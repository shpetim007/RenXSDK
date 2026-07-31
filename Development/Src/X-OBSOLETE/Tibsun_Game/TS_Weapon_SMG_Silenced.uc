class TS_Weapon_SMG_Silenced extends TS_Weapon_SMG;		// Rx_Weapon_Reloadable;

DefaultProperties
{

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_SMG.Mesh.SK_WP_SMG_Silenced_1P'
		AnimSets(0)=AnimSet'TS_WP_SMG.Anim.AS_WP_SMG_1P'
		Animations=MeshSequenceA
		Scale=2.5
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_SMG.Mesh.SK_WP_SMG_Silencer_3P'
		Scale=1.0
	End Object

	AttachmentClass = class'TS_Attachment_SMG_Silenced'


	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_1P_ADS'
	

    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_SMG.Sounds.SingleFire.SC_SMG_Supressed_Fire_1P',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_SMG.Sounds.SingleFire.SC_SMG_Suppressed_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	/****************************************/

	WeaponPreFireSnd[0]=none
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none //SoundCue'TS_WP_SMG.Sounds.SC_SMG_FireLoop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'TS_WP_SMG.Sounds.SC_SMG_FireStop'
    WeaponPostFireSnd[1]=none

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_SMGSilenced'
	
	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_SMG_Silenced'

	bSilentWeapon = true

}
