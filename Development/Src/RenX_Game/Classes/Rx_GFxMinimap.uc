/*********************************************************
*
* File: Rx_GfxMinimap.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc: This class handles the creation and modification of the 
* Minimap in the Rx_GfxHud.uc
*
* ConfigFile: 
*
*********************************************************
*  
*********************************************************/

class Rx_GFxMinimap extends GFxObject;

var		 Rx_GfxHUD               RxHUD;
var		 WorldInfo				 ThisWorld;
var		 Rx_MapInfo				 RxMapInfo;
var      UTPlayerController      RxPC;
var		 int                     MapTexSize;
//var 	 float					 UIScale;

var		 GFxObject               player_icon;

enum ENUM_ICON
{
	ICON_INFANTRY,
	ICON_VEHICLE,
	ICON_MISC 
};

var		 GFxObject               compass;
var		 GFxObject               icons_NavMarker;
var		 GFxObject               icons_Neutral;
var		 GFxObject               icons_Enemy;
var		 GFxObject               icons_Friendly;
var		 GFxObject               icons_NeutralVehicle;
var		 GFxObject               icons_NodVehicle;
var		 GFxObject               icons_GDIVehicle;
var		 GFxObject               map;
var		 string                  mapImagePath;
var		 array<GFxObject>        iconCounts;
var		 matrix                  IconMatrix;

var		 array<GFxObject>        GDITeamIcons;
var		 array<GFxObject>        GDIVehicleIcons;
var		 array<GFxObject>        NodTeamIcons;
var		 array<GFxObject>        NodVehicleIcons;
var		 array<GFxObject>        NeutralIcons;
var		 array<GFxObject>        NeutralVehicleIcons;

var		 int                     IconsEnemyCount;
var		 int                     IconsVehicleEnemyCount;
var		 int                     IconsFriendlyCount;
var		 int                     IconsVehicleFriendlyCount;
var		 int                     IconsNeutralCount;
var		 int                     IconsVehicleNeutralCount;

var		 float                   IconRotationOffset;

/**Use this only for debugging blips*/
var     Texture                 DebugBlipTexture;
var     float					CompassDir;

//Icon data
var array<Actor> GDIActorIcons;
var array<Actor> GDIVehicleActorIcons;
var array<Actor> NodActorIcons;
var array<Actor> NodVehicleActorIcons;
var array<Actor> NeutralActorIcons;
var array<Actor> NeutralVehicleActorIcons;
var array<Actor> SquadActorIcons;
var array<Actor> SquadVehiclesActorIcons; 
var float LastUpdateTime;
var float UpdateTime;


function init(Rx_GFxHud h)
{
	RxHUD                =  h;
	RxPC                 =  UTPlayerController(GetPC());
	ThisWorld            =  RxPC.WorldInfo;
	RxMapInfo            =  Rx_MapInfo(ThisWorld.GetMapInfo());

	player_icon          =  GetObject("player");
	compass              =  GetObject("compass");


	map = GetObject("map"); 
	if (RxMapInfo.MapTexture != none) {
		MapTexSize       =  Texture2D(RxMapInfo.MapTexture).SizeX;
		LoadMapTexture("img://" $PathName(RxMapInfo.MapTexture));
	}

	icons_Enemy          =  GetObject("icons_Nod");
	icons_Friendly       =  GetObject("icons_GDI");
	icons_Neutral        =  GetObject("icons_Neutral");
	icons_NodVehicle     =  GetObject("icons_NodVehicle");                       
	icons_GDIVehicle     =  GetObject("icons_GDIVehicle");                       
	icons_NeutralVehicle =	GetObject("icons_NeutralVehicle");               
	icons_NavMarker      =  GetObject("icons_nav");

}

function LoadMapTexture(string mapPathName)
{
	map.ActionScriptVoid("loadMapTexture");
}

function LoadTexture(string pathName, GFxObject widget) 
{
	widget.ActionScriptVoid("loadTexture");
}

/**Updates the Minimap as well as the location of the blips.*/
function Update()
{
	// TODO: Height Adjustment
	//
	// TEMP: Hardcoded Values.
	//          Radius = 124
	//          Scale = 1/64
	// 

	// Calling functions in Flash while the movie is closed can cause a crash.
	if (!bMovieIsOpen)
		return;	


	//	Scale = 1.0/Scale;

	if (RxPC == None || Pawn(RxPC.ViewTarget) == none) 
	{
		return;
	}
	
	//player compass rotation
	UpdateIconLocations();

	//terrain map texture
	//UpdateMap();

	//update the player's marker
	UpdatePlayerBlip();

	// Generate markers for other pawns
	UpdateActorBlips();
}

function UpdateIconLocations()
{
	local float Scale;

	local float f;
	
	if(RxMapInfo == None)
		return;
	
	Scale = RxMapInfo.MinimapScale / RxMapInfo.MinimapCurrentZoom;


	CompassDir = -((RxPC.Rotation.Yaw) & 65535) * (360.0/65536.0);	
	f = -((RxPC.Rotation.Yaw + 16384) & 65535) * (Pi/32768.0);
	IconMatrix.XPlane.X = cos(f) * Scale;//(1.0/32);//Scale;
	IconMatrix.XPlane.Y = sin(f) * Scale;//(1.0/32);//Scale;
	IconMatrix.YPlane.X = -sin(f) * Scale;//(1.0/32);//Scale;
    IconMatrix.YPlane.Y = cos(f) * Scale;////Scale;
    IconMatrix.WPlane.X = 0;
    IconMatrix.WPlane.Y = 0;
    IconMatrix.WPlane.Z = 0;
    IconMatrix.WPlane.W = 1;
    IconMatrix.WPlane = TransformVector(IconMatrix, -Pawn(RxPC.ViewTarget).Location);

}

function UpdateMap()
{
	local vector Vect;
	local matrix Mtrx;
	local float MapScale;
	local vector MapOffset;

	local float f;
	
	if(RxMapInfo == None || Pawn(RxPC.ViewTarget) == none)
		return;

	f = -((RxPC.Rotation.Yaw + 16384) & 65535) * (Pi/32768.0);

	if (RxMapInfo != none && RxMapInfo.MapTexture != none) {
		f -= Pi*0.5;
		MapScale =  RxMapInfo.MinimapNormalZoom/(2.0 * RxMapInfo.MinimapCurrentZoom); //Scale is calculated by = (normalZoom / 2.0 * currentZoom)
	    Mtrx.XPlane.X = -cos(f) * MapScale;
		Mtrx.XPlane.Y = -sin(f) * MapScale;
	    Mtrx.YPlane.X = sin(f) * MapScale;
		Mtrx.YPlane.Y = -cos(f) * MapScale;
		MapOffset.X = -MapTexSize*0.5f;
		MapOffset.Y = -MapTexSize*0.5f;
		Mtrx.WPlane.X = 0;
		Mtrx.WPlane.Y = 0;
		Mtrx.WPlane.Z = 0;
		Mtrx.WPlane.W = 1;
		Mtrx.WPlane = TransformVector(Mtrx, MapOffset);
		f = Pi*1.5-f;
		Vect = (RxMapInfo.MapCenter - Pawn(RxPC.ViewTarget).Location) * MapTexSize/RxMapInfo.MapExtent;
		MapScale = RxMapInfo.MinimapNormalZoom/(2.0 * RxMapInfo.MinimapCurrentZoom); //Scale is calculated by = (normalZoom / 2.0 * currentZoom)
		Mtrx.WPlane.X += (Vect.X * cos(f) + Vect.Y * sin(f)) * MapScale;
		Mtrx.WPlane.Y += (Vect.Y * cos(f) - Vect.X * sin(f)) * MapScale;
		map.SetDisplayMatrix(Mtrx);
	}
}

function uLog2(string s)
{
	`log(s);
}

function UpdatePlayerBlip()
{
	local ASDisplayInfo displayInfo;
	if (Rx_Vehicle(Pawn(RxPC.ViewTarget)) != none) {
		//player_icon.GetObject("playerG").GotoAndStop (GetVehicleIconName(Rx_Vehicle(Pawn(RxPC.ViewTarget))));
		if (Rx_Vehicle(Pawn(RxPC.ViewTarget)).MinimapIconTexture != none) {
			LoadTexture("img://" $ PathName(Rx_Vehicle(Pawn(RxPC.ViewTarget)).MinimapIconTexture), player_icon.GetObject("playerG"));
		} else {
			LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Radar_Blip_Vehicle_Player'), player_icon.GetObject("playerG"));
		}		
	} else {
		//player_icon.GetObject("playerG").GotoAndStop ("Infrantry");
		LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Radar_Blip_Infantry_Player'), player_icon.GetObject("playerG"));
	}
	displayInfo.hasRotation = true;
	displayInfo.Rotation = Pawn(RxPC.ViewTarget).Rotation.Yaw * UnrRotToDeg + CompassDir;

	//player_icon.SetDisplayInfo(displayInfo);
	player_icon.SetDisplayInfo(displayInfo);

}

function UpdateActorBlips()
{
	local Actor P;
	local RxIfc_RadarMarker Marker; 
	local ENUM_ICON IconType; 
	if(thisWorld.TimeSeconds- LastUpdateTime > UpdateTime){
		GDIActorIcons.Length=0;
		GDIVehicleActorIcons.Length=0;
		NodActorIcons.Length=0;	
		NodVehicleActorIcons.Length=0;
		NeutralActorIcons.Length=0;
		NeutralVehicleActorIcons.Length=0;
		SquadActorIcons.Length=0;
		SquadVehiclesActorIcons.Length=0; 

		LastUpdateTime  = thisWorld.TimeSeconds;

		foreach ThisWorld.DynamicActors(class'Actor', P, class'RxIfc_RadarMarker')
		{		
			if((Rx_PRI(P)!=none))
			{
				continue;//skip PRI's, grab stuff off of pawns instead
			}
			Marker = RxIfc_RadarMarker(P);

			IconType = ENUM_ICON(Marker.GetRadarIconType());

			switch (p.GetTeamNum())
			{
				case TEAM_GDI:
					if (IconType == ICON_INFANTRY)
					{
						GDIActorIcons.AddItem(P);
					}
					else if (IconType == ICON_VEHICLE)
					{
						GDIVehicleActorIcons.AddItem(P);
					}
					else if (IconType == ICON_MISC)
					{
						NeutralVehicleActorIcons.AddItem(P);
					}
					break;
				case TEAM_NOD:
					if (IconType == ICON_INFANTRY)
					{
						NodActorIcons.AddItem(P);
					}
					else if (IconType == ICON_VEHICLE)
					{
						NodVehicleActorIcons.AddItem(P);
					}
					else if (IconType == ICON_MISC)
					{
						NeutralVehicleActorIcons.AddItem(P);
					}
					break;
				default:
					if (IconType == ICON_INFANTRY)
					{
						NeutralActorIcons.AddItem(P);
					}
					else if (IconType == ICON_VEHICLE)
					{
						NeutralVehicleActorIcons.AddItem(P);
					}
					else if (IconType == ICON_MISC)
					{
						NeutralActorIcons.AddItem(P);
					}
					break;
			}

		}
	}

	UpdateIcons(GDIActorIcons, GDITeamIcons, TEAM_GDI, false);
	UpdateIcons(GDIVehicleActorIcons, GDIVehicleIcons, TEAM_GDI, true);		
	UpdateIcons(NodActorIcons, NodTeamIcons, TEAM_NOD, false);
	UpdateIcons(NodVehicleActorIcons, NodVehicleIcons, TEAM_NOD, true);	
	UpdateIcons(NeutralActorIcons, NeutralIcons, TEAM_UNOWNED, false);
	UpdateIcons(NeutralVehicleActorIcons, NeutralVehicleIcons, TEAM_UNOWNED, true);	
}

function UpdateIcons(out array<Actor> Actors, out array<GFxObject> ActorIcons, TEAM TeamInfo, bool bVehicle, optional bool bSquad = false)
{
	// HARDCODED: Radius = 124

	local ASDisplayInfo displayInfo;
	local RxIfc_RadarMarker CurrentMarker;
	local array<GFxObject> Icons;
	local int i;
	local vector V;
	local GFxObject Val;
	local Rx_Pawn rxPawn;
	local Rx_GRI rxGRI;
	local bool isDriving;

	if(RxMapInfo == None)
		return;

	rxGRI = Rx_GRI(ThisWorld.GRI);

	displayInfo.hasVisible = true;
	displayInfo.hasX = true; 
	displayInfo.hasY = true;
	displayInfo.hasRotation = true;

	// Generate new icons if the actor icons is not equal to total specified actor count. 
	// Else, hide them all and show them until it reach the specified actor count.
	if (ActorIcons.Length < Actors.Length) {
		switch (TeamInfo) 
		{
			case TEAM_GDI:
				Icons = bVehicle ? GenGDIVehicleIcons(Actors.Length - ActorIcons.Length, bSquad) : GenGDIIcons(Actors.Length - ActorIcons.Length, bSquad);
				break;
			case TEAM_NOD:
				Icons = bVehicle ? GenNodVehicleIcons(Actors.Length - ActorIcons.Length, bSquad) : GenNodIcons(Actors.Length - ActorIcons.Length, bSquad);
				break;
			default:
				Icons = bVehicle ? GenNeutralVehicleIcons(Actors.Length - ActorIcons.Length) : GenNeutralIcons(Actors.Length - ActorIcons.Length);
				break;
		}
		
		foreach Icons(Val) {
			ActorIcons.AddItem(Val);
		}
	} else {
		displayInfo.Visible = false;
		for (i = Actors.Length; i < ActorIcons.Length; i++) {
			ActorIcons[i].SetDisplayInfo(displayInfo);
		}
	}

	if(bSquad)
	{
		displayInfo.HasXScale = true;
		displayInfo.HasYScale = true;
		displayInfo.XScale = 110.f;
		displayInfo.YScale = 110.f;
	}


	//sets the Blips Visibility condition here
	for (i = 0; i < Actors.Length; i++) {

		if(Pawn(Actors[i]) != None && Pawn(Actors[i]).Health <= 0 && !RxPC.IsSpectating()) {
			//This fix hides icons from dead people, this needs to be done because scaleform does not remove anything unless its told to remove it
			displayInfo.Visible = false;
			ActorIcons[i].SetDisplayInfo(displayInfo);
			continue;
		}
		CurrentMarker = RxIfc_RadarMarker(Actors[i]); 
		
		V = TransformVector(IconMatrix, CurrentMarker.GetRadarActorLocation());

		// Display only within the range of the minimap radius
		// Handepsilon tweaked the thing a bit because.... box
		displayInfo.Visible = (WithinMinimapBox(V));

		// Sets up the blips coordinates
		displayInfo.X = V.X;
		displayInfo.Y = V.Y;

		//@shahman: icon rotation = actor's rotation + compass's rotation + rotation offset
		if(Rx_Weapon_DeployedActor(Actors[i]) != None)
			displayInfo.Rotation = (CurrentMarker.GetRadarActorRotation().Yaw + IconRotationOffset);

		else
			displayInfo.Rotation = (CurrentMarker.GetRadarActorRotation().Yaw * UnrRotToDeg) +  CompassDir + IconRotationOffset ;
		
		//Condition for other blips that is not the same team as the player owner
		if (rxGRI != none && (Pawn(GetPC().viewtarget).GetTeamNum() != Actors[i].GetTeamNum()) )
		{
			
			if ( (Actors[i].GetTeamNum() == TEAM_GDI || Actors[i].GetTeamNum() == TEAM_NOD)) {
				
				//No need to go through all of this if it is a stealth tank or SBH that's cloaked
				if (Actors[i].IsInState('Stealthed') && !RxPC.IsSpectating())
				{
					displayInfo.Visible = false;
					ActorIcons[i].SetDisplayInfo(displayInfo);
					continue;
				}
	
				displayInfo.Visible = false; // init false, as most instances will be false.
				
				if(CurrentMarker.GetRadarVisibility() == 2 || 
					CurrentMarker.ForceVisible())
				{
						displayInfo.Visible = true;		
				}
				
				if (RxHUD.RenxHud.TargetingBox.TargetedActor != none &&
					RxHUD.RenxHud.TargetingBox.TargetedActor.GetActualTarget() == Actors[i]) 
						{
							displayInfo.Visible = true;
						}
			} else {

				//No need to go through all of this if it is a stealth tank or SBH that's cloaked
				if (Actors[i].IsInState('Stealthed') && !RxPC.IsSpectating())
				{
					displayInfo.Visible = false;
					ActorIcons[i].SetDisplayInfo(displayInfo);
					continue;
				}
					
				if (Pawn(Actors[i]) != None && Pawn(Actors[i]).Health <= 0)
				{
					displayInfo.Visible = false;
				}
				else
				{ 
					displayInfo.Visible = true;
				}
			}
		}

		if(RxPC.IsSpectating())
			displayInfo.Visible = true;

		if(displayInfo.Visible && bVehicle)
		{
			if (CurrentMarker.GetMinimapIconTexture() != none) {
				LoadTexture("img://" $ PathName(CurrentMarker.GetMinimapIconTexture()), ActorIcons[i].GetObject("vehicleG"));
			} else {
				LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'), ActorIcons[i].GetObject("vehicleG"));
			}	 
			
			//Specific instance for irrelevant pawns needing to check what they're driving through PRI 
			if(ThisWorld.NetMode == NM_Client && Rx_PRI(Actors[i]) != none && Rx_PRI(Actors[i]).PawnVehicleClass != none )
			{
				if (class<Rx_Vehicle>(Rx_PRI(Actors[i]).PawnVehicleClass).default.MinimapIconTexture != none) {
					LoadTexture("img://" $ PathName(class<Rx_Vehicle>(Rx_PRI(Actors[i]).PawnVehicleClass).default.MinimapIconTexture), ActorIcons[i].GetObject("vehicleG"));
				} else {
					LoadTexture("img://" $ PathName(Texture2D'RenxHud.T_Radar_Blip_Vehicle_Neutral'), ActorIcons[i].GetObject("vehicleG"));
				}	
			}
		}		

		if(displayInfo.Visible && !bVehicle && Rx_pawn(Actors[i])!=none)
		{
			rxPawn = Rx_pawn(Actors[i]);
			isDriving = rxPawn.DrivenVehicle !=none;
			if(isDriving)
			{
				displayInfo.Visible = false;	
			}
		}

		ActorIcons[i].SetDisplayInfo(displayInfo);
	}

}

function bool PlayerInBase(Actor CheckPlayer)
{
	local Pawn P;
	local Rx_PRI PRI;
	local Volume V;

	P = Pawn(CheckPlayer);

	if(P != None)
		PRI = Rx_PRI(P.PlayerReplicationInfo);

	else
		PRI = Rx_PRI(CheckPlayer);

	if(PRI == None)
		return false;

	foreach CheckPlayer.CollidingActors(class'Volume',V,100,CheckPlayer.Location,true)
	{
		if(PRI.GetTeamNum() == 0 && Rx_Volume_TeamBase_GDI(V) != None)
			return true;

		if(PRI.GetTeamNum() == 1 && Rx_Volume_TeamBase_Nod(V) != None)
			return true;
	}
	
	return false;
}

function array<GFxObject> GenGDIIcons(int IconCount, optional bool bSquad)
{
   	local array<GFxObject> Icons;
   	local GFxObject IconMC;
    local int i;
	local ASColorTransform ColorTransform;
	for (i = 0; i < IconCount; i++)
    {
        IconMC = icons_Friendly.AttachMovie("FriendlyBlips", "GDI_Player"$IconsFriendlyCount++);
		//@roxez: Debugging blips
        //IconMC = icons_Friendly.AttachMovie("DebugBlips", "GDI_Player"$IconsFriendlyCount++);
		if(bSquad)
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.0;
			ColorTransform.add.G = 0.75;
			ColorTransform.add.B = 0.75;
			IconMC.SetColorTransform(ColorTransform);
		}
        Icons[i] = IconMC;
    }
    return Icons;
}

function array<GFxObject> GenGDIVehicleIcons(int IconCount, optional bool bSquad)
{
	local ASColorTransform ColorTransform;
   	local array<GFxObject> Icons;
   	local GFxObject IconMC;
    local int i;
	for (i = 0; i < IconCount; i++)
    {
        IconMC = icons_Friendly.AttachMovie("VehicleMarker", "GDI_Vehicle"$IconsVehicleFriendlyCount++);
		
		if(bSquad)
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.0;
			ColorTransform.add.G = 0.75;
			ColorTransform.add.B = 0.75;
			IconMC.SetColorTransform(ColorTransform);
		}
		else
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.75;
			ColorTransform.add.G = 0.58;
			ColorTransform.add.B = 0;
		IconMC.SetColorTransform(ColorTransform);
		}
		
        Icons[i] = IconMC;
    }
    return Icons;
}

function array<GFxObject> GenNodIcons(int IconCount, optional bool bSquad)
{
	local array<GFxObject> Icons;
	local GFxObject IconMC;
    local int i;
	local ASColorTransform ColorTransform;
	
	for (i = 0; i < IconCount; i++)
    {
        IconMC = icons_Enemy.AttachMovie("EnemyBlips", "Nod_Player" $IconsEnemyCount++);
		//@roxez: Debugging blips
        //IconMC = icons_Enemy.AttachMovie("DebugBlips", "Nod_Player" $IconsEnemyCount++);
		if(bSquad)
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.0;
			ColorTransform.add.G = 0.75;
			ColorTransform.add.B = 0.75;
			IconMC.SetColorTransform(ColorTransform);
		}
        Icons[i] = IconMC;
    }
    return Icons;
}

function array<GFxObject> GenNodVehicleIcons(int IconCount, optional bool bSquad)
{
	local ASColorTransform ColorTransform;
	local array<GFxObject> Icons;
	local GFxObject IconMC;
    local int i;
	for (i = 0; i < IconCount; i++)
    {
		IconMC = icons_Friendly.AttachMovie("VehicleMarker", "Nod_Vehicle"$IconsVehicleEnemyCount++);
		if(bSquad)
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.0;
			ColorTransform.add.G = 0.75;
			ColorTransform.add.B = 0.75;
			IconMC.SetColorTransform(ColorTransform);
		}
		else
		{
			ColorTransform.multiply.R = 0.25;
			ColorTransform.multiply.G = 0.25;
			ColorTransform.multiply.B = 0.25;
			ColorTransform.add.R = 0.75;
			ColorTransform.add.G = 0;
			ColorTransform.add.B = 0;
			IconMC.SetColorTransform(ColorTransform);
		}
        
        Icons[i] = IconMC;
    }
    return Icons;
}

function array<GFxObject> GenNeutralIcons(int IconCount)
{
	local array<GFxObject> Icons;
	local GFxObject IconMC;
    local int i;
	for (i = 0; i < IconCount; i++)
    {
        IconMC = icons_Enemy.AttachMovie("NeutralBlips", "Neutral_Player" $IconsNeutralCount++);
        Icons[i] = IconMC;
    }
    return Icons;
}

function array<GFxObject> GenNeutralVehicleIcons(int IconCount)
{
	local array<GFxObject> Icons;
	local GFxObject IconMC;
    local int i;
	for (i = 0; i < IconCount; i++)
    {
        IconMC = icons_Friendly.AttachMovie("VehicleMarker", "Neutral_Vehicle"$IconsVehicleNeutralCount++);
        Icons[i] = IconMC;
    }
    return Icons;
}


function bool WithinMinimapBox(Vector V)
{
	if(V.x > RxMapInfo.MinimapRadius || V.x < (RxMapInfo.MinimapRadius * -1))
		return false;

	if(V.y > RxMapInfo.MinimapRadius || V.y < (RxMapInfo.MinimapRadius * -1))
		return false;

	return true;
}

DefaultProperties
{
	IconsFriendlyCount = 0
	IconsVehicleFriendlyCount = 0
	IconsEnemyCount = 0
	IconsVehicleEnemyCount = 0
	IconsNeutralCount = 0;
	IconsVehicleNeutralCount = 0;

	DebugBlipTexture = Texture2D'RenxHud.T_Radar_Blip_Debug'
//	UIScale	= 1.f
	UpdateTime=1
}
