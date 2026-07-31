class TS_Weapon_LightMachineGun extends TS_Weapon_Charged;


DefaultProperties
{

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_LightRailgun_1P_LMG'
		AnimSets(0)=AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_LightRailgun_1P'
		Animations=MeshSequenceA
		Scale=3.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_LightRailgun_Back'
		// Translation=(X=-15)
		Scale=1.0
	End Object

	ArmsAnimSet = AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_LightRailgun_Arms'

	PlayerViewOffset=(X=0.0,Y=0.0,Z=0.0)
	
	FireOffset=(X=10,Y=10,Z=-13)
	
	LeftHandIK_Offset=(X=2.0,Y=0.5,Z=0.0)
	LeftHandIK_Relaxed_Offset=(X=6.0,Y=-0.0,Z=3.0)
	LeftHandIK_Relaxed_Rotation=(Pitch=-3094,Yaw=4369,Roll=4369)
//	RightHandIK_Offset=(X=5.19,Y=-4.9,Z=2.04)
	RightHandIK_Relaxed_Offset=(X=2.0,Y=3.0,Z=0.0)
	RightHandIK_Relaxed_Rotation=(Pitch=910,Yaw=3640,Roll=1820)


	AttachmentClass = class'TS_Attachment_LightMachineGun'
	
	BobDamping=1.2
	//-------------- Recoil --------------//
	
	// Intensity
	RecoilDelay = 0.02
	MinRecoil = 125.0
	MaxRecoil = 150.0
	MaxTotalRecoil = 1000.0

	// Pitch
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 4.0

	// Yaw
	RecoilYawMultiplier = 1.0
	RecoilYawModifier = 0.5
	RecoilInterpSpeedYaw = 25.0
	RecoilDeclineSpeedYaw = 4.0

	// Roll
	RecoilRollMultiplier = 3.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 75.0
	RecoilDeclineSpeedRoll = 16.0

	// Spread
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.00035
	RecoilSpreadDeclineSpeed = 0.2
	RecoilSpreadDecreaseDelay = 0.2
	RecoilSpreadCrosshairScaling = 1500;

	// IronSights
	IronSightMinRecoilDamping = 1.5
	IronSightMaxRecoilDamping = 1.5
	IronSightMaxTotalRecoilDamping = 1
	IronSightRecoilYawDamping = 2
	IronSightRecoilRollDamping = 1.0
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 10

	//-----------------------------------//


    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)=+0.07
    FireInterval(1)=+2.0
    ReloadTime(0) = 4.0
    ReloadTime(1) = 4.0

    EquipTime=0.75
	//PutDownTime=0.3
	ActionToReadyTime = 0.15

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile

	WeaponProjectiles(0)=class'TibSun_Game.TS_Projectile_LightMachineGun'
	WeaponProjectiles(1)=class'TibSun_Game.TS_Projectile_LightMachineGun'

	WeaponRange=5000.0

	InstantHitDamage(0)=8
	InstantHitDamage(1)=8
	
	HeadShotDamageMult=1.5

	InstantHitDamageTypes(0)=class'TS_DmgType_LightMachineGun'
	InstantHitDamageTypes(1)=class'TS_DmgType_LightMachineGun'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000

	bInstantHit = true
    
	Spread(0)=0.0001
    Spread(1)=0.0001

    ClipSize = 150
    InitalNumClips = 4
	MaxClips = 4
	
	Ammo_Increment = 50
	AmmoIncrementRate = 1.0

    ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
	ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"
	
	WeaponPreFireAnim[0]="WeaponADSFireStart"
    WeaponPreFireAnim[1]="WeaponADSFireStart"
    WeaponFireAnim[0]="WeaponADSFireloop"
    WeaponFireAnim[1]="WeaponADSFireStart"
    WeaponPostFireAnim[0]="WeaponADSFireEnd"
    WeaponPostFireAnim[1]="WeaponADSFireEnd"

    ArmPreFireAnim[0]="WeaponADSFireStart"
    ArmPreFireAnim[1]="WeaponADSFireStart"
    ArmFireAnim[0]="WeaponADSFireloop"
    ArmFireAnim[1]="WeaponADSFireStart"
    ArmPostFireAnim[0]="WeaponADSFireEnd"
    ArmPostFireAnim[1]="WeaponADSFireEnd"



    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
//	WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun_Light.Sounds.LMG.SC_LMG_Fire_1P',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
//	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun_Light.Sounds.LMG.SC_LMG_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun_Light.Sounds.SC_LRG_Fire_Single',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun_Light.Sounds.SC_LRG_Fire_Single_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)


	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/


 
	WeaponPreFireSnd[0]=none
	WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none //SoundCue'TS_WP_Railgun_Light.Sounds.SC_LMG_FireLoop'
    WeaponFireSnd[1]=none
	WeaponPostFireSnd[0]=none //SoundCue'TS_WP_Railgun_Light.Sounds.SC_LMG_FireStop'
	WeaponPostFireSnd[1]=none

	WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'
	ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_Light_Reload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_Light_Reload'

	PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    MuzzleFlashSocket=MuzzleFlashSocket
	FireSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_Nod_1P'
	MuzzleFlashDuration=0.1
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=4

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_LMG'

    
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
    bOkAgainstVehicles = False

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 400

	FireDelayTime = 0.01
	bCharge = true
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = true
	IronSightViewOffset=(X=-8.0,Y=-11.13,Z=-2.325)
	IronSightFireOffset=(X=0,Y=0,Z=-5)
	IronSightBobDamping=4
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=35.0 
	ZoomedWeaponFov=20.0
	ZoomedTargetFOV=60.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11


	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_LightMachineGun'

	/**********************/
	
	//Burst Fire Variables//
//	TimeBetweenBursts = 0.08
//	BurstNum = 4
//	Burst_Cooldown(0) = 0.75
//	Burst_Cooldown(1) = 0.75
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = 0.0 //Can't drop and part of the JJ (Probably)

	// Muzzle heat
	MuzzleHeatPerShot = 0.01f				// Heat increase per shot
	MuzzleHeatCooldownTimeInterval = 0.025f	// Time between each decrease tick
	MuzzleHeatCooldownAmount = -0.0025f		// Amount to decrease per cooldown tick
	MinMuzzleHeatRequired = 0.1f			// Minimum heat required for it to be shown
	MuzzleHeatCooldownWaitTime = 0.5f		// Time between firing and starting decrease ticks
}
