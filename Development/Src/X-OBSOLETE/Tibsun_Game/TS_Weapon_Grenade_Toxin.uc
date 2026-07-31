class TS_Weapon_Grenade_Toxin extends TS_Weapon_Grenade;

DefaultProperties
{

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_NapalmGrenade.Mesh.SK_NapalmGrenade_1P'
		AnimSets(0)=AnimSet'RX_WP_Grenade.Anims.AS_Grenade_1P'
		Materials(0)=MaterialInstanceConstant'TS_WP_NapalmGrenade.Materials.MI_NapalmGrenade_Tib'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=55.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_NapalmGrenade.Mesh.SK_NapalmGrenade_3P'
		Scale=2.5
	End Object

	AttachmentClass = class'TS_Attachment_NapalmGrenade'
	
	BackWeaponAttachmentClass = none //class'TS_BackWeaponAttachment_NapalmGrenade'
	   

    WeaponProjectiles(0)=class'TS_Projectile_TiberiumGrenade'
    WeaponProjectiles(1)=class'TS_Projectile_TiberiumGrenade'
    
}