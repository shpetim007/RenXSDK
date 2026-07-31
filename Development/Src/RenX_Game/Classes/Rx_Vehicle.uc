/*********************************************************
*
* File: Rx_Vehicle.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle extends UTVehicle
	dependson(Rx_Pawn)
	//implements(Rx_IPurchasable) DEPRACATED ITEM
	implements(RxIfc_ClientSideInstantHitRadius)
	implements(RxIfc_SeekableTarget)
	implements(RxIfc_EMPable)
	implements(RxIfc_Targetable)
	implements(RxIfc_TargetedDescription)
	implements(RxIfc_Airlift)
	implements(RxIfC_RadarMarker)
	implements(RxIfc_Veterancy);

`define TakeEMPDamage TakeDamage(EMPDamage,EMPInstigator,vect(0,0,0),vect(0,0,0),EMPDmgType,,self)

var GameSkelCtrl_Recoil    Recoil;
var bool bLightArmor; //Used for an armour modifier
var const bool bIsAircraft;
var name RecoilTriggerTag; // call same as FireTriggerTags in Vehicle Weapon!
var bool bUsesBullets;
var Pawn PawnThatTrysToDrive;
var byte TeamBought; // to save the Teamnum before going neutral for vehiclecounter calculations
var bool fpCamera;
var Array<name> fpCameraTag;
var Array<name> tpCameraTag;
var int ZoomedFOV;
var PlayerReplicationInfo buyerPri;
var PlayerReplicationInfo BoundPRI;
var float TimeLastOccupied;
var bool bDriverLocked;
var bool bReservedToBuyer;
var float startTime;
var byte LastTeamToUse;
var bool bBindable;
var float ReservationLength;
var float oldMaxEngineTorque, oldThrottleSpeed, oldInsideTrackTorqueFactor;
var interpCurveFloat oldTorqueVSpeedCurve;
var float VehicleResetTime;
var float EMPHealModifier;
var bool bIsVehicleFromCrate;
var Rx_Sentinel_Obelisk_Laser_Base Obelisk;
var Rx_Sentinel_AGT_Rockets_Base AGT;

var bool bCanCapture;

var bool bCountTowardsVehicleLimit;

// UTVehicle only replicates driver and 1st passenger PRI. We need more of them.
var PlayerReplicationInfo PassengerPRIExtras[10];


var bool bOkAgainstBuildings; // Hint for AI

var protected float SavedDmg;
var const float     HealPointsScale;        /** how many points per healed HP */
var const float     DamagePointsScale;      /** how many points per damaged HP */
var const float     PointsForDestruction;
var bool  bReverseSteeringInverted;

var repnotify bool bEMPd;
var bool bEMPDisablesVehicle;
var Controller EMPInstigator;
var int EMPTimeLeft;
//var ParticleSystem EMPParticleTemplate;
var ParticleSystemComponent EMPParticleComponent;
var bool bEMPParticleAttached;

var int EMPTime;
var int EMPDamage;
var class<DamageType> EMPDmgType;
var AudioComponent EMPSound;

var name BrakeLightParameterName;	// material parameter that should be modified to turn the brake lights on and off
var name ReverseLightParameterName;	// material parameter that should be modified to turn the reverse lights on and off
var name HeadLightParameterName;	// material parameter that should be modified to turn the headlights on and off
var bool bBrakeLightOn;				// Internal variable.  Maintains brake light state to avoid extraMatInst calls.
var bool bReverseLightOn;			// Internal variable.  Maintains reverse light state to avoid extra MatInst calls.
var bool bHeadlightsOn;				// Internal variable.  Maintains headlight state to avoid extra MatInst calls.

var SoundCue SuspensionShiftSound;	/** Sound played whenever Suspension moves suddenly */
var bool bIsReducingFrontalCollisionGrip;

// Modifiers for rockets seeking this actor
var float SeekAimAheadModifier;
var float SeekAccelrateModifier;
var float ReducedThrottleForTurning;
var float SpeedAtWhichToApplyReducedTurningThrottle;
var SkeletalMesh SkeletalMeshForPT;

/** Wheel Dirt Fix Variables*/
var array<ParticleSystemComponent> WheelPSCs;
var ParticleSystem DefaultWheelPSCTemplate;
var ParticleSystem WheelParticleEffect, OldWheelParticleEffect;
var UTPhysicalMaterialProperty OldPhysicalProperty;

var bool bSprinting;
var repnotify bool bSprintingServer;

/**Shahman: Variables when being detected*/
var bool bSpotted;
var bool bTargetted;
var bool bFocused; 

/** Minimum speed multiplier for sprinting. */
var(Vehicle) repnotify float MinSprintSpeedMultiplier;

/** Maximum speed multiplier for sprinting. */
var(Vehicle) float MaxSprintSpeedMultiplier;

/** time interval for reaching maximum sprint speed. */
var(Vehicle) float SprintTimeInterval;

/** increment amount for addding/subtracting sprint speed modifier. */
var(Vehicle) float SprintSpeedIncrement;

var() SoundCue SprintBoostSound, SprintStopSound;

var bool bSecondaryFireTogglesFirstPerson;
var bool bCanResetSlip;

var Rx_Speaker Speaker;
//var bool bBlinkingName;

var byte UISymbol; 
/** reference to the texture to use for the Hud */
var() Texture VehicleIconTexture;
var() Texture MinimapIconTexture;

var float RegenerationRate, HeroicRegenerationRate;

/*For commander targeting*/
var bool bIsTarget;
var bool bIsDefensiveTarget; 
var bool bIsAdminTarget;  

/*Veterancy*/
struct VetInfo{
	var const float	VPReward; 
	var float HealthMod; //Health Increases for this unit as it ranks up (*X)
	var float SprintSpeedMod; //Sprint speed increases for this unit as it ranks up. (*X)
	var float SprintTTFDMod; 

	structdefaultproperties
	{
		HealthMod=1.0;
		SprintSpeedMod=1.0;
		SprintTTFDMod=0;
	}
};

var array<VetInfo> VetRankInfo;

var repnotify byte VRank; 
var byte TempVRank; //Hold onto the last VRank piloting if the driver leaves [avoids exploting getting out of a vehicle just before it explodes to deny bonuses]

var bool bHasPlayerEntered;

var bool bHijackBonus; /*When true, the vehicle grants a bonus when stolen. Resets after a minute and a half to prevent team-hampering*/
var bool bAlwaysRegenerate; //Should this unit ALWAYS regenerate? 
var bool bCanBePromoted ; 
var float LegitamateDamage;
var bool bTakingDamage; 
var float MaxDR; //Maximum resistance. Lower numbers are more resilient (0.0 is 100% resistance, 1.0 is no resistance)
/*Copied from beacons*/
var float					  Damage_Taken;

//For determining some VP stuff
var string SpotLocation; //Updated once per SpotUpdateTime
var float SpotUpdateTime; //Time to wait between updates (in seconds)

/*Track who does damage to me so I can distribute points correctly on death*/
var array<Attacker>	DamagingParties;	//Track who is doing damage to me to evenly distribute points

struct Repairer
{
	var PlayerReplicationInfo 	PPRI;
	var float					LastRepairTime;
};
var array<Repairer> CurrentHealers; //Track all healers from the last ten seconds  

var float DeathImpulseStrength; 

//Comm Centre
var byte RadarVisibility, LastRadarVisibility; //Set radar visibility. 0: Invisible to all 1: visible to your team 2: visible to enemy team 
//Shadow Bounds Scale (nBab)
var DynamicLightEnvironmentComponent MyLightEnvironment;

var array<float> BarrelLength; //Estimated length of the vehicle's barrels. Used to adjust where projectiles are spawned when clipping through geometry

//Heroic Effects 
var ParticleSystem		Heroic_MuzzleFlash;

var	repnotify bool				bPickedUp;

/** Rx_IPurchasable */
var const bool bHighTier;
var const int BasePurchaseCost;
var const localized string PT_Title;
var const localized string PT_Description;
var const Texture2D PT_Icon;

var protected repnotify LinearColor VehicleOverlayColour; 
//For HUD stuff, should only be used by mods/mutators.
var string CustomVehicleName;

//Death impulse 
var rotator DestroyedRotatorAddend; 
var float 	DestroyedImpulseOffset; //location + this is where the death impulse is applied (along the Y-axis)
var bool	bStayUprightOnDeath;

// Vars for Transitioning between vehicle and pawn cam when entering/exiting vehicles
var vector VehiclePawnTransitionStartLoc;
var float BlendPct;
var vector CalcViewLocation;

//Voice override for Pawns (Unused by most vehicles, so should be none)
var class<Rx_Pawn_VoiceClass> VehicleVoiceClass;

var repnotify SoundCue CurrentHornSound;//Controllable horn sound
var SkeletalMeshComponent DevFlag;
var AudioComponent FlagAmbient;
var repnotify Texture2D DevFlagTexture;
var MaterialInstanceConstant FlagMIC;
var float SpawnOffset;
var float SpawnHeightOffset;

var float FOVMultiplier, FOVZoomedMultiplier, FOVChangeRate;

var repnotify bool bPassengerControlTurret;
var int TurretPassengerIndex;
var Rx_Vehicle_Weapon MainWeapon;

var repnotify rotator PassengerWeaponRotation ;
var repnotify vector PassengerFlashLocation ;
var repnotify byte PassengerFlashCount ;
var repnotify byte PassengerFiringMode ; 
var bool bCanCarryHeavies;
var string UIString;

/* Collision Suppression (to keep vehicles going absolutely insane when colliding with / pushing  things) */
var(CollisionSuppression) bool bUsesCollisionSuppression; //if false, it doesn't concern itself with any collision suppression (Mostly aircraft)
var(CollisionSuppression) vector WeightResistance;
var float CutTorqueModifier; // Dynamic number we change
var(CollisionSuppression) float PushTorqueMult; //%of our Torque we get when trying to push something (Generally pretty low)
var bool bUseLinearCollisionSupp, bUseLateralCollisionSupp; //Linear (front back) and Lateral (Left Right) collision suppreession
var float LastThrottle; 

//TODO: Use rectangles/traces for checking 
var int PushCheckDistanceFront, PushCheckDistanceRear; //How far out to start the trace for a push check (Should be front of the vehicle, not including the barrel/turret or anything) 
var int PushCheckRadius;

//Starting point to check if we're colliding/almost colliding with another vehicle (should be the front left of the vehicle). 
var(CollisionSuppression) vector PushCheckMax; 
var(CollisionSuppression) vector PushCheckVWidth, PushCheckVLength; 
var(CollisionSuppression) vector PushCheckExtent; //The extent used by each trace (should just be Z value to indicate height)
var(CollisionSuppression) bool bVCollisionFront, bVCollisionLeft, bVCollisionRight, bVCollisionRear; 
//Minimum physical weight of the 'other' vehicle to warrant activating suppression (By percent of our weight)
var(CollisionSuppression) float SuppressionMinWtPct; 

//When pushing/being pushed from the front or back, multiply our default StayUpright constraints by these
var(CollisionSuppression) float PushingUprightResistPitchMult, PushingUprightResistRollMult; 
var(CollisionSuppression) float ParkedUprightResistPitchMult, ParkedUprightResistRollMult; 

var(CollisionSuppression) bool bDrawCollisionDebug;

var ParticleSystem VehicleCollisionEffect;
var bool bCanPlayHeavyShift; 

var bool bCrushable; 
var bool bCanCrushVehicles; 
var byte CrushTier;  
var bool bOverrideDevHorn; 

var class<UTFamilyInfo> CurrCharClassInfo;
//Pawn Voices
var Rx_AudioComponent VoiceComponent; 
var bool		   bCanHitReact; //Used to determine if we should play a hit reaction sound
var float			LastHitReactTime, HitTauntWindow; 
var bool		   bPlayAssistSound;
var byte 			LastPicked_KillConfirm, LastPicked_Hit, LastPicked_VKillConfirm, LastPicked_BKill, LastPicked_Assist, DeathSound, VehicleAcquiredSound; //Used in Randomization for voice sounds
struct VoiceBlock
{
	var int	 VoiceIndex;
	var name SoundType;
	var bool bCanOverride;
};

var repnotify VoiceBlock ReplicatedVoice;
var bool bUseParkingBrake;



replication
{
	if (bNetDirty && Role == ROLE_Authority )
		bSprintingServer, MinSprintSpeedMultiplier, bSpotted, bFocused, buyerPri, BoundPRI, bDriverLocked, UISymbol, VRank, RadarVisibility, bPickedUp, VehicleOverlayColour, CurrentHornSound, EMPTimeLeft, bUseLinearCollisionSupp, bUseLateralCollisionSupp; //bBlinkingName

	if (bNetDirty && Role == ROLE_Authority)
		PassengerPRIExtras;

	if (bNetDirty || bNetInitial)
        DevFlagTexture, bPassengerControlTurret,MainWeapon, LastTeamToUse, bTakingDamage, ReplicatedVoice, CurrCharClassInfo, bEMPd;

	if (bNetDirty && !bDemoRecording && bPassengerControlTurret && Seats.Length > 1 && !IsSeatControllerReplicationViewer(1))
		PassengerWeaponRotation, PassengerFlashLocation, PassengerFlashCount, PassengerFiringMode;
}

static function int Cost(Rx_PRI Context) {
	local float Multiplier;
	
	Multiplier = 1.0;
	
	if (`RxGameObject.PurchaseSystem.AreTeamPowerPlantsDestroyed(Context.GetTeamNum())) 
		Multiplier = 1.5;
	
	if (`RxGameObject.PurchaseSystem.AreTeamFactoriesDestroyed(Context.GetTeamNum()))
		Multiplier *= 2;

	return default.BasePurchaseCost * Multiplier;
}

static function EAvailability Available(Rx_PRI Context) 
{
	
	if (default.bHighTier && `RxGameObject.PurchaseSystem.AreTeamFactoriesDestroyed(Context.GetTeamNum())) 
	{
			return PURCHASE_HIDDEN;
	}
	
	return PURCHASE_AVAILABLE;
}

static function RxIfc_FactoryVehicle GetVehicleFactory(byte TeamNum) {
	if (TeamNum == TEAM_GDI)
		return `RxGameObject.PurchaseSystem.WeaponsFactory[0];
	
	return `RxGameObject.PurchaseSystem.Airstrip[0];
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'DevFlagTexture')
    {
        UpdateDevFlag(DevFlagTexture);
    } 
	else if (VarName == 'bEMPd')
	{
		if (bEMPd)
		{
			StartEMPEffects();
			// Fallback timer in case StopEffects doesn't work the first time it is called due to a bug that may/may not still exist.
			SetTimer(EMPTime+2,false,'FallbackStopEMPEffects');
		}
		else
		{
			StopEMPEffects();
			UpdateThrottleAndTorqueVars();
		}
			
	}
	else if(VarName == 'bSprintingServer')
	{
		if(!bSprintingServer && IsTimerActive('DecreaseSprintSpeed'))
		{
			ClearTimer('DecreaseSprintSpeed');
			UpdateThrottleAndTorqueVars();
		}
				
		if(UDKVehicleSimChopper(SimObj) != None)
		{
			UDKVehicleSimChopper(SimObj).MaxStrafeForce = bSprintingServer ? UDKVehicleSimChopper(SimObj).Default.MaxStrafeForce * Rx_Vehicle_Air(self).MaxStrafeForce : UDKVehicleSimChopper(SimObj).Default.MaxStrafeForce;
			UDKVehicleSimChopper(SimObj).MaxRiseForce = bSprintingServer ? UDKVehicleSimChopper(SimObj).Default.MaxRiseForce * Rx_Vehicle_Air(self).MaxRiseForce : UDKVehicleSimChopper(SimObj).Default.MaxRiseForce;
			UDKVehicleSimChopper(SimObj).MaxYawRate = bSprintingServer ? UDKVehicleSimChopper(SimObj).Default.MaxYawRate * Rx_Vehicle_Air(self).MaxYawRate : UDKVehicleSimChopper(SimObj).Default.MaxYawRate;
			UDKVehicleSimChopper(SimObj).RollTorqueStrafeFactor = bSprintingServer ? UDKVehicleSimChopper(SimObj).Default.RollTorqueStrafeFactor * Rx_Vehicle_Air(self).RollTorqueStrafeFactor : UDKVehicleSimChopper(SimObj).Default.RollTorqueStrafeFactor;
			UDKVehicleSimChopper(SimObj).PitchTorqueFactor = bSprintingServer ? UDKVehicleSimChopper(SimObj).Default.PitchTorqueFactor * Rx_Vehicle_Air(self).PitchTorqueFactor : UDKVehicleSimChopper(SimObj).Default.PitchTorqueFactor;	
		}  			
	}
	else if(VarName == 'MinSprintSpeedMultiplier')
	{
		UpdateThrottleAndTorqueVars();
	}
	else if(VarName == 'bIsTarget')
	{
		if(bIsTarget)
			SetTargetAlarm(25);
	}
	else if(VarName == 'VRank')
	{
		
		if(Vrank == 9)
		{
			SetHeroicMuzzleFlash(true);
			SetHeroicAmbientSounds(true); 
		}
		else		
		{
			SetHeroicMuzzleFlash(false);	
			SetHeroicAmbientSounds(false); 
		}

	}
	else if(VarName == 'bPickedUp')
	{
		if(bPickedUp) SetPhysics(PHYS_NONE); 
		else
		SetPhysics(PHYS_RigidBody);
	}
	else if(VarName == 'VehicleOverlayColour')
	{
		SetOverlay(VehicleOverlayColour);
	} 
	else if(VarName == 'CurrentHornSound')
	{
		HornSounds[0] = CurrentHornSound;
	} 
	else if(VarName == 'ReplicatedVoice')
	{
		//`log("Replicated Voice"); 
		if(ReplicatedVoice.SoundType != 'NULL')
			PlayVoiceSound(ReplicatedVoice.SoundType, 
		ReplicatedVoice.bCanOverride, ReplicatedVoice.VoiceIndex) ;
	}
	/*
	else if(VarName == 'fpCamera')
	{
		if(!fpCamera)
		{
			fpCamera = false;
			Seats[0].CameraTag = tpCameraTag;
			OldPositions.Length=0;
		}
		else
		{
			fpCamera = true;
			Seats[0].CameraTag = fpCameraTag;
		}
	}
	*/
	else if(VarName == 'bPassengerControlTurret')
    {
        SwitchTurretControl(bPassengerControlTurret);
    }
	else
		super.ReplicatedEvent(VarName);

}

simulated function float GetStamina()
{
	return -1.0f;
}

simulated function string GetStaminaName()
{
	return "Stamina";
}

simulated function SetRadarVisibility(byte Visibility)
{
	RadarVisibility = Visibility; 
	
	if(Rx_PRI(PlayerReplicationInfo) != none) 
		Rx_PRI(Controller.PlayerReplicationInfo).PawnRadarVis = Visibility;
	else if (Rx_ScriptedBotPRI(PlayerReplicationInfo) != None)
		Rx_ScriptedBotPRI(PlayerReplicationInfo).RadarVisibility = Visibility;
}

simulated function SendRadarSpotted()
{
	if(WorldInfo.NetMode != NM_DedicatedServer) 
	{
		ServerSetRadarSpotted(); 
	}
} 

reliable server function ServerSetRadarSpotted()
{
	if(Rx_Controller(Controller) != none )
	{
		Rx_Controller(Controller).SetSpottedRadarVisibility();
	}
	else if(Rx_Bot(Controller) != none )
	{
		Rx_Bot(Controller).SetSpottedRadarVisibility();
	}
	else if(Rx_Vehicle_HarvesterController(Controller) != none )
	{
		Rx_Vehicle_HarvesterController(Controller).SetSpottedRadarVisibility();
	}
}

simulated function PlayerReplicationInfo GetSeatPRI(int SeatNum)
{
	if ( Role == ROLE_Authority )
	{
		return Seats[SeatNum].SeatPawn.PlayerReplicationInfo;
	}
	else
	{
		switch(seatNum)
		{
			case 0:
				return PlayerReplicationInfo;
			case 1:
				return PassengerPRI;
			default:
				if(SeatNum < 12)
					return PassengerPRIExtras[seatNum-2];
		}
	}

	// If we're over 12 seats, then let's just not do the replication. I don't know what insane person would do that, but please just don't
	return None; 
}

function SetSeatStoragePawn(int SeatIndex, Pawn PawnToSit)
{
	super.SetSeatStoragePawn(seatindex,pawntosit);
	
	if(SeatIndex >= 2)
		PassengerPRIExtras[SeatIndex - 2] = (PawnToSit == None) ? None : Seats[SeatIndex].SeatPawn.PlayerReplicationInfo;		
}

function startUpDriving()
{
	SetTimer(1.0,false,'moveVehicleAwayFromSpawnpoint');
	SetTimer(ReservationLength,false,'openVehToAllPlayersAfterBuy');
	startTime = WorldInfo.TimeSeconds;
}

function startUpDrivingWithDelay()
{
	SetTimer(2.5,false,'moveVehicleAwayFromSpawnpointAir');
	SetTimer(ReservationLength,false,'openVehToAllPlayersAfterBuy');
	startTime = WorldInfo.TimeSeconds;
}

simulated function UpdateFOV(optional float ChangeRate)
{
	local Rx_Controller UTPC;

	UTPC = Rx_Controller(Controller);
	
	//`log("UpdateFOV" @ UTPC);

	if(UTPC == None || (WorldInfo.NetMode != NM_DedicatedServer && Controller != GetALocalPlayerController())) // either AI or non-local player
		return;

	if(ChangeRate != 0)
		FOVChangeRate = ChangeRate;
	else
		FOVChangeRate = default.FOVChangeRate;

	if(fpCamera) {
		UTPC.StartZoom(UTPC.DefaultFOV * FOVZoomedMultiplier, FOVChangeRate);
	}
	else {
		UTPC.StartZoom(UTPC.DefaultFOV * FOVMultiplier, FOVChangeRate);
	}
}

function ToggleCam()
{
	if(fpCamera)
	{
		fpCamera = false;
//		Seats[0].CameraTag = tpCameraTag;
		OldPositions.Length=0;
		UpdateFOV();
	}
	else
	{
		fpCamera = true;
//		Seats[0].CameraTag = fpCameraTag;
		UpdateFOV();
	}
	ServerChangeFpCamera(fpCamera);
}

reliable server function ServerChangeFpCamera(bool newFpCamera)
{
	fpCamera = newFpCamera;
	if(!newFpCamera)
	{
		fpCamera = false;
		//Seats[0].CameraTag = tpCameraTag[0];
		OldPositions.Length=0;
		UpdateFOV();
	}
	else
	{
		fpCamera = true;
		//Seats[0].CameraTag = fpCameraTag[0];
		UpdateFOV();
	}
	
}


/** For Antenna delegate purposes (let's turret motion be more dramatic)*/
function vector GetVelocity()
{
	if (WorldInfo.TimeSeconds - CreationTime < 0.5f)
		return vect(0,0,0);

	return Velocity;
}

simulated event PostBeginPlay()
{
	local int i;
	
	super.PostBeginPlay();
	Team  = 255;

	Mesh.AttachComponentToSocket(DevFlag, 'FlagSocket');
    FlagAmbient = CreateAudioComponent(SoundCue'RX_Deco_Flag.banner.Sound.SC_Flag', false, true, true);
	
	//set shadow frustum scale (nBab)
	SetShadowBoundsScale();
	
	if(ROLE == ROLE_Authority && RxIfc_Harvester(self) == none && Rx_Defence(self) == none) 
	{
		bAlwaysRelevant = Rx_Game(WorldInfo.Game).bVehiclesAlwaysRelevant; 
		
		if(!bAlwaysRelevant) 
			SetTimer(0.1,true,'UpdatePRILocation'); 
	}
	
	if (Mesh != None && (ROLE == ROLE_SimulatedProxy || WorldInfo.NetMode == NM_StandAlone) && Rx_Vehicle_Air(self) == None)
	{
		SetTimer(0.5, true, 'CheckWheelEmitters');
		for( i=0; i< Wheels.Length; i++ )
		{
			WheelPSCs[i] = new () class'ParticleSystemComponent';
			if( WheelPSCs[i] != none )
			{
				WheelPSCs[i].SetTemplate(DefaultWheelPSCTemplate);
				Mesh.AttachComponentToSocket(WheelPSCs[i], name("WheelEffectSocket"$i));
			}
			OldWheelParticleEffect = DefaultWheelPSCTemplate;
		}
	}

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		MaterialInstanceConstant(Mesh.GetMaterial(0)).SetScalarParameterValue('Camo_Offset_Seed', FRand());
		MaterialInstanceConstant(Mesh.GetMaterial(0)).SetScalarParameterValue('Camo_Scale_Seed', (FRand() % 0.4) + 0.8);
	}

	SetTimer(SpotUpdateTime,true,'UpdateSpotLocation');
}

//set shadow frustum scale (nBab)
simulated function SetShadowBoundsScale()
{
	MyLightEnvironment = DynamicLightEnvironmentComponent(Mesh.LightEnvironment);
	MyLightEnvironment.LightingBoundsScale = Rx_MapInfo(WorldInfo.GetMapInfo()).GroundVehicleShadowBoundsScale;
	Mesh.SetLightEnvironment(MyLightEnvironment);
}

// Turn lights on/off and also control tail, break, and reverse lights
simulated function Tick( FLOAT DeltaSeconds )
{
	local bool bSetBrakeLightOn, bSetReverseLightOn;	
	local bool bUpdateBrakeLight, bUpdateReverseLight, bUpdateHeadLight;
	local int i;

	//if(Controller != none)
	//	GetIsCollidingVehicle(true);

	if(bUseLateralCollisionSupp || bUseLinearCollisionSupp)
	{
		TickWeightResistance(DeltaSeconds); 
	}
/*
	if( Rx_Vehicle_Treaded(self) != None && Steering != 0 && Throttle > 0 && VSizeSq(Velocity) > Square(SpeedAtWhichToApplyReducedTurningThrottle))
	{
		Throttle = ReducedThrottleForTurning;
	}
*/
	// client side effects follow - return if server or not rendered
	if (LastRenderTime < WorldInfo.TimeSeconds - 0.2)
		return;
	
	// Update brake light and reverse light
	// Both lights default to off.

	// only check if player is available to avoid memory leak
	if(PlayerReplicationInfo != None)
	{
		// check if vehicle is braking (NOTE : Hover vehicles always 'brakes' while tanks never do. In this case, we use different way to calculate instead)
		if(UDKVehicleSimCar(SimObj) != None && ( (OutputBrake > 0.0) || bOutputHandbrake) && (VSizeSq(Velocity) > 4.0) )
		{
			bSetBrakeLightOn = true;
			if ( !bBrakeLightOn )
			{	
				// turn on brake light
				bBrakeLightOn = TRUE;
				bUpdateBrakeLight = True;
			}
		}
		else if( (Throttle < 0.0 && (Vector(Rotation) dot Normal(Velocity)) > 0.0) || (Throttle > 0.0 && (Vector(Rotation) dot Normal(Velocity)) < 0.0)) // basically throttle and actual velocity are on opposite direction
		{
			bSetBrakeLightOn = true;
			if ( !bBrakeLightOn )
			{	
				// turn on brake light
				bBrakeLightOn = TRUE;
				bUpdateBrakeLight = True;
			}			
		}
	}

	// check if vehicle is in reverse
	if ( Throttle < 0.0 )
	{
		bSetReverseLightOn = true;
		if ( !bReverseLightOn )
		{
			// turn on reverse light
			bReverseLightOn = true;
			bUpdateReverseLight = true;
		}
	}

	if ( bBrakeLightOn && !bSetBrakeLightOn )
	{
		// turn off brake light
		bBrakeLightOn = false;
		bUpdateBrakeLight = true;
	}
	if ( bReverseLightOn && !bSetReverseLightOn )
	{
		// turn off reverse light & goto normal tail lights
		bReverseLightOn = false;
		bUpdateReverseLight = true;
	}

	// update headlights & breaklights (Basically switch lights off when the vehicle is empty)
	if ( bHeadlightsOn )
	{
		if ( PlayerReplicationInfo == None )
		{
			// turn off headlights
			bHeadlightsOn = false;
			bUpdateHeadLight = true;
			bUpdateBrakeLight = true;
		}
	}
	else if ( PlayerReplicationInfo != None )
	{
		// turn on headlights
		bHeadlightsOn = true;
		bUpdateHeadLight = true;
		bUpdateBrakeLight = true;
	}

	for (i = 0; i < Mesh.Materials.Length; i++)
	{
		if(MaterialInstanceConstant(Mesh.Materials[i]) != None)
		{
			if(bUpdateHeadLight)
				MaterialInstanceConstant(Mesh.Materials[i]).SetScalarParameterValue(HeadLightParameterName, bHeadlightsOn ? 1.0 : 0.0);

			if(bUpdateBrakeLight)
			{
				if(PlayerReplicationInfo != None)
				{
					MaterialInstanceConstant(Mesh.Materials[i]).SetScalarParameterValue(BrakeLightParameterName, bBrakeLightOn ? 2.0 : 1.0);
				}
				else
					MaterialInstanceConstant(Mesh.Materials[i]).SetScalarParameterValue(BrakeLightParameterName, 0.0);
			}

			if(bUpdateReverseLight)
				MaterialInstanceConstant(Mesh.Materials[i]).SetScalarParameterValue(ReverseLightParameterName, bReverseLightOn ? 1.0 : 0.0);
		}
	}

	for (i = 0; i < Mesh.SkeletalMesh.Materials.Length; i++)
	{
		if(MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[i]) != None)
		{
			if(bUpdateHeadLight)
				MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[i]).SetScalarParameterValue(HeadLightParameterName, bHeadlightsOn ? 1.0 : 0.0);

			if(bUpdateBrakeLight)
			{
				if(PlayerReplicationInfo != None)
				{
					MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[i]).SetScalarParameterValue(BrakeLightParameterName, bBrakeLightOn ? 2.0 : 1.0);
				}
				else
					MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[i]).SetScalarParameterValue(BrakeLightParameterName, 0.0);
			}

			if(bUpdateReverseLight)
				MaterialInstanceConstant(Mesh.SkeletalMesh.Materials[i]).SetScalarParameterValue(ReverseLightParameterName, bReverseLightOn ? 1.0 : 0.0);
		}
	}

	if(bDrawCollisionDebug)
		DrawPushDebug(); 
	
}

function StartSprint()
{
	if(!bSprinting && !bEMPd)
	{
		if(!IsTimerActive('IncreaseSprintSpeed'))
		{
			if(MinSprintSpeedMultiplier*GetSpeedModifier() == Default.MinSprintSpeedMultiplier*GetSpeedModifier())
				IncreaseSprintSpeed();
			else
				SetTimer(SprintTimeInterval, true, 'IncreaseSprintSpeed');
		}

		if(IsTimerActive('DecreaseSprintSpeed'))
		{
			ClearTimer('DecreaseSprintSpeed');
		}
		
		VehicleEvent('SprintStart');

		if(SprintBoostSound != none) PlaySound(SprintBoostSound, TRUE, FALSE, FALSE, Location, FALSE);

		bSprinting = true;
	}
}

function StopSprinting()
{
	if(bSprinting)
	{
		bSprinting = false;
		if(!IsTimerActive('DecreaseSprintSpeed'))
		{	
			SetTimer(0.25, true, 'DecreaseSprintSpeed');
		}

		if(IsTimerActive('IncreaseSprintSpeed'))
		{
			ClearTimer('IncreaseSprintSpeed');
		}

		VehicleEvent('SprintStop');
		if(SprintStopSound != none) PlaySound(SprintStopSound, TRUE, FALSE, FALSE, Location, FALSE);
		
	}
}

reliable server function ServerSetGroundSpeed(float Speed)
{
	if(bEMPd && bEMPDisablesVehicle) Speed = 0; 
	
	if(Speed > default.GroundSpeed)
	{
		bSprintingServer = true;
	} 
	else
	{
		bSprintingServer = false;
	}

	GroundSpeed = Speed;	
}
reliable server function ServerSetAirSpeed(float Speed)
{
	if(bEMPd && bEMPDisablesVehicle) Speed = 0; 
	
	if(Speed > default.AirSpeed)
	{
		bSprintingServer = true;
	} 
	else
	{
		bSprintingServer = false;
	}
	AirSpeed = Speed;	
}
reliable server function ServerSetWaterSpeed(float Speed)
{
	if(bEMPd && bEMPDisablesVehicle) Speed = 0; 
	
	if(Speed > default.WaterSpeed)
	{
		bSprintingServer = true;
	} 
	else
	{
		bSprintingServer = false;
	}
	WaterSpeed = Speed;	
}
reliable server function ServerSetMaxSpeed(float Speed)
{
	if(bEMPd && bEMPDisablesVehicle) Speed = 0; 
	
	if(Speed > default.MaxSpeed)
	{
		bSprintingServer = true;
	} 
	else
	{
		bSprintingServer = false;
	}
	MaxSpeed = Speed;	
}

reliable server function IncreaseSprintSpeed()
{
	local float SprintSpeed_Air;
	local float SprintSpeed_Ground;
	local float SprintSpeed_Water;
	local float VGround_SprintSpeedMax;
	
	if(bEMPd) return; 
	
	VGround_SprintSpeedMax = default.MaxSprintSpeedMultiplier*GetSpeedModifier() ;

	MinSprintSpeedMultiplier += SprintSpeedIncrement*GetSpeedModifier();
	
	if(MinSprintSpeedMultiplier >= VGround_SprintSpeedMax)
	{
		MinSprintSpeedMultiplier = VGround_SprintSpeedMax;
		if(IsTimerActive('IncreaseSprintSpeed'))
		{
			ClearTimer('IncreaseSprintSpeed');
		}
	}

	SprintSpeed_Air = Default.AirSpeed * MinSprintSpeedMultiplier * GetSpeedModifier() * GetScriptedSpeedModifier();
	SprintSpeed_Ground = Default.GroundSpeed * MinSprintSpeedMultiplier * GetSpeedModifier() * GetScriptedSpeedModifier();
	SprintSpeed_Water = Default.WaterSpeed * MinSprintSpeedMultiplier * GetSpeedModifier() * GetScriptedSpeedModifier();

	if(PlayerController(Controller) != None)
	{
		ServerSetAirSpeed(SprintSpeed_Air);
		ServerSetGroundSpeed(SprintSpeed_Ground);
		ServerSetWaterSpeed(SprintSpeed_Water);
	}

	AirSpeed = SprintSpeed_Air;
	GroundSpeed = SprintSpeed_Ground;
	WaterSpeed = SprintSpeed_Water;

	if(UDKVehicleSimCar(SimObj) != None)
		UDKVehicleSimCar(SimObj).ThrottleSpeed = UDKVehicleSimCar(SimObj).Default.ThrottleSpeed * MinSprintSpeedMultiplier * GetScriptedSpeedModifier();
}
reliable server function DecreaseSprintSpeed()
{
	MinSprintSpeedMultiplier -= SprintSpeedIncrement;
	if(MinSprintSpeedMultiplier <= Default.MinSprintSpeedMultiplier)
	{
		MinSprintSpeedMultiplier = Default.MinSprintSpeedMultiplier;
		if(IsTimerActive('DecreaseSprintSpeed'))
		{
			ClearTimer('DecreaseSprintSpeed');

		}
	}
	if(PlayerController(Controller) != None)
	{
		ServerSetAirSpeed(AirSpeed);
		ServerSetGroundSpeed(GroundSpeed);
		ServerSetWaterSpeed(WaterSpeed);
	}

	AirSpeed = Default.AirSpeed * GetScriptedSpeedModifier();
	GroundSpeed = Default.GroundSpeed * GetScriptedSpeedModifier();
	WaterSpeed = Default.WaterSpeed * GetScriptedSpeedModifier();

	if(UDKVehicleSimCar(SimObj) != None)
		UDKVehicleSimCar(SimObj).ThrottleSpeed = UDKVehicleSimCar(SimObj).Default.ThrottleSpeed * GetScriptedSpeedModifier();
}

reliable server function HardSprintStop()
{
	MinSprintSpeedMultiplier -= default.MinSprintSpeedMultiplier  * GetScriptedSpeedModifier();
	if(IsTimerActive('DecreaseSprintSpeed'))
	{
		ClearTimer('DecreaseSprintSpeed');
	}
	
	AirSpeed = Default.AirSpeed * GetScriptedSpeedModifier();
	GroundSpeed = Default.GroundSpeed * GetScriptedSpeedModifier();
	WaterSpeed = Default.WaterSpeed * GetScriptedSpeedModifier();

	if(PlayerController(Controller) != None)
	{
		ServerSetAirSpeed(AirSpeed);
		ServerSetGroundSpeed(GroundSpeed);
		ServerSetWaterSpeed(WaterSpeed);
	}

	if(UDKVehicleSimCar(SimObj) != None)
		UDKVehicleSimCar(SimObj).ThrottleSpeed = UDKVehicleSimCar(SimObj).Default.ThrottleSpeed  * GetScriptedSpeedModifier();
}

function UnmarkTarget()
{
	bTargetted = false;
}

simulated function vector GetCameraStart(int SeatIndex)
{
	local vector CamStart;

	// fpcamera only applies to the driver, so keep this from breaking the other seat's camera by accident

	if (fpCamera && SeatIndex == 0 && SeatIndex < fpCameraTag.length)
	{
		if (Mesh.GetSocketWorldLocationAndRotation(fpCameraTag[SeatIndex], CamStart) )
		{
			return CamStart;
		}
	}
	return Super.GetCameraStart(SeatIndex);
}


simulated function DrivingStatusChanged()
{
	// turn parking friction on or off
	bUpdateWheelShapes = true;

	// possibly use different physical material while being driven (to allow properties like friction to change).
	/**
	if ( bDriving )
	{
		if(Role == ROLE_Authority && Rx_Vehicle_Treaded(self) != None)
		{
			//SetTimer(0.05,true,'FrontalCollisionGripReductionTimer');
		}
		if ( DrivingPhysicalMaterial != None )
		{		
			Mesh.SetPhysMaterialOverride(DrivingPhysicalMaterial);
		}
	}
	else if ( DefaultPhysicalMaterial != None )
	{			
		Mesh.SetPhysMaterialOverride(DefaultPhysicalMaterial);
	}*/

	if ( bDriving && !bIsDisabled )
	{
		VehiclePlayEnterSound();
	}
	else if ( Health > 0 )
	{
		VehiclePlayExitSound();
	}

	if (!bDriving)
	{
		// Put brakes on before driver gets out! :)
		Throttle = 0;
		Steering = 0;
		Rise = 0;
	} 

	bBlocksNavigation = !bDriving;

	if (!bDriving)
	{
		StopFiringWeapon();

		SetMovementEffect(0, false);
		SetTexturesToBeResident(false);
		
		/**
		if(Role == ROLE_Authority)
		{
			ClearTimer('FrontalCollisionGripReductionTimer');
		}*/		
	}

	VehicleEvent(bDriving ? 'EngineStart' : 'EngineStop');
}

function FrontalCollisionGripReductionTimer()
{
	local int i;
	
	if(RxIfc_Harvester(self) == None && Rx_Vehicle_Treaded(self) != None)
	{

		if(bFrontalCollision && !bIsReducingFrontalCollisionGrip)
		{
			for(i=0; i<Wheels.length; i++)
			{
				if(UDKVehicleWheel(Wheels[i]) != None)
				{
					Wheels[i].LongSlipFactor = 0.85;
				}
			}
			bIsReducingFrontalCollisionGrip = true;
			bCanResetSlip = false;
			SetTimer(1.0, false, 'canResetSlipTimer');
		}
		
		if(Throttle == 0.0)
			bCanResetSlip = true; 
		if(!bFrontalCollision && bCanResetSlip && bIsReducingFrontalCollisionGrip) 
		{
			for(i=0; i<Wheels.length; i++)
			{
				if(UDKVehicleWheel(Wheels[i]) != None)
				{
					Wheels[i].LongSlipFactor = Wheels[i].default.LongSlipFactor;
				}
			}
			bIsReducingFrontalCollisionGrip = false;
		}
	}
}

function LogWheelNormals()
{

}

function canResetSlipTimer()
{
	bCanResetSlip = true;
} 

/** added recoil */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	Super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh && Mesh != none)
		Recoil = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil') );
}

/**
 * Team is changed when vehicle is possessed
 */
event SetTeamNum(byte toTeam)
{
	if ( toTeam != Team )
	{
		Team = toTeam;
		TeamChanged();
	}

	NotifyCaptuePointsOfTeamChange();
}

simulated function TeamChanged()
{
	if (Rx_GRI(WorldInfo.GRI) != none)
		Rx_GRI(WorldInfo.GRI).VehChangedTeam(self);
}

function NotifyCaptuePointsOfTeamChange()
{
	local Rx_CapturePoint CP;
	local Rx_Volume_CaptureArea VCA;

	foreach TouchingActors(class'Rx_CapturePoint', CP)
		CP.NotifyVehicleTeamChange(self);

	foreach TouchingActors(class'Rx_Volume_CaptureArea', VCA)
	{
		CP = VCA.CapturePoint;
			
		if(CP != None)
			CP.NotifyVehicleTeamChange(self);
	}
}

/**
 * An interface for causing various events on the vehicle.
 * also recoil is called here
 */
simulated function VehicleEvent(name EventTag)
{
	super.VehicleEvent(EventTag);

	PlayRecoil(EventTag);
}

simulated function PlayRecoil(name EventTag)
{
	if (RecoilTriggerTag == EventTag && Recoil != none)
		Recoil.bPlayRecoil = true;
}


exec function ReloadWeapon()
{
	if( Weapon != none && Rx_Vehicle_Weapon_Reloadable(Weapon) != none )
	{
		Rx_Vehicle_Weapon_Reloadable(Weapon).ReloadWeapon();
	}
}

simulated function EntryAnnouncement(Controller C)
{
	// dont call super to remove the Hijacked sounds
}

function bool TryToDrive(Pawn P)
{
	local vector X,Y,Z;
	local bool bFreedSeat;
	local bool bEnteredVehicle;

	local Pawn DriverTemp;
	local Rx_SoftLevelBoundaryVolume volume;
	local Rx_Controller PC;

	// Bots should only be drivers, not passengers
	if(Rx_VehRolloutController(Controller) == None && Driver != None && UTBot(P.Controller) != None) 
		return false; 

	PC = Rx_Controller(P.PlayerReplicationInfo.Owner);
	
	if(PC != None && PlayAreaVolumeOfPawn(self) == None && PlayAreaVolumeOfPawn(P) != None)
	{	
		PC.clientmessage("Try entering the vehicle from another side! As the vehicle is outside the map boundaries it can´t be entered from your current location!");
		return false; // Pawn has to step out of the PlayArea aswell so that he triggers the PlayArea UnTouch() event
	}	

	// disallow entering scripted bot's vehicle
	if(Rx_Pawn_Scripted(Driver) != None || Rx_Bot_Scripted(Controller) != None)
	{
		PC.clientmessage("This vehicle is being controlled by an NPC!");
		return false;
	}

	if(buyerPri != none)
	{ 
		if (bReservedToBuyer && P.PlayerReplicationInfo != buyerPri)
		{
			if(P.PlayerReplicationInfo.Owner != None && PC != None) 
			{
				PC.ReceiveVehicleMessageWithInt(class'Rx_Message_Vehicle',VM_NoEntry_BuyerReserved,buyerPri,,Class,Int(ReservationLength - `TimeSince(startTime))+1);
			}
			return false;
		}
		else if (P.GetTeamNum() != buyerPri.GetTeamNum() || P.GetTeamNum() != GetTeamNum()) // so if you switch team after buying, you don't get to circumvent the exclusivity
		{
			if(P.PlayerReplicationInfo.Owner != None && PC != None) 
			{
				PC.ReceiveVehicleMessageWithInt(class'Rx_Message_Vehicle',VM_NoEntry_TeamReserved,buyerPri,,self,Int(ReservationLength - `TimeSince(startTime))+1);
			}
			return false;
		}
	}

	// If a human tries to enter kick out the Rollout AI driver
	if(Driver != none && Rx_VehRolloutController(Controller) != none) {
		bAllowedExit = true;
		driverTemp = Driver;
		DriverLeave(true);
		driverTemp.Controller.Destroy();
		driverTemp.Destroy();
	}

	PawnThatTrysToDrive = P;    

	// don't allow while playing spawn effect
	if (bPlayingSpawnEffect)
	{
		return false;
	}

	// Does the vehicle need to be uprighted?
	if ( bIsInverted && bMustBeUpright && !bVehicleOnGround && VSizeSq(Velocity) <= 25.0f )
	{
		if ( bCanFlip )
		{
			bIsUprighting = true;
			UprightStartTime = WorldInfo.TimeSeconds;
			GetAxes(Rotation,X,Y,Z);
			bFlipRight = ((P.Location - Location) dot Y) > 0;
		}
		return false;
	}

	if ( !CanEnterVehicle(P) || (Vehicle(P) != None) )
	{
		return false;
	}

	// Check vehicle Locking....
	// Must be a non-disabled same team (or no team game) vehicle
	if (!bIsDisabled && (Team == UTVEHICLE_UNSET_TEAM || !bTeamLocked || !WorldInfo.Game.bTeamGame || WorldInfo.GRI.OnSameTeam(self,P)))
	{
		if (bEnteringUnlocks)
		{
			bTeamLocked = false;

		}
		if (!AnySeatAvailable())
		{
			if (WorldInfo.GRI.OnSameTeam(self, P))
			{
				// kick out the first bot in the vehicle to make way for this driver
				bFreedSeat = KickOutBot();
			}

			if (!bFreedSeat)
			{
				// we were unable to kick a bot out
				return false;
			}
		}

		// Look to see if the driver seat is open
		if (Driver == None && ( !bDriverLocked || P.PlayerReplicationInfo == BoundPRI || P.GetTeamNum() != BoundPRI.GetTeamNum() ) )
			bEnteredVehicle = DriverEnter(P);
		else
			bEnteredVehicle = PassengerEnter(P, GetFirstAvailableSeat());

		if( bEnteredVehicle )
		{
			SetTexturesToBeResident( TRUE );
			foreach TouchingActors(class'Rx_SoftLevelBoundaryVolume', volume)
			{
				if (PC.IsInPlayArea)
				{
					PC.PlayAreaLeaveDamageWaitCounter = 0;
					PC.PlayAreaLeaveDamageWait = volume.DamageWait;
					PC.SetTimer(volume.fWaitToWarn, false, 'PlayAreaTimerTick');
					PC.IsInPlayArea = false;
				}
				break;
			}
			if (ParentFactory != None)
			{
				ParentFactory.VehicleTaken();
			}
		}

		return bEnteredVehicle;
	}

	VehicleLocked( P );
	return false;
}

function bool AnySeatAvailable()
{
	if(!super.AnySeatAvailable())
	{
		if (WorldInfo.GRI.OnSameTeam(self, PawnThatTrysToDrive))
		{
			// kick out the first bot in the vehicle to make way for this driver
			return KickOutBot();
		}
		return false;
	}
	return true;
}

function bool ChangeSeat(Controller ControllerToMove, int RequestedSeat)
{
	if (Controller == ControllerToMove && bAllowedExit == false)
		return false;

	if (RequestedSeat == 0 && bDriverLocked && ControllerToMove.PlayerReplicationInfo != BoundPRI)
	{
		if ( PlayerController(ControllerToMove) != None )
		{
			PlayerController(ControllerToMove).ClientPlaySound(VehicleLockedSound);
			PlayerController(ControllerToMove).ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_NoEntry_DriverLocked,BoundPRI);

			if(PlayerController(BoundPRI.Owner) != None)
				PlayerController(BoundPRI.Owner).ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_TeammateEntered_Locked,,ControllerToMove.PlayerReplicationInfo,Class);
		}
		return false;
	}
	return super.ChangeSeat(ControllerToMove, RequestedSeat);
}

/**
 * This function looks at 2 controllers and decides if one as priority over the other.  
 * Modified to give priority to whoever the vehicle is bound to.
 *
 * @returns	ture if First has priority over second
 */
function bool HasPriority(controller First, controller Second)
{
	if ( First != Second && PlayerController(First) != none && PlayerController(Second) == none)
		return true;

	if(First.PlayerReplicationInfo == BoundPRI)
		return true;

	return false;
}

function InitializeSeats()
{
	local int i;
	if (Seats.Length==0)
	{
		`log("WARNING: Vehicle ("$self$") **MUST** have at least one seat defined");
		destroy();
		return;
	}

	for(i=0;i<Seats.Length;i++)
	{
		if (i>0)
		{
	   		Seats[i].SeatPawn = Spawn(class'Rx_VehicleSeatPawn');
	   		Seats[i].SeatPawn.SetBase(self);
	   		if(TurretPassengerIndex == i)
	   			Seats[i].GunClass = Seats[0].GunClass;

	   		if(Seats[i].GunClass != None)
			{
				Seats[i].Gun = UTVehicleWeapon(Seats[i].SeatPawn.InvManager.CreateInventory(Seats[i].GunClass));
				Seats[i].Gun.SetBase(self);
			}
			Seats[i].SeatPawn.EyeHeight = Seats[i].SeatPawn.BaseEyeheight;
			if(Seats[i].GunClass != None)
			{
				UTWeaponPawn(Seats[i].SeatPawn).MyVehicleWeapon = UTVehicleWeapon(Seats[i].Gun);
			}
			UTWeaponPawn(Seats[i].SeatPawn).MyVehicle = self;
	   		UTWeaponPawn(Seats[i].SeatPawn).MySeatIndex = i;

	   		if ( Seats[i].ViewPitchMin != 0.0f )
	   		{
				UTWeaponPawn(Seats[i].SeatPawn).ViewPitchMin = Seats[i].ViewPitchMin;
			}
			else
	   		{
				UTWeaponPawn(Seats[i].SeatPawn).ViewPitchMin = ViewPitchMin;
			}


	   		if ( Seats[i].ViewPitchMax != 0.0f )
	   		{
				UTWeaponPawn(Seats[i].SeatPawn).ViewPitchMax = Seats[i].ViewPitchMax;
			}
			else
	   		{
				UTWeaponPawn(Seats[i].SeatPawn).ViewPitchMax = ViewPitchMax;
			}
		}
		else
		{
			Seats[i].SeatPawn = self;
			if(Seats[i].GunClass != None)
			{
				Seats[i].Gun = UTVehicleWeapon(InvManager.CreateInventory(Seats[i].GunClass));
				Seats[i].Gun.SetBase(self);
			}
			MainWeapon = Rx_Vehicle_Weapon(Seats[i].Gun);
		}

		Seats[i].SeatPawn.DriverDamageMult = Seats[i].DriverDamageMult;
		Seats[i].SeatPawn.bDriverIsVisible = Seats[i].bSeatVisible;

		if (Seats[i].Gun!=none)
		{
			UTVehicleWeapon(Seats[i].Gun).SeatIndex = i;
			UTVehicleWeapon(Seats[i].Gun).MyVehicle = self;
		}
   	}
}


function bool PassengerEnter(Pawn P, int SeatIndex)
{
	local int FromTeam;

	FromTeam = GetTeamNum();

	// Restrict someone not on the same team
	if ( WorldInfo.Game.bTeamGame && GetTeamNum() != 255 && P.GetTeamNum() != GetTeamNum() )
	{
		return false;
	}

	if (SeatIndex <= 0 || SeatIndex >= Seats.Length)
	{
		`warn("Attempted to add a passenger to unavailable passenger seat" @ SeatIndex);
		return false;
	}

	if ( !Seats[SeatIndex].SeatPawn.DriverEnter(p) )
	{
		return false;
	}

	HandleEnteringFlag(UTPlayerReplicationInfo(Seats[SeatIndex].SeatPawn.PlayerReplicationInfo));

	SetSeatStoragePawn(SeatIndex,P);

	bHasBeenDriven = true;
	if (FromTeam > 1 || FromTeam < 0)
	{
		SetTeamNum(P.GetTeamNum());
	}
	return true;
}

simulated function StopVehicleSounds()
{
	super.StopVehicleSounds();
	EMPSound.Stop();
}

simulated function StartEMPEffects()
{
	EMPSound.Play();
	EMPParticleComponent.ActivateSystem();
}

simulated function StopEMPEffects()
{
	EMPSound.Stop();
	EMPParticleComponent.DeactivateSystem();
}

simulated function FallbackStopEMPEffects()
{
	if (!bEMPd && EMPParticleComponent.bIsActive)
	{
		EMPParticleComponent.DeactivateSystem();
	}
}

simulated function bool IsEffectedByEMP()
{
	return  GetResistanceModifier() > 0.7; 
}

function EnteredEMPField(Rx_EMPField EMPCausingActor);

function LeftEMPField(Rx_EMPField EMPCausingActor);

simulated function bool EMPHit(Controller InstigatedByController, Actor EMPCausingActor, optional float TimeModifier = 0.0)
{
	local int NewTotalTime; 

	if ((InstigatedByController != none && InstigatedByController.GetTeamNum() == GetTeamNum()))
		return false;

	NewTotalTime = FFloor((EMPTime + TimeModifier)*GetResistanceModifier()); 
	//Already EMP'd ... Update the person who EMP'd us, and the time we're EMP'd if it's higher 
	if(ROLE == ROLE_Authority && bEMPd && NewTotalTime > EMPTimeLeft)
	{
		EMPTimeLeft =  NewTotalTime; 
		EMPInstigator = InstigatedByController;
		
		`TakeEMPDamage;
		
		SetTimer(1.0, true, 'EMPBleed');
		
		if(Rx_Controller(EMPInstigator) != none && EMPInstigator.GetTeamNum() != LastTeamToUse ) {
			Rx_Controller(EMPInstigator).DisseminateVPString("[" $ GetHumanReadableName() @ "Chain EMP'd]&" $ class'Rx_VeterancyModifiers'.default.Ev_VehicleChainEMP $ "&"); 
		}
		
		if(Rx_PRI(EMPInstigator.PlayerReplicationInfo) != none && EMPInstigator.GetTeamNum() != LastTeamToUse){
			Rx_PRI(EMPInstigator.PlayerReplicationInfo).AddEMPHit();
			Rx_PRI(EMPInstigator.PlayerReplicationInfo).AddScoreToPlayerAndTeam(0); //EMPs worth 0 actual.. as you get points for the damage already
		}

		return true; 
	}

	if(bEMPd)
		return false;

	bEMPd = true;
	
	//This is done through replication in a client server environment
	if(WorldInfo.NetMode == NM_StandAlone) 
		StartEMPEffects();
	
	if(bSprinting) 
		StopSprinting(); 

	if(UDKVehicleSimCar(simobj) != none && bEMPDisablesVehicle)
	{
		oldThrottleSpeed = UDKVehicleSimCar(simobj).ThrottleSpeed;
		UDKVehicleSimCar(simobj).ThrottleSpeed = 0;
	}

	if(SVehicleSimTank(simobj) != none && bEMPDisablesVehicle)
	{
		oldMaxEngineTorque = SVehicleSimTank(simobj).MaxEngineTorque;
		SVehicleSimTank(simobj).MaxEngineTorque = 0;
	}

	if(Rx_Controller(controller) != none)
		Rx_Controller(controller).OnEMPHit(InstigatedByController, EMPCausingActor, TimeModifier);
	else if(Rx_Bot(controller) != none)
		Rx_Bot(controller).OnEMPHit(InstigatedByController, EMPCausingActor, TimeModifier);
	else if(Rx_Vehicle_HarvesterController(controller) != none)
		Rx_Vehicle_HarvesterController(controller).OnEMPHit(InstigatedByController, EMPCausingActor, TimeModifier);
	
	if(WorldInfo.NetMode == NM_Client) 
		return true; 
	
	if (bIsAircraft && bEMPDisablesVehicle)
		SetDriving(false);
	
	EMPTimeLeft = NewTotalTime ; //FFloor((EMPTime + TimeModifier)*GetResistanceModifier());
	EMPInstigator = InstigatedByController;
	
	`TakeEMPDamage;
	
	SetTimer(1.0, true, 'EMPBleed');
	
	if(Rx_Controller(EMPInstigator) != none && EMPInstigator.GetTeamNum() != LastTeamToUse ) {
		Rx_Controller(EMPInstigator).DisseminateVPString("[" $ GetHumanReadableName() @ "EMP'd]&" $ class'Rx_VeterancyModifiers'.default.Ev_VehicleEMP $ "&"); 
	}
	
	if(Rx_PRI(EMPInstigator.PlayerReplicationInfo) != none && EMPInstigator.GetTeamNum() != LastTeamToUse){
		Rx_PRI(EMPInstigator.PlayerReplicationInfo).AddEMPHit();
		Rx_PRI(EMPInstigator.PlayerReplicationInfo).AddScoreToPlayerAndTeam(0); //EMPs worth 0 actual.. as you get points for the damage already
	}
	
	return true;
}

simulated function EMPBleed()
{
	if (--EMPTimeLeft <= 0)
	{
		ClearTimer('EMPBleed');
		bEMPd = false;
		if(UDKVehicleSimCar(simobj) != none)
		{
			UDKVehicleSimCar(simobj).ThrottleSpeed = oldThrottleSpeed;
		}
		if(SVehicleSimTank(simobj) != none)
			SVehicleSimTank(simobj).MaxEngineTorque = oldMaxEngineTorque;
				
		if(Role == ROLE_Authority)
		{
			UpdateThrottleAndTorqueVars();
			bForceNetUpdate = true; 
			bNetDirty = true;
		}
			
		StopEMPEffects();

		if(Rx_Controller(controller) != none)
			Rx_Controller(controller).OnEMPBleed(true);
		else if(Rx_Bot(controller) != none)
			Rx_Bot(controller).OnEMPBleed(true);
		else if(Rx_Vehicle_HarvesterController(controller) != none)
			Rx_Vehicle_HarvesterController(controller).OnEMPBleed(true);
		
		if(bIsAircraft && Driver != none && bEMPDisablesVehicle) 
			SetDriving(true);
		else if(Driver != none && bDriving == false)
			SetDriving(true);
	}
	else
	{
		// If EMP was initated by a teammate, make sure the damage isn't blocked by friendlyfire protection. Need proper way to do this :o
		if(role == ROLE_Authority)
		{
			if (EMPInstigator != none && EMPInstigator.GetTeamNum() == GetTeamNum())
				TakeDamage(EMPDamage,None,vect(0,0,0),vect(0,0,0),EMPDmgType,,self);
			else
				`TakeEMPDamage;
			
			//Re-enable driving if we're being driven
			if(Driver != none && !bIsAircraft && bEMPDisablesVehicle) 
				SetDriving(true); 
		}

		if(Rx_Controller(controller) != none)
			Rx_Controller(controller).OnEMPBleed();
		else if(Rx_Bot(controller) != none)
			Rx_Bot(controller).OnEMPBleed();
		else if(Rx_Vehicle_HarvesterController(controller) != none)
			Rx_Vehicle_HarvesterController(controller).OnEMPBleed();
	}
}

simulated function ClearEMP()
{
	if(!bEMPd)
		return; 
	EMPTimeLeft = 0; 
	EMPBleed();
}

function Controller GetLastLegitDmgController()
{
	local Attacker PRII;
	local Attacker Returnee;

	foreach DamagingParties(PRII)
	{
		if (WorldInfo.TimeSeconds - PRII.LastDamageTime >= 15.0) 
		{
			Damage_Taken-=PRII.DamageDone; //Rid yourselves of irrelevant excessive damage
			DamagingParties.RemoveItem(PRII);
		}
	}

	foreach DamagingParties(PRII)
	{
		if (Returnee.PPRI == None && PRII.PPRI != None)
		{
			Returnee = PRII;
		}

		// if current iterated value is higher than saved
		if (PRII.PPRI != None && PRII.LastDamageTime > Returnee.LastDamageTime) 
		{
			Returnee = PRII; 
		}
	}

	return Controller(Returnee.PPRI.Owner);
}

event TakeWaterDamage()
{
	local int ImpartedWaterDamage;
	local controller InstController;

	ImpartedWaterDamage = AccumulatedWaterDamage;
	AccumulatedWaterDamage -= ImpartedWaterDamage;

	InstController = GetLastLegitDmgController();

	if (InstController == None)
	{
		InstController = Controller;
	}

	TakeDamage(ImpartedWaterDamage, InstController, Location, vect(0,0,0), VehicleDrowningDamType);
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local int i;
	local Rx_Pawn UTP;
	local byte WasTeam;
	local string DeathVPString; 
	local Attacker PRII;
	local Repairer RPRII;  
	local float TempAssistPoints; 
	local Controller C; 
	
	WasTeam = GetTeamNum();

	if (Killer == None)
	{
		if (GetLastLegitDmgController() != None)
			Killer = GetLastLegitDmgController();
	}
		
	if(Killer != none)
	{
		DeathVPString = BuildDeathVPString(Killer, DamageType);
		
		//Clear out those who who haven't attacked us in the last 10 seconds
		foreach DamagingParties(PRII)
			{
				if(WorldInfo.TimeSeconds - PRII.LastDamageTime >= 15.0) 
				{
					Damage_Taken-=PRII.DamageDone; //Rid yourselves of irrelevant excessive damage
					DamagingParties.RemoveItem(PRII);
				}
			continue;
			}
		
		//Divi out assist points to those who didn't get the kill and are still in this array 
			foreach DamagingParties(PRII)
			{
			if(PRII.PPRI != none)
				{
				if(PRII.DamageDone >= 100 && PRII.PPRI.Owner != Killer) 
					{
						C=Controller(PRII.PPRI.Owner);
						
						//Why's Unreal so keen on turning everything into integers... I swear 
						TempAssistPoints = fmin(default.VetRankInfo[VRank].VPReward, fmax(1,default.VetRankInfo[VRank].VPReward*( (1.0*PRII.DamageDone)/(HealthMax*1.0))))  ;//Damage_Taken)); // at least 2 points
						TempAssistPoints=fmax(1.0,TempAssistPoints+BuildAssistVPString(C));
						if(Rx_Controller(C) != none ) 
							Rx_Controller(C).DisseminateVPString("[" $ GetHumanReadableName() @ "Kill Assist]&" $ TempAssistPoints $ "&"); 
						else
						if(Rx_Bot(C) != none ) 
							Rx_Bot(C).DisseminateVPString("[" $ GetHumanReadableName() @ "Kill Assist]&" $ TempAssistPoints $ "&"); 
					}
				}
			}
			
		//Divi out assist points to those who were repairing
			
		if(Rx_Vehicle(Killer.Pawn) != none)
		{
			foreach Rx_Vehicle(Killer.Pawn).CurrentHealers(RPRII)
			{
				if(RPRII.PPRI != none)
				{
					if(RPRII.PPRI == Killer.Pawn.PlayerReplicationInfo)
						continue; // No repair-assisting yourself. Ty for the info by the way, Hyperion

					if((WorldInfo.TimeSeconds - RPRII.LastRepairTime) <= 5.0) 
					{
						C=Controller(RPRII.PPRI.Owner);
						TempAssistPoints=class'Rx_VeterancyModifiers'.default.Ev_VehicleRepairAssist;
						if(Rx_Controller(C) != none ) 
						{
							Rx_Controller(C).DisseminateVPString("[" $ GetHumanReadableName() @ "Kill Repair Assist]&" $ TempAssistPoints $ "&"); 
							Rx_PRI(RPRII.PPRI).AddVehicleRepairAssist();
						}
						else
						if(Rx_Bot(C) != none ) Rx_Bot(C).DisseminateVPString("[" $ GetHumanReadableName() @ "Kill Repair Assist]&" $ TempAssistPoints $ "&"); 
					}
				}
			}
		}
		
		//Play kill taunt for killer if they're on foot
		if(Killer.Pawn != None && GetTeamNum() != Killer.GetTeamNum() && (BoundPRI == None || BoundPRI.GetTeamNum() != Killer.GetTeamNum()))
		{
			if (LastTeamToUse != Killer.GetTeamNum() && LastTeamToUse != 255)
			{
				if(Rx_Pawn(Killer.Pawn) !=none && (DamageType != class'Rx_DmgType_ProxyC4' && DamageType !=class'Rx_DmgType_TimedC4' )) 
					Rx_Pawn(Killer.Pawn).SetTimer(1.5,false,'PlayVehicleKillConfirmTimer');
				else if(Rx_Vehicle(Killer.Pawn) != none && Rx_Pawn( Rx_Vehicle(Killer.Pawn).Driver) != none && (DamageType != class'Rx_DmgType_ProxyC4' && DamageType !=class'Rx_DmgType_TimedC4' ))
				{
					Rx_Pawn( Rx_Vehicle(Killer.Pawn).Driver).SetTimer(1.5,false,'PlayVehicleKillConfirmTimer'); 	
				}	
			}
		}		
		
		if(Rx_Controller(Killer) != None && GetTeamNum() != Killer.GetTeamNum()) Rx_Controller(Killer).DisseminateVPString(DeathVPString); 
		else
		if(Rx_Bot(Killer) != None && GetTeamNum() != Killer.GetTeamNum()) Rx_Bot(Killer).DisseminateVPString(DeathVPString); 
		else
		if(Rx_Defence_Controller(Killer) != none) //Just give defences VP, nothing else
		{
			Rx_Defence_Controller(Killer).GiveVeterancy(default.VetRankInfo[VRank].VPReward);	
		}
	} 
	for (i=0;i<Seats.Length;i++)
	{
		if (Seats[i].StoragePawn != None || Seats[i].StoragePawn != None)
		{
			UTP = Rx_Pawn(Seats[i].StoragePawn);
			if(UTP != none && Seats[i].SeatPawn != none)
			{
				if (Rx_Controller(Seats[i].SeatPawn.Controller) != None && Killer != none)
					Rx_Controller(Seats[i].SeatPawn.Controller).ReceiveVehicleDeathMessage(Killer.PlayerReplicationInfo, damageType);
				
				if(Rx_PRI((Seats[i].SeatPawn.Controller.PlayerReplicationInfo)) != None)
				{	
					if(Rx_Defence(Self) != none)
						Rx_PRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(31) ;
					else if(Rx_Vehicle_Air(Self) != none) 
						Rx_PRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(41) ;
					else
						Rx_PRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(11) ;
				}
				else if (Rx_ScriptedBotPRI((Seats[i].SeatPawn.Controller.PlayerReplicationInfo)) != None)
				{
					if(Rx_Defence(Self) != none)
						Rx_ScriptedBotPRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(31) ;
					else if(Rx_Vehicle_Air(Self) != none) 
						Rx_ScriptedBotPRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(41) ;
					else
						Rx_ScriptedBotPRI(Seats[i].SeatPawn.Controller.PlayerReplicationInfo).SetTargetEliminated(11) ;
					
				}
				
				if((class<Rx_DmgType_Nuke>(DamageType) != None || class<Rx_DmgType_IonCannon>(DamageType) != None) && Rx_Game(WorldInfo.Game) != None && Rx_Game(WorldInfo.Game).bPedestalDetonated)
				{
					bStopDeathCamera = true;
				}
				else if(Rx_Bot_Scripted(Seats[i].SeatPawn.Controller) == None || Rx_Bot_Scripted(Seats[i].SeatPawn.Controller).ShouldSurviveVehicleDeath())
					Seats[i].SeatPawn.DriverLeave(true);
			}
		}
	}

	if(bCountTowardsVehicleLimit && TeamBought != 255)
	{
		Rx_TeamInfo(UTTeamGame(WorldInfo.Game).Teams[TeamBought]).DecreaseVehicleCount(Class);

		if (BoundPRI != None)
		{
			Rx_PRI(BoundPRI).AddVehicleLost();
		}
	}

	if (super.Died(Killer, DamageType, HitLocation))
	{
		NotifyCaptuePointsOfDied(WasTeam);
		return true;
	}
	else
		return false;
}

function NotifyCaptuePointsOfDied(byte WasTeam)
{
	local Rx_CapturePoint CP;
	local Rx_Volume_CaptureArea VCA;

	foreach TouchingActors(class'Rx_CapturePoint', CP)
		CP.NotifyVehicleDied(self, WasTeam);

	foreach TouchingActors(class'Rx_Volume_CaptureArea', VCA)
	{
		CP = VCA.CapturePoint;
			
		if(CP != None)
			CP.NotifyVehicleDied(self, WasTeam);
	}
}

function bool RecommendLongRangedAttack()
{
	/** To keep bots from ramming eachother go long ranged combat if the enemy is within weaponrange */
	if(Controller.Enemy != None 
		&& VSizeSq(Controller.Enemy.location - location) < Square(Weapon.MaxRange())) {
		// && Weapon.IsAimCorrect()) {
		return true;
	} 
	return false;
}

function Actor GetObelisk()
{
	local Rx_Sentinel_Obelisk_Laser_Base Ob;

	if(Obelisk != None) 
		return Obelisk;
	
	ForEach DynamicActors(class'Rx_Sentinel_Obelisk_Laser_Base', Ob) 
	{
		Obelisk = Ob;
	}
	if(Obelisk != None)
		return Obelisk;	
	
	if(Rx_Game(WorldInfo.Game).Obelisk == None)
		return None;
}

function Actor GetAGT()
{
	local Rx_Sentinel_AGT_Rockets_Base AdGT;
	
	if(AGT != None) 
		return AGT;

	ForEach DynamicActors(class'Rx_Sentinel_AGT_Rockets_Base', AdGT) 
	{
		AGT = AdGT;
	}
	if(AGT != None)
		return AGT;		
	
	if(Rx_Game(WorldInfo.Game).AGT == None)
		return None;	
}

/** is evaluated before RecommendLongRangedAttack */
function bool RecommendCharge(UTBot B, Pawn Enemy)
{
	local float dist;
	local Vehicle veh;

	if(Weapon == None) // we have no weapon, so yeah....
		return true;
	
	if(Enemy != None && B.GetOrders() == 'Attack' && Rx_BuildingObjective(B.Squad.SquadObjective) != None) {
		if(B.GetTeamNum() == TEAM_GDI) 
		{
			if(GetObelisk() != None)
				if(FastTrace(Enemy.location, Rx_Bot(B).GetObelisk().location))	
					return false;
		} else if(B.GetTeamNum() == TEAM_NOD) 
		{
			if(GetAGT() != None)
				if(FastTrace(Enemy.location, Rx_Bot(B).GetAGT().location)) 	
					return false;
			
		}
	}
	
	dist = VSizeSq(location - Enemy.location);
	
	if ( Vehicle(Enemy) == None && dist < Square(weapon.MaxRange())) {
		/** check to see if the Enemy is blocked by a vehicle. If so then dont recommend charge */
		ForEach CollidingActors(class'Vehicle', veh, 500, Enemy.location)
		{
			if(veh != self && class'Rx_Utils'.static.OrientationOfLocAndRotToB(Enemy.location,rotator(location - Enemy.location),veh) > 0.4) {            
				return false;
			}
		}
	}    
	
	if ( Vehicle(Enemy) == None ) {
		/** when close and can turn in place or in front or in back then charge*/ 
		if(dist < Square(500 + FRand()*200) 
			&& (bTurnInPlace || (class'Rx_Utils'.static.OrientationToB(self, Enemy) > 0.7 || class'Rx_Utils'.static.OrientationToB(self, Enemy) < -0.7))) {
			return true;    
		}
	} 
	
	if(Rx_Vehicle_APC_GDI(self) != None || Rx_Vehicle_APC_Nod(self) != None
			|| Rx_Vehicle_Buggy(self) != None || Rx_Vehicle_Humvee(self) != None) {
		if ( Vehicle(Enemy) == None ) {
			return true;
		}
	} else if(Rx_Vehicle_FlameTank(self) != None) {
		if ( Vehicle(Enemy) == None ) {
			return VsizeSq(location - Enemy.location) < Square(800 + FRand()*300);
		}
	} else if(Rx_Vehicle_StealthTank(self) != None) {
		if ( Vehicle(Enemy) == None ) {
			return VsizeSq(location - Enemy.location) < Square(1000 + FRand()*400);
		}
	}
	
	return false; // overridden in some vehicleclasses
}
/** Recommend high priority charge at enemy */
function bool CriticalChargeAttack(UTBot B)
{
	return super.CriticalChargeAttack(B);
}

function bool TooCloseToAttack(Actor Other)
{
	local float dist;
	
	if(Pawn(Other) != None && RecommendCharge(UTBot(Controller),Pawn(Other))) {
		return false;
	}
	if(super.TooCloseToAttack(Other)) {
		return true;    
	}
	if ( Vehicle(Other) == None ) {
		return false;
	}
	dist = VSizeSq(Location - Other.Location);
	return (dist < Square(300.0 + 200*FRand()));
}

function bool ValidEnemyForVehicle(Pawn NewEnemy)
{
	return true;
}

simulated function bool CanEnterVehicle(Pawn P)
{
	local int i;
	local bool bSeatAvailable, bIsHuman;
	local PlayerReplicationInfo SeatPRI;
	local Rx_Bot_Scripted SB;
	local bool bPilotEmptyButLocked;

	// We should not let the invincible perma invis dude be able to steal vehicles!
	if(P.IsA('Rx_Pawn_admin'))
		return false;

	if (Rx_Pawn(P) != None && ((!Rx_Pawn(P).CanEnterVehicles && !bCanCarryHeavies) || Rx_Pawn(P).bDodging || Rx_Pawn(P).bDoingDodge))
		return false;

	if(Rx_Pawn_Scripted(Driver) != None)
	{
		SB = Rx_Bot_Scripted(P.Controller);

		if(SB != None && SB.BoundVehicle == Self)
			SB.BoundVehicle = None;

		return false;
	}

	// Vehicle is locked after purchase
	if(buyerPri != none)
	{
		if (bReservedToBuyer && P.PlayerReplicationInfo != buyerPri)
			return false;
		else if (P.GetTeamNum() != buyerPri.GetTeamNum())
			return false;
	}

	if ( (P.DrivenVehicle != None) || (P.Controller == None) || !P.Controller.bIsPlayer
	     || Health <= 0 || bDeleteMe )
	{
		return false;
	}

	// check for available seat, and no enemies in vehicle
	// allow humans to enter if full but with bots (TryToDrive() will kick one out if possible)
	bIsHuman = P.IsHumanControlled();
	bSeatAvailable = false;
	for (i=0;i<Seats.Length;i++)
	{
		SeatPRI = GetSeatPRI(i);

		if (i == 0 && bDriverLocked && BoundPRI != P.PlayerReplicationInfo && BoundPRI.GetTeamNum() == P.GetTeamNum())
		{
			if(SeatPRI == None)
				bPilotEmptyButLocked = true;
			continue;
		}
		if (SeatPRI == None)
		{
			bSeatAvailable = true;
		}
		else if (!WorldInfo.GRI.OnSameTeam(P, SeatPRI))
		{
			return false;
		}
		else if (bIsHuman && SeatPRI.bBot)
		{
			bSeatAvailable = true;
		}
	}

	if(bPilotEmptyButLocked && PlayerController(BoundPRI.Owner) != None)
		PlayerController(BoundPRI.Owner).ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_TeammateEntered_Locked,,P.PlayerReplicationInfo,Class);

	return bSeatAvailable;
}

simulated function bool InUseableRange(UDKPlayerController PC, float Dist)
{
	return true;
}

simulated function bool IsVehicleStolen()
{
	if(Rx_PRI(PlayerReplicationInfo) == None)
		return false;
	return false;//Rx_PRI(PlayerReplicationInfo).IsVehicleStolen();
}

simulated function bool IsVehicleFromCrate()
{
	if(Rx_PRI(PlayerReplicationInfo) == None)
		return false;
	return Rx_PRI(PlayerReplicationInfo).IsVehicleFromCrate();
}

function VehicleStolen()
{
	local Rx_Controller PC;
	local Rx_Controller Veh_Owner;
	
	if(bHijackBonus)
	{
	Rx_PRI(Seats[0].SeatPawn.PlayerReplicationInfo).SetVehicleIsStolen (true);

	if(Rx_Controller(Seats[0].SeatPawn.Controller) != none)
		Rx_Controller(Seats[0].SeatPawn.Controller).DisseminateVPString("[VEHICLE STOLEN]&+" $ class'Rx_VeterancyModifiers'.default.Ev_VehicleSteal $"&");
	else if(Rx_Bot(Seats[0].SeatPawn.Controller) != none)
		Rx_Bot(Seats[0].SeatPawn.Controller).DisseminateVPString("[VEHICLE STOLEN]&+" $ class'Rx_VeterancyModifiers'.default.Ev_VehicleSteal $"&");


	bHijackBonus = false; 
	SetTimer(90,false,'ResetHijackTimer'); 
	}
	
	if (BoundPRI == None) {
		`LogRx("GAME" `s "Stolen;" `s self.Class `s "by" `s `PlayerLog(Seats[0].SeatPawn.PlayerReplicationInfo) );
		foreach WorldInfo.AllControllers(class'Rx_Controller', PC) {
			if (PC.GetTeamNum() == LastTeamToUse)
				PC.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_EnemyStolen_Unbound,,,Class);
			else
				PC.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_EnemyStolen_Enemy,,Seats[0].SeatPawn.PlayerReplicationInfo,Class);
		}
	}
	else {
		`LogRx("GAME" `s "Stolen;" `s self.Class `s "bound to" `s `PlayerLog(BoundPRI) `s "by" `s `PlayerLog(Seats[0].SeatPawn.PlayerReplicationInfo) );
		foreach WorldInfo.AllControllers(class'Rx_Controller', PC) {
			if (PC.GetTeamNum() == BoundPRI.GetTeamNum()) {
				PC.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_EnemyStolen_Team,BoundPRI,,Class);
				
				if (PC.PlayerReplicationInfo == BoundPRI)
					Veh_Owner = PC;
			}
			else
				PC.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_EnemyStolen_Enemy,,Seats[0].SeatPawn.PlayerReplicationInfo,Class);
		}
		Veh_Owner != none ? UnBind(Veh_Owner) : UnBind();
	}
	
	if( TeamBought != 255 && bCountTowardsVehicleLimit )
	{
		Rx_TeamInfo(UTTeamGame(WorldInfo.Game).Teams[TeamBought]).DecreaseVehicleCount(Class);
		TeamBought = 255; // so the originaly owning team doesent get a vehiclecount decrease again once this veh gets destroyed
	}
}


function bool DriverEnter(Pawn P)
{
	local Rx_Controller C;
	local bool bWasBuyer;
	local Rx_Controller RxC; 

	if (!super.DriverEnter(P))
		return false;

	if(Rx_Pawn(P) != None)
	{
		if(Rx_Pawn(P).CurrCharClassInfo != None)
			CurrCharClassInfo = Rx_Pawn(P).CurrCharClassInfo;
		if(VehicleVoiceClass == none)
			VehicleVoiceClass = Rx_Pawn(P).GetRxFamilyInfo().default.PawnVoiceClass;
	}

	//Play VehicleAcquired voiceline if driving a crate vehicle and you're the first driver
	if(bIsVehicleFromCrate && !bHasBeenDriven)
	{
		PlayVoiceSound('VehicleAcquired', true);
	}

	if (Rx_Controller(Controller) != None)
	{
		RxC = Rx_Controller(Controller);
		
		//Make us fancier than the peasants!//
		UpdateDevFlare(RxC);
	}
	
		if (bSprintingServer || bSprinting) 
			StopSprinting(); 
		
		if (bEMPd && bEMPDisablesVehicle)
			SetDriving(false);
		
		if (Rx_VehRolloutController(Controller) == none)
		{
			if (buyerPri != None)
			{
				if (Controller.PlayerReplicationInfo == buyerPri)
					bWasBuyer = true;
				buyerPri = none;
				bReservedToBuyer = false;
			}
		}
		if (GetTeamNum() != LastTeamToUse)
		{
			if (LastTeamToUse != 255)
				VehicleStolen();
			LastTeamToUse = GetTeamNum();
		}
		if(Rx_Bot(Controller) != None)
			Rx_Bot(Controller).EnteredVehicle();        
		if (BoundPRI != None)
		{
			if (Seats[0].SeatPawn.PlayerReplicationInfo != BoundPRI)
			{
				foreach WorldInfo.AllControllers(class'Rx_Controller', C)
				{
					if (C.PlayerReplicationInfo == BoundPRI)
					{
						C.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_TeammateEntered,,Seats[0].SeatPawn.PlayerReplicationInfo,Class);
						break;
					}
				}
			}
		}
		else if (RxC != None && bBindable)
			RxC.NotifyBindAllowed(self, bWasBuyer);
		
		if(ROLE == ROLE_Authority && RxC != none)
		{
			SetRadarVisibility(RxC.GetRadarVisibility()); 
			PromoteUnit(Rx_PRI(Controller.PlayerReplicationInfo).VRank); 
			TempVRank = Rx_PRI(Controller.PlayerReplicationInfo).VRank;
			//Set appropriate overlays
			RxC.UpdateModifiedStats(); 
			Rx_PRI(Controller.PlayerReplicationInfo).UpdateVehicleClass(self.class); 
			if(IsTimerActive('ResetTempVRank')) ClearTimer('ResetTempVRank'); 
			if(WorldInfo.NetMode != NM_StandAlone && Rx_Vehicle_Weapon(Weapon) != none) Rx_Vehicle_Weapon(Weapon).ClientGetAmmo(); 
		
		}		
		else
		if(ROLE == ROLE_Authority && Rx_Bot(Controller) != none) 
		{
			if(Rx_Bot_Scripted(Controller) == None)
			{
				SetRadarVisibility(Rx_Bot(Controller).GetRadarVisibility());  	
				PromoteUnit(Rx_PRI(Controller.PlayerReplicationInfo).VRank); 
				//Update overlays/stats
				Rx_Bot(Controller).UpdateModifiedStats();
				Rx_PRI(Controller.PlayerReplicationInfo).UpdateVehicleClass(self.class); 
				TempVRank =Rx_PRI(Controller.PlayerReplicationInfo).VRank;
			}
			else
			{
				SetRadarVisibility(Rx_Bot(Controller).GetRadarVisibility());  	
				PromoteUnit(Rx_Bot_Scripted(Controller).VRank); 
				//Update overlays/stats
				Rx_Bot(Controller).UpdateModifiedStats();
				TempVRank =Rx_Bot_Scripted(Controller).VRank;

			}

			if(IsTimerActive('ResetTempVRank')) 
				ClearTimer('ResetTempVRank'); 
		}
		else 
		if(ROLE == ROLE_Authority && Rx_Vehicle_HarvesterController(Controller) != none) 
		{
			SetRadarVisibility(Rx_Vehicle_HarvesterController(Controller).GetRadarVisibility());  	
		}

		if (!bHasPlayerEntered && ROLE == ROLE_Authority && RxC != none) // Set ammo to max if just bought, so they don't need to reload because of vet clip size increase.
		{
			bHasPlayerEntered = true;
			if (Rx_Vehicle_Weapon_Reloadable(Weapon) != None)
			{
				Rx_Vehicle_Weapon_Reloadable(Weapon).CurrentAmmoInClip = Rx_Vehicle_Weapon_Reloadable(Weapon).GetMaxAmmoInClip();
			}
			else if (Rx_Vehicle_MultiWeapon(Weapon) != None)
			{
				Rx_Vehicle_MultiWeapon(Weapon).CurrentAmmoInClip[0] = Rx_Vehicle_MultiWeapon(Weapon).GetMaxAmmoInClip();
				Rx_Vehicle_MultiWeapon(Weapon).CurrentAmmoInClip[1] = Rx_Vehicle_MultiWeapon(Weapon).GetMaxAltAmmoInClip();
			}
		}

		NotifyCaptuePointsOfTeamChange(); //because DriverEnter no longer triggers SetTeamNum, we change it from here
		return true;
}


event bool DriverLeave(bool bForceLeave)
{	
	if(Rx_Bot_Scripted(Controller) != None || Rx_Pawn_Scripted(Driver) != None)
		return false;

    if (!super.DriverLeave(bForceLeave))
		return false;
	
	CurrentHornSound = default.HornSounds[0];
	DevFlagTexture = None;
	VehicleVoiceClass = None;
	
    // set team to neutral if buyer lockdown is over (buyerePri is set to none then)
	if(buyerPri == none) {
		SetNeutralIfNoOccupants();
	}
	
	StopSprinting();
	//If we're not being pushed or anything, use this to slow us down on exit
	if(bUseParkingBrake &&!bUseLinearCollisionSupp && !bUseLateralCollisionSupp && bVehicleOnGround)
	{
		Mesh.SetRBLinearVelocity(Mesh.BodyInstance.Velocity*0.25);
		Mesh.SetRBAngularVelocity(vect(0,0,0));
	}

	

	SetTimer(5.0, false, 'ResetTempVRank');
	ClearOverlay();	 	

    return true;
}

function UpdateDevFlare(Rx_Controller OurController)
{
	local string SteamID;
    local OnlineSubsystem OnlineSub;
	
	if (OurController.UseDevFlag())
	{
		//Dev horn stuff 
		OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
	    SteamID = OnlineSub.UniqueNetIdToString(Controller.PlayerReplicationInfo.UniqueId);
		
		//Replicated
	    
		if(!bOverrideDevHorn)
		{
			CurrentHornSound = class'Rx_DevManager'.static.GetHornSound(SteamID, OurController.bIsDev, default.HornSounds[HornIndex]);
			HornSounds[0] = CurrentHornSound;
		}
		
		
		/*Do Dev Flag stuff*/
		DevFlagTexture = class'Rx_DevManager'.static.GetFlagTexture(SteamID, OurController.bIsDev);
		
		if (DevFlagTexture != None)
		{
			UpdateDevFlag(DevFlagTexture);

			if (!OurController.bNotifiedOfFlagUsage)
			{
				OurController.ClientMessage("Toggle flag on/off with ToggleDevFlag");
				OurController.bNotifiedOfFlagUsage = true;
			}
		}
		else
		{
			UpdateDevFlag(None);
		}
	}
	else
	{
		UpdateDevFlag(None);
	}
}


simulated function UpdateDevFlag(Texture2D NewFlagTexture)
{
    if (NewFlagTexture == None || DevFlag == None)
    {
        DevFlag.SetHidden(true);

        if(FlagAmbient != None)
        {
        	FlagAmbient.Stop();
        }
    }

    else
    {
    	if (DevFlag.AttachedToSkelComponent == None || DevFlag == None) return;

        DevFlag.SetHidden(false);

        if (FlagMIC == None) FlagMIC = DevFlag.CreateAndSetMaterialInstanceConstant(0);
        FlagMIC.SetTextureParameterValue('FlagTexture', NewFlagTexture);

        if(FlagAmbient != None)
        {
        	FlagAmbient.Play();
    	}
    }
}

function ResetTempVRank()
{
	TempVRank = 0; 
}

function PassengerLeave(int SeatIndex)
{
	super.PassengerLeave(SeatIndex);
	SetNeutralIfNoOccupants();

	if(SeatIndex == TurretPassengerIndex && bPassengerControlTurret)
	{
		SwitchTurretControl(false);
	}
}

function bool SetNeutralIfNoOccupants()
{
	local int i;
	for (i=0; i<Seats.Length; ++i)
	{
		if (Seats[i].SeatPawn.Controller != None)
			return false;
	}
	SetTeamNum(255);
	TimeLastOccupied = WorldInfo.TimeSeconds;
	return true;
}

function bool ToggleDriverLock()
{
	local int Seat;

	if (bDriverLocked)
	{
		bDriverLocked = false;
	}
	else
	{
		bDriverLocked = true;
		if (Seats[0].SeatPawn.Controller != None && Seats[0].SeatPawn.PlayerReplicationInfo != BoundPRI)
		{
			if (PlayerController(Seats[0].SeatPawn.Controller) != None)
				PlayerController(Seats[0].SeatPawn.Controller).ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_OwnerLocked,BoundPRI);
			Seat = GetFirstAvailableSeat();
			if (Seat == -1)
				DriverLeave(true);
			else
				ChangeSeat(Seats[0].SeatPawn.Controller, Seat);
		}
	}
	return bDriverLocked;
}

function bool Bind(Rx_Controller binder)
{
	if (!bBindable || BoundPRI != None)
		return false;

	BoundPRI = binder.PlayerReplicationInfo;
	binder.BoundVehicle = self;
	return true;
}

function bool UnBind(optional Rx_Controller unbinder)
{
	if (BoundPRI != None)
	{
		if (unbinder != None && BoundPRI == unbinder.PlayerReplicationInfo)
		{
			unbinder.BoundVehicle = None;
		}
		else
		{
			foreach WorldInfo.AllControllers(class'Rx_Controller', unbinder)
			{
				if (BoundPRI == unbinder.PlayerReplicationInfo)
				{
					unbinder.BoundVehicle = None;
					break;
				}
			}
		}
		BoundPRI = None;
		bDriverLocked = false;
		if (Rx_Controller(Seats[0].SeatPawn.Controller) != None )
		{
			Rx_Controller(Seats[0].SeatPawn.Controller).ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_CanBind_PrevUnbound);
		}
		return true;
	}
	return false;
}

function ResetHijackTimer()
{
	bHijackBonus = true; 
}

function bool hasLightArmor()
{
	return bLightArmor;
}

function bool hasAirCraftArmor()
{
	return bIsAircraft;
}

function bool TeamLink(int TeamNum)
{
	return (LinkHealMult > 0 && (Team == TeamNum || Team == 255) && Health > 0);
}

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local float CurDmg,Scr;
	local int TempDmg;
	local int ScoreDamage;
	local int InstigatorIndex;
	local Attacker TempAttacker;
	
	if(Health <= 0)
		return;

	if((WorldInfo.Netmode == NM_DedicatedServer || WorldInfo.Netmode == NM_StandAlone) && AIController(EventInstigator) == None)
	{
		if(Rx_Projectile_Rocket(DamageCauser) != None && Rx_Controller(EventInstigator) != None && GetTeamNum() != EventInstigator.GetTeamNum())
		{ 
			Rx_Controller(EventInstigator).IncReplicatedHitIndicator();
		}
	}

	if (Role == ROLE_Authority)
	{
		if ( (UTPawn(Driver) != None) && UTPawn(Driver).bIsInvulnerable )
			Damage = 0;
	}

	bForceNetUpdate = TRUE; // force quick net update

	if ( DamageType != None )
	{
		CurDmg = Float(Damage) * DamageType.static.VehicleDamageScalingFor(self) * fmax(GetResistanceModifier(), MaxDR);
		
		Damage *= DamageType.static.VehicleDamageScalingFor(self)*fmax(GetResistanceModifier(), MaxDR);
		
		if(Damage > 0) setTakingDamage();
		
		momentum *= DamageType.default.VehicleMomentumScaling * MomentumMult;
		
	    if(Damage < CurDmg)
	    {
	    	SavedDmg += CurDmg - Float(Damage);	
	    }
	    
	    if (SavedDmg >= 1)
	    {
	    	Damage += SavedDmg; 
	    	TempDmg = SavedDmg;
	    	SavedDmg -= Float(TempDmg);		   
	    }

	    if (Driver != None || Rx_Defence(self) != None && EventInstigator != None && EventInstigator.IsA('Rx_SentinelController'))
	    {
	    	// do not remove this unless there is a fix for volumes counting as legit damage, i dont feel like messing with it but it works.
	    	if (EventInstigator != None)
	    		LegitamateDamage+=Damage;
	    }
	    
		if(Rx_Defence_Controller(EventInstigator) != none)
			Rx_Defence_Controller(EventInstigator).AddVehicleDamagePoints(Min(Damage,Health)); 

	    if( Driver != none || Rx_Defence(self) != none )
	    {
		    if (EventInstigator != none 
		    	&& !EventInstigator.IsA('Rx_SentinelController') 
		    	&& Rx_Pri(EventInstigator.PlayerReplicationInfo) != None
		    	&& GetTeamNum() != EventInstigator.GetTeamNum())
		    {
				
				ScoreDamage = Damage;
					
				if(ScoreDamage > float(Health)) 
					ScoreDamage = float(Health); //Don't give ridiculously high points for high damage
					
				if(ScoreDamage < 0)
					ScoreDamage = 0;

				//`log(`showvar(ScoreDamage)@`showvar(Damage));
				
				Scr = ScoreDamage * DamagePointsScale;						

				LegitamateDamage+=Damage; //This was real damage
				Rx_PRI(EventInstigator.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Scr);
				
				/*Now track who's doing the damage if it's legit*/
				InstigatorIndex=DamagingParties.Find('PPRI',EventInstigator.PlayerReplicationInfo);
			
				if(InstigatorIndex == -1)  //New damager
				{
					TempAttacker.PPRI=EventInstigator.PlayerReplicationInfo;
					
					TempAttacker.DamageDone = Min(Damage,Health);
					
					Rx_PRI(TempAttacker.PPRI).AddVehicleDamagePoints(Min(Damage,Health));
					
					TempAttacker.LastDamageTime = WorldInfo.TimeSeconds; 
					
					Damage_Taken+=TempAttacker.DamageDone; //Add this damage to the total damage taken.
					
					DamagingParties.AddItem(TempAttacker) ;
				}
				else
				{
					if(Damage <= float(Health))
					{
						DamagingParties[InstigatorIndex].LastDamageTime = WorldInfo.TimeSeconds; 
						DamagingParties[InstigatorIndex].DamageDone+=Damage;
						Rx_PRI(DamagingParties[InstigatorIndex].PPRI).AddVehicleDamagePoints(Damage);
						Damage_Taken+=Damage; //Add this damage to the total damage taken.
					}
					else
					{
						DamagingParties[InstigatorIndex].LastDamageTime = WorldInfo.TimeSeconds;	
						DamagingParties[InstigatorIndex].DamageDone+=Health;
						Rx_PRI(DamagingParties[InstigatorIndex].PPRI).AddVehicleDamagePoints(Health);
						Damage_Taken+=Health; //Add this damage to the total damage taken.
					}
				}
				
		    }
	    }	    		
	}	
	
	super(Pawn).TakeDamage(Damage,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	
	if (Role == ROLE_Authority)
	{
		CheckDamageSmoke();
	}	
}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local int RealAmount;
	local float FAmount;
	local float Scr;
	local int InstigatorIndex;
	local Repairer TempHealer; 

	if (Health <= 0 || Amount <= 0 || Healer == None)
		return false;

	FAmount = Float(Amount) * (1.0/GetResistanceModifier()); 
	
	if(bEMPd)
	{
		FAmount *= EMPHealModifier;
	}

	Amount = FFloor(FAmount);

	if(Amount < FAmount)
	{
		SavedDmg -= (FAmount - Amount);
	}

	if(SavedDmg <= -1)
	{
		Amount += FFloor(SavedDmg * -1);
		SavedDmg -= Float(FFloor(SavedDmg));
	}

	RealAmount = Min(Amount, HealthMax - Health);

	if (DamageType == class'Rx_DmgType_RepairFacility')
	{
		NotifyHealedDamage(Amount, DamageType); 
		return Super.HealDamage(RealAmount, Healer, DamageType);
	}

	if (RealAmount > 0 && LegitamateDamage > 0 && (Driver != none || Rx_Defence(self) !=none || LastTeamToUse == Healer.GetTeamNum()))
	{
		if (Health >= HealthMax && SavedDmg > 0.0f)
		{
			
			SavedDmg = FMax(0.0f, SavedDmg - Amount);
			Scr = SavedDmg * HealPointsScale;
			Rx_PRI(Healer.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Scr);
		}
		LegitamateDamage=fMax(0,LegitamateDamage-RealAmount); 
		Scr = RealAmount * HealPointsScale;
		Rx_PRI(Healer.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Scr);
		Rx_PRI(Healer.PlayerReplicationInfo).AddRepairPoints_V(Amount); //Add to amount of Vehicle repair points this
		/*Now track who's doing the healing if it's legit*/
		InstigatorIndex=CurrentHealers.Find('PPRI',Healer.PlayerReplicationInfo);
	
		if(InstigatorIndex == -1)  //New damager
		{
			TempHealer.PPRI=Healer.PlayerReplicationInfo;
			
			TempHealer.LastRepairTime = WorldInfo.TimeSeconds;
			
			CurrentHealers.AddItem(TempHealer) ;
		}
		else
		{
			CurrentHealers[InstigatorIndex].LastRepairTime = WorldInfo.TimeSeconds;
		}
		
		
	}

	NotifyHealedDamage(Amount, DamageType); 
	
   	return Super.HealDamage(RealAmount, Healer, DamageType);
}

function NotifyHealedDamage(int Amount, class<DamageType> DamageType)
{
	if(Rx_Controller(Controller) != none)
		Rx_Controller(Controller).NotifyTakeHeals(Amount, DamageType);
} 

/**
 *  AI code
 */
function bool Occupied()
{
	local int i;
	for (i=0; i<Seats.Length; ++i)
	{
		if (Seats[i].SeatPawn.Controller != None)
			return true;
	}

	return false;
}

function bool OpenPositionFor(Pawn P)
{
	if(Rx_Bot(P.Controller) != None) 
	{
		return Controller == None;    
	}
	else
	{
		return super.OpenPositionFor(P);
	}
}

function moveVehicleAwayFromSpawnpoint()
{
	local vector tv;
	local UTPawn rolloutDriver;
	local Rx_VehRolloutController rolloutAI;	

	if(driver != none)
		return;
	
	tv = Location;
	tv.z += 60;
	tv.x += 50;

	rolloutDriver = Spawn(class'UTPawn',,,tv,,,true);

	rolloutAI = Spawn(class'Rx_VehRolloutController',,,tv,,,true);
	rolloutAI.bIsPlayer = false;
	rolloutAI.PlayerReplicationInfo = none;
	rolloutAI.SetTeam(Team);

	rolloutAI.Possess(rolloutDriver,true);
	DriverEnter(rolloutDriver);
	rolloutAI.GotoState('RolloutMove');
}

function moveVehicleAwayFromSpawnpointAir()
{
	local vector tv;
	local UTPawn rolloutDriver;
	local Rx_VehRolloutController rolloutAI;	

	if(driver != none)
		return;
	
	tv = Location;
	tv.z += 60;
	tv.x += 50;

	rolloutDriver = Spawn(class'UTPawn',,,tv,,,true);

	rolloutAI = Spawn(class'Rx_VehRolloutControllerAir',,,tv,,,true);
	rolloutAI.bIsPlayer = false;
	rolloutAI.PlayerReplicationInfo = none;
	rolloutAI.SetTeam(Team);

	rolloutAI.Possess(rolloutDriver,true);
	DriverEnter(rolloutDriver);
	rolloutAI.GotoState('RolloutMove');
}

function openVehToAllPlayersAfterBuy() 
{
	if (buyerPri != None)
	{
		if(Rx_Bot(buyerPri.Owner) != None)
		{
			Rx_Bot(buyerPri.Owner).SetBaughtVehicle(-1);	
		}	
		SetTeamNum(255);

		if (Rx_VehRolloutController(Controller) != None)
			Controller.GotoState('leaveVehicle');

		buyerPri = none;
		bReservedToBuyer = false;
	}
}


simulated function ResetUseCollissionSuppression()
{
	if(GetIsCollidingVehicle(false) == false)
	{
		//`log("No longer pushing vehicle");
		SetCollisionSuppression(false); 
		UpdateThrottleandTorqueVars();
	}
	else
	{
		UpdateCutTorqueModifier(); 
		SetTimer(0.1, false, 'ResetUseCollissionSuppression');
	}
		
	
}

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
								   const out CollisionImpactData Collision, int ContactIndex ) {
	local float HisOrientationToMe;
	local float MyOrientationToHim;

	if(default.bUsesCollisionSuppression && Rx_Vehicle(OtherComponent.Owner) != none)
	{
		//Potentially a new collison direction, so check all directions
		if(GetIsCollidingVehicle(true))
			SetCollisionSuppression(true);
	}

	if(VehicleCollisionEffect != None && WorldInfo.TimeSeconds - LastCollisionSoundTime > CollisionIntervalSecs)
	{
		PlayCollisionEffect(Collision.ContactInfos[0].ContactPosition, Collision.ContactInfos[0].ContactNormal*-1.0); 
		PlaySound(CollisionSound, true);
		LastCollisionSoundTime = WorldInfo.TimeSeconds;
	}

	if(OtherComponent == None || VSizeSq(Velocity - OtherComponent.Owner.Velocity) > 62500) {
		super.RigidBodyCollision(HitComponent,OtherComponent,Collision,ContactIndex);
	}
	
	if(bStationary == false && RxIfc_Harvester(HitComponent.owner) == None && UTVehicle(HitComponent.owner) != None 
			&& OtherComponent != None 
			&& UTVehicle(OtherComponent.owner) != None 
			&& (Rx_Bot(Controller) != None || (Rx_VehRolloutController(Controller) != None && AIController(UTVehicle(OtherComponent.owner).Controller) != None)) )
	{
		HisOrientationToMe = class'Rx_Utils'.static.OrientationOfLocAndRotToBLocation(Location,Rotation,OtherComponent.owner.location);
		MyOrientationToHim = class'Rx_Utils'.static.OrientationOfLocAndRotToBLocation(OtherComponent.owner.location,OtherComponent.owner.rotation,location);
		if(HisOrientationToMe > 0.2)
		{ // meaning hes in front of me
			if(HisOrientationToMe > MyOrientationToHim)
			{ // meaning hes more in front of me then im in front of him -> so i wait
				if(UTBot(Controller) != None)
				{
					UTBot(Controller).MoveTarget = None;
					Rx_Bot(Controller).setShouldWait(UTVehicle(Controller.Pawn));
				} 
				else
				{
					Rx_VehRolloutController(Controller).setShouldWait(UTVehicle(Controller.Pawn));
				}
				UTVehicle(Controller.Pawn).bStationary = true;	
			}	
		}
	}
}

function bool NeedsHealing() 
{
	if(Health <= 0)
	{
		return false;
	}
	return HealthMax > Health;
}

function HandleEnteringFlag(UTPlayerReplicationInfo EnteringPRI);

function bool IsReversedSteeringInverted()
{
	return bReverseSteeringInverted;
}

function SetReversedSteeringInverted(bool NewVal)
{
	bReverseSteeringInverted=NewVal;
	ServerSetReversedSteeringInverted(NewVal);
}

reliable server function ServerSetReversedSteeringInverted(bool NewVal)
{
	bReverseSteeringInverted=NewVal;
}

simulated function SwitchWeapon(byte NewGroup)
{
	if(UTPlayerController(Controller) == None || (!Rx_PlayerInput(UTPlayerController(Controller).PlayerInput).bRadio1Pressed 
			&& !Rx_PlayerInput(UTPlayerController(Controller).PlayerInput).bRadio0Pressed))
	{	
		super.SwitchWeapon(NewGroup);
	}
}

simulated event SuspensionHeavyShift(float Delta)
{
	if(bCanPlayHeavyShift && Delta>0 && SuspensionShiftSound != None )
	{
		PlaySound(SuspensionShiftSound);
		bCanPlayHeavyShift = false; 
		SetTimer(0.25, false, 'ResetPlayHeavyShift');
	}
}

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	super.ProcessViewRotation(DeltaTime,out_ViewRotation,out_DeltaRot);
	if(Weapon != None) {
		Rx_Vehicle_Weapon(Weapon).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
	}
	out_ViewRotation += out_DeltaRot;
}

simulated function VehicleCalcCamera(float DeltaTime, int SeatIndex, out vector out_CamLoc, out rotator out_CamRot, out vector CamStart, optional bool bPivotOnly)
{
	local vector CamPos, CamDir, HitLocation, FirstHitLocation, HitNormal, CamRotX, CamRotY, CamRotZ, SafeLocation, X, Y, Z;
	local actor HitActor;
	local float NewCamStartZ;
	local UTPawn P;
	local bool bObstructed, bInsideVehicle;

	if (fpCamera && SeatIndex == 0)
	{
		out_CamLoc = GetCameraStart(SeatIndex);
		out_CamRot = Seats[SeatIndex].SeatPawn.GetViewRotation();
		CamStart = out_CamLoc;
		CalcViewLocation = out_CamLoc;

	    CalcPlayerVehicleCamTransition(out_CamLoc, DeltaTime);	
		return;
	}

	if ( (UTPawn(Driver) != None) && !Driver.bHidden && Driver.Mesh.bOwnerNoSee )
		UTPawn(Driver).SetMeshVisibility(true);

	// Handle the fixed view
	P = UTPawn(Seats[SeatIndex].SeatPawn.Driver);
	if (P != None && P.bFixedView)
	{
		out_CamLoc = P.FixedViewLoc;
		out_CamRot = P.FixedViewRot;
		return;
	}

	CamStart = GetCameraStart(SeatIndex);

	// Get the rotation
	if ( (Seats[SeatIndex].SeatPawn.Controller != None) && !bSpectatedView  )
	{
		out_CamRot = Seats[SeatIndex].SeatPawn.GetViewRotation();
	}

	// support debug 3rd person cam
	if (P != None)
	{
		P.ModifyRotForDebugFreeCam(out_CamRot);
	}

	GetAxes(out_CamRot, CamRotX, CamRotY, CamRotZ);
	CamStart += (Seats[SeatIndex].SeatPawn.EyeHeight + LookForwardDist * FMax(0,(1.0 - CamRotZ.Z)))* CamRotZ;

	/* if bNoFollowJumpZ, Z component of Camera position is fixed during a jump */
	if ( bNoFollowJumpZ )
	{
		NewCamStartZ = CamStart.Z;
		if ( (Velocity.Z > 0) && !HasWheelsOnGround() && (OldCamPosZ != 0) )
		{
			// upward part of jump. Fix camera Z position.
			bFixedCamZ = true;
			if ( OldPositions.Length > 0 )
				OldPositions[OldPositions.Length-1].Position.Z += (OldCamPosZ - CamStart.Z);
			CamStart.Z = OldCamPosZ;
			if ( NewCamStartZ - CamStart.Z > 64 )
				CamStart.Z = NewCamStartZ - 64;
		}
		else if ( bFixedCamZ )
		{
			// Camera z position is being fixed, now descending
			if ( HasWheelsOnGround() || (CamStart.Z <= OldCamPosZ) )
			{
				// jump has ended
				if ( DeltaTime >= 0.1 )
				{
					// all done
					bFixedCamZ = false;
				}
				else
				{
					// Smoothly return to normal camera mode.
					CamStart.Z = 10*DeltaTime*CamStart.Z + (1 - 10*DeltaTime)*OldCamPosZ;
					if ( abs(NewCamStartZ - CamStart.Z) < 1.f )
						bFixedCamZ = false;
				}
			}
			else
			{
				// descending from jump, still in the air, so fix camera Z position
				if ( OldPositions.Length > 0 )
					OldPositions[OldPositions.Length-1].Position.Z += (OldCamPosZ - CamStart.Z);
				CamStart.Z = OldCamPosZ;
			}
		}
	}

	// Trace up to the view point to make sure it's not obstructed.
	if ( Seats[SeatIndex].CameraSafeOffset == vect(0,0,0) )
	{
		SafeLocation = Location;
	}
	else
	{
	    GetAxes(Rotation, X, Y, Z);
	    SafeLocation = Location + Seats[SeatIndex].CameraSafeOffset.X * X + Seats[SeatIndex].CameraSafeOffset.Y * Y + Seats[SeatIndex].CameraSafeOffset.Z * Z;
	}

	HitActor = Trace(HitLocation, HitNormal, CamStart, SafeLocation, false, vect(12, 12, 12));
	if ( HitActor != None)
	{
			bObstructed = true;
			CamStart = HitLocation;
	}

	OldCamPosZ = CamStart.Z;
	if (bPivotOnly)
	{
		out_CamLoc = CamStart;
		return;
	}

	// Calculate the optimal camera position
	CamDir = CamRotX * Seats[SeatIndex].CameraOffset * SeatCameraScale;

	// keep camera from going below vehicle
	if ( !bRotateCameraUnderVehicle && (CamDir.Z < 0) )
	{
		CamDir *= (VSize(CamDir) - abs(CamDir.Z))/(VSize(CamDir) + abs(CamDir.Z));
	}

	CamPos = CamStart + CamDir;

	// Adjust for obstructions
	HitActor = Trace(HitLocation, HitNormal, CamPos, CamStart, false, vect(12, 12, 12));

	if ( HitActor != None )
	{
		out_CamLoc = HitLocation;
		bObstructed = true;
	}
	else
	{
		out_CamLoc = CamPos;
	}
	if ( !bRotateCameraUnderVehicle && (CamDir.Z < 0) && TraceComponent( FirstHitLocation, HitNormal, CollisionComponent, out_CamLoc, CamStart, vect(0,0,0)) )
	{
		// going through vehicle - it's ok if outside collision on other side
		if ( !TraceComponent( HitLocation, HitNormal, CollisionComponent, CamStart, out_CamLoc, vect(0,0,0)) )
		{
			// end point is inside collision - that's bad
			out_CamLoc = FirstHitLocation;
			bObstructed = true;
			bInsideVehicle = true;
			//`log("obstructed 1");
		}
	}

	// if trace doesn't hit collisioncomponent going back in, it means we are inside the collision box
	// in which case we want to hide the vehicle
	if ( !bCameraNeverHidesVehicle && bObstructed )
	{
		bInsideVehicle = bInsideVehicle
						|| !TraceComponent( HitLocation, HitNormal, CollisionComponent, SafeLocation, out_CamLoc, vect(0,0,0))
						|| (VSizeSq(HitLocation - out_CamLoc) < MinCameraDistSq);
	}

	CalcPlayerVehicleCamTransition(out_CamLoc, DeltaTime);
}

simulated function CalcPlayerVehicleCamTransition(out vector out_CamLoc, float DeltaTime)
{
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		if(VehiclePawnTransitionStartLoc != vect(0,0,0) && BlendPct < 1.0f)
		{
			BlendPct += DeltaTime/0.5f;
			out_CamLoc = VLerp(VehiclePawnTransitionStartLoc,  out_CamLoc, BlendPct);
		} else 
		{
			VehiclePawnTransitionStartLoc = vect(0,0,0);
		}
		CalcViewLocation = out_CamLoc;
	}
}

/**RxIfc_SeekableTarget******/

function float GetAimAheadModifier()
{
	return SeekAimAheadModifier;
}

function float GetAccelrateModifier()
{
	return SeekAccelrateModifier;
}

simulated function vector GetAdjustedLocation()
{
	return location; 
}

/********************/

simulated function StartFire(byte FireModeNum)
{
 	//local vector FireStartLoc;
 	local Rx_Vehicle veh;
 	
 	if(FireModeNum == 1 && bSecondaryFireTogglesFirstPerson)
 	{
 		if(WorldInfo.NetMode != NM_DedicatedServer && Rx_Controller(controller) != None)
 		{
 			Rx_Controller(controller).ToggleCam();
 		}
 		return;
 	}	

 	if(Rx_Vehicle_Weapon_Reloadable(weapon) != None && Rx_Vehicle_Weapon_Reloadable(weapon).bCheckIfFireStartLocInsideOtherVehicle)
 	{	 	
 	    foreach CollidingActors(class'Rx_Vehicle', veh, 3, location, true)
   		{
			if(veh.GetTeamNum() == GetTeamNum())
				continue;	
			UTVehicleWeapon(weapon).ClearPendingFire(UTVehicleWeapon(weapon).CurrentFireMode);
			return;
		}
	} 	

	super.StartFire(FireModeNum);
}

simulated function float CalcRadiusDmgDistance(vector HurtOrigin)
{
	local vector HitLocation;
	local TraceHitInfo HitInfo;

	HitLocation = Location;
	CheckHitInfo( HitInfo, Mesh, Location - HurtOrigin, HitLocation );
	return VSize(HitLocation - HurtOrigin);
}

function TakeDamageFromDistance (
	float               GivenDistance,
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
	local vector HitLocation, Dir;
	local float DamageScale;
	local TraceHitInfo HitInfo;

	// calculate actual hit position on mesh, rather than approximating with cylinder
	HitLocation = Location;
	Dir = Location - HurtOrigin;

	CheckHitInfo( HitInfo, Mesh, Dir, HitLocation );

	if ( bFullDamage )
	{
		DamageScale = 1.f;
	}
	else if ( GivenDistance > DamageRadius )
		return;
	else
	{
		DamageScale = FMax(0,1 - GivenDistance/DamageRadius);
		DamageScale = DamageScale ** DamageFalloffExponent;
	}

	RadialImpulseScaling = DamageScale;

	TakeDamage
	(
		BaseDamage * DamageScale,
		InstigatedBy,
		HitLocation,
		(DamageScale * Momentum * Normal(dir)),
		DamageType,
		HitInfo,
		DamageCauser
	);
	RadialImpulseScaling = 1.0;
}

simulated function bool ClientHitIsNotRelevantForServer()
{
	return Health <= 0;
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
	local Actor ProjectileWeaponOwner; 
	
	if(InstigatedBy != None && InstigatedBy.GetTeamNum() == GetTeamNum())
	{
		return;
	}
	
	if(Rx_Projectile(DamageCauser) != None && Rx_Projectile_Rocket(DamageCauser) == None && !Rx_Projectile(DamageCauser).isAirstrikeProjectile())
	{
		//Get what actually shot us 
		if(Rx_Projectile(DamageCauser) != none) 
			ProjectileWeaponOwner = Rx_Projectile(DamageCauser).GetWeaponInstigator();
		else
		{
			if(InstigatedBy != None)
				ProjectileWeaponOwner = InstigatedBy.Pawn.Weapon; //Likely not a projectile then, so just look for the weapon calling this 
			else
				return; // we're likely calling it not as the guy who's dealing the hit, in which case we'll have no way to know the controller. It's also not necessary to call it from our side
		}

//		`log("VEH TK DMG"@Rx_Projectile(DamageCauser).GetWeaponInstigator()@InstigatedBy.Pawn.Weapon@InstigatedBy@DamageCauser);
		
		if(WorldInfo.NetMode != NM_DedicatedServer && InstigatedBy != None 
				&& InstigatedBy.Pawn != None
				&& (Rx_Weapon(ProjectileWeaponOwner) != None || Rx_Vehicle_Weapon(ProjectileWeaponOwner) != None || Rx_PassiveAbility(ProjectileWeaponOwner) != None)) 
		{	
			if(Health > 0 && self.GetTeamNum() != InstigatedBy.GetTeamNum() && UTPlayerController(InstigatedBy) != None)
			{
				Rx_Hud(UTPlayerController(InstigatedBy).myHud).ShowHitMarker();
				Rx_Controller(InstigatedBy).PlayHitSound(A_FLAK, Health, BaseDamage);
			}

			if(Rx_Weapon_VoltAutoRifle(ProjectileWeaponOwner) != None)
					Rx_Weapon_VoltAutoRifle(ProjectileWeaponOwner).ServerALRadiusDamageCharged(self,HurtOrigin,bFullDamage,class'Rx_Projectile_VoltBolt'.static.GetChargePercentFromDamage(BaseDamage));
				else if(Rx_Weapon(ProjectileWeaponOwner) != None) {
					Rx_Weapon(ProjectileWeaponOwner).ServerALRadiusDamage(self,HurtOrigin,bFullDamage);
				} 
				else if(Rx_Vehicle_Weapon(ProjectileWeaponOwner) != None) {
					Rx_Vehicle_Weapon(ProjectileWeaponOwner).ServerALRadiusDamage(self,HurtOrigin,bFullDamage, Rx_Projectile(DamageCauser).FMTag);
				}
				else if(Rx_PassiveAbility(ProjectileWeaponOwner) != None) {
					Rx_PassiveAbility(ProjectileWeaponOwner).ServerALRadiusDamage(self,HurtOrigin,bFullDamage);
				}
		}
		else if(ROLE == ROLE_Authority && AIController(InstigatedBy) != None)
		{
			super.TakeRadiusDamage(InstigatedBy,BaseDamage,DamageRadius,DamageType,Momentum,HurtOrigin,bFullDamage,DamageCauser,DamageFalloffExponent);
		}
	}
	else
	{
		super.TakeRadiusDamage(InstigatedBy,BaseDamage,DamageRadius,DamageType,Momentum,HurtOrigin,bFullDamage,DamageCauser,DamageFalloffExponent);
	}
}

simulated function int GetSeatIndexBasedOnWeapon(Weapon InWeapon)
{
	local int i;

	if(Rx_Vehicle_Weapon(InWeapon) != None)
		return Rx_Vehicle_Weapon(InWeapon).SeatIndex;

	for (i=0; i<Seats.Length; ++i)
	{
		if (InWeapon.Class == Seats[i].GunClass)
		{
			if(i == 0 && bPassengerControlTurret)
				return TurretPassengerIndex;
			return i;
		}
	}
	return 0;
}

simulated function class<Rx_Vehicle_Weapon> GetWeaponClassOfSeat(int SeatIndex)
{
	return class<Rx_Vehicle_Weapon>(default.Seats[SeatIndex].GunClass);
}

simulated function VehicleWeaponImpactEffects(vector HitLocation, int SeatIndex)
{
	super.VehicleWeaponImpactEffects(HitLocation, SeatIndex);

	PlayBeamParticleEffect(HitLocation, SeatIndex);
}

simulated function PlayBeamParticleEffect(vector HitLocation, int SeatIndex)
{
	local ParticleSystemComponent E;
	local ParticleSystem PS;
	local class<Rx_Vehicle_Weapon> RxVW;  

	RxVW = GetWeaponClassOfSeat(SeatIndex);
	
	if (RxVW == None)
	{
		`log(self@"got none weapon class for seat index"@SeatIndex);
		return; 
	}

	if(VRank < 9 || RxVW.default.BeamTemplates_Heroic[0] == none)
		PS = RxVW.default.BeamTemplates[SeatFiringMode(SeatIndex,,true)];
	else
		PS = GetWeaponClassOfSeat(SeatIndex).default.BeamTemplates_Heroic[SeatFiringMode(SeatIndex,,true)];
	
	if (PS != None)
	{
		E = WorldInfo.MyEmitterPool.SpawnEmitter(PS, GetEffectLocation(SeatIndex));
		E.SetVectorParameter('BeamEnd', HitLocation);
	}
}

simulated function ClientsideVehicleWeaponImpactEffects(vector HitLocation, int SeatIndex)
{
	local vector NewHitLoc, HitNormal, LightLoc;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local MaterialImpactEffect ImpactEffect;
	local MaterialInterface MI;
	local MaterialInstanceTimeVarying MITV_Decal;
	local int DecalMaterialsLength;
	local Vehicle V;
	local Pawn EffectInstigator;
	local UTPlayerController PC;
	local class<UTVehicleWeapon> SeatWeaponClass; 

	HitNormal = Normal(Location - HitLocation);
	HitActor = FindWeaponHitNormal(NewHitLoc, HitNormal, (HitLocation - (HitNormal * 32)), HitLocation + (HitNormal * 32),HitInfo);

	if ( (HitActor == None) && (VSizeSq(Location - HitLocation) > 1000000000) )
	{
		return;
	}

	if (Pawn(HitActor) != None)
	{
		CheckHitInfo(HitInfo, Pawn(HitActor).Mesh, -HitNormal, NewHitLoc);
	}
	
	SeatWeaponClass = GetWeaponClassOfSeat(SeatIndex);
	
	// figure out the impact effect to use
	ImpactEffect = SeatWeaponClass.static.GetImpactEffect(HitActor, HitInfo.PhysMaterial, SeatFiringMode(SeatIndex,, true));
	
	if (ImpactEffect.Sound != None)
	{
		// if hit a vehicle controlled by the local player, always play it full volume
		V = Vehicle(HitActor);
		if (V != None && V.IsLocallyControlled() && V.IsHumanControlled())
		{
			PlayerController(V.Controller).ClientPlaySound(ImpactEffect.Sound);
		}
		else
		{
			if ( (SeatWeaponClass.default.BulletWhip != None) && (WorldInfo.GRI != None) )
			{
				ForEach LocalPlayerControllers(class'UTPlayerController', PC)
				{
					if (!WorldInfo.GRI.OnSameTeam(self, PC))
					{
						PC.CheckBulletWhip(SeatWeaponClass.default.BulletWhip, Location, Normal(HitLocation - Location), HitLocation);
					}
				}
			}
			if (Speaker == None)
				Speaker = Spawn(class'Rx_Speaker', self);
			Speaker.PlaySoundAt(ImpactEffect.Sound, HitLocation);
		}
	}

	EffectInstigator = Seats[SeatIndex].SeatPawn;
	if (EffectInstigator == None)
	{
		EffectInstigator = self;
	}
	if (EffectInstigator.EffectIsRelevant(HitLocation, false, MaxImpactEffectDistance))
	{
		// Pawns handle their own hit effects
		if (HitActor != None && (Pawn(HitActor) == None || Vehicle(HitActor) != None))
		{
			// this code is mostly duplicated in:  UTGib, UTProjectile, UTVehicle, UTWeaponAttachment be aware when updating
			if ( !WorldInfo.bDropDetail && (Pawn(HitActor) == None) )
			{
				// if we have a decal to spawn on impact
				DecalMaterialsLength = ImpactEffect.DecalMaterials.length;
				if( DecalMaterialsLength > 0 )
				{
					MI = ImpactEffect.DecalMaterials[Rand(DecalMaterialsLength)];
					if( MI != None )
					{
						if( MaterialInstanceTimeVarying(MI) != none )
						{
							MITV_Decal = new(self) class'MaterialInstanceTimeVarying';
							MITV_Decal.SetParent( MI );

							WorldInfo.MyDecalManager.SpawnDecal( MITV_Decal, HitLocation, rotator(-HitNormal), ImpactEffect.DecalWidth,
								ImpactEffect.DecalHeight, 10.0, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex );
							//here we need to see if we are an MITV and then set the burn out times to occur
							MITV_Decal.SetScalarStartTime( ImpactEffect.DecalDissolveParamName, ImpactEffect.DurationOfDecal );
						}
						else
						{
							WorldInfo.MyDecalManager.SpawnDecal( MI, HitLocation, rotator(-HitNormal), ImpactEffect.DecalWidth,
								ImpactEffect.DecalHeight, 10.0, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex );
						}
					}
				}
			}

			if (ImpactEffect.ParticleTemplate != None)
			{
				SpawnImpactEmitter(HitLocation, HitNormal, ImpactEffect, SeatIndex );
				if ( (Seats[SeatIndex].ImpactFlashLightClass != None) && (WorldInfo.GetDetailMode() != DM_Low) && !class'Engine'.static.IsSplitScreen()
					&& (!WorldInfo.bDropDetail || (Seats[SeatIndex].SeatPawn != None && PlayerController(Seats[SeatIndex].SeatPawn.Controller) != None && Seats[SeatIndex].SeatPawn.IsLocallyControlled())) )
				{
					LightLoc = HitLocation + ((0.5 * Seats[SeatIndex].ImpactFlashLightClass.default.TimeShift[0].Radius * vect(1,0,0)) >> rotator(HitNormal));
					UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(Seats[SeatIndex].ImpactFlashLightClass, LightLoc);
				}
			}
		}
	}

	PlayBeamParticleEffect(HitLocation, SeatIndex);
}

event RanInto(Actor Other)
{
	local vector Momentum;
	local float Speed;
	local class<UDKEmitCameraEffect> CameraEffect;

	if (Rx_Pawn(Other) != None && Rx_Pawn(Other).GetTeamNum() == GetTeamNum())
		Rx_Pawn(Other).LastRanInto = WorldInfo.TimeSeconds;

	if ( Pawn(Other) == None || (Vehicle(Other) != None) || Other == Instigator || Other.Role != ROLE_Authority )
		return;

	Speed = VSize(Velocity);
	if (Speed > MinRunOverSpeed)
	{
		Momentum = Velocity * 0.25 * Pawn(Other).Mass;
		if ( RanOverSound != None )
			PlaySound(RanOverSound);

		if ( WorldInfo.GRI.OnSameTeam(self,Other) )
		{
			Momentum += Speed * 0.25 * Pawn(Other).Mass * Normal(Velocity cross vect(0,0,1));
		}
		else
		{
			// dont squish while neutral
			if (GetTeamNum() == 255)
				return;

			Other.TakeDamage(int(Speed * 0.075), GetCollisionDamageInstigator(), Other.Location, Momentum, RanOverDamageType);

			if (Pawn(Other).Health <= 0 && UTPlayerController(Controller) != none)
			{
				CameraEffect = RanOverDamageType.static.GetDeathCameraEffectInstigator(UTPawn(Other));
				if (CameraEffect != None)
				{
					UTPlayerController(Controller).ClientSpawnCameraEffect(CameraEffect);
				}
			}
		}
	}
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	VehicleWeaponFired(bViaReplication, HitLocation, GetSeatIndexBasedOnWeapon(InWeapon));
}

simulated function VehicleWeaponFired( bool bViaReplication, vector HitLocation, int SeatIndex )
{
	if(Role == ROLE_Authority)
	{
		if(MainWeapon != None && SeatIndex == TurretPassengerIndex)
			MainWeapon.SetCurrentFireMode(Seats[SeatIndex].Gun.CurrentFireMode);
	}

	// Trigger any vehicle Firing Effects
	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Instant Fire plays the fire effects on the client immediately, so don't play them again when the server tells the client that it has fired (as they've already been played).
		if (bViaReplication && Seats[SeatIndex].SeatPawn != None && Seats[SeatIndex].SeatPawn.Controller == GetALocalPlayerController())
			return;

		VehicleWeaponFireEffects(HitLocation, SeatIndex);

		if (!bViaReplication && Seats[SeatIndex].SeatPawn != None && GetSeatIndexForController(GetALocalPlayerController()) == SeatIndex)
			ClientsideVehicleWeaponImpactEffects(HitLocation, SeatIndex);
		else
			VehicleWeaponImpactEffects(HitLocation, SeatIndex);

		if (SeatIndex == 0)
		{
			Seats[SeatIndex].Gun = UTVehicleWeapon(Weapon);
		}
		if (Seats[SeatIndex].Gun != None)
		{
			UTVehicleWeapon(Seats[SeatIndex].Gun).ShakeView();
		}
		if ( EffectIsRelevant(Location,false,MaxFireEffectDistance) )
		{
			CauseMuzzleFlashLight(SeatIndex);
		}
	}
}

simulated function CheckWheelEmitters()
{
	local vector loc, norm, end;
	local TraceHitInfo hitInfo;
	local Actor traceHit;
	local UTPhysicalMaterialProperty PhysicalProperty;
	local int i;
	
	if(VSizeSq(Velocity) > 14400 && !IsInState('Stealthed') && !IsInState('BeenShot'))
    {
		
		end = Location;
		end.Z = Location.Z -128;
		traceHit = trace(loc, norm, end, Location, false,, hitInfo);
	
		if (traceHit == none)
		{
			return;
		}
		if( HitInfo.HitComponent != none && Landscape(HitInfo.HitComponent.Owner) != none 
				&& Landscape(HitInfo.HitComponent.Owner).LandscapeMaterial != None
				&& Landscape(HitInfo.HitComponent.Owner).LandscapeMaterial.GetPhysicalMaterial() != None)
			PhysicalProperty = UTPhysicalMaterialProperty(Landscape(HitInfo.HitComponent.Owner).LandscapeMaterial.GetPhysicalMaterial().GetPhysicalMaterialProperty(class'UTPhysicalMaterialProperty'));

		else if(HitInfo.PhysMaterial != None)
			PhysicalProperty = UTPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(class'UTPhysicalMaterialProperty'));

	}
	else
	{
		PhysicalProperty = OldPhysicalProperty;
	}
	
     // check the material type and change wheel particles
	if( PhysicalProperty != none )
	{
		OldPhysicalProperty = PhysicalProperty;
		for(i = 0; i < WheelParticleEffects.Length; i++ )
		{
			 if( PhysicalProperty.MaterialType == WheelParticleEffects[i].MaterialType )
			{
				 WheelParticleEffect = WheelParticleEffects[i].ParticleTemplate;
				 break;   
			}
		}
	}
	else
		WheelParticleEffect = DefaultWheelPSCTemplate; // prolly means it should be an empty emitter, mb a tiny amount of shed dust to taste
		
	if( WheelParticleEffect != none && WheelParticleEffect != OldWheelParticleEffect )
	{
		for( i=0; i<WheelPSCs.Length; i++ )
		{
			WheelPSCs[i].SetTemplate(WheelParticleEffect);
		}
		OldWheelParticleEffect = WheelParticleEffect;
	}
	
	for( i=0; i<WheelPSCs.Length; i++ )
	{
		if(IsInState('Stealthed') || IsInState('BeenShot'))
			WheelPSCs[i].SetFloatParameter('Wheelslip', 1.0);
		else
		{
			WheelPSCs[i].SetFloatParameter('Wheelslip', 1.0 + 9.0*FClamp(bDriving ? VSizeSq(Velocity) : 0.0001 / MaxSpeed, 0.0, 1.0)); // input range is 1-10
		}
	}
}

simulated function rotator GetWeaponAimWithOptionalPredefinedAimPoint(UTVehicleWeapon VWeapon, vector AimPoint)
{
	local vector SocketLocation, CameraLocation, RealAimPoint, DesiredAimPoint, HitLocation, HitRotation, DirA, DirB;
	local rotator CameraRotation, SocketRotation, ControllerAim, AdjustedAim;
	local float DiffAngle, MaxAdjust;
	local Controller C;
	local PlayerController PC;
	local Quat Q;

	if ( VWeapon != none )
	{
		C = Seats[VWeapon.SeatIndex].SeatPawn.Controller;

		PC = PlayerController(C);
		if(AimPoint != vect(0,0,0))
			DesiredAimPoint = AimPoint;
		else 
		{	
			if (PC != None)
			{
				PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
				DesiredAimPoint = CameraLocation + Vector(CameraRotation) * VWeapon.GetTraceRange();
				if (Trace(HitLocation, HitRotation, DesiredAimPoint, CameraLocation, true, vect(0,0,0),,TRACEFLAG_Bullet) != None)
				{
					DesiredAimPoint = HitLocation;
				}
			}
			else if (C != None)
			{
				DesiredAimPoint = C.GetFocalPoint();
			}
		}

		if ( Seats[VWeapon.SeatIndex].GunSocket.Length>0 )
		{
			GetBarrelLocationAndRotation(VWeapon.SeatIndex, SocketLocation, SocketRotation);
			if(VWeapon.bIgnoreSocketPitchRotation || ((DesiredAimPoint.Z - Location.Z)<0 && VWeapon.bIgnoreDownwardPitch))
			{
				SocketRotation.Pitch = Rotator(DesiredAimPoint - Location).Pitch;
			}
		}
		else
		{
			SocketLocation = Location;
			SocketRotation = Rotator(DesiredAimPoint - Location);
		}

		RealAimPoint = SocketLocation + Vector(SocketRotation) * VWeapon.GetTraceRange();
		DirA = normal(DesiredAimPoint - SocketLocation);
		DirB = normal(RealAimPoint - SocketLocation);
		DiffAngle = ( DirA dot DirB );
		MaxAdjust = VWeapon.GetMaxFinalAimAdjustment();
		if ( DiffAngle >= MaxAdjust )
		{
			// bit of a hack here to make bot aiming and single player autoaim work
			ControllerAim = (C != None) ? C.Rotation : Rotation;
			AdjustedAim = VWeapon.GetAdjustedAim(SocketLocation);
			if (AdjustedAim == VWeapon.Instigator.GetBaseAimRotation() || AdjustedAim == ControllerAim)
			{
				// no adjustment				
				return rotator(DesiredAimPoint - SocketLocation);
			}
			else
			{
				// FIXME: AdjustedAim.Pitch = Instigator.LimitPitch(AdjustedAim.Pitch);
				return AdjustedAim;
			}
		}
		else
		{
			Q = QuatFromAxisAndAngle(Normal(DirB cross DirA), ACos(MaxAdjust));
			return Rotator( QuatRotateVector(Q,DirB));
		}
	}
	else
	{
		return Rotation;
	}
}
simulated function rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	return GetWeaponAimWithOptionalPredefinedAimPoint(VWeapon, vect(0,0,0));
}

function vector GetWeaponAimLocation(vector AimLoc)
{
	local vector HitNormal, HitLocation, StartTrace, EndTrace;
	local rotator AdjustedAim;
	local Actor TraceActor;
	
	AdjustedAim = GetWeaponAimWithOptionalPredefinedAimPoint(UTVehicleWeapon(weapon), AimLoc);	
	StartTrace = GetPhysicalFireStartLoc(UTVehicleWeapon(weapon));
	EndTrace = StartTrace + Vector(AdjustedAim) * 2000;

	TraceActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, vect(0,0,0),, TRACEFLAG_Bullet);
	if(TraceActor != None)
	{
		return HitLocation;
	} else
	{
		return EndTrace;
	}
}

function ToggleTurretRotation()
{
}

function PancakeOther(Pawn Other)
{
	if(Rx_Pawn(Other) == None)
		return;

	if(GetTeamNum() != 255 && GetTeamNum() != Other.GetTeamNum())
	{
		Other.TakeDamage(10000, GetCollisionDamageInstigator(), Other.Location, Velocity * Other.Mass, CrushedDamageType);
	}
}

simulated function SetSpotted(float SpottedTime)
{
if(ROLE < ROLE_Authority) ServerSetSpotted(SpottedTime); 
else
	{
	bSpotted = true;
	SetTimer(SpottedTime,false,'ResetSpotted');
	}
}

reliable server function ServerSetSpotted(float SpottedTime)
{
	if(GetTimerRate('ResetSpotted') - GetTimerCount('ResetSpotted') >= SpottedTime) return; //Already spotted for longer by something else	
	
	bSpotted = true;
	SetTimer(SpottedTime,false,'ResetSpotted');
}

function ResetSpotted()
{
	bSpotted = false;
}

simulated function SetFocused()
{
//Hold
}

reliable server function ServerSetFocused() //Draw a focus-fire symbol for enemy targets on this unit
{
	bFocused = true;
	SetTimer(10.0,false,'ResetFocused'); 
}



function ResetFocused()
{
	bFocused = false; 
}

event CheckReset()
{
	ResetTime = WorldInfo.TimeSeconds + 10000000.0;
}

simulated function UTGib SpawnGibVehicle(vector SpawnLocation, rotator SpawnRotation, StaticMesh TheMesh, vector HitLocation, bool bSpinGib, vector ImpulseDirection, ParticleSystem PS_OnBreak, ParticleSystem PS_Trail)
{
	local UTGib gib;	
	gib = super.SpawnGibVehicle(SpawnLocation,SpawnRotation,TheMesh,HitLocation,bSpinGib,ImpulseDirection,PS_OnBreak,PS_Trail);
	if(gib != None)
		gib.LifeSpan = 4.0 + (2.0 * FRand());
	return gib;
}

simulated event Destroyed()
{
	local Rx_Controller C;
	local int i;


	if (bEMPd)
		StopEMPEffects();
	if (Speaker != None)
	{
		Speaker.Destroy();
		Speaker = None;
	}
	
	super.Destroyed();
	Recoil = None;
	buyerPri = None;

	for(i = 0; i<10; i++)
	{
		PassengerPRIExtras[i] = None;
	}

	if (BoundPRI != None)
	{
		foreach WorldInfo.AllControllers(class'Rx_Controller', C)
		{
			if (C.PlayerReplicationInfo == BoundPRI)
			{
				C.ReceiveLocalizedMessage(class'Rx_Message_Vehicle',VM_Destroyed,,,Class);
				break;
			}
		}
	}
	UnBind();
}

function SetUISymbol(byte sym)
{
	UISymbol = sym; 
	SetTimer(3.5,false,'DisableUISymbol');
}


function DisableUISymbol()
{
	UISymbol = 0; 
}

simulated function byte GetHealNecessity() //On a scale from 0 to 3, how much does it hurt? 
{
	local float HealthFraction; 
	
	HealthFraction = (float(Health)/float(HealthMax))*100.0 ;

	
	if(HealthFraction <= 33) return 3 ; //Critical
	else
	if(HealthFraction <= 66) return 2 ; // Should probably heal me, bro 
	else
	if(HealthFraction <= 95) return 1; //Not much in the way of necessity on healing
	else
	return 0 ; 
}

simulated function BlowupVehicle()
{
	local int i;

	if(bDriving)
	{
		VehicleEvent('EngineStop');
	}

	bCanBeBaseForPawns = false;
	LinkHealMult = 0.0;
	GotoState('DyingVehicle');
	AddVelocity(TearOffMomentum, TakeHitLocation, HitDamageType);
	bDeadVehicle = true;
	
	if(!bStayUprightOnDeath){
		
		bStayUpright = false;
		if ( StayUprightConstraintInstance != None )
		{
			StayUprightConstraintInstance.TermConstraint();
		}
	}

	// Iterate over wheels, turning off those we want
	for(i=0; i<Wheels.length; i++)
	{
		if(UDKVehicleWheel(Wheels[i]) != None && UDKVehicleWheel(Wheels[i]).bDisableWheelOnDeath)
		{
			SetWheelCollision(i, FALSE);
		}
	}

	CustomGravityScaling = 1.0;
	if ( UDKVehicleSimHover(SimObj) != None )
	{
		UDKVehicleSimHover(SimObj).bDisableWheelsWhenOff = true;
	}
}

simulated state VehicleHusk
{
	ignores Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, FellOutOfWorld;

	simulated function bool DriverEnter(Pawn P);
	simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon) {}
	simulated function PlayNextAnimation() {}
	singular event BaseChange() {}
	event Landed(vector HitNormal, Actor FloorActor) {}

	simulated function BlowupVehicle() {}

	simulated function CheckDamageSmoke();
}

simulated state DyingVehicle
{
	/** spawn an explosion effect and damage nearby actors */
	simulated function DoVehicleExplosion(bool bDoingSecondaryExplosion)
	{
		local UTPlayerController UTPC;
		local float Dist, ShakeScale, MinViewDist;
		local ParticleSystem Template;
		local bool bIsVisible;
		local rotator PerpendicularVelocity; 
		
		if ( WorldInfo.NetMode != NM_DedicatedServer )
		{
			if ( bDoingSecondaryExplosion )
			{
				// already checked visibility
				bIsVisible = true;
			}
			else
			{
				// viewshakes and visibility check
				MinViewDist = 10000.0;
				
				foreach LocalPlayerControllers(class'UTPlayerController', UTPC)
				{
					Dist = VSize(Location - UTPC.ViewTarget.Location);
					if (UTPC == KillerController)
					{
						bIsVisible = true;
						Dist *= 0.25;
					}
					MinViewDist = FMin(Dist, MinViewDist);
					if (Dist < OuterExplosionShakeRadius)
					{
						bIsVisible = true;
						
						if (DeathExplosionShake != None)
						{
							ShakeScale = 1.0;
							if (Dist > InnerExplosionShakeRadius)
							{
								ShakeScale -= (Dist - InnerExplosionShakeRadius) / (OuterExplosionShakeRadius - InnerExplosionShakeRadius);
							}
							UTPC.PlayCameraAnim(DeathExplosionShake, ShakeScale);
						}
					}
				}
				bIsVisible = bIsVisible || (WorldInfo.TimeSeconds - LastRenderTime < 3.0);
			}

			// determine which explosion to use
			if ( bIsVisible )
			{
				if( !bDoingSecondaryExplosion )
				{
					if( BigExplosionTemplates.length > 0 )
					{
						Template = class'UTEmitter'.static.GetTemplateForDistance(BigExplosionTemplates, Location, WorldInfo);
					}
				}
				else
				{
					Template = SecondaryExplosion;
				}

				PlayVehicleExplosionEffect( Template, !bDoingSecondaryExplosion );
			}

			if (ExplosionSound != None)
			{
				PlaySound(ExplosionSound, true);
			}

			//Remove this check if we ever go back to vehicle explosions causing damage
			if(!bDoingSecondaryExplosion)
			{
				HurtRadius(ExplosionDamage, ExplosionRadius, class'UTDmgType_VehicleExplosion', ExplosionMomentum, Location,, GetCollisionDamageInstigator());
				AddVelocity((ExplosionMomentum / Mass) * vect(0,0,1), Location, class'UTDmgType_VehicleExplosion');
			}
		
		} 
	 
		if(bDoingSecondaryExplosion)
		{
			return; 
		}

		// If in air, add some anglar spin.
		
		if(Role == ROLE_Authority && !bVehicleOnGround)
		{
			Mesh.SetRBAngularVelocity(VRand() * ExplosionInAirAngVel, TRUE);
		}


		/*Inject to make aircraft do fancy things when they die (Like spin around)*/
		
		if(Rx_Vehicle_Air(self) != none || Rx_Vehicle_Air_Jet(self) != none) {	
			PerpendicularVelocity.Pitch = Mesh.rotation.pitch+DestroyedRotatorAddend.pitch;
			PerpendicularVelocity.Roll=Mesh.rotation.Roll+DestroyedRotatorAddend.Roll;
			PerpendicularVelocity.Yaw=Mesh.rotation.Yaw+DestroyedRotatorAddend.Yaw;
			
			Mesh.AddForce(DeathImpulseStrength * vector(PerpendicularVelocity), location + vector(rotation) * (DestroyedImpulseOffset * -1.0)); 
			bStayUpright = bStayUprightOnDeath;
			
			SetCollision(false, false); 
			
		}
		else {
			Mesh.SetHidden(true);
			SetCollision(false, false); 
		}
	}
}

simulated function ClientSetAsTarget(int Spot_Mode, coerce string TeamString, int Num)
{
	if(Health <= 0 || self.IsInState('Dead') ) return;
	ServerSetAsTarget(Spot_Mode, TeamString, Num);
}

reliable server function ServerSetAsTarget(int Spot_Mode, coerce string TeamString, int Num)
{
	local Rx_ORI ORI;

	ORI = Rx_GRI(WorldInfo.GRI).ObjectiveManager;

	ORI.Update_Markers (
		TeamString, //String of what team we're updating these for. The object keeps track of GDI/Nod targets, but only displays the targets that correspond with the 
		Spot_Mode, //Type of call getting passed down. 0:Attack 1: Defend 2: Repair 3: Waypoint
		0, //Whether to update Commander/CoCommander or Support Targets [assume 1 commander for now]
		false, // If we're looking to update a waypoint. If this is true, and CT is equal to 1, we'll update the defensive waypoint.
		false, //If this is a building being targeted
		self	//Actor we'll be marking
	);
}

simulated function SetTargetAlarm (int Time)
{
	SetTimer(Time,false,'TargetAlarm');
}

simulated function TargetAlarm()
{
	local Rx_ORI ORI;
	local Rx_Controller PC;
	
	PC = Rx_Controller(GetALocalPlayerController()) ;
	ORI=Rx_GRI(WorldInfo.GRI).ObjectiveManager; 
	
	ORI.NotifyTargetDecayed(self); //Decay
	
	PC.HudVisuals.NotifyTargetDecayed(self); //Decay
	
}

reliable client function ClientNotifyTarget(int TeamNum, int Target_Type, int TargetNum)
{
	local Rx_Controller PC;
	
	PC = Rx_Controller(GetALocalPlayerController()) ;
	PC.HudVisuals.UpdateTargets(self, TeamNum, Target_Type, TargetNum);
	
}

reliable client function ClientNotifyTargetKilled() 
{
	
	local Rx_ORI ORI;
	local Rx_Controller PC;
	
	PC = Rx_Controller(GetALocalPlayerController()) ;
	ORI=Rx_GRI(WorldInfo.GRI).ObjectiveManager; 
	
	ORI.NotifyTargetKilled(self); //Decay
	
	PC.HudVisuals.NotifyTargetKilled(self); //Decay	
}

function PromoteUnit(byte rank, optional bool bInitial) //Promotion depends mostly on the unit. All units gain health however [was simulated]
{	
	local float HealthPCT; 

	if(rank < 0) rank = 0;
	else
	if(rank > 9) rank = 9; 

	HealthPCT=float(Health)/float(HealthMax); 

	HealthMax=default.Health*VetRankInfo[rank].HealthMod;
	Health=HealthMax*HealthPCT; 

	VRank=rank; 

	if(rank >= 6)
	{
		SetTimer(0.5f, true, 'regenerateHealth'); 
		if(rank == 9)
			RegenerationRate = HeroicRegenerationRate; 
		else
			RegenerationRate = default.RegenerationRate; 
	}
	else		
	{
		if(IsTimerActive('regenerateHealth') && !bAlwaysRegenerate) ClearTimer('regenerateHealth') ;
		if(WorldInfo.NetMode == NM_Standalone) SetHeroicMuzzleFlash(false);	
	}

	if(WorldInfo.NetMode == NM_Standalone && rank >= 9)
		SetHeroicMuzzleFlash(true);

	if(WorldInfo.NetMode == NM_Standalone)
		SetHeroicAmbientSounds(rank >= 9);

	if(Rx_vehicle_Weapon(Weapon) != none)
		Rx_Vehicle_Weapon(Weapon).PromoteUnit(rank);
}

function regenerateHealth()
{
	if(bTakingDamage) return; 

    if(Health  < HealthMax) {    
		Health += RegenerationRate;
		if(Health > HealthMax) Health=HealthMax; 

		ApplyMorphHeal(RegenerationRate);
    }
}

function setTakingDamage()
{
	bTakingDamage = true; 
	SetTimer(3.0,false,'ResetTakingDamageTimer');
}

function ResetTakingDamageTimer()
{
	bTakingDamage = false; 
}


function string BuildDeathVPString(Controller Killer, class<DamageType> DamageType)
{
	local string VPString;
	local int IntHolder; //Hold current number we'll be using 
	local int KillerVRank; 
	local float BaseVP;
	local string Killer_Location, Victim_Location;  
	local Rx_PRI KillerPRI; 
	local bool	bNeutral; 
	
	
	if((Killer == none && Rx_Controller(Killer) == none && Rx_Bot(Killer) == none) || LastTeamToUse == Killer.GetTeamNum() ) 
		return ""; //Only RX controllers and bots have a concept of VP

	
	//Remember that -I- am the victim here
	//Begin by finding WHAT we are
	if(RxIfc_Veterancy(Killer.Pawn) != none)
	{
		KillerVRank = RxIfc_Veterancy(Killer.Pawn).GetVRank();
	}
	
	/*Finding location info*/ 
	KillerPRI = Rx_PRI(Killer.PlayerReplicationInfo);
	
	IntHolder=Killer.GetTeamNum(); 
	
	Killer_Location = GetPawnLocation(Killer.Pawn); 
	
	IntHolder=GetTeamNum(); 
	
	Victim_Location = GetPawnLocation(self); 
	/*End Getting location*/
	
	//VP count starts here. 
	BaseVP = default.VetRankInfo[VRank].VPReward; 
	
	bNeutral = true; 
	
	VPString = "["$ GetHumanReadableName() @"Kill]&+" $ BaseVP $ "&" ; 
	
	/**************************************************/
	/*Look for neutral Modifiers (Pawns and Vehicles)*/
	/**************************************************/
	//Are THEY defending a beacon 
	if(NearEnemyBeacon()) //If we're near an enemy beacon 
	{
	
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_BeaconDefense;	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Beacon Defence]&+" $ IntHolder $ "&";
		
		if(KillerPRI != none)
		{
			KillerPRI.AddBeaconKill(); 
			KillerPRI.AddBeaconKill(); //So nice, we do it twice for vehicles
		}
		
	}
		
	if(NearFriendlyBeacon()) //If we're near a friendly beacon 
	{
	
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_BeaconAttack;	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Beacon Offence]&+" $ IntHolder $ "&";
	
	} 
		//Are we a substantially higher VRank than them ? 
	if(TempVRank > KillerVRank ) //Ya' done got fucked, son  [Negative Modifiers] (Leave out the '+') 
	{
	
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_Disadvantage*(VRank - KillerVRank);	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Disadvantage]&+" $ IntHolder $ "&";
	
	}
		
	if( PawnInFriendlyBase(Victim_Location, self) ) // Getting wrecked in your own base
	{
	
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_AssaultKill;	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Offensive Kill]&" $ IntHolder $ "&";
		
		if(KillerPRI != none)
			KillerPRI.AddOffensiveVehKill(); 
		
		bNeutral = false; 
	} 
		//Is this a Ground-to-Air exchange
	if(Rx_Vehicle_Air(self) != none  &&  Rx_Vehicle_Air(Killer.Pawn) == none) //Killing an air vehicle with a ground vehicle 
	{
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_Ground2Air;	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Ground to Air]&" $ IntHolder $ "&";
	} 
	/********************/
	/*Negative Modifiers*/
	/********************/
	if(KillerVRank > VRank ) //Is this bastard gimping ? [Negative Modifiers] (Leave out the '+') 
	{
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_UnfairAdvantage*(KillerVRank-VRank);	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Vet Advantage]&" $ IntHolder $ "&";
	} 
		
	if( PawnInFriendlyBase(Killer_Location, Killer.Pawn) ) //Is this bastard in his own base ? [Negative Modifiers] (Leave out the '+') 
	{
		IntHolder = class'Rx_VeterancyModifiers'.default.Mod_DefenseKill;	
			
		BaseVP+=IntHolder;
		
		VPString = VPString $ "[Defensive Kill]&" $ IntHolder $ "&";
		
		if(KillerPRI != none)
			KillerPRI.AddDefensiveVehKill();
		
		bNeutral = false; 
	} 
		
	//EDIT Just show NET amount. Comment this out to show full feat list 
		
	BaseVP=fmax(1.0, BaseVP); //Offer at least 1 VP cuz... why not ? Consolation prize
		
	if(KillerPRI != none)
		KillerPRI.AddVehicleKill();
	
	if(bNeutral)
		KillerPRI.AddNeutralVehKill();
		
	return "["$ GetHumanReadableName() @"Kill]&+" $ BaseVP $ "&" ;
}

//A much lighter variant of the VPString builder, used to calculate assists (Which only add in negative modifiers for in-base and higher VRank)
function int BuildAssistVPString(Controller Killer) 
{
	local int EndAssistModifier;
	local int KillerVRank; 
	local string Killer_Location, Victim_Location; 
	local Rx_PRI KillerPRI;
	local bool	 bNeutral; 
	
	//Remember that -I- am the victim here
	
	if(Rx_Controller(Killer) == none && Rx_Bot(Killer) == none) return 0; //Only RX controllers and bots have a concept of VP
	
	if(RxIfc_Veterancy(Killer.Pawn) != none)
	{
		KillerVRank = RxIfc_Veterancy(Killer.Pawn).GetVRank();
	}
	/*Finding location info*/ 
	
	bNeutral = true; 
	
	KillerPRI=Rx_PRI(Killer.PlayerReplicationInfo);
	
	Killer_Location = GetPawnLocation(Killer.Pawn); 
	
	Victim_Location = GetPawnLocation(self); 
	
	/*End Getting location*/
	
	//VP count starts here. 
		
	/********************/
	/*Positive Modifiers*/
	/********************/
	
	if( PawnInFriendlyBase(Victim_Location, self) ) // Getting wrecked in your own base
	{
		EndAssistModifier += class'Rx_VeterancyModifiers'.default.Mod_AssaultKill;		
		
		if(KillerPRI != none)
			KillerPRI.AddOffensiveVehAssist(); 
		
		bNeutral = false; 
	} 
		
	/********************/
	/*Negative Modifiers*/
	/********************/
		
	if(KillerVRank > VRank ) //Is this bastard gimping ? [Negative Modifiers] (Leave out the '+') 
	{
		EndAssistModifier += class'Rx_VeterancyModifiers'.default.Mod_UnfairAdvantage*(KillerVRank-VRank);	
	} 
		
	if( PawnInFriendlyBase(Killer_Location, Killer.Pawn) ) //Is this bastard in his own base ? [Negative Modifiers] (Leave out the '+') 
	{
		EndAssistModifier += class'Rx_VeterancyModifiers'.default.Mod_DefenseKill;	
			
		if(KillerPRI != none)
			KillerPRI.AddDefensiveVehAssist(); 
		
		bNeutral = false; 
	} 
		
	if(KillerPRI != none)
	{
		KillerPRI.AddVehicleAssist(); 
		
		if(bNeutral)
			KillerPRI.AddNeutralVehAssist();
		
		KillerPRI.AddScoreToPlayerAndTeam(0); /*Add 0 for assists. That way they don't affect Legacy, but also call the update for Score in the new PRI score system.*/
	}

	return EndAssistModifier;
}

function bool NearFriendlyBeacon()
{
	local Rx_Weapon_DeployedBeacon CloseBeacon; 

	foreach OverlappingActors(class'Rx_Weapon_DeployedBeacon', CloseBeacon, 1500)
	{
		if(CloseBeacon.GetTeamNum() == GetTeamNum()) 
			return true; 
	}

	return false; 
}

function bool NearEnemyBeacon()
{
	local Rx_Weapon_DeployedBeacon CloseBeacon; 

	foreach OverlappingActors(class'Rx_Weapon_DeployedBeacon', CloseBeacon, 1500)
	{
		if(CloseBeacon.GetTeamNum() != GetTeamNum()) 
			return true; 
	}
	return false; 
} 

/*Check if the Pawn is in base. This is expensive... don't ever spam this*/
function string GetPawnLocation (Pawn P)
{
	local string LocationInfo;
	local Rx_GRI WGRI; 
	local RxIfc_SpotMarker SpotMarker;
	local Actor TempActor;
	local float NearestSpotDist;
	local RxIfc_SpotMarker NearestSpotMarker;
	local float DistToSpot;	
	
	WGRI = Rx_GRI(WorldInfo.GRI);
	
	if(P == none || WGRI == none) return "";
		
	foreach WGRI.SpottingArray(TempActor) {
		SpotMarker = RxIfc_SpotMarker(TempActor);
		DistToSpot = VSizeSq(TempActor.location - P.location);
		if(NearestSpotDist == 0.0 || DistToSpot < NearestSpotDist) {
			
			NearestSpotDist = DistToSpot;	
			NearestSpotMarker = SpotMarker;
		}
	}
	
	LocationInfo = NearestSpotMarker.GetSpotName();	
	return LocationInfo; 
}

simulated function PlayTaunt(byte Option = 0)
{
	if(Role < Role_Authority) 
		ServerPlayTaunt(Option); 
	else if(!VoiceComponent.isPlaying())
		{
			PlayVoiceSound('Taunt',false, Option);
		}
	 
}

unreliable server function ServerPlayTaunt(byte Option = 0)
{
	
	PlayVoiceSound('Taunt',false, Option); 
	
}

simulated function PlayVoiceSound(name VoiceOverType, bool bOverrideSound, optional byte VoiceLineNum = 0) //Voice sounds all start on the server
{
	local SoundNodeWave SoundToPlay;
	local float SoundDuration;
	//local PlayerController PC;
	local class<Rx_FamilyInfo> FamInfo; 

	if (Controller == GetALocalPlayerController())
	{
		VoiceComponent.bAllowSpatialization = false;
	}
	
	if(Role == Role_Authority && VoiceOverType != 'Taunt') 
	{		
		if(isTimerActive('ClearReplicatedVoice')) 
			ClearTimer('ClearReplicatedVoice');
		
		if(IsInState('Stealthed') && VoiceOverType != 'VehicleAcquired')
			return; 
		
		VoiceLineNum = PickRandomVoiceIndex(VoiceOverType); //If we're the server or a standalone, choose the line to say
	}
	
	if(WorldInfo.NetMode == NM_DedicatedServer) //Just replicate to clients
	{
		//`log("Played Sound on server" @ VoiceLineNum @ VoiceOverType); 
		ReplicatedVoice.VoiceIndex = VoiceLineNum;
		ReplicatedVoice.SoundType = VoiceOverType;
		ReplicatedVoice.bCanOverride = bOverrideSound;
		SetTimer(0.5,false,'ClearReplicatedVoice');
		if(bCanHitReact && VoiceOverType == 'Damage') 
		{
			bCanHitReact=false;
			SetTimer(4.0,false,'ResetHitReaction');
		}
		
		if(bPlayAssistSound && VoiceOverType == 'Assist')
		{
			bPlayAssistSound=false;
			SetTimer(20.0,false,'ResetAssistVoice');
		}
	
		bNetDirty = true; 
		return;
	}
	
	if( (VoiceComponent.isPlaying() && !bOverrideSound ) || (VoiceOverType=='Damage' && !bCanHitReact) || (self.IsInState('Dead') && VoiceOverType != 'Death'))  
	{
		return;
	}
	
	VoiceComponent.Stop(); 
	
	//if(IsTimerActive('ClearVoiceComponent')) ClearTimer('ClearVoiceComponent');
	
	FamInfo = GetRxFamilyInfo();
	//`log(VoiceLineNum @ VoiceOverType);  
	
	switch (VoiceOverType)
	{
		case 'Taunt' :
		SoundToPlay = GetVoiceClass().static.GetTauntSound(VoiceLineNum);
		
		break;
		
		case 'Death' :
			SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetDeathSound(VoiceLineNum);
			break;
		
		case 'Kill' :
		SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetKillConfirmSound(VoiceLineNum);
		break;
		
		case 'DestroyVehicle' :
		SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetDestroyVehicleSound(VoiceLineNum);
		break;
		
		case 'Assist' :
		SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetAssistSound(VoiceLineNum);
		break;
		
		case 'DestroyBuilding' :
		SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetBuildingDestroyedSound(VoiceLineNum);
		break;

		case 'VehicleAcquired' :
		SoundToPlay = FamInfo.default.PawnVoiceClass.static.GetVehicleAcquiredSound(VoiceLineNum);
		break;
	}
	
	if(SoundToPlay == none) return;
	//SoundToPlay = SoundNodeWave'RX_CharSnd_Generic.gdi_male.S_Soldier_GDI_AreaSecured_02';
	if(SoundToPlay.Duration > 2.5) 
		SoundDuration=SoundToPlay.Duration; 
	else
		SoundDuration=2.5; 
	
	if((WorldInfo.Netmode == NM_Client || WorldInfo.NetMode == NM_Standalone) && Rx_Controller(Controller) !=none) //Your own voice may need to be slightly lower
	{
		if(DrivenVehicle == none) VoiceComponent.VolumeMultiplier= FamInfo.default.PawnVoiceClass.default.PersonalVolumeModifier; 
		else
		VoiceComponent.VolumeMultiplier= FamInfo.default.PawnVoiceClass.default.PersonalVolumeModifier+0.30; 
	}

		
	VoiceComponent.SetWaveParameter('Voice', SoundToPlay);
	VoiceComponent.SoundCue.Duration=SoundDuration;
	VoiceComponent.Play(); 	
}

function ClearReplicatedVoice()
{
	ReplicatedVoice.SoundType='NULL'; 
}

function int PickRandomVoiceIndex(name VoiceType) //Pick a voice index, but try to prevent playing the same sound twice in a row
{
	local int Output, PosNeg, Integer;
	//local byte LastInteger; //Uncomment for debugging only

	//Integer to use

	if(VoiceType == 'Kill')  Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.KillConfirmSounds.Length);
	else
	if(VoiceType == 'Damage') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.TakeDamageSounds.Length);
	else
	if(VoiceType == 'DamageTaunt') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.TakeDamageTauntSounds.Length);
	else
	if(VoiceType == 'DestroyVehicle') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.DestroyVehicleSounds.Length);
	else
	if(VoiceType == 'Taunt') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.TauntSounds.Length);
	else
	if(VoiceType == 'Assist') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.AssistSounds.Length);
	else
	if(VoiceType == 'DestroyBuilding') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.BuildingDestroyedSounds.Length);
	else
	if(VoiceType == 'VehicleAcquired') Integer=(GetRxFamilyInfo().default.PawnVoiceClass.default.VehicleAcquiredSounds.Length);
	else 
	//Death sounds are more rare and don't need to be super randomized
	if(VoiceType == 'Death') 
	{
	return DeathSound ; //rand(GetRxFamilyInfo().default.PawnVoiceClass.default.DeathSounds.Length);	
	}

	if(Integer == 2)
	{
		switch(VoiceType)
		{
			case 'Kill':
				LastPicked_KillConfirm= LastPicked_KillConfirm == 0 ? 1 : 0 ;
				return LastPicked_KillConfirm;  
				break;
				
			case 'Damage':
				LastPicked_Hit= LastPicked_Hit == 0 ? 1 : 0 ;
				return LastPicked_Hit;  
			break;
			
			case 'DestroyVehicle':
				LastPicked_VKillConfirm = LastPicked_VKillConfirm == 0 ? 1 : 0 ;
				return LastPicked_VKillConfirm;  
				//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
			break;		
			case 'DestroyBuilding':
				LastPicked_BKill = LastPicked_BKill == 0 ? 1 : 0 ;
				return LastPicked_BKill;  
				//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
			break;
			
			case 'Assist':
				LastPicked_Assist = LastPicked_Assist == 0 ? 1 : 0 ;
				return LastPicked_Assist;  
				//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
			break;

			case 'VehicleAcquired':
				VehicleAcquiredSound = VehicleAcquiredSound == 0 ? 1 : 0 ;
				return VehicleAcquiredSound;  
				//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
			break;
			
			default:
			break;
		}
		
		
	}
	else
	if(Integer==1) return 0; 

	PosNeg=rand(100);

	Output=rand(Integer);



	switch(VoiceType)
	{
		case 'Kill':
			Output = PosNeg <= 20 ? LastPicked_KillConfirm+1+rand(2) : LastPicked_KillConfirm-1-rand(2);
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1;
			//LastInteger=LastPicked_KillConfirm;
			LastPicked_KillConfirm=Output;
			//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
			break;
		case 'Damage':
			Output = PosNeg <= 20 ? LastPicked_Hit+1+rand(2) : LastPicked_Hit-1-rand(2);
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1; 
		
			//LastInteger=LastPicked_Hit;
			LastPicked_Hit=Output;
			//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
		break;
		
		case 'DestroyVehicle':
			
			Output = PosNeg <= 20 ? LastPicked_VKillConfirm+1+rand(2) : LastPicked_VKillConfirm-1-rand(2);
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1;
			
			//LastInteger=LastPicked_VKillConfirm;
			LastPicked_VKillConfirm = Output; 
			//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 
		break;
		
		case 'DestroyBuilding':
			
			Output = PosNeg <= 20 ? LastPicked_BKill+1+rand(2) : LastPicked_BKill-1-rand(2);
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1;
			
			LastPicked_BKill = Output; 
		break;
		
		case 'Assist':
			
			OutPut = LastPicked_Assist+1; 
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1;

			LastPicked_Assist = Output; 
		break;

		case 'VehicleAcquired':
			
			OutPut = VehicleAcquiredSound+1; 
			
			if(Output > Integer-1) Output = 0; 
			else
			if(Output < 0) OutPut = Integer-1;

			VehicleAcquiredSound = Output; 
		break;
		
		
		default:
		break;
	}

		
	//`log("Integer/Output/Last" @ Integer @ OutPut @ LastInteger); 

	return Output; 
}

simulated function ClearVoiceComponent()
{
	VoiceComponent.SetWaveParameter('Voice', none);
	VoiceComponent.SoundCue.Duration=0.0;	
}

simulated function AttachVoiceBox()
{	
	Mesh.AttachComponentToSocket(VoiceComponent, 'Root');
}

simulated function class<Rx_FamilyInfo> GetRxFamilyInfo()
{
	local class<Rx_FamilyInfo> famInfo;
	famInfo = class<Rx_FamilyInfo>(CurrCharClassInfo);
	
	if(famInfo == None) return class'Rx_FamilyInfo_GDI_Soldier' ;
	
	return famInfo;
}

simulated function class<Rx_Pawn_VoiceClass> GetVoiceClass()
{
	if(VehicleVoiceClass != none)
		return VehicleVoiceClass; 
	else
		return GetRxFamilyInfo().default.PawnVoiceClass;
}

function bool PawnInFriendlyBase(coerce string LocationInfo, Pawn P)
{
	local int TEAMI;
	local Volume V; 
	
	if(P == none) 
		return false;
	
	if(Rx_Vehicle(P) != none) 
		TeamI=Rx_Vehicle(P).LastTeamToUse; //If it's a vehicle then go off of the last team that used it.
	else
		TEAMI=P.GetTeamNum();

	switch(TEAMI)
	{
		case 0:
			foreach TouchingActors(class'Volume', V)
			{
				if(Rx_Volume_TeamBase_GDI(V) != none) return true; 
				else
				continue; 
			}
	
			break;
	
		case 1: 
			foreach TouchingActors(class'Volume', V)
			{
				if(Rx_Volume_TeamBase_Nod(V) != none) return true; 
				else
				continue; 
			}
	
			break;
	
		default:
			return false;
	}

	return false; 	
}

function bool PawnInEnemyBase(coerce string LocationInfo, Pawn P)
{
	local int TEAMI;
	local Volume V; 
	
	if(P==none) return false;
	
	if(Rx_Vehicle(P) != none) 
		TeamI=Rx_Vehicle(P).LastTeamToUse; //If it's a vehicle then go off of the last team that used it.
	else
		TEAMI=P.GetTeamNum();
	
	switch(TEAMI)
	{
		case 0: 
			foreach TouchingActors(class'Volume', V)
			{
				if(Rx_Volume_TeamBase_Nod(V) != none) 
					return true; 
				else
					continue; 
			}
			break;
	
		case 1: 
			foreach TouchingActors(class'Volume', V)
			{
				if(Rx_Volume_TeamBase_GDI(V) != none) 
					return true; 
				else
					continue; 
			}
			break;

		default: 
			return false; 
	}
	
	return false; 	
}

function HealerKillAssistBonus (int Amount, string KilledNameFriendly) //For infantry... may just make it for everyone honestly
{
	local Repairer RPRII;
	local Controller C; 
		foreach CurrentHealers(RPRII)
		{
			if(RPRII.PPRI != none)
			{
				if(RPRII.PPRI == Driver.PlayerReplicationInfo)
					continue; // No repair-assisting yourself. Ty for the info by the way, Hyperion
				if((WorldInfo.TimeSeconds - RPRII.LastRepairTime) <= 5.0) 
				{
					C=Controller(RPRII.PPRI.Owner); 
					if(Rx_Controller(C) != none ) Rx_Controller(C).DisseminateVPString("["$KilledNameFriendly$" Kill Repair Assist]&" $ Amount $ "&"); 
					else
					if(Rx_Bot(C) != none ) Rx_Bot(C).DisseminateVPString("["$KilledNameFriendly$" Kill Repair Assist]&" $ Amount $ "&"); 
				}
			}
		}
}

simulated function SitDriver( UTPawn UTP, int SeatIndex)
{
	if (Seats[SeatIndex].SeatBone != '')
	{
		UTP.SetBase( Self, , Mesh, Seats[SeatIndex].SeatBone);
	}
	else
	{
		UTP.SetBase( Self );
	}
	SetMovementEffect(SeatIndex,true, UTP);

	// Shut down physics when getting in vehicle.
	if(UTP.Mesh.PhysicsAssetInstance != None)
	{
		UTP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
	}
	UTP.Mesh.bUpdateKinematicBonesFromAnimation = false;
	UTP.Mesh.PhysicsWeight = 0.0;

	if ( Seats[SeatIndex].bSeatVisible )
	{
		if ( (UTP.Mesh != None) && (Mesh != None) )
		{
			UTP.Mesh.SetShadowParent(Mesh);
			UTP.Mesh.SetLightEnvironment(LightEnvironment);
		}
		UTP.SetMeshVisibility(true);
		if(WorldInfo.NetMode != NM_Standalone)
			UTP.SetRelativeLocation( Seats[SeatIndex].SeatOffset + (vect(0,0,1) * UTP.BaseTranslationOffset) );
		else
			UTP.SetRelativeLocation( Seats[SeatIndex].SeatOffset );
		UTP.SetRelativeRotation( Seats[SeatIndex].SeatRotation );
		UTP.Mesh.SetCullDistance(0); // 0 means no cull
		UTP.Mesh.SetTranslation(vect(0,0,1) * UTP.BaseTranslationOffset);
		UTP.SetHidden(false);
	}
	else
	{
		UTP.SetHidden(True);
	}
}

simulated function vector GetAdjustedEffectLocation(int SeatIndex) //Use this when sticking barrels through terrain
{
	local vector SocketLocation;
	local rotator SocketRotation;

	if ( Seats[SeatIndex].GunSocket.Length == 0 )
		return Location;
	
	
	GetBarrelLocationAndRotation(SeatIndex,SocketLocation, SocketRotation);
	SocketLocation = SocketLocation+vector(SocketRotation) * (-1.0*BarrelLength[SeatIndex]); 

	return SocketLocation;
}

simulated function Vector GetAdjustedPhysicalFireStartLoc(UTWeapon ForWeapon)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(ForWeapon);
	if ( VWeap != none )
	{
		return GetAdjustedEffectLocation(VWeap.SeatIndex);
	}
	else
		return location;
}

 simulated function SetVehicleEffectParms(name TriggerName, ParticleSystemComponent PSC)
 {
	super.SetVehicleEffectParms(TriggerName, PSC);
 }
 
 simulated function SetHeroicMuzzleFlash(bool SetTrue)
 {
	 local int i; 
	 
	 if(Heroic_MuzzleFlash == none) return; 
	 
	 for(i=0;i<VehicleEffects.Length;i++)
	 {
		 if(VehicleEffects[i].EffectStartTag=='MainGun' && VehicleEffects[i].EffectRef != none) 
		 {
			 if(SetTrue) VehicleEffects[i].EffectRef.SetTemplate(Heroic_MuzzleFlash);
			 else
			VehicleEffects[i].EffectRef.SetTemplate(default.VehicleEffects[i].EffectTemplate);
			return;
		 }
	 }
 }

simulated function SetHeroicAmbientSounds(bool SetTrue); //Set in sub classess

 reliable client function ClientUpdatePhysics( EPhysics newPhysics )
 {
	SetPhysics(newPhysics) ;
 }

//RxIfc_Airlift
simulated function bool bReadyToLift() 
{
	return (PlayerReplicationInfo == None && LastTeamToUse == 255 &&  !bPickedUp) ;
} 

simulated function OnAttachToVehicle()
{
	if(Rx_SupportVehicle(Base) != none) LastTeamToUse = Rx_SupportVehicle(Base).TeamIndex;
}

simulated function DetachFromVehicle()
{
	SetPhysics(PHYS_RigidBody); 
	Mesh.WakeRigidBody();
}
//End RxIfc_Airlift

/****Do not stack supply crate healing*****/
function SetLastSupportHealTime()
{
	if(Rx_Controller(Controller) != none) Rx_Controller(Controller).SetLastSupportHealTime();  
	else
	if(Rx_Bot(Controller) != none) Rx_Bot(Controller).SetLastSupportHealTime(); 
}

function bool bCanAcceptSupportHealing()
{
	if(Rx_Controller(Controller) != none) return Rx_Controller(Controller).LastSupportHealTime < WorldInfo.TimeSeconds ; 
	else
	if(Rx_Bot(Controller) != none) return Rx_Bot(Controller).LastSupportHealTime < WorldInfo.TimeSeconds; 
	else
	return false; 
}


/**Stat Modifier Calls**/ 
simulated function float GetSpeedModifier()
{
	if(bEMPd && bEMPDisablesVehicle) return 0.0; 
	
	if(Rx_Controller(Controller) != none) 
		return (VetRankInfo[VRank].SprintSpeedMod+(Rx_Controller(Controller).Misc_SpeedModifier)); 
	
	else if(Rx_Bot(Controller) != none) 
	{
		return VetRankInfo[VRank].SprintSpeedMod+(Rx_Bot(Controller).Misc_SpeedModifier); 
	}
	
	else if(Rx_Vehicle_HarvesterController(Controller) != none) 
		return VetRankInfo[VRank].SprintSpeedMod+(Rx_Vehicle_HarvesterController(Controller).Misc_SpeedModifier); 
	
	else if(Rx_Defence_Controller(Controller) != none) 
		return VetRankInfo[VRank].SprintSpeedMod+(Rx_Defence_Controller(Controller).Misc_SpeedModifier); 
	
	else
		return VetRankInfo[VRank].SprintSpeedMod; 
}

simulated function float GetScriptedSpeedModifier()
{
	if(Rx_Bot_Scripted(Controller) != None)
		return Rx_Bot_Scripted(Controller).SpeedModifier;
	else
		return 1.f;
}

//Resistance is about the only thing defences and Harvesters need to worry about 
function float GetResistanceModifier()
{
	if(Rx_Controller(Controller) != none) return Rx_Controller(Controller).Misc_DamageResistanceMod; 
	else
	if(Rx_Bot(Controller) != none) return Rx_Bot(Controller).Misc_DamageResistanceMod; 
	else
	if(Rx_Vehicle_HarvesterController(Controller) != none) return Rx_Vehicle_HarvesterController(Controller).Misc_DamageResistanceMod;
	else
	if(Rx_Defence_Controller(Controller) != none) return Rx_Defence_Controller(Controller).Misc_DamageResistanceMod; 
	else
	return 1.0; 
}

simulated function UpdateSpotLocation()
{
	local string STS; 
	if(Rx_Controller(Controller) == none || Rx_Bot(Controller) == none)
	{
		ClearTimer('UpdateSpotLocation');
		return;
	}
	
	STS = GetPawnLocation(self);
	SpotLocation = STS; 
	ServerSendLocationInfo(STS);  
}

reliable server function ServerSendLocationInfo(coerce string STR)
{
	SpotLocation = STR; 
}


/** Jacked the Link gun code, as vehicles already have most of the code for overlays in that*/
simulated function SetOverlay(LinearColor MatColour)
{
	local MaterialInstanceConstant MIC;
	local int i;
	
	/*Server doesn't need to concern itself with visuals, and just replicates the colour */
	if(WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer) 
	{
		VehicleOverlayColour = MatColour; 
		return; 
	}
	
	/*Run client/standalone visual code*/
	
	for (i = 0; i < Mesh.Materials.Length || i < Mesh.SkeletalMesh.Materials.Length; i++)
	{
		if (i < Mesh.Materials.Length)
		{
			MIC = MaterialInstanceConstant(Mesh.Materials[i]);
		}
		if (MIC == None)
		{
			if (i >= Mesh.Materials.Length || Mesh.Materials[i] == None)
			{
				Mesh.SetMaterial(i, Mesh.SkeletalMesh.Materials[i]);
			}
			MIC = Mesh.CreateAndSetMaterialInstanceConstant(i);
		}
		if (MIC != None)
		{
			MIC.SetVectorParameterValue('Veh_OverlayColor', MatColour);
			MIC.SetScalarParameterValue('Veh_Overlay_Distort_Amount', 0.500000); //Stop being so damn weird
		}
	}
}

/** Just stole the link gun code to avoid reinventing the wheel entirely*/
simulated function ClearOverlay()
{
	local MaterialInstanceConstant mic;
	local LinearColor Black;
	local int i;

	/*Server doesn't need to concern itself with visuals, and just replicates the colour */
	if(WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer) 
	{
		VehicleOverlayColour = Black; 
		return; 
	}
	
	for (i = 0; i < Mesh.Materials.Length; i++)
	{
		MIC = MaterialInstanceConstant(Mesh.Materials[i]);
		if (MIC != None)
		{
			MIC.SetVectorParameterValue('Veh_OverlayColor',Black);
			MIC.SetScalarParameterValue('Veh_Overlay_Distort_Amount', 0.500000); //Stop being so damn weird

		}
	}
}

simulated function float GetTurnTrackSpeedModifier()
{
	if(bEMPd && bEMPDisablesVehicle) return 0.0; 
	if(Rx_Controller(Controller) != none) return VetRankInfo[VRank].SprintTTFDMod+(Rx_Controller(Controller).Misc_SpeedModifier); 
	else
	if(Rx_Bot(Controller) != none) return VetRankInfo[VRank].SprintTTFDMod+(Rx_Bot(Controller).Misc_SpeedModifier); 
	else
	return VetRankInfo[VRank].SprintTTFDMod; 
}

simulated function UpdateThrottleAndTorqueVars()
{
	if(UDKVehicleSimCar(SimObj) != None)
		{
			UDKVehicleSimCar(SimObj).ThrottleSpeed = UDKVehicleSimCar(SimObj).Default.ThrottleSpeed * MinSprintSpeedMultiplier*GetSpeedModifier() * GetScriptedSpeedModifier(); 
			if(Rx_Bot_Scripted(Controller) != None)
			{
				MaxSpeed = Default.MaxSpeed * GetScriptedSpeedModifier();
				ServerSetMaxSpeed(MaxSpeed);
			}
		}
		else if(SVehicleSimTank(SimObj) != None)
		{
			if(bSprinting)
			{
				SVehicleSimTank(SimObj).MaxEngineTorque = SVehicleSimTank(SimObj).Default.MaxEngineTorque * MinSprintSpeedMultiplier * CutTorqueModifier * GetScriptedSpeedModifier();
				SVehicleSimTank(SimObj).InsideTrackTorqueFactor =  SVehicleSimTank(SimObj).Default.InsideTrackTorqueFactor * (MinSprintSpeedMultiplier * CutTorqueModifier) / (Rx_Vehicle_Treaded(self).SprintTrackTorqueFactorDivident+GetTurnTrackSpeedModifier()) * GetScriptedSpeedModifier();
			}
			else
			{
				SVehicleSimTank(SimObj).MaxEngineTorque = SVehicleSimTank(SimObj).Default.MaxEngineTorque * CutTorqueModifier * GetScriptedSpeedModifier(); 
				SVehicleSimTank(SimObj).InsideTrackTorqueFactor =  SVehicleSimTank(SimObj).Default.InsideTrackTorqueFactor  * GetScriptedSpeedModifier();
			}
			
		} 	
}

function bool TryExitPos(Pawn ExitingDriver, vector ExitPos, bool bMustFindGround)
{
	local bool ret;
	
	ret = super.TryExitPos(ExitingDriver, ExitPos, bMustFindGround);	
	if(ret)
	{
		if(PlayAreaVolumeOfPawn(ExitingDriver) == None && PlayAreaVolumeOfPawn(self) != None)
		{	
			return false; // dont allow this Exitlocation as its out of the PlayArea
		}	
	}	
	return ret;
}

function Rx_PlayAreaVolume PlayAreaVolumeOfPawn(Pawn P)
{
	local Rx_PlayAreaVolume V;

	foreach P.CollidingActors( class'Rx_PlayAreaVolume', V , 200.f,P.Location,true)
	{
		if(V.IsAcceptableAreaVolume(V,P))
			return V;
	}

	return None;
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	if(bEMPd && bEMPDisablesVehicle) 
	{
		InForward	=	0.0; 
		InStrafe	=	0.0;
		InUp		=	0.0;
	}		
	
	super.SetInputs(InForward,InStrafe,InUp);
}

simulated function float GetThrottle()
{
	if(UDKVehicleSimCar(simobj) != none)
	{
		return	UDKVehicleSimCar(simobj).ThrottleSpeed;
	}

	if(SVehicleSimTank(simobj) != none)
	{
		return SVehicleSimTank(simobj).MaxEngineTorque;
	}
}

simulated function float GetInwardTurnTrack()
{
	if(UDKVehicleSimCar(simobj) != none)
	{
		return	0.0; 
	}
	else
	if(SVehicleSimTank(simobj) != none)
	{
		return SVehicleSimTank(simobj).InsideTrackTorqueFactor;
	}
	else
	return 0.0; 
}

/******************
*RxIfc_RadarMarker*
*******************/

//0:Infantry 1: Vehicle 2:Miscellaneous  
simulated function int GetRadarIconType()
{
	return 1; //Vehicle
} 

simulated function bool ForceVisible()
{
	// If empty and last team to use is current team or last use was neutral
	// or if not empty and spotted
	// or bot and forced visible
	return (PlayerReplicationInfo == none && GetTeamNum() == 255 && (LastTeamToUse == GetALocalPlayerController().GetTeamNum() || LastTeamToUse == 255)) ||
	(Rx_PRI(PlayerReplicationInfo) !=none && Rx_PRI(PlayerReplicationInfo).isSpotted()) || 
	(Rx_ScriptedBotPRI(PlayerReplicationInfo) !=none && Rx_ScriptedBotPRI(PlayerReplicationInfo).GetRadarVisibility() == 2);  
}

simulated function vector GetRadarActorLocation() 
{
	return location; 
} 
simulated function rotator GetRadarActorRotation()
{
	return rotation; 
}

simulated function byte GetRadarVisibility()
{
	if(Rx_ScriptedBotPRI(PlayerReplicationInfo) != None)
		return Rx_ScriptedBotPRI(PlayerReplicationInfo).GetRadarVisibility();
	return RadarVisibility; 
} 
simulated function Texture GetMinimapIconTexture()
{
	return MinimapIconTexture; 
}

simulated function bool GetUseSquadMarker(byte TeamByte, byte SquadByte)
{
	return false; 
}

/******************
*END RadarMarker***
*******************/

function UpdatePRILocation()
{
	if(PlayerReplicationInfo == None)
		return;
	if(Rx_PRI(PlayerReplicationInfo) != none)
		Rx_PRI(PlayerReplicationInfo).UpdatePawnLocation(location,rotation, velocity); 
}


/*Modifying Relevancy Temporarily*/

function SetTemporaryRelevance(float Amount)
{
	if(Rx_Game(WorldInfo.Game).bVehiclesAlwaysRelevant)
		return;
	
	SetRelevant(true);

	if(Amount > 0)
		SetTimer(Amount,false,'ResetAlwaysRelevantTimer'); 
}

function SetRelevant(bool Rel)
{
	bAlwaysRelevant = Rel; 
}

function ResetAlwaysRelevantTimer()
{
	bAlwaysRelevant = Rx_Game(WorldInfo.Game).bVehiclesAlwaysRelevant; 
}

simulated function String GetHumanReadableName()
{
	if(CustomVehicleName != "")
		return CustomVehicleName;
	else
		return Super.GetHumanReadableName();
}

function DriverLeft()
{
	local UTPlayerReplicationInfo DriverPRI;

	if(Rx_Controller(Driver.Controller) != None)
		Rx_Controller(Driver.Controller).ClientSetLocationAndKeepRotation( Driver.Location );

	DriverPRI = UTPlayerReplicationInfo(Driver.PlayerReplicationInfo);
	if (DriverPRI != None && DriverPRI.bHasFlag && UDKPawn(Driver) != None)
	{
		UDKPawn(Driver).HoldGameObject(DriverPRI.GetFlag());
	}

	Super(UDKVehicle).DriverLeft();

	if (Occupied())
	{
		return;
	}

	if (VehicleResetTime > 0)
		ResetTime = WorldInfo.TimeSeconds + VehicleResetTime;
}

function bool FindAutoExit(Pawn ExitingDriver)
{
	local vector X, Y, Z;
	local float PlaceDist;

	GetAxes(ExitRotation(), X,Y,Z);
	Y *= -1;

	if ( ExitRadius == 0 )
	{
		ExitRadius = CylinderComponent.CollisionRadius + 2*ExitingDriver.GetCollisionRadius();
	}
	PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();

	if ( Controller != None )
	{
		if ( UTBot(ExitingDriver.Controller) != None )
		{
			// bot picks which side he'd prefer to get out on (since bots are bad at running around vehicles)
			return super.FindAutoExit(ExitingDriver);
		}
		else
		{
			// use the controller's rotation as a hint
			if ( (Y dot vector(Controller.Rotation)) < 0 )
			{
				Y *= -1;
			}
		}
	}

	if ( VSizeSq(Velocity) > Square(MinCrushSpeed) )
	{
		//avoid running driver over by placing in direction away from velocity
		if ( (Velocity Dot X) < 0 )
			X *= -1;
		// check if going sideways fast enough
		if ( (Velocity Dot Y) > MinCrushSpeed )
			Y *= -1;
	}

	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) - (PlaceDist * Y), bFindGroundExit) )
		return true;
	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) + (PlaceDist * Y), bFindGroundExit) )
		return true;

	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) - (PlaceDist * X), false) )
		return true;
	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) + (PlaceDist * X), false) )
		return true;
	if ( !bFindGroundExit )
		return false;
	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) + (PlaceDist * Y), false) )
		return true;
	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) - (PlaceDist * Y), false) )
		return true;
	if ( TryExitPos(ExitingDriver, GetTargetLocation() + (ExitOffset >> Rotation) + (PlaceDist * Z), false) )
		return true;

	return false;
}


simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	/**if(Rx_Vehicle(APawn) != none)
		return false;*/ 
		
	return super.CanBeBaseForPawn(APawn) && Rx_Vehicle_Walker(APawn) == None;
}

static function float GetSpawnOffset() // mainly because things like titans can't fit in the usual spawn point
{
	return default.SpawnOffset;
}

static function float GetSpawnHeightOffset() // mainly because things like titans can't fit in the usual spawn point
{
	return default.SpawnHeightOffset;
}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return Health;} //Return the current health of this target
simulated function int GetTargetHealthMax() {return HealthMax;} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return 0;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return 0;} // Get the current Armour of the target 
simulated function bool GetHasResistance() {return false;} //If this unit has any kind of resistance

// Veterancy

simulated function byte GetVRank() {return VRank;}
simulated function CheckVRank();
simulated function float GetBuildingDamageModifier(optional byte FireModeTag) {return 1.0;} //Gets a multiplier for building damage from this thing (if any)

/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return (1.0 * Health / max(1,HealthMax));}
simulated function float GetTargetArmourPct() {return 0;} //(1.0 * Armor / max(1,float(HealthMax + ArmorMax)));}
simulated function float GetTargetMaxHealthPct() {return 1.0;} //( 1.0 * HealthMax / max(1,float(HealthMax + ArmorMax)));} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return false;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return true;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return ShouldShowUseable(PC,0);} //Are we ever interactable for this controller??
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return CanEnterVehicle(RxPC.Pawn);} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return Health > 0;} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return false;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return false;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return true;} //Does our target box 'stick' even after we're untargeted for awhile 

//Spotting
simulated function bool IsSpottable() {return true;}
simulated function bool IsCommandSpottable() {return true;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return GetHumanReadableName();} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "Press [ " $ BindKey $ " ] to enter " $ GetHumanReadableName();} //Get the text for our interaction 

simulated function string GetTargetedDescription(PlayerController PlayerPerspective)
{

	//return string(Mesh.BodyInstance.GetBodyMass());

	if ( PlayerPerspective.GetTeamNum() != GetTeamNum() && bEMPd)
		return "EMPd - " $ EMPTimeLeft ;

	//Above all else 
	if(Rx_PRI(PlayerReplicationInfo) != none && Rx_PRI(PlayerReplicationInfo).bIsMyCommander()) return "[COMMANDER]";
	
	if (BoundPRI != None) 		
	{
		if (PlayerPerspective.PlayerReplicationInfo == BoundPRI)
		{
			if (bDriverLocked)
				return "Your Vehicle [Locked]";
			else
				return "Your Vehicle";
		}
		else if (BoundPRI.GetTeamNum() == PlayerPerspective.GetTeamNum())
			return BoundPRI.PlayerName$"'s Vehicle";

		else if (bDriverLocked && BoundPRI.GetTeamNum() == PlayerPerspective.GetTeamNum())
			return "Locked by"@BoundPRI.PlayerName;
	}
	else if (buyerPri != None)
	{
		if (PlayerPerspective.PlayerReplicationInfo == buyerPri)
		{
			return "Your Purchased Vehicle";
		}
		else if (buyerPri.GetTeamNum() == PlayerPerspective.GetTeamNum())
		{
			return "Reserved for"@buyerPRI.PlayerName;
		}
	}
	return "";
}

//Actions
simulated function SetTargeted(bool bTargeted) 
{
	bTargetted = bTargeted;
}; //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/


simulated function SwitchTurretControl(bool bNewControl)
{
	local array<UDKSkelControl_TurretConstrained> TurretControllersList;
	local UDKSkelControl_TurretConstrained TC;
	local int OldTurretIndex,NewTurretIndex;
	local Rx_Vehicle_Weapon NewWeap,OldWeap;

    if(Role == ROLE_Authority)
    {
    	if(bNewControl == bPassengerControlTurret)
    		return;

        if((TurretPassengerIndex <= 0 || Seats[TurretPassengerIndex].SeatPawn.Controller == None) && bNewControl)
            return; // no point on switching on one-seater, ignore

//        if(PlayerController(Seats[TurretPassengerIndex].SeatPawn.Controller) == None)
//        	return;
    }

    bPassengerControlTurret = bNewControl;

    OldTurretIndex = bNewControl ? 0 : TurretPassengerIndex;
    NewTurretIndex = bNewControl ? TurretPassengerIndex : 0;

    if(Role == ROLE_Authority)
    {
        if(bNewControl)
        {
        	if(Rx_Controller(Controller) != None)
	            Rx_Controller(Controller).CTextMessage("Turret Switched to Passenger", 'LightGreen', 30.0);

	        if(Rx_Controller(Seats[TurretPassengerIndex].SeatPawn.Controller) != None)
	            Rx_Controller(Seats[TurretPassengerIndex].SeatPawn.Controller).CTextMessage("Turret Switched to Passenger", 'LightGreen', 30.0);

        }
        else
        {
        	if(Rx_Controller(Controller) != None)
	            Rx_Controller(Controller).CTextMessage("Turret Switched to Driver", 'LightGreen', 30.0);

	        if(Rx_Controller(Seats[TurretPassengerIndex].SeatPawn.Controller) != None)
	            Rx_Controller(Seats[TurretPassengerIndex].SeatPawn.Controller).CTextMessage("Turret Switched to Driver", 'LightGreen', 30.0);

        }
        
    	NewWeap = Rx_Vehicle_Weapon(Seats[NewTurretIndex].Gun);
    	OldWeap = Rx_Vehicle_Weapon(Seats[OldTurretIndex].Gun);

    	NewWeap.AmmoCount = OldWeap.AmmoCount;
    	NewWeap.MaxAmmoCount = OldWeap.MaxAmmoCount;

		if(Rx_Vehicle_Weapon_Reloadable(OldWeap) != None)
		{
			Rx_Vehicle_Weapon_Reloadable(NewWeap).CurrentAmmoInClip = Rx_Vehicle_Weapon_Reloadable(OldWeap).CurrentAmmoInClip;

			if(Rx_Vehicle_Weapon_Reloadable(NewWeap).CurrentAmmoInClip <= 0)
				Rx_Vehicle_Weapon_Reloadable(NewWeap).ReloadWeapon();

			

		}    	
		if(Rx_Vehicle_MultiWeapon(OldWeap) != None)
		{
			Rx_Vehicle_Multiweapon(NewWeap).CurrentAmmoInClip[0] = Rx_Vehicle_MultiWeapon(OldWeap).CurrentAmmoInClip[0];
			Rx_Vehicle_Multiweapon(NewWeap).CurrentAmmoInClip[1] = Rx_Vehicle_MultiWeapon(OldWeap).CurrentAmmoInClip[1];		

			if(Rx_Vehicle_Multiweapon(NewWeap).CurrentAmmoInClip[0] <= 0)
				Rx_Vehicle_Multiweapon(NewWeap).PrimaryReload();

			if(Rx_Vehicle_Multiweapon(NewWeap).CurrentAmmoInClip[1] <= 0)
				Rx_Vehicle_Multiweapon(NewWeap).SecondaryReload();
		}

		NewWeap.CallAmmoReplication();

    }

//  Seats[NewTurretIndex].Gun = MyWeap;
//  Seats[OldTurretIndex].Gun = None;

    TurretControllersList = Seats[OldTurretIndex].TurretControllers;
    Seats[OldTurretIndex].TurretControllers.Length = 0;

    foreach TurretControllersList(TC)
    {
    	TC.AssociatedSeatIndex = NewTurretIndex;
    	Seats[NewTurretIndex].TurretControllers.AddItem(TC);

    	//Reset Turret
    	TC.InitTurret(TC.BoneRotation + Rotation, Mesh);

		if(Role == ROLE_Authority)
		{
			SeatWeaponRotation(NewTurretIndex, Rotation, FALSE);
		}
    }

    if(NewTurretIndex > 0)
    {
	    if(Seats[NewTurretIndex].GunSocket.Length <= 0 && Seats[OldTurretIndex].GunSocket.Length > 0)
	    {
	    	Seats[NewTurretIndex].GunSocket = Seats[OldTurretIndex].GunSocket;
	    }
	    if(Seats[NewTurretIndex].MuzzleFlashLightClass == None && Seats[OldTurretIndex].MuzzleFlashLightClass != None)
	    {
	    	Seats[NewTurretIndex].MuzzleFlashLightClass = Seats[OldTurretIndex].MuzzleFlashLightClass;
	    }
	    if(Seats[NewTurretIndex].GunClass == None && Seats[OldTurretIndex].GunClass != None)
	    {
	    	Seats[NewTurretIndex].GunClass = Seats[OldTurretIndex].GunClass;
	    }
	}
	WeaponRotationChanged(NewTurretIndex);
}

simulated function bool bForceRotationonEntry(){return false;}

simulated function TickWeightResistance(float Deltatime)
{
	local SVehicleWheel S;

	ForEach Wheels(S)
	{
		if(!S.bWheelOnGround && UDKVehicleWheel(S).bConsiderForWeightResistance)
		{
			Mesh.AddImpulse(WeightResistance*DeltaTime, location + TransformVectorByRotation(rotation, S.WheelPosition));
		}
	}	
}

simulated function bool GetIsCollidingVehicle(optional bool bCheckAllDirections)
{
	local Rx_Vehicle RXV;
	local vector LeftFront, RightFront, RightBack, LeftBack;
	local vector HitVec, HitNorm;

	if(Throttle != 0)
		LastThrottle = Throttle; 
	//Use the throttle to determine if we're going forward or backward when being driven
	

	LeftFront = location+TransformVectorByRotation(rotation, PushCheckMax);
	LeftBack = location+TransformVectorByRotation(rotation, PushCheckMax-PushCheckVLength);

	RightFront = location+TransformVectorByRotation(rotation, PushCheckMax+PushCheckVWidth);
	RightBack = location+TransformVectorByRotation(rotation, (PushCheckMax+PushCheckVWidth)-PushCheckVLength);

	FlushPersistentDebugLines();
	//Use the throttle to determine if we're going forward or backward when being driven

	
	//Check our front side if things are still here
	if(bCheckAllDirections || bVCollisionFront)
	{
		bVCollisionFront = false; 
		foreach TraceActors(class'Rx_Vehicle', RXV, HitVec, HitNorm, LeftFront, RightFront, PushCheckExtent)
		{
			if(RXV != self && RXV != none)
			{
				bVCollisionFront = true; 
				break;
			}
		}
	}

	//Check our ass for colliders
	if(bCheckAllDirections || bVCollisionRear)
	{
		bVCollisionRear = false; 
		foreach TraceActors(class'Rx_Vehicle', RXV, HitVec, HitNorm, LeftBack, RightBack, PushCheckExtent)
		{
			if(RXV != self && RXV != none)
			{
				bVCollisionRear = true; 
				break;
			}
		}
	}

	//Check our left side for vehicle colliders
	if(bCheckAllDirections || bVCollisionLeft)
	{
		bVCollisionLeft = false; 
		foreach TraceActors(class'Rx_Vehicle', RXV, HitVec, HitNorm, LeftFront, LeftBack, PushCheckExtent)
		{
			if(RXV != self && RXV != none)
			{
				bVCollisionLeft = true; 
				break;
			}
		}
	}

	//Check our Right side for vehicle colliders
	if(bCheckAllDirections || bVCollisionRight)
	{
		bVCollisionRight = false; 
		foreach TraceActors(class'Rx_Vehicle', RXV, HitVec, HitNorm, RightFront, RightBack, PushCheckExtent)
		{
			if(RXV != self && RXV != none)
			{
				bVCollisionRight = true; 
				break;
			}
		}
	}

	//Any collision, return true
	 if( bVCollisionFront || bVCollisionRear || bVCollisionLeft || bVCollisionRight)
		return true;

	return false; 
}

simulated function SetCollisionSuppression(bool bSet)
{ 
	//Set to false initially. Will be true if in use at the end
	bUseLinearCollisionSupp = false;
	bUseLateralCollisionSupp = false;

	if(bSet)
	{
		//Linear collisions (Only cut torque if colliding in the direction we're going)
		if(bVCollisionFront || bVCollisionRear)
		{
			bUseLinearCollisionSupp = true; 
			SetWheelPushSlip(true);

			if(Controller != none)
				UpdateCutTorqueModifier(); 
				
		}
		else
		{
			UpdateCutTorqueModifier();
		}
		
		//Lateral collisions just resist rolling
		if(bVCollisionLeft || bVCollisionRight)
		{
			bUseLateralCollisionSupp = true; 
		}
	
		StayUprightConstraintInstance.SetAngularDOFLimitScale(PushingUprightResistPitchMult, PushingUprightResistRollMult, 1.0, StayUprightConstraintSetup);
		//SetUprightConstraintMultipliers(bUseLinearCollisionSupp ? PushingUprightResistPitchMult : 1.0, bUseLateralCollisionSupp ? PushingUprightResistRollMult : 1.0, bUseLateralCollisionSupp ? PushingUprightResistRollMult : 1.0);

		

		UpdateThrottleAndTorqueVars();
		SetTimer(0.2, false, 'ResetUseCollissionSuppression');
	}
	else
	{
		SetWheelPushSlip(false);
		CutTorqueModifier = default.CutTorqueModifier;
		StayUprightConstraintInstance.SetAngularDOFLimitScale(1.0, 1.0, 1.0, StayUprightConstraintSetup);

		if(Driver != none)
			SetUprightConstraintMultipliers(1.0, 1.0, 1.0);
		else
			SetUprightConstraintMultipliers(ParkedUprightResistPitchMult, ParkedUprightResistRollMult, 1.0);
		
		UpdateThrottleAndTorqueVars(); 
		SetSensitiveToRBCollision(); 
		SetTimer(2.0, false, 'SetInSensitiveToRBCollision');
		//ClearTimer('ResetUseCollissionSuppression');
	}
}

simulated function UpdateCutTorqueModifier()
{
	if(CutTorqueModifier == default.CutTorqueModifier) // We're default
	{
		if((bVCollisionFront && LastThrottle > 0) || (bVCollisionRear && LastThrottle < 0))
		{
			CutTorqueModifier = PushTorqueMult; 
			UpdateThrottleAndTorqueVars(); 
		}
	}
	else //It's set to something non-default already 
	{
		if((bVCollisionFront && LastThrottle < 0) || (bVCollisionRear && LastThrottle > 0) || (!bVCollisionFront && !bVCollisionRear))
		{
			CutTorqueModifier = default.CutTorqueModifier;
			UpdateThrottleAndTorqueVars(); 
		}
	}
}	

//Make an actual array to hold slip wheels so it doesn't always iterate through all wheels
simulated function SetWheelPushSlip(bool bSet)
{
	local SVehicleWheel S;
	local UDKVehicleWheel UDKWheel; 
	
	if(bSet)
	{
		ForEach Wheels(S)
		{
			UDKWheel= UDKVehicleWheel(S);
			if(UDKWheel.bSlipOnVehiclePush)
			{
				UDKWheel.LongSlipFactor = UDKWheel.default.VPushLongSlip;
				UDKWheel.LatSlipFactor = UDKWheel.default.VPushLatSlip; 
			}
		}
	}
	else 
	{
		ForEach Wheels(S)
		{
			UDKWheel= UDKVehicleWheel(S);
			if(UDKWheel.bSlipOnVehiclePush)
			{
				UDKWheel.LongSlipFactor = UDKWheel.default.LongSlipFactor;
				UDKWheel.LatSlipFactor = UDKWheel.default.LatSlipFactor; 
			}
		}
	}
	
}

simulated function SetUprightConstraintMultipliers(float inPitchResistMult, float inRollResistMult, float inTwistResistMult)
{
	StayUprightConstraintInstance.SetAngularDOFLimitScale(inPitchResistMult, inRollResistMult, inTwistResistMult, StayUprightConstraintSetup);
}

simulated function SetDriving(bool bNewDriving)
{
	if(bNewDriving == false)
		SetUprightConstraintMultipliers(ParkedUprightResistPitchMult, ParkedUprightResistRollMult, 1.0);
	else if(!IsTimerActive('ResetUseCollissionSuppression'))
	{
		SetUprightConstraintMultipliers(1.0, 1.0, 1.0);
	}

	super.SetDriving(bNewDriving);
}

simulated function SetSensitiveToRBCollision()
{
	Mesh.ScriptRigidBodyCollisionThreshold = 5.0;
}

simulated function SetInsensitiveToRBCollision()
{
	Mesh.ScriptRigidBodyCollisionThreshold = Mesh.default.ScriptRigidBodyCollisionThreshold;
}

simulated function PlayCollisionEffect(vector Loc, vector rot)
{
	if(WorldInfo.NetMode == NM_DedicatedServer)
		return; 

	WorldInfo.MyEmitterPool.SpawnEmitter(VehicleCollisionEffect, Loc, rotator(rot));
}

simulated function ResetPlayHeavyShift()
{
	bCanPlayHeavyShift = true; 
}

simulated function DrawPushDebug()
{
	local vector LeftFront, RightFront, RightBack, LeftBack;
	
	LeftFront = location+TransformVectorByRotation(rotation, PushCheckMax);
	LeftBack = location+TransformVectorByRotation(rotation, PushCheckMax-PushCheckVLength);

	RightFront = location+TransformVectorByRotation(rotation, PushCheckMax+PushCheckVWidth);
	RightBack = location+TransformVectorByRotation(rotation, (PushCheckMax+PushCheckVWidth)-PushCheckVLength);

	FlushPersistentDebugLines();

	//Uncomment this to only draw where the collisions are happening
	if(bVCollisionFront) DrawDebugLine(LeftFront, RightFront, 255, 0, 0, true);
	if(bVCollisionLeft) DrawDebugLine(LeftFront, LeftBack, 255, 255, 0, true);
	if(bVCollisionRear) DrawDebugLine(LeftBack, RightBack, 0, 255, 0, true);
	if(bVCollisionRight) DrawDebugLine(RightFront, RightBack, 0, 0, 255, true);

	return; 
	//Uncomment to always just draw the box all the way around when colliding
	if(Controller != none)
	{
		DrawDebugLine(LeftFront, RightFront, 255, 0, 0, true);
		DrawDebugLine(LeftFront, LeftBack, 255, 255, 0, true);
		DrawDebugLine(LeftBack, RightBack, 0, 255, 0, true);
		DrawDebugLine(RightFront, RightBack, 0, 0, 255, true);
	}
}

//Vehicle is trying to crush us
event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
	local Rx_Vehicle RXV;
	if(ROLE < ROLE_AUTHORITY || !default.bCrushable)
		return;

	RXV = Rx_Vehicle(Vehicle);

	if(RXV != None && RXV.bCanCrushVehicles && RXV.GetTeamNum() != LastTeamToUse && default.CrushTier < RXV.CrushTier) 
	{
		if(Vehicle.Controller != None)
			TakeDamage(10,Vehicle.Controller, Vehicle.Location, (Normal(Vehicle.Location - Location) * 50000), CrushedDamageType);
		else
			TakeDamage(10,Controller, Vehicle.Location, (Normal(Vehicle.Location - Location) * 50000), CrushedDamageType);
	}
	else
		super.OnRanOver(Vehicle,RunOverComponent,WheelIndex);
}

DefaultProperties
{
    FOVMultiplier=0.9
    FOVZoomedMultiplier=0.8
    FOVChangeRate=120.0
    EMPHealModifier=0.15
    bEMPDisablesVehicle=true

	bRotateCameraUnderVehicle = true
    
	MinSprintSpeedMultiplier=1.0
	MaxSprintSpeedMultiplier=1.2
	SprintTimeInterval=1.0
	SprintSpeedIncrement=1.0

	bCountTowardsVehicleLimit=true
   
   	RadarVisibility = 1

   	Begin Object Name=MyLightEnvironment
		MinTimeBetweenFullUpdates=0.1 	//Original Value is 1.0 meaning update once every second
		InvisibleUpdateTime=2.0 		//Original Value is 5.0 meaning update one every 5 seconds
	End Object
	LightEnvironment=MyLightEnvironment
   
	Begin Object name=SVehicleMesh
		ScriptRigidBodyCollisionThreshold=100.0
		RBCollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=False,GameplayPhysics=True,EffectPhysics=True,Untitled1=False,Untitled2=True,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=True,DeadPawn=True,Clothing=False,ClothingCollision=False)
	End Object

    Begin Object Class=SkeletalMeshComponent Name=SDevFlag
        SkeletalMesh=SkeletalMesh'RX_Deco_Flag.banner.Mesh.SK_Flag_WarBanner'
        bEnableClothSimulation=false
        bClothAwakeOnStartup=false
        bClothWindRelativeToOwner=true
        ClothWind=(X=10,Y=-50,Z=-10)
        //Rotation=(Yaw=49152)
        LightEnvironment = MyLightEnvironment
        HiddenGame=true
        HiddenEditor=true
		bAutoFreezeClothWhenNotRendered=true
    End Object
    Components.Add(SDevFlag)
    DevFlag=SDevFlag
	
	fpCameraTag[0] = CamView1P
	tpCameraTag[0] = CamView3P
	fpCamera = false
	LinkHealMult = 1
	Begin Object Name=CollisionCylinder
		CollisionHeight=50.0
		CollisionRadius=140.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
		RBCollideWithChannels=(Default=True,Nothing=False,Pawn=True,Vehicle=True,Water=False,GameplayPhysics=True,EffectPhysics=True,Untitled1=False,Untitled2=True,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=True,DeadPawn=True,Clothing=False,ClothingCollision=False)
	End Object
	CylinderComponent=CollisionCylinder
	
	Begin Object Class=ParticleSystemComponent Name=EMPParticleComp
		bAutoActivate=false
		Template=ParticleSystem'Pickups.Deployables.Effects.P_Deployables_EMP_Mine_VehicleDisabled'
	End Object
	Components.Add(EMPParticleComp)
	EMPParticleComponent=EMPParticleComp

	Begin Object Class=AudioComponent Name=EMPSoundComp
        SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_EMPLoop'
    End Object
    EMPSound=EMPSoundComp
    Components.Add(EMPSoundComp);
	
	Begin Object Class=Rx_AudioComponent Name=InitVoice
		bUseOwnerLocation = true
		bStopWhenOwnerDestroyed = true
		SoundCue = SoundCue'RX_CharSnd_Generic.gdi_male.Pawn_Voice'
	End Object
	
	VoiceComponent=InitVoice
	Components.Add(InitVoice); 

	bCanStrafe=false
	AIPurpose = AIP_Any
	
	bHomingTarget=false
	bOverrideAVRiLLocks=false
	bReverseSteeringInverted = true
	
	TeamBought=255
	LastTeamToUse=255
	bTeamLocked=false
	bEnteringUnlocks=true
	bEjectPassengersWhenFlipped=true
	bUsesBullets = false
	bOkAgainstBuildings=true
	bBindable=true
	TimeLastOccupied=-1
	ReservationLength=30

	DamageSmokeThreshold=0.25
	FireDamageThreshold=0.20
	FireDamagePerSec=0.0

	CollisionDamageMult=0.0
	WaterDamage=200.0
	UpsideDownDamagePerSec=200.0
	OccupiedUpsideDownDamagePerSec=200.0

	RespawnTime=10.0
	SpawnInTime=1.0
	SpawnRadius=200.0
	BurnOutTime=0.0
	DeadVehicleLifeSpan=1.0
	BurnTimeParameterName=BurnTime

	SpawnInSound = None
	SpawnOutSound = None
    SuspensionShiftSound= SoundCue'RX_SoundEffects.Vehicle.SC_VehicleCompress'

	ExplosionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Explode'
	CollisionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Collision'
	VehicleCollisionEffect=ParticleSystem'RX_FX_Vehicle.Damage.P_Vehicle_Impact_Metal'
	
	SprintBoostSound = None
	SprintStopSound = None

	ExplosionDamage=0
	ExplosionRadius=1

	RanOverDamageType=class'Rx_DmgType_RanOver'
	CrushedDamageType=class'Rx_DmgType_Pancake'

	EMPTime=1.0 //6.0 //9.0//11 //(Now added to based on distance)
	EMPDamage=2 //1
	EMPDmgType=class'Rx_DmgType_EMPGrenade'

	CameraLag=0.3
	ViewPitchMin=-15000
	MinCameraDistSq=1.0
	DefaultFOV=81 //obsolete
	ZoomedFOV=72 //obsolete
	bNoZSmoothing=False
	CameraSmoothingFactor=2.0

	HealPointsScale   = 0.05f // means 0.05 points per healed healthpoint
	DamagePointsScale = 0.1f
	PointsForDestruction = 10.0f

	bStayUpright=true
	StayUprightRollResistAngle=40.0		// 20.0
	StayUprightPitchResistAngle=50.5	// 25.0
	StayUprightStiffness=2000			// 2000
	StayUprightDamping=2000				// 2000

	// The lower these numbers, the harder it is for another rigid body to Pitch/Twist this vehicle when pushing it
	PushingUprightResistPitchMult = 0.5 
	PushingUprightResistRollMult = 0.5

	ParkedUprightResistPitchMult = 0.25
	ParkedUprightResistRollMult = 0.25

	
	BrakeLightParameterName=BreakLights
	ReverseLightParameterName=ReverseLights
	HeadLightParameterName=Headlights
	
	DrivingAnim=H_M_Seat_Apache

	VehicleIconTexture=Texture2D'RenxHud.T_VehicleIcon_MissingCameo'

	// Seeking modifiers. Higher values mean seeking rockets can track this vehicle better
	SeekAimAheadModifier = 0.0
	SeekAccelrateModifier = 0.0
	
	ReducedThrottleForTurning = 0.7
	SpeedAtWhichToApplyReducedTurningThrottle = 340
	SkeletalMeshForPT=SkeletalMesh'RX_VH_MediumTank.Mesh.SK_VH_MediumTank'
	
	WheelParticleEffects.Empty
	WheelParticleEffects[0]=(MaterialType=Generic,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
    WheelParticleEffects[1]=(MaterialType=Dirt,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt')
	WheelParticleEffects[2]=(MaterialType=Grass,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt')
    WheelParticleEffects[3]=(MaterialType=Water,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Water')
    WheelParticleEffects[4]=(MaterialType=Snow,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Snow')
	WheelParticleEffects[5]=(MaterialType=Concrete,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[6]=(MaterialType=Metal,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[7]=(MaterialType=Stone,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Stone')
	WheelParticleEffects[8]=(MaterialType=WhiteSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_WhiteSand')
	WheelParticleEffects[9]=(MaterialType=YellowSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_YellowSand')
	DefaultWheelPSCTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt'
	
	/*Veterancy */
	VRank=0

	bCanCapture=true

	SpotLocation = "NULL"
	SpotUpdateTime = 1.0 //Seconds
	
	/***********/
	/*Vehicle Veterancy Block*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SprintSpeedMod = Base Sprint Speed multiplied by this
	//TTFD = Turn Torque Factor (Keeps vehicles from turning too hard when their sprint speed increases)

	//RECRUIT
	VetRankInfo(0) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(1) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(2) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//VETERAN
	VetRankInfo(3) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(4) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(5) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//ELITE
	VetRankInfo(6) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(7) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(8) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//HEROIC
	VetRankInfo(9) = (VPReward = 2, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	
	/******************/
	
	RegenerationRate = 1
	HeroicRegenerationRate = 3 
	bHijackBonus = true
	bAlwaysRegenerate = false 
	bCanBePromoted = true  
	UISymbol = 0
	MaxDR = 0.1 //Maximumum of 90% damage resistance
	bHasPlayerEntered = false
	
	BarrelLength(0)=200
	BarrelLength(1)=200
	BarrelLength(2)=200
	BarrelLength(3)=200
	BarrelLength(4)=200
	BarrelLength(5)=200
	
	bPickedUp=false //When replicated, tells the client that the vehicle is being lifted
	
	bAlwaysRelevant = true

	CustomVehicleName = "" //The HUD will use this if it does not == "". This should only be used by mods/mutators.
	
	DeathImpulseStrength = 8000 //16000

	bCameraNeverHidesVehicle=true
	bCanCarryHeavies=false
	CutTorqueModifier = 1.0
	PushTorqueMult = 0.25
	
	bUsesCollisionSuppression = true
	PushCheckMax = (X=0,Y=0,Z=0)
	PushCheckVWidth = (X=0,Y=0,Z=0)
	PushCheckVLength = (X=0,Y=0,Z=0)
	PushCheckExtent = (X=0,Y=0,Z=10)
	bDrawCollisionDebug = false

	bCanPlayHeavyShift = true; 

	bCrushable = true
	bCanCrushVehicles = false 
	CrushTier = 10 //Capable of crushing vehicles that are beneath this tier if bCanCrushVehicles is true

	NetUpdateFrequency=120

	bUseParkingBrake = true;
	//DEPRACATED
	PushCheckDistanceFront = 300 //How far out to start the trace for a push check (Should be front of the vehicle, not including the barrel/turret or anything)
	PushCheckDistanceRear = 300 
	PushCheckRadius = 200
	HornDelay = 3.0 
}