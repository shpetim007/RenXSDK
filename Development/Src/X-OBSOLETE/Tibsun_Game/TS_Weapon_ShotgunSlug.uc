class TS_Weapon_ShotgunSlug extends TS_Weapon_Reloadable;


defaultproperties
{
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
        bCauseActorAnimEnd=true
    End Object

    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'RX_WP_Shotgun.Mesh.SK_WP_Shotgun_1P_Alt'
        AnimSets(0)=AnimSet'RX_WP_Shotgun.Anims.AS_Shotgun_1P'
        Animations=MeshSequenceA
		Scale=3.0
        FOV=75.0
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_Shotgun.Mesh.SK_WP_Shotgun_Back'
        //Translation=(X=-10)
        Scale=1.0
    End Object
	
    ArmsAnimSet = AnimSet'RX_WP_Shotgun.Anims.AS_Shotgun_Arms_Alternative' //AnimSet'RX_WP_Shotgun.Anims.AS_Shotgun_Arms'

    	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	RightHandIK_Offset=(X=6,Y=-1,Z=-2)
	
	LeftHandIK_Relaxed_Offset = (X=0.000000,Y=-2.000000,Z=4.000000)

    AttachmentClass=class'TS_Attachment_ShotgunSlug'

    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Shotgun'
	
    PlayerViewOffset=(X=0.0,Y=-6.0,Z=2.0)

    FireOffset=(X=5,Y=7,Z=-5)
	

	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 700.0
	MaxRecoil = 800.0
	MaxTotalRecoil = 30000.0
	RecoilInterpSpeed = 25.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 5.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.05
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 1.0
	RecoilSpreadCrosshairScaling=2000

	// Yaw
	RecoilYawModifier = 0.5
	RecoilYawMultiplier = 1.0
	RecoilInterpSpeedYaw = 35
	RecoilDeclineSpeedYaw = 5

	// Roll
	RecoilRollMultiplier = 1.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 35.0
	RecoilDeclineSpeedRoll = 5.0

	CameraRecoilRotMin[0] = (Pitch=-182,Yaw=-25,Roll=-187)
	CameraRecoilRotMax[0] = (Pitch=-273,Yaw=25,Roll=187)


    ShotCost(0)=1
    ShotCost(1)=1

    Spread(0)=0.05
    Spread(1)=0.05

	IronSightAndScopedSpread(0)= 0.0001
	IronSightAndScopedSpread(1)= 0.0001

    EquipTime=0.75
	//PutDownTime=0.3

    ClipSize = 8
    InitalNumClips = 6
	MaxClips = 6
	
	Ammo_Increment = 8
	AmmoIncrementRate = 1.0

	bAutoFire = False
 
    FireInterval(0)=0.9
    FireInterval(1)=0.9

    FireAnimLength[0] = 1.0
	FireAnimLength[1] = 1.0
    
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
        
	WeaponProjectiles(0)=class'TS_Projectile_Shotgun_Slug'

	WeaponRange=2000.0

	InstantHitDamage(0)=65
	InstantHitDamage(1)=65
	
	HeadShotDamageMult=1.5

	InstantHitDamageTypes(0)=class'TS_DmgType_Shotgun'
	InstantHitDamageTypes(1)=class'TS_DmgType_Shotgun'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
	bInstantHit=true



	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/



    WeaponFireSnd[0]=none//SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Fire'
    WeaponFireSnd[1]=none//SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Fire'

    WeaponPutDownSnd=none//SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_PutDown'
    WeaponEquipSnd=none//SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Equip'
    PickupSound=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Equip'

    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0

    MuzzleFlashSocket=MuzzleFlashSocket
    FireSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_1P'
    MuzzleFlashDuration=0.1
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

    PerBulletReload = True
    /** Shotgun uses a 3-state reloading system **/
    ReloadAnimName(2) = "WeaponReloadStart"
    ReloadArmAnimName(2) = "WeaponReloadStart"
    ReloadAnim3PName(2) = "H_M_Shotgun_Reload_Start"
    ReloadSound(2)=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Reload_Start'
    ReloadTime(2) = 0.4
    ReloadAnimName(1) = "WeaponReloadLoop"
    ReloadArmAnimName(1) = "WeaponReloadLoop"
    ReloadAnim3PName(1) = "H_M_Shotgun_Reload_Loop"
    ReloadSound(1)=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Reload_Loop'
    ReloadTime(1) = 0.4
    ReloadAnimName(0) = "WeaponReloadEnd"
    ReloadArmAnimName(0) = "WeaponReloadEnd"
    ReloadAnim3PName(0) = "H_M_Shotgun_Reload_Stop"
    ReloadSound(0)=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Reload_End'
    ReloadTime(0) = 0.4

    SwapFromAbilityAnim = "WeaponAimedToRest"
	SwapFromAbilityArmAnim = "WeaponAimedToRest"

    WeaponFireAnim(0)=WeaponFire
    WeaponFireAnim(1)=WeaponAltFire
    ArmFireAnim(0)=WeaponFire
    ArmFireAnim(1)=WeaponAltFire
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
//	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_None'

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=7

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Spas12'
    
    /****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False

	bSniping = False 
	bFastRepeater = False	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.5
	AIRating=+0.3
	CurrentRating=+0.3
	AimError = 545 

	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=0,Y=-11.58,Z=5.595)
	IronSightFireOffset=(X=0,Y=0,Z=-2)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=30.0 
	ZoomedTargetFOV=60.0
	InverseZoomOffset=0.0
//	ZoomedWeaponFov 65.000000
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=190.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2					// 2		1.5
	IronSightMaxRecoilDamping = 2					// 2		1.5
	IronSightMaxTotalRecoilDamping = 2				// 2		1.5
	IronSightRecoilYawDamping = 1					// 1		1.0
	IronSightMaxSpreadDamping = 2					// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 10		// 4		1.7
	
	
	bLocSync = true; 
	LocSyncIncrement = 4; 

}
