/** Native replacement for RenXPauseMenu. */
class Rx_HUD_CanvasPauseMenu extends Rx_Hud_Component;

enum EPauseCanvasPage { PCP_Scoreboard, PCP_HowToPlay, PCP_Chat, PCP_Suicide, PCP_ChangeTeams, PCP_Donate, PCP_Settings };
var EPauseCanvasPage CurrentPage;
var Rx_HUD_CanvasSettings SettingsMenu;
var int SelectedPlayer;
var string DonateAmount;
var bool bDonateEntry;
var bool bPrivateChat;
var int SelectedChatPlayer;
var Color AccentColor, TextColor, MutedTextColor, PanelColor;

function Update(float DeltaTime,Rx_HUD HUD)
{
	Super.Update(DeltaTime,HUD);
	if(CurrentPage==PCP_Settings)
	{
		if(SettingsMenu==None) SettingsMenu=new class'Rx_HUD_CanvasSettings';
		SettingsMenu.Update(DeltaTime,HUD);
	}
}

function Draw()
{
	local float S,X,Y,W,H;
	S=FClamp(Canvas.SizeY/1080.0,0.65,1.25); X=110*S; Y=210*S; W=1700*S; H=760*S;
	Canvas.SetDrawColor(0,0,0,165); Canvas.SetPos(0,0); Canvas.DrawRect(Canvas.SizeX,Canvas.SizeY);
	DrawTopTabs(S);
	Canvas.SetDrawColor(PanelColor.R,PanelColor.G,PanelColor.B,225); Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,220); Canvas.SetPos(X,Y); Canvas.DrawRect(W,3*S);
	switch(CurrentPage)
	{
		case PCP_Settings: SettingsMenu.RenderSettings(X+22*S,Y+70*S,W-44*S,H-105*S,S); break;
		case PCP_HowToPlay: DrawHowToPlay(X,Y,W,H,S); break;
		case PCP_Donate: DrawDonate(X,Y,W,H,S); break;
		case PCP_Chat: DrawChat(X,Y,W,H,S); break;
		case PCP_Scoreboard: DrawScoreboard(X,Y,W,H,S); break;
		default: DrawPlaceholder(X,Y,W,H,S); break;
	}
	DrawBottomTabs(S);
	DrawCursor();
}

function DrawTopTabs(float S)
{
	local array<string> Tabs; local int i;
	Tabs.AddItem("SCOREBOARD"); Tabs.AddItem("HOW TO PLAY"); Tabs.AddItem("CHAT"); Tabs.AddItem("SUICIDE"); Tabs.AddItem("CHANGE TEAMS"); Tabs.AddItem("DONATE CREDITS");
	for(i=0;i<Tabs.Length;i++) DrawTextAt(Tabs[i],75*S+i*250*S,65*S,i==CurrentPage?AccentColor:TextColor,0.48*S);
}

function DrawBottomTabs(float S)
{
	DrawTextAt("SETTINGS",75*S,995*S,CurrentPage==PCP_Settings?AccentColor:TextColor,0.62*S);
	DrawTextAt("RESUME",1530*S,995*S,TextColor,0.62*S);
	DrawTextAt("EXIT",1750*S,995*S,TextColor,0.62*S);
}

function DrawHowToPlay(float X,float Y,float W,float H,float S)
{
	DrawTextAt("TO COMMAND AND CONQUER",X+W*0.5,Y+45*S,TextColor,0.78*S);
	DrawBox("THE BASE","Protect your refinery and power plant. Barracks and factories provide infantry and vehicles; base defences protect the team.",X+55*S,Y+115*S,480*S,235*S,S);
	DrawBox("THE TEAMS","GDI and Nod battle to destroy the opposing base. Capture the field, protect teammates, and use every credit wisely.",X+610*S,Y+115*S,480*S,235*S,S);
	DrawBox("ECONOMY","Keep the Harvester alive, capture Tiberium Silos, destroy enemy units and structures, and repair friendly assets.",X+1165*S,Y+115*S,480*S,235*S,S);
	DrawBox("TERMINALS","Use Purchase Terminals to buy characters, weapons, vehicles, equipment and deployables.",X+55*S,Y+405*S,480*S,235*S,S);
	DrawBox("SPECIAL CHARACTERS","Engineers repair. Technicians carry advanced explosives. Stealth Black Hands excel at ambushes.",X+610*S,Y+405*S,480*S,235*S,S);
	DrawBox("SPECIAL ITEMS","Airstrikes, repair guns, C4, superweapon beacons and proximity mines can turn a match.",X+1165*S,Y+405*S,480*S,235*S,S);
}

function DrawDonate(float X,float Y,float W,float H,float S)
{
	local PlayerReplicationInfo PRI; local int Row;
	DrawTextAt("DONATE CREDITS TO OTHERS",X+W*0.5,Y+45*S,TextColor,0.70*S);
	DrawBox("#     PLAYER                                      CREDITS","",X+470*S,Y+95*S,470*S,550*S,S);
	Row=0;
	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
	{
		if(Rx_PRI(PRI)==None || PRI==RenxHud.PlayerOwner.PlayerReplicationInfo || PRI.bBot || !RenxHud.WorldInfo.GRI.OnSameTeam(RenxHud.PlayerOwner.PlayerReplicationInfo,PRI)) continue;
		DrawTextAt((Row==SelectedPlayer?"> ":"  ") $ PRI.PlayerName,X+495*S,Y+(145+Row*42)*S,Row==SelectedPlayer?AccentColor:TextColor,0.48*S);
		DrawTextAt(string(int(Rx_PRI(PRI).GetCredits())),X+850*S,Y+(145+Row*42)*S,MutedTextColor,0.48*S); Row++;
	}
	DrawBox("YOUR CREDITS: " $ int(Rx_PRI(RenxHud.PlayerOwner.PlayerReplicationInfo).GetCredits()),"Amount: " $ (DonateAmount==""?"0":DonateAmount),X+1040*S,Y+230*S,430*S,260*S,S);
	DrawTextAt("DONATE TO PLAYER",X+1090*S,Y+365*S,TextColor,0.55*S);
	DrawTextAt("DONATE TO TEAM",X+1090*S,Y+415*S,TextColor,0.55*S);
	DrawTextAt("DONATE ALL TO TEAM",X+1090*S,Y+465*S,TextColor,0.55*S);
}

function DrawScoreboard(float X,float Y,float W,float H,float S)
{
	local PlayerReplicationInfo PRI; local int Row;
	Row=0;
	DrawTextAt("SCOREBOARD",X+45*S,Y+45*S,TextColor,0.75*S);
	DrawTextAt("PLAYER",X+100*S,Y+105*S,MutedTextColor,0.50*S); DrawTextAt("SCORE",X+W-250*S,Y+105*S,MutedTextColor,0.50*S);
	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI) { DrawTextAt(PRI.PlayerName,X+100*S,Y+(150+Row*38)*S,TextColor,0.47*S); DrawTextAt(string(PRI.Score),X+W-250*S,Y+(150+Row*38)*S,MutedTextColor,0.47*S); Row++; }
}

function DrawChat(float X,float Y,float W,float H,float S)
{
	local int i, Row, Start;
	local array<string> PlayerNames;
	PopulateChatPlayers(PlayerNames);
	DrawTextAt("ALL",X+35*S,Y+38*S,bPrivateChat?TextColor:AccentColor,0.58*S);
	DrawTextAt("PRIVATE",X+155*S,Y+38*S,bPrivateChat?AccentColor:TextColor,0.58*S);
	DrawBox("CHAT HISTORY","",X+30*S,Y+85*S,W-440*S,H-145*S,S);
	DrawBox("PLAYERS","Select a player to see private messages",X+W-365*S,Y+85*S,335*S,H-145*S,S);
	for(i=0;i<RenxHud.CanvasChatHistory.Length;i++)
	{
		if(!ShouldDrawChatEntry(RenxHud.CanvasChatHistory[i],PlayerNames)) continue;
		Row++;
	}
	Start=Max(0,Row-17); Row=0;
	for(i=0;i<RenxHud.CanvasChatHistory.Length;i++)
	{
		if(!ShouldDrawChatEntry(RenxHud.CanvasChatHistory[i],PlayerNames)) continue;
		if(Row>=Start) DrawTextAt(RenxHud.CanvasChatHistory[i].Text,X+52*S,Y+(125+(Row-Start)*31)*S,RenxHud.CanvasChatHistory[i].TextColor,0.42*S);
		Row++;
	}
	for(i=0;i<PlayerNames.Length;i++)
		DrawTextAt((i==SelectedChatPlayer?"> ":"  ")$PlayerNames[i],X+W-340*S,Y+(145+i*35)*S,i==SelectedChatPlayer?AccentColor:TextColor,0.45*S);
	DrawTextAt(bPrivateChat ? "ENTER: MESSAGE SELECTED PLAYER" : "ENTER: START ALL CHAT",X+35*S,Y+H-32*S,MutedTextColor,0.38*S);
}

function bool ShouldDrawChatEntry(Rx_HUD.CanvasChatLogEntry Entry,array<string> PlayerNames)
{
	if(!bPrivateChat)
		return !Entry.bPrivate;
	if(SelectedChatPlayer < 0 || SelectedChatPlayer >= PlayerNames.Length)
		return false;
	return Entry.bPrivate && Entry.SpeakerName ~= PlayerNames[SelectedChatPlayer];
}

function PopulateChatPlayers(out array<string> PlayerNames)
{
	local PlayerReplicationInfo PRI;
	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
		if(PRI != RenxHud.PlayerOwner.PlayerReplicationInfo && !PRI.bBot && PlayerNames.Find(PRI.PlayerName) < 0)
			PlayerNames.AddItem(PRI.PlayerName);
}

function DrawPlaceholder(float X,float Y,float W,float H,float S)
{
	DrawTextAt("THIS CANVAS VIEW IS READY FOR ITS GAMEPLAY DATA SOURCE",X+W*0.5,Y+H*0.45,MutedTextColor,0.55*S);
}

function DrawBox(string Title,string Body,float X,float Y,float W,float H,float S)
{
	Canvas.SetDrawColor(12,30,42,205); Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	DrawTextAt(Title,X+20*S,Y+20*S,TextColor,0.55*S); DrawTextAt(Body,X+20*S,Y+65*S,MutedTextColor,0.38*S);
}
function DrawTextAt(string T,float X,float Y,Color C,float S) { Canvas.SetDrawColor(C.R,C.G,C.B,C.A); Canvas.SetPos(X,Y); Canvas.DrawText(T,false,S,S); }
function DrawCursor() { Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,255); Canvas.SetPos(MousePosition.X-2,MousePosition.Y-8); Canvas.DrawRect(4,16); Canvas.SetPos(MousePosition.X-8,MousePosition.Y-2); Canvas.DrawRect(16,4); }

function OnKeyPress(name Key)
{
	local string K; K=Caps(string(Key));
	// Escape is bound to Rx_HUD.TogglePauseMenu. Do not close here too: that
	// would close and immediately re-open the Canvas pause screen.
	if(K=="ESCAPE") return;
	if(CurrentPage==PCP_Settings) { SettingsMenu.OnKeyPress(Key); return; }
	if(CurrentPage==PCP_Chat)
	{
		if(K=="TAB") { bPrivateChat=!bPrivateChat; return; }
		if(K=="UP" && bPrivateChat) { SelectedChatPlayer=Max(0,SelectedChatPlayer-1); return; }
		if(K=="DOWN" && bPrivateChat) { SelectedChatPlayer++; return; }
		if(K=="ENTER") StartChat();
		return;
	}
	if(CurrentPage==PCP_Donate && bDonateEntry) { if(K=="BACKSPACE") DonateAmount=Left(DonateAmount,Len(DonateAmount)-1); else if(K=="ENTER") bDonateEntry=false; else AppendDigit(Key); return; }
	if(K=="UP" && CurrentPage==PCP_Donate) SelectedPlayer=Max(0,SelectedPlayer-1);
	if(K=="DOWN" && CurrentPage==PCP_Donate) SelectedPlayer++;
}
function AppendDigit(name Key) { switch(Key) { case 'Zero':DonateAmount$="0";break; case 'One':DonateAmount$="1";break; case 'Two':DonateAmount$="2";break; case 'Three':DonateAmount$="3";break; case 'Four':DonateAmount$="4";break; case 'Five':DonateAmount$="5";break; case 'Six':DonateAmount$="6";break; case 'Seven':DonateAmount$="7";break; case 'Eight':DonateAmount$="8";break; case 'Nine':DonateAmount$="9";break; } }
function HandleLeftClick(int MX,int MY)
{
	local float S; S=FClamp(Canvas.SizeY/1080.0,0.65,1.25);
	if(MY<130*S) { SelectTopTab(int(MX/(250*S))); return; }
	if(MY>930*S) { if(MX<350*S) CurrentPage=PCP_Settings; else if(MX>1480*S && MX<1730*S) RenxHud.CloseCanvasPauseMenu(); else if(MX>1730*S) ConsoleCommand("disconnect"); return; }
	if(CurrentPage==PCP_Settings) { SettingsMenu.HandleLeftClick(MX,MY,132*S,280*S,1656*S,655*S,S); return; }
	if(CurrentPage==PCP_Chat)
	{
		if(MY>260*S && MY<350*S) { bPrivateChat=MX>260*S; return; }
		if(MX>1450*S) SelectedChatPlayer=Max(0,int((MY-350*S)/(35*S)));
		return;
	}
	if(CurrentPage==PCP_Donate && MX>1040*S)
	{
		if(MY>455*S && MY<555*S) bDonateEntry=true;
		else if(MY>=555*S && MY<610*S) DonateToSelectedPlayer();
		else if(MY>=610*S && MY<660*S) Rx_Controller(RenxHud.PlayerOwner).TeamDonate(int(DonateAmount));
		else if(MY>=660*S && MY<720*S) Rx_Controller(RenxHud.PlayerOwner).TeamDonate(int(Rx_PRI(RenxHud.PlayerOwner.PlayerReplicationInfo).GetCredits()));
	}
}
function SelectTopTab(int Tab)
{
	if(Tab==3) { ConsoleCommand("suicide"); RenxHud.CloseCanvasPauseMenu(); return; }
	if(Tab==4) { ConsoleCommand("changeteam"); RenxHud.CloseCanvasPauseMenu(); return; }
	if(Tab>=0 && Tab<=5) CurrentPage=EPauseCanvasPage(Tab);
}
function StartChat()
{
	local array<string> PlayerNames;
	if(bPrivateChat)
	{
		PopulateChatPlayers(PlayerNames);
		if(SelectedChatPlayer < PlayerNames.Length)
			Rx_Controller(RenxHud.PlayerOwner).StartTyping("PrivateSay " $ PlayerNames[SelectedChatPlayer] $ " ");
	}
	else Rx_Controller(RenxHud.PlayerOwner).StartTyping("Say ");
	RenxHud.CloseCanvasPauseMenu();
}
function DonateToSelectedPlayer()
{
	local PlayerReplicationInfo PRI; local int Row;
	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
	{
		if(Rx_PRI(PRI)==None || PRI==RenxHud.PlayerOwner.PlayerReplicationInfo || PRI.bBot || !RenxHud.WorldInfo.GRI.OnSameTeam(RenxHud.PlayerOwner.PlayerReplicationInfo,PRI)) continue;
		if(Row==SelectedPlayer) { Rx_Controller(RenxHud.PlayerOwner).Donate(PRI.PlayerName,int(DonateAmount)); return; }
		Row++;
	}
}

DefaultProperties
{
	bEnabled=false
	CurrentPage=PCP_HowToPlay
	AccentColor=(R=240,G=35,B=30,A=255)
	TextColor=(R=220,G=240,B=245,A=255)
	MutedTextColor=(R=135,G=190,B=210,A=255)
	PanelColor=(R=4,G=15,B=25,A=240)
}
