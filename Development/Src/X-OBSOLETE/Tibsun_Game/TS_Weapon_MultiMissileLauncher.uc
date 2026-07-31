class TS_Weapon_MultiMissileLauncher extends TS_Weapon_Guided;


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

	bPersistentLock = true
    bCanLock = true

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
    StayLocked=2.0 
    LockOnSize = 32.f

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

	AttachmentClass = class'TS_Attachment_MultiMissileLauncher'

	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_RocketLauncher'
	
	PlayerViewOffset=(X=12.0,Y=6.0,Z=-3.0)
	WideScreenOffsetScaling = 0.0
	BobDamping = 0.6

	FireOffset=(X=50,Y=20,Z=5)
	
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
	ReloadTime(0) = 3.5
	ReloadTime(1) = 3.5

	bOverrideFireIntervalForReload=False

	
	EquipTime=1.0
	//PutDownTime=1.0
	ActionToReadyTime = 0.75

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	
	WeaponProjectiles(0)=class'TS_Projectile_MultiMissileLauncher'
	WeaponProjectiles(1)=class'TS_Projectile_MultiMissileLauncher'

	WeaponProjectilesAir(0)=class'TS_Projectile_MultiMissileLauncher'
    WeaponProjectilesAir(1)=class'TS_Projectile_MultiMissileLauncher'

	/**WeaponProjectiles_Heroic(0)=class'Rx_Projectile_MissileLauncher_Heroic'
	WeaponProjectiles_Heroic(1)=class'TS_Projectile_MissileLauncherAlt_GDI'
	*/
	
	Spread(0)=0.2
	Spread(1)=0.2

	SpreadScoped=0.001
	SpreadNoScoped=0.001

	IronSightAndScopedSpread(0)=0.001
	IronSightAndScopedSpread(1)=0.001

	
	ClipSize = 4
	InitalNumClips = 8
	MaxClips = 8
	
	Ammo_Increment = 4
	AmmoIncrementRate = 1

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
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_RocketLauncher.Effects.P_MuzzleFlash'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	InventoryGroup=1
	InventoryMovieGroup=16

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_RocketLauncher'

	// Muzzle heat
    MuzzleHeatPerShot = 0.25f				// Heat increase per shot
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
	IronSightViewOffset=(X=-2.0,Y=-9.79,Z=-6.65)
	IronSightFireOffset=(X=10,Y=15,Z=-1)
	IronSightBobDamping=20
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
	IronSightSpreadIncreasePerShotDamping = 2

	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.1
}
