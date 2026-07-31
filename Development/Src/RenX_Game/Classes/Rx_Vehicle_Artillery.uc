/*********************************************************
*
* File: Rx_Vehicle_Artillery.uc
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
class Rx_Vehicle_Artillery extends Rx_Vehicle_Treaded
    placeable;


var SkeletalMeshComponent AntennaMesh;


/** The Cantilever Beam that is the Antenna itself*/
var UTSkelControl_CantileverBeam AntennaBeamControl;


/** This bit here will attach all of the seperate antennas and towing rings that jiggle about when the vehicle moves **/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.AttachComponentToSocket(AntennaMesh,'AntennaSocket');

	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMesh.FindSkelControl('BeamS'));

	if(AntennaBeamControl != none)
	{
		AntennaBeamControl.EntireBeamVelocity = GetVelocity;
	}
}

 
	
	
	
	
function bool TooCloseToAttack(Actor Other)
{
    local float dist;
    
    if(super.TooCloseToAttack(Other)) {
        return true;
    }
    
    dist = VSizeSq(Location - Other.Location);
    return (dist < Square(700.0 + FRand()*200));
}


DefaultProperties
{

    Begin Object Name=CollisionCylinder
    CollisionHeight=100.0
    CollisionRadius=200.0
    Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\


    Health=400
    bLightArmor=True
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=false
    bSeparateTurretFocus=True
    CameraLag=0.15
    LookForwardDist=250
    GroundSpeed=400
    AirSpeed=400
    MaxSpeed=600
    LeftStickDirDeadZone=0.1
    TurnTime=18
    ViewPitchMin=-13000
    HornIndex=0
    COMOffset=(x=-10.0,y=0.0,z=-60.0)
    bSecondaryFireTogglesFirstPerson=true
	SpeedAtWhichToApplyReducedTurningThrottle=220
	
	SprintTrackTorqueFactorDivident=0.975

	BarrelLength(0)=450
	BarrelLength(1)=400
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
VetRankInfo(0) = (VPReward = 5, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
VetRankInfo(1) = (VPReward = 5, HealthMod = 1.025, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
VetRankInfo(2) = (VPReward = 5, HealthMod = 1.065, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

//VETERAN
VetRankInfo(3) = (VPReward = 7, HealthMod = 1.125, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
VetRankInfo(4) = (VPReward = 7, HealthMod = 1.15, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
VetRankInfo(5) = (VPReward = 7, HealthMod = 1.19, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

//ELITE
VetRankInfo(6) = (VPReward = 9, HealthMod = 1.25, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 
VetRankInfo(7) = (VPReward = 9, HealthMod = 1.275, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 
VetRankInfo(8) = (VPReward = 9, HealthMod = 1.315, SprintspeedMod = 1.05, SprintTTFDMod = 0.10) 

//HEROIC
VetRankInfo(9) = (VPReward = 12, HealthMod = 1.375, SprintspeedMod = 1.10, SprintTTFDMod = 0.10) 

/******************/
	

Heroic_MuzzleFlash=ParticleSystem'RX_VH_MediumTank.Effects.MuzzleFlash_Heroic'

    Begin Object Class=SVehicleSimTank Name=SimObject

        bClampedFrictionModel=true

        WheelSuspensionStiffness=200
        WheelSuspensionDamping=2.0
        WheelSuspensionBias=0.15

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
        EngineDamping=3
        InsideTrackTorqueFactor=0.35
        TurnInPlaceThrottle=0.3
        TurnMaxGripReduction=0.995
        TurnGripScaleRate=0.8
        MaxEngineTorque=2400
        End Object
    SimObj=SimObject
    Components.Add(SimObject)


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RX_VH_Artillery.Mesh.SK_VH_Artillery'
        AnimTreeTemplate=AnimTree'RX_VH_Artillery.Anims.AT_VH_Artillery'
        PhysicsAsset=PhysicsAsset'RX_VH_Artillery.Mesh.SK_VH_Artillery_Physics'
		MorphSets[0]=MorphTargetSet'RX_VH_Artillery.Mesh.MT_VH_Artillery'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_Artillery.Mesh.SK_PTVH_Artillery'
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMesh
		SkeletalMesh=SkeletalMesh'RX_VH_Artillery.Mesh.SK_Antenna'
		AnimTreeTemplate=AnimTree'RX_VH_Artillery.Anims.AT_Antenna'
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMesh=SAntennaMesh

	VehicleIconTexture=Texture2D'RX_VH_Artillery.UI.T_VehicleIcon_Artillery'
	MinimapIconTexture=Texture2D'RX_VH_Artillery.UI.T_MinimapIcon_Artillery'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'Rx_Vehicle_Artillery_Weapon',
                GunSocket=(Fire01),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(MainTurretYaw,MainTurretPitch),
                CameraTag=CamView3P,
                bSeatVisible=false,
                CameraBaseOffset=(Z=-10),
                CameraOffset=-600,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
                
    Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
                CameraTag=CamView3P,
                bSeatVisible=false,
                CameraBaseOffset=(Z=-10),
                CameraOffset=-600,
                )}

//  TurretPassengerIndex = 1

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


//    LeftTeadIndex     = 1
//    RightTreadIndex   = 2

    BurnOutMaterial[0]=MaterialInstanceConstant'RX_VH_Artillery.Materials.MI_VH_Artillery_Destroyed'
    BurnOutMaterial[1]=MaterialInstanceConstant'RX_VH_Artillery.Materials.MI_VH_Artillery_Destroyed'

    DrivingPhysicalMaterial=none//PhysicalMaterial'RX_VH_Artillery.Materials.PhysMat_Arty_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_Artillery.Materials.PhysMat_Arty'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectTemplate=ParticleSystem'RX_VH_Artillery.Effects.P_MuzzleFlash',EffectSocket="Fire01")
    VehicleEffects(1)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke01)
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSmoke02)
    VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks01)
    VehicleEffects(4)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks02)
    VehicleEffects(5)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks01)
    VehicleEffects(6)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSparks02)
    VehicleEffects(7)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
    VehicleEffects(8)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire02)

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
	
    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_VH_Artillery.Effects.P_Explosion_Vehicle')
    BigExplosionSocket=VH_Death
	
	DamageMorphTargets(0)=(InfluenceBone=MT_Ch_F,MorphNodeName=MorphNodeW_Ch_F,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_Ch_L,MorphNodeName=MorphNodeW_Ch_L,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage3))
    DamageMorphTargets(2)=(InfluenceBone=MT_Ch_R,MorphNodeName=MorphNodeW_Ch_R,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage4))
    DamageMorphTargets(3)=(InfluenceBone=MT_Ch_B,MorphNodeName=MorphNodeW_Ch_B,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage2))
    DamageMorphTargets(4)=(InfluenceBone=MT_Tu_L,MorphNodeName=MorphNodeW_Tu_L,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage3))
    DamageMorphTargets(5)=(InfluenceBone=MT_Tu_R,MorphNodeName=MorphNodeW_Tu_R,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage1))
    DamageMorphTargets(6)=(InfluenceBone=MT_Tu_B,MorphNodeName=MorphNodeW_Tu_B,LinkedMorphNodeName=none,Health=80,DamagePropNames=(Damage2))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)

//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RX_VH_Artillery.Sounds.Arty_IdleCue'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);

    EnterVehicleSound=SoundCue'RX_VH_Artillery.Sounds.Arty_startCue'
    ExitVehicleSound=SoundCue'RX_VH_Artillery.Sounds.Arty_StopCue'
	
	ExplosionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Explode_Large'
	
	Begin Object Class=AudioComponent Name=ScorpionSquealSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_TireSlide'
	End Object
	SquealSound=ScorpionSquealSound
	Components.Add(ScorpionSquealSound);


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

   
   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=RRWheel_01
      BoneName="Rt_Rear_Tire_01"
      SkelControlName="Rt_Rear_01_Control"
      Side=SIDE_Right
   End Object
   Wheels(0)=RRWheel_01

   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=LRWheel_01
      BoneName="Lt_Rear_Tire_01"
      SkelControlName="Lt_Rear_01_Control"
      Side=SIDE_Left
   End Object
   Wheels(1)=LRWheel_01

   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=RRWheel_02
      BoneName="Rt_Rear_Tire_02"
      SkelControlName="Rt_Rear_02_Control"
      Side=SIDE_Right
   End Object
   Wheels(2)=RRWheel_02

   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=LRWheel_02
      BoneName="Lt_Rear_Tire_02"
      SkelControlName="Lt_Rear_02_Control"
      Side=SIDE_Left
   End Object
   Wheels(3)=LRWheel_02

   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=RFWheel_01
      BoneName="Rt_Front_Tire"
      SkelControlName="Rt_Front_Control"
      Side=SIDE_Right
      LongSlipFactor=1.5
      VPushLongSlip = 0.20
   End Object
   Wheels(4)=RFWheel_01

   Begin Object class=Rx_Vehicle_Artillery_Wheel Name=LFWheel_01
      BoneName="Lt_Front_Tire"
      SkelControlName="Lt_Front_Control"
      Side=SIDE_Left
      LongSlipFactor=1.5
      VPushLongSlip = 0.20
   End Object
   Wheels(5)=LFWheel_01

   UIString="Artillery"
   WeightResistance = (X=0.0,Y=0.0,Z=-20000)
    PushTorqueMult = 0.50

    PushCheckMax = (X=225,Y=-125,Z=-15)
	PushCheckVWidth = (X=0,Y=250,Z=0)
	PushCheckVLength = (X=450,Y=0,Z=0)
}