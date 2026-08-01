/**
 * Native Canvas replacement for Renegade X's always-on Scaleform HUD movies.
 *
 * This component deliberately owns display state (messages, tips, votes and
 * contextual menus) so the gameplay HUD can run without starting a GFx movie.
 * Full-screen front-end and pause screens remain separate from this component.
 */
class Rx_HUD_CanvasMain extends Rx_Hud_Component
	DependsOn(Rx_GFxHud);

struct CanvasTextRun
{
	var string Text;
	var color TextColor;
};

struct CanvasHUDMessage
{
	var color TextColor;
	var float ExpireTime;
	var byte Channel;
	var array<CanvasTextRun> Runs;
};

struct OverviewCountRow
{
	var string Label;
	var int Count;
};

var array<CanvasHUDMessage> Messages;
var array<MenuOption> MenuOptions;
var array<string> HelpLines;

var string GameplayTip;
var string SubtitleText;
var string VoteText;
var string LoadingText;
var float LoadingProgress;
var float HitMarkerExpireTime;
var float VoteExpireTime;
var int VoteYes;
var int VoteNo;
var int VoteNeeded;
var bool bShowSideMenu;
var bool bShowHelp;
var bool bShowLoading;
var bool bShowOverview;
var bool bShowFullScoreboard;
var bool bHUDTextRenderInfoReady;
var Rx_HUD_CanvasMap MapRenderer;
var FontRenderInfo HUDTextRenderInfo;

var Font HUDFont;
var Color PanelColor;
var Color PanelBorderColor;
var Color HealthColor;
var Color ArmorColor;
var Color AmmoColor;
var Color GDIColor;
var Color NodColor;
var Color NeutralColor;
var Texture2D ResourceMineIcon;
var Texture2D ResourceVehicleIcons[2];
var Texture2D VetRankTextures[4];
var int CachedTeamPlayerCounts[2];
var float NextTeamCountRefreshTime;
var array<Rx_Building> CachedGDIBuildings;
var array<Rx_Building> CachedNodBuildings;
var WorldInfo CachedBuildingWorld;
var float NextBuildingCacheTime;
var bool bBuildingCacheReady;
var Pawn CachedWeaponOwner;
var array<Rx_Weapon> CachedWeapons;
var float NextWeaponCacheTime;
var array<PlayerReplicationInfo> CachedSortedPlayers;
var float NextScoreboardCacheTime;
var array<OverviewCountRow> CachedCharacterRows;
var array<OverviewCountRow> CachedVehicleRows;
var int CachedOverviewTeam;
var float NextOverviewCountRefreshTime;
var int CachedLayoutWidth;
var int CachedLayoutHeight;
var string CachedLayoutMapName;
var float LayoutGlobalScale;
var float LayoutHorizontalOffset;
var float LayoutVerticalOffset;
var float LayoutHorizontalSafeZone;
var float LayoutVerticalSafeZone;
var float LayoutMinimapScale;
var float LayoutMessageScale;
var float LayoutScoreboardScale;
var float LayoutOverviewScale;
var Texture2D WhiteTexture;
var array<CanvasUVTri> ActiveSegmentTriangles;
var array<CanvasUVTri> InactiveSegmentTriangles;

function Update(float DeltaTime, Rx_HUD HUD)
{
	local int i;

	Super.Update(DeltaTime, HUD);
	ResolveLayout();
	if(!bHUDTextRenderInfoReady && Canvas!=None)
	{
		// Canvas selects SimpleElementPixelShader.usf's distance-field font
		// branch when a distance-field font receives FontRenderInfo.
		HUDTextRenderInfo=Canvas.CreateFontRenderInfo(false,false);
		HUDTextRenderInfo.GlowInfo.bEnableGlow=true;
		HUDTextRenderInfo.GlowInfo.GlowColor.R=0;
		HUDTextRenderInfo.GlowInfo.GlowColor.G=0;
		HUDTextRenderInfo.GlowInfo.GlowColor.B=0;
		HUDTextRenderInfo.GlowInfo.GlowColor.A=0.58;
		HUDTextRenderInfo.GlowInfo.GlowOuterRadius.X=0.22;
		HUDTextRenderInfo.GlowInfo.GlowOuterRadius.Y=0.42;
		HUDTextRenderInfo.GlowInfo.GlowInnerRadius.X=0.47;
		HUDTextRenderInfo.GlowInfo.GlowInnerRadius.Y=0.52;
		bHUDTextRenderInfoReady=true;
	}
	if(MapRenderer == None)
		MapRenderer = new class'Rx_HUD_CanvasMap';
	MapRenderer.SetLayout(LayoutGlobalScale, LayoutHorizontalOffset,
		LayoutVerticalOffset, LayoutHorizontalSafeZone, LayoutVerticalSafeZone,
		LayoutMinimapScale, LayoutOverviewScale);
	MapRenderer.Update(DeltaTime, HUD);
	for(i = Messages.Length - 1; i >= 0; --i)
	{
		if(Messages[i].ExpireTime <= HUD.WorldInfo.TimeSeconds)
			Messages.Remove(i, 1);
	}

	if(VoteExpireTime > 0 && VoteExpireTime <= HUD.WorldInfo.TimeSeconds)
	{
		VoteText = "";
		VoteExpireTime = 0;
	}
}

function ResolveLayout()
{
	local string CurrentMapName;

	if(Canvas == None || RenxHud == None || RenxHud.WorldInfo == None)
		return;

	CurrentMapName = RenxHud.WorldInfo.GetMapName(true);
	if(CachedLayoutWidth == Canvas.SizeX && CachedLayoutHeight == Canvas.SizeY
		&& CachedLayoutMapName == CurrentMapName)
		return;

	CachedLayoutWidth = Canvas.SizeX;
	CachedLayoutHeight = Canvas.SizeY;
	CachedLayoutMapName = CurrentMapName;
	class'Rx_HUD_CanvasConfig'.static.ResolveLayout(
		CachedLayoutWidth, CachedLayoutHeight, CachedLayoutMapName,
		LayoutGlobalScale, LayoutHorizontalOffset, LayoutVerticalOffset,
		LayoutHorizontalSafeZone, LayoutVerticalSafeZone, LayoutMinimapScale,
		LayoutMessageScale, LayoutScoreboardScale, LayoutOverviewScale);

	`log("Rx_HUD Canvas layout:" @ CachedLayoutWidth$"x"$CachedLayoutHeight
		@ CachedLayoutMapName @ "scale="$LayoutGlobalScale
		@ "minimap="$LayoutMinimapScale @ "messages="$LayoutMessageScale
		@ "scoreboard="$LayoutScoreboardScale @ "overview="$LayoutOverviewScale);
}

function AddMessage(string InText, optional float LifeTime = 8.0, optional byte Channel = 0, optional Color InColor)
{
	local CanvasHUDMessage NewMessage;

	if(InColor.A == 0)
	{
		InColor=ColorWhite;
		if(Channel==2)
			InColor=NeutralColor;
		else if(Channel==3)
			InColor=GDIColor;
		else if(Channel==4)
			InColor.A=235;
		else if(Channel==5)
		{
			InColor.R=255; InColor.G=220; InColor.B=70; InColor.A=255;
		}
		else if(Channel==6)
		{
			InColor.R=70; InColor.G=255; InColor.B=90; InColor.A=255;
		}
	}

	// Keep the legacy font-color spans. They encode team chat, global-chat
	// sender, killer and victim colors and are rendered natively below.
	NewMessage.TextColor = InColor;
	ParseRichText(InText,InColor,NewMessage.Runs);
	if(Channel==0 || Channel==1)
		LifeTime=FMax(8.0,LifeTime);
	else if(Channel==2)
		// General notifications (crate pickups, missile warnings, etc.) should
		// be readable without occupying the feed as long as chat or radio.
		LifeTime=FClamp(LifeTime,2.5,4.0);
	else if(Channel==3)
		LifeTime=FMax(7.0,LifeTime);
	else if(Channel==4)
		LifeTime=FMax(8.0,LifeTime);
	else if(Channel==6)
		LifeTime=FClamp(LifeTime,4.0,8.0);
	NewMessage.ExpireTime = RenxHud.WorldInfo.TimeSeconds + FMax(2.5, LifeTime);
	NewMessage.Channel = Channel;
	Messages.AddItem(NewMessage);

	while(Messages.Length > 24)
		Messages.Remove(0, 1);
}

function SetGameplayTip(string InText)
{
	GameplayTip = StripMarkup(InText);
}

function SetSubtitle(string InText)
{
	SubtitleText = StripMarkup(InText);
}

function SetVote(string InText, int YesVotes, int NoVotes, int YesNeeded, int SecondsLeft)
{
	VoteText = StripMarkup(InText);
	VoteYes = YesVotes;
	VoteNo = NoVotes;
	VoteNeeded = YesNeeded;
	VoteExpireTime = RenxHud.WorldInfo.TimeSeconds + FMax(1, SecondsLeft);
}

function SetMenuOptions(array<MenuOption> InOptions)
{
	MenuOptions = InOptions;
	bShowSideMenu = true;
}

function SetHelpLines(array<string> InLines)
{
	HelpLines = InLines;
	bShowHelp = true;
}

function SetSideMenuVisible(bool bVisible)
{
	bShowSideMenu = bVisible;
	if(!bVisible)
		bShowHelp = false;
}

function ShowHitMarker()
{
	HitMarkerExpireTime = RenxHud.WorldInfo.TimeSeconds + 0.18;
}

function ShowLoading(float Progress, string InText)
{
	LoadingProgress = FClamp(Progress, 0.0, 1.0);
	LoadingText = StripMarkup(InText);
	bShowLoading = true;
}

function HideLoading()
{
	bShowLoading = false;
}

function Draw()
{
	if(!bEnabled || Canvas == None || RenxHud == None)
		return;

	Canvas.Font = HUDFont;
	if(bShowOverview)
	{
		DrawOverviewMap();
		return;
	}
	if(bShowFullScoreboard)
	{
		DrawFullScoreboard();
		return;
	}
	DrawMatchInfo();
	if(MapRenderer != None)
		MapRenderer.DrawMinimap(GetDisplayPawn());
	DrawHudDataCounters();
	DrawPawnInfo();
	DrawBuildingStrip();
	DrawSpectatorInfo();
	DrawMessages();
	DrawVote();
	DrawTipsAndSubtitles();
	DrawSideMenu();
	DrawLoading();
	DrawHitMarker();
}

function DrawFullScoreboard()
{
	local Rx_GRI GRI;
	local PlayerReplicationInfo PRI;
	local Rx_PRI RPRI;
	local int i, TeamIndex, TeamRow;
	local float S, PanelX, X, Y, W, H, ColumnW, RowH, RowY;
	local float BuildingColumnW, BuildingY, BuildingH;
	local string Line, PlayerName, RoleText;
	local Color TeamColor, PlayerColor, RowColor, TeamPanelColor;

	GRI = Rx_GRI(RenxHud.WorldInfo.GRI);
	if(GRI == None)
		return;

	S = GetScale()*LayoutScoreboardScale;
	W = FMin(Canvas.SizeX*0.96-2*LayoutHorizontalSafeZone*S, 1120*S);
	H = FMin(Canvas.SizeY*0.92-2*LayoutVerticalSafeZone*S, 662*S);
	PanelX = (Canvas.SizeX-W)*0.5+LayoutHorizontalOffset*S;
	X = PanelX;
	Y = (Canvas.SizeY-H)*0.5+(LayoutVerticalSafeZone+LayoutVerticalOffset)*S;
	RowH = 17*S;
	BuildingColumnW=62*S;
	ColumnW = (W-40*S-2*BuildingColumnW)*0.5;
	RefreshScoreboardCache(GRI);
	// The Tab screen is an exclusive top layer. Cover gameplay components that
	// rendered earlier in PostRender, then draw only scoreboard-owned content.
	Canvas.SetDrawColor(0,0,0,255);
	Canvas.SetPos(0,0);
	Canvas.DrawRect(Canvas.SizeX,Canvas.SizeY);
	DrawPanel(X,Y,W,H,PanelColor);
	DrawAccent(X,Y,W*0.5,3*S,GDIColor);
	DrawAccent(X+W*0.5,Y,W*0.5,3*S,NodColor);
	DrawTextAt(GRI.bMatchIsOver ? "MATCH RESULTS" : "RENEGADE X", X+W*0.5, Y+8*S, ColorWhite, 0.78*S, 1);
	DrawTextAt(Caps(RenxHud.WorldInfo.GetMapName(true)), X+W*0.5, Y+30*S, NeutralColor, 0.45*S, 1);

	if(GRI.bMatchIsOver)
		DrawEndGameHeader(GRI,X+W*0.5,Y+49*S,S);

	for(TeamIndex=TEAM_GDI; TeamIndex<=TEAM_NOD; ++TeamIndex)
	{
		X = PanelX+14*S+BuildingColumnW+TeamIndex*(ColumnW+12*S);
		RowY = Y+(GRI.bMatchIsOver ? 146 : 58)*S;
		TeamColor = TeamIndex == TEAM_GDI ? GDIColor : NodColor;
		TeamPanelColor=PanelColor;
		if(TeamIndex==TEAM_GDI)
		{
			TeamPanelColor.R=16; TeamPanelColor.G=14; TeamPanelColor.B=5;
		}
		else
		{
			TeamPanelColor.R=17; TeamPanelColor.G=5; TeamPanelColor.B=5;
		}
		DrawPanel(X,RowY-5*S,ColumnW,H-(GRI.bMatchIsOver ? 222 : 134)*S,TeamPanelColor);
		DrawTextAt((TeamIndex == TEAM_GDI ? "GLOBAL DEFENSE INITIATIVE" : "BROTHERHOOD OF NOD")
			$"   "$GetTeamScore(GRI,TeamIndex),
			X+ColumnW*0.5,RowY,TeamColor,0.58*S,1);
		RowY += 20*S;
		DrawAccent(X,RowY-3*S,ColumnW,2*S,TeamColor);
		DrawTextAt("PLAYER",X+5*S,RowY,NeutralColor,0.42*S,0);
		DrawTextAt("CLASS / VEHICLE",X+ColumnW*0.62,RowY,NeutralColor,0.34*S,2);
		DrawTextAt("SCORE  K  VK  D  PING",X+ColumnW-5*S,RowY,NeutralColor,0.42*S,2);
		RowY += 16*S;
		TeamRow = 0;
		for(i=0; i<CachedSortedPlayers.Length; ++i)
		{
			PRI = CachedSortedPlayers[i];
			RPRI = Rx_PRI(PRI);
			if(RPRI == None || PRI.bIsSpectator || RPRI.bIsScripted || PRI.GetTeamNum() != TeamIndex)
				continue;
			if(TeamRow < 18)
			{
				PlayerColor=PRI==RenxHud.PlayerOwner.PlayerReplicationInfo ? NeutralColor
					: TeamColor;
				RowColor=TeamColor;
				if(PRI==RenxHud.PlayerOwner.PlayerReplicationInfo)
					RowColor.A=52;
				else if((TeamRow&1)==1)
				{
					RowColor.R=255; RowColor.G=255; RowColor.B=255; RowColor.A=10;
				}
				else
					RowColor.A=0;
				if(RowColor.A>0)
					DrawAccent(X+2*S,RowY-1*S,ColumnW-4*S,RowH,RowColor);
				PlayerName=(RPRI.bIsCommander ? "[C] " : "")$PRI.GetHumanReadableName();
				DrawTextAt(PlayerName,X+5*S,RowY,PlayerColor,0.46*S,0);
				RoleText=GetScoreboardRole(RPRI);
				DrawTextAt(RoleText,X+ColumnW*0.62,RowY,ColorWhite,0.33*S,2);
				Line=RPRI.GetRenScore()$"  "$RPRI.GetRenKills()$"  "$RPRI.GetVehicleKills()
					$"  "$RPRI.Deaths$"  "$PRI.Ping*4;
				DrawTextAt(Line,X+ColumnW-5*S,RowY,ColorWhite,0.43*S,2);
				RowY += RowH;
			}
			++TeamRow;
		}
		DrawTextAt(TeamRow$" PLAYERS",X+ColumnW*0.5,RowY+3*S,TeamColor,0.43*S,1);
	}
	BuildingY=Y+(GRI.bMatchIsOver ? 146 : 58)*S-5*S;
	BuildingH=H-(GRI.bMatchIsOver ? 222 : 134)*S;
	DrawScoreboardBuildingColumn(CachedGDIBuildings,PanelX+8*S,BuildingY,
		BuildingColumnW,BuildingH);
	DrawScoreboardBuildingColumn(CachedNodBuildings,PanelX+W-8*S-BuildingColumnW,
		BuildingY,BuildingColumnW,BuildingH);
	DrawScoreboardBuildings(PanelX+8*S,Y+H-70*S,W-16*S,S);
	if(GRI.bMatchIsOver)
		DrawEndGameMapVote(GRI,PanelX+W*0.2,Y+H-166*S,W*0.6,S);
}

function RefreshScoreboardCache(Rx_GRI GRI)
{
	local int I;

	if(GRI==None || RenxHud.WorldInfo.TimeSeconds<NextScoreboardCacheTime)
		return;
	CachedSortedPlayers.Length=0;
	for(I=0;I<GRI.PRIArray.Length;++I)
		if(Rx_PRI(GRI.PRIArray[I])!=None && !Rx_PRI(GRI.PRIArray[I]).bIsScripted)
			CachedSortedPlayers.AddItem(GRI.PRIArray[I]);
	CachedSortedPlayers.Sort(SortCanvasPRI);
	NextScoreboardCacheTime=RenxHud.WorldInfo.TimeSeconds+0.25;
}

function int GetTeamScore(Rx_GRI GRI, int TeamIndex)
{
	if(GRI!=None && TeamIndex>=TEAM_GDI && TeamIndex<=TEAM_NOD
		&& Rx_TeamInfo(GRI.Teams[TeamIndex])!=None)
		return Rx_TeamInfo(GRI.Teams[TeamIndex]).GetRenScore();
	return 0;
}

function string GetScoreboardRole(Rx_PRI PRI)
{
	local class<Rx_Vehicle> VehicleClass;
	local class<Rx_FamilyInfo> FamilyClass;

	if(PRI==None)
		return "";
	VehicleClass=class<Rx_Vehicle>(PRI.GetPawnVehicleClass());
	if(VehicleClass!=None)
		return Left(Caps(VehicleClass.default.UIString),15);
	FamilyClass=class<Rx_FamilyInfo>(PRI.CharClassInfo);
	if(FamilyClass!=None)
		return Left(Caps(FamilyClass.default.UIString),15);
	return "INFANTRY";
}

function int SortCanvasPRI(coerce PlayerReplicationInfo A, coerce PlayerReplicationInfo B)
{
	if(Rx_PRI(A)==None || Rx_PRI(B)==None)
		return 0;
	if(Rx_PRI(A).GetRenScore()>Rx_PRI(B).GetRenScore())
		return 1;
	if(Rx_PRI(A).GetRenScore()<Rx_PRI(B).GetRenScore())
		return -1;
	return 0;
}

function DrawOverviewMap()
{
	local Pawn CenterPawn;
	local float S, MapSize, X, Y, BuildingY, BuildingH;

	CenterPawn = GetDisplayPawn();
	if(CenterPawn == None)
		return;

	S = GetScale();
	Canvas.SetDrawColor(0,0,0,205);
	Canvas.SetPos(0,0);
	Canvas.DrawRect(Canvas.SizeX,Canvas.SizeY);
	// Give the tactical map roughly two thirds of the horizontal layout while
	// respecting the screen-height limit of its square terrain.
	MapSize = FMin(Canvas.SizeY*0.88,Canvas.SizeX*0.667)
		*LayoutGlobalScale*LayoutOverviewScale;
	MapSize = FMin(MapSize,Canvas.SizeY-(60+2*LayoutVerticalSafeZone)*S);
	X = Canvas.SizeX-MapSize-(18+LayoutHorizontalSafeZone-LayoutHorizontalOffset)*S;
	Y = (26+LayoutVerticalSafeZone+LayoutVerticalOffset)*S;
	DrawTextAt("TACTICAL OVERVIEW",X+MapSize*0.5,Y-24*S,ColorWhite,0.68*S,1);
	if(MapRenderer != None)
		MapRenderer.DrawOverview(CenterPawn,X,Y,MapSize);
	DrawOverviewRoster((14+LayoutHorizontalSafeZone+LayoutHorizontalOffset)*S,Y,
		Canvas.SizeX-MapSize-(46+2*LayoutHorizontalSafeZone)*S,MapSize);
	BuildingY=Y+MapSize+5*S;
	BuildingH=FMin(72*S,Canvas.SizeY-BuildingY-(7+LayoutVerticalSafeZone)*S);
	BuildingY=Canvas.SizeY-BuildingH-(7+LayoutVerticalSafeZone-LayoutVerticalOffset)*S;
	DrawOverviewBuildingRows(X,BuildingY,MapSize,BuildingH);
}

function DrawOverviewRoster(float X, float Y, float W, float H)
{
	local float S, PlayerH, BottomY, BottomH, Gap, CharacterW;

	S=GetScale();
	Gap=5*S;
	PlayerH=H*0.59;
	BottomY=Y+PlayerH+Gap;
	BottomH=H-PlayerH-Gap;
	CharacterW=(W-Gap)*0.56;
	DrawOverviewPlayerTable(X,Y,W,PlayerH);
	DrawOverviewCountTables(X,BottomY,CharacterW,W-CharacterW-Gap,BottomH,Gap);
}

function DrawOverviewPlayerTable(float X, float Y, float W, float H)
{
	local Rx_GRI GRI;
	local Rx_PRI RPRI;
	local PlayerReplicationInfo PRI;
	local class<Rx_Vehicle> VehicleClass;
	local class<Rx_FamilyInfo> FamilyClass;
	local int i, Row, MaxRows;
	local float S, RowH;
	local string ClassText, VehicleText;
	local Color C;

	GRI = Rx_GRI(RenxHud.WorldInfo.GRI);
	if(GRI == None || W < 120)
		return;
	S = GetScale();
	RowH = 15*S;
	MaxRows=Max(1,int((H-45*S)/RowH));
	DrawPanel(X,Y,W,H,PanelColor);
	C=RenxHud.PlayerOwner.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor;
	DrawAccent(X,Y,W,3*S,C);
	DrawTextAt("TEAM PLAYER TABLE",X+W*0.5,Y+7*S,C,0.52*S,1);
	DrawAccent(X,Y+27*S,W,1*S,C);
	DrawTextAt("PLAYER",X+6*S,Y+30*S,C,0.36*S,0);
	DrawTextAt("$",X+W*0.43,Y+30*S,C,0.36*S,2);
	DrawTextAt("CLASS",X+W*0.70,Y+30*S,C,0.36*S,2);
	DrawTextAt("VEHICLE",X+W-5*S,Y+30*S,C,0.36*S,2);
	Row=0;
	for(i=0;i<GRI.PRIArray.Length;++i)
	{
		PRI=GRI.PRIArray[i];
		RPRI=Rx_PRI(PRI);
		if(RPRI==None || PRI.bIsSpectator || RPRI.bIsScripted
			|| PRI.GetTeamNum()!=RenxHud.PlayerOwner.GetTeamNum())
			continue;
		VehicleClass=class<Rx_Vehicle>(RPRI.GetPawnVehicleClass());
		FamilyClass=class<Rx_FamilyInfo>(RPRI.CharClassInfo);
		ClassText=FamilyClass!=None ? FamilyClass.default.UIString : "";
		if(RPRI.isSpy())
			ClassText="[SPY] "$ClassText;
		VehicleText=VehicleClass!=None ? VehicleClass.default.UIString : "";
		if(Row<MaxRows)
		{
			C=PRI==RenxHud.PlayerOwner.PlayerReplicationInfo ? NeutralColor
				: (PRI.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor);
			if((Row&1)==1)
			{
				C.A=12;
				DrawAccent(X+2*S,Y+44*S+Row*RowH,W-4*S,RowH,C);
				C=PRI==RenxHud.PlayerOwner.PlayerReplicationInfo ? NeutralColor
					: (PRI.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor);
			}
			DrawTextAt(PRI.GetHumanReadableName(),X+6*S,Y+44*S+Row*RowH,C,0.36*S,0);
			DrawTextAt(string(int(RPRI.GetCredits())),X+W*0.43,Y+44*S+Row*RowH,ColorWhite,0.33*S,2);
			DrawTextAt(Left(ClassText,17),X+W*0.70,Y+44*S+Row*RowH,ColorWhite,0.32*S,2);
			DrawTextAt(Left(VehicleText,15),X+W-5*S,Y+44*S+Row*RowH,ColorWhite,0.32*S,2);
		}
		++Row;
	}
}

function DrawOverviewCountTables(float X, float Y, float CharacterW, float VehicleW, float H, float Gap)
{
	RefreshOverviewCountRows();
	DrawOverviewCountTable(X,Y,CharacterW,H,"CHARACTER OVERVIEW",CachedCharacterRows);
	DrawOverviewCountTable(X+CharacterW+Gap,Y,VehicleW,H,"VEHICLE OVERVIEW",CachedVehicleRows);
}

function RefreshOverviewCountRows()
{
	local int TeamIndex;

	TeamIndex=RenxHud.PlayerOwner.GetTeamNum();
	if(TeamIndex==CachedOverviewTeam
		&& RenxHud.WorldInfo.TimeSeconds<NextOverviewCountRefreshTime)
		return;
	CachedCharacterRows.Length=0;
	CachedVehicleRows.Length=0;
	BuildOverviewCountRows(CachedCharacterRows,CachedVehicleRows);
	CachedOverviewTeam=TeamIndex;
	NextOverviewCountRefreshTime=RenxHud.WorldInfo.TimeSeconds+0.5;
}

function BuildOverviewCountRows(out array<OverviewCountRow> CharacterRows,
	out array<OverviewCountRow> VehicleRows)
{
	local Rx_MapInfo MI;
	local OverviewCountRow Row;
	local class<Rx_FamilyInfo> FamilyClass;
	local class<Rx_Vehicle_PTInfo> PTClass;
	local class<Rx_Vehicle> VehicleClass;
	local int I, TeamIndex, SpyCount;

	if(MapRenderer==None || MapRenderer.MapInfo==None)
		return;
	MI=MapRenderer.MapInfo;
	TeamIndex=RenxHud.PlayerOwner.GetTeamNum();
	if(TeamIndex==TEAM_GDI)
	{
		for(I=0;I<MI.GDIInfantryArray.Length;++I)
		{
			FamilyClass=MI.GDIInfantryArray[I];
			if(FamilyClass==None)
				continue;
			Row.Label=FamilyClass.default.UIString;
			Row.Count=CountOverviewFamily(FamilyClass,TeamIndex);
			CharacterRows.AddItem(Row);
		}
		for(I=0;I<MI.GDIVehicleArray.Length;++I)
		{
			PTClass=MI.GDIVehicleArray[I];
			if(PTClass==None || PTClass.default.VehicleClass==None)
				continue;
			VehicleClass=PTClass.default.VehicleClass;
			Row.Label=VehicleClass.default.UIString;
			Row.Count=CountOverviewVehicle(VehicleClass,TeamIndex);
			VehicleRows.AddItem(Row);
		}
	}
	else
	{
		for(I=0;I<MI.NodInfantryArray.Length;++I)
		{
			FamilyClass=MI.NodInfantryArray[I];
			if(FamilyClass==None)
				continue;
			Row.Label=FamilyClass.default.UIString;
			Row.Count=CountOverviewFamily(FamilyClass,TeamIndex);
			CharacterRows.AddItem(Row);
		}
		for(I=0;I<MI.NodVehicleArray.Length;++I)
		{
			PTClass=MI.NodVehicleArray[I];
			if(PTClass==None || PTClass.default.VehicleClass==None)
				continue;
			VehicleClass=PTClass.default.VehicleClass;
			Row.Label=VehicleClass.default.UIString;
			Row.Count=CountOverviewVehicle(VehicleClass,TeamIndex);
			VehicleRows.AddItem(Row);
		}
	}
	SpyCount=CountOverviewSpies(TeamIndex);
	Row.Label="SPIES";
	Row.Count=SpyCount;
	CharacterRows.AddItem(Row);
}

function int CountOverviewFamily(class<Rx_FamilyInfo> FamilyClass, int TeamIndex)
{
	local PlayerReplicationInfo PRI;
	local int Count;

	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
		if(Rx_PRI(PRI)!=None && !PRI.bIsSpectator
			&& PRI.GetTeamNum()==TeamIndex
			&& class<Rx_FamilyInfo>(Rx_PRI(PRI).CharClassInfo)==FamilyClass
			&& !Rx_PRI(PRI).isSpy())
			++Count;
	return Count;
}

function int CountOverviewVehicle(class<Rx_Vehicle> VehicleClass, int TeamIndex)
{
	local PlayerReplicationInfo PRI;
	local int Count;

	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
		if(Rx_PRI(PRI)!=None && !PRI.bIsSpectator
			&& PRI.GetTeamNum()==TeamIndex
			&& class<Rx_Vehicle>(Rx_PRI(PRI).GetPawnVehicleClass())==VehicleClass)
			++Count;
	return Count;
}

function int CountOverviewSpies(int TeamIndex)
{
	local PlayerReplicationInfo PRI;
	local int Count;

	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
		if(Rx_PRI(PRI)!=None && !PRI.bIsSpectator
			&& PRI.GetTeamNum()==TeamIndex && Rx_PRI(PRI).isSpy())
			++Count;
	return Count;
}

function DrawOverviewCountTable(float X, float Y, float W, float H,
	string Title, array<OverviewCountRow> Rows)
{
	local int I;
	local float S, RowH;
	local string CountText;
	local Color TeamColor;

	S=GetScale();
	TeamColor=RenxHud.PlayerOwner.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor;
	DrawPanel(X,Y,W,H,PanelColor);
	DrawAccent(X,Y,W,2*S,TeamColor);
	DrawTextAt("#",X+6*S,Y+6*S,TeamColor,0.34*S,0);
	DrawTextAt(Title,X+22*S,Y+6*S,TeamColor,0.34*S,0);
	DrawAccent(X,Y+21*S,W,1*S,TeamColor);
	if(Rows.Length==0)
		return;
	RowH=FMin(14*S,(H-24*S)/Rows.Length);
	for(I=0;I<Rows.Length;++I)
	{
		CountText=string(Rows[I].Count);
		DrawTextAt(CountText,X+8*S,Y+24*S+I*RowH,ColorWhite,0.30*S,1);
		DrawTextAt(Left(Rows[I].Label,20),X+22*S,Y+24*S+I*RowH,ColorWhite,0.30*S,0);
	}
}

function DrawOverviewBuildingRows(float X, float Y, float W, float H)
{
	RefreshBuildingCache();
	DrawOverviewBuildingTeamRow(CachedGDIBuildings,X,Y,W*0.5,H,false);
	DrawOverviewBuildingTeamRow(CachedNodBuildings,X+W*0.5,Y,W*0.5,H,true);
	DrawTextAt("M  CLOSE OVERVIEW",X+W*0.5,Canvas.SizeY-10*GetScale(),
		NeutralColor,0.34*GetScale(),1);
}

function DrawOverviewBuildingTeamRow(array<Rx_Building> Buildings,
	float X, float Y, float W, float H, bool bRightAlign)
{
	local int I;
	local float S, CellW, StartX, CellX;

	if(Buildings.Length==0 || H<=8)
		return;
	S=GetScale();
	CellW=FMin(66*S,(W-3*S)/Buildings.Length);
	StartX=bRightAlign ? X+W-CellW*Buildings.Length : X;
	for(I=0;I<Buildings.Length;++I)
	{
		CellX=StartX+I*CellW;
		DrawBuildingStatusCell(Buildings[I],CellX,Y,CellW-3*S,H,S);
	}
}

function DrawScoreboardBuildingColumn(array<Rx_Building> Buildings,
	float X, float Y, float W, float H)
{
	local int I;
	local float S, CellH;

	if(Buildings.Length==0 || H<=8)
		return;
	S=GetScale()*LayoutScoreboardScale;
	CellH=FMin(68*S,(H-3*S)/Buildings.Length);
	for(I=0;I<Buildings.Length;++I)
		DrawBuildingStatusCell(Buildings[I],X,Y+I*CellH,W,CellH-3*S,S);
}

function DrawBuildingStatusCell(Rx_Building B, float X, float Y,
	float W, float H, float S)
{
	local float IconSize, ArtworkSize, HealthPct, ArmorPct;
	local Color C, IconColor, ArtworkColor;
	local string StateText;
	local Texture2D StatusTexture;

	if(B==None || W<=8 || H<=12)
		return;
	C=B.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor;
	IconColor=C;
	ArtworkColor=ColorWhite;
	if(B.GetTeamNum()==TEAM_GDI)
	{
		// Keep GDI building artwork yellow-gold instead of the darker
		// orange used by compact score accents.
		IconColor.R=255; IconColor.G=222; IconColor.B=60; IconColor.A=255;
	}
	if(B.IsDestroyed())
	{
		IconColor.R=125; IconColor.G=128; IconColor.B=132; IconColor.A=230;
		// The shipped overview has no separate destroyed silo artwork.
		if(Rx_Building_TeamSilo_GDI(B)!=None || Rx_Building_TeamSilo_Nod(B)!=None)
			ArtworkColor=IconColor;
		if(B.GetRevivalTime()>0
			|| (B.BuildingInternals!=None && B.BuildingInternals.GetReviveIsAvailable()))
			StateText=B.GetTimerString(B.GetRevivalTime());
		else
			StateText="DESTROYED";
	}
	else
	{
		HealthPct=B.GetMaxHealth()>0
			? FClamp(float(B.GetHealth())/B.GetMaxHealth(),0.0,1.0) : 0.0;
		ArmorPct=B.GetMaxArmor()>0
			? FClamp(float(B.GetArmor())/B.GetMaxArmor(),0.0,1.0) : 0.0;
	}
	IconSize=FMin(40*S,FMin(W-7*S,H-22*S));
	ArtworkSize=IconSize*2.0;
	StatusTexture=GetBuildingStatusTexture(B);
	DrawPanel(X,Y,W,H,PanelColor);
	DrawAccent(X,Y,W,2*S,C);
	if(StateText!="")
		DrawTextAt(StateText,X+W*0.5,Y+3*S,IconColor,0.25*S,1);
	if(StatusTexture!=None)
		DrawTextureAspect(StatusTexture,X+(W-ArtworkSize)*0.5,
			Y+10*S-(ArtworkSize-IconSize)*0.5,
			ArtworkSize,ArtworkSize,ArtworkColor);
	else if(B.IconTexture!=None)
		DrawTextureAspect(B.IconTexture,X+(W-IconSize)*0.5,Y+10*S,
			IconSize,IconSize,IconColor);
	else
		DrawTextAt(Left(Caps(B.GetBuildingName()),7),X+W*0.5,Y+18*S,
			IconColor,0.28*S,1);
	DrawBar(X+3*S,Y+H-10*S,W-6*S,4*S,HealthPct,1,C);
	DrawBar(X+3*S,Y+H-5*S,W-6*S,3*S,ArmorPct,1,ArmorColor);
}

function Texture2D GetBuildingStatusTexture(Rx_Building B)
{
	local bool bDestroyed;

	if(B==None)
		return None;
	bDestroyed=B.IsDestroyed();

	// These are the full-resolution images embedded by the Scaleform overview.
	// Check specializations first because helipads and silos inherit from the
	// ordinary vehicle/money factory categories.
	if(Rx_Building_Helipad_GDI(B)!=None)
		return bDestroyed
			? Texture2D'RenXScoreboard.T_BuildingIcon_Helipad_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Helipad_GDI_Active';
	if(Rx_Building_Helipad_Nod(B)!=None)
		return bDestroyed
			? Texture2D'RenXScoreboard.T_BuildingIcon_Helipad_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Helipad_Nod_Active';
	if(Rx_Building_TeamSilo_GDI(B)!=None)
		return Texture2D'RenXInfoScreen.T_BuildingIcon_Silo_GDI_Active';
	if(Rx_Building_TeamSilo_Nod(B)!=None)
		return Texture2D'RenXInfoScreen.T_BuildingIcon_Silo_Nod_Active';
	if(Rx_Building_RepairFacility_GDI(B)!=None)
		return bDestroyed
			? Texture2D'RenXScoreboard.T_BuildingIcon_Repair_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_RepPad_GDI_Active';
	if(Rx_Building_RepairFacility_Nod(B)!=None)
		return bDestroyed
			? Texture2D'RenXScoreboard.T_BuildingIcon_Repair_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_RepPad_Nod_Active';

	if(Rx_Building_GDI_Defense(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_AGT_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_AGT_Active';
	if(Rx_Building_Nod_Defense(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_Ob_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Ob_Active';
	if(Rx_Building_GDI_InfantryFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_Bar_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Bar_Active';
	if(Rx_Building_Nod_InfantryFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_HoN_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_HoN_Active';
	if(Rx_Building_GDI_VehicleFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_WF_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_WF_Active';
	if(Rx_Building_Nod_VehicleFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_Air_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Air_Active';
	if(Rx_Building_GDI_MoneyFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_Ref_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Ref_GDI_Active';
	if(Rx_Building_Nod_MoneyFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_Ref_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_Ref_Nod_Active';
	if(Rx_Building_GDI_PowerFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_PP_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_PP_GDI_Active';
	if(Rx_Building_Nod_PowerFactory(B)!=None)
		return bDestroyed
			? Texture2D'RenXInfoScreen.T_BuildingIcon_PP_Destroyed'
			: Texture2D'RenXInfoScreen.T_BuildingIcon_PP_Nod_Active';

	return None;
}

function DrawEndGameHeader(Rx_GRI GRI, float CenterX, float Y, float S)
{
	local float TimeLeft;
	local string Winner, Commander[2];
	local Color C;
	local PlayerReplicationInfo PRI;

	foreach GRI.PRIArray(PRI)
		if(Rx_PRI(PRI)!=None && Rx_PRI(PRI).bIsCommander && PRI.GetTeamNum()<=TEAM_NOD)
			Commander[PRI.GetTeamNum()]=PRI.GetHumanReadableName();
	Winner=GRI.WinnerTeamNum==TEAM_GDI ? "GDI VICTORY" : "NOD VICTORY";
	C=GRI.WinnerTeamNum==TEAM_GDI ? GDIColor : NodColor;
	DrawTextAt(Winner,CenterX,Y,C,0.72*S,1);
	DrawTextAt(StripMarkup(GRI.WinnerReason),CenterX,Y+21*S,ColorWhite,0.44*S,1);
	DrawTextAt("COMMANDERS  "$DisplayOrNone(Commander[0])$"  /  "$DisplayOrNone(Commander[1]),
		CenterX,Y+38*S,ColorWhite,0.4*S,1);
	DrawTextAt("MVP  "$DisplayOrNone(GRI.MVP[0])$"  /  "$DisplayOrNone(GRI.MVP[1]),
		CenterX,Y+53*S,NeutralColor,0.42*S,1);
	DrawTextAt("OFF  "$DisplayOrNone(GRI.BestOP[0])$" / "$DisplayOrNone(GRI.BestOP[1])
		$"   DEF  "$DisplayOrNone(GRI.BestDP[0])$" / "$DisplayOrNone(GRI.BestDP[1])
		$"   SUP  "$DisplayOrNone(GRI.BestSP[0])$" / "$DisplayOrNone(GRI.BestSP[1]),
		CenterX,Y+68*S,ColorWhite,0.37*S,1);
	TimeLeft=FMax(0,GRI.RenEndTime-RenxHud.WorldInfo.RealTimeSeconds);
	DrawTextAt("NEXT MAP  "$Caps(GRI.NextMap)$"   "$int(TimeLeft)$"s",
		CenterX,Y+83*S,ColorWhite,0.4*S,1);
}

function DrawEndGameMapVote(Rx_GRI GRI, float X, float Y, float W, float S)
{
	local int i, Rows;
	local float RowY;
	local string VoteLine;

	if(GRI.NextMap!="" || GRI.MapVotesSize<=0)
		return;
	DrawPanel(X,Y,W,91*S,PanelColor);
	DrawTextAt("MAP VOTE",X+W*0.5,Y+6*S,NeutralColor,0.44*S,1);
	RowY=Y+24*S;
	for(i=0;i<ArrayCount(GRI.MapVoteList) && Rows<4;++i)
	{
		if(GRI.MapVoteList[i]=="")
			continue;
		VoteLine=(i+1)$"  "$Caps(GRI.MapVoteList[i])$"   "$GRI.MapVotes[i];
		DrawTextAt(VoteLine,X+8*S,RowY,ColorWhite,0.4*S,0);
		RowY+=14*S;
		++Rows;
	}
}

function string DisplayOrNone(string Value)
{
	return Value=="" ? "NONE" : StripMarkup(Value);
}

function DrawScoreboardBuildings(float X, float Y, float W, float S)
{
	local Rx_Building B;
	local Rx_GRI GRI;
	local Rx_TeamInfo GDITeam, NodTeam;
	local int Counts[2], Destroyed[2];
	local int I;

	RefreshBuildingCache();
	for(I=0;I<CachedGDIBuildings.Length+CachedNodBuildings.Length;++I)
	{
		B=I<CachedGDIBuildings.Length ? CachedGDIBuildings[I]
			: CachedNodBuildings[I-CachedGDIBuildings.Length];
		if(B==None)
			continue;
		++Counts[B.GetTeamNum()];
		if(B.IsDestroyed())
			++Destroyed[B.GetTeamNum()];
	}
	GRI=Rx_GRI(RenxHud.WorldInfo.GRI);
	if(GRI!=None)
	{
		GDITeam=Rx_TeamInfo(GRI.Teams[TEAM_GDI]);
		NodTeam=Rx_TeamInfo(GRI.Teams[TEAM_NOD]);
	}
	DrawPanel(X,Y,W,54*S,PanelColor);
	DrawTextAt("GDI BUILDINGS  "$(Counts[0]-Destroyed[0])$"/"$Counts[0],
		X+10*S,Y+8*S,GDIColor,0.48*S,0);
	DrawTextAt("NOD BUILDINGS  "$(Counts[1]-Destroyed[1])$"/"$Counts[1],
		X+W-10*S,Y+8*S,NodColor,0.48*S,2);
	if(GDITeam!=None && NodTeam!=None)
		DrawTextAt("HARV  "$(GDITeam.bHasHarv ? (GDITeam.CurrentHarvester!=None ? "ACTIVE" : "DOWN") : "N/A")
			$"     "$(NodTeam.bHasHarv ? (NodTeam.CurrentHarvester!=None ? "ACTIVE" : "DOWN") : "N/A"),
			X+W*0.5,Y+22*S,ColorWhite,0.34*S,1);
	DrawTextAt("TAB  CLOSE SCOREBOARD",X+W*0.5,Y+38*S,NeutralColor,0.34*S,1);
}

function DrawBuildingStrip()
{
	local float S, CommandW, CommandX, Y, CellSize, Gap, X;

	RefreshBuildingCache();
	S=GetScale();
	CommandW=190*S;
	CommandX=(Canvas.SizeX-CommandW)*0.5+LayoutHorizontalOffset*S;
	Y=Canvas.SizeY-(30+LayoutVerticalSafeZone-LayoutVerticalOffset)*S;
	CellSize=25*S;
	Gap=2*S;
	X=CommandX-Gap-CachedGDIBuildings.Length*(CellSize+Gap);
	DrawNormalBuildingIcons(CachedGDIBuildings,X,Y,CellSize,Gap);
	DrawNormalBuildingIcons(CachedNodBuildings,CommandX+CommandW+Gap,Y,CellSize,Gap);
}

function RefreshBuildingCache()
{
	local Rx_Building B;

	if(bBuildingCacheReady && CachedBuildingWorld==RenxHud.WorldInfo
		&& RenxHud.WorldInfo.TimeSeconds<NextBuildingCacheTime)
		return;
	CachedGDIBuildings.Length=0;
	CachedNodBuildings.Length=0;
	CachedBuildingWorld=RenxHud.WorldInfo;
	foreach RenxHud.WorldInfo.AllActors(class'Rx_Building',B)
	{
		if(!IsBuildingReady(B) || !B.bSignificant || B.GetTeamNum()>TEAM_NOD
			|| Rx_Building_AirTower(B)!=None)
			continue;
		if(B.GetTeamNum()==TEAM_GDI)
			CachedGDIBuildings.AddItem(B);
		else
			CachedNodBuildings.AddItem(B);
	}
	NextBuildingCacheTime=RenxHud.WorldInfo.TimeSeconds+1.0;
	bBuildingCacheReady=true;
}

function DrawNormalBuildingIcons(array<Rx_Building> Buildings, float X, float Y,
	float CellSize, float Gap)
{
	local Rx_Building B;
	local int I;
	local float ArmorPct;
	local Color C;

	for(I=0;I<Buildings.Length;++I)
	{
		B=Buildings[I];
		C=ColorWhite;
		// RenX buildings lose armor before health. The bottom-strip warning is
		// therefore keyed to the first damage stage, not the later health stage.
		ArmorPct=B.GetMaxArmor()>0
			? FClamp(float(B.GetArmor())/B.GetMaxArmor(),0.0,1.0) : 1.0;
		if(B.IsDestroyed())
		{
			C.R=105; C.G=110; C.B=115; C.A=215;
		}
		else if(ArmorPct<0.20)
		{
			C.R=255; C.G=55; C.B=45; C.A=255;
		}
		DrawPanel(X+I*(CellSize+Gap),Y,CellSize,CellSize,PanelColor);
		if(B.IconTexture!=None)
			DrawTextureFit(B.IconTexture,X+I*(CellSize+Gap)+2*GetScale(),Y+2*GetScale(),
				CellSize-4*GetScale(),CellSize-4*GetScale(),C);
		else
			DrawTextAt(Left(Caps(B.GetBuildingName()),2),
				X+I*(CellSize+Gap)+CellSize*0.5,Y+7*GetScale(),C,0.32*GetScale(),1);
	}
}

function bool IsBuildingReady(Rx_Building B)
{
	if(B==None)
		return false;
	if(Rx_Building_Airstrip(B)!=None)
		return Rx_Building_Airstrip(B).AirTowerInternals!=None;
	return B.BuildingInternals!=None;
}

function Pawn GetDisplayPawn()
{
	local Rx_Controller PC;

	PC = Rx_Controller(RenxHud.PlayerOwner);
	if(PC == None)
		return Pawn(RenxHud.PlayerOwner.ViewTarget);
	if(PC.IsSpectating() && Pawn(PC.ViewTarget) != None)
		return Pawn(PC.ViewTarget);
	return PC.Pawn;
}

function Rx_PRI GetDisplayPRI()
{
	local Pawn P;

	P = GetDisplayPawn();
	if(P != None && Rx_PRI(P.PlayerReplicationInfo) != None)
		return Rx_PRI(P.PlayerReplicationInfo);
	return Rx_PRI(RenxHud.PlayerOwner.PlayerReplicationInfo);
}

function DrawSpectatorInfo()
{
	local Rx_Controller PC;
	local Pawn ViewedPawn;
	local float S, W, X, Y;
	local string ViewedName;

	PC=Rx_Controller(RenxHud.PlayerOwner);
	if(PC==None || !PC.IsSpectating())
		return;
	ViewedPawn=Pawn(PC.ViewTarget);
	if(ViewedPawn!=None && ViewedPawn.PlayerReplicationInfo!=None)
		ViewedName=ViewedPawn.PlayerReplicationInfo.GetHumanReadableName();
	else
		ViewedName="FREE CAMERA";
	S=GetScale();
	W=FMin(Canvas.SizeX*0.52,430*S);
	X=(Canvas.SizeX-W)*0.5+LayoutHorizontalOffset*S;
	Y=Canvas.SizeY*0.76+(LayoutVerticalOffset-LayoutVerticalSafeZone)*S;
	DrawPanel(X,Y,W,42*S,PanelColor);
	DrawTextAt("SPECTATING  "$ViewedName,X+W*0.5,Y+6*S,NeutralColor,0.5*S,1);
	DrawTextAt("FIRE: NEXT PLAYER   ALT-FIRE: PREVIOUS   JUMP: FREE CAMERA",
		X+W*0.5,Y+24*S,ColorWhite,0.32*S,1);
}

function DrawMatchInfo()
{
	local Rx_GRI GRI;
	local string TimerText, GameState;
	local int Seconds, Minutes;
	local float S, X, Y, W, H, TeamW;

	GRI = Rx_GRI(RenxHud.WorldInfo.GRI);
	if(GRI == None)
		return;

	S = GetScale();
	W = 190*S;
	H = 26*S;
	TeamW=48*S;
	X = (Canvas.SizeX - W) * 0.5+LayoutHorizontalOffset*S;
	Y = Canvas.SizeY-(30+LayoutVerticalSafeZone-LayoutVerticalOffset)*S;
	DrawPanel(X, Y, W, H, PanelColor);
	DrawAccent(X,Y,TeamW,2*S,GDIColor);
	DrawAccent(X+W-TeamW,Y,TeamW,2*S,NodColor);

	if(GRI.TimeLimit > 0)
		Seconds = Max(0, GRI.RemainingTime);
	else
		Seconds = Max(0, GRI.ElapsedTime);
	Minutes = Seconds / 60;
	TimerText = TwoDigits(Minutes) $ ":" $ TwoDigits(Seconds % 60);
	if(GRI.bMatchIsOver)
		GameState="GAME OVER";
	else if(GRI.bMatchHasBegun)
		GameState="ALL OUT WAR";
	else
		GameState="WARMUP";

	if(GRI.Teams[0] != None)
		DrawTextAt(string(Rx_TeamInfo(GRI.Teams[0]).GetRenScore()),
			X+TeamW*0.5,Y+3*S,GDIColor,0.45*S,1);
	if(GRI.Teams[1] != None)
		DrawTextAt(string(Rx_TeamInfo(GRI.Teams[1]).GetRenScore()),
			X+W-TeamW*0.5,Y+3*S,NodColor,0.45*S,1);
	RefreshTeamPlayerCounts();
	DrawTextAt(string(CachedTeamPlayerCounts[TEAM_GDI]),
		X+TeamW*0.5,Y+14*S,GDIColor,0.27*S,1);
	DrawTextAt(string(CachedTeamPlayerCounts[TEAM_NOD]),
		X+W-TeamW*0.5,Y+14*S,NodColor,0.27*S,1);
	DrawTextAt(GameState,X+W*0.5,Y+2*S,ColorWhite,0.38*S,1);
	DrawTextAt(TimerText,X+W*0.5,Y+13*S,ColorWhite,0.43*S,1);
}

function RefreshTeamPlayerCounts()
{
	local PlayerReplicationInfo PRI;

	if(RenxHud.WorldInfo.TimeSeconds<NextTeamCountRefreshTime)
		return;
	CachedTeamPlayerCounts[TEAM_GDI]=0;
	CachedTeamPlayerCounts[TEAM_NOD]=0;
	foreach RenxHud.WorldInfo.GRI.PRIArray(PRI)
	{
		if(Rx_PRI(PRI)!=None && !PRI.bIsSpectator && !Rx_PRI(PRI).bIsScripted
			&& PRI.GetTeamNum()>=TEAM_GDI && PRI.GetTeamNum()<=TEAM_NOD)
			++CachedTeamPlayerCounts[PRI.GetTeamNum()];
	}
	NextTeamCountRefreshTime=RenxHud.WorldInfo.TimeSeconds+0.5;
}

function DrawHudDataCounters()
{
	local Rx_PRI PRI;
	local Rx_TeamInfo TI;
	local float S, X, Y, RowH, IconW, IconH, ArtworkW, ArtworkH, TextX;

	if(MapRenderer==None || MapRenderer.MinimapSize<=0)
		return;
	PRI=GetDisplayPRI();
	if(PRI==None || PRI.Team==None)
		return;
	TI=Rx_TeamInfo(PRI.Team);
	if(TI==None)
		return;
	S=GetScale();
	X=MapRenderer.MinimapX;
	RowH=23*S;
	Y=MapRenderer.MinimapY-RowH*4-4*S;
	IconW=75*S;
	IconH=52.5*S;
	ArtworkW=IconW*0.3;
	ArtworkH=IconH*0.3;
	TextX=X+82*S;
	// Weapon and radar artwork is not square. Preserve its authored aspect
	// ratio inside a substantially larger counter-row icon box.
	// Keep the four text baselines unchanged. The enlarged resource artwork
	// occupies its own left column: mine above the split, vehicle below it.
	DrawTextureRegionAspect(ResourceMineIcon,X+1*S+(IconW-ArtworkW)*0.5,
		Y+RowH-IconH+(IconH-ArtworkH)*0.5,ArtworkW,ArtworkH,
		0.3671875,0.2578125,0.26953125,0.484375,ColorWhite);
	DrawTextAt(TI.MineCount$" / "$TI.MineLimit,
		TextX,Y+3*S,ColorWhite,0.48*S,0);
	if(PRI.GetTeamNum()==TEAM_GDI)
		DrawTextureRegionAspect(ResourceVehicleIcons[TEAM_GDI],
			X+1*S+(IconW-ArtworkW)*0.5,Y+RowH+(IconH-ArtworkH)*0.5,
			ArtworkW,ArtworkH,0.2265625,0.2109375,0.55078125,0.5703125,ColorWhite);
	else
		DrawTextureRegionAspect(ResourceVehicleIcons[TEAM_NOD],
			X+1*S+(IconW-ArtworkW)*0.5,Y+RowH+(IconH-ArtworkH)*0.5,
			ArtworkW,ArtworkH,0.2265625,0.1953125,0.55078125,0.609375,ColorWhite);
	DrawTextAt(TI.GetVehicleCount()$" / "$TI.VehicleLimit,
		TextX,Y+RowH+3*S,ColorWhite,0.48*S,0);
	DrawTextAt("$",TextX,Y+RowH*2+3*S,ColorWhite,0.60*S,0);
	DrawTextAt(string(int(PRI.GetCredits())),
		TextX+18*S,Y+RowH*2+3*S,ColorWhite,0.48*S,0);
	DrawTextAt("CP",TextX,Y+RowH*3+3*S,ColorWhite,0.46*S,0);
	DrawTextAt(int(TI.GetCommandPoints())$" / "$int(TI.GetMaxCommandPoints()),
		TextX+22*S,Y+RowH*3+3*S,ColorWhite,0.48*S,0);
}

function DrawPawnInfo()
{
	local Pawn P;
	local Rx_Pawn Infantry;
	local Rx_Vehicle VehiclePawn;
	local Rx_VehicleSeatPawn SeatPawn;
	local Rx_Vehicle Vehicle;
	local Rx_Vehicle_Weapon VehicleWeapon;
	local Rx_Vehicle_Weapon_Reloadable VehicleReloadable;
	local Rx_Vehicle_MultiWeapon MultiWeapon;
	local Rx_Weapon_Reloadable Reloadable;
	local Rx_Weapon Weapon;
	local Rx_Pawn Driver;
	local Rx_PRI PRI;
	local int Health, MaxHealth, Armor, MaxArmor, Ammo, Reserve, AltAmmo;
	local float S, X, Y, W, H, ReloadPct;
	local string WeaponName, ArmorLabel, AmmoText;

	P = GetDisplayPawn();
	if(P == None)
		return;
	PRI = GetDisplayPRI();

	Infantry = Rx_Pawn(P);
	VehiclePawn = Rx_Vehicle(P);
	SeatPawn = Rx_VehicleSeatPawn(P);
	if(VehiclePawn != None)
	{
		Vehicle = VehiclePawn;
		VehicleWeapon=Rx_Vehicle_Weapon(VehiclePawn.Weapon);
	}
	else if(SeatPawn != None)
	{
		Vehicle = Rx_Vehicle(SeatPawn.MyVehicle);
		VehicleWeapon=Rx_Vehicle_Weapon(SeatPawn.MyVehicleWeapon);
	}

	if(Infantry != None)
	{
		Health = Infantry.Health;
		MaxHealth = Infantry.HealthMax;
		Armor = Infantry.Armor;
		MaxArmor = Infantry.ArmorMax;
		Weapon = Rx_Weapon(Infantry.Weapon);
	}
	else if(Vehicle != None)
	{
		Health = Vehicle.Health;
		MaxHealth = Vehicle.HealthMax;
		Driver=Rx_Pawn(Vehicle.Driver);
		if(Driver!=None)
		{
			Armor=Driver.Health;
			MaxArmor=Driver.HealthMax;
		}
	}

	S = GetScale();
	W = 150*S;
	H = 150*S;
	X = (MapRenderer != None && MapRenderer.MinimapSize > 0)
		? MapRenderer.MinimapX+MapRenderer.MinimapSize+8*S
		: (12+LayoutHorizontalSafeZone+LayoutHorizontalOffset)*S;
	Y = Canvas.SizeY-H-(34+LayoutVerticalSafeZone-LayoutVerticalOffset)*S;
	if(MaxHealth>0 && float(Health)/MaxHealth<0.33)
	{
		Canvas.SetDrawColor(255,35,25,byte(150+80*Abs(Sin(RenxHud.WorldInfo.TimeSeconds*5))));
		Canvas.SetPos(X-2*S,Y-2*S);
		Canvas.DrawBox(W+4*S,H+4*S);
		DrawTextAt("CRITICAL",X+W-6*S,Y-28*S,NodColor,0.42*S,2);
	}
	if(PRI != None)
		DrawVeterancy(PRI,X+8*S,Y+7*S,W-16*S);

	DrawTextAt((Vehicle!=None ? "VEHICLE" : "HEALTH"),
		X+8*S,Y+72*S,HealthColor,0.36*S,0);
	DrawTextAt(Max(0,Health)$" / "$MaxHealth,
		X+W-8*S,Y+72*S,ColorWhite,0.38*S,2);
	DrawSegmentedStatusBar(X+8*S,Y+85*S,W-16*S,11*S,
		Health,MaxHealth,HealthColor,true);

	if(MaxArmor > 0)
	{
		ArmorLabel=Vehicle!=None ? "PILOT " : "ARMOR ";
		DrawTextAt(ArmorLabel,X+8*S,Y+105*S,ColorWhite,0.36*S,0);
		DrawTextAt(Max(0,Armor)$" / "$MaxArmor,
			X+W-8*S,Y+105*S,ColorWhite,0.38*S,2);
		DrawSegmentedStatusBar(X+8*S,Y+118*S,W-16*S,11*S,
			Armor,MaxArmor,ColorWhite,false);
	}
	if(PRI != None)
	{
		if(PRI.isSpotted())
			DrawTextAt("REVEALED",X+W-6*S,Y-54*S,NodColor,0.38*S,2);
	}

	if(Weapon != None || VehicleWeapon != None)
	{
		if(Weapon!=None)
		{
			WeaponName=Caps(Weapon.GetDisplayName());
			Reloadable=Rx_Weapon_Reloadable(Weapon);
			Ammo=Weapon.GetUseableAmmo();
			Reserve=Weapon.GetReserveAmmo();
			if(Reloadable!=None && Reloadable.IsReloading() && Reloadable.currentReloadTime>0)
				ReloadPct=FClamp((RenxHud.WorldInfo.TimeSeconds-Reloadable.reloadBeginTime)
					/Reloadable.currentReloadTime,0,1);
		}
		else
		{
			WeaponName=Caps(VehicleWeapon.ItemName);
			Ammo=VehicleWeapon.GetUseableAmmo();
			Reserve=VehicleWeapon.GetReserveAmmo();
			VehicleReloadable=Rx_Vehicle_Weapon_Reloadable(VehicleWeapon);
			MultiWeapon=Rx_Vehicle_MultiWeapon(VehicleWeapon);
			if(VehicleReloadable!=None && VehicleReloadable.CurrentlyReloading
				&& VehicleReloadable.currentReloadTime>0)
				ReloadPct=FClamp((RenxHud.WorldInfo.TimeSeconds-VehicleReloadable.reloadBeginTime)
					/VehicleReloadable.currentReloadTime,0,1);
			if(MultiWeapon!=None)
				AltAmmo=MultiWeapon.GetAltUseableAmmo();
		}

		W = 250*S;
		H = 98*S;
		Y = Canvas.SizeY-H-(12+LayoutVerticalSafeZone-LayoutVerticalOffset)*S;
		X = Canvas.SizeX-W-(12+LayoutHorizontalSafeZone-LayoutHorizontalOffset)*S;
		if(Weapon!=None && Weapon.WeaponIconTexture!=None)
			DrawTextureAspect(Weapon.WeaponIconTexture,X+W-112*S,Y+3*S,
				104*S,44*S,ColorWhite);
		else if(VehicleWeapon!=None && VehicleWeapon.PTIconPrimary!=None)
			DrawTextureAspect(VehicleWeapon.PTIconPrimary,X+W-112*S,Y+3*S,
				104*S,44*S,ColorWhite);
		DrawTextAt(WeaponName,X+W-8*S,Y+48*S,ColorWhite,0.54*S,2);
		if(Weapon!=None && Weapon.HasInfiniteAmmo())
			AmmoText=Ammo$" / 999";
		else if(MultiWeapon!=None)
			AmmoText=Ammo$" | "$AltAmmo;
		else
			AmmoText=Ammo$" / "$Reserve;
		DrawTextAt(AmmoText,X+W-8*S,Y+66*S,AmmoColor,0.92*S,2);
		if(ReloadPct>0)
		{
			DrawBar(X+20*S,Y+89*S,W-40*S,6*S,ReloadPct,1,AmmoColor);
			DrawTextAt("RELOADING",X+W-8*S,Y+82*S,NeutralColor,0.30*S,2);
		}

		if(Weapon!=None && P.InvManager!=None)
			DrawWeaponWheel(P,Weapon,X+W-50*S,Y-206*S,46*S,196*S);
		if(Infantry!=None)
			DrawAbilityStatus(Infantry,X,Y,W);
		if(Vehicle!=None)
			DrawVehicleStatus(Vehicle,X,Y,W);
	}
}

function DrawWeaponWheel(Pawn P, Rx_Weapon ActiveWeapon,
	float X, float Y, float W, float H)
{
	local Rx_Weapon WheelWeapon;
	local int I, Index, ActiveIndex, VisibleCount;
	local float S, CellH, IconSize, IconX, IconY;
	local Color IconColor;

	if(P==None || P.InvManager==None || ActiveWeapon==None)
		return;
	RefreshWeaponCache(P);
	if(CachedWeapons.Length==0)
		return;
	for(I=0;I<CachedWeapons.Length;++I)
		if(CachedWeapons[I]==ActiveWeapon)
		{
			ActiveIndex=I;
			break;
		}

	S=GetScale();
	// The equipped weapon is rendered once in the large main block. The
	// vertical carousel contains only the remaining weapons, ordered cyclically
	// after the active item so swapping produces a scrolling/zooming effect.
	VisibleCount=Min(6,CachedWeapons.Length-1);
	if(VisibleCount<=0)
		return;
	CellH=H/float(VisibleCount);
	for(I=0;I<VisibleCount;++I)
	{
		Index=(ActiveIndex+I+1)%CachedWeapons.Length;
		WheelWeapon=CachedWeapons[Index];
		if(WheelWeapon==None || WheelWeapon.WeaponIconTexture==None)
			continue;
		IconSize=FMin((38-I*1.4)*S,W-3*S);
		IconX=X+(W-IconSize)*0.5;
		IconY=Y+H-(I+0.5)*CellH-IconSize*0.5;
		IconColor=ColorWhite;
		IconColor.A=byte(Max(125,205-I*14));
		DrawTextureAspect(WheelWeapon.WeaponIconTexture,IconX,IconY,
			IconSize,IconSize,IconColor);
	}
}

function RefreshWeaponCache(Pawn P)
{
	local Inventory Inv;
	local Rx_Weapon Weapon;

	if(P==CachedWeaponOwner && RenxHud.WorldInfo.TimeSeconds<NextWeaponCacheTime)
		return;
	CachedWeaponOwner=P;
	CachedWeapons.Length=0;
	if(P!=None && P.InvManager!=None)
		for(Inv=P.InvManager.InventoryChain;Inv!=None;Inv=Inv.Inventory)
		{
			Weapon=Rx_Weapon(Inv);
			if(Weapon!=None && Weapon.WeaponIconTexture!=None)
				CachedWeapons.AddItem(Weapon);
		}
	NextWeaponCacheTime=RenxHud.WorldInfo.TimeSeconds+0.35;
}

function DrawInventoryCounts(Rx_PRI PRI, float X, float Y, float W)
{
	local float S;
	local string Counts;

	if(PRI==None)
		return;
	S=GetScale();
	Counts="AT "$PRI.ATMineNumber$"  C4 "$PRI.RemoteC4Number
		$"  PC4 "$PRI.PersonalProxyC4Number$"  DEF "$PRI.DeployedDefenseNumber
		$"/"$PRI.DeployedDefenseLimit;
	DrawTextAt(Counts,X+W-4*S,Y-41*S,NeutralColor,0.3*S,2);
}

function DrawVeterancy(Rx_PRI PRI, float X, float Y, float W)
{
	local int Rank, NextLevel, IconIndex;
	local float S, IconSize;
	local string VPText;

	Rank=PRI.GetVetRank();
	S=GetScale();
	if(Rank>=9)
		VPText="MAX VP";
	else if(Rank<ArrayCount(class'Rx_Game'.default.VPMilestones))
	{
		NextLevel=class'Rx_Game'.default.VPMilestones[Rank];
		VPText=int(PRI.Veterancy_Points)$" / "$NextLevel$" VP";
	}
	else
		VPText="MAX VP";
	DrawTextAt(VetRankStateName(Rank),X,Y,NeutralColor,0.50*S,0);
	DrawTextAt(VPText,X,Y+16*S,ColorWhite,0.38*S,0);
	IconIndex=Clamp(Rank/3,0,3);
	IconSize=51*S;
	if(VetRankTextures[IconIndex]!=None)
		DrawTextureFit(VetRankTextures[IconIndex],X+W-IconSize,Y+5*S,
			IconSize,IconSize,ColorWhite);
}

function DrawAbilityStatus(Rx_Pawn Infantry, float X, float Y, float W)
{
	local Rx_InventoryManager IM;
	local Rx_Weapon HeldWeapon;
	local Rx_WeaponAbility Ability;
	local float S, Progress;
	local Color TeamColor;
	local string AbilityName;

	IM=Rx_InventoryManager(Infantry.InvManager);
	HeldWeapon=Rx_Weapon(Infantry.Weapon);
	if(IM==None)
		return;
	if(HeldWeapon!=None && HeldWeapon.AttachedWeaponAbility!=None)
		Ability=HeldWeapon.AttachedWeaponAbility;
	else
		Ability=IM.GetIndexedAbility(0);
	if(Ability==None || !Ability.bShouldBeVisible())
		return;
	S=GetScale();
	Progress=Ability.GetRechargeTiming();
	TeamColor=Infantry.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor;
	DrawPanel(X+W-124*S,Y-42*S,124*S,36*S,PanelColor);
	DrawAccent(X+W-124*S,Y-42*S,124*S,2*S,TeamColor);
	if(Ability.WeaponIconTexture!=None)
		DrawTextureFit(Ability.WeaponIconTexture,X+W-120*S,Y-38*S,29*S,27*S,ColorWhite);
	AbilityName=Left(Caps(Ability.GetDisplayName()),15);
	DrawTextAt(AbilityName,X+W-5*S,Y-37*S,ColorWhite,0.31*S,2);
	DrawTextAt(int(Ability.CurrentCharges)$"/"$int(Ability.MaxCharges),
		X+W-5*S,Y-25*S,TeamColor,0.38*S,2);
	DrawBar(X+W-87*S,Y-14*S,80*S,5*S,Progress,1,TeamColor);
}

function DrawVehicleStatus(Rx_Vehicle Vehicle, float X, float Y, float W)
{
	local int i, Occupied;
	local float S;
	local string SeatText, LockText;

	SeatText="";
	for(i=0;i<Vehicle.Seats.Length;++i)
		if(Vehicle.GetSeatPRI(i)!=None)
		{
			++Occupied;
			if(Len(SeatText)<40)
				SeatText$=(SeatText=="" ? "" : ", ")$(i+1)$":"$Vehicle.GetSeatPRI(i).GetHumanReadableName();
		}
	S=GetScale();
	LockText=Vehicle.bDriverLocked ? "LOCKED" : "OPEN";
	if(Vehicle.BoundPRI!=None)
		LockText@="BOUND "$Vehicle.BoundPRI.GetHumanReadableName();
	DrawTextAt("SEATS "$Occupied$"/"$Vehicle.Seats.Length$"  "$LockText,
		X+W-4*S,Y-32*S,NeutralColor,0.34*S,2);
	DrawTextAt(SeatText,X+W-4*S,Y-19*S,ColorWhite,0.3*S,2);
}

function string VetRankName(int Rank)
{
	if(Rank >= 9)
		return "HEROIC";
	if(Rank >= 6)
		return "ELITE";
	if(Rank >= 3)
		return "VETERAN";
	return "RECRUIT";
}

function string VetRankStateName(int Rank)
{
	local string Result;
	local int Stage;

	Result=VetRankName(Rank);
	if(Rank>=9)
		return Result;
	Stage=Rank%3;
	if(Stage==1)
		Result@="I";
	else if(Stage==2)
		Result@="II";
	return Result;
}

function DrawMessages()
{
	local int I, HostRows, EVARows, ChatRows, KillRows, LinesDrawn;
	local float S, MS, MessageX, HostY, EVAY, ChatY, KillY, MaxMessageWidth;
	local Color C;

	S=GetScale();
	MS=S*LayoutMessageScale;
	HostRows=0;
	EVARows=0;
	ChatRows=0;
	KillRows=0;
	MessageX=(14+LayoutHorizontalSafeZone+LayoutHorizontalOffset)*S;
	MaxMessageWidth=Canvas.SizeX-MessageX-(14+LayoutHorizontalSafeZone)*S;
	HostY=(8+LayoutVerticalSafeZone+LayoutVerticalOffset)*S;
	EVAY=HostY+3*17*MS+6*MS;
	ChatY=EVAY+2*17*MS+7*MS;
	KillY=ChatY+7*17*MS+8*MS;
	for(I=Messages.Length-1;I>=0;--I)
	{
		C=Messages[I].TextColor;
		C.A=byte(FClamp(Messages[I].ExpireTime-RenxHud.WorldInfo.TimeSeconds,0,2)*127.5);
		if(Messages[I].Channel==6 || Messages[I].Channel==5)
		{
			if(HostRows<3)
			{
				LinesDrawn=DrawRichTextMessage(I,MessageX,HostY+HostRows*17*MS,
					FMin(Canvas.SizeX*0.62,MaxMessageWidth),C,Messages[I].Channel==5 ? 0.56*MS : 0.48*MS,
					3-HostRows);
				HostRows+=LinesDrawn;
			}
		}
		else if(Messages[I].Channel==2)
		{
			if(EVARows<2)
			{
				LinesDrawn=DrawRichTextMessage(I,MessageX,EVAY+EVARows*17*MS,
					FMin(Canvas.SizeX*0.58,MaxMessageWidth),C,0.46*MS,2-EVARows);
				EVARows+=LinesDrawn;
			}
		}
		else if(Messages[I].Channel==4)
		{
			if(KillRows<5)
			{
				LinesDrawn=DrawRichTextMessage(I,MessageX,KillY+KillRows*17*MS,
					FMin(Canvas.SizeX*0.54,MaxMessageWidth),C,0.46*MS,5-KillRows);
				KillRows+=LinesDrawn;
			}
		}
		else if(ChatRows<7)
		{
			LinesDrawn=DrawRichTextMessage(I,MessageX,ChatY+ChatRows*17*MS,
				FMin(Canvas.SizeX*0.58,MaxMessageWidth),C,0.46*MS,7-ChatRows);
			ChatRows+=LinesDrawn;
		}
	}
}

function int DrawRichTextMessage(int MessageIndex, float X, float Y, float MaxWidth,
	Color BaseColor, float Scale, optional int MaxLines=3)
{
	local string Remaining, Token;
	local int I, SpaceAt, LineCount;
	local float CursorX, XL, YL, S;
	local Color C;

	MaxLines=Max(1,MaxLines);
	if(MessageIndex<0 || MessageIndex>=Messages.Length)
		return 0;
	S=GetScale()*LayoutMessageScale;
	CursorX=X;
	for(I=0; I<Messages[MessageIndex].Runs.Length && LineCount<MaxLines; ++I)
	{
		Remaining=Messages[MessageIndex].Runs[I].Text;
		C=Messages[MessageIndex].Runs[I].TextColor;
		C.A=BaseColor.A;
		// Most color runs fit on one line. Render the complete run in one
		// submission and only fall back to word wrapping for genuinely long
		// spans.
		Canvas.TextSize(Remaining,XL,YL,Scale,Scale);
		if(XL<=MaxWidth)
		{
			if(CursorX+XL>X+MaxWidth && CursorX>X)
			{
				CursorX=X;
				++LineCount;
			}
			if(LineCount<MaxLines)
			{
				DrawTextAt(Remaining,CursorX,Y+LineCount*17*S,C,Scale,0);
				CursorX+=XL;
			}
			continue;
		}
		while(Remaining!="" && LineCount<MaxLines)
		{
			SpaceAt=InStr(Remaining," ");
			if(SpaceAt==INDEX_NONE)
			{
				Token=Remaining;
				Remaining="";
			}
			else
			{
				Token=Left(Remaining,SpaceAt+1);
				Remaining=Mid(Remaining,SpaceAt+1);
			}
			Canvas.TextSize(Token,XL,YL,Scale,Scale);
			if(CursorX+XL>X+MaxWidth && CursorX>X)
			{
				CursorX=X;
				++LineCount;
			}
			if(LineCount<MaxLines)
			{
				DrawTextAt(Token,CursorX,Y+LineCount*17*S,C,Scale,0);
				CursorX+=XL;
			}
		}
	}
	return Max(1,LineCount+1);
}

function ParseRichText(string Source, Color BaseColor, out array<CanvasTextRun> Runs)
{
	local CanvasTextRun Run;
	local string Tag, Chunk, HexColor;
	local int TagStart, TagEnd, HashAt;
	local Color CurrentColor;

	CurrentColor=BaseColor;
	while(Source!="")
	{
		TagStart=InStr(Source,"<");
		if(TagStart==INDEX_NONE)
		{
			Chunk=DecodeTextEntities(Source);
			Source="";
		}
		else if(TagStart>0)
		{
			Chunk=DecodeTextEntities(Left(Source,TagStart));
			Source=Mid(Source,TagStart);
		}
		else
		{
			TagEnd=InStr(Source,">");
			if(TagEnd==INDEX_NONE)
			{
				Chunk=DecodeTextEntities(Source);
				Source="";
			}
			else
			{
				Tag=Caps(Mid(Source,1,TagEnd-1));
				Source=Mid(Source,TagEnd+1);
				Chunk="";
				if(Left(Tag,5)=="FONT ")
				{
					HashAt=InStr(Tag,"#");
					if(HashAt!=INDEX_NONE)
					{
						HexColor=Mid(Tag,HashAt+1,6);
						CurrentColor=ColorFromMarkup(HexColor,BaseColor.A);
					}
				}
				else if(Left(Tag,5)=="/FONT")
					CurrentColor=BaseColor;
				else if(Left(Tag,2)=="BR")
					Chunk=" ";
			}
		}
		if(Chunk!="")
		{
			Run.Text=Chunk;
			Run.TextColor=CurrentColor;
			Runs.AddItem(Run);
		}
	}
}

function Color ColorFromMarkup(string HexColor, byte TextAlpha)
{
	local Color C;

	C.A=TextAlpha;
	switch(Caps(HexColor))
	{
		case "FFC600": C.R=255; C.G=198; C.B=0; break;
		case "FF0000": C.R=255; C.G=0; C.B=0; break;
		case "00FF00": C.R=0; C.G=255; C.B=0; break;
		case "00FF7F": C.R=0; C.G=255; C.B=127; break;
		case "2288FF": C.R=34; C.G=136; C.B=255; break;
		case "0055FF": C.R=0; C.G=85; C.B=255; break;
		case "22BBFF": C.R=34; C.G=187; C.B=255; break;
		case "E8DAEF": C.R=232; C.G=218; C.B=239; break;
		case "FFFF00": C.R=255; C.G=255; C.B=0; break;
		default: C.R=255; C.G=255; C.B=255; break;
	}
	return C;
}

function string DecodeTextEntities(string Text)
{
	Text=Repl(Text,"&lt;","<");
	Text=Repl(Text,"&gt;",">");
	Text=Repl(Text,"&#92;","\\");
	return Text;
}

function DrawVote()
{
	local string Counts;
	local string YesKey, NoKey;
	local float S, W, X, Y;
	local int SecondsLeft, TotalVotes;
	local Rx_PlayerInput RxPI;
	local Color TeamColor;

	if(VoteText == "")
		return;

	S = GetScale();
	W = FMin(Canvas.SizeX*0.68, 570*S);
	X = (Canvas.SizeX-W)*0.5+LayoutHorizontalOffset*S;
	Y = (61+LayoutVerticalSafeZone+LayoutVerticalOffset)*S;
	DrawPanel(X, Y, W, 61*S, PanelColor);
	TeamColor=RenxHud.PlayerOwner.GetTeamNum()==TEAM_GDI ? GDIColor : NodColor;
	DrawAccent(X,Y,W,3*S,TeamColor);
	DrawTextAt("VOTE IN PROGRESS",X+W*0.5,Y+6*S,TeamColor,0.44*S,1);
	DrawTextAt(VoteText, X+W*0.5, Y+23*S, ColorWhite, 0.53*S, 1);
	RxPI=Rx_PlayerInput(RenxHud.PlayerOwner.PlayerInput);
	if(RxPI!=None)
	{
		YesKey=RxPI.GetUDKBindNameFromCommand("voteyes");
		NoKey=RxPI.GetUDKBindNameFromCommand("voteno");
	}
	if(YesKey=="") YesKey="F1";
	if(NoKey=="") NoKey="F2";
	SecondsLeft=Max(0,FCeil(VoteExpireTime-RenxHud.WorldInfo.TimeSeconds));
	Counts="["$YesKey$"] YES "$VoteYes$"    ["$NoKey$"] NO "$VoteNo
		$"    NEEDED "$VoteNeeded$"    "$SecondsLeft$"s";
	DrawTextAt(Counts, X+W*0.5, Y+43*S, NeutralColor, 0.46*S, 1);
	TotalVotes=Max(1,VoteNeeded);
	DrawBar(X+7*S,Y+55*S,(W-16*S)*0.5,3*S,VoteYes,TotalVotes,HealthColor);
	DrawBar(X+W*0.5+1*S,Y+55*S,(W-16*S)*0.5,3*S,VoteNo,TotalVotes,NodColor);
}

function DrawTipsAndSubtitles()
{
	local float S;

	S = GetScale();
	if(SubtitleText != "")
		DrawTextAt(SubtitleText, Canvas.SizeX*0.5+LayoutHorizontalOffset*S,
			Canvas.SizeY*0.72+LayoutVerticalOffset*S, ColorWhite, 0.6*S, 1);
	if(GameplayTip != "")
		DrawTextAt(GameplayTip, Canvas.SizeX*0.5+LayoutHorizontalOffset*S,
			Canvas.SizeY*0.82+LayoutVerticalOffset*S, NeutralColor, 0.58*S, 1);
}

function DrawSideMenu()
{
	local int i;
	local float S, X, Y, W, H;

	if(!bShowSideMenu && !bShowHelp)
		return;

	S = GetScale();
	X = Canvas.SizeX*0.04+(LayoutHorizontalSafeZone+LayoutHorizontalOffset)*S;
	Y = Canvas.SizeY*0.18+(LayoutVerticalSafeZone+LayoutVerticalOffset)*S;
	W = FMin(Canvas.SizeX*0.43, 430*S);
	H = (bShowHelp ? HelpLines.Length : MenuOptions.Length) * 20*S + 30*S;
	DrawPanel(X, Y, W, H, PanelColor);

	if(bShowHelp)
	{
		DrawTextAt("HELP", X+12*S, Y+8*S, NeutralColor, 0.62*S, 0);
		for(i=0; i<HelpLines.Length; ++i)
			DrawTextAt(StripMarkup(HelpLines[i]), X+12*S, Y+(30+i*20)*S, ColorWhite, 0.48*S, 0);
	}
	else
	{
		DrawTextAt("COMMANDS", X+12*S, Y+8*S, NeutralColor, 0.62*S, 0);
		for(i=0; i<MenuOptions.Length; ++i)
			DrawTextAt(MenuOptions[i].Key @ StripMarkup(MenuOptions[i].Message), X+12*S, Y+(30+i*20)*S, ColorWhite, 0.5*S, 0);
	}
}

function DrawLoading()
{
	local float S, W, X, Y;

	if(!bShowLoading)
		return;

	S = GetScale();
	W = FMin(Canvas.SizeX*0.55, 430*S);
	X = (Canvas.SizeX-W)*0.5+LayoutHorizontalOffset*S;
	Y = Canvas.SizeY*0.72+LayoutVerticalOffset*S;
	DrawPanel(X, Y, W, 42*S, PanelColor);
	DrawBar(X+10*S, Y+23*S, W-20*S, 9*S, LoadingProgress, 1, NeutralColor);
	DrawTextAt(LoadingText, X+W*0.5, Y+5*S, ColorWhite, 0.5*S, 1);
}

function DrawHitMarker()
{
	local float S, X, Y, L;

	if(HitMarkerExpireTime <= RenxHud.WorldInfo.TimeSeconds)
		return;

	S = GetScale();
	X = Canvas.SizeX*0.5;
	Y = Canvas.SizeY*0.5;
	L = 7*S;
	Canvas.SetDrawColor(255,255,255,220);
	DrawLineRect(X-L-3*S, Y-L-3*S, X-3*S, Y-3*S, 2*S);
	DrawLineRect(X+3*S, Y-3*S, X+L+3*S, Y-L-3*S, 2*S);
	DrawLineRect(X-L-3*S, Y+L+3*S, X-3*S, Y+3*S, 2*S);
	DrawLineRect(X+3*S, Y+3*S, X+L+3*S, Y+L+3*S, 2*S);
}

function DrawLineRect(float X1, float Y1, float X2, float Y2, float Thickness)
{
	local int Steps, i;
	local float DX, DY;

	Steps = Max(1, int(FMax(Abs(X2-X1), Abs(Y2-Y1)) / FMax(1,Thickness)));
	DX = (X2-X1)/Steps;
	DY = (Y2-Y1)/Steps;
	for(i=0; i<=Steps; ++i)
	{
		Canvas.SetPos(X1+DX*i, Y1+DY*i);
		Canvas.DrawRect(Thickness, Thickness);
	}
}

function DrawPanel(float X, float Y, float W, float H, Color FillColor)
{
	Canvas.SetDrawColor(FillColor.R, FillColor.G, FillColor.B, FillColor.A);
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(W,H);
	// Generic panels should recede into the scene. Team color is applied by
	// the individual widgets; a cyan outline around every surface flattened
	// the entire HUD into one visual layer.
	Canvas.SetDrawColor(PanelBorderColor.R, PanelBorderColor.G, PanelBorderColor.B, PanelBorderColor.A);
	Canvas.SetPos(X,Y);
	Canvas.DrawBox(W,H);
}

function DrawAccent(float X, float Y, float W, float H, Color C)
{
	Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(W,H);
}

function DrawTextureFit(Texture T, float X, float Y, float W, float H, Color C)
{
	if(T==None)
		return;
	Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
	Canvas.SetPos(X,Y);
	Canvas.DrawTile(T,W,H,0,0,T.GetSurfaceWidth(),T.GetSurfaceHeight());
}

function DrawTextureAspect(Texture T, float X, float Y, float W, float H, Color C)
{
	local float SourceW, SourceH, DrawScale, DrawW, DrawH;

	if(T==None)
		return;
	SourceW=T.GetSurfaceWidth();
	SourceH=T.GetSurfaceHeight();
	if(SourceW<=0 || SourceH<=0)
		return;
	DrawScale=FMin(W/SourceW,H/SourceH);
	DrawW=SourceW*DrawScale;
	DrawH=SourceH*DrawScale;
	DrawTextureFit(T,X+(W-DrawW)*0.5,Y+(H-DrawH)*0.5,DrawW,DrawH,C);
}

function DrawTextureRegionAspect(Texture T, float X, float Y, float W, float H,
	float U, float V, float UL, float VL, Color C)
{
	local float SourceW, SourceH, RegionW, RegionH, DrawScale, DrawW, DrawH;

	if(T==None || UL<=0 || VL<=0)
		return;
	SourceW=T.GetSurfaceWidth();
	SourceH=T.GetSurfaceHeight();
	if(SourceW<=0 || SourceH<=0)
		return;
	RegionW=SourceW*UL;
	RegionH=SourceH*VL;
	DrawScale=FMin(W/RegionW,H/RegionH);
	DrawW=RegionW*DrawScale;
	DrawH=RegionH*DrawScale;
	Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
	Canvas.SetPos(X+(W-DrawW)*0.5,Y+(H-DrawH)*0.5);
	Canvas.DrawTile(T,DrawW,DrawH,SourceW*U,SourceH*V,RegionW,RegionH);
}

function DrawBar(float X, float Y, float W, float H, float Value, float MaxValue, Color FillColor)
{
	local float Pct;

	Pct = MaxValue > 0 ? FClamp(Value/MaxValue,0,1) : 0.0;
	Canvas.SetDrawColor(10,10,10,210);
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(FillColor.R,FillColor.G,FillColor.B,FillColor.A);
	Canvas.SetPos(X+1,Y+1);
	Canvas.DrawRect((W-2)*Pct,H-2);
}

function DrawSegmentedStatusBar(float X, float Y, float W, float H,
	float Value, float MaxValue, Color BaseColor, bool bHealthBar)
{
	local int I, FilledSegments, ActiveTriangle, InactiveTriangle;
	local float Pct, Gap, SegmentW, SegmentX, FilledWidth, S;
	local Color ActiveColor, InactiveColor, GlowColor;

	Pct=MaxValue>0 ? FClamp(Value/MaxValue,0,1) : 0.0;
	FilledSegments=Clamp(int(Pct*20.0+0.999),0,20);
	ActiveColor=BaseColor;
	if(bHealthBar)
	{
		if(Pct<0.10)
		{
			ActiveColor.R=255; ActiveColor.G=45; ActiveColor.B=35; ActiveColor.A=255;
		}
		else if(Pct<0.50)
		{
			ActiveColor.R=255; ActiveColor.G=205; ActiveColor.B=35; ActiveColor.A=255;
		}
	}
	InactiveColor.R=58; InactiveColor.G=62; InactiveColor.B=66; InactiveColor.A=220;
	GlowColor=ActiveColor;
	S=GetScale();
	Gap=2*S;
	SegmentW=(W-Gap*19)/20.0;

	// Glow the complete live portion twice, then draw each of the 20 segments
	// once. This preserves the bleed around the bar while avoiding two extra
	// rectangles for every filled segment.
	if(FilledSegments>0)
	{
		FilledWidth=FilledSegments*SegmentW+(FilledSegments-1)*Gap;
		GlowColor.A=35;
		Canvas.SetDrawColor(GlowColor.R,GlowColor.G,GlowColor.B,GlowColor.A);
		Canvas.SetPos(X-3*S,Y-3*S);
		Canvas.DrawRect(FilledWidth+6*S,H+6*S);
		GlowColor.A=105;
		Canvas.SetDrawColor(GlowColor.R,GlowColor.G,GlowColor.B,GlowColor.A);
		Canvas.SetPos(X-1.5*S,Y-1.5*S);
		Canvas.DrawRect(FilledWidth+3*S,H+3*S);
	}
	if(WhiteTexture==None)
	{
		for(I=0;I<20;++I)
		{
			SegmentX=X+I*(SegmentW+Gap);
			if(I<FilledSegments)
				Canvas.SetDrawColor(ActiveColor.R,ActiveColor.G,ActiveColor.B,ActiveColor.A);
			else
				Canvas.SetDrawColor(InactiveColor.R,InactiveColor.G,InactiveColor.B,InactiveColor.A);
			Canvas.SetPos(SegmentX,Y);
			Canvas.DrawRect(SegmentW,H);
		}
		return;
	}

	ActiveSegmentTriangles.Length=FilledSegments*2;
	InactiveSegmentTriangles.Length=(20-FilledSegments)*2;
	ActiveTriangle=0;
	InactiveTriangle=0;
	for(I=0;I<20;++I)
	{
		SegmentX=X+I*(SegmentW+Gap);
		if(I<FilledSegments)
		{
			SetRectTriangles(ActiveSegmentTriangles,ActiveTriangle,SegmentX,Y,SegmentW,H);
			ActiveTriangle+=2;
		}
		else
		{
			SetRectTriangles(InactiveSegmentTriangles,InactiveTriangle,SegmentX,Y,SegmentW,H);
			InactiveTriangle+=2;
		}
	}
	if(ActiveSegmentTriangles.Length>0)
	{
		Canvas.SetDrawColor(ActiveColor.R,ActiveColor.G,ActiveColor.B,ActiveColor.A);
		Canvas.DrawTris(WhiteTexture,ActiveSegmentTriangles,ActiveColor);
	}
	if(InactiveSegmentTriangles.Length>0)
	{
		Canvas.SetDrawColor(InactiveColor.R,InactiveColor.G,InactiveColor.B,InactiveColor.A);
		Canvas.DrawTris(WhiteTexture,InactiveSegmentTriangles,InactiveColor);
	}
}

function SetRectTriangles(out array<CanvasUVTri> Triangles, int TriangleIndex,
	float X, float Y, float W, float H)
{
	Triangles[TriangleIndex].V0_Pos.X=X;
	Triangles[TriangleIndex].V0_Pos.Y=Y;
	Triangles[TriangleIndex].V1_Pos.X=X+W;
	Triangles[TriangleIndex].V1_Pos.Y=Y;
	Triangles[TriangleIndex].V2_Pos.X=X+W;
	Triangles[TriangleIndex].V2_Pos.Y=Y+H;
	Triangles[TriangleIndex+1].V0_Pos.X=X;
	Triangles[TriangleIndex+1].V0_Pos.Y=Y;
	Triangles[TriangleIndex+1].V1_Pos.X=X+W;
	Triangles[TriangleIndex+1].V1_Pos.Y=Y+H;
	Triangles[TriangleIndex+1].V2_Pos.X=X;
	Triangles[TriangleIndex+1].V2_Pos.Y=Y+H;
}

function DrawTextAt(string Text, float X, float Y, Color TextColor, float Scale, byte Alignment)
{
	local float XL, YL;

	if(Text == "")
		return;
	if(Alignment!=0)
	{
		Canvas.TextSize(Text, XL, YL, Scale, Scale);
		if(Alignment == 1)
			X -= XL*0.5;
		else if(Alignment == 2)
			X -= XL;
	}
	Canvas.SetDrawColor(TextColor.R,TextColor.G,TextColor.B,TextColor.A);
	Canvas.SetPos(X,Y);
	Canvas.DrawText(Text,false,Scale,Scale,HUDTextRenderInfo);
}

function float GetScale()
{
	return FClamp(Canvas.SizeY/720.0, 0.62, 1.5)*LayoutGlobalScale;
}

function string TwoDigits(int Value)
{
	return Value < 10 ? "0"$Value : string(Value);
}

static function string StripMarkup(string Source)
{
	local string Result, C;
	local int i;
	local bool bInTag;

	Source = Repl(Source, "<br>", " ");
	Source = Repl(Source, "<br/>", " ");
	Source = Repl(Source, "&lt;", "<");
	Source = Repl(Source, "&gt;", ">");
	Source = Repl(Source, "&#92;", "\\");
	for(i=0; i<Len(Source); ++i)
	{
		C = Mid(Source,i,1);
		if(C == "<")
			bInTag = true;
		else if(C == ">")
			bInTag = false;
		else if(!bInTag)
			Result $= C;
	}
	return Result;
}

DefaultProperties
{
	LayoutGlobalScale=1.0
	LayoutMinimapScale=1.0
	LayoutMessageScale=1.0
	LayoutScoreboardScale=1.0
	LayoutOverviewScale=1.0
	WhiteTexture=Texture2D'EngineResources.WhiteSquareTexture'
	HUDFont=Font'RenxHud.Font.AgentConDB'
	PanelColor=(R=4,G=9,B=13,A=196)
	PanelBorderColor=(R=28,G=39,B=45,A=185)
	HealthColor=(R=76,G=190,B=55,A=255)
	ArmorColor=(R=40,G=170,B=230,A=255)
	AmmoColor=(R=245,G=245,B=230,A=255)
	GDIColor=(R=255,G=198,B=0,A=255)
	NodColor=(R=235,G=45,B=35,A=255)
	NeutralColor=(R=80,G=235,B=190,A=255)
	ResourceMineIcon=Texture2D'RX_HUD_Canvas.pt_menu.T_Icon_Weapon_ATMine'
	ResourceVehicleIcons(0)=Texture2D'RX_HUD_Canvas.pt_menu.T_Icon_Vehicles_GDI'
	ResourceVehicleIcons(1)=Texture2D'RX_HUD_Canvas.pt_menu.T_Icon_Vehicles_Nod'
	VetRankTextures(0)=Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Recruit'
	VetRankTextures(1)=Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Veteran'
	VetRankTextures(2)=Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Elite'
	VetRankTextures(3)=Texture2D'RenXTargetSystem.T_TargetSystem_Neutral_Heroic'
}
