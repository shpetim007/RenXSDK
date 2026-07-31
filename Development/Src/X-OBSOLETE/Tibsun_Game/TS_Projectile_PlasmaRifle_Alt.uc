class TS_Projectile_PlasmaRifle_Alt extends TS_Projectile; //_Rocket_Guided;


DefaultProperties
{
    
	AmbientSound=SoundCue'RX_SoundEffects_B.Munitions.Cue.SC_Missile_FlyBy_Loop'
    
    ProjFlightTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_Projectile_PlasmaCannon_Small'

    AirburstExplosionTemplate=none //ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small'

    ImpactEffects(0)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.425,Y=0.4,Z=0.4)) //Concrete
    ImpactEffects(1)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(2)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small' ) 
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Wood
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Medium_Water',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Medium_Water',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Green
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Blue
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_WP_CyborgPlasmaCannon.Effects.P_CyborgPlasma_Explosion_Small',Sound=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow Rock

    DrawScale=1.0

    ProjExplosionScale=1.0

	bCollideWorld=True
	bNetTemporary=False
	bWaitForEffects=True
	bRotationFollowsVelocity=true
    bWaitForEffectsAtEndOfLifetime=true
   
	bEnableExplosionShake=True

	MaxExplosionLightDistance=7000.000000
	Speed=10000
    MaxSpeed=10000
    TerminalVelocity=100000
    AccelRate=0

	TossZ=150
    LifeSpan=3.0
	Damage=30
	DamageRadius=400
    HeadShotDamageMult=1.0
	InnerRadiusPct=0.25
	MomentumTransfer=100000.000000
   

	MyDamageType=Class'TS_DmgType_CyborgPlasmaCannon_Small'

	bCheckProjectileLight=true
    ProjectileLightClass=class'TS_Light_PlasmaCannon_Projectile'
    ExplosionLightClass=Class'TS_Light_PlasmaCannon_Explosion'

    /*Advanced bullet physics options*/ 
    bUseAdvPhysics = true
    MinSpeed = -1.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
    GravForce = 490 //Most bullets don't use gravity

/*
    BaseTrackingStrength=8.0
    HomingTrackingStrength=8.0

    RocketStages(0) = (Stage_AccelRate = 25, Stage_HomingStrength = 8.0, Stage_BaseTrackingStrength = 8.0, Stage_MaxSpeed = 500, Stage_Time = 0.15, bIgnoreHoming = true);//, DirToGo = (Pitch = 500)) ; 
    RocketStages(1) = (Stage_AccelRate = 30000, Stage_HomingStrength = 8.0, Stage_BaseTrackingStrength = 8.0, Stage_MaxSpeed = 10000, bSeekFinalTarget = true ) ; //Snap to target

*/
}

