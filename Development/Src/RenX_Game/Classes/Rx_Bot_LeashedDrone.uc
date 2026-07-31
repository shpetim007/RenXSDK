/////////////////////////////////////////////
//
//	"Scripted Bot" by Handepsilon
//	NPC that looks like PC, only a bit more potato than RenX's first bot :D
//	Mappers can use this bot to emulate some SP/Co-op feel
//
/////////////////////////////////////////////

class Rx_Bot_LeashedDrone extends Rx_Defence_Controller;

// var Rx_Vehicle BoundVehicle; //Our actual vehicle
// var Pawn LeashedPawn; //The Pawn we're 'leashed' to 
// var Rx_TeamInfo AssignedTeam;
// var byte VRank;

// var float SpeedModifier;
// var float DamageTakenModifier;
// var float DamageDealtModifier;
// var bool bDriverSurvives;

enum BattleRole {
	BR_REPAIR,
	BR_FIGHTER,
	BR_GUARD,
	BR_SCOUT
}; 

var BattleRole DroneProtocol; 

struct ProtocolSettings
{
	var float ProtocolLeashLength;
	var float ProtocolEngagementLeashMult;
	var vector ProtocolActorOffset;
};

var array<ProtocolSettings> Protocols;

var float LeashLength;
var float EngagementLeashMult; //Allow us to go this percent of the leash while we're engaged (Should be over 1.0) 
var Actor HostingActor; 
var vector ActorOffset; 
var float ZTolerance; 
var bool bNeedsHeightCorrection;
var string Status;
var bool bRandomMoveWhileSearching; 
var bool bLowCeiling;
var float TemporaryZOffset; 

//0 = no attempts to dodge while engaging / 4.0 maximum dodge-ability in all directions (Use with caution, as it might beat itself into the ground)
var float EngagedDodgeAggressiveness;
var PlayerReplicationInfo OwnerPRI; 

event PostBeginPlay()
{
	Super(AIController).PostBeginPlay();
	//InitPlayerReplicationInfo();
	SetTimer(0.1,true,'CheckActiveModifiers');
}

function RxInitialize(float InSkill, const out CharacterInfo BotInfo, UTTeamInfo BotTeam)
{
	return; 
}

function InitDroneAI(name DroneType, Actor DroneHost, PlayerReplicationInfo NewOwningPRI)
{
	ScriptedMoveTarget = DroneHost;
	HostingActor = DroneHost; 

	if(HostingActor == none)
	{
		`warn("Invalid Drone Host");
		return; 
	}

	if(DroneType == 'Repair')
	{
		SetProtocol(BR_REPAIR);
	}
	else
	{
		SetProtocol(BR_FIGHTER);
	}

	InitPlayerReplicationInfo();
	SetOwnerPRI(NewOwningPRI); 
	
	SetTimer(0.5, true, 'CheckLeash');
	PushState('ScriptedMove');
}

function SetOwnerPRI(PlayerReplicationInfo NewOwningPRI)
{
	OwnerPRI = NewOwningPRI;

	if(OwnerPRI != none && PlayerReplicationInfo != none)
	{
		PlayerReplicationInfo.SetPlayerName(OwnerPRI.PlayerName @ "- Drone");
		PlayerReplicationInfo.SetPlayerTeam(WorldInfo.GRI.Teams[OwnerPRI.GetTeamNum()]);
	}
	else if(OwnerPRI == none)
	{
		PlayerReplicationInfo.SetPlayerName("Drone");
		PlayerReplicationInfo.SetPlayerTeam(none);
	}
}

function InitPlayerReplicationInfo()
{
	if(PlayerReplicationInfo != none)
	{
		CleanupPRI();
	}
	PlayerReplicationInfo = Spawn(class'Rx_DefencePRI', self);

	if (PlayerReplicationInfo != none) {
		if(OwnerPRI != none)
		{
			PlayerReplicationInfo.SetPlayerName(OwnerPRI.PlayerName @ "- Drone");
			PlayerReplicationInfo.SetPlayerTeam(WorldInfo.GRI.Teams[OwnerPRI.GetTeamNum()]);
		}
		else if(HostingActor != none)
		{
			PlayerReplicationInfo.SetPlayerName(HostingActor.GetHumanReadableName());
		}
		else
			PlayerReplicationInfo.SetPlayerName("Drone");
	}
}

function SetProtocol(BattleRole NewProtocol)
{
	DroneProtocol = NewProtocol; 

	bSeeFriendly = DroneProtocol == BR_REPAIR; 

	Focus = none; 
	Enemy = none; 

	LeashLength = Protocols[NewProtocol].ProtocolLeashLength; 
	EngagementLeashMult = Protocols[NewProtocol].ProtocolEngagementLeashMult;
	ActorOffset = Protocols[NewProtocol].ProtocolActorOffset;
}

function bool IsTargetRelevant( Pawn thisTarget )
{
	if(Pawn.Health <= 0)
		return false;

	if(thisTarget == None)
		return false;

	if(DroneProtocol == BR_REPAIR)
		return IsRepairTargetRelevant(thisTarget); 

	// Vehicle is not assigned to GDI (0) or Nod (1), so don't shoot!
	if(self.GetTeamNum() > 1)
		return false;

	if(thisTarget == HostingActor || HostingActor.GetTeamNum() > 1)
		return false; 
	
	if(RxIfc_Stealth(thisTarget) != none && !RxIfc_Stealth(thisTarget).GetIsinTargetableState())
		return false;

	if (Rx_Pawn(thisTarget) != None && Rx_Pawn(thisTarget).isSpy()) // added spy exception
		return false;

	if(targets != TYPE_AIR && (Rx_Vehicle_Air_Jet(thisTarget) != None || Rx_Vehicle_Air(thisTarget) != None || Rx_SupportVehicle_Air(thisTarget) != none))
		return false;
	
	if(Rx_VehicleSeatPawn(thisTarget) != none)
	{
		if(Rx_Vehicle_Air(Rx_VehicleSeatPawn(thisTarget).MyVehicle) != none || Rx_Vehicle_Air_Jet(Rx_VehicleSeatPawn(thisTarget).MyVehicle) != none) 
			return false;		
	}
	
	if (FastTrace(thisTarget.location,pawn.location) &&
		(thisTarget.Controller != None) && 
		(thisTarget.GetTeamNum() != self.GetTeamNum()) &&
		(thisTarget.Health > 0) &&
		pawn.Weapon.CanAttack(thisTarget))
		//(VSize(thisTarget.Location-Pawn.Location) < Pawn.SightRadius*1.25) )
	{
		if ( Rx_Game(WorldInfo.Game).SmokeScreenCount > 0 )
		{
			foreach TraceActors(class'Rx_SmokeScreen', DummyActor, DummyHitLoc, DummyHitNorm, thisTarget.Location, Pawn.Location)
				return false;
		}
		return true;
	}
	return false;
}

function bool IsRepairTargetRelevant( Pawn thisTarget )
{
	if(thisTarget == Pawn || Rx_Vehicle(thisTarget) == none)
		return false;

	if (FastTrace(thisTarget.location,pawn.location) &&
		(thisTarget.Controller != None) && 
		(thisTarget.GetTeamNum() == GetTeamNum()) && 
		(thisTarget.Health > 0) && Rx_Vehicle(thisTarget).NeedsHealing() &&
		UTVehicleWeapon(pawn.Weapon).CanHeal(thisTarget))
	{
		return true;
	}
	return false;
}

function TryToAttackFocus(){
	
	if((Enemy != None)  && (IsAimCorrect()) && 
	(bInAttackProtocol() && UTVehicle(Pawn).Seats[0].Gun.CanAttack(Enemy)) ||
	(bInRepairProtocol() && UTWeapon(UTVehicle(Pawn).Seats[0].Gun).CanHeal(Enemy) ))
	{
		Pawn.BotFire(false);
	}
	else
	{
		self.StopFiring();
	} 
}

function bool bInAttackProtocol() {return DroneProtocol != BR_REPAIR;}

function bool bInRepairProtocol() {return DroneProtocol == BR_REPAIR;}

auto state Searching
{
	Begin:
	Focus = Enemy;
	Sleep(0.2);
	if ( Enemy != None && IsTargetRelevant( Enemy ) )
		GotoState('Engaged');
	Sleep(0.5 + 1.0*FRand());
	
	if(Pawn != None)
	{
		foreach WorldInfo.AllPawns(class'Pawn', DetectedPawn,Pawn.location,pawn.SightRadius)
		{ 
			if(IsTargetRelevant(DetectedPawn))
			{
				if(Enemy == None)
				{
					Enemy = DetectedPawn;
					Focus = DetectedPawn;
				}

				GotoState('Engaged');	
				break;
			}
		}
	}
		
	Goto('Begin');
}

function DoRandomLookAround()
{
	local vector loc;
	local Rx_Vehicle V;  

	if (GetStateName() == 'Searching' && Pawn != None)
	{
		V = Rx_Vehicle(Pawn); 

		loc.x = RandRange(-160000, 160000);
		loc.y = RandRange(-160000, 160000);
		loc.z = RandRange(-5000, 3000);

		if (targets == TYPE_AIR)
			loc.z += 10000;
	
		self.FocalPosition.Position = loc;

		if (V != None)
		{
			V.Steering = RandRange(-0.75,0.75);
			V.Throttle = RandRange(-0.5,0.5);

			V.Rise = V.location.Z < HostingActor.location.Z+ZTolerance ? 0.5 : 0.0; 
		}
	
		UTVehicle(Pawn).ForceWeaponRotation(0, UTVehicle(Pawn).GetWeaponAim(UTVehicleWeapon(UTVehicle(Pawn).Seats[0].Gun)));
		SetTimer(RandRange(2, 4), false, 'DoRandomLookAround');
	}
	else
		return;
}



/**
 * Simple scripted movement state, attempts to pathfind to ScriptedMoveTarget and
 * returns execution to previous state upon either success/failure.
 */
state ScriptedMove
{

Begin:
	// while we have a valid pawn and move target, and
	// we haven't reached the target yet
	while (Pawn != None && bNeedsHeightCorrection || (ScriptedMoveTarget != None && !Pawn.ReachedDestination(ScriptedMoveTarget)))
	{
		if(bNeedsHeightCorrection)
		{
			Status = "Correcting Z Height"; 
			MoveTo(Pawn.Location * vect(1.0,1.0,0.0) + (HostingActor.location*vect(0,0,1.0)+vect(0,0,500) ), Focus != none ? Focus : ScriptedFocus, 120);
		}
		else if (ActorReachable(ScriptedMoveTarget))
		{
			// check to see if it is directly reachable
			// then move directly to the actor
			Status = "Moving Normally To Target"; 
			MoveTo(ScriptedMoveTarget.location+ActorOffset, Focus != none ? Focus : ScriptedFocus, 150);
			//MoveToward(ScriptedMoveTarget, ScriptedFocus);
		}
		else
		{
			// attempt to find a path to the target
			MoveTarget = FindPathToward(ScriptedMoveTarget);

			if (MoveTarget != None)
			{
				// move to the first node on the path
				Status = "Moving Normally To Target"; 
				MoveTo(ScriptedMoveTarget.location+ActorOffset, Focus != none ? Focus : ScriptedFocus, 150);
				//MoveToward(MoveTarget, ScriptedFocus);
			}
			else
			{
				// abort the move
				`warn("Failed to find path to"@ScriptedMoveTarget);
				Status = "Move Was aborted" @ ScriptedFocus @ VSize(location - HostingActor.location); 
				ScriptedMoveTarget = None;
			}
		}
	}
	// return to the previous state
	PopState();
}

state Engaged
{
	
	ignores SeePlayer;
	
	function EnemyNotVisible()
	{
		
		if ( IsTargetRelevant( Enemy ) )
		{
			Focus = None;
			GotoState('WaitForTarget');
			return;
		}
	}

	function BeginState(Name PreviousStateName)
	{
		SetTimer(0.1, true, 'TryToAttackFocus');

		if(bInAttackProtocol())
			SetTimer(1.0, true, 'ApplyRandomStrafe');
	}
	function EndState(Name NextStateName)
	{
		ClearTimer('TryToAttackFocus');
		ClearTimer('ApplyRandomStrafe');
	}


	Begin:
	
	if(bInAttackProtocol() || Rx_Vehicle(Enemy) != none) Focus = Enemy;
	Sleep(0.1);
	//	if(Trace(HitLocation, HitNormal, Focus.Location - vect(0,0,60), UTVehicle(Pawn).Seats[0].Gun.GetPhysicalFireStartLoc(), true,,, TRACEFLAG_Bullet) == Enemy);
	//     	FocalPoint.z = FocalPoint.z-60;
	
	UTVehicleWeapon(UTVehicle(Pawn).Seats[0].Gun).GetFireStartLocationAndRotation(SocketLocation, SocketRotation);
	
	if(AimAhead > 0.0 && Enemy != None && Focus != None) {
		FindAimToHit(Enemy, SocketLocation, Aim_Spot, AimAheadAimRotation);
		self.FocalPosition.Position = Aim_Spot;
	}
	
	if(UTVehicle(Enemy) == None && Rx_Defence_GuardTower(Pawn) == None)
	{
		PlayerFeet = self.FocalPosition.Position;
		PlayerFeet.Z -= 50;
		if(FastTrace(PlayerFeet,SocketLocation)) {
			self.FocalPosition.Position.Z -= 50;	// If Enemy is Infantry, aim more at the feet, if its a Vehicle aim at the middle
		}
	}
	// This 'manually' Points the Turret to where the Controller is Aiming
	UTVehicle(Pawn).ForceWeaponRotation(0, UTVehicle(Pawn).GetWeaponAim(UTVehicleWeapon(UTVehicle(Pawn).Seats[0].Gun)));
	if(bInAttackProtocol())
		Focus = None;
	Sleep(1.2);
	if ( !IsTargetRelevant( Enemy )) {
		GotoState('Searching');
	}
	Goto('Begin');
}

function ApplyRandomStrafe()
{
	local Vehicle V; 

	V = Vehicle(Pawn);

	if (V != None)
	{
		V.Steering = FClamp(RandRange(-1.0,1.0) * EngagedDodgeAggressiveness, -1.0, 1.0) ;
		V.Throttle = FClamp(RandRange(-0.5,0.5) * EngagedDodgeAggressiveness, -1.0, 1.0) ;
		V.Rise = FClamp(RandRange(-0.25,0.25) * EngagedDodgeAggressiveness, -1.0, 1.0) ;
	}
}

function CheckLeash()
{
	local float LowCeilingHeight; 
	if(HostingActor == none || Pawn == none)
		return; 

	if(GetLowCeiling(LowCeilingHeight))
	{
		ClearTimer('ResetLowCeiling'); 
		bLowCeiling = true;
		ActorOffset.Z = 100;
		LeashLength = 150; 
	}
	else if(bLowCeiling && !IsTimerActive('ResetLowCeiling'))
	{
		SetTimer(2.0, false, 'ResetLowCeiling');
	}

	if(ScriptedMoveTarget == none && (VSize(Pawn.location - (HostingActor.location+ActorOffset)) > (GetStateName() == 'Engaged' ? LeashLength*EngagementLeashMult : LeashLength) && !bNeedsHeightCorrection))
	{
		if(IsTimerActive('DoRandomLookAround'))
		{
			ClearTimer('DoRandomLookAround');
		}

		ScriptedMoveTarget = HostingActor;
		ScriptedFocus = HostingActor; 
		Status = "Tugged by Leash" @ VSize(Pawn.location - HostingActor.location); 
		PushState('ScriptedMove');
	}
	else if(GetStateName() != 'Searching' && VSize(Pawn.location - HostingActor.location) <= (GetStateName() == 'Engaged' ? LeashLength*EngagementLeashMult : LeashLength))
	{ 
		if(Pawn.location.Z <= HostingActor.location.Z + ZTolerance)
		{
			bNeedsHeightCorrection = true; 
			SetTimer(1.0,false,'CheckZHeight');
			if(GetStateName() != 'ScriptedMove')
			{
				PushState('ScriptedMove');
			}
				
			return; 
		}
		else 
			bNeedsHeightCorrection = false; 

		ScriptedMoveTarget = none;
		ScriptedFocus = none; 
		StopLatentExecution();
		Status = "Reached Target" @ VSize(Pawn.location - (HostingActor.location+ActorOffset) ); 
		PrepareToStop();
		
		if(bRandomMoveWhileSearching && !IsTimerActive('DoRandomLookAround'))
			SetTimer(1.5, false, 'DoRandomLookAround');

		if(GetStateName() == 'ScriptedMove')
			GotoState('Auto');
	}
	
	if(GetStateName() == 'Searching' && bRandomMoveWhileSearching && !IsTimerActive('DoRandomLookAround'))
	{
		DoRandomLookAround(); //Sets timer in function
	}
}

function ResetLowCeiling()
{
	bLowCeiling = false; 
	TemporaryZOffset = 0; 
	ActorOffset = Protocols[DroneProtocol].ProtocolActorOffset;
	LeashLength = Protocols[DroneProtocol].ProtocolLeashLength;
}

function bool GetLowCeiling(out float CeilingHeight)
{
	local Vector TraceStart;
	local Vector TraceEnd;
	local Vector TraceExtent;
	local Vector OutHitLocation, OutHitNormal;
	local TraceHitInfo HitInfo;
	local Actor HitActor;

	TraceStart = HostingActor.Location;
	TraceEnd = HostingActor.Location+vect(0,0,800);
	
	// trace up and see if our Pawn is under something
	HitActor = HostingActor.Trace(OutHitLocation, OutHitNormal, TraceEnd, TraceStart, TRUE, TraceExtent, HitInfo, TRACEFLAG_Bullet);

	CeilingHeight = VSize(OutHitLocation - Pawn.Location) - 100 ; //Should always result in enough space

	return HitActor != none; 
}

function CheckZHeight()
{
	bNeedsHeightCorrection = Pawn.location.Z <= HostingActor.location.Z + ZTolerance;
	if(bNeedsHeightCorrection)
		SetTimer(1.0,false,'CheckZHeight');
}

function GiveVeterancy(int VP)
{
	if(!bAutoVet || RxIfc_Veterancy(Pawn) == none || RxIfc_Veterancy(Pawn).GetVRank() >= 9) return;
	
	Veterancy_Points+=VP; 
	
	if(Veterancy_Points >= Veterancy_Milestones[RxIfc_Veterancy(Pawn).GetVRank()]) 
	{
		Rx_Vehicle(Pawn).PromoteUnit(RxIfc_Veterancy(Pawn).GetVRank() + 1); //50 
	}
}

//Slow down
function PrepareToStop()
{
	local Vehicle V;

	if (Pawn.Physics != PHYS_Flying)
	{
		Pawn.Acceleration *= 0.25;
	}
	V = Vehicle(Pawn);
	if (V != None)
	{
		V.Steering *= 0.25;
		V.Throttle *= 0.25;
		V.Rise *= 0.0;
	}

	SetTimer(1.0,false,'StopMovement');
}

/** tells our pawn to stop moving */
function StopMovement()
{
	local Vehicle V;

	if (Pawn.Physics != PHYS_Flying)
	{
		Pawn.Acceleration = vect(0,0,0);
	}
	V = Vehicle(Pawn);
	if (V != None)
	{
		V.Steering = 0;
		V.Throttle = 0;
		V.Rise = 0;
	}
}

function SetLeash(float NewLength, float NewEngagementLeash)
{
	LeashLength = NewLength;
	EngagementLeashMult = fmax(1.0, NewEngagementLeash);
}

function DroneDestroyed()
{
	if(RxIfc_DroneHost(HostingActor) != none )
	{
		RxIfc_DroneHost(HostingActor).NotifyDroneDestroyed();
	}

	HostingActor = none; 
	Pawn = none; 
	PlayerReplicationInfo = none; 
	SetTimer(1.0, false, 'Destroy'); 
}

function LogWeapon()
{
    `log("Team Number:" @ GetTeamNum());
	`log("State:" @ GetStateName());
	`log("Protocol:" @ DroneProtocol);
	`log("Enemy: " @ Enemy);
}


DefaultProperties
{
	bIsPlayer = false 
	ActorOffset = (X=0, Y=0, Z=400)
	LeashLength = 1500
	EngagementLeashMult = 1.0
	ZTolerance = 100
	bRandomMoveWhileSearching = true 
	EngagedDodgeAggressiveness = 2.0

	//BR_REPAIR,
	Protocols(0) = (ProtocolLeashLength = 450, ProtocolEngagementLeashMult = 1.0, ProtocolActorOffset = (X=0,Y=0,Z=300) );
	//BR_FIGHTER
	Protocols(1) = (ProtocolLeashLength = 750, ProtocolEngagementLeashMult = 2.0, ProtocolActorOffset = (X=0,Y=0,Z=400) );
	//BR_GUARD
	Protocols(2) = (ProtocolLeashLength = 750, ProtocolEngagementLeashMult = 1.0, ProtocolActorOffset = (X=0,Y=0,Z=400) );
	//BR_SCOUT [Currently unused]
	Protocols(3) = (ProtocolLeashLength = 750, ProtocolEngagementLeashMult = 1.0, ProtocolActorOffset = (X=0,Y=0,Z=300) );

	bAutoVet = false 
}
