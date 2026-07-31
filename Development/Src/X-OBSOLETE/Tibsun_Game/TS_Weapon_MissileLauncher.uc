class TS_Weapon_MissileLauncher extends TS_Weapon_Guided;



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
		SkeletalMesh=SkeletalMesh'TS_WP_MissileLauncher.Mesh.SK_MissileLauncher_1P'
		AnimSets(0)=AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Weapon'
		Animations=MeshSequenceA
		Scale=4.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_MissileLauncher.Mesh.SK_MissileLauncher_Back'
		//Translation=(X=-25)
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Arms'

	AttachmentClass = class'TS_Attachment_MissileLauncher'
	
	PlayerViewOffset=(X=5.0,Y=5.0,Z=-5.0)

	FireOffset=(X=50,Y=20,Z=5)
	
	LeftHandIK_Offset=(X=-3.054600,Y=-3.855900,Z=0.031600)
	LeftHandIK_Rotation=(Pitch=910,Yaw=2002,Roll=-1092)
	RightHandIK_Offset=(X=9.0,Y=3.0,Z=-3.0)
	
	LeftHandIK_Relaxed_Offset = (X=-4.000000,Y=-3.000000,Z=0.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=1092,Yaw=-5825,Roll=-4551)
	RightHandIK_Relaxed_Offset = (X=2.22000,Y=0.000000,Z=-5.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=-985406,Yaw=3822,Roll=7099)

	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed
	
	//-------------- Recoil
	RecoilDelay = 0.05
	RecoilSpreadDecreaseDelay = 0.7
	MinRecoil = -150.0
	MaxRecoil = -200.0
	MaxTotalRecoil = 20000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 90.0
	RecoilDeclinePct = 4.0
	RecoilDeclineSpeed = 45.0
	RecoilSpread = 0.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.000
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadCrosshairScaling = 1500;

	// Roll
	RecoilRollMultiplier = 6.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 70.0
	RecoilDeclineSpeedRoll = 12.0

	ShotCost(0)=1
	ShotCost(1)=1
	FireInterval(0)=+1.0
	FireInterval(1)=+1.0
	ReloadTime(0) = 5.0
	ReloadTime(1) = 5.0

	bOverrideFireIntervalForReload=False
	
	EquipTime=1.0
	//PutDownTime=0.75
	ActionToReadyTime = 0.5

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	
	WeaponProjectiles(0)=class'TS_Projectile_MissileLauncher'
	WeaponProjectiles(1)=class'TS_Projectile_MissileLauncher'

	WeaponProjectilesAir(0)=class'TS_Projectile_MissileLauncher_Air'
    WeaponProjectilesAir(1)=class'TS_Projectile_MissileLauncher_Air'
	
	Spread(0)=0.2
	Spread(1)=0.2

	SpreadScoped=0.001
	SpreadNoScoped=0.001

	IronSightAndScopedSpread(0)=0.001
	IronSightAndScopedSpread(1)=0.001
	
	ClipSize = 1
	InitalNumClips = 12
	MaxClips = 12

	Ammo_Increment = 1
	AmmoIncrementRate = 1.0
	
	bHasInfiniteAmmo = false

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
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/



	WeaponFireSnd[0]=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Fire'
	WeaponFireSnd[1]=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Fire'


	WeaponPutDownSnd=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_PutDown'
	WeaponEquipSnd=none //SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip'
	ReloadSound(0)=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Reload'
	ReloadSound(1)=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Reload'	
	

	PickupSound=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_Equip'

	MuzzleFlashSocket="MuzzleFlashSocket"
	FireSocket = "MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_MissileLauncher.Effects.P_MuzzleFlash'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_RocketLauncher'
	LockedOnCrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_MissileLock'
	TargetMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_LockOnStripe'

	InventoryGroup=1
	InventoryMovieGroup=16

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_MissileLauncher'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = True
	bInstantHit = False
	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = True
    bOkAgainstVehicles = True

	MaxDesireability=0.6
	AIRating=+0.4
	CurrentRating=+0.4
	AimError = 545

	//==========================================
	// LOCKING PROPERTIES
	//==========================================
	bCanLock = true
	bPersistentLock = true

	LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
	LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

	SeekingRocketClass=class'TS_Projectile_MissileLauncher_Air'

	ConsoleLockAim=0.998
	LockRange=15000
	LockAim=0.99//0.999999
	LockRangeAircraft=20000
	LockChecktime=0.25
	LockAcquireTime=0.25//0.75
	LockTolerance=0.5 //3.0   
	StayLocked=2.0 
    bTargetLockingActive = true
    LockOnSize = 32.f

	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True
	bDisplayCrosshairInIronsight = false		
	IronSightViewOffset=(X=0.0,Y=-6.36,Z=-4.56)
	IronSightFireOffset=(X=10,Y=0,Z=-2)
	IronSightBobDamping=3
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedTargetFOV=45.0

	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=175.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 1
	IronSightRecoilYawDamping = 2
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_MissileLauncher'
	
	WeaponSpeedModifier = -0.1

}
