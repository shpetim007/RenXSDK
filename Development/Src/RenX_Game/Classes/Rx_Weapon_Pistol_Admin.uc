class Rx_Weapon_Pistol_Admin extends Rx_Weapon_Reloadable;

simulated function bool IsInstantHit()
{
	return true; 
}

DefaultProperties
{
	bAutoFire = false
	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'RX_WP_Pistol.Mesh.SK_SilencedPistol_1P' 		// SkeletalMesh'RX_WP_Pistol.Mesh.SK_WP_Pistol_1P_Alternative'
		AnimSets(0)=AnimSet'RX_WP_Pistol.Anims.AS_SilencedPistol_Weapon'		// AnimSet'RX_WP_Pistol.Anims.AS_Pistol_1P_Alternative'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=55.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_Pistol.Mesh.SK_SilencedPistol_Back'		// SkeletalMesh'RX_WP_Pistol.Mesh.SK_WP_Pistol_Back'
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'RX_WP_Pistol.Anims.AS_SilencedPistol_Arms'			// AnimSet'RX_WP_Pistol.Anims.AS_Pistol_Arms_Alternative'

	AttachmentClass = class'Rx_Attachment_Pistol_Admin'
	
	PlayerViewOffset=(X=-2.5,Y=-2.0,Z=0.5)		// (X=5.0,Y=2.0,Z=1.0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	bUseHandIKWhenRelax=false
	
	//-------------- Recoil
	RecoilDelay = 0
	MinRecoil = 0
	MaxRecoil = 0
	MaxTotalRecoil = 0
	RecoilYawModifier = 0 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 0
	RecoilDeclinePct = 99
	RecoilDeclineSpeed = 99
	MaxSpread = 0
	RecoilSpreadIncreasePerShot = 0
	RecoilSpreadDeclineSpeed = 99
	RecoilSpreadDecreaseDelay = 0
	RecoilSpreadCrosshairScaling = 0;
	
	CrosshairWidth = 210 	// 256
	CrosshairHeight = 210 	// 256

	ShotCost(0)=0
	ShotCost(1)=0
	FireInterval(0)=+0.01
	FireInterval(1)=+0.0
	ReloadTime(0) = 0.1
	ReloadTime(1) = 0.1
	
	EquipTime=0.1
//	PutDownTime=0.3667
	
	WeaponRange=15000.0

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_None

	InstantHitDamage(0)=0 //12
	InstantHitDamage(1)=0
	
	HeadShotDamageMult=0 //3.5

	InstantHitDamageTypes(0)=class'Rx_DmgType_Pistol'
	InstantHitDamageTypes(1)=None

	InstantHitMomentum(0)=0
	InstantHitMomentum(1)=0

	Spread(0)=0.0
	Spread(1)=0.0
	
	ClipSize = 999
	InitalNumClips = 12
	MaxClips = 2
	bHasInfiniteAmmo = true;

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Pistol_Reload"
	ReloadAnim3PName(1) = "H_M_Pistol_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponFireSnd[0]=None
	WeaponFireSnd[1]=None

	WeaponPutDownSnd=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'
	ReloadSound(0)=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Reload'
	ReloadSound(1)=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Reload'

	PickupSound=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'

	FireSocket="MuzzleFlashSocket"

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=None	
	MuzzleFlashDuration=0
	MuzzleFlashLightClass=None
	MuzzleFlashPSC = none
	MuzzleFlashAltPSCTemplate = none

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'	// MaterialInstanceConstant'RenXHud.MI_Reticle_Pistol'

	InventoryGroup=1
	InventoryMovieGroup=1

	WeaponIconTexture=Texture2D'RX_WP_Pistol.UI.T_WeaponIcon_Pistol'
	
	// AI Hints:
	// MaxDesireability=0.3
	AIRating=+0.1
	CurrentRating=+0.1	
	bFastRepeater=true
	bInstantHit=true	
	
	// IronSight:
	bIronSightCapable = true	
	IronSightViewOffset=(X=-10,Y=-6.2375,Z=1.75)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=45.0
	InverseZoomOffset=20.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=220.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	/** one1: Added. */
	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_Pistol'

	//WeaponIconTexture
	
	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (DamageModifier = 0, ROFModifier = 1.0, BuildingDamageMod = 1.0, InfantryDamageMod = 1.0, RangeModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(1)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.99)
	VetRankInfo(2)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.9725)

	//Veterans
	VetRankInfo(3)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.95)
	VetRankInfo(4)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.94)
	VetRankInfo(5)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.925)

	//ELITE
	VetRankInfo(6)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.9)
	VetRankInfo(7)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.89)
	VetRankInfo(8)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.8725)

	//HEROIC
	VetRankInfo(9)= (DamageModifier = 0, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 0.85)

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/


}
