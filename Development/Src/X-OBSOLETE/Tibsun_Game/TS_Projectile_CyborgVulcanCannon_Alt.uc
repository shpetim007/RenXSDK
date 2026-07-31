class TS_Projectile_CyborgVulcanCannon_Alt extends TS_Projectile;

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_Bullet_Nod'
    
    AmbientSound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Flyby_Light'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Stone
    ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Concrete', ImpactSmokeColour=(X=0.425,Y=0.4,Z=0.4)) //Concrete
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Metal_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Metal')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Glass_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass', ImpactSmokeColour=(X=0.2,Y=0.25,Z=0.4)) //Glass
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Wood', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Mud', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Flesh',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Body', ImpactSmokeColour=(X=0.65,Y=0.05,Z=0.0)) //Blood
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Mud', ImpactSmokeColour=(X=0.35,Y=0.25,Z=0.10)) //Dirt
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(17)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Snow', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(18)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snowy Rock
    ImpactEffects(19)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Dynamic_Small',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Grass', ImpactSmokeColour=(X=0.35,Y=0.25,Z=0.15)) //Grass
    
    ProjExplosionScale= 1.0

    MyDamageType=class'TS_DmgType_CyborgVulcanCannon_Alt'

    DrawScale= 1.0

    bCollideComplex=true
    Speed=50000
    MaxSpeed=50000
    AccelRate=0
    LifeSpan=0.05
    Damage=8
    DamageRadius=0
	HeadShotDamageMult=2.0 //2.25
    MomentumTransfer=10000
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=false
    bSuppressExplosionFX=True
}
