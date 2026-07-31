class TS_Attachment_BlastCharge extends Rx_WeaponAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_GadgetC4.Meshes.SK_WP_TimedC4_3P'
	End Object

	WeaponClass = class'TS_Weapon_TimedC4'
	MuzzleFlashSocket=MuzzleFlashSocket
	
	AimProfileName = Unarmed
	bDontAim = true
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Unarmed'
}
