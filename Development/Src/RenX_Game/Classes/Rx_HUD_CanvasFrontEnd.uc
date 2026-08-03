/**
 * Native front-end shell.  This intentionally lives on the HUD instead of in
 * a movie player: the front-end map has a normal Rx_HUD and therefore gets
 * the same cursor and input path as the canvas purchase terminal.
 */
class Rx_HUD_CanvasFrontEnd extends Rx_Hud_Component;

enum EFrontEndPage
{
	FEP_Home,
	FEP_Skirmish,
	FEP_Multiplayer,
	FEP_Settings,
	FEP_Extras,
	FEP_Exit
};

var EFrontEndPage CurrentPage;
var int SelectedItem;
var string AddressText;
var string StatusText;
var float StatusExpireTime;
var bool bAddressFocused;
var bool bCursorInitialized;
var Rx_HUD_CanvasSettings SettingsMenu;
var Rx_HUD_CanvasMultiplayer MultiplayerMenu;
var Color AccentColor;
var Color PanelColor;
var Color TextColor;
var Color MutedTextColor;

function Update(float DeltaTime, Rx_HUD HUD)
{
	Super.Update(DeltaTime, HUD);
	Rx_PlayerInput(Rx_Controller(HUD.PlayerOwner).PlayerInput).setRenxHudSize(Canvas.SizeX, Canvas.SizeY);
	if(!bCursorInitialized)
	{
		Rx_PlayerInput(Rx_Controller(HUD.PlayerOwner).PlayerInput).CenterCursor();
		bCursorInitialized = true;
	}
	if(CurrentPage == FEP_Settings)
	{
		if(SettingsMenu == None) SettingsMenu = new class'Rx_HUD_CanvasSettings';
		SettingsMenu.Update(DeltaTime,HUD);
	}
	else if(CurrentPage == FEP_Multiplayer)
	{
		if(MultiplayerMenu == None) MultiplayerMenu = new class'Rx_HUD_CanvasMultiplayer';
		MultiplayerMenu.Update(DeltaTime,HUD);
	}
	if(StatusExpireTime > 0 && HUD.WorldInfo.TimeSeconds > StatusExpireTime)
		StatusText = "";
}

function Draw()
{
	local float Scale, PanelX, PanelY, PanelW, PanelH;

	if(Canvas == None)
		return;
	Scale = FClamp(Canvas.SizeY / 900.0, 0.78, 1.45);
	PanelW = 660 * Scale;
	PanelH = 475 * Scale;
	if(CurrentPage == FEP_Settings)
	{
		PanelW = 950 * Scale;
		PanelH = 640 * Scale;
	}
	else if(CurrentPage == FEP_Multiplayer)
	{
		PanelW = 1100 * Scale;
		PanelH = 650 * Scale;
	}
	PanelX = (Canvas.SizeX - PanelW) * 0.5;
	PanelY = (Canvas.SizeY - PanelH) * 0.5;

	Canvas.SetDrawColor(0, 0, 0, 180);
	Canvas.SetPos(0, 0);
	Canvas.DrawRect(Canvas.SizeX, Canvas.SizeY);
	Canvas.SetDrawColor(PanelColor.R, PanelColor.G, PanelColor.B, PanelColor.A);
	Canvas.SetPos(PanelX, PanelY);
	Canvas.DrawRect(PanelW, PanelH);
	Canvas.SetDrawColor(AccentColor.R, AccentColor.G, AccentColor.B, AccentColor.A);
	Canvas.SetPos(PanelX, PanelY);
	Canvas.DrawRect(PanelW, 4 * Scale);

	DrawTextAt("RENEGADE X", PanelX + 34 * Scale, PanelY + 27 * Scale, AccentColor, 1.50 * Scale);
	DrawTextAt(PageTitle(), PanelX + 34 * Scale, PanelY + 78 * Scale, TextColor, 1.05 * Scale);
	DrawPage(PanelX + 34 * Scale, PanelY + 120 * Scale, PanelW - 68 * Scale, Scale);
	if(StatusText != "")
		DrawTextAt(StatusText, PanelX + 42 * Scale, PanelY + PanelH - 52 * Scale, AccentColor, 0.55 * Scale);
	DrawTextAt("UP/DOWN OR MOUSE TO SELECT  •  ENTER TO CONFIRM  •  ESC TO GO BACK", PanelX + 42 * Scale, PanelY + PanelH - 32 * Scale, MutedTextColor, 0.60 * Scale);
	DrawCursor();
}

function DrawCursor()
{
	Canvas.SetDrawColor(AccentColor.R, AccentColor.G, AccentColor.B, 255);
	Canvas.SetPos(MousePosition.X - 2, MousePosition.Y - 8);
	Canvas.DrawRect(4, 16);
	Canvas.SetPos(MousePosition.X - 8, MousePosition.Y - 2);
	Canvas.DrawRect(16, 4);
}

function DrawPage(float X, float Y, float W, float Scale)
{
	local array<string> Items;
	local array<string> Descriptions;
	local int i;

	if(CurrentPage == FEP_Settings)
	{
		SettingsMenu.RenderSettings(X,Y,W,475*Scale,Scale);
		return;
	}
	if(CurrentPage == FEP_Multiplayer)
	{
		MultiplayerMenu.RenderBrowser(X,Y,W,475*Scale,Scale);
		return;
	}
	GetPageItems(Items, Descriptions);
	for(i = 0; i < Items.Length; ++i)
		DrawItem(Items[i], Descriptions[i], X, Y + i * 60 * Scale, W, Scale, i == SelectedItem);
}

function DrawItem(string Label, string Description, float X, float Y, float W, float Scale, bool bSelected)
{
	if(bSelected)
	{
		Canvas.SetDrawColor(AccentColor.R, AccentColor.G, AccentColor.B, 70);
		Canvas.SetPos(X, Y);
		Canvas.DrawRect(W, 51 * Scale);
		Canvas.SetDrawColor(AccentColor.R, AccentColor.G, AccentColor.B, 255);
		Canvas.SetPos(X, Y);
		Canvas.DrawRect(5 * Scale, 51 * Scale);
	}
	DrawTextAt(Label, X + 18 * Scale, Y + 5 * Scale, bSelected ? AccentColor : TextColor, 1.10 * Scale);
	DrawTextAt(Description, X + 18 * Scale, Y + 32 * Scale, MutedTextColor, 0.64 * Scale);
}

function DrawTextAt(string Text, float X, float Y, Color DrawColor, float Scale)
{
	Canvas.SetDrawColor(DrawColor.R, DrawColor.G, DrawColor.B, DrawColor.A);
	Canvas.SetPos(X, Y);
	Canvas.DrawText(Text, false, Scale, Scale);
}

function string PageTitle()
{
	switch(CurrentPage)
	{
		case FEP_Skirmish: return "SKIRMISH";
		case FEP_Multiplayer: return "MULTIPLAYER";
		case FEP_Settings: return "SETTINGS";
		case FEP_Extras: return "EXTRAS";
		case FEP_Exit: return "EXIT GAME";
	}
	return "MAIN MENU";
}

function GetPageItems(out array<string> Items, out array<string> Descriptions)
{
	switch(CurrentPage)
	{
		case FEP_Home:
			Items.AddItem("SKIRMISH"); Descriptions.AddItem("Fight offline with and against bots");
			Items.AddItem("MULTIPLAYER"); Descriptions.AddItem("Join a server by address");
			Items.AddItem("SETTINGS"); Descriptions.AddItem("Display and HUD options");
			Items.AddItem("EXTRAS"); Descriptions.AddItem("Game information");
			Items.AddItem("EXIT"); Descriptions.AddItem("Close Renegade X");
			break;
		case FEP_Skirmish:
			Items.AddItem("START CNC-FIELD"); Descriptions.AddItem("Standard match: 4 GDI bots vs 5 Nod bots");
			Items.AddItem("BACK"); Descriptions.AddItem("Return to main menu");
			break;
		case FEP_Extras:
			Items.AddItem("ABOUT RENEGADE X"); Descriptions.AddItem("Renegade X is a free, standalone Unreal Engine 3 game");
			Items.AddItem("BACK"); Descriptions.AddItem("Return to main menu");
			break;
		case FEP_Exit:
			Items.AddItem("YES, EXIT GAME"); Descriptions.AddItem("Close the game");
			Items.AddItem("CANCEL"); Descriptions.AddItem("Return to main menu");
			break;
	}
}

function ActivateSelection()
{
	switch(CurrentPage)
	{
		case FEP_Home:
			CurrentPage = EFrontEndPage(SelectedItem + 1);
			break;
		case FEP_Skirmish:
			if(SelectedItem == 0)
				ConsoleCommand("open CNC-Field?Team=0?Numplay=9?GDIBotCount=4?NODBotCount=5");
			else GoHome();
			break;
		case FEP_Extras:
			if(SelectedItem == 0) SetStatus("Visit renegadex.gg for news and support.");
			else GoHome();
			break;
		case FEP_Exit:
			if(SelectedItem == 0) ConsoleCommand("exit"); else GoHome();
			break;
	}
	SelectedItem = 0;
}

function GoHome()
{
	CurrentPage = FEP_Home;
	SelectedItem = 0;
	bAddressFocused = false;
}

function SetStatus(string Message)
{
	StatusText = Message;
	StatusExpireTime = RenxHud.WorldInfo.TimeSeconds + 5.0;
}

function OnKeyPress(name Key)
{
	local string KeyText;
	local array<string> Items, Descriptions;
	KeyText = Caps(string(Key));
	if(CurrentPage == FEP_Settings)
	{
		if(KeyText == "ESCAPE" || KeyText == "BACKSPACE") GoHome();
		else SettingsMenu.OnKeyPress(Key);
		return;
	}
	if(CurrentPage == FEP_Multiplayer)
	{
		if(KeyText == "ESCAPE") GoHome();
		else MultiplayerMenu.OnKeyPress(Key);
		return;
	}
	GetPageItems(Items, Descriptions);
	if(KeyText == "UP" || KeyText == "W") SelectedItem = (SelectedItem + Items.Length - 1) % Items.Length;
	else if(KeyText == "DOWN" || KeyText == "S") SelectedItem = (SelectedItem + 1) % Items.Length;
	else if(KeyText == "ENTER" || KeyText == "SPACEBAR") ActivateSelection();
	else if(KeyText == "ESCAPE") GoHome();
}

function AppendAddressKey(name Key, string KeyText)
{
	if(Len(KeyText) == 1 && InStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-:", KeyText) >= 0)
		AddressText $= KeyText;
	else if(Key == 'Zero') AddressText $= "0";
	else if(Key == 'One') AddressText $= "1";
	else if(Key == 'Two') AddressText $= "2";
	else if(Key == 'Three') AddressText $= "3";
	else if(Key == 'Four') AddressText $= "4";
	else if(Key == 'Five') AddressText $= "5";
	else if(Key == 'Six') AddressText $= "6";
	else if(Key == 'Seven') AddressText $= "7";
	else if(Key == 'Eight') AddressText $= "8";
	else if(Key == 'Nine') AddressText $= "9";
	else if(Key == 'Period' || Key == 'Decimal') AddressText $= ".";
	else if(Key == 'Colon') AddressText $= ":";
	else if(Key == 'Subtract' || Key == 'Hyphen') AddressText $= "-";
}

function checkForLeftClick(int MouseX, int MouseY)
{
	local float Scale, PanelX, PanelY, PanelW, ItemY, AddressY;
	local array<string> Items, Descriptions;
	local int i;
	Scale = FClamp(Canvas.SizeY / 900.0, 0.70, 1.35);
	PanelW = CurrentPage == FEP_Settings ? 950 * Scale : (CurrentPage == FEP_Multiplayer ? 1100 * Scale : 660 * Scale);
	PanelX = (Canvas.SizeX - PanelW) * 0.5;
	PanelY = (Canvas.SizeY - (CurrentPage == FEP_Settings ? 640 : (CurrentPage == FEP_Multiplayer ? 650 : 475)) * Scale) * 0.5;
	if(CurrentPage == FEP_Settings)
	{
		SettingsMenu.HandleLeftClick(MouseX,MouseY,PanelX+34*Scale,PanelY+120*Scale,PanelW-68*Scale,475*Scale,Scale);
		return;
	}
	if(CurrentPage == FEP_Multiplayer)
	{
		if(MultiplayerMenu.HandleLeftClick(MouseX,MouseY,PanelX+34*Scale,PanelY+120*Scale,PanelW-68*Scale,475*Scale,Scale)) return;
		/* Back is intentionally handled here because it leaves this component. */
		if(MouseY >= PanelY+120*Scale+400*Scale && MouseY <= PanelY+120*Scale+442*Scale
			&& MouseX >= PanelX+34*Scale+279*Scale && MouseX <= PanelX+34*Scale+389*Scale) GoHome();
		return;
	}
	GetPageItems(Items, Descriptions);
	AddressY = PanelY + 120 * Scale + 248 * Scale;
	if(CurrentPage == FEP_Multiplayer && MouseX >= PanelX + 42 * Scale
		&& MouseX <= PanelX + PanelW - 42 * Scale && MouseY >= AddressY
		&& MouseY <= AddressY + 42 * Scale)
	{
		bAddressFocused = true;
		return;
	}
	for(i = 0; i < Items.Length; ++i)
	{
		ItemY = PanelY + 120 * Scale + i * 60 * Scale;
		if(MouseY >= ItemY && MouseY <= ItemY + 51 * Scale)
		{
			SelectedItem = i;
			ActivateSelection();
			return;
		}
	}
}

DefaultProperties
{
	CurrentPage=FEP_Home
	AccentColor=(R=88,G=214,B=217,A=255)
	PanelColor=(R=5,G=14,B=20,A=240)
	TextColor=(R=232,G=240,B=241,A=255)
	MutedTextColor=(R=150,G=172,B=180,A=255)
}
