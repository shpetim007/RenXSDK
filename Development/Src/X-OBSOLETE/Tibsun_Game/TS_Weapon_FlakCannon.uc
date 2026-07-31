class TS_Weapon_FlakCannon extends TS_Weapon_Reloadable;


DefaultProperties
{
	bAutoFire = true

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_AutoShotgun.Mesh.SK_AutoShotgun_Carbine_1P'
		AnimSets(0)=AnimSet'RX_WP_Carbine.Anims.AS_Carbine_1P'
		Animations=MeshSequenceA
		Scale=3.0
		FOV=75
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_AutoShotgun.Mesh.SK_AutoShotgun_Back'
		Scale=1.0
	End Object

	PlayerViewOffset=(X=-15.0,Y=-2.0,Z=-1.0)
	
	LeftHandIK_Offset=(X=0.25,Y=-3.06,Z=1.04)
	LeftHandIK_Rotation=(Pitch=0,Yaw=0,Roll=0)
	LeftHandIK_Relaxed_Offset = (X=0.757900,Y=-3.926300,Z=0.610000)
	LeftHandIK_Relaxed_Rotation = (Pitch=1820,Yaw=-4551,Roll=-4733)
	
	RightHandIK_Offset=(X=5.771700,Y=-2.312800,Z=0.874400)
	RightHandIK_Relaxed_Offset = (X=2.212800,Y=0.420000,Z=-1.164800)
	RightHandIK_Relaxed_Rotation = (Pitch=-182,Yaw=3276,Roll=6735)
	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed

	ArmsAnimSet = AnimSet'RX_WP_Carbine.Anims.AS_Carbine_Arms'

	AttachmentClass = class'TS_Attachment_FlakCannon'


	FireOffset=(X=5,Y=0,Z=-0)
	
	//-------------- Recoil --------------//
	
	// Intensity
	RecoilDelay = 0.0
	MinRecoil = 85.0
	MaxRecoil = 100.0
	MaxTotalRecoil = 10000.0

	// Pitch
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 8.0

	// Yaw
	RecoilYawMultiplier = 1.0
	RecoilYawModifier = 0.75
	RecoilInterpSpeedYaw = 25.0
	RecoilDeclineSpeedYaw = 6.0

	// Roll
	RecoilRollMultiplier = 4.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 75.0
	RecoilDeclineSpeedRoll = 60.0

	// Spread
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.0005
	RecoilSpreadDeclineSpeed = 0.25
	RecoilSpreadDecreaseDelay = 0.1
	RecoilSpreadCrosshairScaling = 1500;

	// IronSights
	IronSightMinRecoilDamping = 1.5
	IronSightMaxRecoilDamping = 1.5
	IronSightMaxTotalRecoilDamping = 1
	IronSightRecoilYawDamping = 2
	IronSightRecoilRollDamping = 1
	IronSightMaxSpreadDamping = 1
	IronSightSpreadIncreasePerShotDamping = 3

	// ADS Camera & Weapon Visual Recoil
	IronsightCameraRecoilLocMod[0] = (X=1.0,Y=1.0,Z=1.0)
	IronsightCameraRecoilLocMod[1] = (X=1.0,Y=1.0,Z=1.0)

	IronsightCameraRecoilRotMod[0] = (X=0.0,Y=2.0,Z=0.0)
	IronsightCameraRecoilRotMod[1] = (X=0.0,Y=2.0,Z=0.0)

	IronsightWeaponRecoilLocMod[0] = (X=2.0,Y=0.0,Z=0.0)
	IronsightWeaponRecoilLocMod[1] = (X=2.0,Y=0.0,Z=0.0)

	IronsightWeaponRecoilRotMod[0] = (X=0.1,Y=0.1,Z=0.1)
	IronsightWeaponRecoilRotMod[1] = (X=0.1,Y=0.1,Z=0.1)

	//-----------------------------------//

    ShotCost(0)=1
    ShotCost(1)=2
    FireInterval(0)=+0.12
    FireInterval(1)=+0.12
    ReloadTime(0) = 2.75
    ReloadTime(1) = 2.75
    
    EquipTime=0.75
	//PutDownTime=0.5
	ActionToReadyTime = 0.15

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile

	WeaponProjectiles(0)=class'TS_Projectile_FlakCannon'
	WeaponProjectiles(1)=class'TS_Projectile_FlakCannon'

	InstantHitDamage(0)=12
	InstantHitDamage(1)=12
	
	HeadShotDamageMult=1.25

	InstantHitDamageTypes(0)=class'TS_DmgType_JumpjetRifle'
	InstantHitDamageTypes(1)=class'TS_DmgType_JumpjetRifle'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
    Spread(0)=0.01
    Spread(1)=0.01

    IronSightAndScopedSpread(0)=0.001
    IronSightAndScopedSpread(1)=0.001

    WeaponRange=1000.0

    bInstantHit=true
 
    ClipSize = 30
    InitalNumClips = 8
	MaxClips = 8
	
	Ammo_Increment = 60
	AmmoIncrementRate = 1.0

	FireAnimLength[0] = 0.5
	FireAnimLength[1] = 0.5

	WeaponFireAnim[0]="WeaponFire"
	ArmFireAnim[0] = "WeaponFire"
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"

    WeaponADSFireAnim(0) = "WeaponIdle"
	WeaponADSFireAnim(1) = "WeaponIdle"
	ArmADSFireAnim(0) = "WeaponIdle"
	ArmADSFireAnim(1) = "WeaponIdle"


    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun_Light.Sounds.SC_LRG_Fire_Single',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun_Light.Sounds.SC_LRG_Fire_Single_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_AutoRifle.Sounds.AutoRifle_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_AutoRifle.Sounds.AutoRifle_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/



    WeaponFireSnd[0]=none //SoundCue'TS_WP_AutoShotgun.Sounds.SC_AutoShotgun_Fire'

    WeaponPutDownSnd=none //SoundCue'RX_WP_AutoRifle.Sounds.AutoRifle_PutDownCue'
	WeaponEquipSnd=none //SoundCue'RX_WP_AutoRifle.Sounds.AutoRifle_EquipCue'
	ReloadSound(0)=SoundCue'RX_WP_Carbine.Sounds.SC_Carbine_Reload'
	ReloadSound(1)=SoundCue'RX_WP_Carbine.Sounds.SC_Carbine_Reload'

    PickupSound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltAutoRifle_Equip'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_AutoRifle.Effects.MuzzleFlash_1P_ADS'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 196
	CrosshairHeight = 196

    InventoryGroup=1
    InventoryMovieGroup=22
    
    // AI Hints:
    WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_AutoShotgun'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False

	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = False

	MaxDesireability=0.5
	AIRating=+0.35
	CurrentRating=+0.35
	AimError = 545
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	IronSightViewOffset=(X=-30.0,Y=-10.35,Z=1.8)
	IronSightFireOffset=(X=0,Y=0,Z=-5)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	//ZoomedFOVSub=35.0 
	ZoomedFOVSub=10.0 
	InverseZoomOffset=0.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=250.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_AutomaticShotgun'


	bLocSync = true; 
	LocSyncIncrement = 4; 
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.05

	// Muzzle heat
	MuzzleHeatPerShot = 0.04f				// Heat increase per shot
	MuzzleHeatCooldownTimeInterval = 0.025f	// Time between each decrease tick
	MuzzleHeatCooldownAmount = -0.003f		// Amount to decrease per cooldown tick
	MinMuzzleHeatRequired = 0.35f			// Minimum heat required for it to be shown
	MuzzleHeatCooldownWaitTime = 1.0f		// Time between firing and starting decrease ticks
}
