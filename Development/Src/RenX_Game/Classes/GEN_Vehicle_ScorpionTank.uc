/*********************************************************
*
* File: Gen_Vehicle_ScorpionTank.uc
* Author: RenegadeX-Team
* Pojekt: Renegade-X UDK <www.renegade-x.com>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Gen_Vehicle_ScorpionTank extends Rx_Vehicle_Treaded
    placeable;


/** Firing sounds */
var() AudioComponent FiringAmbient;
var() SoundCue FiringStopSound;
var repnotify bool bPlayingAmbientFireSound;
var const name RocketBoneName;
var repnotify bool bShowMissile; 

/** The Cantilever Beam that is the Antenna itself*/
var UTSkelControl_CantileverBeam AntennaBeamControl;

var GameSkelCtrl_Recoil   Recoil_L, Recoil_Rocket_R;

replication
{
    if (bNetDirty && !bNetOwner)
		bPlayingAmbientFireSound;

    if (bNetDirty || bNetInitial)
        bShowMissile;
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
    else if (VarName == 'bShowMissile')
    {   
        UpdateMissileBone(bShowMissile);
    }
    else 
	    super.ReplicatedEvent(VarName);
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

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
    Super.PostInitAnimTree(SkelComp);

    if (SkelComp == Mesh)
    {
        Recoil_L = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil') );

        Recoil_Rocket_R = GameSkelCtrl_Recoil( mesh.FindSkelControl('Recoil_Rocket') );
    }
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
   local Name FireTriggerTag;

   Super.VehicleWeaponFireEffects(HitLocation, SeatIndex);

   //`Log("VehicleWeaponFireEffects called",, '_Mammoth_Debug');
   FireTriggerTag = Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)];

   if(MainWeapon != None) {
       if (MainWeapon.CurrentFireMode == 0)
       {
           switch(FireTriggerTag)
          {
          case 'FireL':
             Recoil_L.bPlayRecoil = TRUE;
             break;
          }
       }
       else
       {
          switch(FireTriggerTag)
          {
          case 'AltFireR':
             Recoil_Rocket_R.bPlayRecoil = TRUE;
             break;
          }
       }
   }
}

simulated function UpdateMissileBone(bool bVisible)
{
    if(bVisible)
        Mesh.UnHideBoneByName('b_RocketPod_Fire');
    else
        Mesh.HideBoneByName('b_RocketPod_Fire', PBO_None);
    
    Mesh.ForceSkelUpdate();
}

simulated function SetShowMissile(bool bNewMissile)
{
    bShowMissile = bNewMissile;
    UpdateMissileBone(bShowMissile);

    if(ROLE != ROLE_Authority)
    {
        ServerSetShowMissile(bNewMissile);
    }
}

reliable server function ServerSetShowMissile(bool bNewMissile)
{
    if(bShowMissile == bNewMissile)
        return; 
    
    bShowMissile = bNewMissile;
    ForceNetRelevant();
    UpdateMissileBone(bNewMissile);
}

DefaultProperties
{
    RocketBoneName = b_RocketPod_Fire

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
    Health=600
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
    COMOffset=(x=-25.0,y=0.0,z=-55.0)
	
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
	VetRankInfo(0) = (VPReward = 6, HealthMod = 1.0, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(1) = (VPReward = 6, HealthMod = 1.025, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 
	VetRankInfo(2) = (VPReward = 6, HealthMod = 1.065, SprintspeedMod = 1.0, SprintTTFDMod = 0.0) 

	//VETERAN
	VetRankInfo(3) = (VPReward = 8, HealthMod = 1.125, SprintspeedMod = 1.10, SprintTTFDMod = 0.10) 
	VetRankInfo(4) = (VPReward = 8, HealthMod = 1.15, SprintspeedMod = 1.10, SprintTTFDMod = 0.10) 
	VetRankInfo(5) = (VPReward = 8, HealthMod = 1.19, SprintspeedMod = 1.10, SprintTTFDMod = 0.10) 

	//ELITE
	VetRankInfo(6) = (VPReward = 10, HealthMod = 1.25, SprintspeedMod = 1.20, SprintTTFDMod = 0.20) 
	VetRankInfo(7) = (VPReward = 10, HealthMod = 1.275, SprintspeedMod = 1.20, SprintTTFDMod = 0.20) 
	VetRankInfo(8) = (VPReward = 10, HealthMod = 1.315, SprintspeedMod = 1.20, SprintTTFDMod = 0.20) 

	//HEROIC
	VetRankInfo(9) = (VPReward = 13, HealthMod = 1.375, SprintspeedMod = 1.30, SprintTTFDMod = 0.30) 
	
	/******************/

/**********************/
	
    Begin Object Class=SVehicleSimTank Name=SimObject

        bClampedFrictionModel=true

        WheelSuspensionStiffness=200 //57.0 //40
        WheelSuspensionDamping=20.0 //2.0
        WheelSuspensionBias=0.25

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
        EngineDamping=2
        InsideTrackTorqueFactor=0.375
        TurnInPlaceThrottle=0.285
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
        SkeletalMesh=SkeletalMesh'Gen_VH_ScorpionTank.Mesh.SK_VH_ScorpionTank'
        AnimTreeTemplate=AnimTree'Gen_VH_ScorpionTank.Anims.AT_VH_ScorpionTank'
        PhysicsAsset=PhysicsAsset'Gen_VH_ScorpionTank.Mesh.SK_VH_ScorpionTank_Physics'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'Gen_VH_ScorpionTank.Mesh.SK_VH_ScorpionTank'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\


    Seats(0)={(GunClass=class'Gen_Vehicle_ScorpionTank_Weapon',
                GunSocket=("FireL", "AltFireR"),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(b_Turret_Yaw,b_Turret_Pitch),
                CameraTag=CamView3P,
				SeatBone=b_root,
				SeatSocket=VH_Death,
                CameraBaseOffset=(Z=20),
                CameraOffset=-460,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'Rx_Light_Tank_MuzzleFlash'
                )}
                
	Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
				CameraTag=CamView3P,
				CameraBaseOffset=(Z=20),
				CameraOffset=-460,
				)}

//  TurretPassengerIndex = 1

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


    LeftTeadIndex     = 1
    RightTreadIndex   = 2

    DrivingPhysicalMaterial=none //PhysicalMaterial'Gen_VH_ScorpionTank.Materials.PhysMat_ScorpionTank_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'Gen_VH_ScorpionTank.Materials.PhysMat_ScorpionTank'

    RecoilTriggerTag = "FireL"
    VehicleEffects(0)=(EffectStartTag="FireL",EffectTemplate=ParticleSystem'RX_VH_MediumTank.Effects.MuzzleFlash',EffectSocket="MuzzleFlashSocket")
    VehicleEffects(1)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_FX_Vehicle.Damage.P_EngineFire',EffectSocket=DamageFire01)
    VehicleEffects(2)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.GenericExhaust',EffectSocket=Exhaust_01)
    VehicleEffects(3)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RX_VH_Humvee.Effects.GenericExhaust',EffectSocket=Exhaust_02)
	VehicleEffects(4)=(EffectStartTag="AltFireR",EffectTemplate=ParticleSystem'RX_VH_M2Bradley.Effects.P_MuzzleFlash_Rocket',EffectSocket="AltFireR")
	
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
	
    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_VH_MediumTank.Effects.P_Explosion_Vehicle')
    BigExplosionSocket=VH_Death

    VehicleIconTexture=Texture2D'Gen_VH_ScorpionTank.Textures.VehicleIcon_Scorpion'


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
		SoundCue=SoundCue'RX_VH_MediumTank.Sounds.SC_MediumTank_MG'
    End Object
    FiringAmbient=FiringmbientSoundComponent
    Components.Add(FiringmbientSoundComponent)
    
    FiringStopSound=SoundCue'RX_VH_Humvee.Sounds.SC_Humvee_Fire_Stop' //SoundCue'RX_VH_MediumTank.Sounds.SC_MediumTank_MG_Stop'


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RG_Wheel_01
        BoneName="b_Wheel_RG_01"
        SkelControlName="Wheel_RG_01_Cont"
        Side=SIDE_Right
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    
    Wheels(0)=RG_Wheel_01

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RG_Wheel_02
        BoneName="b_Wheel_RG_02"
        SkelControlName="Wheel_RG_02_Cont"
        Side=SIDE_Right
    End Object
    Wheels(1)=RG_Wheel_02

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RG_Wheel_03
        BoneName="b_Wheel_RG_03"
        SkelControlName="Wheel_RG_03_Cont"
        Side=SIDE_Right
    End Object
    Wheels(2)=RG_Wheel_03

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RG_Wheel_04
        BoneName="b_Wheel_RG_04"
        SkelControlName="Wheel_RG_04_Cont"
        Side=SIDE_Right
    End Object
    Wheels(3)=RG_Wheel_04

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RG_Wheel_05
        BoneName="b_Wheel_RG_05"
        SkelControlName="Wheel_RG_05_Cont"
        Side=SIDE_Right
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(4)=RG_Wheel_05

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=LG_Wheel_01
        BoneName="b_Wheel_LG_01"
        SkelControlName="Wheel_LG_01_Cont"
        Side=SIDE_Left
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(5)=LG_Wheel_01

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=LG_Wheel_02
        BoneName="b_Wheel_LG_02"
        SkelControlName="Wheel_LG_02_Cont"
        Side=SIDE_Left
    End Object
    Wheels(6)=LG_Wheel_02

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=LG_Wheel_03
        BoneName="b_Wheel_LG_03"
        SkelControlName="Wheel_LG_03_Cont"
        Side=SIDE_Left
    End Object
    Wheels(7)=LG_Wheel_03

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=LG_Wheel_04
        BoneName="b_Wheel_LG_04"
        SkelControlName="Wheel_LG_04_Cont"
        Side=SIDE_Left
    End Object
    Wheels(8)=LG_Wheel_04

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=LG_Wheel_05
        BoneName="b_Wheel_LG_05"
        SkelControlName="Wheel_LG_05_Cont"
        Side=SIDE_Left
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(9)=LG_Wheel_05

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=FL_Wheel
        BoneName="b_Wheel_FL"
        SkelControlName="Wheel_FL_Cont"
        Side=SIDE_Left
        LongSlipFactor = 1.0
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(10)=FL_Wheel

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RL_Wheel
        BoneName="b_Wheel_RL"
        SkelControlName="Wheel_RL_Cont"
        Side=SIDE_Left
        LongSlipFactor = 1.0
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(11)=RL_Wheel

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=FR_Wheel
        BoneName="b_Wheel_FR"
        SkelControlName="Wheel_FR_Cont"
        Side=SIDE_Right
        LongSlipFactor = 1.0
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(12)=FR_Wheel

    Begin Object Class=Gen_Vehicle_ScorpionTank_Wheel Name=RR_Wheel
        BoneName="b_Wheel_RR"
        SkelControlName="Wheel_RR_Cont"
        Side=SIDE_Right
        LongSlipFactor = 1.0
        VPushLongSlip = 0.15 //Long Slip when pushing a vehicle
    End Object
    Wheels(13)=RR_Wheel

    bOverrideDevHorn = true
    HornDelay = 5.0
    HornSounds[0]=SoundCue'Gen_VH_ScorpionTank.Sounds.SN_Scorpion_Horn_Cue'
    
    WeightResistance = (X=0,Y=0,Z=-20000)
    PushTorqueMult = 0.25 //2000

    PushCheckMax = (X=140,Y=-107,Z=-50)
	PushCheckVWidth = (X=0,Y=212,Z=0)
	PushCheckVLength = (X=300,Y=0,Z=0)
    PushCheckExtent = (X=1,Y=1,Z=20)

	MinimapIconTexture=Texture2D'Gen_VH_ScorpionTank.UI.T_MinimapIcon_Scorpion'
}
