class TS_Weapon_PortableBeamCannon extends TS_Weapon_Charged; //TS_Weapon_Reloadable;



DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_PortableObelisk.Mesh.SK_BeamCannon_1P'
        AnimSets(0)=AnimSet'TS_WP_PortableObelisk.Anims.AS_WP_BeamCannon_1P'
        Animations=MeshSequenceA
        Scale=3.0
        FOV=90.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_PortableObelisk.Mesh.SK_BeamCannon_Back'
        //Translation=(X=-25)
        Scale=1.0
    End Object
    
    ArmsAnimSet = AnimSet'TS_WP_PortableObelisk.Anims.AS_WP_BeamCannon_Arms'

    AttachmentClass = class'TS_Attachment_PortableBeamCannon'

    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_PortableObeliskUnit'
    
    LeftHandIK_Offset = (X=-4,Y=-4,Z=0)
    RightHandIK_Offset = (X=8,Y=2,Z=0)
    LeftHandIK_Rotation = (Pitch=4004,Yaw=7281,Roll=8738)
    
    LeftHandIK_Relaxed_Offset = (X=-5.0,Y=-3.5,Z=1.0)
    RightHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
    LeftHandIK_Relaxed_Rotation = (Pitch=-3640,Yaw=-3640,Roll=-5461)
    RightHandIK_Relaxed_Rotation = (Pitch=-1820,Yaw=3640,Roll=5461)

    bOverrideLeftHandAnim=true
    LeftHandAnim=H_M_Hands_Closed

    PlayerViewOffset = (X=15.0,Y=25.0,Z=-18.0)

    FireOffset=(X=10,Y=7,Z=-0.5)
	
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
    FireInterval(0)=0.03
    FireInterval(1)=0.03
    
    EquipTime=1.0
	//PutDownTime=0.5
	ActionToReadyTime = 0.4
    
    Spread(0)=0.001
    Spread(1)=0.001
	IronSightAndScopedSpread(0)= 0.0001
	IronSightAndScopedSpread(1)= 0.0001
 
    WeaponFireTypes(0)=EWFT_InstantHit
    WeaponFireTypes(1)=EWFT_InstantHit

    WeaponRange=8000.0

    InstantHitDamage(0)=4
    InstantHitDamage(1)=4
    
    HeadShotDamageMult=1.1

    InstantHitDamageTypes(0)=class'TS_DmgType_PortableBeamCannon'
    InstantHitDamageTypes(1)=class'TS_DmgType_PortableBeamCannon'

    InstantHitMomentum(0)=10
    InstantHitMomentum(1)=10
    
    bInstantHit=true

    ClipSize = 100
    InitalNumClips = 21
    MaxClips = 21
    
    Ammo_Increment = 100
    AmmoIncrementRate = 1.0

    FireDelayTime = 1.0
    bCharge = true
    IronSightPostAnimDurationModifier=1.0


    ReloadTime(0) = 2.0
    ReloadTime(1) = 2.0
    
    BoltReloadAnimName(0) = "WeaponBoltReload"
    BoltReloadAnimName(1) = "WeaponBoltReload"
    BoltReloadArmAnimName(0) = "WeaponBoltReload"
    BoltReloadArmAnimName(1) = "WeaponBoltReload"

    ReloadAnimName(0) = "WeaponBoltReload"
    ReloadAnimName(1) = "WeaponBoltReload"
    ReloadAnim3PName(0) = "H_M_BoltReload"
    ReloadAnim3PName(1) = "H_M_BoltReload"
    ReloadArmAnimName(0) = "WeaponBoltReload"
    ReloadArmAnimName(1) = "WeaponBoltReload"

    

    ReloadSound(0)=SoundCue'TS_WP_PortableObelisk.Sounds.S_PortableObelisk_BoltReload'
    ReloadSound(1)=SoundCue'TS_WP_PortableObelisk.Sounds.S_PortableObelisk_BoltReload'

    BoltReloadSound(0)=SoundCue'TS_WP_PortableObelisk.Sounds.S_PortableObelisk_BoltReload'
    BoltReloadSound(1)=SoundCue'TS_WP_PortableObelisk.Sounds.S_PortableObelisk_BoltReload'
    
    WeaponPreFireAnim[0]="WeaponCharge"     //WeaponCharge
    WeaponPreFireAnim[1]="WeaponCharge"
    WeaponFireAnim[0]="WeaponFireLoop"
    WeaponFireAnim[1]="WeaponFireLoop"
    WeaponPostFireAnim[0]="WeaponFireEnd"
    WeaponPostFireAnim[1]="WeaponFireEnd"

    ArmPreFireAnim[0]="WeaponCharge"
    ArmPreFireAnim[1]="WeaponCharge"
    ArmFireAnim[0]="WeaponFireLoop"
    ArmFireAnim[1]="WeaponFireLoop"
    ArmPostFireAnim[0]="WeaponFireEnd"
    ArmPostFireAnim[1]="WeaponFireEnd"



    /****************************************/
    /*       TS Weapon Sound Tagss          */
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_PortableObelisk.Sounds.SC_BeamCannon_FireEnd',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(1)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_PortableObelisk.Sounds.SC_BeamCannon_FireEnd',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/



    WeaponPreFireSnd[0]=SoundCue'TS_WP_PortableObelisk.Sounds.Snd_PortableObelisk_Chargeup_B_Cue'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_WP_PortableObelisk.Sounds.SC_BeamCannon_FireLoop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none
    WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'

    PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_PortableObelisk.Effects.P_BeamCannon_MuzzleFlash_1P'
    MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_PortableObelisk.Effects.P_BeamCannon_MuzzleFlash_1P_ADS'
    MuzzleFlashDuration=5.0
    MuzzleFlashLightClass=class'TS_Light_LaserRifle'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 180
	CrosshairHeight = 180

    CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
    IconCoordinates=(U=726,V=532,UL=165,VL=51)
    InventoryMovieGroup=14

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableObelisk'

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
    AimRate=100
    InverseZoomOffset=0.0

	IronSightViewOffset=(X=20.0,Y=9.475,Z=-21.7)
    IronSightFireOffset=(X=10,Y=4,Z=-3)
	IronSightBobDamping=12

	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=30.0 
    ZoomedWeaponFov=45.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
}
