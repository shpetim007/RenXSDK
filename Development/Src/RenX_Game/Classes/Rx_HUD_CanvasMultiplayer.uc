/** Canvas replacement for the Scaleform multiplayer server browser. */
class Rx_HUD_CanvasMultiplayer extends Rx_Hud_Component;

var Rx_Game RxGame;
var array<int> VisibleServerIndices;
var int SelectedServer;
var int ServerScroll;
var string AddressText;
var bool bAddressFocused;
var string PasswordText;
var string PendingAddress;
var bool bPasswordFocused;
var bool bRequestedServers;
var string StatusText;
var float StatusExpireTime;
var Color AccentColor, TextColor, MutedTextColor;

function Update(float DeltaTime, Rx_HUD HUD)
{
	Super.Update(DeltaTime, HUD);
	if(RxGame == None)
	{
		RxGame = Rx_Game(HUD.WorldInfo.Game);
		if(RxGame != None)
		{
			RxGame.NotifyPingFinished = OnPingFinished;
			RxGame.NotifyServerListUpdate = OnNotifyFromServer;
		}
	}
	RebuildVisibleList();
	if(!bRequestedServers && RxGame != None)
		RefreshServers();
	if(StatusExpireTime > 0 && HUD.WorldInfo.TimeSeconds > StatusExpireTime)
		StatusText = "";
}

function RebuildVisibleList()
{
	local int i;
	VisibleServerIndices.Length = 0;
	if(RxGame == None) return;
	for(i = 0; i < RxGame.ListServers.Length; ++i)
		if(!RxGame.ListServers[i].isLAN)
			VisibleServerIndices.AddItem(i);
	if(SelectedServer >= VisibleServerIndices.Length)
		SelectedServer = Max(0, VisibleServerIndices.Length - 1);
	ServerScroll = Clamp(ServerScroll, 0, Max(0, VisibleServerIndices.Length - 6));
}

function RefreshServers()
{
	if(RxGame == None) return;
	RxGame.ListServers.Length = 0;
	`RxEngineObject.DllCore.clear_pings();
	bRequestedServers = true;
	SelectedServer = 0;
	ServerScroll = 0;
	SetStatus("Refreshing server list...");
	if(RxGame.ServiceBrowser != None)
		RxGame.ServiceBrowser.GetFromServer();
	else
		SetStatus("Server browser is unavailable.");
}

function OnPingFinished()
{
	RebuildVisibleList();
	SetStatus(string(VisibleServerIndices.Length) $ " internet servers found.");
}

function OnNotifyFromServer()
{
	RebuildVisibleList();
	`RxGameObject.StartPings();
	SetStatus(string(VisibleServerIndices.Length) $ " internet servers found. Pinging...");
}

function RenderBrowser(float X, float Y, float W, float H, float Scale)
{
	local float ListW, DetailsX, RowY, RowH, BottomY;
	local int i, RawIndex, LastRow;

	ListW = W * 0.60;
	DetailsX = X + ListW + 16 * Scale;
	RowH = 48 * Scale;
	DrawTextAt("INTERNET SERVERS", X, Y, AccentColor, 0.90 * Scale);
	DrawTextAt("MAP", X + 8 * Scale, Y + 30 * Scale, MutedTextColor, 0.55 * Scale);
	DrawTextAt("SERVER", X + 130 * Scale, Y + 30 * Scale, MutedTextColor, 0.55 * Scale);
	DrawTextAt("PLAYERS", X + ListW - 118 * Scale, Y + 30 * Scale, MutedTextColor, 0.55 * Scale);
	DrawTextAt("PING", X + ListW - 48 * Scale, Y + 30 * Scale, MutedTextColor, 0.55 * Scale);
	Canvas.SetDrawColor(18,31,39,235);
	Canvas.SetPos(X,Y + 45 * Scale);
	Canvas.DrawRect(ListW,H - 130 * Scale);
	LastRow = Min(VisibleServerIndices.Length, ServerScroll + 6);
	for(i = ServerScroll; i < LastRow; ++i)
	{
		RawIndex = VisibleServerIndices[i];
		RowY = Y + 48 * Scale + (i - ServerScroll) * RowH;
		DrawServerRow(RawIndex, X, RowY, ListW, RowH, Scale, i == SelectedServer);
	}
	if(VisibleServerIndices.Length == 0)
		DrawTextAt("No servers listed yet. Press REFRESH to try again.", X + 14 * Scale, Y + 66 * Scale, MutedTextColor, 0.62 * Scale);

	DrawDetails(DetailsX,Y,W-ListW-16*Scale,H-130*Scale,Scale);
	BottomY = Y + H - 75 * Scale;
	DrawButton("JOIN", X, BottomY, 120 * Scale, 42 * Scale, Scale, false);
	DrawButton("REFRESH", X + 132 * Scale, BottomY, 135 * Scale, 42 * Scale, Scale, false);
	DrawButton("BACK", X + 279 * Scale, BottomY, 110 * Scale, 42 * Scale, Scale, false);
	DrawTextAt("DIRECT ADDRESS", X + 415 * Scale, BottomY - 18 * Scale, MutedTextColor, 0.52 * Scale);
	Canvas.SetDrawColor(18,31,39,255);
	Canvas.SetPos(X + 415 * Scale, BottomY);
	Canvas.DrawRect(W - 415 * Scale,42 * Scale);
	DrawTextAt(AddressText == "" ? "IP or hostname:port" : AddressText, X + 426 * Scale, BottomY + 8 * Scale, bAddressFocused ? AccentColor : TextColor, 0.70 * Scale);
	if(StatusText != "") DrawTextAt(StatusText,X,BottomY + 53 * Scale,AccentColor,0.56*Scale);
	if(bPasswordFocused) RenderPasswordPrompt(X,Y,W,H,Scale);
}

function RenderPasswordPrompt(float X, float Y, float W, float H, float Scale)
{
	local float PX, PY, PW, PH;
	PX=X+W*0.22; PY=Y+H*0.27; PW=W*0.56; PH=155*Scale;
	Canvas.SetDrawColor(0,0,0,165); Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(5,14,20,255); Canvas.SetPos(PX,PY); Canvas.DrawRect(PW,PH);
	Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,255); Canvas.SetPos(PX,PY); Canvas.DrawRect(PW,3*Scale);
	DrawTextAt("SERVER PASSWORD",PX+18*Scale,PY+18*Scale,AccentColor,0.70*Scale);
	DrawTextAt("Enter the password for the selected server.",PX+18*Scale,PY+49*Scale,MutedTextColor,0.62*Scale);
	Canvas.SetDrawColor(18,31,39,255); Canvas.SetPos(PX+18*Scale,PY+76*Scale); Canvas.DrawRect(PW-36*Scale,33*Scale);
	DrawTextAt(PasswordText == "" ? "Password" : PasswordMask(),PX+28*Scale,PY+83*Scale,TextColor,0.50*Scale);
	DrawTextAt("ENTER TO JOIN  •  ESC TO CANCEL",PX+18*Scale,PY+122*Scale,MutedTextColor,0.56*Scale);
}

function DrawServerRow(int RawIndex, float X, float Y, float W, float H, float Scale, bool bSelected)
{
	local Rx_Game.ServerInfo Server;
	Server = RxGame.ListServers[RawIndex];
	if(bSelected)
	{
		Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,70);
		Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
		Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,255);
		Canvas.SetPos(X,Y); Canvas.DrawRect(4*Scale,H);
	}
	DrawTextAt(GetMapName(Server.Mapname),X+8*Scale,Y+14*Scale,bSelected?AccentColor:TextColor,0.68*Scale);
	DrawWrappedServerName((Server.bPassword ? "* " : "") $ Server.NamePrefix @ Server.ServerName,X+130*Scale,Y+5*Scale,W-255*Scale,TextColor,0.70*Scale);
	DrawTextAt(string(Server.NumPlayers)$"/"$string(Server.MaxPlayers),X+W-118*Scale,Y+7*Scale,TextColor,0.64*Scale);
	DrawTextAt(Server.Ping < 0 ? "..." : string(Server.Ping),X+W-45*Scale,Y+7*Scale,Server.Ping > 180 ? MutedTextColor : AccentColor,0.64*Scale);
}

function DrawWrappedServerName(string Text,float X,float Y,float MaxWidth,Color DrawColor,float Scale)
{
	local array<string> Words;
	local string LineOne, LineTwo, Candidate;
	local int i;
	LineOne=""; LineTwo="";
	Words=SplitString(Text," ",false);
	for(i=0;i<Words.Length;i++)
	{
		Candidate=LineOne=="" ? Words[i] : LineOne@Words[i];
		if(TextFits(Candidate,MaxWidth,Scale) || LineOne=="") LineOne=Candidate;
		else { LineTwo=LineTwo=="" ? Words[i] : LineTwo@Words[i]; }
	}
	if(!TextFits(LineOne,MaxWidth,Scale)) LineOne=FitText(LineOne,MaxWidth,Scale);
	if(LineTwo!="") LineTwo=FitText(LineTwo,MaxWidth,Scale);
	DrawTextAt(LineOne,X,Y,DrawColor,Scale);
	if(LineTwo!="") DrawTextAt(LineTwo,X,Y+18*Scale,DrawColor,Scale);
}

function bool TextFits(string Text,float MaxWidth,float Scale)
{
	local float TextWidth, TextHeight;
	Canvas.TextSize(Text,TextWidth,TextHeight,Scale,Scale);
	return TextWidth<=MaxWidth;
}

function string FitText(string Text,float MaxWidth,float Scale)
{
	local string Result;
	local int i;
	Result="";
	for(i=0;i<Len(Text);i++)
	{
		if(!TextFits(Result$Mid(Text,i,1)$"...",MaxWidth,Scale)) break;
		Result $= Mid(Text,i,1);
	}
	return Result $ (Len(Result)<Len(Text) ? "..." : "");
}

function DrawDetails(float X, float Y, float W, float H, float Scale)
{
	local Rx_Game.ServerInfo Server;
	if(VisibleServerIndices.Length == 0)
	{
		DrawTextAt("SERVER DETAILS",X,Y,AccentColor,0.90*Scale);
		DrawTextAt("Select a server to view match details.",X,Y+38*Scale,MutedTextColor,0.64*Scale);
		return;
	}
	Server = RxGame.ListServers[VisibleServerIndices[SelectedServer]];
	DrawTextAt("SERVER DETAILS",X,Y,AccentColor,0.90*Scale);
	DrawTextAt(Server.NamePrefix @ Server.ServerName,X,Y+38*Scale,TextColor,0.78*Scale);
	DrawDetail("Map",GetMapName(Server.Mapname),X,Y+72*Scale,Scale);
	DrawDetail("Players",string(Server.NumPlayers)$" / "$string(Server.MaxPlayers),X,Y+100*Scale,Scale);
	DrawDetail("Time limit",Server.TimeLimit == 0 ? "Unlimited" : string(Server.TimeLimit)$" minutes",X,Y+128*Scale,Scale);
	DrawDetail("Vehicle limit",string(Server.VehicleLimit),X,Y+156*Scale,Scale);
	DrawDetail("Mine limit",string(Server.MineLimit),X,Y+184*Scale,Scale);
	DrawDetail("Crates",Server.CratesEnabled ? "Enabled" : "Disabled",X,Y+212*Scale,Scale);
	DrawDetail("Ranked",Server.Ranked ? "Yes" : "No",X,Y+240*Scale,Scale);
	DrawDetail("Auto balance",Server.TeamMode == 3 ? "Enabled" : "Disabled",X,Y+268*Scale,Scale);
	DrawDetail("Password",Server.bPassword ? "Required" : "None",X,Y+296*Scale,Scale);
}

function DrawDetail(string Label, string Value, float X, float Y, float Scale)
{
	DrawTextAt(Label$":",X,Y,MutedTextColor,0.62*Scale);
	DrawTextAt(Value,X+120*Scale,Y,TextColor,0.62*Scale);
}

function DrawButton(string Label, float X, float Y, float W, float H, float Scale, bool bSelected)
{
	Canvas.SetDrawColor(bSelected ? AccentColor.R : 18,bSelected ? AccentColor.G : 31,bSelected ? AccentColor.B : 39,bSelected ? 120 : 255);
	Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	DrawTextAt(Label,X+13*Scale,Y+8*Scale,bSelected ? TextColor : AccentColor,0.74*Scale);
}

function DrawTextAt(string Text, float X, float Y, Color DrawColor, float Scale)
{
	Canvas.SetDrawColor(DrawColor.R,DrawColor.G,DrawColor.B,DrawColor.A);
	Canvas.SetPos(X,Y); Canvas.DrawText(Text,false,Scale,Scale);
}

function string GetMapName(string MapName)
{
	local int i;
	if(RxGame != None)
		for(i=0;i<RxGame.MapDataProviderList.Length;++i)
			if(RxGame.MapDataProviderList[i].MapName ~= MapName)
				return RxGame.MapDataProviderList[i].FriendlyName;
	return MapName;
}

function JoinSelectedServer()
{
	local Rx_Game.ServerInfo Server;
	if(VisibleServerIndices.Length == 0) { SetStatus("Select a server first."); return; }
	Server = RxGame.ListServers[VisibleServerIndices[SelectedServer]];
	PendingAddress = Server.ServerIP $ (Server.ServerPort != "" ? ":" $ Server.ServerPort : "");
	if(Server.bPassword) { PasswordText=""; bPasswordFocused=true; return; }
	ConsoleCommand("open " $ PendingAddress);
}

function JoinAddress()
{
	if(AddressText == "") { SetStatus("Type a server address first."); return; }
	ConsoleCommand("open " $ AddressText);
}

function OnKeyPress(name Key)
{
	local string KeyText;
	KeyText = Caps(string(Key));
	if(bPasswordFocused)
	{
		if(KeyText == "ENTER") { if(PasswordText != "") ConsoleCommand("open "$PendingAddress$"?Password="$PasswordText); bPasswordFocused=false; return; }
		if(KeyText == "ESCAPE") { bPasswordFocused=false; return; }
		if(KeyText == "BACKSPACE" && Len(PasswordText)>0) { PasswordText=Left(PasswordText,Len(PasswordText)-1); return; }
		AppendPasswordKey(Key,KeyText); return;
	}
	if(bAddressFocused)
	{
		if(KeyText == "ENTER") { bAddressFocused=false; JoinAddress(); return; }
		if(KeyText == "ESCAPE") { bAddressFocused=false; return; }
		if(KeyText == "BACKSPACE" && Len(AddressText)>0) { AddressText=Left(AddressText,Len(AddressText)-1); return; }
		AppendAddressKey(Key,KeyText); return;
	}
	if(KeyText == "UP" || KeyText == "W") SelectOffset(-1);
	else if(KeyText == "DOWN" || KeyText == "S") SelectOffset(1);
	else if(KeyText == "ENTER") JoinSelectedServer();
	else if(KeyText == "R") RefreshServers();
	else if(KeyText == "I") bAddressFocused=true;
}

function SelectOffset(int Offset)
{
	if(VisibleServerIndices.Length == 0) return;
	SelectedServer = Clamp(SelectedServer+Offset,0,VisibleServerIndices.Length-1);
	if(SelectedServer < ServerScroll) ServerScroll=SelectedServer;
	if(SelectedServer >= ServerScroll+6) ServerScroll=SelectedServer-5;
}

function AppendAddressKey(name Key, string KeyText)
{
	if(Len(KeyText)==1 && InStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-:?=",KeyText)>=0) AddressText $= KeyText;
	else if(Key == 'Zero') AddressText $= "0"; else if(Key == 'One') AddressText $= "1"; else if(Key == 'Two') AddressText $= "2";
	else if(Key == 'Three') AddressText $= "3"; else if(Key == 'Four') AddressText $= "4"; else if(Key == 'Five') AddressText $= "5";
	else if(Key == 'Six') AddressText $= "6"; else if(Key == 'Seven') AddressText $= "7"; else if(Key == 'Eight') AddressText $= "8";
	else if(Key == 'Nine') AddressText $= "9"; else if(Key == 'Period' || Key == 'Decimal') AddressText $= ".";
	else if(Key == 'Colon') AddressText $= ":"; else if(Key == 'Subtract' || Key == 'Hyphen') AddressText $= "-";
}

function AppendPasswordKey(name Key, string KeyText)
{
	if(Len(KeyText)==1 && InStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",KeyText)>=0) PasswordText $= KeyText;
	else if(Key == 'SpaceBar') PasswordText $= " ";
	else if(Key == 'Zero') PasswordText $= "0"; else if(Key == 'One') PasswordText $= "1"; else if(Key == 'Two') PasswordText $= "2";
	else if(Key == 'Three') PasswordText $= "3"; else if(Key == 'Four') PasswordText $= "4"; else if(Key == 'Five') PasswordText $= "5";
	else if(Key == 'Six') PasswordText $= "6"; else if(Key == 'Seven') PasswordText $= "7"; else if(Key == 'Eight') PasswordText $= "8";
	else if(Key == 'Nine') PasswordText $= "9";
}

function string PasswordMask()
{
	local int i;
	local string Result;
	for(i=0;i<Len(PasswordText);++i) Result $= "*";
	return Result;
}

function bool HandleLeftClick(int MouseX, int MouseY, float X, float Y, float W, float H, float Scale)
{
	local float ListW, RowH, BottomY;
	local int Row;
	ListW=W*0.60; RowH=48*Scale; BottomY=Y+H-75*Scale;
	if(bPasswordFocused) return true;
	if(MouseY >= Y+48*Scale && MouseY < Y+48*Scale+6*RowH && MouseX >= X && MouseX <= X+ListW)
	{
		Row = ServerScroll + int((MouseY-(Y+48*Scale))/RowH);
		if(Row < VisibleServerIndices.Length) { SelectedServer=Row; return true; }
	}
	if(MouseY >= BottomY && MouseY <= BottomY+42*Scale)
	{
		if(MouseX >= X && MouseX <= X+120*Scale) { JoinSelectedServer(); return true; }
		if(MouseX >= X+132*Scale && MouseX <= X+267*Scale) { RefreshServers(); return true; }
		if(MouseX >= X+415*Scale && MouseX <= X+W) { bAddressFocused=true; return true; }
	}
	return false;
}

function SetStatus(string Message)
{
	StatusText=Message;
	if(RenxHud != None) StatusExpireTime=RenxHud.WorldInfo.TimeSeconds+5.0;
}

DefaultProperties
{
	AccentColor=(R=88,G=214,B=217,A=255)
	TextColor=(R=232,G=240,B=241,A=255)
	MutedTextColor=(R=150,G=172,B=180,A=255)
}
