class TS_Projectile_RamjetRifle extends TS_Projectile;

DefaultProperties
{

    ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_Bullet_HeavySniper'

    MyDamageType=class'TS_DmgType_GaussRifle'

    ImpactEffectClass = class'TS_ImpactEffect_Bullet_Incendiary'

    DrawScale= 1.0

    bCollideComplex=true

/*    
    Begin Object Name=CollisionCylinder
        CollisionRadius=5
        CollisionHeight=5
        //Don't waste server resources on tracing for a client side projectile 
        CollideActors = false
        AlwaysLoadOnServer=false
    End Object
*/    
    Speed=50000
    MaxSpeed=50000
    TerminalVelocity=120000.0
    AccelRate=-30000

    Damage=80
    DamageRadius=0
    HeadShotDamageMult=1.5
    MomentumTransfer=10000
    bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=false
    bSuppressExplosionFX=True

    bRotationFollowsVelocity=true

    bPierceInfantry = true
    //Must COLLIDE actors if it can't pierce vehicles.. otherwise it'll go through them anyway
    bCollideActors = true 
    bPierceVehicles = false
    
    MaximumPiercingAbility  = 5
    CurrentPiercingPower    = 5

    /*--------------------------------*/
    
    //Very Long Ranged, very low damage falloff bullet template [IE Sniper Rifles] (Assumes 20000+ speed) 
    LifeSpan=3.0 
    EffectiveLifeSpan = 0.75 //-1.0 translates to unused  
    MaxDamageReduction = 0.5 //Must be set if EffectiveLifeSpan > 0 [1.0 is no reduction. Lower is reduced more]

    /*Advanced bullet physics options*/ 
    bUseAdvPhysics = true
    MinSpeed = 20000.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
    GravForce = 490 //Most bullets don't use gravity

	BulletWhizBySnd = SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Sniper'
   
}
