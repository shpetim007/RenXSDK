class OG_Weapon_Pistol extends Rx_Weapon_Pistol;

DefaultProperties
{
	bAutoFire = True
    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh = SkeletalMesh'OG_WP_Pistol.Mesh.SK_WP_Pistol_1P_Alternative'
        AnimSets(0) = AnimSet'OG_WP_Pistol.Anims.AS_Pistol_1P_Alternative'
        Animations = MeshSequenceA
        FOV=55
		Scale=2.0
    End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'OG_WP_Pistol.Mesh.SK_WP_Pistol_Back'
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'OG_WP_Pistol.Anims.AS_Pistol_Arms_Alternative'

	AttachmentClass = OG_Attachment_Pistol

	PlayerViewOffset=(X=5.0,Y=2.0,Z=1.0)

	RecoilDelay = 0.02
	MinRecoil = 0.0
	MaxRecoil = 0.0
	MaxTotalRecoil = 0.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 35.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 4.0
	MaxSpread = 0.06
	RecoilSpreadIncreasePerShot = 0.0025
	RecoilSpreadDeclineSpeed = 0.6
	RecoilSpreadDecreaseDelay = 0.2
	RecoilSpreadCrosshairScaling = 1500;
	
	CrosshairWidth = 210 	// 256
	CrosshairHeight = 210 	// 256

	ShotCost(0)=1
	ShotCost(1)=0
	FireInterval(0)=0.25
	FireInterval(1)=+0.0
	ReloadTime(0) = 1.86
	ReloadTime(1) = 1.86
	
	EquipTime=1.0
	PutDownTime=1.0
	
	WeaponRange=2000.0

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_None

	InstantHitDamage(0)=10 //12
	InstantHitDamage(1)=0
	
	HeadShotDamageMult=1.5 //3.5

	InstantHitDamageTypes(0)=class'Rx_DmgType_Pistol'
	InstantHitDamageTypes(1)=None

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=0

	Spread(0)=0.001
	Spread(1)=0.0
	
	ClipSize = 12
	InitalNumClips = 12
	MaxClips = 2
	bHasInfiniteAmmo = true

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Pistol_Reload"
	ReloadAnim3PName(1) = "H_M_Pistol_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponFireSnd[0]=SoundCue'OG_WP_Pistol.Sounds.Pistol_FireCue'
	WeaponFireSnd[1]=None

	WeaponPutDownSnd=SoundCue'OG_WP_Pistol.Sounds.SC_Pistol_PutDown'
	WeaponEquipSnd=SoundCue'OG_WP_Pistol.Sounds.SC_Pistol_Equip'
	ReloadSound(0)=SoundCue'OG_WP_Pistol.Sounds.Pistol_ReloadCue'
	ReloadSound(1)=SoundCue'OG_WP_Pistol.Sounds.Pistol_ReloadCue'

	PickupSound=SoundCue'OG_WP_Pistol.Sounds.SC_Pistol_Equip'

	FireSocket="MuzzleFlashSocket"

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'	// ParticleSystem'RX_WP_Pistol.Effects.MuzzleFlash_1P'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'	// MaterialInstanceConstant'RenXHud.MI_Reticle_Pistol'

	InventoryGroup=1
	InventoryMovieGroup=1

	WeaponIconTexture=Texture2D'OG_WP_Pistol.UI.T_WeaponIcon_Pistol'
	
	// AI Hints:
	// MaxDesireability=0.3
	AIRating=+0.1
	CurrentRating=+0.1	
	bFastRepeater=true
	bInstantHit=true	
	
	// IronSight:
	bIronSightCapable = false	
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
	BackWeaponAttachmentClass = class'OG_BackWeaponAttachment_Pistol'
}