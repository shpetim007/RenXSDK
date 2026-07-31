class TS_Weapon_RPG extends TS_Weapon_Reloadable;



DefaultProperties
{
	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_RPG.Mesh.SK_WP_RPG_1P'
		AnimSets(0)=AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Weapon'
		Animations=MeshSequenceA
		Scale=5.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_RPG.Mesh.SK_WP_RPG_Back'
		//Translation=(X=-25)
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'RX_WP_MissileLauncher.Anims.AS_MissileLauncher_Arms'

	AttachmentClass = class'TS_Attachment_RPG'

	bPlayReloadSound=false
	
	PlayerViewOffset=(X=-10.0,Y=5.0,Z=-5.0)

	FireOffset=(X=20,Y=20,Z=0)
	
	LeftHandIK_Offset=(X=-3.054600,Y=-3.855900,Z=0.031600)
	LeftHandIK_Rotation=(Pitch=910,Yaw=2002,Roll=-1092)
	RightHandIK_Offset=(X=4.0,Y=-2.0,Z=2.0)
	
	LeftHandIK_Relaxed_Offset = (X=-4.000000,Y=-4.000000,Z=-1.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=3640)
	RightHandIK_Relaxed_Offset = (X=0.000000,Y=-5.000000,Z=-8.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=-5461,Yaw=6189,Roll=14017)
	
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
	FireInterval(0)=+0.3
	FireInterval(1)=+0.3
	ReloadTime(0) = 3.75
	ReloadTime(1) = 3.75

	bOverrideFireIntervalForReload=False
	
	EquipTime=0.75
	//PutDownTime=0.3

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	
	WeaponProjectiles(0)=class'TS_Projectile_RPG'
	WeaponProjectiles(1)=class'TS_Projectile_RPG'

	Spread(0)=0.01
	Spread(1)=0.01

	SpreadScoped=0.001
	SpreadNoScoped=0.001

	IronSightAndScopedSpread(0)=0.001
	IronSightAndScopedSpread(1)=0.001
	
	ClipSize = 1
	InitalNumClips = 12
	MaxClips = 12

	Ammo_Increment = 1
	AmmoIncrementRate = 1.0

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_RocketLauncher_Reload"
	ReloadAnim3PName(1) = "H_M_RocketLauncher_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"



	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_RPG.Sounds.SC_RPG_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_RocketLauncher.Sounds.SC_RocketLauncher_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/

	

	WeaponFireSnd[0]=SoundCue'TS_WP_RPG.Sounds.SC_RPG_Fire'
	WeaponFireSnd[1]=SoundCue'TS_WP_RPG.Sounds.SC_RPG_Fire'

	WeaponPutDownSnd=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_MissileLauncher.Sounds.SC_MissileLauncher_Equip'
	ReloadSound(0)=SoundCue'TS_WP_RPG.Sounds.SC_RPG_Reload'
	ReloadSound(1)=SoundCue'TS_WP_RPG.Sounds.SC_RPG_Reload'

	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	MuzzleFlashSocket="MuzzleFlashSocket"
	FireSocket = "MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_RPG.Effects.P_MuzzleFlash'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_RocketLauncher'
	LockedOnCrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_MissileLock'
	TargetMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_LockOnStripe'

	InventoryGroup=1
	InventoryMovieGroup=16

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_RPG'
	
	// AI Hints:
	// MaxDesireability=0.7
	AIRating=+0.4
	CurrentRating=+0.4
	bFastRepeater=false
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=true
	bSniping=false  
	bOkAgainstBuildings=true
	bOkAgainstVehicles=true 


	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = True
	bDisplayCrosshairInIronsight = false		
	IronSightViewOffset=(X=-16.666664,Y=-14.250000,Z=-5.233335)
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
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_RPG'
	
}
