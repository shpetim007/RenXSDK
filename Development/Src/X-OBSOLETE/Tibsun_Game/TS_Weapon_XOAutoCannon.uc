class TS_Weapon_XOAutoCannon extends TS_Weapon_Reloadable;


DefaultProperties
{
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

	// Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_GaussRifle.Mesh.SK_WP_GaussRifle'
        AnimSets(0)=AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_1P'
        Animations=MeshSequenceA
        Scale=3.0
        FOV=75.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_GaussRifle.Mesh.SK_GaussRifle_Back'
        // Translation=(X=-15)
        Scale=1.0
    End Object

    ArmsAnimSet = AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_Arms'

    PlayerViewOffset=(X=10.0,Y=17.0,Z=-26.0)
	
	FireOffset=(X=200,Y=45,Z=-30)

    AttachmentClass=class'TS_Attachment_XOAutoCannon'
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	RightHandIK_Offset=(X=3,Y=0,Z=-0)
	
	LeftHandIK_Relaxed_Offset = (X=9.000000,Y=-2.000000,Z=5.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=-2730,Yaw=-1456,Roll=11650)
	RightHandIK_Relaxed_Offset = (X=2.340000,Y=-0.720000,Z=-3.350000)
	RightHandIK_Relaxed_Rotation = (Pitch=-2730,Yaw=1274,Roll=7645)
	
	//-------------- Recoil
	RecoilDelay = 0.07
	RecoilSpreadDecreaseDelay = 0.6
	MinRecoil = 100.0
	MaxRecoil = 150.0
	MaxTotalRecoil = 2000.0

	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 1.0
	RecoilDeclineSpeed = 3.0

	RecoilSpread = 0.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.005
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadCrosshairScaling = 750;

	// Yaw
	RecoilYawMultiplier = 1.0
	RecoilYawModifier = 0.5
	RecoilInterpSpeedYaw = 20.0
	RecoilDeclineSpeedYaw = 3.0

	// Roll
	RecoilRollMultiplier = 2.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 90.0
	RecoilDeclineSpeedRoll = 30.0

    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)= 0.75
    FireInterval(1)= 0.75
    ReloadTime(0) = 4.0
    ReloadTime(1) = 4.0

    bBurstFire=true
    TimeBetweenBursts=0.08
    
    EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_XOAutoCannon'
    WeaponProjectiles(1)=class'TS_Projectile_XOAutoCannon' 

    Spread(0)=0.001
    Spread(1)=0.001
       
    ClipSize = 15
    InitalNumClips = 8
    MaxClips = 8
    
    Ammo_Increment = 3
	AmmoIncrementRate = 1.0

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
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_GaussRifle.Sounds.SC_XOGaussAutoCannon_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_GaussRifle.Sounds.SC_XOGaussAutoCannon_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/ 



    WeaponFireSnd[0]=none //SoundCue'TS_WP_GaussRifle.Sounds.SC_XOGaussAutoCannon_Fire'
    WeaponFireSnd[1]=none //SoundCue'TS_WP_GaussRifle.Sounds.SC_XOGaussAutoCannon_Fire'

    WeaponPutDownSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip'
    WeaponEquipSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown'
    ReloadSound(0)=SoundCue'TS_WP_DiscLauncher.Sounds.SC_DiscLauncher_Reload'
    ReloadSound(1)=SoundCue'TS_WP_DiscLauncher.Sounds.SC_DiscLauncher_Reload'

    PickupSound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltAutoRifle_Equip'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_XOGaussAutoCannon_MuzzleFlash_1P'
    MuzzleFlashDuration=3.3667
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 195
	CrosshairHeight = 195

    InventoryGroup=1
    InventoryMovieGroup=9

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_GaussRifle'
 
    /****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = True
	bInstantHit = False
	bSniping = False 
	bFastRepeater = False

    bOkAgainstBuildings = True
    bOkAgainstVehicles = True

	MaxDesireability=0.5
	AIRating=+0.4
	CurrentRating=+0.4
	AimError = 200

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_GaussRifle'

	
	ROFTurnover = 4
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True //true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=60.0,Y=0.849,Z=-22.0)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=20
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=60.0 
    ZoomedWeaponFov=15.0
	InverseZoomOffset=0.0

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
	IronSightSpreadIncreasePerShotDamping = 3		// 4		1.7
}
