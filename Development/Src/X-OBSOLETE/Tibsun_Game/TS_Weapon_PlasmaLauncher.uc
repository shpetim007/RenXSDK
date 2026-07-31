class TS_Weapon_PlasmaLauncher extends TS_Weapon_Guided;


simulated function class<Projectile> GetProjectileClassSimulated(optional byte FMTag = 255)
{
	if (bLockedOnTarget && (Rx_Vehicle_Air(LockedTarget) != None || TS_Vehicle_Air(LockedTarget) != None || TS_Vehicle_Advanced_Air(LockedTarget) != None))
		return (WeaponProjectilesAir.length > CurrentFireMode) ? WeaponProjectilesAir[CurrentFireMode] : None;
	return (CurrentFireMode < WeaponProjectiles.length) ? WeaponProjectiles[CurrentFireMode] : None;
}

/**
 * We override GetProjectileClass to swap in a Seeking Rocket if we are locked on.
 */
function class<Projectile> GetProjectileClass()
{
	if (bLockedOnTarget)
	{
		if((Rx_Vehicle_Air(LockedTarget) != None || TS_Vehicle_Air(LockedTarget) != None || TS_Vehicle_Advanced_Air(LockedTarget) != None))
			return (WeaponProjectilesAir.length > CurrentFireMode) ? WeaponProjectilesAir[CurrentFireMode] : None;

		return SeekingRocketClass;
	}
	else
	{
		return WeaponProjectiles[CurrentFireMode];
	}
}

simulated function bool UsesClientSideProjectiles(byte FireMode)
{
	return false;
}



DefaultProperties
{

  	// Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_PlasmaLauncher.Mesh.SK_PlasmaLauncher_1P'
		AnimSets(0)=AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Weapon'
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
	
	ArmsAnimSet = AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Arms'

    AttachmentClass = class'TS_Attachment_PlasmaLauncher'

    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_PlasmaLauncher'
	
	LeftHandIK_Offset = (X=-4,Y=-4,Z=0)
	RightHandIK_Offset = (X=8,Y=2,Z=0)
	LeftHandIK_Rotation = (Pitch=4004,Yaw=7281,Roll=8738)
	
	LeftHandIK_Relaxed_Offset = (X=-5.0,Y=-3.5,Z=1.0)
	RightHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
	LeftHandIK_Relaxed_Rotation = (Pitch=-3640,Yaw=-3640,Roll=-5461)
	RightHandIK_Relaxed_Rotation = (Pitch=-1820,Yaw=3640,Roll=5461)

	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed

	PlayerViewOffset = (X=5.0,Y=5.0,Z=0.0)

    FireOffset=(X=20,Y=7.5,Z=-2)
	
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

    //==========================================


    BobDamping=1.2

    ShotCost(0)=1
    ShotCost(1)=1
    FireInterval(0)= 0.5
    FireInterval(1)= 0.5
    
    EquipTime=0.75
	//PutDownTime=0.1
	ActionToReadyTime = 0.15

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_PlasmaLauncher_Guided'
    WeaponProjectiles(1)=class'TS_Projectile_PlasmaLauncher_Guided' 

    WeaponProjectilesAir(0)=class'TS_Projectile_PlasmaLauncher_Guided'
    WeaponProjectilesAir(1)=class'TS_Projectile_PlasmaLauncher_Guided'

    Spread(0)=0.1
    Spread(1)=0.1

    IronSightAndScopedSpread(0)=0.0001
    IronSightAndScopedSpread(1)=0.0001

    bAutoFire=False
       
    ClipSize = 16
    InitalNumClips = 1
    MaxClips = 1
    
    Ammo_Increment = 1
	AmmoIncrementRate = 0.5

	//FireDelayTime = 1.0
    //bCharge = true

    BoltActionReload=true
    bUnzoomDuringBoltActionReloading = false

    BoltReloadTime(0) = 3.0 //2.0f (Factor in RefireBoltReloadInterrupt) 
    BoltReloadTime(1) = 3.0 //2.0f

    ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0

    RefireBoltReloadInterrupt(0)=1.0
    RefireBoltReloadInterrupt(1)=1.0
    
    BoltReloadAnimName(0) = "weaponreload"
    BoltReloadAnimName(1) = "weaponreload"
    BoltReloadArmAnimName(0) = "weaponreload"
    BoltReloadArmAnimName(1) = "weaponreload"

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
	ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"
/*	
	WeaponPreFireAnim[0]="WeaponIdle"
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
*/

    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 
    

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_PlasmaLauncher.Sounds.SC_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_PlasmaLauncher.Sounds.SC_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


    /****************************************/ 
 /*
	WeaponPreFireSnd[0]=SoundCue'TS_WP_PlasmaLauncher.Sounds.SC_ChargeUp'
	WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
	WeaponPostFireSnd[0]=none
	WeaponPostFireSnd[1]=none
*/
    WeaponPutDownSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip'
    WeaponEquipSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown'
    ReloadSound(0)=SoundCue'TS_WP_PlasmaLauncher.Sounds.SC_Reload'
    ReloadSound(1)=SoundCue'TS_WP_PlasmaLauncher.Sounds.SC_Reload'

    PickupSound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltAutoRifle_Equip'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"

	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_PlasmaLauncher.Effects.P_MuzzleFlash_1P'
	MuzzleFlashPSCTemplate_Heroic=ParticleSystem'TS_WP_PlasmaLauncher.Effects.P_MuzzleFlash_1P'
	MuzzleFlashLightClass=class'TibSun_Game.TS_Light_PlasmaRifle_MuzzleFlash'
    MuzzleFlashDuration=5.0
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 196
	CrosshairHeight = 196

    InventoryGroup=1
    InventoryMovieGroup=9

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableObelisk'
	
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
	// LOCKING PROPERTIES
	//==========================================

	bCanLock = true
	bPersistentLock = true

	LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
	LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

	SeekingRocketClass=class'TS_Projectile_PlasmaLauncher_Guided'

	ConsoleLockAim=0.998
	LockRange=15000
	LockAim=0.99
	LockRangeAircraft=15000
	LockChecktime=0.25
	LockAcquireTime=0.25
	LockTolerance=0.5 
	StayLocked=2.0 
    bTargetLockingActive = true
    LockOnSize = 32.f
    

	///==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True	
	bDisplayCrosshairInIronsight = false
	AimRate=100

	IronSightViewOffset=(X=-12.0,Y=-3.86,Z=0.17)
	IronSightFireOffset=(X=10,Y=15,Z=-1)
	IronSightBobDamping=20
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=60.0 
	ZoomedWeaponFov=45.0

	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=175.0
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
	