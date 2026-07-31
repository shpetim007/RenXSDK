class TS_Projectile_GrenadeLauncher_Bouncy extends TS_Projectile_Grenade;


var bool bExploded;

var float DetonationTimer; 


simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(DetonationTimer,false, 'Explode'); 
}


simulated event Tick(float DeltaTime)
{
    SetRotation(Rotator(Velocity));
    super.Tick(DeltaTime);
}


/**
 * Explode
 */
simulated function Explode(vector HitLocation, vector HitNormal)
{
    if (!bExploded)
        super.Explode(location,vect(0,0,0)) ;// vect(0,0,1));

    //Check if we were on a building, as normally explode ignores buildings
    if (Rx_Building(ImpactedActor) != none)
        ImpactedActor.TakeDamage(Damage*GetDamageModifier(VRank, InstigatorController),InstigatorController,Location,vect(0,0,0),ExplosionDamageType);

    bExploded = true;
}


/**
 * Give a little bounce
 */
simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    bBlockedByInstigator = false;    

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {

        PlaySound(ImpactSound, true);

        if (!bHasBounced)
        {
            bHasBounced=true;
        }
    }

    // check to make sure we didn't hit a pawn

    if ( bExplodeOnPawnImpact && Pawn(Wall) != none && Wall != Instigator )
    {
        
        Explode(Location, HitNormal);
    }
    else
    {

        Velocity = BounceDamping*(( Velocity dot HitNormal ) * HitNormal * -2.0 + Velocity);   // Reflect off Wall w/damping
        Speed = VSize(Velocity);

        if (Velocity.Z > 200)
        {
            Velocity.Z = BounceDampingZ * (400 + Velocity.Z);
        }
    }
}



DefaultProperties
{
	bExploded=false

    ImpactSound=SoundCue'RX_WP_Grenade.Sounds.SC_Grenade_Bounce'

    ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_Tracer_StickyBomb'
	AmbientSound=SoundCue'RX_WP_GrenadeLauncher.Sounds.SC_GrenadeLauncher_Ambient'

    AirburstExplosionTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst'

    ImpactEffects(0)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(1)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(2)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(3)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Wood
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Green
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Blue
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow Rock    
  
    DrawScale= 1.0
    
    Physics=PHYS_Falling
	
	CustomGravityScaling=1.0
    
    MyDamageType=class'TS_DmgType_GrenadeLauncher'

    bEnableExplosionShake=True
    ProjExplosionScale=1.0

    bHasRandomSpin=false

    BounceDamping=0.334
    BounceDampingZ=0.334

    bExplodeOnPawnImpact=true
    
    TossZ=150
    Speed=3500
    MaxSpeed=12000
    TerminalVelocity=12000
    AccelRate=0
    LifeSpan=4.5
    Damage=70
    DamageRadius=600
    InnerRadiusPct=0.25
    MomentumTransfer=5000

    bRotationFollowsVelocity=true

    DetonationTimer=4.0

	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
    ProjectileLightClass=none //class'TibSun_Game.TS_Light_DiscGrenade_Projectile'
	
}