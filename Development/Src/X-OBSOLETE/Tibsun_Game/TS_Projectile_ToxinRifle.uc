class TS_Projectile_ToxinRifle extends TS_Projectile;

DefaultProperties
{

    Begin Object Name=CollisionCylinder
        CollisionRadius=2
        CollisionHeight=2
        //Don't waste server resources on tracing for a client side projectile 
        CollideActors = false
        AlwaysLoadOnServer=false
    End Object

    ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_Bullet_Rifle_Green'

    MyDamageType=class'TS_DmgType_ToxinRifle'

    ImpactEffectClass = class'TS_ImpactEffect_Bullet_Small_TibGreen'

    DrawScale= 1.5
    
    bRotationFollowsVelocity=True

    bCollideComplex=true
    Speed=80000
    MaxSpeed=80000
    TerminalVelocity=120000.0
    AccelRate=-40000

    Damage=60
    DamageRadius=0
    HeadShotDamageMult=2.5
    MomentumTransfer=2000
    bWaitForEffects=true
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=false
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air

    TossZ=0

    /*--------------------------------*/
    
    //Very Long Ranged, very low damage falloff bullet template [IE Sniper Rifles] (Assumes 20000+ speed) 
    LifeSpan=2.0 
    EffectiveLifeSpan = -1.0 //-1.0 translates to unused  
    MaxDamageReduction = 1.0 //Must be set if EffectiveLifeSpan > 0 [1.0 is no reduction. Lower is reduced more]

    /*Advanced bullet physics options*/ 
    bUseAdvPhysics = true
    MinSpeed = 30000.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
    GravForce = 490 //Most bullets don't use gravity

    BulletWhizBySnd = SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Medium'
}
