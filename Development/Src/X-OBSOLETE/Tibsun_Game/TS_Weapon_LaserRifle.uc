class TS_Weapon_LaserRifle extends TS_Weapon_Charged;


DefaultProperties
{
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_LaserRifle.Mesh.SK_WP_LaserRifle_1P'
        AnimSets(0)=AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_1P'
        Animations=MeshSequenceA
        FOV=75.0
		Scale=2.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_LaserRifle.Mesh.SK_WP_LaserRifle_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_LaserRifle'
	
	ArmsAnimSet = AnimSet'TS_WP_LaserRifle.Anims.AS_WP_LaserRifle_Arms'
	
	PlayerViewOffset=(X=5.0,Y=-1.0,Z=-2.0)

	FireOffset=(X=20.0,Y=10.0,Z=-12.0)
	
	LeftHandIK_Relaxed_Offset = (X=2.250000,Y=0.720000,Z=0.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=-2912,Yaw=0,Roll=364)
	RightHandIK_Relaxed_Offset = (X=-2.000000,Y=2.000000,Z=-5.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=-3822,Yaw=910,Roll=8192)
	
	//-------------- Recoil --------------//
	
	//-------------- Recoil
    RecoilDelay = 0.0
    MinRecoil = -25.0
    MaxRecoil = -30.0
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
    RecoilRollMultiplier = 6.0
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



	WeaponRecoilLocMin(0) = (X=-2.0,Y=0.5,Z=0.5)
    WeaponRecoilLocMin(1) = (X=-2.5,Y=-0.5,Z=-0.5)

    IronsightWeaponRecoilLocMod(0) = (X=1.0,Y=0.25,Z=0.25)
    IronsightWeaponRecoilLocMod(1) = (X=1.0,Y=-0.25,Z=-0.25)



	//-----------------------------------//
	
	CrosshairWidth = 195
	CrosshairHeight = 195

    ShotCost(0)=1
    ShotCost(1)=0

    FireInterval(0)=+0.065
    FireInterval(1)=+0.065
	
    ReloadTime(0) = 3.667
    ReloadTime(1) = 3.667
    
    EquipTime=0.75
	//PutDownTime=0.3

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

    Spread(0)=0.001
    Spread(1)=0.001
    
    IronSightAndScopedSpread(0)= 0.0
    IronSightAndScopedSpread(1)= 0.0

	WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile

	WeaponProjectiles(0)=class'TS_Projectile_LaserRifle'


	WeaponRange=8000.0

    InstantHitDamage(0)=10
    InstantHitDamage(1)=10
    
    HeadShotDamageMult=1.1

	InstantHitDamageTypes(0)=class'TS_DmgType_LaserRifle'
	InstantHitDamageTypes(1)=class'TS_DmgType_LaserRifle'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
	bInstantHit=true


    ClipSize = 50
    InitalNumClips = 12
    MaxClips = 12
    
    Ammo_Increment = 50
    AmmoIncrementRate = 1.0

    FireDelayTime = 0.01
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
	
	WeaponADSFireAnim[0] = "WeaponIdle"
    ArmADSFireAnim[0] = "WeaponIdle"

	
	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_FireEnd',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(1)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_FireEnd',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/



	WeaponPreFireSnd[0]=none //SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_FireStart'
    WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_FireLoop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_FireEnd'
    WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_PutDown'
    WeaponEquipSnd=none //SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip'
    ReloadSound(0)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'
    ReloadSound(1)=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Reload'

    PickupSound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_LaserRifle.Effects.P_LaserRifle_MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_LaserRifle.Effects.P_LaserRifle_MuzzleFlash_1P_ADS'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_LaserRifle'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=10

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PlasmaRifle'
    
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
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=-3.0,Y=-7.17,Z=0.f)
	IronSightFireOffset=(X=-8,Y=0,Z=-5)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=10.0 
	ZoomedWeaponFov=15.0
    InverseZoomOffset=0.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=210.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

    
	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_LaserRifle'

	
	bLocSync = true; 
	LocSyncIncrement = 12; 
}
