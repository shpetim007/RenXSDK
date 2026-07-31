class TS_Weapon_Minigun extends TS_Weapon_Charged;


DefaultProperties
{

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_Minigun.Mesh.SK_Minigun_1P'
        AnimSets(0)=AnimSet'RX_WP_ChainGun.Anims.AS_Chaingun_1P_Alternative'
        Animations=MeshSequenceA
        FOV=75
		Scale=2.0
    End Object
	
	ArmsAnimSet = AnimSet'RX_WP_ChainGun.Anims.AS_Chaingun_Arms_New'

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_Minigun.Mesh.SK_Minigun_Back'
        // Translation=(X=-15)
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_Minigun'
	
	PlayerViewOffset=(X=-5.0,Y=2.0,Z=-3.0)
	
	FireOffset=(X=35,Y=30,Z=-35)
	
	// Side Handle
//	LeftHandIK_Offset=(X=0,Y=0,Z=0)
//	LeftHandIK_Rotation=(Pitch=2730,Yaw=-3458,Roll=-364)
//	RightHandIK_Offset=(X=0,Y=0,Z=0)

	// Upper Handle
	LeftHandIK_Offset = (X=5.610700,Y=15.237499,Z=13.125501)
	LeftHandIK_Rotation = (Pitch=-6917,Yaw=-6917,Roll=10740)
	RightHandIK_Offset = (X=3.0,Y=-5.0,Z=-3.0)
	
	LeftHandIK_Relaxed_Offset = (X=6.630000,Y=15.318001,Z=14.550000)
	LeftHandIK_Relaxed_Rotation = (Pitch=3822,Yaw=-1274,Roll=6007)
	RightHandIK_Relaxed_Offset = (X=0.000000,Y=-6.000000,Z=-0.690000)
	RightHandIK_Relaxed_Rotation = (Pitch=2548,Yaw=0,Roll=-3640)
	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed
	
	BobDamping=1.2
	//-------------- Recoil --------------//
	
	// Intensity
	RecoilDelay = 0.02
	MinRecoil = 65.0
	MaxRecoil = 75.0
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
    FireInterval(0)=+0.05
    FireInterval(1)=+2.0
    ReloadTime(0) = 4.0
    ReloadTime(1) = 4.0

    EquipTime=0.75
	//PutDownTime=0.3
	ActionToReadyTime = 0.15

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile

	WeaponProjectiles(0)=class'TibSun_Game.TS_Projectile_Minigun'
	WeaponProjectiles(1)=class'TibSun_Game.TS_Projectile_Minigun'

	WeaponProjectiles_Nod(0)=class'TibSun_Game.TS_Projectile_Minigun_Nod'
	WeaponProjectiles_Nod(1)=class'TibSun_Game.TS_Projectile_Minigun_Nod'

	WeaponRange=5000.0

	InstantHitDamage(0)=7
	InstantHitDamage(1)=7
	
	HeadShotDamageMult=1.25

	InstantHitDamageTypes(0)=class'TS_DmgType_LightMachineGun'
	InstantHitDamageTypes(1)=class'TS_DmgType_LightMachineGun'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000

	bInstantHit = true
    
	Spread(0)=0.0001
    Spread(1)=0.0001

    FireDelayTime = 0.5
	bCharge = true

    ClipSize = 200
    InitalNumClips = 4
	MaxClips = 4
	
	Ammo_Increment = 100
	AmmoIncrementRate = 1.0

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



    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
//	WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun_Light.Sounds.LMG.SC_LMG_Fire_1P',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
//	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun_Light.Sounds.LMG.SC_LMG_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	WeaponSounds(0)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Minigun.Sounds.SC_Fire_End',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Minigun.Sounds.SC_Fire_End',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)


	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/


 
	WeaponPreFireSnd[0]=SoundCue'TS_WP_Minigun.Sounds.SC_Fire_Start'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_WP_Minigun.Sounds.SC_Fire_Loop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'RX_WP_ChainGun.Sounds.SC_ChainGun_Stop'
    WeaponPostFireSnd[1]=none

	WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'
	
	ReloadSound(0)=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_Reload'
    ReloadSound(1)=SoundCue'RX_WP_ChainGun.Sounds.SC_Chaingun_Reload'

	PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    MuzzleFlashSocket=MuzzleFlashSocket
	FireSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Minigun.Effects.P_MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_Minigun.Effects.P_MuzzleFlash_1P'
	MuzzleFlashDuration=0.1
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=4

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Minigun'

    
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

	
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = true
	IronSightViewOffset=(X=-12.0,Y=-7,Z=3.5)
	IronSightFireOffset=(X=0,Y=0,Z=-5)
	IronSightBobDamping=4
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=20.0 
	ZoomedWeaponFov=20.0
	InverseZoomOffset=0.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11


	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Minigun'

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
