class TS_Weapon_CYReaper_RocketPod extends TS_Weapon_Reloadable;


DefaultProperties
{
	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object
/*
	bPersistentLock = false
    bCanLock = false

   	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_RocketLauncher'
	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Glass' // MaterialInstanceConstant'RenXHud.MI_Reticle_Dot'
	LockedOnCrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_MissileLock'
	TargetMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_LockOnStripe'

	LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
	LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

	ConsoleLockAim=0.998
	LockRange=15000
	LockRangeAircraft=20000
	LockAim=0.998//0.999999
	LockChecktime=0.25
	LockAcquireTime=0.25
	LockTolerance=0.5 //3.0   
    bTargetLockingActive = true
    StayLocked=0.5 
    LockOnSize = 32.f
*/
	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		AnimSets(0)=AnimSet'TS_WP_RocketLauncher.Anims.AS_WP_RocketLauncher_1P'
		Animations=MeshSequenceA
		Scale=3.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_Back'
		//Translation=(X=-25)
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'TS_WP_RocketLauncher.Anims.AS_WP_RocketLauncher_Arms'

	AttachmentClass = class'TS_Attachment_CYReaper_RocketPod'

	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_RocketLauncher'
	
	WideScreenOffsetScaling = 0.0
	BobDamping = 0.6

	PlayerViewOffset=(X=12.0,Y=20.0,Z=-5.0)
	
	FireOffset=(X=200,Y=45,Z=-30)
	
	LeftHandIK_Offset=(X=-3.054600,Y=-3.855900,Z=0.031600)
	LeftHandIK_Rotation=(Pitch=910,Yaw=2002,Roll=-1092)
	RightHandIK_Offset=(X=9.595700,Y=1.008600,Z=-1.700000)
	
	LeftHandIK_Relaxed_Offset = (X=-3.0,Y=-5.,Z=0.0)
	LeftHandIK_Relaxed_Rotation = (Pitch=2912,Yaw=-3640,Roll=-4733)
	RightHandIK_Relaxed_Offset = (X=-0.685800,Y=-4.620000,Z=-5.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=364,Yaw=3458,Roll=7463)
	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 200.0
	MaxRecoil = 250.0
	MaxTotalRecoil = 1000.0
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.4
	RecoilDeclineSpeed = 8.0
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.01
	RecoilSpreadDeclineSpeed = 0.2
	RecoilSpreadDecreaseDelay = 0.2

	// Yaw
	RecoilYawMultiplier = 1.0
	RecoilYawModifier = 0.5
	RecoilInterpSpeedYaw = 25.0
	RecoilDeclineSpeedYaw = 4.0

	// Roll
	RecoilRollMultiplier = 1.5
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 75.0
	RecoilDeclineSpeedRoll = 30.0

	ShotCost(0)=1
	ShotCost(1)=1
	FireInterval(0)=+0.2
	FireInterval(1)=+0.2
	ReloadTime(0) = 3.5
	ReloadTime(1) = 3.5

	bOverrideFireIntervalForReload=False

	
	EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.75

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	
	WeaponProjectiles(0)=class'TS_Projectile_CYReaper_RocketPod'
	WeaponProjectiles(1)=class'TS_Projectile_CYReaper_RocketPod'

	WeaponProjectilesAir(0)=class'TS_Projectile_CYReaper_RocketPod'
    WeaponProjectilesAir(1)=class'TS_Projectile_CYReaper_RocketPod'

	Spread(0)=0.01
	Spread(1)=0.01

	SpreadScoped=0.001
	SpreadNoScoped=0.2

	IronSightAndScopedSpread(0)=0.001
	IronSightAndScopedSpread(1)=0.001

	
	ClipSize = 15
	InitalNumClips = 6
	MaxClips = 6
	
	Ammo_Increment = 3
	AmmoIncrementRate = 1.0

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_RocketLauncher_Reload"
	ReloadAnim3PName(1) = "H_M_RocketLauncher_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	SwapFromAbilityAnim = "WeaponAimedToRest"
	SwapFromAbilityArmAnim = "WeaponAimedToRest" 


	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 
    

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_MissileLauncher.Sounds.SC_CYReaper_RocketPod_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_MissileLauncher.Sounds.SC_CYReaper_RocketPod_Fire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/ 


	WeaponFireSnd[0]=none //SoundCue'TS_WP_MissileLauncher.Sounds.SC_CYReaper_RocketPod_Fire'
	WeaponFireSnd[1]=none //SoundCue'TS_WP_MissileLauncher.Sounds.SC_CYReaper_RocketPod_Fire'

	WeaponPutDownSnd=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_PutDown'
	WeaponEquipSnd=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip'
	ReloadSound(0)=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Reload'
	ReloadSound(1)=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Reload'

	PickupSound=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip'

	MuzzleFlashSocket="MuzzleFlashSocket"
	FireSocket = "MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_MissileLauncher.Effects.P_MuzzleFlash_CYReaper_RocketPod'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	InventoryGroup=1
	InventoryMovieGroup=16

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_RocketLauncher'

	// Muzzle heat
    MuzzleHeatPerShot = 0.025f				// Heat increase per shot
    MuzzleHeatCooldownTimeInterval = 0.05f	// Time between each decrease tick
    MuzzleHeatCooldownAmount = -0.005f     // Amount to decrease per cooldown tick
    MinMuzzleHeatRequired = 0.35f            // Minimum heat required for it to be shown
    MuzzleHeatCooldownWaitTime = 1.0f       // Time between firing and starting decrease ticks
	
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

	MaxDesireability=0.6
	AIRating=+0.4
	CurrentRating=+0.4
	AimError = 300  


	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=0.0,Y=15.0,Z=-5.0)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=10
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=55.0
	ZoomedTargetFOV=45.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 2
	IronSightRecoilYawDamping = 2
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4

	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.1
}
