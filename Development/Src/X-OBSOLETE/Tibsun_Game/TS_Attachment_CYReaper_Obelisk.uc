class TS_Attachment_CYReaper_Obelisk extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_PortableObelisk.Mesh.SK_BeamCannon_3P'
		Scale=3.5
	End Object

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Red'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

	WeaponClass = class'TS_Weapon_CYReaper_Obelisk'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_PortableObelisk.Effects.P_PortableObelisk_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=5.0
	
	AimProfileName = CYReaper
    WeaponAnimSet = AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper'
}
