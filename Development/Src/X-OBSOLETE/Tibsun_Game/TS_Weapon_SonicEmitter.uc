class TS_Weapon_SonicEmitter extends TS_Weapon_HeatLimited;


DefaultProperties
{
   // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_IonRifle.Mesh.SK_IonRifle_1P'
        AnimSets(0)=AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_1P'
        Materials(0)=MaterialInstanceConstant'TS_WP_IonRifle.Materials.MI_SonicEmitter'
        Animations=MeshSequenceA
        FOV=90.0
        Scale=3.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_LaserRifle.Mesh.SK_WP_LaserRifle_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_SonicEmitter'
    
    ArmsAnimSet = AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_Arms'
    
    PlayerViewOffset=(X=5.0,Y=3.0,Z=-6.0)

    FireOffset=(X=30.0,Y=10.0,Z=-15.0)
    
    LeftHandIK_Relaxed_Offset = (X=2.250000,Y=0.720000,Z=0.000000)
    LeftHandIK_Relaxed_Rotation = (Pitch=-2912,Yaw=0,Roll=364)
    RightHandIK_Relaxed_Offset = (X=-2.000000,Y=2.000000,Z=-5.000000)
    RightHandIK_Relaxed_Rotation = (Pitch=-3822,Yaw=910,Roll=8192)

    
    //-------------- Recoil
    RecoilDelay = 0.0
    MinRecoil = -50.0
    MaxRecoil = -70.0
    MaxTotalRecoil = 10000.0
    RecoilInterpSpeed = 90.0
    RecoilDeclinePct = 1.5
    RecoilDeclineSpeed = 45.0
    MaxSpread = 0.05
    RecoilSpreadIncreasePerShot = 0.0
    RecoilSpreadDeclineSpeed = 0.05
    RecoilSpreadDecreaseDelay = 0.15
    RecoilSpreadCrosshairScaling = 2000;

    // Yaw
    RecoilYawMultiplier = 1.5
    RecoilYawModifier = 0.5
    RecoilInterpSpeedYaw = -1.0
    RecoilDeclineSpeedYaw = 2.0

    // Roll
    RecoilRollMultiplier = 2.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 60.0
    RecoilDeclineSpeedRoll = 12.0

    // IronSights
    IronSightMinRecoilDamping = 2
    IronSightMaxRecoilDamping = 2
    IronSightMaxTotalRecoilDamping = 2
    IronSightRecoilYawDamping = 2
    IronSightRecoilRollDamping = 2
    IronSightMaxSpreadDamping = 2
    IronSightSpreadIncreasePerShotDamping = 2

    //-----------------------------------//

    ShotCost(0)=1
    ShotCost(1)=1
    
    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0
    
    FireInterval(0)=+0.05
    FireInterval(1)=+0.05

    EquipTime=0.75
    //PutDownTime=0.3

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_SonicEmitter'
    WeaponProjectiles(1)=class'TS_Projectile_SonicEmitter'

    Spread(0)=0.0025
    Spread(1)=0.0025
    
    IronSightAndScopedSpread(0)= 0.0
    IronSightAndScopedSpread(1)= 0.0

    FireDelayTime = 0.4
    bCharge = true

    ClipSize = 100
    InitalNumClips = 6
    MaxClips = 6

    CoolThreshold = 30

    Ammo_Increment = 20
    AmmoIncrementRate = 1.0

    HeatIncreasePerShot[0] = 1
    HeatIncreasePerShot[1] = 1
    HeatDecreasePerSec = 30

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
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_SonicResonator.Sounds.SC_SonicResonator_Fire_End',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_SonicResonator.Sounds.SC_SonicResonator_Fire_End',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)

    // Swapped Weapon Mode fire sounds
    WeaponSounds(7)=(SoundStartTag=SwappedFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_SonicResonator.Sounds.SC_SingleFire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(8)=(SoundStartTag=SwappedFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_SonicResonator.Sounds.SC_SingleFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    /****************************************/



    WeaponPreFireSnd[0]=SoundCue'TS_WP_SonicResonator.Sounds.SC_SonicResonator_Fire_Start'
    WeaponPreFireSnd[1]=SoundCue'TS_WP_SonicResonator.Sounds.SC_ChargeUp_Heavy'
    WeaponFireSnd[0]=SoundCue'TS_WP_SonicResonator.Sounds.SC_SonicResonator_Fire_Loop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'TS_WP_SonicResonator.Sounds.SC_SonicResonator_Fire_End'
    WeaponPostFireSnd[1]=none //SoundCue'TS_WP_SonicResonator.Sounds.SC_SingleFire'

    WeaponPutDownSnd=none //SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_PutDown'
    WeaponEquipSnd=none //SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip'

    PickupSound=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=none //ParticleSystem'TS_WP_SonicResonator.Effects.P_MuzzleFlash_1P'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

    CrosshairWidth = 256
    CrosshairHeight = 256
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=11

    WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_ParticleCannon'

    // Muzzle heat
    MuzzleHeatPerShot = 0.004f               // Heat increase per shot
    MuzzleHeatCooldownTimeInterval = 0.05f // Time between each decrease tick
    MuzzleHeatCooldownAmount = -0.0025f     // Amount to decrease per cooldown tick
    MinMuzzleHeatRequired = 0.1f            // Minimum heat required for it to be shown
    MuzzleHeatCooldownWaitTime = 0.5f       // Time between firing and starting decrease ticks
    
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

    MaxDesireability=0.8
    AIRating=+0.6
    CurrentRating=+0.6
    AimError = 545 


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
    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_SonicResonator'
    
    bLocSync = true; 
}
