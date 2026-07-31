class TS_Projectile_MicroDiscGrenade_Air extends TS_Projectile_Rocket;

DefaultProperties
{
    ImpactSound=SoundCue'rx_wp_proxyc4.Sounds.SC_ProxyC4_Impact' //SoundCue'RX_WP_Grenade.Sounds.SC_Grenade_Bounce'

    ProjFlightTemplate=ParticleSystem'TS_WP_DiscLauncher.Effects.P_MicroDisc'
    AmbientSound=SoundCue'TS_WP_DiscLauncher.Sounds.SC_Disc_FlyBy'

    AirburstExplosionTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small'

    ImpactEffects(0)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(1)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(2)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(3)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Wood
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Green
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Blue
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow Rock  
        
    DrawScale= 1.0

    ProjExplosionScale=1.0
    
    BaseTrackingStrength=8.0
    HomingTrackingStrength=8.0

    bEnableExplosionShake=True
    
    //Game Block//
    LifeSpan=4
    Speed=6000
    MaxSpeed=6000
    AccelRate=1000
    TerminalVelocity=10000
    Damage = 70
    DamageRadius = 350
    MyDamageType=class'TS_DmgType_MicroDiscLauncher'

    bCollideComplex=true
    bCollideWorld=true
    bBounce=false
    bNetTemporary=false
    bRotationFollowsVelocity=true
    bBlockedByInstigator=false
    bSuppressExplosionFX=false // Do not spawn hit effect in mid air
	bWaitForEffectsAtEndOfLifetime=true

	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
    ProjectileLightClass=class'TibSun_Game.TS_Light_DiscGrenade_Projectile'
}
