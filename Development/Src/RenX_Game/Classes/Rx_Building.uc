/*********************************************************
*
* File: Rx_Building.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
* The Base class of all the Buildings. 
* This is the placeable part that defines the visual looks. Referred as BuildingVisuals by the Internals class
* 
* See Also :
* - Rx_Building_Internals - The base of all the building inner-working
* - Rx_Building_Team_Internals - Extension of the base Internals class that contains the rest of the basic inner-working required for both Team Buildings and Capturable tech buildings
*
*********************************************************
*  
*********************************************************/

class Rx_Building extends Actor
	abstract
	ClassGroup(Buildings)
	dependson(Rx_Game)
	implements(RxIfc_SpotMarker)
	implements(RxIfc_EMPable)
	implements(RxIfc_Targetable)
	implements(RxIFc_TargetedDescription);

// A list of all the different types of buildings
enum BuildingType
{
	BT_None,
	BT_Power,
	BT_Money,
	BT_Veh,
	BT_Inf,
	BT_Def,
	BT_Air,
	BT_Tech,
	BT_Rep,
	BT_Neutral
};

var(RenX_Buildings) TEAM                        TeamID;                 // building belongs to team with this TeamID (normally 0 -> GDI, 1-> Nod)
var(RenX_Buildings) int                         Health;                 // Starting Health for the building
var(RenX_Buildings) int                         HealthMax;                // Max Health for the building
var(RenX_Buildings) bool                        bBuildingDebug;         // Set to true to enable Debug Logging
var(RenX_Buildings) const BuildingType myBuildingType;

var(RenX_Buildings) class<Rx_Building_Internals>          BuildingInternalsClass; // Class of the internals that needs spawned
var repnotify Rx_Building_Internals             BuildingInternals;      // Instance of the internals that handles the logic like TakeDamage and the like
var(RenX_Buildings) bool bSignificant;									// Whether or not this building counts as victory condition and is shown in HUD
var(RenX_Buildings) bool bTriggerUnderAttack;							// Whether or not this building still announces under attack messages when bSignificant is false

var(RenX_Buildings) int MineLimit; 							// How many mines this building can have in it
var int MinesOnMeCount;													// How many mines are currently on this building
var array<Rx_Weapon_DeployedProxyC4> MinesOnMe;

var(BuildingLights) array<PointLightComponent>  PointLightComponents;   // Point lights for the pre setup lighting
var(BuildingLights) array<SpotLightComponent>   SpotLightComponents;    // Spot lights for the PT's and MCT's for pre setup lighting
var array<StaticMeshComponent>                  StaticMeshPieces;
var Rx_BuildingObjective						myObjective;
var Rx_BuildingAttachment MCT;

var() StaticMeshComponent StaticExterior;
var() StaticMeshComponent StaticInterior;
var() StaticMeshComponent StaticInteriorComplex;
var() StaticMeshComponent PTScreens;

var() Array<NavigationPoint> ViableAttackPoints;

var(RenX_Buildings) Texture IconTexture;

var string NodColor, GDIColor, HostColor, ArmourColor, NeutralColor;

var ParticleSystem RebuildPS;
var float RebuildPSScale;  

replication
{
	if( bNetInitial && Role == ROLE_Authority )
		IconTexture, MineLimit, bSignificant, bTriggerUnderAttack;

	if( bNetDirty && Role == ROLE_Authority )
		BuildingInternals, MinesOnMeCount, TeamID;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'BuildingInternals' ) 
	{
		BuildingInternalsReplicated(); 
	}
	else
		super.ReplicatedEvent(VarName);
}	

simulated function BuildingInternalsReplicated()
{

}

simulated function Rx_BuildingAttachment GetMCT()
{

	local int i;
	local Rx_BuildingAttachment Attachment;
	
	if(MCT != None)
		return MCT;
	else if(BuildingInternals != None)
	{
		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			Attachment=BuildingInternals.BuildingAttachments[i];
			
			if(Attachment.IsA('Rx_BuildingAttachment_MCT'))
			{
				MCT = Attachment;
				return Attachment;	//found it, abandon everything else
			}
		}
	}

	return none;
	
}	

simulated function byte GetBuildingType()
{
	return myBuildingType;
}

function PostBeginPlay()
{
	BuildingInternals = spawn(BuildingInternalsClass, self, BuildingInternalsClass.Name, Location, Rotation);

	if ( BuildingInternals != none 
		&& ( WorldInfo.NetMode == NM_StandAlone 
			|| WorldInfo.NetMode == NM_DedicatedServer 
			|| WorldInfo.NetMode == NM_ListenServer)
	)
	{
		BuildingInternals.Init(self, bBuildingDebug);
	}

	if(Role == ROLE_Authority)
		GetAttackPoints();
}

simulated function TickBuilding(float DeltaTime)
{
	
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	if(BuildingInternals.GetHealth() <= 0) {
		return;
	}
	super.TakeRadiusDamage(InstigatedBy,BaseDamage,DamageRadius,DamageType,Momentum,HurtOrigin,bFullDamage,DamageCauser,DamageFalloffExponent);
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if(BuildingInternals.GetHealth() <= 0) 
	{
		if(myObjective != None && !myObjective.IsDisabled()) 
		{
			myObjective.DisableBuildingObjective();
		}
		return;
	}
	BuildingInternals.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	if(myObjective != None) 
	{
		myObjective.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);    
	}
}

event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	if(BuildingInternals.HealDamage(Amount,Healer,DamageType) && myObjective != none ) {
		myObjective.HealDamage(Amount,Healer,DamageType);
		return true;
	}
	return false;
}

simulated function bool IsEffectedByEMP()
{
	return true;
}

function bool EMPHit(Controller InstigatedByController, Actor EMPCausingActor, optional float TimeModifier = 0)
{
	if (Rx_Building_Team_Internals(BuildingInternals) != None && GetTeamNum() != InstigatedByController.GetTeamNum() && BuildingInternals.GetHealth() > 0)
	{
		Rx_Building_Team_Internals(BuildingInternals).TriggerBuildingUnderAttackMessage(InstigatedByController);
		return true;
	}
	return false;
}

function EnteredEMPField(Rx_EMPField EMPField);

function LeftEMPField(Rx_EMPField EMPField);

simulated function bool StopsProjectile(Projectile P)
{
	return true;
}

simulated function byte ScriptGetTeamNum() 
{
	return TeamID; 
}

simulated function byte GetTeamNum() 
{
	return TeamID; 
}

simulated function int GetHealth() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetHealth(); 
	else 
		return Health;		
}

simulated function int GetMaxHealth() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetMaxHealth(); 
	else 
		return HealthMax;	
}

simulated function int GetTrueMaxHealth() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetTrueMaxHealth(); 
	else 
		return HealthMax;	
}


simulated function int GetArmor() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetArmor(); 
	else 
		return 0;		
}

simulated function int GetMaxArmor() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetMaxArmor(); 
	else 
		return 0;	
}

simulated function int GetArmorPct()
{
	if(GetMaxArmor() == 0)
		return 0;

	return FFloor(100 * Float(GetArmor()) / Float(GetMaxArmor()));
}


simulated function string GetBuildingName()
{	
	if (BuildingInternals != None)
		return BuildingInternals.GetBuildingName();
			
	else return "";
}

simulated function bool IsDestroyed()
{
	if (BuildingInternals != none)
		return BuildingInternals.IsDestroyed();
	else return false;
}

simulated function bool IsEligibleSpottingMarker()
{
	return true;
}

simulated function String GetSpotName()
{
	local String TeamColor;

	if(WorldInfo.NetMode == NM_DedicatedServer)
		return GetNonHTMLSpotName();

	if(GetTeamNum() == 0)
	{
		TeamColor = Rx_HUD(GetALocalPlayerController().myHUD).default.GDIColor;
	}
	else if(GetTeamNum() == 1)
	{
		TeamColor = Rx_HUD(GetALocalPlayerController().myHUD).default.NodColor;
	}
	else
	{
		TeamColor = Rx_HUD(GetALocalPlayerController().myHUD).default.NeutralColor;
	}

	return "<font color='"$TeamColor$"'>"$GetHumanReadableName()$"</font>";
}

simulated function string GetNonHTMLSpotName()
{
	return GetHumanReadableName();
}

/*
simulated function vector GetTargetLocation(optional actor RequestedBy, optional bool bRequestAlternateLoc) 
{
	return super.GetTargetLocation(RequestedBy,bRequestAlternateLoc) + vect(0,0,200);
}
*/

function AddMine(Rx_Weapon_DeployedProxyC4 Mine)
{
	local Rx_Weapon_DeployedProxyC4 M;

	MinesOnMe.AddItem(Mine);

	if (MinesOnMe.Length > MineLimit)
	{
		M = MinesOnMe[0];
		MinesOnMe.Remove(0, 1);
		M.Destroy();
	}

	MinesOnMeCount = MinesOnMe.Length;
}

function RemoveMyMines(Rx_Controller Control)
{
	local Rx_Weapon_DeployedProxyC4 Proxies; 
	local byte TeamByte;
	local int MinesRemoved;
	
	TeamByte = Control.GetTeamNum();
	
	foreach AllActors(class'Rx_Weapon_DeployedProxyC4', Proxies)
	{
		if (Proxies.Base == self && Proxies.GetTeamNum() == TeamByte ) 
		{
			Proxies.TakeDamage(500, Control, vect(0,0,0), vect(0,0,0), class'Rx_DmgType_EMP') ; 
			MinesRemoved++;
		}
	}

	if (MinesRemoved > 0)
		WorldInfo.Game.BroadcastTeam(Control, MinesRemoved@"proxies removed from"@GetHumanReadableName(), 'TeamSay');

	MinesOnMeCount = 0;
}

function RemoveMine(Rx_Weapon_DeployedProxyC4 mine)
{
	MinesOnMe.RemoveItem(mine);
	MinesOnMeCount = MinesOnMe.Length;
}

function GetAttackPoints()
{
	local NavigationPoint N;
	local Vector Dummy1,Dummy2;

	foreach WorldInfo.AllNavigationPoints(class'NavigationPoint',N)
	{
		if(N.Trace(Dummy1,Dummy2,Location,N.Location,,,,TRACEFLAG_Bullet) != Self)
			Continue;

		ViableAttackPoints.AddItem(N);

	}

	if(ViableAttackPoints.length <= 0)
		`log(GetHumanReadableName()@" : Failed to find viable attack points! Bots may find issues in pathfinding to this building!");
}

function NavigationPoint FindAttackPointsFor(UTBot B)
{
	local float Dist, BestDist;
	local Vector DistanceMark;
	local NavigationPoint N, BestN;
	local bool bBotIsTransport;

	if(ViableAttackPoints.length <= 0)
	{
		`log(GetHumanReadableName()@" : This building lacks any attack point!");
		return none;
	}

	if(Vehicle(B.Pawn) != None && (Rx_Vehicle_Weapon(B.Pawn.Weapon) == None || !Rx_Vehicle_Weapon(B.Pawn.Weapon).bOkAgainstBuildings))
	{
		bBotIsTransport = true;
		DistanceMark = Location;
	}
	else
	{
		DistanceMark = B.Pawn.Location;
	}

	foreach ViableAttackPoints(N)
	{
		if(Vehicle(B.Pawn) != None && N.bBlockedForVehicles)
			continue;
		Dist = VSizeSq(N.Location - DistanceMark);

		if(!bBotIsTransport && VSizeSq(N.Location - Location) > Square(B.Pawn.Weapon.GetTraceRange()))		// can't possibly attack from here if the spot is unreachable
			continue;

		if(BestN == None || BestDist > Dist)
		{
			BestN = N;
			BestDist = Dist;
		}
	}

	if(BestN != None)
	{
		return BestN;
	}

	else
	{
		`log(B.GetHumanReadableName()@" : Failed to get my attack spot, have you setup the map's navigation points correctly?");
		return none;
	}
}

simulated function Rx_BuildingObjective GetObjective()
{
	return myObjective;
}

function OnToggle(SeqAct_Toggle Action)
{
	local Rx_Building_Team_Internals TeamInternals;
	local bool bNewPowerStatus;

	if(Rx_Building_Team_Internals(BuildingInternals) != None && !IsDestroyed())
		TeamInternals = Rx_Building_Team_Internals(BuildingInternals);

	else
		return;

	if(Action.InputLinks[0].bHasImpulse)
		bNewPowerStatus = true;

	else if (Action.InputLinks[1].bHasImpulse)
		bNewPowerStatus = false;

	else
		bNewPowerStatus = TeamInternals.bNoPower;


	if(bNewPowerStatus)
		TeamInternals.PowerRestore();
	else
		TeamInternals.PowerLost(true);
	
}

function bool Unpowered()
{
	if(IsDestroyed())
		return true;
	if(Rx_Building_Team_Internals(BuildingInternals) != None)
		return Rx_Building_Team_Internals(BuildingInternals).bNoPower;
}

function CreateUnlistedBO()
{
	local vector SpawnLoc;

	if(GetMCT() != None)
		SpawnLoc = GetMCT().Location;

	else
		SpawnLoc = Location;

	myObjective = Spawn(class'Rx_BuildingObjective_Dynamic',self,,SpawnLoc,Rotation);

	myObjective.DefenderTeamIndex = ScriptGetTeamNum();
	myObjective.DamageCapacity = GetMaxArmor();	
	myObjective.myBuilding = Self;

	Rx_BuildingObjective_Dynamic(myObjective).GenerateInfiltrationPoint();
}

function bool ShouldCreateUnlistedBO()
{
	return myObjective == None;
}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return GetHealth();} //Return the current health of this target
simulated function int GetTargetHealthMax() {return GetMaxHealth();} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return GetArmor();} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return GetMaxArmor();} // Get the current Armour of the target 
simulated function bool GetHasResistance() {return false;} //If this unit has any kind of resistance

/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return float(GetHealth()) / fmax(1,float(GetTrueMaxHealth()));}
simulated function float GetTargetArmourPct() {return float(GetArmor()) / max(1,float(GetMaxArmor()));}
simulated function float GetTargetMaxHealthPct() {return 1.0f;} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return true;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return true;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return false;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return false;} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return true;} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return true;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return true;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return false;} //Does our target box 'stick' even after we're untargeted for awhile 

//Spotting
simulated function bool IsSpottable() {return true;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return GetBuildingName();} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "";} //Get the text for our interaction 

//Get any special description we might have when targeted 
simulated function string GetTargetedDescription(PlayerController PlayerPerspectiv) {
	if(PlayerPerspectiv.GetTeamNum() == GetTeamNum())
	{
		if(GetHealth() <= 0 && GetRevivalTime() > 0)
		{
			return "[REBUILDING]:" @ GetTimerString(GetRevivalTime());
		}
		else if(BuildingInternals.GetReviveIsAvailable())
			return "REVIVE AVAILABLE AT MCT";
		else if(!GetCanRepair())
			return "[REPAIRS DISABLED]"; 
		else if(BuildingInternals.DamageMultiplier > 1.0)
			return int(BuildingInternals.DamageMultiplier)$"x Damage";
		else if(BuildingInternals.GetTimesRevived() > 0)
			return "[REBUILT]"; 
		else
			return ""; 
	}
	else
	{
		if(GetHealth() <= 0 && GetRevivalTime() > 0) {
			return "[REBUILDING]";
		}
		else if(!GetCanRepair())
			return "[REPAIRS DISABLED]";
		else if(BuildingInternals.DamageMultiplier > 1.0)
			return int(BuildingInternals.DamageMultiplier)$"x Damage";
		else if(BuildingInternals.GetTimesRevived() > 0)
			return "[REBUILT]"; 
		else
			return ""; 
	}
} 

//Actions
simulated function SetTargeted(bool bTargeted) ; //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/

simulated function int GetRevivalTime() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetRevivalTime(); 
	else 
		return 0;		
}

simulated function string GetTimerString(float InputTime)
{
	local int Seconds, Minutes; 

	if(InputTime == 0)
	{
		return "|MCT|"; //The only thing that sees this is the Scoreboard
	}

	Minutes = int(InputTime/60.0);
	Seconds = InputTime % 60.0;
	
	return Seconds > 9 ? Minutes$":"$Seconds : Minutes$":0"$Seconds ; //Add a 0 on seconds if need be
}

function StartRevival(int RevivalTime)
{
	if(BuildingInternals != None)
		BuildingInternals.SetRevivalTime(RevivalTime); 
}

function CancelRevive()
{
	if(BuildingInternals != None)
		BuildingInternals.ClearRevivalTimer(); 
	
}

function SetCanRepair(bool bNewRepair)
{
	if(BuildingInternals != None)
		BuildingInternals.SetCanRepair(bNewRepair);
}

simulated function bool GetCanRepair()
{
	if(BuildingInternals != None)
		return BuildingInternals.GetCanRepair();
	else 
		return false; 
}

function SetDamageMultiplier(float NewMultiplier)
{
	if(ROLE == ROLE_Authority && BuildingInternals != None)
	{
		BuildingInternals.SetDamageMultiplier(NewMultiplier);
	}
}

simulated function HideAttachements(bool bHide)
{
	local int i; 

	if(bHide)
	{
		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(true); 
		}
	}
	else 
	{
		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(false); 
		}
	}
	
}

simulated function HideBuilding(bool bHide)
{
	local int i; 

	if(bHide)
	{
		//SetHidden(true);
		HideStaticMeshes(true); 

		//SetCollision(false,false); 
		//SetCollisionType(COLLIDE_NoCollision);
		//bWorldGeometry = false;
		BuildingInternals.SetHidden(true); 
		BuildingInternals.SetCollisionType(COLLIDE_NoCollision);
		//bIgnoreRigidBodyPawns = false;
		
		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(true);
			BuildingInternals.BuildingAttachments[i].SetAllCollision(false);
		}
	}
	else
	{
		SetHidden(false);
		HideStaticMeshes(false);

		SetCollision(true,true); 
		SetCollisionType(COLLIDE_BLOCKALL);
		bWorldGeometry = true;
		BuildingInternals.SetHidden(false); 
		BuildingInternals.SetCollisionType(COLLIDE_CustomDefault);

		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(false);
			BuildingInternals.BuildingAttachments[i].SetAllCollision(true);
		}
	}
}

simulated function HideStaticMeshes(bool bHide)
{
	local StaticMeshComponent SMC;

	if(bHide)
	{
		Foreach StaticMeshPieces(SMC)
		{
			SMC.SetHidden(true); 
			SMC.SetActorCollision(false, false);
			SMC.SetBlockRigidBody(false);
			SMC.SetRBChannel(RBCC_Nothing);
			SMC.SetTraceBlocking(false, false);
		}
	}
	else
	{
		Foreach StaticMeshPieces(SMC)
		{
			SMC.SetHidden(SMC.default.HiddenGame); 
			SMC.SetActorCollision(SMC.default.CollideActors, SMC.default.BlockActors);
			SMC.SetBlockRigidBody(SMC.default.BlockRigidBody);
			SMC.SetRBChannel(SMC.default.RBChannel);
			SMC.SetTraceBlocking(SMC.default.BlockZeroExtent, SMC.default.BlockNonZeroExtent);
		}
	}
}

function HideSelf()
{
	local StaticMeshComponent SMC; 
	local int i; 

	if(bHidden)
	{
		Foreach StaticMeshPieces(SMC)
		{
			SetHidden(false);
			SMC.SetHidden(false); 
		}

		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(false); 
		}
	}
	else
	{
		Foreach StaticMeshPieces(SMC)
		{
			SetHidden(true);
			SMC.SetHidden(true); 
		}

		for (i = 0; i < BuildingInternals.BuildingAttachments.length; i++)
		{
			BuildingInternals.BuildingAttachments[i].SetHidden(true); 
		}

		SetCollision(false,false); 
		SetCollisionType(COLLIDE_NoCollision);
		bWorldGeometry = false;
		BuildingInternals.SetHidden(true); 
		BuildingInternals.SetCollisionType(COLLIDE_NoCollision);
	}
}

defaultproperties
{
	/***************************************************/
	/*              Actor Settings                     */
	/***************************************************/
	TickGroup=TG_DuringAsyncWork
	RemoteRole            = ROLE_SimulatedProxy
	bBlocksNavigation   = false
	bBlocksTeleport     = True
	BlockRigidBody      = True
	bCollideActors      = True
	bBlockActors        = True
	bStatic             = true
	bWorldGeometry      = True
	bMovable            = False
	bAlwaysRelevant     = True
	bGameRelevant       = True
	bOnlyDirtyReplication = True
	
	NetUpdateFrequency=10.0

	bEdShouldSnap=true


	HealthMax           = 4000
	Health              = 0
	bBuildingDebug      = False
	bSignificant		= true
	RebuildPS = ParticleSystem'RX_WP_Blueprint.Particles.P_DeploymentDust'
	RebuildPSScale = 5.0

	/***************************************************/
	/*             Buildings Static Meshes             */
	/***************************************************/
	Begin Object Class=StaticMeshComponent Name=Static_Interior
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = True
		//HiddenGame=true
		ForcedLodModel 					= 1
		LightingChannels                = (bInitialized=True,Static=True)
		Translation						= (Z=-150)
	End Object
	StaticMeshPieces.Add( Static_Interior )
	Components.Add( Static_Interior )
	StaticInterior=Static_Interior

	Begin Object Class=StaticMeshComponent Name=Static_Interior_Complex
		//HiddenGame=true
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 1
		LightingChannels                = (bInitialized=True,Static=True)
		Translation						= (Z=-150)
	End Object
	StaticMeshPieces.Add( Static_Interior_Complex )
	Components.Add( Static_Interior_Complex )
	StaticInteriorComplex=Static_Interior_Complex

	Begin Object Class=StaticMeshComponent Name=Static_Exterior
		//HiddenGame=true
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 1
		LightingChannels                = (bInitialized=True,Static=True)
		Translation						= (Z=-150)
	End Object
	StaticMeshPieces.Add( Static_Exterior )
	Components.Add( Static_Exterior )
	StaticExterior=Static_Exterior

	Begin Object Class=StaticMeshComponent Name=PT_Screens
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 1
		LightingChannels                = (bInitialized=True,Static=True)
		Translation						= (Z=-150)
	End Object
	StaticMeshPieces.Add( PT_Screens )
	Components.Add( PT_Screens )
	PTScreens=PT_Screens


	/***************************************************/
	/*             For Debugging Purposes              */
	/***************************************************/
	Begin Object Class=DrawLightRadiusComponent Name=DrawLightRadius0
	End Object
	Components.Add(DrawLightRadius0)

	Begin Object Class=DrawLightRadiusComponent Name=DrawLightSourceRadius0
		SphereColor = (R=231,G=239,B=0,A=255)
	End Object
	Components.Add(DrawLightSourceRadius0)

	// Inner cone visualization.
	Begin Object Class=DrawLightConeComponent Name=DrawInnerCone0
		ConeColor=(R=150,G=200,B=255)
	End Object
	Components.Add(DrawInnerCone0)

	// Outer cone visualization.
	Begin Object Class=DrawLightConeComponent Name=DrawOuterCone0
		ConeColor=(R=200,G=255,B=255)
	End Object
	Components.Add(DrawOuterCone0)


	/***************************************************/
	/*             Point Light Components              */
	/***************************************************/
	Begin Object Class=PointLightComponent Name=PointLightComponent1
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent2
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent3
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent4
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent5
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent6
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent7
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent8
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent9
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent10
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent11
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object
	
	Begin Object Class=PointLightComponent Name=PointLightComponent12
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent13
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	Begin Object Class=PointLightComponent Name=PointLightComponent14
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		PreviewLightRadius          = DrawLightRadius0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
		Radius                      = 350.000000
		FalloffExponent             = 4.000000
		Brightness                  = 3.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightColor                  = (B=255,G=255,R=255,A=0)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
	End Object

	/***************************************************/
	/*              Spot Light Components              */
	/***************************************************/
	Begin Object Class=SpotLightComponent Name=SpotLightComponent1
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		InnerConeAngle              = 80.000000
		OuterConeAngle              = 90.000000
		Radius                      = 300.000000
		FalloffExponent             = 4.000000
		Brightness                  = 2.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
		PreviewLightRadius          = DrawLightRadius0
		PreviewInnerCone            = DrawInnerCone0
		PreviewOuterCone            = DrawOuterCone0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
	End Object

  Begin Object Class=SpotLightComponent Name=SpotLightComponent2
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		InnerConeAngle              = 80.000000
		OuterConeAngle              = 90.000000
		Radius                      = 300.000000
		FalloffExponent             = 4.000000
		Brightness                  = 2.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
		PreviewLightRadius          = DrawLightRadius0
		PreviewInnerCone            = DrawInnerCone0
		PreviewOuterCone            = DrawOuterCone0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
	End Object

	Begin Object Class=SpotLightComponent Name=SpotLightComponent3
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		InnerConeAngle              = 80.000000
		OuterConeAngle              = 90.000000
		Radius                      = 300.000000
		FalloffExponent             = 4.000000
		Brightness                  = 2.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
		PreviewLightRadius          = DrawLightRadius0
		PreviewInnerCone            = DrawInnerCone0
		PreviewOuterCone            = DrawOuterCone0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
	End Object
	
	Begin Object Class=SpotLightComponent Name=SpotLightComponent4
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		InnerConeAngle              = 80.000000
		OuterConeAngle              = 90.000000
		Radius                      = 300.000000
		FalloffExponent             = 4.000000
		Brightness                  = 2.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
		PreviewLightRadius          = DrawLightRadius0
		PreviewInnerCone            = DrawInnerCone0
		PreviewOuterCone            = DrawOuterCone0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
	End Object

	Begin Object Class=SpotLightComponent Name=SpotLightComponent5
		LightAffectsClassification  = LAC_STATIC_AFFECTING
		CastShadows                 = True
		CastStaticShadows           = True
		CastDynamicShadows          = False
		bForceDynamicLight          = False
		InnerConeAngle              = 80.000000
		OuterConeAngle              = 90.000000
		Radius                      = 300.000000
		FalloffExponent             = 4.000000
		Brightness                  = 2.000000
		LightingChannels            = (BSP=True,Static=True,Dynamic=False,CompositeDynamic=True,bInitialized=True)
		LightmassSettings           = (IndirectLightingScale=1,IndirectLightingSaturation=1,ShadowExponent=2,LightSourceRadius=32)
		PreviewLightRadius          = DrawLightRadius0
		PreviewInnerCone            = DrawInnerCone0
		PreviewOuterCone            = DrawOuterCone0
		PreviewLightSourceRadius    = DrawLightSourceRadius0
	End Object

	SupportedEvents.Add(class'Rx_SeqEvent_BuildingEvent')

	IconTexture=Texture2D'RenxHud.T_BuildingIcon_RepairPad_Normal'

	ArmourColor         = "#05DAFD"

}