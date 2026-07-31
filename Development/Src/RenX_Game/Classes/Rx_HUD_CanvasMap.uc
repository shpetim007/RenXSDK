/**
 * Shared Canvas renderer for the rotating minimap and north-up overview map.
 * Uses the map-authored UT/RenX MapInfo material and coordinate calibration.
 */
class Rx_HUD_CanvasMap extends Rx_Hud_Component;

var Rx_MapInfo MapInfo;
var Texture2D InfantryFriendlyIcon;
var Texture2D InfantryEnemyIcon;
var Texture2D InfantryNeutralIcon;
var Texture2D VehicleFriendlyIcon;
var Texture2D VehicleEnemyIcon;
var Texture2D VehicleNeutralIcon;
var Texture2D PlayerInfantryIcon;
var Texture2D PlayerVehicleIcon;
var Texture2D BuildingGDIIcon;
var Texture2D BuildingNodIcon;
var Texture2D TechIcon;

var float MinimapWorldRange;
var float MinimapX;
var float MinimapY;
var float MinimapSize;
var float OverviewX;
var float OverviewY;
var float OverviewSize;
var bool bMapFontRenderInfoReady;
var FontRenderInfo MapFontRenderInfo;
var Texture2D WhiteTexture;
var array<CanvasUVTri> InfantryHexTriangles;
var array<Pawn> CachedRadarPawns;
var array<Actor> CachedRadarActors;
var WorldInfo CachedRadarWorld;
var float NextRadarListRefreshTime;
var bool bRadarListReady;

function Update(float DeltaTime, Rx_HUD HUD)
{
	Super.Update(DeltaTime, HUD);
	if(!bMapFontRenderInfoReady && Canvas!=None)
	{
		MapFontRenderInfo=Canvas.CreateFontRenderInfo(false,false);
		MapFontRenderInfo.GlowInfo.bEnableGlow=true;
		MapFontRenderInfo.GlowInfo.GlowColor.R=0;
		MapFontRenderInfo.GlowInfo.GlowColor.G=0;
		MapFontRenderInfo.GlowInfo.GlowColor.B=0;
		MapFontRenderInfo.GlowInfo.GlowColor.A=0.62;
		MapFontRenderInfo.GlowInfo.GlowOuterRadius.X=0.22;
		MapFontRenderInfo.GlowInfo.GlowOuterRadius.Y=0.42;
		MapFontRenderInfo.GlowInfo.GlowInnerRadius.X=0.47;
		MapFontRenderInfo.GlowInfo.GlowInnerRadius.Y=0.52;
		bMapFontRenderInfoReady=true;
	}
	if(MapInfo == None && HUD.WorldInfo != None)
		MapInfo = Rx_MapInfo(HUD.WorldInfo.GetMapInfo());
	if(MapInfo != None && MapInfo.MapMaterialInstance == None)
		MapInfo.FindObjectives();
}

function DrawMinimap(Pawn CenterPawn)
{
	local float S;
	local rotator MapRotation;

	if(!CanDrawMap(CenterPawn))
		return;

	S = GetResolutionScale();
	MinimapSize = FClamp(Canvas.SizeY*0.245, 150*S, 244*S);
	MinimapX = 14*S;
	MinimapY = Canvas.SizeY-MinimapSize-12*S;
	MinimapWorldRange = GetMinimapRange();

	DrawMapFrame(MinimapX,MinimapY,MinimapSize,MinimapSize,false);
	Canvas.PushMaskRegion(MinimapX+2*S,MinimapY+2*S,MinimapSize-4*S,MinimapSize-4*S);

	MapInfo.ActualMapCenter = CenterPawn.Location;
	MapInfo.RadarRange = MinimapWorldRange;
	MapInfo.RadarWidth = MinimapSize;
	MapInfo.CenterPos.X = MinimapX+MinimapSize*0.5;
	MapInfo.CenterPos.Y = MinimapY+MinimapSize*0.5;
	MapInfo.MapScale = 1.5*MinimapSize/MapInfo.DefaultMapSize;
	// The authored minimap texture is rotated one quarter-turn from the
	// previous Canvas calibration. Rotate the terrain and marker basis
	// together so player-relative positions remain correct.
	MapRotation.Yaw = RenxHud.PlayerOwner.Rotation.Yaw;
	MapInfo.ChangeMapRotation(MapRotation);
	DrawSquareMinimapImage(CenterPawn);

	DrawRadarActors(CenterPawn,false);
	DrawPlayerMarker(CenterPawn,false);
	Canvas.PopMaskRegion();
	DrawCompassTicks();
}

function DrawOverview(Pawn CenterPawn, float X, float Y, float Size)
{
	local rotator MapRotation;
	local float OverviewZoom, ContentScale, DrawSize, DrawX, DrawY;

	if(!CanDrawMap(CenterPawn))
		return;

	OverviewX = X;
	OverviewY = Y;
	OverviewSize = Size;
	DrawMapFrame(X,Y,Size,Size);
	Canvas.PushMaskRegion(X+2,Y+2,Size-4,Size-4);

	// Enlarge the complete tactical-map coordinate space inside its existing
	// frame. Terrain and markers share DrawSize, so their registration stays
	// exact while unused authored margins are pushed outside the mask.
	ContentScale=1.22;
	DrawSize=Size*ContentScale;
	DrawX=X-(DrawSize-Size)*0.5;
	DrawY=Y-(DrawSize-Size)*0.5;
	OverviewZoom = GetOverviewZoom();
	MapInfo.ActualMapCenter = MapInfo.MapCenter;
	// The old overview's IconMatrix used MinimapNormalZoom /
	// (2 * MinimapCurrentZoom), and the authored OverviewScale affected the
	// whole map container. Keep the terrain and every marker in that same
	// coordinate space.
	MapInfo.RadarRange = MapInfo.MapExtent/OverviewZoom;
	MapInfo.RadarWidth = DrawSize;
	MapInfo.CenterPos.X = X+Size*0.5;
	MapInfo.CenterPos.Y = Y+Size*0.5;
	MapInfo.MapScale = 1.5*DrawSize/MapInfo.DefaultMapSize;
	// Align the UT marker basis with the authored RenX overview texture.
	// The final reference calibration is 90 degrees clockwise from the
	// previous half-turn correction.
	MapRotation.Yaw = MapInfo.MapYaw*182.044444+16384;
	MapInfo.ChangeMapRotation(MapRotation);
	MapInfo.DrawMapImage(Canvas,DrawX,DrawY,DrawSize,DrawSize,0,
		1.0/Max(0.1,MapInfo.OverviewScale));

	DrawRadarActors(CenterPawn,true);
	DrawBuildings(true,CenterPawn);
	DrawPlayerMarker(CenterPawn,true);
	Canvas.PopMaskRegion();
	DrawOverviewCompass();
}

function bool CanDrawMap(Pawn CenterPawn)
{
	return Canvas != None
		&& RenxHud != None
		&& MapInfo != None
		&& MapInfo.MapTexture != None
		&& CenterPawn != None
		&& MapInfo.MapExtent > 0;
}

function float GetMinimapRange()
{
	local float LegacyPixelsPerUU;

	// Scaleform positioned blips in a 2*MinimapRadius logical-pixel square
	// using MinimapScale / MinimapCurrentZoom pixels per world unit. Convert
	// that exact calibration into the Canvas radar range. The previous
	// MapExtent-derived approximation showed most of the level at once.
	if(MapInfo.MinimapScale > 0 && MapInfo.MinimapCurrentZoom > 0
		&& MapInfo.MinimapRadius > 0)
	{
		LegacyPixelsPerUU = MapInfo.MinimapScale/float(MapInfo.MinimapCurrentZoom);
		return (2.0*MapInfo.MinimapRadius)/LegacyPixelsPerUU;
	}
	return MapInfo.MapExtent*0.15;
}

function float GetOverviewZoom()
{
	// OverviewScale is the authored full-map zoom. Do not multiply it by the
	// rotating minimap's legacy 44/(2*32) factor: the terrain material does not
	// use that factor, so doing so pulls markers toward the center.
	return FClamp(Max(1.0,float(MapInfo.OverviewScale)),1.0,4.0);
}

function DrawSquareMinimapImage(Pawn CenterPawn)
{
	local float Overscan, DrawSize, DrawX, DrawY, BackgroundScale;
	local int PlayerYaw;

	if(MapInfo.MapTexture==None || MapInfo.MapMaterialInstance==None)
		return;

	// UDK's map material has the correct authored translation/rotation, but
	// includes a circular mask. Draw it larger than the square's diagonal and
	// compensate its texture zoom: the mask edge stays outside all four
	// corners while the visible map keeps the legacy player-centered scale.
	Overscan=1.50;
	DrawSize=MinimapSize*Overscan;
	DrawX=MinimapX-(DrawSize-MinimapSize)*0.5;
	DrawY=MinimapY-(DrawSize-MinimapSize)*0.5;
	BackgroundScale=(MinimapWorldRange/MapInfo.MapExtent)*Overscan;
	PlayerYaw=RenxHud.PlayerOwner.Rotation.Yaw & 65535;
	MapInfo.DrawMapImage(Canvas,DrawX,DrawY,DrawSize,DrawSize,
		PlayerYaw-(MapInfo.MapYaw*182.0444),BackgroundScale);
}

function DrawRadarActors(Pawn CenterPawn, bool bOverview)
{
	local int I;

	if(!bRadarListReady || CachedRadarWorld!=RenxHud.WorldInfo
		|| RenxHud.WorldInfo.TimeSeconds>=NextRadarListRefreshTime)
		RefreshRadarActorCache();

	for(I=0;I<CachedRadarPawns.Length;++I)
		if(CachedRadarPawns[I]!=None && CachedRadarPawns[I]!=CenterPawn)
			DrawRadarActor(CachedRadarPawns[I],CenterPawn,bOverview);
	for(I=0;I<CachedRadarActors.Length;++I)
		if(CachedRadarActors[I]!=None)
			DrawRadarActor(CachedRadarActors[I],CenterPawn,bOverview);
}

function RefreshRadarActorCache()
{
	local Actor A;
	local Pawn P;

	CachedRadarPawns.Length=0;
	CachedRadarActors.Length=0;
	CachedRadarWorld=RenxHud.WorldInfo;
	for(P=RenxHud.WorldInfo.PawnList;P!=None;P=P.NextPawn)
		if(RxIfc_RadarMarker(P)!=None)
			CachedRadarPawns.AddItem(P);
	foreach RenxHud.WorldInfo.DynamicActors(class'Actor',A,class'RxIfc_RadarMarker')
		if(Pawn(A)==None)
			CachedRadarActors.AddItem(A);
	NextRadarListRefreshTime=RenxHud.WorldInfo.TimeSeconds+0.25;
	bRadarListReady=true;
}

function DrawRadarActor(Actor A, Pawn CenterPawn, bool bOverview)
{
	local RxIfc_RadarMarker Marker;
	local vector MapPos;
	local Texture IconTexture;
	local float IconSize, GlowSize, DotRadius;
	local rotator IconRotation;
	local Color IconColor, GlowColor;
	local bool bRotateIcon, bInfantryMarker;

	if(A==None || A==CenterPawn || Rx_PRI(A)!=None)
		return;

	Marker=RxIfc_RadarMarker(A);
	if(Marker==None || !ShouldDrawMarker(A,Marker,CenterPawn,bOverview))
		return;

	if(bOverview)
		MapPos=MapInfo.UpdateHUDLocation(Marker.GetRadarActorLocation());
	else if(!GetMinimapMarkerPosition(Marker.GetRadarActorLocation(),CenterPawn,MapPos))
		return;

	IconTexture=Marker.GetMinimapIconTexture();
	IconSize=GetMarkerSize(A,bOverview);
	IconColor=GetActorColor(A,CenterPawn);
	// These colors deliberately sit near full luminance on both tactical maps.
	// The authored blip textures are mostly translucent, so the old mid-value
	// tints made even valid markers disappear into bright terrain.
	if(A.GetTeamNum()==TEAM_GDI)
	{
		IconColor.R=255; IconColor.G=245; IconColor.B=135; IconColor.A=255;
	}
	else if(A.GetTeamNum()==TEAM_NOD)
	{
		IconColor.R=255; IconColor.G=145; IconColor.B=135; IconColor.A=255;
	}
	else
	{
		IconColor.R=165; IconColor.G=255; IconColor.B=235; IconColor.A=255;
	}
	if(Rx_Vehicle(A)!=None)
	{
		if(A.GetTeamNum()==TEAM_GDI)
		{
			IconColor.R=255; IconColor.G=252; IconColor.B=170; IconColor.A=255;
		}
		else if(A.GetTeamNum()==TEAM_NOD)
		{
			IconColor.R=255; IconColor.G=170; IconColor.B=160; IconColor.A=255;
		}
		else
		{
			IconColor.R=255; IconColor.G=255; IconColor.B=255; IconColor.A=255;
		}
	}
	if(Marker.GetUseSquadMarker(CenterPawn.GetTeamNum(),0))
	{
		IconColor.R=165; IconColor.G=255; IconColor.B=235; IconColor.A=255;
		IconSize*=1.25;
	}

	// Scaleform's infantry blips were solid vector dots. Do not run infantry
	// through T_Radar_Blip_Infantry_Player: at these small sizes its filtered
	// transparent edge leaves only a fleeting sub-pixel center. A single
	// six-triangle Canvas hexagon remains solid at low resolution and submits
	// the whole marker in one native DrawTris call.
	bInfantryMarker=Marker.GetRadarIconType()==0 && Rx_Vehicle(A)==None;
	if(bInfantryMarker)
	{
		DotRadius=IconSize*0.68;
		DrawHexMarker(MapPos.X,MapPos.Y,DotRadius,IconColor);
		return;
	}

	IconRotation.Yaw=Marker.GetRadarActorRotation().Yaw
		-(bOverview ? MapInfo.CurrentMapRotYaw : RenxHud.PlayerOwner.Rotation.Yaw);
	// Vehicle artwork now uses the same un-offset facing basis on both maps.
	// Marker positions and map transforms are unchanged.

	bRotateIcon=IconTexture!=None || Rx_Vehicle(A)!=None;
	if(IconTexture==None)
		IconTexture=GetFallbackIcon(A,CenterPawn);
	if(IconTexture!=None)
	{
		// A broad translucent copy provides a readable halo without changing the
		// marker's calibrated center or its vehicle-facing transform.
		GlowColor=IconColor;
		GlowColor.A=105;
		GlowSize=IconSize*1.42;
		Canvas.SetDrawColor(GlowColor.R,GlowColor.G,GlowColor.B,GlowColor.A);
		Canvas.SetPos(MapPos.X-GlowSize*0.5,MapPos.Y-GlowSize*0.5);
		if(bRotateIcon)
			Canvas.DrawRotatedTile(IconTexture,IconRotation,GlowSize,GlowSize,0,0,
				IconTexture.GetSurfaceWidth(),IconTexture.GetSurfaceHeight());
		else
			Canvas.DrawTile(IconTexture,GlowSize,GlowSize,0,0,
				IconTexture.GetSurfaceWidth(),IconTexture.GetSurfaceHeight());

		Canvas.SetDrawColor(IconColor.R,IconColor.G,IconColor.B,IconColor.A);
		Canvas.SetPos(MapPos.X-IconSize*0.5,MapPos.Y-IconSize*0.5);
		if(bRotateIcon)
			Canvas.DrawRotatedTile(IconTexture,IconRotation,IconSize,IconSize,0,0,
				IconTexture.GetSurfaceWidth(),IconTexture.GetSurfaceHeight());
		else
			Canvas.DrawTile(IconTexture,IconSize,IconSize,0,0,
				IconTexture.GetSurfaceWidth(),IconTexture.GetSurfaceHeight());
	}
	else
	{
		GlowColor=IconColor;
		GlowColor.A=90;
		DrawDot(MapPos.X,MapPos.Y,IconSize*0.62,GlowColor);
		DrawDot(MapPos.X,MapPos.Y,IconSize*0.42,IconColor);
	}
}

function DrawHexMarker(float X, float Y, float Radius, Color C)
{
	local float HalfRadius, HexY;

	if(WhiteTexture==None)
		return;
	if(InfantryHexTriangles.Length!=6)
		InfantryHexTriangles.Length=6;
	HalfRadius=Radius*0.5;
	HexY=Radius*0.8660254;

	InfantryHexTriangles[0].V0_Pos.X=X; InfantryHexTriangles[0].V0_Pos.Y=Y;
	InfantryHexTriangles[0].V1_Pos.X=X+Radius; InfantryHexTriangles[0].V1_Pos.Y=Y;
	InfantryHexTriangles[0].V2_Pos.X=X+HalfRadius; InfantryHexTriangles[0].V2_Pos.Y=Y+HexY;
	InfantryHexTriangles[1].V0_Pos.X=X; InfantryHexTriangles[1].V0_Pos.Y=Y;
	InfantryHexTriangles[1].V1_Pos.X=X+HalfRadius; InfantryHexTriangles[1].V1_Pos.Y=Y+HexY;
	InfantryHexTriangles[1].V2_Pos.X=X-HalfRadius; InfantryHexTriangles[1].V2_Pos.Y=Y+HexY;
	InfantryHexTriangles[2].V0_Pos.X=X; InfantryHexTriangles[2].V0_Pos.Y=Y;
	InfantryHexTriangles[2].V1_Pos.X=X-HalfRadius; InfantryHexTriangles[2].V1_Pos.Y=Y+HexY;
	InfantryHexTriangles[2].V2_Pos.X=X-Radius; InfantryHexTriangles[2].V2_Pos.Y=Y;
	InfantryHexTriangles[3].V0_Pos.X=X; InfantryHexTriangles[3].V0_Pos.Y=Y;
	InfantryHexTriangles[3].V1_Pos.X=X-Radius; InfantryHexTriangles[3].V1_Pos.Y=Y;
	InfantryHexTriangles[3].V2_Pos.X=X-HalfRadius; InfantryHexTriangles[3].V2_Pos.Y=Y-HexY;
	InfantryHexTriangles[4].V0_Pos.X=X; InfantryHexTriangles[4].V0_Pos.Y=Y;
	InfantryHexTriangles[4].V1_Pos.X=X-HalfRadius; InfantryHexTriangles[4].V1_Pos.Y=Y-HexY;
	InfantryHexTriangles[4].V2_Pos.X=X+HalfRadius; InfantryHexTriangles[4].V2_Pos.Y=Y-HexY;
	InfantryHexTriangles[5].V0_Pos.X=X; InfantryHexTriangles[5].V0_Pos.Y=Y;
	InfantryHexTriangles[5].V1_Pos.X=X+HalfRadius; InfantryHexTriangles[5].V1_Pos.Y=Y-HexY;
	InfantryHexTriangles[5].V2_Pos.X=X+Radius; InfantryHexTriangles[5].V2_Pos.Y=Y;
	Canvas.DrawTris(WhiteTexture,InfantryHexTriangles,C);
}

function bool GetMinimapMarkerPosition(vector WorldLocation, Pawn CenterPawn,
	out vector MapPos)
{
	local vector Delta;
	local float F, PixelsPerUU, ResolutionFactor, LocalX, LocalY, HalfSize;

	if(MapInfo.MinimapCurrentZoom<=0 || MapInfo.MinimapRadius<=0)
		return false;

	// This is Rx_GFxMinimap's IconMatrix reduced to one player-relative
	// transform. MapYaw and UTMapInfo's rotation axes are intentionally absent:
	// applying either here would rotate marker positions a second time.
	Delta=WorldLocation-CenterPawn.Location;
	F=-float((RenxHud.PlayerOwner.Rotation.Yaw+16384) & 65535)*(Pi/32768.0);
	PixelsPerUU=MapInfo.MinimapScale/float(MapInfo.MinimapCurrentZoom);
	ResolutionFactor=MinimapSize/(2.0*float(MapInfo.MinimapRadius));
	LocalX=(Delta.X*Cos(F)-Delta.Y*Sin(F))*PixelsPerUU*ResolutionFactor;
	LocalY=(Delta.X*Sin(F)+Delta.Y*Cos(F))*PixelsPerUU*ResolutionFactor;
	HalfSize=MinimapSize*0.5-3*GetResolutionScale();
	if(Abs(LocalX)>HalfSize || Abs(LocalY)>HalfSize)
		return false;
	MapPos.X=MapInfo.CenterPos.X+LocalX;
	MapPos.Y=MapInfo.CenterPos.Y+LocalY;
	MapPos.Z=0;
	return true;
}

function bool ShouldDrawMarker(Actor A, RxIfc_RadarMarker Marker, Pawn CenterPawn, bool bOverview)
{
	local bool bEnemy, bSpotted;

	if(Pawn(A) != None && Pawn(A).Health <= 0)
		return false;
	if(Rx_Pawn(A) != None && Rx_Pawn(A).DrivenVehicle != None)
		return false;

	bEnemy = IsEnemy(A,CenterPawn);
	bSpotted = RenxHud.SpotTargets.Find(A) != INDEX_NONE;
	if(bEnemy && !RenxHud.PlayerOwner.IsSpectating())
	{
		// A direct Q spot is authoritative for its normal ten-second lifetime,
		// including enemy vehicles that would otherwise fail stealth/radar
		// visibility checks.
		if(A.IsInState('Stealthed') && !bSpotted)
			return false;
		if(Marker.GetRadarVisibility() != 2
			&& !Marker.ForceVisible()
			&& !bSpotted
			&& (RenxHud.TargetingBox == None
				|| RenxHud.TargetingBox.TargetedActor == None
				|| RenxHud.TargetingBox.TargetedActor.GetActualTarget() != A))
			return false;
	}

	return true;
}

function DrawPlayerMarker(Pawn CenterPawn, bool bOverview)
{
	local vector P;
	local Texture2D Icon;
	local float Size, GlowSize;
	local rotator R;
	local Color IconColor, GlowColor;

	P = bOverview ? MapInfo.UpdateHUDLocation(CenterPawn.Location) : MapInfo.CenterPos;
	Icon = Rx_Vehicle(CenterPawn) != None ? PlayerVehicleIcon : PlayerInfantryIcon;
	Size = bOverview ? 18*GetResolutionScale() : 13*GetResolutionScale();
	IconColor.R=175; IconColor.G=255; IconColor.B=235; IconColor.A=255;
	if(Icon != None)
	{
		R.Yaw = CenterPawn.Rotation.Yaw-MapInfo.CurrentMapRotYaw;
		GlowColor=IconColor;
		GlowColor.A=110;
		GlowSize=Size*1.45;
		Canvas.SetDrawColor(GlowColor.R,GlowColor.G,GlowColor.B,GlowColor.A);
		Canvas.SetPos(P.X-GlowSize*0.5,P.Y-GlowSize*0.5);
		Canvas.DrawRotatedTile(Icon,R,GlowSize,GlowSize,0,0,Icon.SizeX,Icon.SizeY);
		Canvas.SetDrawColor(IconColor.R,IconColor.G,IconColor.B,IconColor.A);
		Canvas.SetPos(P.X-Size*0.5,P.Y-Size*0.5);
		Canvas.DrawRotatedTile(Icon,R,Size,Size,0,0,Icon.SizeX,Icon.SizeY);
	}
	else
	{
		GlowColor=IconColor;
		GlowColor.A=90;
		DrawDot(P.X,P.Y,Size*0.60,GlowColor);
		DrawDot(P.X,P.Y,Size*0.38,IconColor);
	}
	if(bOverview)
		DrawPlayerDirectionArrow(CenterPawn,P,Size);
}

function DrawBuildings(bool bOverview, Pawn CenterPawn)
{
	local Rx_Building B;
	local vector P;
	local Color C;
	local float Size, HealthPct, ArmorPct;

	Size = (bOverview ? 11 : 8)*GetResolutionScale();
	foreach RenxHud.WorldInfo.AllActors(class'Rx_Building',B)
	{
		if(!IsBuildingReady(B))
			continue;
		// The Airstrip's separate tower actor shares its health with the
		// Airstrip and inherits the generic wrench icon. The legacy overview
		// intentionally listed only the Airstrip vehicle-factory actor.
		if(bOverview && Rx_Building_AirTower(B)!=None)
			continue;
		if(bOverview && Rx_Building_Silo(B)==None)
			continue;
		if(!bOverview && VSize2D(B.Location-CenterPawn.Location)>MinimapWorldRange*0.55)
			continue;
		if(!B.bSignificant)
			Size=(bOverview ? 8 : 6)*GetResolutionScale();
		else
			Size=(bOverview ? 11 : 8)*GetResolutionScale();
		P = MapInfo.UpdateHUDLocation(B.Location);
		if(B.GetTeamNum()==TEAM_GDI)
			C=GDIColor();
		else if(B.GetTeamNum()==TEAM_NOD)
			C=NodColor();
		else
		{
			// Unowned Silos need to remain obvious against the dark map.
			C.R=235; C.G=240; C.B=245; C.A=255;
		}
		if(B.IsDestroyed())
			C.A = 90;
		if(bOverview && Rx_Building_Silo(B)!=None && B.IconTexture!=None)
		{
			Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
			Canvas.SetPos(P.X-Size,P.Y-Size);
			Canvas.DrawTile(B.IconTexture,Size*2.0,Size*2.0,0,0,
				B.IconTexture.GetSurfaceWidth(),B.IconTexture.GetSurfaceHeight());
		}
		else
			DrawBuildingDot(P.X,P.Y,Size,C,B.IsDestroyed());
		if(bOverview && Rx_Building_Silo(B)!=None)
			continue;
		if(B.IsDestroyed())
		{
			Canvas.SetDrawColor(230,230,230,150);
			DrawLine(P.X-Size*0.28,P.Y-Size*0.28,P.X+Size*0.28,P.Y+Size*0.28,1.0);
			DrawLine(P.X+Size*0.28,P.Y-Size*0.28,P.X-Size*0.28,P.Y+Size*0.28,1.0);
		}
		else if(bOverview)
		{
			HealthPct=B.GetMaxHealth()>0
				? FClamp(float(B.GetHealth())/B.GetMaxHealth(),0,1) : 0.0;
			Canvas.SetPos(P.X-Size*0.5,P.Y+Size*0.62);
			Canvas.DrawRect(Size*HealthPct,2);
			if(B.GetMaxArmor()>0)
			{
				ArmorPct=FClamp(float(B.GetArmor())/B.GetMaxArmor(),0,1);
				Canvas.SetDrawColor(40,170,230,230);
				Canvas.SetPos(P.X-Size*0.5,P.Y+Size*0.84);
				Canvas.DrawRect(Size*ArmorPct,2);
			}
		}
	}
}

function DrawPlayerDirectionArrow(Pawn CenterPawn, vector PlayerPos, float MarkerSize)
{
	local vector Ahead, Direction, Perpendicular, Tip, Base, LeftPoint, RightPoint;
	local Color C;

	Ahead=MapInfo.UpdateHUDLocation(CenterPawn.Location+Vector(CenterPawn.Rotation)*1000.0);
	Direction=Ahead-PlayerPos;
	Direction.Z=0;
	if(VSize2D(Direction)<0.01)
		return;
	Direction=Normal(Direction);
	Perpendicular.X=-Direction.Y;
	Perpendicular.Y=Direction.X;
	Tip=PlayerPos+Direction*MarkerSize*1.05;
	Base=PlayerPos-Direction*MarkerSize*0.28;
	LeftPoint=Base+Perpendicular*MarkerSize*0.42;
	RightPoint=Base-Perpendicular*MarkerSize*0.42;
	C.R=80; C.G=255; C.B=160; C.A=255;
	Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
	DrawLine(Tip.X,Tip.Y,LeftPoint.X,LeftPoint.Y,2.0);
	DrawLine(Tip.X,Tip.Y,RightPoint.X,RightPoint.Y,2.0);
	DrawLine(LeftPoint.X,LeftPoint.Y,RightPoint.X,RightPoint.Y,1.0);
}

function DrawOverviewCompass()
{
	local float S, Pad;

	S=GetResolutionScale();
	Pad=4*S;
	DrawSmallText("N",OverviewX+OverviewSize*0.5,OverviewY+Pad,1);
	DrawSmallText("S",OverviewX+OverviewSize*0.5,OverviewY+OverviewSize-12*S,1);
	DrawSmallText("W",OverviewX+Pad,OverviewY+OverviewSize*0.5-4*S,0);
	DrawSmallText("E",OverviewX+OverviewSize-Pad,OverviewY+OverviewSize*0.5-4*S,2);
}

function bool IsBuildingReady(Rx_Building B)
{
	if(B==None)
		return false;
	if(Rx_Building_Airstrip(B)!=None)
		return Rx_Building_Airstrip(B).AirTowerInternals!=None;
	return B.BuildingInternals!=None;
}

function DrawCompassTicks()
{
	local float S, X, Y;
	local int Degrees;
	local string Heading;

	S = GetResolutionScale();
	X = MinimapX+MinimapSize*0.5;
	Y = MinimapY+5*S;
	Degrees = int(float(RenxHud.PlayerOwner.Rotation.Yaw & 65535)*360.0/65536.0);
	if(Degrees >= 315 || Degrees < 45)
		Heading = "N";
	else if(Degrees < 135)
		Heading = "E";
	else if(Degrees < 225)
		Heading = "S";
	else
		Heading = "W";
	Canvas.Font = Font'RenxHud.Font.AgentConDB';
	DrawSmallText(Heading@" "$Degrees$Chr(176),X,Y,1);
}

function DrawMapFrame(float X, float Y, float W, float H, optional bool bShowTeamAccent=true)
{
	local Color Accent;
	local Pawn P;

	P=Pawn(RenxHud.PlayerOwner.ViewTarget);
	Accent=(P != None && P.GetTeamNum()==TEAM_NOD) ? NodColor() : GDIColor();
	Canvas.SetDrawColor(2,8,13,218);
	Canvas.SetPos(X,Y);
	Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(22,32,39,235);
	Canvas.SetPos(X,Y);
	Canvas.DrawBox(W,H);
	if(bShowTeamAccent)
	{
		Canvas.SetDrawColor(Accent.R,Accent.G,Accent.B,220);
		Canvas.SetPos(X+1,Y+H-2);
		Canvas.DrawRect(W-2,2);
	}
}

function DrawDot(float X, float Y, float Radius, Color C)
{
	local int I, Steps;
	local float DY, HalfWidth, RowHeight;

	Steps=6;
	RowHeight=Max(1.0,(2.0*Radius)/float(2*Steps+1));
	Canvas.SetDrawColor(C.R,C.G,C.B,C.A);
	for(I=-Steps; I<=Steps; ++I)
	{
		DY=float(I)/float(Steps);
		HalfWidth=Sqrt(FMax(0.0,1.0-DY*DY))*Radius;
		Canvas.SetPos(X-HalfWidth,Y+DY*Radius-RowHeight*0.5);
		Canvas.DrawRect(2.0*HalfWidth,RowHeight+0.5);
	}
}

function DrawBuildingDot(float X, float Y, float Size, Color C, bool bDestroyed)
{
	local Color Shadow;

	Shadow.R=2; Shadow.G=6; Shadow.B=9; Shadow.A=220;
	DrawDot(X,Y,Size*0.58,Shadow);
	if(bDestroyed)
		C.A=95;
	DrawDot(X,Y,Size*0.42,C);
}

function DrawLine(float X1, float Y1, float X2, float Y2, float Thickness)
{
	local int I, Steps;
	local float DX, DY;

	Steps=Max(1,int(FMax(Abs(X2-X1),Abs(Y2-Y1))/FMax(1.0,Thickness)));
	DX=(X2-X1)/Steps;
	DY=(Y2-Y1)/Steps;
	for(I=0; I<=Steps; ++I)
	{
		Canvas.SetPos(X1+DX*I,Y1+DY*I);
		Canvas.DrawRect(Thickness,Thickness);
	}
}

function DrawSmallText(string Text, float X, float Y, byte Alignment)
{
	local float XL,YL,S;

	S = 0.48*GetResolutionScale();
	Canvas.TextSize(Text,XL,YL,S,S);
	if(Alignment == 1)
		X -= XL*0.5;
	else if(Alignment == 2)
		X -= XL;
	Canvas.SetDrawColor(235,245,255,255);
	Canvas.SetPos(X,Y);
	Canvas.DrawText(Text,false,S,S,MapFontRenderInfo);
}

function bool IsEnemy(Actor A, Pawn CenterPawn)
{
	return (A.GetTeamNum() == TEAM_GDI || A.GetTeamNum() == TEAM_NOD)
		&& A.GetTeamNum() != CenterPawn.GetTeamNum();
}

function Color GetActorColor(Actor A, Pawn CenterPawn)
{
	if(A.GetTeamNum()==TEAM_GDI)
		return GDIColor();
	if(A.GetTeamNum()==TEAM_NOD)
		return NodColor();
	return NeutralColor();
}

function float GetMarkerSize(Actor A, bool bOverview)
{
	local float S;

	S = GetResolutionScale();
	if(Rx_Vehicle(A) != None)
		return (bOverview ? 14 : 12)*S;
	if(Rx_Weapon_DeployedBeacon(A) != None)
		return (bOverview ? 13 : 15)*S;
	return (bOverview ? 8 : 6)*S;
}

function Texture GetFallbackIcon(Actor A, Pawn CenterPawn)
{
	if(Rx_Vehicle(A) != None)
	{
		if(IsEnemy(A,CenterPawn))
			return VehicleEnemyIcon;
		if(A.GetTeamNum() == CenterPawn.GetTeamNum())
			return VehicleFriendlyIcon;
		return VehicleNeutralIcon;
	}
	if(IsEnemy(A,CenterPawn))
		return InfantryEnemyIcon;
	if(A.GetTeamNum() == CenterPawn.GetTeamNum())
		return InfantryFriendlyIcon;
	return InfantryNeutralIcon;
}

function float GetResolutionScale()
{
	return FClamp(Canvas.SizeY/720.0,0.67,1.5);
}

function Color GDIColor()
{
	local Color C;
	C.R=255; C.G=198; C.B=0; C.A=255;
	return C;
}

function Color NodColor()
{
	local Color C;
	C.R=240; C.G=45; C.B=35; C.A=255;
	return C;
}

function Color NeutralColor()
{
	local Color C;
	C.R=80; C.G=235; C.B=190; C.A=255;
	return C;
}

DefaultProperties
{
	WhiteTexture=Texture2D'EngineResources.WhiteSquareTexture'
	// Reuse the filtered legacy blip artwork for Canvas fallbacks instead of
	// drawing stepped procedural rectangles. Team color is applied at draw time.
	VehicleFriendlyIcon=Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'
	VehicleEnemyIcon=Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'
	VehicleNeutralIcon=Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'
	InfantryFriendlyIcon=Texture2D'RenxHud.T_Radar_Blip_Infantry_Player'
	InfantryEnemyIcon=Texture2D'RenxHud.T_Radar_Blip_Infantry_Player'
	InfantryNeutralIcon=Texture2D'RenxHud.T_Radar_Blip_Infantry_Player'
	PlayerInfantryIcon=Texture2D'RenxHud.T_Radar_Blip_Infantry_Player'
	PlayerVehicleIcon=Texture2D'RenxHud.T_Radar_Blip_Vehicle_Player'
}
