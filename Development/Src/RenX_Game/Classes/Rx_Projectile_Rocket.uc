class Rx_Projectile_Rocket extends Rx_Projectile
	abstract;

var repnotify vector Target;
var bool bDontLockAnymore;

//Test stuff 
var ParticleSystem 					TargetMarker ; 

var bool bIgnoreOptimizationChecks;

struct Stage {
	var int Stage_AccelRate;
	var float Stage_HomingStrength;
	var float Stage_BaseTrackingStrength;
	var int Stage_MaxSpeed; 
	
	/*Use for timed stage*/
	var float Stage_Time; //Time this stage should last

	/*Use for vector based stages*/
	var float Stage_MorphDistance; /*How close we need to get to our target vector before calling the next stage*/ 
	
	var float Stage_DamageMultiplier; /*Useful for making early stages do less damage... as the weapon wouldn't be properly armed and ired */
	
	/*True target location + this vector will be where the missile flies toward (E.g: +10000 Z will force the missile to fly well above the target)*/
	var vector Stage_TargetOffset; 
	
	var bool   bSeekFinalTarget; //If true, it will seek our actual target in this stage (Incase you want another stage if the missile misses)
	var bool   bIgnoreHoming; /*Ignores all acceleration created by homing and just does its own thing. Use for initial stages, or to make missiles do loops and whatnot*/
	
	/*If bIgnoreHoming is true, we look to these*/
	var rotator DirToGo;
	var vector DirectionSpread; //Set to non-zeros to have 
	
	var SoundCue Stage_TransitionSound; 
	
	structdefaultProperties
	{
		Stage_Time = 0; 
		Stage_DamageMultiplier = 1.0; 
	}
};

var array<Stage> RocketStages; /*If there are no stages, then the behaviour is ignored. */
var byte CurrentStage; /*Should never be more than 255 stages I'd assume... unless you want to do something stupid */ 

/*Modifier for rocket stages that allows vehicle weapons to multiply yaw values. Example: The HMRLS can make their rockets' initial stage veer left or right depending on which launcher bay the rocket spawned from */
var float YawModifier; 

/*Replacement for Seek target that doesn't enforce native code execution when set*/
var Actor FinalSeekTarget; 
var bool  bInitialTargetSet; //Used to see if this is the 1st Target being replicated

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	bImportantAmbientSound = !WorldInfo.bDropDetail;

	if(bWaitForEffectsAtEndOfLifetime) {
		SetTimer(LifeSpan,false,'ShutDownBeforeEndOfLife');
		LifeSpan += 0.5;
	}

}

replication
{
	
    if (Role == ROLE_Authority && (bNetDirty || bNetInitial))
        Target, FinalSeekTarget;/*We actually need Final seek target, as SeekTarget links back to native code and needs to be set to none occasionally for multi-stage rockets*/
	
	/**if(bNetDirty)
		CurrentStage;*/

}

simulated function ReplicatedEvent(name VarName)
{
	if (VarName == 'Target')
	{
		//`log("-----Target Replicated----" @ Target); 
      	ClientAdjustState();
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
}

/**if(VarName == 'CurrentStage')
	{
		`log("Replicate Current Stage" @ CurrentStage);
		GotoNextStage(); 
	}*/
	
/**
 * Initialize the Projectile [RX] Add modifiers for veterancy
 */
 simulated event SetInitialState()
{
	super(UTProjectile).SetInitialState();
}
 
function Init(vector Direction)
{
	local Rx_Weapon Rx_Inst; 
	local Rx_Vehicle_Weapon Rx_VInst;
	local Rx_PassiveAbility_Weapon Rx_PInst;
	
	Rx_Inst=Rx_Weapon(Instigator.Weapon);
	
	Rx_VInst=Rx_Vehicle_Weapon(Instigator.Weapon) ;
	
	Rx_PInst=Rx_PassiveAbility_Weapon(MyWeaponInstigator) ;
	
	if(Rx_Inst != none)
	{
		VRank=Rx_Inst.VRank; 
		YawModifier = Rx_Inst.GetRProjectileYaw();
	}			
	else
	if(Rx_VInst != none) 
	{
		VRank=Rx_VInst.VRank; 
		YawModifier = Rx_VInst.GetRProjectileYaw();
	}
	else
	if(Rx_PInst != none) 
	{
		VRank=Rx_PInst.VRank; 
		YawModifier = Rx_PInst.GetRProjectileYaw();
	}	
	
	SetRotation(rotator(Direction));
	
	Velocity = (Speed*VetRankInfo[VRank].SpeedModifier) * Direction;
	
	Velocity.Z += TossZ;
	
	Acceleration = AccelRate * Normal(Velocity);
	
	//`log("INIT"); 
	
	if(RocketStages.Length == 0)
	{
		MaxSpeed = default.MaxSpeed*VetRankInfo[VRank].SpeedModifier ; 
	}
	else
	{
		CurrentStage = 0; 
		
		SetRocketStageParameters(); 
	}
	
}

simulated function ShutDownBeforeEndOfLife() 
{
	
	if ( !bShuttingDown )
		{
			HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, location,,,false); 
		}
	
	if(AmbientSound != none)
		CleanupAmbientSound();
	
	Shutdown();
}

simulated function ClientAdjustState()
{
	if(!bInitialTargetSet && RocketStages.Length > 0)
	{
		SetRocketStageParameters();
		bInitialTargetSet = true;
		GotoState('Homing');		
	}
	else
		GotoState('Homing');
		
	
}

simulated state Homing
{
	simulated function Timer()
	{
		local vector TargetLocation;
		local bool bDontLock;
		local bool bUsingStages;
		
		bUsingStages = RocketStages.Length > 0; 
		
		//`log("Target/Stage" @ Target @ SeekTarget @ "/" @ FinalSeekTarget); //Acceleration.Z @ AccelRate);
		
		if(bUsingStages && RocketStages[CurrentStage].bIgnoreHoming )
		{
			//`log("Acceleration in Homing" @ Acceleration);
			return; 
		}
			
		if(bDontLockAnymore) {
			//`log("Don't lock anymore");
			return;
		}
		
		/*Initial Target Location, whether we have stages or not*/
		
		if(!bUsingStages)
			{
				if(FinalSeekTarget != none) {
					TargetLocation = FinalSeekTarget.GetTargetLocation();
				} else {
					TargetLocation = Target ;		
				}	
			}
			else {
				//If we use stages then we actually need some damn replication I guess
				if(FinalSeekTarget != none) {
					TargetLocation = ROLE == ROLE_Authority ? FinalSeekTarget.GetTargetLocation() + RocketStages[CurrentStage].Stage_TargetOffset : FinalSeekTarget.GetTargetLocation() ;
					//`log("Target Location:" @ TargetLocation);
					Target = TargetLocation;
				} else {
					TargetLocation = Target + RocketStages[CurrentStage].Stage_TargetOffset + GetRocketSpread();
					//`log("Stage:" @ CurrentStage @ "Target Location:" @ TargetLocation.Z);					
				}
			}
			
			//`log("Target/Stage" @ Target @ CurrentStage);
		
		//`log( "Orientation: " @ class'Rx_Utils'.static.OrientationOfLocAndRotToBLocation(Location,Rotation,TargetLocation) );
		/* else we already are past the target EDIT: Also tear off if we're EXTREMELY close, so we don't try and straight up stop*/
		if((!bUsingStages || CurrentStage == RocketStages.Length-1) && class'Rx_Utils'.static.OrientationOfLocAndRotToBLocation(Location,Rotation,TargetLocation) < 0.0){ // || VSizeSq(TargetLocation - Location) < MaxSpeed*0.5) { 
			bDontLock = true;	
		}
		/**if(GetTimerCount('ShutDownBeforeEndOfLife',self) < 2.0)
			bDontLock = false;*/	
		
		if(!bDontLock || FinalSeekTarget != none) {
			if(RxIfc_SeekableTarget(FinalSeekTarget) != none && VSizeSq(FinalSeekTarget.Velocity) > 22500 && RxIfc_SeekableTarget(FinalSeekTarget).GetAimAheadModifier() > 0.0) { 
				TargetLocation = TargetLocation + Normal(FinalSeekTarget.Velocity) * RxIfc_SeekableTarget(FinalSeekTarget).GetAimAheadModifier();
			}
			if(RxIfc_SeekableTarget(FinalSeekTarget) != none && RxIfc_SeekableTarget(FinalSeekTarget).GetAccelrateModifier() > 0.0) { 
				
				if(bUsingStages)
					AccelRate = RocketStages[CurrentStage].Stage_AccelRate * RxIfc_SeekableTarget(FinalSeekTarget).GetAccelrateModifier();
				else
					AccelRate = default.AccelRate * RxIfc_SeekableTarget(FinalSeekTarget).GetAccelrateModifier();
			}
			
			Acceleration = HomingTrackingStrength * AccelRate * Normal(TargetLocation - Location);
		} else {
			//`log("Use Base Strength" @ bDontLock @ FinalSeekTarget); 
			Acceleration = BaseTrackingStrength * AccelRate * Normal(TargetLocation - Location);
			//Acceleration = 16.0 * Velocity;
			bDontLockAnymore = true;
		}
		
		
			if(bUsingStages && (RocketStages[CurrentStage].Stage_MorphDistance > 0 && VSizeSq(TargetLocation - Location) <= RocketStages[CurrentStage].Stage_MorphDistance*RocketStages[CurrentStage].Stage_MorphDistance)) 
			{
				GotoNextStage(); 
			}
	}

	simulated function BeginState(name PreviousStateName)
	{
		InitialState = 'Homing';
		
		if(ROLE == ROLE_Authority && FinalSeekTarget == none)
			FinalSeekTarget = SeekTarget; 
		//`log("Seek Target / Final:" @ SeekTarget @ FinalSeekTarget);
		
		if(ROLE == ROLE_Authority && RocketStages.Length > 0 && RocketStages[CurrentStage].bIgnoreHoming)
		{
			if(FinalSeekTarget != none)
				Target = FinalSeekTarget.GetTargetLocation();
			
			SeekTarget = none; 
			bNetDirty = true; 
		}
			
		Timer();
		SetTimer(0.1, true);
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local float VAdjustedDamage; //Adjusted for veterancy
	
	VAdjustedDamage=Damage*GetDamageModifier(VRank, InstigatorController);
	
	if(DamageRadius == 0.0 && Rx_BuildingAttachment_MCT(Other) != None) {
		// Some projectiles are so fast that they go through the MCT and hit the building behind it.
		// This prevents the building from taking additional damage via HitWall()
		//Destroy();
		bWaitForEffects=false;
		Explode(HitLocation,HitNormal);
	}
	
	if (DamageRadius > 0.0)
	{
		if(Rx_DestroyableObstaclePlus(Other) !=none && !Rx_DestroyableObstaclePlus(Other).bTakeRadiusDamage) // || (Rx_BasicPawn(Other) !=none && !Rx_BasicPawn(Other).bTakeRadiusDamage)) 
			Other.TakeDamage(VAdjustedDamage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);	
	}
	
    super(UTProjectile).ProcessTouch(Other, HitLocation, HitNormal);
}

simulated function bool HurtRadius( float DamageAmount,
								    float InDamageRadius,
				    				class<DamageType> DamageType,
									float Momentum,
									vector HurtOrigin,
									optional actor IgnoredActor,
									optional Controller InstigatedByController = Instigator != None ? Instigator.Controller : None,
									optional bool bDoFullDamage
									)
{
	local bool bCausedDamage, bResult;

	if ( bHurtEntry )
		return false;

	//`log("Rocket hurt radius"); 
	
	bCausedDamage = false;
	if (InstigatedByController == None)
	{
		InstigatedByController = InstigatorController;
	}

	// if ImpactedActor is set, we actually want to give it full damage, and then let him be ignored by super.HurtRadius()
	if ( (ImpactedActor != None) && (ImpactedActor != self) && Rx_Building(ImpactedActor) == None)
	{
		if(!TryHeadshot(ImpactedActor, HurtOrigin, Velocity, DamageAmount)) {
			ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, true, self);
		}
		bCausedDamage = ImpactedActor.bProjTarget;
	}

	bResult = Super(Actor).HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
	return ( bResult || bCausedDamage );
}

simulated function bool TryHeadshot(Actor Other, Vector HitLocation, Vector HitNormal, float DamageAmount, optional float DmgReduction = 1.0)
{
    local float Scaling;
    local ImpactInfo Impact;
    
    if(Worldinfo.NetMode == NM_Client) { // since Rockets dont use clientside hitdetection yet
    	return false;
    }
	
	//`log("Rocket rey "); 
	
    if (Instigator == None || VSizeSq(Instigator.Velocity) < Square(Instigator.GroundSpeed * Instigator.CrouchedPct))
    {
        Scaling = SlowHeadshotScale;
    }
    else
    {
        Scaling = RunningHeadshotScale;
    }

	DamageAmount*=GetDamageModifier(VRank, InstigatorController); 
	
    DamageAmount *= HeadShotDamageMult;
    
    Impact.HitActor = Other;
    Impact.HitLocation = HitLocation;
    Impact.HitNormal = HitNormal;
    Impact.RayDir = vector(Rotation); 
    
    if( Rx_Pawn(Other) != None )
    {
        UTPawn(Other).Mesh.ForceSkelUpdate();
        CheckHitInfo(Impact.HitInfo, UTPawn(Other).Mesh, Impact.RayDir, Impact.HitLocation);
        
       	return Rx_Pawn(Other).TakeHeadShot(Impact, MyDamageType, DamageAmount, Scaling, InstigatorController, true, GetWeaponInstigator());
    }
    
    return False;
}

simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;

	TriggerEventClass(class'SeqEvent_HitWall', Wall);
	
	if ( Wall.bWorldGeometry )
	{
		HitStaticMesh = StaticMeshComponent(WallComp);
		if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
		{
	        NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
	        if ( NewKActor != None )
			{
				Wall = NewKActor;
			}
		}
	}
	ImpactedActor = Wall;
	if ( ( !Wall.bStatic && (DamageRadius == 0) ) || ClassIsChildOf(Wall.Class,class'Rx_Building') )
	{
		Wall.TakeDamage( Damage*GetDamageModifier(VRank, InstigatorController), InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	}

	Explode(Location, HitNormal);
	ImpactedActor = None;
}

simulated function SpawnExplosionEffects(vector HitLocation, vector HitNormal)
{
	local vector NewHitLoc;
	local TraceHitInfo MyHitInfo;
	local MaterialImpactEffect ImpactEffect;	
	
	local PlayerController PC;
	local float Distance;	
		
		
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		
//		ScriptTrace();
		if(AmbientSound != none)
			CleanupAmbientSound();
		
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			Distance = VSizeSq(PC.ViewTarget.Location - HitLocation);
			 
			// dont spawn explosion effect if far away and no direct line of sight or if behind and relativly far away   
			if ( (PC.ViewTarget != None && Distance > 81000000 && !FastTrace(PC.ViewTarget.Location, HitLocation) ) 
			 		|| ( vector(PC.Rotation) dot (HitLocation - PC.ViewTarget.Location) < 0.0 && Distance > 25000000 && !FastTrace(PC.ViewTarget.Location, HitLocation)) )
			{
				
				if (ExplosionSound != None && !bSuppressSounds)
				{
					PlaySound(ExplosionSound, true);
				}
		
				bSuppressExplosionFX = true; // so we don't get called again				
				return;
			}
		}	
		
		if(ImpactedActor != None && ImpactedActor.isA('Rx_Vehicle')){
			ProjExplosionTemplate = ImpactEffects[3].ParticleTemplate;
			ExplosionSound = ImpactEffects[3].Sound;
		} else if(ImpactedActor != None && ImpactedActor.isA('Rx_Pawn')){
			ProjExplosionTemplate = ImpactEffects[8].ParticleTemplate;
			ExplosionSound = ImpactEffects[8].Sound;
			ExplosionSmokeColour = ImpactEffects[8].ImpactSmokeColour; 
		} else if(bShuttingDown && AirburstExplosionTemplate != none){
			ProjExplosionTemplate = AirburstExplosionTemplate;
			//ExplosionSound = ImpactEffects[8].Sound;
		}
		else {
			Trace(NewHitLoc, HitNormal, (HitLocation - (HitNormal * 32)), HitLocation + (HitNormal * 32), true,, MyHitInfo, TRACEFLAG_Bullet);
			ImpactEffect = GetImpactEffect(MyHitInfo.PhysMaterial);
			ProjExplosionTemplate = ImpactEffect.ParticleTemplate;
			ExplosionSmokeColour = ImpactEffect.ImpactSmokeColour; 
			ExplosionSound = ImpactEffect.Sound;
		}
	}
	super(UTProjectile).SpawnExplosionEffects(HitLocation,HitNormal);
}


simulated function SetRocketStageParameters(){
	
	//`log("SetRocket Parameters: " @ CurrentStage); 

	AccelRate = RocketStages[CurrentStage].Stage_AccelRate; 
	MaxSpeed = RocketStages[CurrentStage].Stage_MaxSpeed; 
	
	if(CurrentStage == 0)
		Speed = RocketStages[CurrentStage].Stage_MaxSpeed; 
	
	HomingTrackingStrength = RocketStages[CurrentStage].Stage_HomingStrength;
	BaseTrackingStrength = RocketStages[CurrentStage].Stage_BaseTrackingStrength;
	
	if(RocketStages[CurrentStage].bSeekFinalTarget && FinalSeekTarget != none){
		SeekTarget = FinalSeekTarget;
	}
	else
	{
		SeekTarget = none; /*Erase SeekTarget so UDK Native code doesn't interfere with missile stage code*/ 
	}
		
	
	if(RocketStages[CurrentStage].bIgnoreHoming)
	{
		//`log("Seek Target Was:" @ SeekTarget);
		if(FinalSeekTarget == none && SeekTarget != none)
		{
			FinalSeekTarget = SeekTarget; 
			SeekTarget = none;
		}

		if(ROLE < ROLE_Authority)
			YawModifier = GetYawModifier();
		
		RocketStages[CurrentStage].DirToGo.Yaw*=YawModifier;  //Usually 1.0. Can be reversed with a -1.0 
		
		RocketStages[CurrentStage].DirToGo = RocketStages[CurrentStage].DirToGo+rotation;

		//`log("Old Acceleration:" @ Acceleration);
		
		Acceleration = Acceleration + vector(RocketStages[CurrentStage].DirToGo) * 5000; //1500 just to be safe, but probably too much  ;
		
		//`log("New Acceleration:" @ Acceleration);
	}
	
	if(RocketStages[CurrentStage].Stage_Time > 0.0 && CurrentStage < RocketStages.Length){
		SetTimer(RocketStages[CurrentStage].Stage_Time, false, 'GotoNextStage'); 
	}
}

simulated function GotoNextStage()
{
	//if(ROLE == ROLE_Authority)
	CurrentStage=Min(CurrentStage+1, RocketStages.Length-1); 
	
	if(WorldInfo.NetMode != NM_DedicatedServer && RocketStages[CurrentStage].Stage_TransitionSound != none)
	{
		PlaySound(RocketStages[CurrentStage].Stage_TransitionSound, true);
	}
		
	
	SetRocketStageParameters(); 
}

simulated function SetYawModifier(float NewMod)
{
	YawModifier = NewMod; 
}

simulated function float GetYawModifier()
{
	local Rx_Weapon Rx_Inst; 
	local Rx_Vehicle_Weapon Rx_VInst;
	local Rx_PassiveAbility_Weapon Rx_PInst;
	local float rYaw; 
	
	Rx_Inst=Rx_Weapon(Instigator.Weapon);
	
	Rx_VInst=Rx_Vehicle_Weapon(Instigator.Weapon) ;
	
	Rx_PInst = Rx_PassiveAbility_Weapon(MyWeaponInstigator);
	
	if(Rx_Inst != none)
	{
		VRank=Rx_Inst.VRank; 
		rYaw = Rx_Inst.GetRProjectileYaw();
	}			
	else
	if(Rx_VInst != none) 
	{
		VRank=Rx_VInst.VRank; 
		rYaw = Rx_VInst.GetRProjectileYaw();
	}
	else
	if(Rx_PInst != none) 
	{
		VRank=Rx_PInst.VRank; 
		rYaw = Rx_PInst.GetRProjectileYaw();
	}
	
	return rYaw; 
}

event TornOff()
{
	/*Hacky: Account for multistage rockets not always being 100% in sync in netplay, and giving them time to actually hit their target visually*/ 
	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		SetTimer(0.5, false, 'Shutdown');
		Super(UDKProjectile).TornOff();
	}
		
	else
	{
		ShutDown();
		Super(UDKProjectile).TornOff();
	}
}

simulated static function float GetRange()
{
	local int i, StageLimit;
	local float NonHomingTime;
	local float FinalLifeSpan;
	local float AccelTime;
	
	if(default.RocketStages.length < 2)
		return super.GetRange();

	StageLimit = default.RocketStages.Find('bSeekFinalTarget',true);

	if(StageLimit < 0)
	{
		StageLimit = default.RocketStages.Find('bIgnoreHoming', false);
	}

	if(StageLimit > 0)
	{
		for(i = 0; i < StageLimit;i++)
		{
			if(default.RocketStages[i].bSeekFinalTarget)
			{
				NonHomingTime += default.RocketStages[i].Stage_Time;
			}
		}
	}

	FinalLifeSpan = default.LifeSpan - NonHomingTime;

	if (default.LifeSpan == 0.0)
	{
		return 15000.0;
	}
	else if (default.AccelRate == 0.0)
	{
		return (default.Speed * FinalLifeSpan);
	}
	else
	{
		AccelTime = (default.MaxSpeed - default.Speed) / default.AccelRate;
		if (AccelTime < FinalLifeSpan)
		{
			return ((0.5 * default.AccelRate * AccelTime * AccelTime) + (default.Speed * AccelTime) + (default.MaxSpeed * (FinalLifeSpan - AccelTime)));
		}
		else
		{
			return (0.5 * default.AccelRate * FinalLifeSpan * FinalLifeSpan) + (default.Speed * FinalLifeSpan);
		}
	}		
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Super.Explode(HitLocation, HitNormal);
	SetTimer(0.0,false);
}

simulated function vector GetRocketSpread()
{
	local float iRandomizer; 

	iRandomizer = FRand() > 0.5 ? 1.0 : -1.0;   

	return RocketStages[CurrentStage].DirectionSpread * ((1.0 - Frand()) * iRandomizer) ; 
}

DefaultProperties
{
	HeadShotDamageMult=2.0
	SlowHeadshotScale=1.75
	RunningHeadshotScale=1.5

	ProjExplosionScale=1.0

	// copied from proj_SeekingRocket and proj_Rocket
	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	RotationRate=(Roll=50000)
	bCollideWorld=true
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'

	bWaitForEffects=true
	bAttachExplosionToVehicles=false

	ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	DecalWidth=128.0
	DecalHeight=128.0
	speed=1350.0
	MaxSpeed=1350.0
	Damage=100.0
	DamageRadius=220.0
	MomentumTransfer=85000

    bRotationFollowsVelocity=true
	CheckRadius=0.0
	BaseTrackingStrength=1.0
	HomingTrackingStrength=16.0

	// copies end here

	ExplosionDecal=none
	ExplosionSound=none
    bWaitForEffectsAtEndOfLifetime = true

    ExplosionShake=CameraAnim'Envy_Effects.Camera_Shakes.C_VH_Death_Shake'
	bEnableExplosionShake=False
	bIgnoreOptimizationChecks=false
	
	YawModifier = 1.0 
	
	
	TargetMarker = ParticleSystem'rx_fx_envy.Fire.P_Flare_Large_Yellow'
}