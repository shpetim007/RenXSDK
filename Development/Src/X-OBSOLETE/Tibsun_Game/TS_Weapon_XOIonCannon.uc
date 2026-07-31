class TS_Weapon_XOIonCannon extends TS_Weapon_Charged;


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
        FOV=75.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_XOIonCannon'
	
	ArmsAnimSet = AnimSet'RX_WP_LaserChaingun.Anims.AS_LCG_Arms'
	
	PlayerViewOffset=(X=10.0,Y=20.0,Z=-10.0)
    
    FireOffset=(X=200,Y=45,Z=-30)
	
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

    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)= 3
    FireInterval(1)= 3
    ReloadTime(0) = 2
    ReloadTime(1) = 2

    bOverrideFireIntervalForReload=False
    
    EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_XOIonCannon'
    WeaponProjectiles(1)=class'TS_Projectile_XOIonCannon' 

    Spread(0)=0.05
    Spread(1)=0.05

    IronSightAndScopedSpread(0)=0.01
    IronSightAndScopedSpread(1)=0.01

    bAutoFire=False
       
    ClipSize = 5
    InitalNumClips = 1
	MaxClips = 1
	
	Ammo_Increment = 1
	AmmoIncrementRate = 0.1

	FireDelayTime = 8
    bCharge = true

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
	ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"
	
	WeaponPreFireAnim[0]="WeaponADSFireStart"
    WeaponPreFireAnim[1]="WeaponADSFireStart"
    WeaponFireAnim[0]="WeaponADSFireloop"
    WeaponFireAnim[1]="WeaponADSFireStart"
    WeaponPostFireAnim[0]="WeaponADSFireEnd"
    WeaponPostFireAnim[1]="WeaponADSFireEnd"

    ArmPreFireAnim[0]="WeaponADSFireStart"
    ArmPreFireAnim[1]="WeaponADSFireStart"
    ArmFireAnim[0]="WeaponADSFireloop"
    ArmFireAnim[1]="WeaponADSFireStart"
    ArmPostFireAnim[0]="WeaponADSFireEnd"
    ArmPostFireAnim[1]="WeaponADSFireEnd"



    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 
    

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_ParticleCannon.Sounds.SC_XOIonCannon_SingleFire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_ParticleCannon.Sounds.SC_XOIonCannon_SingleFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/ 


 
	WeaponPreFireSnd[0]=SoundCue'TS_WP_ParticleCannon.Sounds.SC_XOIonCannon_ChargeUp'
	WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
	WeaponPostFireSnd[0]=none
	WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip'
    WeaponEquipSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown'
    ReloadSound(0)=SoundCue'TS_WP_DiscLauncher.Sounds.SC_DiscLauncher_Reload'
    ReloadSound(1)=SoundCue'TS_WP_DiscLauncher.Sounds.SC_DiscLauncher_Reload'

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

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = False
	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = True
    bOkAgainstVehicles = True

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 200

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
	IronSightMinRecoilDamping = 2				// 2		1.5
	IronSightMaxRecoilDamping = 2				// 2		1.5
	IronSightMaxTotalRecoilDamping = 2			// 2		1.5
	IronSightRecoilYawDamping = 2					// 1		1.0
	IronSightRecoilRollDamping = 2
	IronSightMaxSpreadDamping = 2				// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 3		// 4		1.7
}
	