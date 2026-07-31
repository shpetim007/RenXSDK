class TS_Attachment_MultiMissileLauncher extends TS_Attachment_ScopedLaser;

simulated function ThirdPersonFireEffects(vector HitLocation)
{
	super.ThirdPersonFireEffects(HitLocation);
}

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
	End Object

	WeaponClass = class'TS_Weapon_RocketLauncher'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_RocketLauncher.Effects.P_MuzzleFlash'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	AimProfileName = Autorifle
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'

	EndPointParamName=BeamEnd
	BeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_green'
	BeamSocket = MuzzleFlashSocket
}
