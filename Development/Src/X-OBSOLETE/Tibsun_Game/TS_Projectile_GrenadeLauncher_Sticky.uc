class TS_Projectile_GrenadeLauncher_Sticky extends TS_Projectile_Sticky;

simulated event Tick(float DeltaTime)
{
    SetRotation(Rotator(Velocity));
    super.Tick(DeltaTime);
}

DefaultProperties
{
	ImpactSound=SoundCue'RX_WP_Grenade.Sounds.SC_Grenade_Bounce'

    ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_Tracer_StickyBomb'
	AmbientSound=SoundCue'RX_WP_GrenadeLauncher.Sounds.SC_GrenadeLauncher_Ambient'

//    AirburstExplosionTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Airburst'

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
    
    TossZ=150
    Speed=4000
    MaxSpeed=12000
    TerminalVelocity=12000
    AccelRate=0
    LifeSpan=4.5
    Damage=80
    DamageRadius=600
    InnerRadiusPct=0.25
    MomentumTransfer=5000

    bRotationFollowsVelocity=true

    bDoImpactDamage=false
    DetonationTimer=4.0

	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
    ProjectileLightClass=none //class'TibSun_Game.TS_Light_DiscGrenade_Projectile'
	
}