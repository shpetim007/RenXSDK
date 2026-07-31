class TS_Weapon_XORailgun extends TS_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

function byte BestMode()
{
    return 0;
}

simulated function bool IsInstantHit()
{
	return false; 
}

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound(WeaponDistantFireSnd);
}

DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_Railgun_1P'
        AnimSets(0)=AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_1P'
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

    ArmsAnimSet = AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_Arms'

    PlayerViewOffset=(X=10.0,Y=20.0,Z=-10.0)
    
    FireOffset=(X=200,Y=45,Z=-30)
    
    LeftHandIK_Offset=(X=2.0,Y=0.5,Z=0.0)
    LeftHandIK_Relaxed_Offset=(X=6.0,Y=-0.0,Z=3.0)
    LeftHandIK_Relaxed_Rotation=(Pitch=-3094,Yaw=4369,Roll=4369)
//  RightHandIK_Offset=(X=5.19,Y=-4.9,Z=2.04)
    RightHandIK_Relaxed_Offset=(X=2.0,Y=3.0,Z=0.0)
    RightHandIK_Relaxed_Rotation=(Pitch=910,Yaw=3640,Roll=1820)


    AttachmentClass = class'TS_Attachment_XORailgun'
	
	//-------------- Recoil
	RecoilDelay = 0.05
	MinRecoil = 2000.0
	MaxRecoil = 2400.0
	MaxTotalRecoil = 5000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 30.0
	RecoilDeclinePct = 0.8
	RecoilDeclineSpeed = 2.0
	MaxSpread = 0.12
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.3
	RecoilSpreadCrosshairScaling = 4000;	// 2500

    // Roll
    RecoilRollMultiplier = 2.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 60.0
    RecoilDeclineSpeedRoll = 6.0

    BobDamping=1.2

    bAutoFire = true
	GroupWeight=1

	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = False
	bSniping = True 
	bFastRepeater = False	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 100

    InventoryGroup=1

    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)=2.0
    FireInterval(1)=2.0

    ReloadTime(0) = 1.0
    ReloadTime(1) = 1.0

    bOverrideFireIntervalForReload=False
    
    EquipTime=0.1
    PutDownTime=0.1
	ActionToReadyTime = 0.4
    
    Spread(0)=0.05
    Spread(1)=0.05
	IronSightAndScopedSpread(0)= 0.01
	IronSightAndScopedSpread(1)= 0.01
 
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_None

    WeaponProjectiles(0)=class'TS_Projectile_XORailgun'
    WeaponProjectiles(1)=None

    ClipSize = 1
    InitalNumClips = 20
    MaxClips = 20
    Ammo_Increment = 10


    ReloadAnimName(0) = "WeaponBolt"
    ReloadAnimName(1) = "WeaponBolt"
    ReloadAnim3PName(0) = "H_M_BoltReload"
    ReloadAnim3PName(1) = "H_M_BoltReload"
    ReloadArmAnimName(0) = "WeaponBolt"
    ReloadArmAnimName(1) = "WeaponBolt"

    ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'

    WeaponFireSnd[0]=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_Fire'
    WeaponFireSnd[1]=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_AltFire'
	
	WeaponDistantFireSnd=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_DistantFire'

    WeaponPutDownSnd=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'

    PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_Railgun_Light_MuzzleFlash'
    MuzzleFlashPSCTemplate_Heroic=ParticleSystem'TS_WP_Railgun_Light.Effects.P_Railgun_Light_MuzzleFlash'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 180
	CrosshairHeight = 180

    CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
    IconCoordinates=(U=726,V=532,UL=165,VL=51)
    InventoryMovieGroup=14

	WeaponIconTexture=Texture2D'RX_WP_Railgun.UI.T_WeaponIcon_Railgun'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Railgun'

	bLocSync = true; 
	ROFTurnover = 2;

	//==========================================
    // IRON SIGHT PROPERTIES
    //==========================================
    
    // IronSight:
    bIronSightCapable = True //true 
    bDisplayCrosshairInIronsight = false
    IronSightViewOffset=(X=10.0,Y=15.0,Z=-5.0)
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
    IronSightMinRecoilDamping = 2               // 2        1.5
    IronSightMaxRecoilDamping = 2               // 2        1.5
    IronSightMaxTotalRecoilDamping = 2          // 2        1.5
    IronSightRecoilYawDamping = 2                   // 1        1.0
    IronSightRecoilRollDamping = 2
    IronSightMaxSpreadDamping = 2               // 2        1.5
    IronSightSpreadIncreasePerShotDamping = 3       // 4        1.7
}
