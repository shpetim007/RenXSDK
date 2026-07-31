class TS_Attachment_PlasmaLauncher extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_PlasmaLauncher.Mesh.SK_PlasmaLauncher_3P'
	End Object

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

	WeaponClass = class'TS_Weapon_PlasmaLauncher'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_PlasmaLauncher.Effects.P_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'TibSun_Game.TS_Light_PlasmaRifle_MuzzleFlash'
	MuzzleFlashDuration=5.0
	
	AimProfileName = Autorifle
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'
}
