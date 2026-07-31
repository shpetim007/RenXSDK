class TS_Weapon_PulseCannon extends TS_Weapon_Charged;


DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_IonRifle.Mesh.SK_IonRifle_1P'
        AnimSets(0)=AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_1P'
        Materials(0)=MaterialInstanceConstant'TS_WP_IonRifle.Materials.MI_PulseCannon'
        Animations=MeshSequenceA
        FOV=90.0
        Scale=3.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_LaserRifle.Mesh.SK_WP_LaserRifle_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_PulseCannon'
    
    ArmsAnimSet = AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_Arms'
    
    PlayerViewOffset=(X=5.0,Y=2.0,Z=-7.0)

    FireOffset=(X=30.0,Y=15.0,Z=-20.0)
    
    LeftHandIK_Relaxed_Offset = (X=2.250000,Y=0.720000,Z=0.000000)
    LeftHandIK_Relaxed_Rotation = (Pitch=-2912,Yaw=0,Roll=364)
    RightHandIK_Relaxed_Offset = (X=-2.000000,Y=2.000000,Z=-5.000000)
    RightHandIK_Relaxed_Rotation = (Pitch=-3822,Yaw=910,Roll=8192)
    
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
    ShotCost(1)=1
    
    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0
    
    FireInterval(0)=+0.5
    FireInterval(1)=+0.5

    FireAnimLength(0)=1.0
    FireAnimLength(1)=1.0

    EquipTime=0.75
    //PutDownTime=0.3

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_PulseCannon'
    WeaponProjectiles(1)=class'TS_Projectile_PulseCannon'

    bInstantHit=false

    bAutoFire=false
    bFirePerTap = false

    BotDamagePercentage = 1.0;

    Spread(0)=0.001
    Spread(1)=0.001
    
    IronSightAndScopedSpread(0)= 0.0
    IronSightAndScopedSpread(1)= 0.0

    ClipSize = 4
    InitalNumClips = 12
    MaxClips = 12

    Ammo_Increment = 4
    AmmoIncrementRate = 1.0

    FireDelayTime = 0.1
    bCharge = true

	ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponaltreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponaltreload"
    
    WeaponPreFireAnim[0]="WeaponFireStart"
    WeaponPreFireAnim[1]="WeaponFireStart"
    WeaponFireAnim[0]="WeaponFireLoop"
    WeaponFireAnim[1]="WeaponFireLoop"
    WeaponPostFireAnim[0]="WeaponFireEnd"
    WeaponPostFireAnim[1]="WeaponFireEnd"

    ArmPreFireAnim[0]="WeaponFireStart"
    ArmPreFireAnim[1]="WeaponFireStart"
    ArmFireAnim[0]="WeaponFireloop"
    ArmFireAnim[1]="WeaponFireLoop"
    ArmPostFireAnim[0]="WeaponFireEnd"
    ArmPostFireAnim[1]="WeaponFireEnd"  
    
    WeaponADSFireAnim[0]="WeaponFireLoop"
    ArmADSFireAnim[0]="WeaponFireLoop"
    
    SwapFromAbilityAnim="WeaponAimedToRest"
    SwapFromAbilityArmAnim="WeaponAimedToRest"


    /****************************************/
    /*       TS Weapon Sound Tagss          */
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_IonRifle.Sounds.S_PulseCannon_Fire_End',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(1)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_IonRifle.Sounds.S_PulseCannon_Fire_End',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/

    WeaponPreFireSnd[0]=SoundCue'TS_WP_IonRifle.Sounds.S_PulseCannon_Fire_Start'
    WeaponPreFireSnd[1]=SoundCue'TS_WP_IonRifle.Sounds.S_PulseCannon_Fire_Start'

    ReloadSound(0)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'
    ReloadSound(1)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'

    PickupSound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_IonRifle.Effects.P_PulseCannon_MuzzleFlash_1P'
    MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_IonRifle.Effects.P_PulseCannon_MuzzleFlash_ADS'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

    CrosshairWidth = 256
    CrosshairHeight = 256
    
    // AI Hints:
    //MaxDesireability=0.7
    AIRating=+0.4
    CurrentRating=+0.4
    bFastRepeater=true

    bSplashJump=false
    bRecommendSplashDamage=false
    bSniping=false 
    bOkAgainstBuildings=true	
	bOkAgainstVehicles=true	

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_IonRifle'
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = true
	IronSightViewOffset=(X=-5.0,Y=-10.755,Z=-5.25)     //Z=-3.45
	IronSightFireOffset=(X=30,Y=0,Z=-12)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=50.0 
	ZoomedWeaponFov=15.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=210.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

    
	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_PulseCannon'

	
	bLocSync = true; 
	LocSyncIncrement = 12; 
}
