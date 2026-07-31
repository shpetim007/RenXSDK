class TS_Weapon_EMPDart extends TS_Weapon_Reloadable;


DefaultProperties
{
	bAutoFire = True

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Revolver.Mesh.SK_WP_Revolver_1P'
		AnimSets(0)=AnimSet'TS_WP_Revolver.Anims.AS_WP_Revolver_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Revolver.Mesh.SK_WP_Revolver_3P'
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'TS_WP_Revolver.Anims.AS_WP_Revolver_Arms'
	
	AttachmentClass = class'TS_Attachment_HeavyPistol'
	
	PlayerViewOffset=(X=0,Y=0,Z=0)

	FireOffset=(X=20.0,Y=10.0,Z=-8.0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	bUseHandIKWhenRelax=false
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 70.0
	MaxRecoil = 80.0
	MaxTotalRecoil = 5000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 35.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 6.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.1
	RecoilSpreadDeclineSpeed = 0.25
	RecoilSpreadDecreaseDelay = 0.2
	RecoilSpreadCrosshairScaling = 1500;

	// Roll
	RecoilRollMultiplier = 2.0
	RecoilRollModifier = 0.8
	RecoilInterpSpeedRoll = 100.0
	RecoilDeclineSpeedRoll = 12.0
	
	CrosshairWidth = 210 	// 256
	CrosshairHeight = 210 	// 256

	ShotCost(0)=1
	ShotCost(1)=0
	FireInterval(0)=+1.0
	FireInterval(1)=+0.0
	ReloadTime(0) = 5.0
	ReloadTime(1) = 5.0
	
	EquipTime=1.0
	//PutDownTime=0.667
	ActionToReadyTime = 0.15

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_None
	
	WeaponProjectiles(0)=class'TS_Projectile_EMPDart'
	WeaponProjectiles(1)=class'TS_Projectile_EMPDart'

	Spread(0)=0.001
	Spread(1)=0.0

	IronSightAndScopedSpread(0)=0.0
	IronSightAndScopedSpread(1)=0.0
	
	ClipSize = 1
	InitalNumClips = 5
	MaxClips = 5

	Ammo_Increment = 5

	bHasInfiniteAmmo = false


	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire_Silenced',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire3P_Silenced',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/


	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Pistol_Reload"
	ReloadAnim3PName(1) = "H_M_Pistol_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponFireSnd[0]=none //SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire_Silenced'
	WeaponFireSnd[1]=none //SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire_Silenced'

	WeaponPutDownSnd=none //SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_PutDown'
	WeaponEquipSnd=none //SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_Equip'
	ReloadSound(0)=SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_Reload'
	ReloadSound(1)=SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_Reload'

	PickupSound=SoundCue'TS_WP_Revolver.Sounds.SC_Revolver_Equip'

	FireSocket="MuzzleFlashSocket"

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'	// ParticleSystem'RX_WP_Pistol.Effects.MuzzleFlash_1P'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'	// MaterialInstanceConstant'RenXHud.MI_Reticle_Pistol'

	InventoryGroup=2
	InventoryMovieGroup=1

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Revolver'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = False
	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.4
	AIRating=+0.25
	CurrentRating=+0.25
	AimError = 200
	
	// IronSight:
	bIronSightCapable = true	
	IronSightViewOffset=(X=0,Y=-7.83,Z=1.544)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2

	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 3					// 2		1.5
	IronSightMaxRecoilDamping = 3					// 2		1.5
	IronSightMaxTotalRecoilDamping = 2				// 2		1.5
	IronSightRecoilYawDamping = 5					// 1		1.0
	IronSightMaxSpreadDamping = 10					// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 10		// 4		1.7

	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=45.0
	InverseZoomOffset=20.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=250.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_HeavyPistol'

	//WeaponIconTexture
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.02
}
