class TS_Projectile_CyborgVulcanCannon extends TS_Projectile;

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'TS_WP_CyborgVulcanCannon.Effects.P_Bullets_Cluster'
    
    BulletWhizBySnd = SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Standard'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Stone
    ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Concrete', ImpactSmokeColour=(X=0.425,Y=0.4,Z=0.4)) //Concrete
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Metal',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Metal', ImpactSmokeColour=(X=0.75,Y=0.75,Z=0.75)) //Metal
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Glass',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Wood',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Wood')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'TS_VH_Wolverine_HD.Effects.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'TS_VH_Wolverine_HD.Effects.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Mud')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.bullets.P_Bullet_Impact_Flesh',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Body')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Glass')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Mud')
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Dirt', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(17)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Snow', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(18)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Rock', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snowy Rock
    ImpactEffects(19)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_WP_AutoShotgun.Effects.P_Bullet_Impact_Dynamic',Sound=SoundCue'RX_SoundEffects_B.Bullet_Impact.Cue.SC_Bullet_Impact_Grass', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
    
    ProjExplosionScale=1.0

    DrawScale= 1.0f

    Begin Object Name=CollisionCylinder
        CollisionRadius=16
        CollisionHeight=16
        //Don't waste server resources on tracing for a client side projectile 
        CollideActors = false
        AlwaysLoadOnServer=false
    End Object

    bCollideComplex=true
//    bCollideWorld=true
    Speed=45000
    MaxSpeed=45000
    AccelRate=0
    Damage=7
    DamageRadius=0
//    InnerRadiusPct = 1.0
    HeadShotDamageMult=1.0 //2.25
    MomentumTransfer=10000
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=false
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air

    bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
    
    ProjectileLightClass=none
    ExplosionLightClass=none
    MyDamageType=class'TS_DmgType_CyborgVulcanCannon'

    bPierceInfantry = true
    //Must COLLIDE actors if it can't pierce vehicles.. otherwise it'll go through them anyway
    bCollideActors = true 
    bPierceVehicles = false
    
    MaximumPiercingAbility  = 5
    CurrentPiercingPower    = 5
    
    //Long Ranged, Moderate damage falloff bullet template [IE Assault Rifles]
    LifeSpan=0.333333
    EffectiveLifeSpan = -1.0 //-1.0 translates to unused  
    MaxDamageReduction = 1.0 //Must be set if EffectiveLifeSpan > 0 [1.0 is no reduction. Lower is reduced more]
}