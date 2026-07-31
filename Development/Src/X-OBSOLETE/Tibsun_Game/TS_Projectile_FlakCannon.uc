class TS_Projectile_FlakCannon extends TS_Projectile;

DefaultProperties
{

	ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_Bullet_Flak'

    MyDamageType=class'TS_DmgType_JumpjetRifle'

    ImpactEffectClass = class'TS_ImpactEffect_Bullet_Cluster'

    Begin Object Name=CollisionCylinder
        CollisionRadius=15
        CollisionHeight=15
        //Don't waste server resources on tracing for a client side projectile 
        CollideActors = false
        AlwaysLoadOnServer=false
    End Object

    DrawScale= 1.0f

    ProjExplosionScale=1.0

    bCollideComplex=true
    Speed=45000 //20000 //14000 //9000
    MaxSpeed=45000 //20000 //14000 //9000
    AccelRate=0
    Damage=12
    DamageRadius=0
    InnerRadiusPct = 0.0
	HeadShotDamageMult=1.25
    MomentumTransfer=10000
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air

    ProjectileLightClass=class'Rx_Light_Bullet_GDI'
	
	//Long Ranged, Moderate damage falloff bullet template [IE Assault Rifles]
	LifeSpan=0.3 
	EffectiveLifeSpan = 0.1 //-1.0 translates to unused  
    MaxDamageReduction = 0.5 //Must be set if EffectiveLifeSpan > 0 [1.0 is no reduction. Lower is reduced more]

	BulletWhizBySnd = SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Standard'
	
}
