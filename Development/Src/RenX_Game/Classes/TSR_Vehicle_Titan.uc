/*********************************************************
*
* File: TSR_Vehicle_Titan.uc
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
class TSR_Vehicle_Titan extends Rx_Vehicle_Treaded
placeable;
	
var GameSkelCtrl_Recoil    Recoil_Barrel, Recoil_Cannon, Recoil_Turret;

var SkeletalMeshComponent AntennaMeshL;
var SkeletalMeshComponent AntennaMeshR;

/** The Cantilever Beam that is the Antenna itself*/
var UTSkelControl_CantileverBeam AntennaBeamControl;

/** This bit here will attach all of the seperate antennas and towing rings that jiggle about when the vehicle moves **/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.AttachComponentToSocket(AntennaMeshL,'Antenna_L');
	Mesh.AttachComponentToSocket(AntennaMeshR,'Antenna_R');

	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshL.FindSkelControl('Beam'));
	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshR.FindSkelControl('Beam'));

	if (AntennaBeamControl != none)
	{
		AntennaBeamControl.EntireBeamVelocity = GetVelocity;
	}
}
	
/** added recoil */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	Super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh)
    {
		Recoil_Barrel = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Barrel') );
		Recoil_Cannon = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Cannon') );
		Recoil_Turret = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Turret') );
	}
}

simulated function PlayRecoil(name EventTag)
{
	if (RecoilTriggerTag == EventTag && Recoil_Barrel != none)
	{
		Recoil_Barrel.bPlayRecoil = true;
	}	
	
	if (RecoilTriggerTag == EventTag && Recoil_Cannon != none)
	{
		Recoil_Cannon.bPlayRecoil = true;
	}
	
	if (RecoilTriggerTag == EventTag && Recoil_Turret != none)
	{
		Recoil_Turret.bPlayRecoil = true;
	}
}
    
DefaultProperties
{
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

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\

    bRotateCameraUnderVehicle=false
    bSecondaryFireTogglesFirstPerson=true
    Health=800
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=True
    bSeparateTurretFocus=True
    CameraLag=0.2
    LookForwardDist=100
    GroundSpeed=300
    MaxSpeed=1000
    LeftStickDirDeadZone=0.1
    TurnTime=18
    ViewPitchMin=-13000
    HornIndex=0
    COMOffset=(x=0.0,y=0.0,z=-300.0)
	ExitOffset=(Z=-200.0)
	ExtraReachDownThreshold=450.0
	ObjectiveGetOutDist=750.0

	bStayUpright=true
	StayUprightRollResistAngle=5.0			// will be "locked"
	StayUprightPitchResistAngle=5.0
	StayUprightStiffness=100000
	StayUprightDamping=100
	
	UprightLiftStrength=50.0
	UprightTorqueStrength=50.0
	
	CustomGravityScaling=2.0

    Begin Object Class=SVehicleSimTank Name=SimObject
	
        bClampedFrictionModel=true

        WheelSuspensionStiffness=65
        WheelSuspensionDamping=20.0
        WheelSuspensionBias=0.0

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
        EngineDamping=3.5
        InsideTrackTorqueFactor=0.4
        TurnInPlaceThrottle=0.3
        TurnMaxGripReduction=0.995
        TurnGripScaleRate=0.8
        MaxEngineTorque=3000
		
    End Object
    SimObj=SimObject
    Components.Add(SimObject)

//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'TS_VH_Titan.Mesh.SK_VH_Titan_Reborn'
        AnimTreeTemplate=AnimTree'TS_VH_Titan.Anims.AT_VH_Titan_Reborn'
		AnimSets.Add(AnimSet'TS_VH_Titan.Anims.AS_VH_Titan_Reborn')
        PhysicsAsset=PhysicsAsset'TS_VH_Titan.Mesh.SK_VH_Titan_Reborn_Physics'
		MorphSets[0]=MorphTargetSet'TS_VH_Titan.Mesh.MT_VH_Titan_Reborn'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'TS_VH_Titan.Mesh.SK_VH_Titan_Reborn'
	
	Begin Object Name=CollisionCylinder
		CollisionHeight=150.0
		CollisionRadius=200.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
		End Object
	CylinderComponent=CollisionCylinder
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshL
		SkeletalMesh=SkeletalMesh'RX_VH_MediumTank.Mesh.SK_Antenna_Left'
		AnimTreeTemplate=AnimTree'RX_VH_MediumTank.Anims.AT_Antenna_Left'
		Scale=2.0
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshL=SAntennaMeshL
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshR
		SkeletalMesh=SkeletalMesh'RX_VH_MediumTank.Mesh.SK_Antenna_Right'
		AnimTreeTemplate=AnimTree'RX_VH_MediumTank.Anims.AT_Antenna_Right'
		Scale=2.0
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshR=SAntennaMeshR
	
	VehicleIconTexture=Texture2D'TS_VH_Titan.Materials.T_VehicleIcon_Titan'
	MinimapIconTexture=Texture2D'TS_VH_Titan.Materials.T_RadarBlip_Titan'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'TSR_Vehicle_Titan_Weapon',
                GunSocket=(MuzzleFlashSocket),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(b_Turret_Yaw,b_Turret_Pitch),
                CameraTag=CamView3P,
                CameraBaseOffset=(X=0,Z=-150),
                CameraOffset=-800,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
				
	Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
				CameraTag=CamView3P,
				CameraBaseOffset=(X=0,Z=-150),
                CameraOffset=-800,
				)}
	
//  TurretPassengerIndex = 1

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\

    DrivingPhysicalMaterial=PhysicalMaterial'TS_VH_Titan.Materials.PhysMat_Titan_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'TS_VH_Titan.Materials.PhysMat_Titan'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectTemplate=ParticleSystem'TS_VH_Titan.Effects.P_MuzzleFlash',EffectSocket="MuzzleFlashSocket")
	VehicleEffects(1)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSteam01)
	VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks01)
	VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks02)
    VehicleEffects(4)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Random',EffectSocket=DamageSparks03)
    VehicleEffects(5)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_Sparks_Tracks',EffectSocket=DamageTSpark01))
    VehicleEffects(6)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
	
	VehicleEffects(7)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'TS_VH_Titan.Effects.P_Laser',EffectSocket=LaserSocket)

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
	
    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Huge')
    BigExplosionSocket=VH_Death
	
	DamageMorphTargets(0)=(InfluenceBone=b_Root,MorphNodeName=MorphNodeW_Ch_F,LinkedMorphNodeName=none,Health=100,DamagePropNames=(Damage1))
    DamageMorphTargets(3)=(InfluenceBone=b_Hip,MorphNodeName=MorphNodeW_Ch_B,LinkedMorphNodeName=none,Health=100,DamagePropNames=(Damage2))
    DamageMorphTargets(6)=(InfluenceBone=b_Leg_L_Upper,MorphNodeName=MorphNodeW_Ch_L,LinkedMorphNodeName=none,Health=100,DamagePropNames=(Damage3))
    DamageMorphTargets(7)=(InfluenceBone=b_Leg_R_Upper,MorphNodeName=MorphNodeW_Ch_R,LinkedMorphNodeName=none,Health=100,DamagePropNames=(Damage4))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)


//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'TS_VH_Titan.Sounds.SC_Idle'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);
   
    EnterVehicleSound=SoundCue'TS_VH_Titan.Sounds.SC_Start'
    ExitVehicleSound=SoundCue'TS_VH_Titan.Sounds.SC_Stop'


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\


	Begin Object Class=Rx_Vehicle_MediumTank_Wheel Name=RFThruster
		BoneName="b_Wheel_FR"
		WheelRadius=40
		SuspensionTravel=200
		Side=SIDE_Right
	End Object
	Wheels(0)=RFThruster

	Begin Object Class=Rx_Vehicle_MediumTank_Wheel Name=LFThruster
		BoneName="b_Wheel_FL"
		WheelRadius=40
		SuspensionTravel=200
		Side=SIDE_Left
	End Object
	Wheels(1)=LFThruster
	
	Begin Object Class=Rx_Vehicle_MediumTank_Wheel Name=RRThruster
		BoneName="b_Wheel_RR"
		WheelRadius=40
		SuspensionTravel=200
		Side=SIDE_Right
	End Object
	Wheels(2)=RRThruster
	
	Begin Object Class=Rx_Vehicle_MediumTank_Wheel Name=LRThruster
		BoneName="b_Wheel_RL"
		WheelRadius=40
		SuspensionTravel=200
		Side=SIDE_Left
	End Object
	Wheels(3)=LRThruster

    UIString="Titan"
	
}
