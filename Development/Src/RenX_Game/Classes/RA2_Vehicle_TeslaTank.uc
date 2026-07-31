/*********************************************************
*
* File: RA2_Vehicle_TeslaTank.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class RA2_Vehicle_TeslaTank extends Rx_Vehicle_Treaded
    placeable;

var float ChainRadius_Inf, ChainRadius_V; 
var ParticleSystem ChainLightningPS, HeroicChainLightningPS;

struct LightningChain 
{
    var vector SourceVector ; 
    var vector TargetVector;
};

var repnotify LightningChain PrimaryChainTarget, SecondaryChainTarget; 

var int MaxChains; 
var float PrimaryChainDamagePct, SecondaryChainDamagePct; 


replication {
    if(bNetDirty)
        PrimaryChainTarget, SecondaryChainTarget;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'PrimaryChainTarget')
    {
        if(PrimaryChainTarget.TargetVector != vect(0,0,0))
        {
            DrawLightningChain(PrimaryChainTarget.SourceVector, PrimaryChainTarget.TargetVector);
        }
    } 
	else if (VarName == 'SecondaryChainTarget')
	{
        if(PrimaryChainTarget.TargetVector != vect(0,0,0))
        {
            DrawLightningChain(SecondaryChainTarget.SourceVector, SecondaryChainTarget.TargetVector);
        }
    }
    else 
        super.ReplicatedEvent(VarName); 
}

function ProcessLightningChains(float StartingDamage, class<DamageType> DmgType  ,Controller OwningController, Actor HitActor)
{
    local Pawn P;
    local float DamagePct; 
    local int ChainNum; 

    if(Rx_Pawn(HitActor) != none)
    {
        foreach HitActor.VisibleCollidingActors(class'Pawn', P, ChainRadius_Inf, HitActor.location, true,,true)
        {
            if(ChainNum >= MaxChains)
            {
                bNetDirty = true; 
                bForceNetUpdate = true;
                return;
            }

            if(P.GetTeamNum() == LastTeamToUse || P == Driver)
                continue; 

            if(ChainNum == 0)
            {
                SetPrimaryChainTarget(HitActor, P); 
                DamagePct = PrimaryChainDamagePct; 
            }
            else
            {
                SetSecondaryChainTarget(HitActor, P); 
                DamagePct = SecondaryChainDamagePct; 
            }

            P.TakeDamage( StartingDamage * DamagePct, OwningController, P.location, vect(0,0,0), DmgType,, self);

            if(WorldInfo.NetMode != NM_DedicatedServer)
                DrawLightningChain(HitActor.location, P.location);

            ChainNum++; 
        }
    }
    else if(Rx_Vehicle(HitActor) != none)
    {
        foreach HitActor.VisibleCollidingActors(class'Pawn', P, ChainRadius_V, HitActor.location, true,,true)
        {
            if(ChainNum >= MaxChains)
            {
                bNetDirty = true; 
                bForceNetUpdate = true;
                return;
            }

            if(P.GetTeamNum() == LastTeamToUse || P == self)
                continue; 

            if(ChainNum == 0)
            {
                SetPrimaryChainTarget(HitActor, P); 
                DamagePct = PrimaryChainDamagePct; 
            }
            else
            {
                SetSecondaryChainTarget(HitActor, P); 
                DamagePct = SecondaryChainDamagePct; 
            }

            P.TakeDamage(StartingDamage * DamagePct, OwningController, P.location, vect(0,0,0), DmgType,, self);
            
            if(WorldInfo.NetMode != NM_DedicatedServer)
                DrawLightningChain(HitActor.location, P.location);

            ChainNum++; 
        }
    }
    
    bNetDirty = true; 
    bForceNetUpdate = true;
    return;
} 

simulated function DrawLightningChain(vector SourceVector, vector ChainedVector)
{
    local ParticleSystemComponent LightningEmitter; 

    if(GetVRank() >= 9 && HeroicChainLightningPS != none)
    {
        LightningEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(HeroicChainLightningPS, SourceVector, rotation,self);
        LightningEmitter.SetVectorParameter('BeamEnd', ChainedVector);
    }
    else if(ChainLightningPS  != none)
    {
        LightningEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(ChainLightningPS, SourceVector, rotation,self);
        LightningEmitter.SetVectorParameter('BeamEnd', ChainedVector);
    }
}

function SetPrimaryChainTarget(Actor Source, Actor Target)
{
    PrimaryChainTarget.SourceVector = Source.location;
    PrimaryChainTarget.TargetVector = Target.location; 
}

function SetSecondaryChainTarget(Actor Source, Actor Target)
{
    SecondaryChainTarget.SourceVector = Source.location;
    SecondaryChainTarget.TargetVector = Target.location; 
}

DefaultProperties
{
//========================================================\\
//************** Vehicle Physics Properties **************\\
//========================================================\\

    bRotateCameraUnderVehicle=true
    bSecondaryFireTogglesFirstPerson=true
    Health=800
    MaxDesireability=0.8
    MomentumMult=0.7
    bCanFlip=False
    bTurnInPlace=True
    bSeparateTurretFocus=True
    CameraLag=0.15 //0.4
    LookForwardDist=350
    GroundSpeed=500
    MaxSpeed=1000
    LeftStickDirDeadZone=0.1
    TurnTime=15
    ViewPitchMin=-13000
    HornIndex=0
    COMOffset=(x=18.0,y=0.0,z=-100.0) //5
	
	SprintTrackTorqueFactorDivident=1.10//0.975

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

    Heroic_MuzzleFlash = ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_MuzzleFlash_Heroic'

    Begin Object Class=SVehicleSimTank Name=SimObject

        bClampedFrictionModel=true

        WheelSuspensionStiffness=330
        WheelSuspensionDamping=45.0
        WheelSuspensionBias=0.1

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
        MaxEngineTorque=6000
        End Object
    SimObj=SimObject
    Components.Add(SimObject)


//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\


    Begin Object name=SVehicleMesh
        SkeletalMesh=SkeletalMesh'RA2_VH_TeslaTank.Meshes.RA2_VH_TeslaTank'
        AnimTreeTemplate=AnimTree'RA2_VH_TeslaTank.Animations.AT_VH_TeslaTank'
        PhysicsAsset=PhysicsAsset'RA2_VH_TeslaTank.RA2_VH_TeslaTank_Physics'
        Materials(0)=MaterialInstanceConstant'RA2_VH_TeslaTank.Materials.MI_VH_TeslaTank_RenX'
    End Object

    DrawScale=1.0
	
	SkeletalMeshForPT=SkeletalMesh'RA2_VH_TeslaTank.Meshes.RA2_VH_TeslaTank'
	VehicleIconTexture=Texture2D'RA2_VH_TeslaTank.Textures.T_VehicleIcon_TeslaTank'
	MinimapIconTexture=Texture2D'RA2_VH_TeslaTank.T_Minimapicon_TeslaTank'


//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\

    Seats(0)={(GunClass=class'RA2_Vehicle_TeslaTank_Weapon',
                GunSocket=(Fire01,Fire02),
                TurretControls=(TurretPitch,TurretRotate),
                GunPivotPoints=(MainTurretYaw,MainTurretPitch),
                CameraTag=CamView3P,
                CameraBaseOffset=(Z=50),
                CameraOffset=-700,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=class'APB_Light_TeslaTank_MuzzleFlash'
                )}
                
	Seats(1)={( GunClass=none,
				TurretVarPrefix="Passenger",
				CameraTag=CamView3P,
				CameraBaseOffset=(Z=20),
				CameraOffset=-460,
				)}

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\


    LeftTeadIndex     = 2
    RightTreadIndex   = 1

    DrivingPhysicalMaterial= none //PhysicalMaterial'RA2_VH_TeslaTank.Materials.PhysMat_TeslaTank_Driving'
    DefaultPhysicalMaterial=PhysicalMaterial'RA2_VH_TeslaTank.Materials.PhysMat_TeslaTank'

    RecoilTriggerTag = "MainGun"
    VehicleEffects(0)=(EffectStartTag="MainGun",EffectTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_MuzzleFlash',EffectSocket="Fire01")
	VehicleEffects(1)=(EffectStartTag="MainGun",EffectTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_MuzzleFlash',EffectSocket="Fire02")
    VehicleEffects(2)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Exhaust',EffectSocket="ExhaustEffectLeft")
    VehicleEffects(3)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Exhaust',EffectSocket="ExhaustEffectLRight")
    VehicleEffects(4)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Generator',EffectSocket="GeneratorEffect")
    VehicleEffects(5)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Startup',EffectSocket="ExhaustEffectLeft")
    VehicleEffects(6)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bRestartRunning=false,EffectTemplate=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Startup',EffectSocket="ExhaustEffectLRight")

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
	
    BigExplosionTemplates[0]=(Template=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Huge')
    BigExplosionSocket=VH_Death

//========================================================\\
//*************** Vehicle Audio Properties ***************\\
//========================================================\\


    Begin Object Class=AudioComponent Name=ScorpionEngineSound
        SoundCue=SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_IdleCue'
    End Object
    EngineSound=ScorpionEngineSound
    Components.Add(ScorpionEngineSound);
   
    EnterVehicleSound=SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_startCue'
    ExitVehicleSound=SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_StopCue'


//========================================================\\
//******** Vehicle Wheels & Suspension Properties ********\\
//========================================================\\

     Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RB_Wheel_01
        BoneName="Wheel_RB_01"
        SkelControlName="Wheel_RB_01_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(0)=RB_Wheel_01

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RB_Wheel_02
        BoneName="Wheel_RB_02"
        SkelControlName="Wheel_RB_02_Cont"
        Side=SIDE_Right
    End Object
    Wheels(1)=RB_Wheel_02

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RB_Wheel_03
        BoneName="Wheel_RB_03"
        SkelControlName="Wheel_RB_03_Cont"
        Side=SIDE_Right
    End Object
    Wheels(2)=RB_Wheel_03

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RB_Wheel_04
        BoneName="Wheel_RB_04"
        SkelControlName="Wheel_RB_04_Cont"
        Side=SIDE_Right
    End Object
    Wheels(3)=RB_Wheel_04

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RB_Wheel_05
        BoneName="Wheel_RB_05"
        SkelControlName="Wheel_RB_05_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(4)=RB_Wheel_05

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LB_Wheel_01
        BoneName="Wheel_LB_01"
        SkelControlName="Wheel_LB_01_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(5)=LB_Wheel_01

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LB_Wheel_02
        BoneName="Wheel_LB_02"
        SkelControlName="Wheel_LB_02_Cont"
        Side=SIDE_Left
    End Object
    Wheels(6)=LB_Wheel_02

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LB_Wheel_03
        BoneName="Wheel_LB_03"
        SkelControlName="Wheel_LB_03_Cont"
        Side=SIDE_Left
    End Object
    Wheels(7)=LB_Wheel_03

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LB_Wheel_04
        BoneName="Wheel_LB_04"
        SkelControlName="Wheel_LB_04_Cont"
        Side=SIDE_Left
    End Object
    Wheels(8)=LB_Wheel_04

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LB_Wheel_05
        BoneName="Wheel_LB_05"
        SkelControlName="Wheel_LB_05_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(9)=LB_Wheel_05


    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LT_Wheel_Front
        BoneName="Wheel_LT_Front"
        SkelControlName="Wheel_LT_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(10)=LT_Wheel_Front

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=LT_Wheel_Rear
        BoneName="Wheel_LT_Rear"
        SkelControlName="Wheel_LT_Cont"
        Side=SIDE_Left
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(11)=LT_Wheel_Rear

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RT_Wheel_Front
        BoneName="Wheel_RT_Front"
        SkelControlName="Wheel_RT_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(12)=RT_Wheel_Front

    Begin Object Class=RA2_Vehicle_TeslaTank_Wheel Name=RT_Wheel_Rear
        BoneName="Wheel_RT_Rear"
        SkelControlName="Wheel_RT_Cont"
        Side=SIDE_Right
        LongSlipFactor=1.0
        VPushLongSlip = 0.15
    End Object
    Wheels(13)=RT_Wheel_Rear

    WeightResistance = (X=0.0,Y=0.0,Z=-30000)
    PushTorqueMult = 0.40

    PushCheckMax = (X=188,Y=-120,Z=-50)
	PushCheckVWidth = (X=0,Y=240,Z=0)
	PushCheckVLength = (X=370,Y=0,Z=0)

    bOverrideDevHorn = true
    HornSounds[0]=SoundCue'RA2_VH_TeslaTank.Sounds.SN_RA2TeslaTank_Horn_Cue'

    ChainLightningPS = ParticleSystem'RA2_VH_TeslaTank.Effects.P_Lightning'
    HeroicChainLightningPS = ParticleSystem'RA2_VH_TeslaTank.Effects.P_Lightning_Heroic'
    MaxChains = 2
    PrimaryChainDamagePct = 0.5
    SecondaryChainDamagePct = 0.5
    ChainRadius_Inf = 800
    ChainRadius_V = 800
}
