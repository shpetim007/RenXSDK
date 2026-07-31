class TS_Attachment_CYReaper_RocketPod extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
		Scale=3.0
	End Object

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Red'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

	WeaponClass = class'TS_Weapon_CYReaper_RocketPod'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_MissileLauncher.Effects.P_MuzzleFlash_CYReaper_RocketPod'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	AimProfileName = CYReaper
    WeaponAnimSet = AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper'
}
