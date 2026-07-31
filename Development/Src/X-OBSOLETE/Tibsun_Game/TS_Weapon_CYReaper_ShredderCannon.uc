class TS_Weapon_CYReaper_ShredderCannon extends TS_Weapon_Reloadable;

DefaultProperties
{
	bAutoFire = true

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

    AttachmentClass = class'TS_Attachment_CYReaper_ShredderCannon'
	
	PlayerViewOffset=(X=10.0,Y=20.0,Z=-5.0)
	
	FireOffset=(X=200,Y=45,Z=-30)

	LeftHandIK_Offset=(X=0.25,Y=-3.06,Z=1.04)
	LeftHandIK_Rotation=(Pitch=0,Yaw=0,Roll=0)
	LeftHandIK_Relaxed_Offset = (X=0.757900,Y=-3.926300,Z=0.610000)
	LeftHandIK_Relaxed_Rotation = (Pitch=1820,Yaw=-4551,Roll=-4733)
	
	RightHandIK_Offset=(X=5.771700,Y=-2.312800,Z=0.874400)
	RightHandIK_Relaxed_Offset = (X=2.212800,Y=0.420000,Z=-1.164800)
	RightHandIK_Relaxed_Rotation = (Pitch=-182,Yaw=3276,Roll=6735)
	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed

	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 100.0
	MaxRecoil = 150.0
	MaxTotalRecoil = 1000.0
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.4
	RecoilDeclineSpeed = 8.0
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.001
	RecoilSpreadDeclineSpeed = 0.2
	RecoilSpreadDecreaseDelay = 0.2

	// Yaw
	RecoilYawMultiplier = 1.0
	RecoilYawModifier = 0.5
	RecoilInterpSpeedYaw = 25.0
	RecoilDeclineSpeedYaw = 4.0

	// Roll
	RecoilRollMultiplier = 1.5
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 75.0
	RecoilDeclineSpeedRoll = 30.0

    ShotCost(0)=1
    ShotCost(1)=2
    FireInterval(0)=+1.0
    FireInterval(1)=+1.0
    ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0

    bBurstFire=true
    BurstNum=3
    TimeBetweenBursts=0.025
    
    EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

    
//	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(0)=EWFT_Projectile
	//WeaponFireTypes(1)=EWFT_Projectile
        
	WeaponProjectiles(0)=class'TS_Projectile_CYReaper_ShredderCannon'
	
    Spread(0)=0.025
    Spread(1)=0.025

    ClipSize = 24
    InitalNumClips = 10
    MaxClips = 10
    
    Ammo_Increment = 6
	AmmoIncrementRate = 1.0

	WeaponFireAnim[0]="WeaponFireStart"
	ArmFireAnim[0] = "WeaponFireStart"
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"


    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 
    

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_AutoShotgun.Sounds.SC_AutoShotgun_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_AutoShotgun.Sounds.SC_AutoShotgun_Fire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

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
    MuzzleFlashPSCTemplate=ParticleSystem'TS_VH_Buggy_HD.Effects.P_MuzzleFlash_Cannon'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

    CrosshairWidth = 180
	CrosshairHeight = 180

    InventoryGroup=1
    InventoryMovieGroup=22
    
    // AI Hints:
    WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_CyborgVulcan'
	
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

	MaxDesireability=0.5
	AIRating=+0.35
	CurrentRating=+0.35
	AimError = 545
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=0.0,Y=15.0,Z=-5.0)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=10
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=55.0
	ZoomedTargetFOV=45.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 2
	IronSightRecoilYawDamping = 2
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4

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
