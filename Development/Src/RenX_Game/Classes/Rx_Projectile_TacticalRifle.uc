class Rx_Projectile_TacticalRifle extends Rx_Projectile;

DefaultProperties
{
    ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Bullets.P_Bullet_Incendiary'
	
	AmbientSound=SoundCue'RX_SoundEffects.Bullet_WhizBy.SC_Bullet_WhizBy'

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Dirt',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Stone',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Stone',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Concrete'),DecalWidth=6.0,DecalHeight=6.0)
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Metal',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Metal',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Metal'),DecalWidth=6.0,DecalHeight=6.0)
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Glass',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Wood',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Wood',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Wood_01'),DecalWidth=6.0,DecalHeight=6.0)
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Water',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Water',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Flesh',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Flesh')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibGround_Green',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibCrystal_Green',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibGround_Blue',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibCrystal_Blue',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Mud',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_WhiteSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_YellowSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Grass',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_YellowSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Snow',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Snow',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
	
    DrawScale= 1.0f

    bCollideComplex=true
    //bCollideWorld=true
    Speed=30000 //20000 //18000 //14000
    MaxSpeed=30000 //20000 //18000 //14000
    AccelRate=0
    LifeSpan=0.3 //0.4 //0.777
    Damage=22 //20 //16
    DamageRadius=40 //80
	HeadShotDamageMult=1.5 //1.6 //2.5
    MomentumTransfer=10000
    bAttachExplosionToVehicles=false
    bCheckProjectileLight=true
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air
    
    ProjectileLightClass=class'Rx_Light_Bullet_GDI'
    ExplosionLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    MyDamageType=class'Rx_DmgType_TacticalRifle'
	ExplosionDamageType = class'Rx_DmgType_TacticalRifle_Explosion'

}
