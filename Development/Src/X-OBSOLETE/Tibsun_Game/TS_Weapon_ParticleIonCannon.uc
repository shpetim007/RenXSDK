class TS_Weapon_ParticleIonCannon extends TS_Weapon_HeatLimited; //TS_Weapon_Charged;


DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

   // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_1P'
        AnimSets(0)=AnimSet'RX_WP_LaserChaingun.Anims.AS_LCG_1P'
        Animations=MeshSequenceA
        Scale=2.0
        FOV=90.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_ParticleIonCannon'
    
    ArmsAnimSet = AnimSet'RX_WP_LaserChaingun.Anims.AS_LCG_Arms'
    
    PlayerViewOffset=(X=-25.0,Y=-5.0,Z=-6.0)

    FireOffset=(X=30.0,Y=18.0,Z=-35.0)
    
    LeftHandIK_Offset=(X=0,Y=0,Z=0)
    LeftHandIK_Rotation=(Pitch=3458,Yaw=-364,Roll=-2730)
    RightHandIK_Offset=(X=0,Y=0,Z=0)
    
    LeftHandIK_Relaxed_Offset = (X=-0.110000,Y=-5.445000,Z=5.880000)
    LeftHandIK_Relaxed_Rotation = (Pitch=4733,Yaw=3640,Roll=4915)
    
   //-------------- Recoil
    RecoilDelay = 0.0
    MinRecoil = 50.0
    MaxRecoil = -50.0
    MaxTotalRecoil = 10000.0
    RecoilInterpSpeed = 90.0
    RecoilDeclinePct = 0.5
    RecoilDeclineSpeed = 45.0
    MaxSpread = 0.05
    RecoilSpreadIncreasePerShot = 0.0
    RecoilSpreadDeclineSpeed = 0.05
    RecoilSpreadDecreaseDelay = 0.15
    RecoilSpreadCrosshairScaling = 2000;

    // Yaw
    RecoilYawMultiplier = 2.0
    RecoilYawModifier = 0.5
    RecoilInterpSpeedYaw = -1.0
    RecoilDeclineSpeedYaw = 2.0

    // Roll
    RecoilRollMultiplier = 3.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 60.0
    RecoilDeclineSpeedRoll = 12.0

    // IronSights
    IronSightMinRecoilDamping = 1.6
    IronSightMaxRecoilDamping = 1.6
    IronSightMaxTotalRecoilDamping = 2
    IronSightRecoilYawDamping = 2
    IronSightRecoilRollDamping = 2
    IronSightMaxSpreadDamping = 2
    IronSightSpreadIncreasePerShotDamping = 2



    WeaponRecoilLocMin(0) = (X=-1.5,Y=0.25,Z=0.25)
    WeaponRecoilLocMax(0) = (X=-3.0,Y=-0.25,Z=-0.25)

    IronsightWeaponRecoilLocMod(0) = (X=0.5,Y=0.1,Z=0.1)
    IronsightWeaponRecoilLocMod(1) = (X=0.5,Y=-0.1,Z=-0.1)

    CameraRecoilRotMin[0] = (Pitch = -273, Roll = -273, Yaw = -273)
    CameraRecoilRotMin[1] = (Pitch = -273, Roll = -273, Yaw = -273)

    CameraRecoilRotMax[0] = (Pitch = 273, Roll = 273, Yaw = 273)
    CameraRecoilRotMax[1] = (Pitch = 273, Roll = 273, Yaw = 273)



    //-----------------------------------//

    InventoryGroup=1

    ShotCost(0)=1
    ShotCost(1)=1
    
    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0
    
    FireInterval(0)=+0.03
    FireInterval(1)=+0.03

    ReloadTime(0) = 2.0
    ReloadTime(1) = 2.0

    EquipTime=0.75
    //PutDownTime=0.5

    WeaponFireTypes(0)=EWFT_InstantHit
    WeaponFireTypes(1)=EWFT_InstantHit
    
//    WeaponProjectiles(0)=class'TS_Projectile_ParticleIonCannon'
//    WeaponProjectiles(1)=class'TS_Projectile_ParticleIonCannon'

    WeaponRange=8000.0

    InstantHitDamage(0)=4
    InstantHitDamage(1)=4
    
    HeadShotDamageMult=1.1

    InstantHitDamageTypes(0)=class'TS_DmgType_ParticleIonCannon'
    InstantHitDamageTypes(1)=class'TS_DmgType_ParticleIonCannon'

    InstantHitMomentum(0)=10
    InstantHitMomentum(1)=10
    
    bInstantHit=true

    BotDamagePercentage = 1.0;

    Spread(0)=0.001
    Spread(1)=0.001
    
    IronSightAndScopedSpread(0)= 0.001
    IronSightAndScopedSpread(1)= 0.001

    ClipSize = 100
    InitalNumClips = 21
    MaxClips = 21
    
    Ammo_Increment = 100
    AmmoIncrementRate = 1.0

    FireDelayTime = 1.0
    bCharge = true

    HeatIncreasePerShot[0] = 1
    HeatIncreasePerShot[1] = 1
    HeatDecreasePerSec = 50

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
    WeaponSounds(0)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_ParticleCannon.Sounds.ParticleCannon_FireEnd',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(1)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_ParticleCannon.Sounds.ParticleCannon_FireEnd',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/


    WeaponPreFireSnd[0]=SoundCue'TS_WP_ParticleCannon.Sounds.SC_PIC_ChargeUp'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_WP_ParticleCannon.Sounds.SC_PIC_FireLoop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'TS_WP_ParticleCannon.Sounds.ParticleCannon_FireEnd'
    WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_PutDown'
    WeaponEquipSnd=none //SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip'

    ReloadSound(0)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'
    ReloadSound(1)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'

    PickupSound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_PIC_MuzzleFlash_1P'
    MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_ParticleCannon.Effects.P_PIC_MuzzleFlash_1P'
    MuzzleFlashPSCTemplate_Heroic=ParticleSystem'TS_WP_ParticleCannon.Effects.P_PIC_MuzzleFlash_1P'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

    CrosshairWidth = 195
    CrosshairHeight = 195
    
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

    WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
    
    //==========================================
    // IRON SIGHT PROPERTIES
    //==========================================
    
    // IronSight:
    bIronSightCapable = true    
    bDisplayCrosshairInIronsight = true
    IronSightViewOffset=(X=-10.0,Y=-10.0,Z=-5.0)
    IronSightFireOffset=(X=30,Y=0,Z=-12)
    IronSightBobDamping=30
    IronSightPostAnimDurationModifier=0.2
    // This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
    ZoomedFOVSub=30.0 
    ZoomedWeaponFov=15.0
    // New lower speed movement values for use while zoom aiming
    ZoomGroundSpeed=210.0
    ZoomAirSpeed=340.0
    ZoomWaterSpeed=11

    
    /** one1: Added. */
    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_SonicResonator'

    
    bLocSync = true; 
    LocSyncIncrement = 12; 
}
