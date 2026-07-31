class TS_Weapon_Railgun extends TS_Weapon_Charged; //TS_Weapon_Reloadable;



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

    PlayerViewOffset=(X=-5.0,Y=2.0,Z=0.0)
    
    FireOffset=(X=10,Y=10,Z=-12)
    
    LeftHandIK_Offset=(X=2.0,Y=0.5,Z=0.0)
    LeftHandIK_Relaxed_Offset=(X=6.0,Y=-0.0,Z=3.0)
    LeftHandIK_Relaxed_Rotation=(Pitch=-3094,Yaw=4369,Roll=4369)
//  RightHandIK_Offset=(X=5.19,Y=-4.9,Z=2.04)
    RightHandIK_Relaxed_Offset=(X=2.0,Y=3.0,Z=0.0)
    RightHandIK_Relaxed_Rotation=(Pitch=910,Yaw=3640,Roll=1820)


    AttachmentClass = class'TS_Attachment_Railgun'
	
	//-------------- Recoil
	RecoilDelay = 0.05
	MinRecoil = -300.0
	MaxRecoil = -360.0
	MaxTotalRecoil = 50000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 75.0
	RecoilDeclinePct = 3.0
	RecoilDeclineSpeed = 15.0
	MaxSpread = 0.12
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.3
	RecoilSpreadCrosshairScaling = 4000;	// 2500

    // Roll
    RecoilRollMultiplier = 6.0
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
    FireInterval(0)=0.5
    FireInterval(1)=1
    
    EquipTime=1.0
	//PutDownTime=0.5
	ActionToReadyTime = 0.4
    
    Spread(0)=0.025
    Spread(1)=0.025
	IronSightAndScopedSpread(0)= 0.001
	IronSightAndScopedSpread(1)= 0.001
 
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_None

    WeaponProjectiles(0)=class'TS_Projectile_Railgun'
    WeaponProjectiles(1)=None

    ClipSize = 1
    InitalNumClips = 25
    MaxClips = 25
    
    Ammo_Increment = 3
    AmmoIncrementRate = 1.0

    FireDelayTime = 0.25
    bCharge = true


    ReloadAnimName(0) = "WeaponBolt"
    ReloadAnimName(1) = "WeaponBolt"
    ReloadAnim3PName(0) = "H_M_BoltReload"
    ReloadAnim3PName(1) = "H_M_BoltReload"
    ReloadArmAnimName(0) = "WeaponBolt"
    ReloadArmAnimName(1) = "WeaponBolt"

    ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0

    ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    
    WeaponPreFireAnim[0]="WeaponIdle"     //WeaponCharge
    WeaponPreFireAnim[1]="WeaponIdle"
    WeaponFireAnim[0]="WeaponFire"
    WeaponFireAnim[1]="WeaponFire"
    WeaponPostFireAnim[0]="WeaponIdle"
    WeaponPostFireAnim[1]="WeaponIdle"

    ArmPreFireAnim[0]="WeaponIdle"
    ArmPreFireAnim[1]="WeaponIdle"
    ArmFireAnim[0]="WeaponFire"
    ArmFireAnim[1]="WeaponFire"
    ArmPostFireAnim[0]="WeaponIdle"
    ArmPostFireAnim[1]="WeaponIdle"



    /****************************************/
    /*       TS Weapon Sound Tagss          */
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/



    WeaponPreFireSnd[0]=SoundCue'TS_WP_Railgun.Sounds.SC_RailGun_ChargeUp'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none
    WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'

    PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun.Effects.P_MuzzleFlash_1P'
    MuzzleFlashPSCTemplate_Heroic=ParticleSystem'TS_WP_Railgun_Light.Effects.P_Railgun_Light_MuzzleFlash'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 180
	CrosshairHeight = 180

    CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
    IconCoordinates=(U=726,V=532,UL=165,VL=51)
    InventoryMovieGroup=14

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Railgun'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Railgun'

	bLocSync = true; 
	ROFTurnover = 2;
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = 0.0	

	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=-25.000000,Y=-11.150002,Z=1.575000)
	IronSightFireOffset=(X=10,Y=0,Z=-12)
	IronSightBobDamping=12
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
    ZoomedWeaponFov=15.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 2
	IronSightRecoilYawDamping = 1
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4
}
