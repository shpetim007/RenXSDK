class TS_Weapon_ToxinRifle extends TS_Weapon_SniperRifle;

DefaultProperties
{

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_SniperRifle.Mesh.SK_WP_SniperRifle_Silenced_1P'
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_SniperRifle.Mesh.SK_DSR50_Back'
		Scale=1.0
	End Object

	AttachmentClass=class'TS_Attachment_ToxinRifle'



	WeaponProjectiles(0)=class'TS_Projectile_ToxinRifle'
	WeaponProjectiles_Nod(0)=class'TS_Projectile_ToxinRifle'

	InstantHitDamage(0)=60
	InstantHitDamageTypes(0)=class'TS_DmgType_ToxinRifle'
	InstantHitMomentum(0)=10000


	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_1P_ADS'
	

	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_SniperRifle.Sounds.SC_DSR50_Fire_Silenced',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_SniperRifle.Sounds.SC_DSR50_Fire_Silenced',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)


	/****************************************/

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_ToxinRifle'

	WeaponIconTexture = Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_ToxinRifle'

}