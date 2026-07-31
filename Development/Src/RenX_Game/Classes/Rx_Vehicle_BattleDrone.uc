/*********************************************************
*
* File: Rx_Vehicle_BattleDrone.uc
* Author: Totem Arts Team
* Poject: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_BattleDrone extends Rx_Vehicle_Air
    placeable;

/** Firing sounds */
var() AudioComponent FiringAmbient;
var() SoundCue FiringStopSound;
var() SoundCue Snd_FiringAmbient_Heroic;
var   SoundCue RepairSound; 

var() AudioComponent  MainRotorAmbient;	// The looping sound for the Main rotor

var name GunCameraTag;

var UTPawn DummyDriver;
var Rx_Bot_LeashedDrone LeashController;
var Actor myHostingActor;
var repnotify byte SparkIterator; 

replication
{
    if(bNetDirty)
        SparkIterator;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'SparkIterator')
    {
        VehicleEvent('Repair');
    }
    else
        super.ReplicatedEvent(VarName); 
}

function InitializeDrone(Actor DroneHost, PlayerReplicationInfo PRI, byte NewTeamNum)
{
    local Rx_Bot_LeashedDrone BotAI;
    local Rx_Vehicle VehicleHost;
    local vector tv;
    
    Instigator = self;
    Weapon = Seats[0].Gun;

    myHostingActor = DroneHost;
    VehicleHost = Rx_Vehicle(DroneHost);

    /**
    if (Seats[0].Gun != none)
    {
        InvManager.SetCurrentWeapon(MainWeapon);
    }*/

    BotAI = Spawn(class'Rx_Bot_LeashedDrone', , 'MyDrone', location + vect(0,0,2000),,,true);

    if(BotAI != none)
    {   
        if(VehicleHost !=none)
        {
            //We're good to give ourselves a dummy driver 
            tv = location;
            tv.z += 60;
            tv.x += 50;
            DummyDriver = Spawn(class'UTPawn',,,tv,,,true);
            BotAI.Possess(DummyDriver,true);
            DriverEnter(DummyDriver);
        }   

        BotAI.InitDroneAI('Repair', myHostingActor, PRI); 
        SetTeamNum(NewTeamNum);
        BotAI.SetTeam(NewTeamNum);

        SetLeashedController(BotAI);
    }
}

function HostChangedTeam(PlayerReplicationInfo NewPRI, byte NewTeamNum)
{
    SetTeamNum(NewTeamNum);

    if(LeashController != none)
    {
        LeashController.SetOwnerPRI(NewPRI);
    }
}

function bool TryToDrive(Pawn P)
{
    if(Rx_Controller(P.Controller) != None || Rx_Bot(P.Controller) != None)
    	return false;
    
    return Super.TryToDrive(P);
}

function bool BotFire(bool bFinished)
{
	StartFire(ChooseFireMode());
	return true;
}

function byte ChooseFireMode()
{
	if (UDKWeapon(Weapon) != None)
	{
		return UDKWeapon(Weapon).BestMode();
	}
	return 0;
}

simulated event PostBeginPlay()
{	
    Super.PostBeginPlay();
}

function PancakeOther(Pawn Other)
{
    return;
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
    if (SeatFiringMode(SeatIndex,,true) == 0)
	{
		VehicleEvent('GunFire');

		if (!FiringAmbient.bWasPlaying)
		{
			FiringAmbient.Play();
		}
	}
    else
        VehicleEvent('Repair');
}
    
simulated function VehicleWeaponFired( bool bViaReplication, vector HitLocation, int SeatIndex )
{
    super.VehicleWeaponFired(bViaReplication,HitLocation,SeatIndex);
}

simulated function VehicleWeaponStoppedFiring( bool bViaReplication, int SeatIndex )
{        
    super.VehicleWeaponStoppedFiring(bViaReplication,SeatIndex);
    
    // Trigger any vehicle Firing Effects
    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if (Role == ROLE_Authority || bViaReplication || WorldInfo.NetMode == NM_Client)
        {
            VehicleEvent('STOP_GunFire');
        }
    }

    if (SeatFiringMode(SeatIndex,,true) == 0)
	{
		PlaySound(FiringStopSound, TRUE, FALSE, FALSE, Location, FALSE);
	}
	
    FiringAmbient.Stop();
}

simulated function SetHeroicMuzzleFlash(bool SetTrue)
 {
	if(SetTrue) FiringAmbient.SoundCue=Snd_FiringAmbient_Heroic;
	else
	FiringAmbient.SoundCue=FiringAmbient.default.SoundCue; 
	super.SetHeroicMuzzleFlash(SetTrue);
}

simulated function bool CanEnterVehicle(Pawn P)
{
	if (p.Controller.bIsPlayer || p.IsA('Rx_Pawn'))
		return false;

	return super.CanEnterVehicle(P);
}

simulated function PlayRepairEffects()
{
    if(ROLE == ROLE_AUTHORITY)
    {
        PlaySound(RepairSound,false,false,true,location, false);
        
        if(SparkIterator < 10)
            SparkIterator+=1; 
        else
            SparkIterator=0;  
    }
        
    
    if(WorldInfo.NetMode == NM_Standalone)
        VehicleEvent('Repair');
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if(Controller != none)
    {
        if(LeashController != none)
        {
            LeashController.DroneDestroyed();
            LeashController.UnPossess();
            LeashController = none; 
            
        }
        else 
            Controller.UnPossess();
    }
		
	return super.Died(Killer,DamageType,HitLocation);
}

simulated function byte GetTeamNum()
{
     if(LeashController != none && Rx_Vehicle(LeashController.HostingActor) != none)
     {
        return Rx_Vehicle(LeashController.HostingActor).LastTeamToUse; 
     }
    else
        return super.GetTeamNum();
}

function SetLeashedController(Rx_Bot_LeashedDrone NewController)
{
    LeashController = NewController;

    if(Weapon == none && MainWeapon != none)
        InvManager.SetCurrentWeapon(MainWeapon);
}

simulated function bool DriverEnter(Pawn P)
{
	if(p.IsA('Rx_Pawn')) {
		return false;
	} 

	P.StopFiring();

    Instigator = self;
    Weapon = Seats[0].Gun;
	if (Seats[0].Gun != none)
	{
		InvManager.SetCurrentWeapon(MainWeapon);
	}

    return super.DriverEnter(P);
}

event bool ContinueOnFoot()
{
	return false; // overriden to prevent AI from leaving the harvester
}

event bool DriverLeave(bool bForceLeave)
{
	local bool bLeft;

	bLeft = Super.DriverLeave(bForceLeave);

	if(bLeft && Health > 0)
	{
		BlowupVehicle();
	}

	return bLeft;
}

event RanInto( Actor Other )
{	
	if(Other == DummyDriver)
		return;
    Super.RanInto(Other);
}

simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return false;}
simulated function string GetInteractText(Controller C, string BindKey) {return "";}

defaultproperties
{
    RepairSound = SoundCue'RX_VH_BattleDrone.Sounds.SC_BattleDrone_Repair'
    bAlwaysRelevant=true
    bReplicateInstigator = true
    bCanBeBaseForPawns = false

    MaxDesireability = 0.8 // todo: reactivate when flying AI is fixed

    MinRunOverSpeed 	= 99999.0f

    ExitRadius=150.0
    
    fpCameraTag[0]=CamView1P

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\

    Begin Object Class=UDKVehicleSimChopper Name=SimObject
        MaxThrustForce=15.0
        MaxReverseForce=15.0 
        LongDamping=0.1
        MaxStrafeForce=15.0
        LatDamping=0.1
        MaxRiseForce=20.0
        UpDamping=0.1
        TurnTorqueFactor=20.0
        TurnTorqueMax=10.0
        TurnDamping=0.01
        MaxYawRate=2.0
        PitchTorqueFactor=5.0
        PitchTorqueMax=5.0
        PitchDamping=0.01
        RollTorqueTurnFactor=15.0
        RollTorqueStrafeFactor=15.0    // 10000.01
        RollTorqueMax=10.0
        RollDamping=0.01
        MaxRandForce=1
        RandForceInterval=1.0
        StopThreshold=0
        bAllowZThrust=False
        bFullThrustOnDirectionChange=False
        bShouldCutThrustMaxOnImpact=true
        bStabilizeStops=false
        StabilizationForceMultiplier=0.05
    End Object
    SimObj=SimObject
    Components.Add(SimObject)
    
	DestroyedRotatorAddend = (Pitch=0,Roll=0,Yaw=16364)
	DestroyedImpulseOffset = 600 
	bStayUprightOnDeath = false
	
    Health=400
    bLightArmor=false
	bisAirCraft=true

	/************************/
	/*Veterancy Multipliers*/
	/***********************/
	
	Snd_FiringAmbient_Heroic = SoundCue'RX_VH_Buggy.Sounds.SC_Buggy_Fire_Loop'
	
    /***********/
	/*Vehicle Veterancy Block*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SprintSpeedMod = Base Sprint Speed multiplied by this
	//TTFD = Turn Torque Factor (Keeps vehicles from turning too hard when their sprint speed increases)

	//RECRUIT
	VetRankInfo(0) = (VPReward = 1, HealthMod = 1.0, SprintspeedMod = 1.0) 
	VetRankInfo(1) = (VPReward = 1, HealthMod = 1.025, SprintspeedMod = 1.0) 
	VetRankInfo(2) = (VPReward = 1, HealthMod = 1.065, SprintspeedMod = 1.0) 

	//VETERAN
	VetRankInfo(3) = (VPReward = 1, HealthMod = 1.125, SprintspeedMod = 1.05) 
	VetRankInfo(4) = (VPReward = 1, HealthMod = 1.15, SprintspeedMod = 1.05) 
	VetRankInfo(5) = (VPReward = 1, HealthMod = 1.19, SprintspeedMod = 1.05) 

	//ELITE
	VetRankInfo(6) = (VPReward = 1, HealthMod = 1.25, SprintspeedMod = 1.10) 
	VetRankInfo(7) = (VPReward = 1, HealthMod = 1.325, SprintspeedMod = 1.10) 
	VetRankInfo(8) = (VPReward = 1, HealthMod = 1.375, SprintspeedMod = 1.10) 

	//HEROIC
	VetRankInfo(9) = (VPReward = 1, HealthMod = 1.5, SprintspeedMod = 1.15) 
	
	/******************/

//========================================================\\

    bFollowLookDir=false
    
    COMOffset=(X=0,Z=0)

    BaseEyeheight=30
    Eyeheight=30
    bRotateCameraUnderVehicle=true
    CameraLag=0.1 //0.4
    LookForwardDist=100
    bLimitCameraZLookingUp=true

    AirSpeed=1750.0
    MaxSpeed=1750.0
    GroundSpeed=1750.0

    UprightLiftStrength=30.0
    UprightTorqueStrength=30.0

    bStayUpright=true
    StayUprightRollResistAngle=5.0
    StayUprightPitchResistAngle=5.0
    StayUprightStiffness=200.0
    StayUprightDamping=2

    SpawnRadius=180.0
    RespawnTime=5.0

    PushForce=50.0
    HUDExtent=140.0

    HornIndex=0
	
	bIsConsoleTurning=False
	bJostleWhileDriving=True
	
	SeekAimAheadModifier = 120
	SeekAccelrateModifier = 4


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\

    Begin Object Name=CollisionCylinder
        CollisionHeight=+100.0
        CollisionRadius=+150.0
        Translation=(X=-40.0,Y=0.0,Z=40.0)
    End Object

    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_VH_BattleDrone.Mesh.SK_VH_BattleDrone'
        AnimTreeTemplate=AnimTree'RX_VH_BattleDrone.Anims.AT_VH_BattleDrone'
        PhysicsAsset=PhysicsAsset'RX_VH_BattleDrone.Mesh.PhysAss_BattleDrone'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_BattleDrone.Mesh.SK_VH_BattleDrone'


//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\
	Seats(0)={( GunClass=class'Rx_Vehicle_BattleDrone_Weapon',
                GunSocket=("Fire01"),
                TurretControls=(TurretPitch,TurretRotate),
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=25),
                CameraOffset=-400,
                SeatRotation=(Pitch=0,Yaw=0),
                MuzzleFlashLightClass=class'RenX_Game.Rx_Light_Tank_MuzzleFlash'
                )}

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\

    DrivingPhysicalMaterial=none
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_BattleDrone.Materials.PhysMat_BattleDrone'

    RecoilTriggerTag = "GunFire"
    VehicleEffects(0)=(EffectStartTag="GunFire",EffectTemplate=ParticleSystem'RX_VH_Apache.Effects.P_MuzzleFlash_Gun',EffectSocket="Fire01")
    VehicleEffects(1)=(EffectStartTag="Repair",EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Vehicle_Impact_Metal',EffectSocket="Fire01")
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Apache.Effects.P_EngineFire',EffectSocket=DamageSmoke01)

//    ContrailEffectIndices=(2,3,4,5,13,14)
//    GroundEffectIndices=(7,8)

//    ReferenceMovementMesh=StaticMesh'RX_VH_Chinook.Mesh.S_Air_Wind_Ball'

	BigExplosionTemplates[0]=(Template=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Air')
	BigExplosionSocket=VH_Death
	SecondaryExplosion=none
	
    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)


//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\

    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RX_VH_Apache.Sounds.SC_TailRotor_Idle'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);

    EnterVehicleSound=SoundCue'RX_VH_Apache.Sounds.SC_TailRotor_Start'
    ExitVehicleSound=SoundCue'RX_VH_Apache.Sounds.SC_TailRotor_Stop'
	
	Begin Object Class=AudioComponent name=FiringmbientSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'RX_VH_BattleDrone.Sounds.SC_BattleDrone_Gun_Loop'
    End Object
    FiringAmbient=FiringmbientSoundComponent
    Components.Add(FiringmbientSoundComponent)
    
    FiringStopSound=SoundCue'RX_VH_Buggy.Sounds.SC_Buggy_Fire_Stop'
	
    // Initialize sound parameters.
    EngineStartOffsetSecs=2.54
    EngineStopOffsetSecs=0.0
	
	VehicleIconTexture=Texture2D'RX_VH_Apache.UI.T_VehicleIcon_Apache'
	MinimapIconTexture=Texture2D'RX_VH_Apache.UI.T_MinimapIcon_Apache'

    UIString="Battle Drone"
}