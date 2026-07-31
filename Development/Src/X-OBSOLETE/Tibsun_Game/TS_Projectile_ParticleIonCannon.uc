class TS_Projectile_ParticleIonCannon extends TS_Projectile;


DefaultProperties
{

    BulletWhizBySnd = none //SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_WizzBy'

    ProjFlightTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_IonProjectile'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')

    DrawScale= 1.0f

    ProjExplosionScale=1.0

    bCollideComplex=true
    Speed=45000
    MaxSpeed=45000
    TerminalVelocity=45000
    AccelRate=0
    LifeSpan=0.3333
    Damage=5
    DamageRadius=0
    InnerRadiusPct = 0.0
    HeadShotDamageMult=1.1

    MomentumTransfer=1

    bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
    bAttachExplosionToVehicles=true
    bCheckProjectileLight=true
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air
    
    ProjectileLightClass=class'TS_Light_Bullet_GaussRifle'
    ExplosionLightClass=none
    MyDamageType=class'TS_DmgType_ParticleIonCannon'
}
