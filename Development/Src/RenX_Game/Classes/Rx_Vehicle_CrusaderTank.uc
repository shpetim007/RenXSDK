/*********************************************************
*
* File: Rx_Vehicle_MediumTank.uc
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
class Rx_Vehicle_CrusaderTank extends Rx_Vehicle_Treaded
    dependson(Rx_Bot_LeashedDrone)
    implements(RxIfc_DroneHost)
    placeable;
	
var SkeletalMeshComponent AntennaMeshL;
var SkeletalMeshComponent AntennaMeshR;

/** Firing sounds */
var() AudioComponent FiringAmbient;
var() SoundCue FiringStopSound;
var repnotify bool bPlayingAmbientFireSound; 

/** The Cantilever Beam that is the Antenna itself*/
var UTSkelControl_CantileverBeam AntennaBeamControl;
var Rx_Vehicle_BattleDrone  MyDrone; 
var float DroneRebuildTime; 
var float LastTookDamageTime; 
var bool bInitialDroneConstructed;
var bool bCanTeleportDrone;

replication
{
    if (bNetDirty && !bNetOwner)
		bPlayingAmbientFireSound;
    if(bNetDirty && bNetOwner)
        bCanTeleportDrone; 
}

simulated event ReplicatedEvent(Name VarName)
{
    if (VarName == 'bPlayingAmbientFireSound')
	{
		if(bPlayingAmbientFireSound)
			FiringAmbient.Play();
		else
		{
			FiringAmbient.Stop();
		}
	}
    else 
		super.ReplicatedEvent(VarName);
}

/** This bit here will attach all of the seperate antennas and towing rings that jiggle about when the vehicle moves **/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

    Mesh.AttachComponentToSocket(FlagAmbient, 'AntennaSocket_R');

	Mesh.AttachComponentToSocket(AntennaMeshL,'AntennaSocket_L');
	Mesh.AttachComponentToSocket(AntennaMeshR,'AntennaSocket_R');

	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshL.FindSkelControl('Beam'));
	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshR.FindSkelControl('Beam'));

	if (AntennaBeamControl != none)
	{
		AntennaBeamControl.EntireBeamVelocity = GetVelocity;
	}
}

simulated function vector GetEffectLocation(int SeatIndex)
{

    local vector SocketLocation;
    local name FireTriggerTag;

    if (Seats[SeatIndex].GunSocket.Length <= 0)
        return Location;

    //`Log("GetEffectLocation called",, '_Mammoth_Debug');
    
    FireTriggerTag = Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)];
    
    Mesh.GetSocketWorldLocationAndRotation(FireTriggerTag, SocketLocation);
    
     //if (Weapon.CurrentFireMode == 0)
     //   ShotCount = ShotCounts >= 255 ? 0 : ShotCounts + 1;
    //  else
    //     AltShotCounts = AltShotCounts >= 255 ? 0 : AltShotCounts + 1;
    return SocketLocation;
}

// special for mammoth
simulated event GetBarrelLocationAndRotation(int SeatIndex, out vector SocketLocation, optional out rotator SocketRotation)
{
    if (Seats[SeatIndex].GunSocket.Length > 0)
    {
        Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)], SocketLocation, SocketRotation);
    }
    else
    {
        SocketLocation = Location;
        SocketRotation = Rotation;
    }
}

simulated function int GetBarrelIndex(int SeatIndex)
{
    local int OldBarrelIndex;
    
    OldBarrelIndex = super.GetBarrelIndex(SeatIndex);
    if (MainWeapon == none)
        return OldBarrelIndex;

    return (MainWeapon.CurrentFireMode == 0 ? OldBarrelIndex % 1 : (OldBarrelIndex % 1) + 1);
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

	if((SeatIndex == 1 && Seats[SeatIndex].SeatPawn.FiringMode == 1) || (MainWeapon != none && MainWeapon.CurrentFireMode == 1))
	{
		if (!FiringAmbient.bWasPlaying)
		{
			FiringAmbient.Play();
			VehicleEvent('FireSecondary');
		}
	}
}

simulated function VehicleWeaponFired( bool bViaReplication, vector HitLocation, int SeatIndex )
{
    super.VehicleWeaponFired(bViaReplication,HitLocation,SeatIndex);
	
	if(ROLE == ROLE_Authority && Seats[SeatIndex].Gun.CurrentFireMode == 1)
	{
		bPlayingAmbientFireSound = true; 
	}
}

simulated function VehicleWeaponStoppedFiring( bool bViaReplication, int SeatIndex )
{
    super.VehicleWeaponStoppedFiring(bViaReplication,SeatIndex);
    
    // Trigger any vehicle Firing Effects
    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if (Role == ROLE_Authority || bViaReplication || WorldInfo.NetMode == NM_Client)
        {
            VehicleEvent('STOP_FireSecondary');
        }
    }
	if(Seats[SeatIndex].Gun != none && Seats[SeatIndex].Gun.CurrentFireMode == 1)
	{
		PlaySound(FiringStopSound, TRUE, FALSE, FALSE, Location, FALSE);
		FiringAmbient.Stop();
	}
	
	if(ROLE == ROLE_Authority && Seats[SeatIndex].Gun.CurrentFireMode == 1)
	{
		bPlayingAmbientFireSound = false; 
	}
}
	
reliable server function ConstructBattleDrone()
{
    local vector DroneLoc; 
    local rotator DroneRot;
    
    if(PlayerReplicationInfo == none || MyDrone != none)
        return;

    Mesh.GetSocketWorldLocationAndRotation('DroneDoorSocket', DroneLoc, DroneRot);

	MyDrone = Spawn(class'Rx_Vehicle_BattleDrone', , 'MyDrone', DroneLoc + vect(0,0,50), DroneRot);

	if(MyDrone != none)
	{
        //MyDrone.InitializeSeats();
        MyDrone.InitializeDrone(self, PlayerReplicationInfo, LastTeamToUse);
        MyDrone.Rise = 1.0; //LAUNCH
        MyDrone.PromoteUnit(VRank);

        if(!bInitialDroneConstructed)
            bInitialDroneConstructed = true;

        bCanTeleportDrone = true; 
	}
}

simulated function OpenHatch()
{
    SetHatchStatus(true);
    SetTimer(2.0, false, 'CloseHatch');//Makes no sense to stay open
}

simulated function CloseHatch()
{
    SetHatchStatus(false);
}

function bool DriverEnter(Pawn P)
{
    if(super.DriverEnter(P))
    {
        if(MyDrone == none)
        {
            SetTimer(bInitialDroneConstructed ? DroneRebuildTime : 3.0, false, 'DoDroneBuild');
            SetTimer(3.0,true,'EvaluateDroneStance');
        }
        else if (MyDrone != none && MyDrone.PlayerReplicationInfo != PlayerReplicationInfo)
        {
            SetDronePRI(PlayerReplicationInfo); 
        }
        
        return true; 
    }
    return false; 
}

/**
Called from the Controller when player wants to get out. */
event bool DriverLeave( bool bForceLeave )
{
    ClearTimer('DoDroneBuild');
    if(IsTimerActive('ConstructBattleDrone'))
    {
        ClearTimer('ConstructBattleDrone');
    }
        
    if(MyDrone != none)
    {
        SetDroneStance(BR_REPAIR);
        SetDronePRI(none);
        
    }

    return super.DriverLeave(bForceLeave) ;
}

function SetDronePRI(PlayerReplicationInfo PRI)
{
    if(MyDrone != none)
    {
        MyDrone.HostChangedTeam(PRI, GetTeamNum());
    }
}

function bool GetHasDrone() {return MyDrone != none;} 

simulated function NotifyDroneDestroyed()
{
    MyDrone = none; 
    bCanTeleportDrone = false;
    SetTimer(DroneRebuildTime, false, 'DoDroneBuild');
}

//0: Repair. Everything else is whatever
function BattleRole GetDroneStance()
{
    if(MyDrone != none && MyDrone.Controller != none)
        return Rx_Bot_LeashedDrone(MyDrone.Controller).DroneProtocol;
}

//0: Repair 
//1: Attack Stance
function SetDroneStance(BattleRole NewStance)
{
    if(MyDrone != none && MyDrone.Controller != none)
        Rx_Bot_LeashedDrone(MyDrone.Controller).SetProtocol(NewStance);
}

simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(Damage,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser); 
    
    LastTookDamageTime = WorldInfo.TimeSeconds; 

    if(Driver != none && Health > 0 && GetHasDrone() && GetDroneStance() == BR_REPAIR)
    {
        SetDroneStance(BR_FIGHTER); 
    }
}

function EvaluateDroneStance()
{
    if(MyDrone == none)
        return; 

    if(Driver == none)
    {
        SetDroneStance(BR_GUARD);
        return; 
    }
    //Currently in repair mode?
    if(GetDroneStance() == BR_REPAIR) 
    {
        if(Health >= HealthMax && (MyDrone.GetStateName() != 'Engaging'))
        {
            SetDroneStance(BR_FIGHTER);  
        }
    }
    else
    {
         if(Health < HealthMax && (WorldInfo.TimeSeconds - LastTookDamageTime >= 8.0) && (MyDrone.GetStateName() != 'Engaging'))
         {
            SetDroneStance(BR_REPAIR);  
         }
    }
}

unreliable client function SetHatchStatus(bool bOpen)
{
	if(bOpen)
    {
        VehicleEvent('OpenHatch');
    }
    else
    {
        VehicleEvent('CloseHatch');
    }
        
}

function PromoteUnit(byte rank, optional bool bInitial) //Promotion depends mostly on the unit. All units gain health however [was simulated]
{
    super.PromoteUnit(rank, bInitial);
    if(MyDrone != none)
        MyDrone.PromoteUnit(rank);
}

simulated function DoDroneBuild()
{
    OpenHatch();
    SetTimer(1.5, false, 'ConstructBattleDrone');
}

reliable server function TeleportDroneToSelf()
{
    local vector DroneLoc; 
    local rotator DroneRot;

    if(ROLE != ROLE_AUTHORITY)
        return; 

    if(bCanTeleportDrone && MyDrone != none && MyDrone.Health > 0)
    {
        Mesh.GetSocketWorldLocationAndRotation('DroneDoorSocket', DroneLoc, DroneRot);
        MyDrone.Mesh.SetRBPosition(DroneLoc+vect(0,0,100)); 
        MyDrone.Mesh.SetRBRotation(DroneRot);
        bCanTeleportDrone = false;
        SetTimer(15.0,false,'ResetCanTeleportDrone');
    }
}

simulated function bool TryTeleportDroneToSelf()
{
    if(bCanTeleportDrone)
    {
        TeleportDroneToSelf(); 
        return true;
    }

    return false; 
}

function ResetCanTeleportDrone()
{
    bCanTeleportDrone = true; 
}

DefaultProperties
{

    DroneRebuildTime = 30.0
    bCanTeleportDrone = true; 
    Begin Object Name=CollisionCylinder
    CollisionHeight=75.0
    CollisionRadius=200.0
    Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object
	

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\

    bRotateCameraUnderVehicle=true
    bSecondaryFireTogglesFirstPerson=false
    Health=1000
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=True
    bSeparateTurretFocus=True
    CameraLag=0.15 //0.4
    LookForwardDist=350
    GroundSpeed=300
    MaxSpeed=1000
    LeftStickDirDeadZone=0.1
    TurnTime=18
    ViewPitchMin=-13000
    HornIndex=0
    COMOffset=(x=21.0,y=0.0,z=-42.0)
	
	SprintTrackTorqueFactorDivident=1.05
	
	Heroic_MuzzleFlash=ParticleSystem'RX_VH_MediumTank.Effects.MuzzleFlash_Heroic'
	
	BarrelLength(0)=450
	BarrelLength(1)=100
	BarrelLength(2)=100
	BarrelLength(3)=100
	BarrelLength(4)=100
	BarrelLength(5)=100


    /***********/
	/*Vehicle Veterancy Block*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SprintSpeedMod = Base Sprint Speed multiplied by this
	//TTFD = Turn Torque Factor (Keeps vehicles from turning too hard when their sprint speed increases)

	//RECRUIT
	VetRankInfo(0) = (VPReward = 8, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(1) = (VPReward = 8, HealthMod = 1.025, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(2) = (VPReward = 8, HealthMod = 1.065, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//VETERAN
	VetRankInfo(3) = (VPReward = 10, HealthMod = 1.125, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(4) = (VPReward = 10, HealthMod = 1.15, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(5) = (VPReward = 10, HealthMod = 1.19, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//ELITE
	VetRankInfo(6) = (VPReward = 12, HealthMod = 1.25, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 
	VetRankInfo(7) = (VPReward = 12, HealthMod = 1.275, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 
	VetRankInfo(8) = (VPReward = 12, HealthMod = 1.315, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 

	//HEROIC
	VetRankInfo(9) = (VPReward = 16, HealthMod = 1.375, SprintspeedMod = 1.10, SprintTTFDMod = 0.15) 
	
	/******************/
	
    Begin Object Class=SVehicleSimTank Name=SimObject

        bClampedFrictionModel=true

        WheelSuspensionStiffness=550//60.0 //40
        WheelSuspensionDamping=50.0 //2.0
        WheelSuspensionBias=0.20

//        WheelLongExtremumSlip=0
//        WheelLongExtremumValue=20
//        WheelLatExtremumValue=4

        // Longitudinal tire model based on 10% slip ratio peak
        WheelLongExtremumSlip=0.5
        WheelLongExtremumValue=2.0
        WheelLongAsymptoteSlip=2.0
        WheelLongAsymptoteValue=0.6

        // Lateral tire model based on slip angle (radians)
           WheelLatExtremumSlip=0.5 //0.35     // 20 degrees
        WheelLatExtremumValue=4.0
        WheelLatAsymptoteSlip=1.4     // 80 degrees
        WheelLatAsymptoteValue=2.0

        ChassisTorqueScale=0.0
        StopThreshold=20
        EngineDamping=4
        InsideTrackTorqueFactor=0.375
        TurnInPlaceThrottle=0.225
        TurnMaxGripReduction=0.995
        TurnGripScaleRate=0.8
        MaxEngineTorque=8000
        End Object
    SimObj=SimObject
    Components.Add(SimObject)


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_VH_CrusaderTank.Mesh.SK_VH_CrusaderTank'
        AnimTreeTemplate=AnimTree'RX_VH_CrusaderTank.Anims.AT_VH_CrusaderTank'
        AnimSets(0)=AnimSet'RX_VH_CrusaderTank.Anims.SK_VH_CrusaderTank_Anims'
        PhysicsAsset=PhysicsAsset'RX_VH_CrusaderTank.Mesh.SK_VH_CrusaderTank_Physics'
        //MorphSets[0]=MorphTargetSet'RX_VH_MediumTank.Mesh.MT_VH_MediumTank'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_CrusaderTank.Mesh.SK_VH_CrusaderTank'
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshL
		SkeletalMesh=SkeletalMesh'RX_VH_MediumTank.Mesh.SK_Antenna_Left'
		AnimTreeTemplate=AnimTree'RX_VH_MediumTank.Anims.AT_Antenna_Left'
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshL=SAntennaMeshL
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshR
		SkeletalMesh=SkeletalMesh'RX_VH_MediumTank.Mesh.SK_Antenna_Right'
		AnimTreeTemplate=AnimTree'RX_VH_MediumTank.Anims.AT_Antenna_Right'
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshR=SAntennaMeshR

	VehicleIconTexture=Texture2D'RX_VH_CrusaderTank.Textures.VehicleIcon_Crusader'
	MinimapIconTexture=Texture2D'RX_VH_MediumTank.UI.T_MinimapIcon_MediumTank'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'Rx_Vehicle_CrusaderTank_Weapon',
                GunSocket=("FirePrimary", "MGFireSocket"),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(b_Turret_Yaw),
                CameraTag=CamView3P,
                bSeatVisible=false,
                CameraBaseOffset=(Z=20),
                CameraOffset=-460,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
                
	Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
				CameraTag=CamView3P,
                bSeatVisible=false,
				CameraBaseOffset=(Z=20),
				CameraOffset=-460,
				)}

//  TurretPassengerIndex = 1

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


    LeftTeadIndex     = 1
    RightTreadIndex   = 2

    DrivingPhysicalMaterial=none //PhysicalMaterial'RX_VH_MediumTank.Materials.PhysMat_Medium_VCollision'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_MediumTank.Materials.PhysMat_Medium'

    RecoilTriggerTag = "FirePrimary", "FireSecondary"
    VehicleEffects(0)=(EffectStartTag="FirePrimary",EffectTemplate=ParticleSystem'RX_VH_MediumTank.Effects.MuzzleFlash',EffectSocket="FirePrimary")
    VehicleEffects(1)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke01)
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke02)
    VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks01)
    VehicleEffects(4)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks02)
    VehicleEffects(5)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks01)
    VehicleEffects(6)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks02)
    VehicleEffects(7)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
    VehicleEffects(8)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire02)
    VehicleEffects(9)=(EffectStartTag="FireSecondary",EffectEndTag="STOP_FireSecondary",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_APC_GDI.Effects.P_MuzzleFlash_50Cal_Looping',EffectSocket="MGFireSocket")

	WheelParticleEffects[0]=(MaterialType=Generic,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
    WheelParticleEffects[1]=(MaterialType=Dirt,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small')
	WheelParticleEffects[2]=(MaterialType=Grass,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small')
    WheelParticleEffects[3]=(MaterialType=Water,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Water')
    WheelParticleEffects[4]=(MaterialType=Snow,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Snow_Small')
	WheelParticleEffects[5]=(MaterialType=Concrete,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[6]=(MaterialType=Metal,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Generic')
	WheelParticleEffects[7]=(MaterialType=Stone,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Stone')
	WheelParticleEffects[8]=(MaterialType=WhiteSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_WhiteSand_Small')
	WheelParticleEffects[9]=(MaterialType=YellowSand,ParticleTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_YellowSand_Small')
	DefaultWheelPSCTemplate=ParticleSystem'RX_FX_Vehicle.Wheel.P_FX_Wheel_Dirt_Small'
	

    VehicleAnims(0)=(AnimTag=Idle,AnimSeqs=(Idle),AnimRate=1.0,bAnimLoopLastSeq=true,AnimPlayerName=AnimPlayer)
	VehicleAnims(1)=(AnimTag=OpenHatch,AnimSeqs=(Open_Hatch),AnimRate=1.0,bAnimLoopLastSeq=false,AnimPlayerName=AnimPlayer)
	VehicleAnims(2)=(AnimTag=CloseHatch,AnimSeqs=(Close_Hatch),AnimRate=1.0,bAnimLoopLastSeq=false,AnimPlayerName=AnimPlayer)

    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_VH_MediumTank.Effects.P_Explosion_Vehicle')
    BigExplosionSocket=VH_Death
/**
    DamageMorphTargets(0)=(InfluenceBone=MT_Chassis_Front,MorphNodeName=MorphNodeW_Ch_F,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_Chassis_Front_Left,MorphNodeName=MorphNodeW_Ch_FL,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(2)=(InfluenceBone=MT_Chassis_Front_Right,MorphNodeName=MorphNodeW_Ch_FR,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(3)=(InfluenceBone=MT_Chassis_Rear,MorphNodeName=MorphNodeW_Ch_B,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(4)=(InfluenceBone=MT_Chassis_Rear_Left,MorphNodeName=MorphNodeW_Ch_BL,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(5)=(InfluenceBone=MT_Chassis_Rear_Right,MorphNodeName=MorphNodeW_Ch_BR,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(6)=(InfluenceBone=MT_Chassis_Left,MorphNodeName=MorphNodeW_Ch_L,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage3))
    DamageMorphTargets(7)=(InfluenceBone=MT_Chassis_Right,MorphNodeName=MorphNodeW_Ch_R,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage4))
    DamageMorphTargets(8)=(InfluenceBone=MT_Turret_Rear_Left,MorphNodeName=MorphNodeW_Tu_BL,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(9)=(InfluenceBone=MT_Turret_Rear_Right,MorphNodeName=MorphNodeW_Tu_BR,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(10)=(InfluenceBone=MT_Turret_Left,MorphNodeName=MorphNodeW_Tu_L,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage3))
    DamageMorphTargets(11)=(InfluenceBone=MT_Turret_Right,MorphNodeName=MorphNodeW_Tu_R,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage4))
    DamageMorphTargets(12)=(InfluenceBone=MT_Turret_Front_Right,MorphNodeName=MorphNodeW_Tu_FR,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(13)=(InfluenceBone=MT_Turret_Front_Left,MorphNodeName=MorphNodeW_Tu_FL,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
*/

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=2.0)

//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RX_VH_MediumTank.Sounds.Med_IdleCue'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);
   
    EnterVehicleSound=SoundCue'RX_VH_MediumTank.Sounds.Med_startCue'
    ExitVehicleSound=SoundCue'RX_VH_MediumTank.Sounds.Med_stopCue'

	Begin Object Class=AudioComponent name=FiringmbientSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
		SoundCue=SoundCue'RX_VH_CrusaderTank.Sounds.SC_CrusaderTank_MG'
    End Object
    FiringAmbient=FiringmbientSoundComponent
    Components.Add(FiringmbientSoundComponent)
    
    FiringStopSound=SoundCue'RX_VH_Humvee.Sounds.SC_Humvee_Fire_Stop' //SoundCue'RX_VH_MediumTank.Sounds.SC_MediumTank_MG_Stop'


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_1
        BoneName="b_Wheel_R_01"
        SkelControlName="Wheel_R1_Cont"
        VPushLongSlip = 0.15 //On vehicle push
        Side=SIDE_Right
    End Object
    Wheels(0)=R_Wheel_1
    
    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_2
        BoneName="b_Wheel_R_02"
        SkelControlName="Wheel_R2_Cont"
        Side=SIDE_Right
    End Object
    Wheels(1)=R_Wheel_2    

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_3
        BoneName="b_Wheel_R_03"
        SkelControlName="Wheel_R3_Cont"
        Side=SIDE_Right
    End Object
    Wheels(2)=R_Wheel_3
    
    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_4
        BoneName="b_Wheel_R_04"
        SkelControlName="Wheel_R4_Cont"
        Side=SIDE_Right
    End Object
    Wheels(3)=R_Wheel_4

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_5
        BoneName="b_Wheel_R_05"
        SkelControlName="Wheel_R5_Cont"
        Side=SIDE_Right
    End Object
    Wheels(4)=R_Wheel_5

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_6
        BoneName="b_Wheel_R_06"
        SkelControlName="Wheel_R6_Cont"
        Side=SIDE_Right
    End Object
    Wheels(5)=R_Wheel_6
	
	Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=R_Wheel_7
        BoneName="b_Wheel_R_07"
        SkelControlName="Wheel_R7_Cont"
        VPushLongSlip = 0.15 //On vehicle push
        Side=SIDE_Right
    End Object
    Wheels(6)=R_Wheel_7





    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_1
        BoneName="b_Wheel_L_01"
        SkelControlName="Wheel_L1_Cont"
        VPushLongSlip = 0.15 //On vehicle push
        Side=SIDE_Left
    End Object
    Wheels(7)=L_Wheel_1
    
    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_2
        BoneName="b_Wheel_L_02"
        SkelControlName="Wheel_L2_Cont"
        Side=SIDE_Left
    End Object
    Wheels(8)=L_Wheel_2    

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_3
        BoneName="b_Wheel_L_03"
        SkelControlName="Wheel_L3_Cont"
        Side=SIDE_Left
    End Object
    Wheels(9)=L_Wheel_3
    
    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_4
        BoneName="b_Wheel_L_04"
        SkelControlName="Wheel_L4_Cont"
        Side=SIDE_Left
    End Object
    Wheels(10)=L_Wheel_4

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_5
        BoneName="b_Wheel_L_05"
        SkelControlName="Wheel_L5_Cont"
        Side=SIDE_Left
    End Object
    Wheels(11)=L_Wheel_5

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_6
        BoneName="b_Wheel_L_06"
        SkelControlName="Wheel_L6_Cont"
        Side=SIDE_Left
    End Object
    Wheels(12)=L_Wheel_6

    Begin Object class=RX_Vehicle_CrusaderTank_Wheel Name=L_Wheel_7
        BoneName="b_Wheel_L_07"
        SkelControlName="Wheel_L7_Cont"
        VPushLongSlip = 0.15 //On vehicle push
        Side=SIDE_Left
    End Object
    Wheels(13)=L_Wheel_7

 Begin Object Class=RX_Vehicle_CrusaderTank_Wheel Name=FL_Wheel
        BoneName="b_Wheel_LT_01"
        SkelControlName="Wheel_FL_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(14)=FL_Wheel

    Begin Object Class=RX_Vehicle_CrusaderTank_Wheel Name=RL_Wheel
        BoneName="b_Wheel_LT_02"
        SkelControlName="Wheel_RL_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(15)=RL_Wheel

    Begin Object Class=RX_Vehicle_CrusaderTank_Wheel Name=FR_Wheel
        BoneName="b_Wheel_RT_01"
        SkelControlName="Wheel_FR_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(16)=FR_Wheel

    Begin Object Class=RX_Vehicle_CrusaderTank_Wheel Name=RR_Wheel
        BoneName="b_Wheel_RT_02"
        SkelControlName="Wheel_RR_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(17)=RR_Wheel

    UIString="Crusader Tank"

    WeightResistance = (X=0.0,Y=0.0,Z=-20000)
    PushTorqueMult = 0.35

    PushCheckMax = (X=215,Y=-105,Z=0)
	PushCheckVWidth = (X=0,Y=210,Z=0)
	PushCheckVLength = (X=390,Y=0,Z=0)

    bOverrideDevHorn = true
    HornDelay = 5.0
    HornSounds[0]=SoundCue'RX_VH_CrusaderTank.Sounds.SN_CrusaderTank_Horn_Cue'

}
