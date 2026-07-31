class TS_Attachment_Pistol_Burst extends TS_Attachment_Pistol;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_Pistol.HD.Mesh.SK_Pistol_Burst_3P'
	End Object

	WeaponClass = class'TS_Weapon_Pistol_Burst'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash'		// ParticleSystem'RX_WP_Pistol.Effects.MuzzleFlash'
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
//	ImpactLightClass=none
	MuzzleFlashDuration=2.5	

}
