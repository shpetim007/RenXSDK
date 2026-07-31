class TS_Projectile_GaussRifle extends TS_Projectile;


DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_Projectile_Gauss'

    AirburstExplosionTemplate= none 

    ImpactEffectClass = class'TS_ImpactEffect_Bullet_Incendiary'

    DrawScale= 1.0f


    //    bCollideComplex=true
    //bCollideWorld=true
    Speed=45000
    MaxSpeed=45000
    AccelRate=0
    Damage=40
    DamageRadius=0
//    InnerRadiusPct=1.0
    LifeSpan=0.333333
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
    MyDamageType=class'TS_DmgType_GaussRifle'

    //For instant hit weapons 
    bPierceInfantry = true
    bPierceVehicles = false
    MaximumPiercingAbility  = 50 
    CurrentPiercingPower    = 50 

    bCollideActors = true ; 

    /*Advanced bullet physics options*/ 
    bUseAdvPhysics = false
    MinSpeed = -1.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
    GravForce = 490 //Most bullets don't use gravity

    BulletWhizBySnd = SoundCue'RX_SoundEffects_B.Bullet_WhizBy.SC_Sniper_Crackle_Heavy'

}
