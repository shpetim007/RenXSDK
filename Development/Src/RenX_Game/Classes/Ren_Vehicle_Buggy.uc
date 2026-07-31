/*********************************************************
*
* File: Ren_Vehicle_Buggy.uc
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
class Ren_Vehicle_Buggy extends Rx_Vehicle
    placeable;


    
/** Firing sounds */
var() AudioComponent FiringAmbient;
var() SoundCue FiringStopSound;
//var	  SoundCue Snd_FiringAmbient_Heroic; 


var SkeletalMeshComponent AntennaMeshA;
var SkeletalMeshComponent AntennaMeshB;

/** The Cantilever Beam that is the Antenna itself*/
var UTSkelControl_CantileverBeam AntennaBeamControl;


/** This bit here will attach all of the seperate antennas and towing rings that jiggle about when the vehicle moves **/
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	Mesh.AttachComponentToSocket(AntennaMeshA,'AntennaSocket_L');
	Mesh.AttachComponentToSocket(AntennaMeshB,'AntennaSocket_R');


	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshA.FindSkelControl('BeamShort'));
	AntennaBeamControl = UTSkelControl_CantileverBeam(AntennaMeshB.FindSkelControl('BeamShort'));


	if(AntennaBeamControl != none)
	{
		AntennaBeamControl.EntireBeamVelocity = GetVelocity;
	}
}

 



simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
    // Trigger any vehicle Firing Effects
    VehicleEvent('MainGun');
    
    if (!FiringAmbient.bWasPlaying)
    {
        FiringAmbient.Play();
    }
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
    // Trigger any vehicle Firing Effects
    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if (Role == ROLE_Authority || bViaReplication || WorldInfo.NetMode == NM_Client)
        {
            VehicleEvent('STOP_MainGun');
        }
    }

    PlaySound(FiringStopSound, TRUE, FALSE, FALSE, Location, FALSE);
    FiringAmbient.Stop();
}

/**simulated function SetHeroicMuzzleFlash(bool SetTrue)
{
	super.SetHeroicMuzzleFlash(SetTrue);
	
}

simulated function SetHeroicMuzzleFlash(bool SetTrue)
 {
	 local int i; 
	 
	 for(i=0;i<VehicleEffects.Length;i++)
	 {
		 if(VehicleEffects[i].EffectStartTag=='MainGun' && default.VehicleEffects[i].EffectRef != none) 
		 {
			 if(SetTrue) VehicleEffects[i].EffectRef.SetTemplate(none);//Heroic_MuzzleFlash); //Special case for lasers
			 else
			VehicleEffects[i].EffectRef.SetTemplate(default.VehicleEffects[i].EffectTemplate);
			//return;
		 }
	 }
	 
	 if(SetTrue) FiringAmbient.SoundCue=Snd_FiringAmbient_Heroic;
		else
		FiringAmbient.SoundCue=FiringAmbient.default.SoundCue; 
 }*/
    
DefaultProperties
{

    Begin Object Name=CollisionCylinder
    CollisionHeight=160.0
    CollisionRadius=80.0
    Translation=(X=0.0,Y=0.0,Z=0.0)
    End Object

//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\


    Health=250
    bLightArmor=True
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bSeparateTurretFocus=True
    CameraLag=0.075 //0.125 //0.2
	LookForwardDist=150
    bHasHandbrake=true
    GroundSpeed=600
    AirSpeed=750
    MaxSpeed=2500
    HornIndex=0
    COMOffset=(x=0.0,y=0.0,z=-25.0)
    bUsesBullets = true
    bOkAgainstBuildings=false
    bSecondaryFireTogglesFirstPerson=true
	
	CustomGravityScaling=0.8

/***********/
/*Vehicle Veterancy Block*/
/***********/

//VP Reward : Base VP give on death
//HealthMod: +HP for this rank
//SprintSpeedMod = Base Sprint Speed multiplied by this
//TTFD = Turn Torque Factor (Keeps vehicles from turning too hard when their sprint speed increases)

//RECRUIT
VetRankInfo(0) = (VPReward = 4, HealthMod = 1.0, SprintspeedMod = 1.0) 
VetRankInfo(1) = (VPReward = 4, HealthMod = 1.02, SprintspeedMod = 1.0) 
VetRankInfo(2) = (VPReward = 4, HealthMod = 1.05, SprintspeedMod = 1.0) 

//VETERAN
VetRankInfo(3) = (VPReward = 6, HealthMod = 1.1, SprintspeedMod = 1.1) 
VetRankInfo(4) = (VPReward = 6, HealthMod = 1.12, SprintspeedMod = 1.1) 
VetRankInfo(5) = (VPReward = 6, HealthMod = 1.15, SprintspeedMod = 1.1) 

//ELITE
VetRankInfo(6) = (VPReward = 8, HealthMod = 1.2, SprintspeedMod = 1.2) 
VetRankInfo(7) = (VPReward = 8, HealthMod = 1.25, SprintspeedMod = 1.2) 
VetRankInfo(8) = (VPReward = 8, HealthMod = 1.30, SprintspeedMod = 1.2) 

//HEROIC
VetRankInfo(9) = (VPReward = 10, HealthMod = 1.4, SprintspeedMod = 1.3) 

/******************/
	
    HeavySuspensionShiftPercent=0.75f;
    bLookSteerOnNormalControls=true
    bLookSteerOnSimpleControls=true
    LookSteerSensitivity=2.2
    LookSteerDamping=0.07
    ConsoleSteerScale=1.1
    DeflectionReverseThresh=-0.3

    Begin Object Class=UDKVehicleSimCar Name=SimObject
        WheelSuspensionStiffness=50
        WheelSuspensionDamping=2.0
        WheelSuspensionBias=0.0
        ChassisTorqueScale=0.25
        MaxBrakeTorque=4.0
        StopThreshold=100

        MaxSteerAngleCurve=(Points=((InVal=0,OutVal=45),(InVal=800.0,OutVal=30.0), (InVal=900.0,OutVal=10.0)))
        SteerSpeed=400

        LSDFactor=0.0

        // TorqueVSpeedCurve=(Points=((InVal=-600.0,OutVal=0.0),(InVal=-300.0,OutVal=80.0),(InVal=0.0,OutVal=130.0),(InVal=950.0,OutVal=130.0),(InVal=1050.0,OutVal=10.0),(InVal=1150.0,OutVal=0.0)))
        TorqueVSpeedCurve=(Points=((InVal=-750.0,OutVal=0.0),(InVal=0.0,OutVal=130.0),(InVal=850.0,OutVal=10.0)))

        // EngineRPMCurve=(Points=((InVal=-500.0,OutVal=2500.0),(InVal=0.0,OutVal=500.0),(InVal=549.0,OutVal=3500.0),(InVal=550.0,OutVal=1000.0),(InVal=849.0,OutVal=4500.0),(InVal=850.0,OutVal=1500.0),(InVal=1100.0,OutVal=5000.0)))
        EngineRPMCurve=(Points=((InVal=-500.0,OutVal=3500.0),(InVal=0.0,OutVal=1500.0),(InVal=850.0,OutVal=4500.0),(InVal=1500.0,OutVal=6000.0)))

        EngineBrakeFactor=0.05
        ThrottleSpeed=1.0
        WheelInertia=0.2
        NumWheelsForFullSteering=4
        SteeringReductionFactor=0.0
        SteeringReductionMinSpeed=1100.0
        SteeringReductionSpeed=1400.0
        bAutoHandbrake=true
        bClampedFrictionModel=true
        FrontalCollisionGripFactor=0.01
        ConsoleHardTurnGripFactor=1.0
        HardTurnMotorTorque=0.7

        SpeedBasedTurnDamping=0.2
        AirControlTurnTorque=0.0

        // Longitudinal tire model based on 10% slip ratio peak
        WheelLongExtremumSlip=0.1
        WheelLongExtremumValue=1.0
        WheelLongAsymptoteSlip=2.0
        WheelLongAsymptoteValue=0.6

        // Lateral tire model based on slip angle (radians)
		WheelLatExtremumSlip=0.35     // 20 degrees
        WheelLatExtremumValue=0.5
        WheelLatAsymptoteSlip=1.4     // 80 degrees
        WheelLatAsymptoteValue=5.0

        bAutoDrive=false
        AutoDriveSteer=0.3
    End Object
    SimObj=SimObject
    Components.Add(SimObject)


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'Ren_VH_Nod_Buggy.Mesh.SK_VH_Buggy'
        AnimTreeTemplate=AnimTree'Ren_VH_Nod_Buggy.Anims.AT_VH_Buggy'
        PhysicsAsset=PhysicsAsset'Ren_VH_Nod_Buggy.Mesh.SK_VH_Buggy_Physics'
		//MorphSets[0]=MorphTargetSet'RX_VH_Buggy.Mesh.MT_VH_Buggy'
		//AnimSets.Add(AnimSet'RX_VH_Buggy.Anims.AS_VH_Buggy')
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'Ren_VH_Nod_Buggy.Mesh.SK_PTVH_Buggy'
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshA
		SkeletalMesh=SkeletalMesh'RX_VH_LightTank.Mesh.SK_Antenna'
		AnimTreeTemplate=AnimTree'RX_VH_LightTank.Anims.AT_Antenna'
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshA=SAntennaMeshA
	
	Begin Object Class=SkeletalMeshComponent Name=SAntennaMeshB
		SkeletalMesh=SkeletalMesh'RX_VH_LightTank.Mesh.SK_Antenna'
		AnimTreeTemplate=AnimTree'RX_VH_LightTank.Anims.AT_Antenna'
		LightEnvironment = MyLightEnvironment
	End Object
	AntennaMeshB=SAntennaMeshB

	VehicleIconTexture=Texture2D'RX_VH_Buggy.UI.T_VehicleIcon_Buggy'
	MinimapIconTexture=Texture2D'RX_VH_Buggy.UI.T_MinimapIcon_Buggy'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'Ren_Vehicle_Buggy_Weapon',
                GunSocket=(Fire_01),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(MainTurretYaw),
                bSeatVisible=false,
                CameraTag=CamView3P,
                CameraBaseOffset=(X=-50,Z=-40),
                CameraOffset=-375,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
                )}
                
    Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
                CameraTag=CamView3P,
                bSeatVisible=false,
                CameraBaseOffset=(Z=-20),
                CameraOffset=-400,
                )}

//  TurretPassengerIndex = 1

	//Heroic_MuzzleFlash = ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P'
	//Snd_FiringAmbient_Heroic = SoundCue'RX_WP_LaserChaingun.Sounds.SC_LaserChainGun_Fire_Loop'
//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\

    DrivingPhysicalMaterial=PhysicalMaterial'RX_VH_Buggy.Materials.PhysMat_BuggyDriving'
    DefaultPhysicalMaterial=PhysicalMaterial'RX_VH_Buggy.Materials.PhysMat_Buggy'
	
    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.P_MuzzleFlash_50Cal_Looping',EffectSocket="Fire_01")
    VehicleEffects(1)=(EffectStartTag="MainGun",EffectEndTag="STOP_MainGun",bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.P_ShellCasing_Looping',EffectSocket="ShellCasingSocket")
    VehicleEffects(2)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageSocket01)
    VehicleEffects(3)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_SteamSmoke',EffectSocket=DamageSocket02)
    VehicleEffects(4)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.GenericExhaust',EffectSocket=Exhaust_01)
    VehicleEffects(5)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.GenericExhaust',EffectSocket=Exhaust_02)

    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_VH_Buggy.Effects.P_Explosion_Vehicle')
    BigExplosionSocket=VH_Death

	DamageMorphTargets(0)=(InfluenceBone=MT_Buggy_Front,MorphNodeName=MorphNodeW_Front,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage1))
    DamageMorphTargets(1)=(InfluenceBone=MT_Buggy_Left,MorphNodeName=MorphNodeW_Left,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage2))
    DamageMorphTargets(2)=(InfluenceBone=MT_Buggy_Right,MorphNodeName=MorphNodeW_Right,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage3))
    DamageMorphTargets(3)=(InfluenceBone=MT_Buggy_Rear,MorphNodeName=MorphNodeW_Rear,LinkedMorphNodeName=none,Health=40,DamagePropNames=(Damage4))

    DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=2.0)
    DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=2.0)
    DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=2.0)
    DamageParamScaleLevels(3)=(DamageParamName=Damage4,Scale=0.1)
	
//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\

    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'Ren_VH_Nod_Buggy.Sounds.SC_Buggy_Idle'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);
    
    Begin Object Class=AudioComponent name=FiringmbientSoundComponent
        bShouldRemainActiveIfDropped=true
        bStopWhenOwnerDestroyed=true
        SoundCue=SoundCue'Ren_VH_GDI_HummVee.Sounds.SC_HummVee_Fire'
    End Object
    FiringAmbient=FiringmbientSoundComponent
    Components.Add(FiringmbientSoundComponent)
    
    FiringStopSound=SoundCue'RX_VH_Buggy.Sounds.SC_Buggy_Fire_Stop'

    EnterVehicleSound=SoundCue'Ren_VH_Nod_Buggy.Sounds.SC_Buggy_Start'
    ExitVehicleSound=SoundCue'Ren_VH_Nod_Buggy.Sounds.SC_Buggy_Stop'
	
	ExplosionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Explode_Small'

    SquealThreshold=0.1
    SquealLatThreshold=0.02
    LatAngleVolumeMult = 30.0
    EngineStartOffsetSecs=2.0
    EngineStopOffsetSecs=1.0
	
	Begin Object Class=AudioComponent Name=ScorpionSquealSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_TireSlide'
	End Object
	SquealSound=ScorpionSquealSound
	Components.Add(ScorpionSquealSound);
	
	Begin Object Class=AudioComponent Name=ScorpionTireSound
		SoundCue=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireDirt'
	End Object
	TireAudioComp=ScorpionTireSound
	Components.Add(ScorpionTireSound);
	
	TireSoundList(0)=(MaterialType=Dirt,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireDirt')
	TireSoundList(1)=(MaterialType=Foliage,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireFoliage')
	TireSoundList(2)=(MaterialType=Grass,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireGrass')
	TireSoundList(3)=(MaterialType=Metal,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireMetal')
	TireSoundList(4)=(MaterialType=Mud,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireMud')
	TireSoundList(5)=(MaterialType=Snow,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireSnow')
	TireSoundList(6)=(MaterialType=Stone,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireStone')
	TireSoundList(7)=(MaterialType=Water,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireWater')
	TireSoundList(8)=(MaterialType=Wood,Sound=SoundCue'RX_SoundEffects.Vehicle.SC_VehicleSurface_TireWood')


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

Begin Object class=Rx_Vehicle_Buggy_Wheel Name=L_Wheel_1
      BoneName="Wheel_L_01"
      SkelControlName="Wheel_L_Control_01"
      SteerFactor=1
      WheelRadius=32
   End Object
   Wheels(0)=L_Wheel_1

   Begin Object class=Rx_Vehicle_Buggy_Wheel Name=L_Wheel_2
      BoneName="Wheel_L_02"
      SkelControlName="Wheel_L_Control_02"
      SteerFactor=0
      WheelRadius=32
	  LongSlipFactor=2.4
	  LatSlipFactor=2.4
      HandbrakeLongSlipFactor=0.4
      HandbrakeLatSlipFactor=0.4
   End Object
   Wheels(1)=L_Wheel_2

   Begin Object class=Rx_Vehicle_Buggy_Wheel Name=R_Wheel_1
      BoneName="Wheel_R_01"
      SkelControlName="Wheel_R_Control_01"
      SteerFactor=1
      WheelRadius=32
   End Object
   Wheels(2)=R_Wheel_1

   Begin Object class=Rx_Vehicle_Buggy_Wheel Name=R_Wheel_2
      BoneName="Wheel_R_02"
      SkelControlName="Wheel_R_Control_02"
	  SteerFactor=0
      WheelRadius=32
	  LongSlipFactor=2.4
	  LatSlipFactor=2.4
      HandbrakeLongSlipFactor=0.4
      HandbrakeLatSlipFactor=0.4
   End Object
   Wheels(3)=R_Wheel_2

   UIString="Buggy"
}