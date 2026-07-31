class TS_Weapon_XOMAC extends TS_Weapon_Charged; //TS_Weapon_Reloadable;


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

    PlayerViewOffset=(X=10.0,Y=12.0,Z=-22.0)

    AttachmentClass = class'TS_Attachment_XOMAC'
    
    FireOffset=(X=200,Y=45,Z=-30)
	
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

    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)= 2
    FireInterval(1)= 2
    
    EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_XOMAC'
    WeaponProjectiles(1)=class'TS_Projectile_XOMAC' 

    Spread(0)=0.025
    Spread(1)=0.025

    IronSightAndScopedSpread(0)=0.005
    IronSightAndScopedSpread(1)=0.005

    bAutoFire=False
       
    ClipSize = 12
    InitalNumClips = 1
    MaxClips = 1
	
	Ammo_Increment = 1
	AmmoIncrementRate = 0.5

	FireDelayTime = 2.5
    bCharge = true

    BoltActionReload=true
    bUnzoomDuringBoltActionReloading = false

    BoltReloadTime(0) = 2.0 //2.0f (Factor in RefireBoltReloadInterrupt) 
    BoltReloadTime(1) = 2.0 //2.0f

    ReloadTime(0) = 2.0
    ReloadTime(1) = 2.0

    RefireBoltReloadInterrupt(0)=2.1
    RefireBoltReloadInterrupt(1)=2.1

	BoltReloadAnimName(0) = "WeaponBolt"
    BoltReloadAnimName(1) = "WeaponBolt"
    BoltReloadArmAnimName(0) = "WeaponBolt"
    BoltReloadArmAnimName(1) = "WeaponBolt"

    ReloadAnimName(0) = "WeaponBolt"
    ReloadAnimName(1) = "WeaponBolt"
    ReloadAnim3PName(0) = "H_M_BoltReload"
    ReloadAnim3PName(1) = "H_M_BoltReload"
    ReloadArmAnimName(0) = "WeaponBolt"
    ReloadArmAnimName(1) = "WeaponBolt"

    ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'

    BoltReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    BoltReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    
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
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 
    

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun.Sounds.SC_XOMAC_SingleFire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun.Sounds.SC_XOMAC_SingleFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/ 


 
	WeaponPreFireSnd[0]=SoundCue'TS_WP_Railgun.Sounds.SC_XOMAC_ChargeUp'
	WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
	WeaponPostFireSnd[0]=none
	WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip'
    WeaponEquipSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown'
    

    PickupSound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltAutoRifle_Equip'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_XOGaussAutoCannon_MuzzleFlash_1P'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
    MuzzleFlashDuration=4.0
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 195
	CrosshairHeight = 195

    InventoryGroup=1
    InventoryMovieGroup=9

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Railgun'

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
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Railgun'

	
	ROFTurnover = 4
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True //true	
	bDisplayCrosshairInIronsight = false
	AimRate=100

	IronSightViewOffset=(X=-5.0,Y=0.849,Z=-22.45)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=20
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=60.0 
    ZoomedWeaponFov=15.0

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


	/****************************************/
    /* Muzzle Heat - Red Barrel Glow Effect */
    /****************************************/ 

	MuzzleHeatPerShot=2.0

}
