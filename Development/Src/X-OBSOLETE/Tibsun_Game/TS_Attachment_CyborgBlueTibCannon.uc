class TS_Attachment_CyborgBlueTibCannon extends TS_WeaponAttachment;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
	End Object

	WeaponClass = class'TS_Weapon_CyborgBlueTibCannon'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_MissileLauncher.Effects.P_MuzzleFlash_CYReaper_RocketPod'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	AimProfileName = Cyborg
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Cyborg'
}
