class TS_Projectile_RPG extends TS_Projectile;


DefaultProperties
{
    
    AmbientSound=SoundCue'RX_SoundEffects_B.Munitions.Cue.SC_Missile_FlyBy_Loop'

	ProjFlightTemplate=ParticleSystem'TS_FX_Munitions.Particles.Rocket.P_Rocket_RPG'

	DrawScale = 1.0f

	AirburstExplosionTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small'

    ImpactEffects(0)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
	ImpactEffects(1)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
    ImpactEffects(2)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
	ImpactEffects(3)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Rock
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Wood
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small_Water',Sound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_Medium_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Green
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Tiberium Ground Blue
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Dirt
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=3,Y=2.6,Z=2.1)) //White Sand
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Sand
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=0.65,Y=0.45,Z=0.25)) //Grass
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=1.8,Y=0.9,Z=0.3)) //Yellow Rock
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small_Dynamic',Sound=SoundCue'TS_SoundEffects_B.Explosions.Cue.SC_Explosion_Small', ImpactSmokeColour=(X=2.0,Y=3.5,Z=6.0)) //Snow Rock


	bCollideWorld=True
	bNetTemporary=False
	bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
	bRotationFollowsVelocity=true
   
	bEnableExplosionShake=True

	ExplosionLightClass=Class'Rx_Light_Tank_MuzzleFlash'
	MaxExplosionLightDistance=7000.000000
	Speed=9000
	MaxSpeed=9000
	AccelRate=0
	TossZ=10
	TerminalVelocity=10000.0
	LifeSpan=3.0
	Damage=95
	DamageRadius=150
	InnerRadiusPct=0.5
	HeadShotDamageMult=1.0
	MomentumTransfer=100000.000000

	MyDamageType=Class'TS_DmgType_RPG'

	bCheckProjectileLight=true
	ProjectileLightClass=class'Rx_Light_Bullet_GDI' //class'RenX_Game.Rx_Light_Rocket'
	
	/*Advanced bullet physics options*/	
	bUseAdvPhysics = true
	MinSpeed = -1.0 //Most things shouldn't need to use this (-1.0 means it's ignored)
	GravForce = 100 //Most bullets don't use gravity
	
	/*--------------------------------*/
	
}

