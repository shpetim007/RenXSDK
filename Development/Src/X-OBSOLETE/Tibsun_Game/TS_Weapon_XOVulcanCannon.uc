class TS_Weapon_XOVulcanCannon extends TS_Weapon_HeatLimited;
	

	DefaultProperties
{
	
	//AttachedWeaponAbilityClass = class'TS_WeaponAbility_CyborgArmCannon'

	// Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgVulcanCannon.Mesh.SK_WP_CyborgVulcan_1P'
        AnimSets(0)=AnimSet'RX_WP_ChainGun.Anims.AS_Chaingun_1P_Alternative'
        Animations=MeshSequenceA
        FOV=75
		Scale=2.0
    End Object
	
	ArmsAnimSet = AnimSet'RX_WP_ChainGun.Anims.AS_Chaingun_Arms_New'

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_ChainGun.Mesh.SK_WP_ChainGun_Back'
        // Translation=(X=-15)
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_XOVulcanCannon'
	
	PlayerViewOffset=(X=10.0,Y=20.0,Z=-5.0)
	
	FireOffset=(X=200,Y=45,Z=-30)
	
	// Side Handle
//	LeftHandIK_Offset=(X=0,Y=0,Z=0)
//	LeftHandIK_Rotation=(Pitch=2730,Yaw=-3458,Roll=-364)
//	RightHandIK_Offset=(X=0,Y=0,Z=0)

	// Upper Handle
	LeftHandIK_Offset = (X=9.0,Y=1.8,Z=5.0)
	LeftHandIK_Rotation = (Pitch=4187,Yaw=-5279,Roll=11104)
	RightHandIK_Offset = (X=0.0,Y=0.0,Z=0.0)
	
	LeftHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
	LeftHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=0)
	RightHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
	RightHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=-0)

	bUseHandIKWhenRelax=false
	bByPassHandIK=true

	
	//-------------- Recoil
	RecoilDelay = 0.0
	MinRecoil = 50.0
	MaxRecoil = 80.0
	MaxTotalRecoil = 10000.0
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.4
	RecoilDeclineSpeed = 2.0
	MaxSpread = 0.05
	RecoilSpreadIncreasePerShot = 0.00025
	RecoilSpreadDeclineSpeed = 0.05
	RecoilSpreadDecreaseDelay = 0.15
	RecoilSpreadCrosshairScaling = 2000;

	// Yaw
    RecoilYawMultiplier = 1.0
    RecoilYawModifier = 0.5
    RecoilInterpSpeedYaw = -1.0
    RecoilDeclineSpeedYaw = 2.0

    // Roll
    RecoilRollMultiplier = 1.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 60.0
    RecoilDeclineSpeedRoll = 12.0

	ShotCost(0)=1
	ShotCost(1)=1
	FireInterval(0)=+0.05
	FireInterval(1)=+0.05
	ReloadTime(0) = 3.0
	ReloadTime(1) = 3.0


    HeatIncreasePerShot[0] = 1
    HeatIncreasePerShot[1] = 1
    HeatDecreasePerSec = 30
	
	EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_NONE
	
	WeaponProjectiles(0)=class'TS_Projectile_XOVulcanCannon'
	WeaponProjectiles(1)=class'TS_Projectile_XOVulcanCannon'

	
    Spread(0)=0.005
	Spread(1)=0.005
	
	ClipSize = 1000
	CoolThreshold = 30
	
	Ammo_Increment = 300

	FireDelayTime = 0.5
    bCharge = true
    
	ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_RocketLauncher_Reload"
    ReloadAnim3PName(1) = "H_M_RocketLauncher_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"

	WeaponPreFireAnim[0]="WeaponFireStart"
    WeaponPreFireAnim[1]="WeaponFireStart"
    WeaponFireAnim[0]="WeaponFireloop"
    WeaponFireAnim[1]="WeaponFireloop"
    WeaponPostFireAnim[0]="WeaponFireEnd"
    WeaponPostFireAnim[1]="WeaponFireEnd"

    ArmPreFireAnim[0]="WeaponFireStart"
    ArmPreFireAnim[1]="WeaponFireStart"
    ArmFireAnim[0]="WeaponFireloop"
    ArmFireAnim[1]="WeaponFireloop"
    ArmPostFireAnim[0]="WeaponFireEnd"
    ArmPostFireAnim[1]="WeaponFireEnd"
 
    WeaponEquipSnd=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_Equip'
    WeaponPutDownSnd=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_PutDown'

    WeaponPreFireSnd[0]=SoundCue'TS_VH_Wolverine_HD.Sounds.SC_Fire_Start'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_VH_Wolverine_HD.Sounds.SC_Fire_Loop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=SoundCue'TS_VH_Wolverine_HD.Sounds.SC_Fire_End'
    WeaponPostFireSnd[1]=none
 
    ReloadSound(0)=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_Reload'
    ReloadSound(1)=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_Reload'


	PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

	MuzzleFlashSocket=MuzzleFlashSocket
    FireSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_CH_GDI_XOPowersuit.Effects.P_MuzzleFlash_MG'
    MuzzleFlashDuration=0.1
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_AutoRifle'
	
	CrosshairWidth = 195
	CrosshairHeight = 195

	InventoryGroup=1
	GroupWeight=1
	InventoryMovieGroup=2

	WeaponIconTexture=Texture2D'RX_WP_ChainGun.UI.T_WeaponIcon_Chaingun'


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

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 545
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True	
	bDisplayCrosshairInIronsight = True
	IronSightViewOffset=(X=10.0,Y=15.0,Z=-10.0)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=20
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=55.0
	ZoomedTargetFOV=45.0

	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=175.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2				// 2		1.5
	IronSightMaxRecoilDamping = 2				// 2		1.5
	IronSightMaxTotalRecoilDamping = 2			// 2		1.5
	IronSightRecoilYawDamping = 2					// 1		1.0
	IronSightRecoilRollDamping = 2
	IronSightMaxSpreadDamping = 2				// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 2		// 4		1.7

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_CyborgMinigun'

	// Muzzle heat
	MuzzleHeatPerShot = 0.0075f				// Heat increase per shot
	MuzzleHeatCooldownTimeInterval = 0.025f	// Time between each decrease tick
	MuzzleHeatCooldownAmount = -0.00175f		// Amount to decrease per cooldown tick
	MinMuzzleHeatRequired = 0.25f			// Minimum heat required for it to be shown
	MuzzleHeatCooldownWaitTime = 0.5f		// Time between firing and starting decrease ticks
}
