class TS_Attachment_Medpack extends TS_WeaponAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_Medkit.Mesh.SK_WP_MedKit_3P'
		Scale=1.0
	End Object

	WeaponClass = class'TS_WeaponAbility_MedKit'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=none
	MuzzleFlashLightClass=none
	MuzzleFlashDuration=2.5
	
	AimProfileName = Unarmed
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Unarmed'
}
