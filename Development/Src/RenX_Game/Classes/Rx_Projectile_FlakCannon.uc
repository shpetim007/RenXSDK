class Rx_Projectile_FlakCannon extends Rx_Projectile;

event Tick( float DeltaTime )
{
    SetRotation(Rotator(Velocity));
}

function Init(vector Direction)
{
    Velocity = Speed * Direction;
    TossZ = TossZ + (FRand() * TossZ / 2.0) - (TossZ / 4.0);
    Velocity.Z += TossZ;
    Acceleration = AccelRate * Normal(Velocity);
    //ProjEffects.SetRotation(Rotator(Direction));
    //SetRotation(Rotator(Direction));
}


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(0.7f);
}


DefaultProperties
{

    ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.shells.P_Flak_Shell'
	AmbientSound=SoundCue'RX_WP_GrenadeLauncher.Sounds.SC_GrenadeLauncher_Ambient'
    
    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Metal',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Metal'),DecalWidth=6.0,DecalHeight=6.0)
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Wood',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Wood_01'),DecalWidth=6.0,DecalHeight=6.0)
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Flesh')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass',DecalMaterials=(DecalMaterial'RX_FX_Munitions.Bullet_Decals.MDecal_Bullet_Glass'),DecalWidth=20.0,DecalHeight=20.0)
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Dirt'),DecalWidth=20.0,DecalHeight=20.0 )
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Flak',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone',DecalMaterials=(DecalMaterial'RX_FX_Munitions.bullet_decals.MDecal_Bullet_Stone'),DecalWidth=8.0,DecalHeight=8.0)
    
	
    DrawScale= 1.0
    
	Physics=PHYS_Falling
    
	CustomGravityScaling=0.5
    
    MyDamageType=class'Rx_DmgType_FlakCannon'
    
	TossZ=100.0
    Speed=3600//3000
    MaxSpeed=3600//3000
	TerminalVelocity=3000.0
    AccelRate=0
    LifeSpan=1.0
    Damage=50 //60
    DamageRadius=300
	HeadShotDamageMult=2.5
    MomentumTransfer=20000

    bCollideComplex=true
    bCollideWorld=true
    bBounce=false
    bNetTemporary=false
    bRotationFollowsVelocity=true
    bBlockedByInstigator=false
    bSuppressExplosionFX=false // Do not spawn hit effect in mid air
	bWaitForEffectsAtEndOfLifetime = true
    bWaitForEffects=true
	
	ProjectileLightClass=Class'RenX_Game.Rx_Light_Rocket'
	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
	
}
