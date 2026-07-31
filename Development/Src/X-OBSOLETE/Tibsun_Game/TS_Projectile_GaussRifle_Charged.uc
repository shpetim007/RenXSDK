class TS_Projectile_GaussRifle_Charged extends TS_Projectile;


DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_GaussRailgun_Projectile'

    AirburstExplosionTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small'

    ImpactEffects(0)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(1)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(2)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(3)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Wood
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Green
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Blue
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Impact_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow Rock

    DrawScale= 1.0f

    Begin Object Name=CollisionCylinder
      CollisionRadius=8
      CollisionHeight=8
      //Don't waste server resources on tracing for a client side projectile 
      CollideActors = false
      AlwaysLoadOnServer=false
    End Object

    //    bCollideComplex=true
    //bCollideWorld=true
    Speed=45000
    MaxSpeed=45000
    AccelRate=0
    Damage=150
    DamageRadius=200
    InnerRadiusPct=0.50
    LifeSpan=0.44444
    HeadShotDamageMult=1.5
    MomentumTransfer=5000
    bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=false
    bSuppressExplosionFX=true // Do not spawn hit effect in mid air

    Physics=PHYS_Projectile

    RotationRate=(Roll=500000)

    ProjectileLightClass=class'UTGame.UTShockMuzzleFlashLight'
    // ExplosionLightClass=class'Rx_Light_Bullet_Ramjet'
    MyDamageType=class'TS_DmgType_GaussRifle_Charged'

    //For instant hit weapons 
    bPierceInfantry = true
    bPierceVehicles = false
    MaximumPiercingAbility  = 50 
    CurrentPiercingPower    = 50 

    bCollideActors = true ; 

    /*Advanced bullet physics options*/ 
    bUseAdvPhysics = false
    MinSpeed = -1.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
    GravForce = 0 //Most bullets don't use gravity

    BulletWhizBySnd = SoundCue'RX_SoundEffects_B.Bullet_WhizBy.SC_Sniper_Crackle_Heavy'

}
