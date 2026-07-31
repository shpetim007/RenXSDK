class TS_Attachment_RPG extends TS_WeaponAttachment;



DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_RPG.Mesh.SK_WP_RPG_3P'
		//Translation=(Y=-3,Z=0)
		//Rotation=(Roll=-1000,Pitch=6000,Yaw=-1000)
		Scale=1.0
	End Object

	WeaponClass = class'TS_Weapon_RPG'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_RPG.Effects.P_MuzzleFlash'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	AimProfileName = Autorifle
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'
}
