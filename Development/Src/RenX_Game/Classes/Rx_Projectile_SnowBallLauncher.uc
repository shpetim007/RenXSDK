class Rx_Projectile_SnowBallLauncher extends Rx_Projectile_Grenade;

/**
 * Set the initial velocity and cook time
 */
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
//    SetTimer(4.0+FRand()*0.5,false);                  // Grenade begins unarmed
//    RandSpin(100000);
}

function Init(vector Direction)
{
    super.Init(Direction);

    TossZ = TossZ + (FRand() * TossZ / 2.0) - (TossZ / 4.0);
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local Rx_Pawn P;
    local Rx_Controller C;
    local Rx_Bot B;

    super.ProcessTouch(Other, HitLocation, HitNormal);

    if (Role >= ROLE_Authority)
    {
        P = Rx_Pawn(Other);

        if (P == None) return;
		if (P.IsSameTeam(Instigator))
			return;
        C = Rx_Controller(P.Controller);
        B = Rx_Bot(P.Controller);
		if(StatEffectClass.default.bEffectStackable)
		{
			if (C != None)
				C.AddActiveModifierStack(StatEffectClass);
			
			if (B != None) 
				B.AddActiveModifierStack(StatEffectClass);
		}
		else
		{
			if (C != None)
				C.AddActiveModifier(StatEffectClass);
		
			if (B != None) 
				B.AddActiveModifier(StatEffectClass);
		}
    }
}
/**
 * Override bounce...
 */
 simulated singular event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local TraceHitInfo WallHitInfo;
	local bool mctDamage;
	local Pawn WallPawn; 
	
	if(PiercedActors.Find(Wall) > -1)
		return;
	
	WallPawn = Pawn(Wall);

	
	//We don't own the projectile, so don't be the one to determine its effects 
	if(ROLE < ROLE_Authority){
		if (DamageRadius > 0.0){
			Explode(Location, HitNormal);
		}
		else {
			SpawnExplosionEffects(Location, HitNormal);
			Shutdown();
		}
		
		return; 
	}
		//`log("Hit Wall, using instigator:" @ MyWeaponInstigator); 
		
	TriggerEventClass(class'SeqEvent_HitWall', Wall);

	if(bPierceInfantry && Rx_Pawn(Wall) != none && CurrentPiercingPower > 0){
		CurrentPiercingPower-=1 ;
		PiercedActors.AddItem(Wall);
	}	
	else if(bPierceVehicles && Rx_Vehicle(Wall) != none && CurrentPiercingPower > 2){
		CurrentPiercingPower-=3 ;
		PiercedActors.AddItem(Wall); 
	}
	else
		CurrentPiercingPower = 0; 
	
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
		if(WorldInfo.NetMode != NM_DedicatedServer 
			&& ( Instigator != none && (Rx_Weapon(MyWeaponInstigator) != None || Rx_Vehicle_Weapon(MyWeaponInstigator) != None || Rx_PassiveAbility(MyWeaponInstigator) != None))
			&& !isAirstrikeProjectile()) 
		{
			if(WallPawn != None && WallPawn.Health > 0 && UTPlayerController(Instigator.Controller) != None && WallPawn.GetTeamNum() != Instigator.GetTeamNum() && WallPawn.GetTeamNum() != 255) 
			{
				Rx_Hud(UTPlayerController(Instigator.Controller).myHud).ShowHitMarker();
			}	
			WallHitInfo.HitComponent = WallComp;

			if(Rx_BuildingAttachment_MCT(Wall) != None) 
			{
				Wall = Rx_BuildingAttachment_MCT(Wall).OwnerBuilding.BuildingVisuals;
					
				mctDamage = true;
	
			} 
			CallServerALHit(Wall,location,WallHitInfo,mctDamage);		
		} 
		else if(ROLE == ROLE_Authority && (AIController(InstigatorController) != None || isAirstrikeProjectile())) 
		{
			Wall.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		}
	}
	
	if(CurrentPiercingPower <= 0)
	{
		Explode(Location, HitNormal);
		ImpactedActor = None;
	}		
}

/**
 * When a grenade enters the water, kill effects/velocity and let it sink
 */
simulated function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
    if ( WaterVolume(NewVolume) != none )
    {
        Velocity *= 0.15;
    }

    Super.PhysicsVolumeChange(NewVolume);
}


DefaultProperties
{

    ImpactSound=SoundCue'RX_WP_Grenade.Sounds.SC_Grenade_Bounce'

    ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Missile.P_SnowBallLauncher'
	AmbientSound=SoundCue'RX_WP_GrenadeLauncher.Sounds.SC_GrenadeLauncher_Ambient'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_SnowBall_Small_Snow',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Grenade')
	
    ProjExplosionScale=1.0

    DrawScale= 1.0
    
    Physics=PHYS_Falling
	
	CustomGravityScaling=0.75
    
    MyDamageType=class'Rx_DmgType_GrenadeLauncher'
    
    TossZ=50 	// 150.0
    Speed=3000 	// 2000
    MaxSpeed=3000
	TerminalVelocity=3000.0
    AccelRate=0
    LifeSpan=1.333334
    Damage=2
    DamageRadius=300//200
    MomentumTransfer=50000
	HeadShotDamageMult=2.0

    bExplodeOnPawnImpact=true
    bCollideComplex=true
    bCollideWorld=true
    bBounce=false
    bNetTemporary=false
    bRotationFollowsVelocity=true
    bBlockedByInstigator=false //true WHY?
    bSuppressExplosionFX=false // Do not spawn hit effect in mid air
	bWaitForEffectsAtEndOfLifetime = true
    bWaitForEffects=true
    ProjectileLightClass=Class'RenX_Game.Rx_Light_Grenade'
	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
    StatEffectClass = class'Rx_StatModifierInfo_ColdDebuffGrenade'
    StatEffectDistance = 300
	}
