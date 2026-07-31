class TS_Weapon_StickyBombLauncher extends TS_Weapon_Reloadable;

var array<Projectile> Bombs;

simulated function Projectile ProjectileFire()
{
	local Projectile Oute;

	Oute = super.ProjectileFire();

	Bombs.AddItem(Oute);

	return Oute;
}

simulated function Projectile ProjectileFireOld()
{
	local Projectile Oute;

	Oute = super.ProjectileFireOld();

	Bombs.AddItem(Oute);

	return Oute;
}

simulated function CustomFire()
{
    local Projectile D;

    ScriptTrace();

    if (Bombs.Length > 0)
	{
		foreach Bombs(D)
		{
			if (D != None)
			{
				if (!TS_Projectile_StickyBomb(D).bExploded)
					TS_Projectile_StickyBomb(D).Explode(D.location,vect(0,0,0));
			}
		}
	}

	Bombs.Length = 0;
}

simulated function StartFire(byte FireModeNum)
{
	super.StartFire(FireModeNum);

	if (FireModeNum == 1)
		CustomFire();
}

DefaultProperties
{
	bAutoFire = false

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Pistol.HD.Mesh.SK_Pistol_1P'
		AnimSets(0)=AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Pistol.HD.Mesh.SK_Pistol_Back'
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_Arms'

	AttachmentClass = class'TS_Attachment_Pistol'
	
	PlayerViewOffset=(X=0,Y=0,Z=0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	bUseHandIKWhenRelax=false
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 80.0
	MaxRecoil = 100.0
	MaxTotalRecoil = 3000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 35.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 4.0
	MaxSpread = 0.06
	RecoilSpreadIncreasePerShot = 0.0025
	RecoilSpreadDeclineSpeed = 0.6
	RecoilSpreadDecreaseDelay = 0.2
	RecoilSpreadCrosshairScaling = 1500;
	
	CrosshairWidth = 210 	// 256
	CrosshairHeight = 210 	// 256

	ShotCost(0)=0
	ShotCost(1)=0
	FireInterval(0)=1.0
	FireInterval(1)=0.0
	ReloadTime(0) = 3.0
	ReloadTime(1) = 0
	
	EquipTime=0.3667
	//PutDownTime=0.3667
	ActionToReadyTime = 0.15
	
	WeaponRange=2500.0

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Custom

	WeaponProjectiles(0)=class'TS_Projectile_StickyBomb'

	Spread(0)=0.0
	Spread(1)=0.0
	
	ClipSize = 1
	InitalNumClips = 4
	MaxClips = 4
	bHasInfiniteAmmo = false

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Pistol_Reload"
	ReloadAnim3PName(1) = "H_M_Pistol_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponFireSnd[0]=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire'
	WeaponFireSnd[1]=None

	WeaponPutDownSnd=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'
	ReloadSound(0)=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Reload'
	ReloadSound(1)=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Reload'

	PickupSound=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'

	FireSocket="MuzzleFlashSocket"

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'	// ParticleSystem'RX_WP_Pistol.Effects.MuzzleFlash_1P'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'	// MaterialInstanceConstant'RenXHud.MI_Reticle_Pistol'

	InventoryGroup=2
	InventoryMovieGroup=1

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_NapalmLauncher'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = True
	bSniping = False 
	bFastRepeater = False	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.4
	AIRating=+0.25
	CurrentRating=+0.25
	AimError = 200	
	
	
	// IronSight:
	bIronSightCapable = false	
	IronSightViewOffset=(X=0,Y=-6.5,Z=2.0)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=45.0 
	ZoomedWeaponFov=45.0
	InverseZoomOffset=20.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=250.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Pistol'

	//WeaponIconTexture
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.001
}
