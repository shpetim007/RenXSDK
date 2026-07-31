class TS_Attachment_CyborgAutoCannon extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_MissileLauncher.Mesh.SK_MissileLauncher_3P'
	End Object

	WeaponClass = class'TS_Weapon_CyborgAutoCannon'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Minigun.Effects.P_MuzzleFlash_3P'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

    AimProfileName = Cyborg
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Cyborg'
}
