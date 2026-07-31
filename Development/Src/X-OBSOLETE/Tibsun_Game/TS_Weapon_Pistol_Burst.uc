class TS_Weapon_Pistol_Burst extends TS_Weapon_Reloadable_Sidearms;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

var MaterialInstanceConstant 	MCounterTens, MCounterOnes, MSkin;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MSkin = Mesh.CreateAndSetMaterialInstanceConstant(0);

	MCounterOnes = Mesh.CreateAndSetMaterialInstanceConstant(4);
	MCounterTens = Mesh.CreateAndSetMaterialInstanceConstant(3);
}

simulated function UpdateAmmoCounter()
{
	local int Ones, Tens;
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Ones = CurrentAmmoInClip%10;
		Tens = ((CurrentAmmoInClip - Ones)/10)%10;

		MCounterOnes.SetScalarParameterValue('OnesClamp', Float(Ones));
		MCounterTens.SetScalarParameterValue('TensClamp', Float(Tens));
	}
}

simulated function SetSkin(Material NewMaterial)
{
	local byte TeamIndex;

	if (bCloaked)
		return;
	
	if (Instigator != none && NewMaterial == none)
	{
		TeamIndex = Instigator.GetTeamNum();

		MCounterOnes.SetScalarParameterValue('TeamColour', TeamIndex);
		MCounterTens.SetScalarParameterValue('TeamColour', TeamIndex);

		MSkin.SetScalarParameterValue('TeamNumber', TeamIndex);
	}
}

simulated function ConsumeAmmo( byte FireModeNum )
{
	super.ConsumeAmmo(FireModeNum);
	UpdateAmmoCounter();
}

simulated function Activate()
{
	UpdateAmmoCounter();
	super.Activate();
}

simulated function PostReloadUpdate()
{
	UpdateAmmoCounter();
}

/*Used for telling things like stealth not to mess with this material in 1st person (Useful for holosights + LED screens)*/
simulated function bool GetIsImmutableMaterial(byte MatNumber)
{
	return MatNumber > 2; //LED and holo sight shouldn't be touched
}
/*
simulated function bool GetIsBurstFire(){
	return bIronsightActivated; 
}
*/
DefaultProperties
{
	//Burst Fire Variables//
	bBurstFire = true  //If true, the weapon will use burst fire mechanics
	TimeBetweenBursts = 0.06
	bConstantFire = true 
	Burst_Cooldown(0) = 0.05
	
	bAutoFire = false
	bFirePerTap = True



	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Pistol.HD.Mesh.SK_Pistol_Burst_1P'
		AnimSets(0)=AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=75.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Pistol.HD.Mesh.SK_Pistol_Burst_Back'
		Scale=1.0
	End Object
	
	ArmsAnimSet = AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_Arms'

	AttachmentClass = class'TS_Attachment_Pistol_Burst'
	
	PlayerViewOffset=(X=5,Y=-2,Z=0)

	FireOffset=(X=0.0,Y=12.0,Z=-8.0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	bUseHandIKWhenRelax=false
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 100.0
	MaxRecoil = 120.0
	MaxTotalRecoil = 3000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 60.0
	RecoilDeclinePct = 1.0
	RecoilDeclineSpeed = 12.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.001
	RecoilSpreadDeclineSpeed = 0.6
	RecoilSpreadDecreaseDelay = 0.2
	RecoilSpreadCrosshairScaling = 1500;

	// Roll
	RecoilRollMultiplier = 1.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 70.0
	RecoilDeclineSpeedRoll = 16.0
	
	CrosshairWidth = 210 	// 256
	CrosshairHeight = 210 	// 256

	ShotCost(0)=1
	ShotCost(1)=0
	FireInterval(0)=+0.08
	FireInterval(1)=+0.0
	ReloadTime(0) = 1.5 	//2.2333
	ReloadTime(1) = 1.7667
	
	EquipTime=0.333
	//PutDownTime=0.2
	ActionToReadyTime = 0.1

    LockerRotation=(pitch=0,yaw=0,roll=-16384)

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_None
	
	WeaponProjectiles(0)=class'TS_Projectile_Pistol_Burst'
	WeaponProjectiles(1)=class'TS_Projectile_Pistol_Burst'
	WeaponProjectiles_Nod(0)=class'TS_Projectile_Pistol_Burst_Nod'
	WeaponProjectiles_Nod(1)=class'TS_Projectile_Pistol_Burst_Nod'

	WeaponRange=3500.0

	InstantHitDamage(0)=8
	InstantHitDamage(1)=8
	
	HeadShotDamageMult=1.25

	InstantHitDamageTypes(0)=class'TS_DmgType_Pistol'
	InstantHitDamageTypes(1)=class'TS_DmgType_Pistol'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000

	bInstantHit = true

	Spread(0)=0.01
	Spread(1)=0.0

	IronSightAndScopedSpread(0)=0.0
	IronSightAndScopedSpread(1)=0.0
	
	ClipSize = 24
	InitalNumClips = 8
	MaxClips = 8
	
	Ammo_Increment = 48
	AmmoIncrementRate = 1.0

	bHasInfiniteAmmo = false

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_Pistol_Reload"
	ReloadAnim3PName(1) = "H_M_Pistol_Reload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"

	WeaponADSFireAnim(0) = "WeaponIdle"
	WeaponADSFireAnim(1) = "WeaponIdle"

	ArmADSFireAnim(0) = "WeaponIdle"
	ArmADSFireAnim(1) = "WeaponIdle"



	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/

	WeaponFireSnd[0]=none //SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Fire'
	WeaponFireSnd[1]=None

	WeaponPutDownSnd=none //SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_PutDown'
	WeaponEquipSnd=none //SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'
	ReloadSound(0)=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Reload'
	ReloadSound(1)=SoundCue'TS_WP_Pistol.HD.Sounds.SC_Pistol_Reload'

	PickupSound=SoundCue'RX_WP_Pistol.Sounds.SC_Pistol_Equip'

	FireSocket="MuzzleFlashSocket"

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'
	MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_AutoRifle.Effects.MuzzleFlash_1P_ADS'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'	// MaterialInstanceConstant'RenXHud.MI_Reticle_Pistol'

	InventoryGroup=2
	InventoryMovieGroup=2

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PistolSilenced'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False

	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.4
	AIRating=+0.25
	CurrentRating=+0.25
	AimError = 200		
	
	// IronSight:
	bIronSightCapable = true	
	IronSightViewOffset=(X=0,Y=-6.5,Z=2.0)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2


	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 3					// 2		1.5
	IronSightMaxRecoilDamping = 3					// 2		1.5
	IronSightMaxTotalRecoilDamping = 2				// 2		1.5
	IronSightRecoilYawDamping = 5					// 1		1.0
	IronSightMaxSpreadDamping = 10					// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 10		// 4		1.7

	
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=20.0 
	ZoomedWeaponFov=45.0
	InverseZoomOffset=0.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=250.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_Pistol_Burst'

	//WeaponIconTexture
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = -0.01

	FireAnimLength[0] = 0.333
	FireAnimLength[1] = 0.333
	
/*
	CameraAnims[0] = 	{(
							CameraModName = Equip,
							CameraModeFilter = 1,
							TimeLength = 0.3,
							bIsPlaying = true,
							bDeleteOnFinish = true,
							bWorldZ = true,
							CamPosOffsets =
							(
								Points[0] = (InVal = 0.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[1] = (InVal = 0.1,OutVal = (X=-1,Y=0.0,Z=-1.0),InterpMode = CIM_CurveAuto),
								Points[2] = (InVal = 0.4,OutVal = (X=0,Y=0.0,Z=2.0),InterpMode = CIM_CurveAuto),
								Points[3] = (InVal = 0.5,OutVal = (X=0.5,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[4] = (InVal = 1.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto)
							),
							CamRotOffsets =
							(
								Points[0] = (InVal = 0.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[1] = (InVal = 0.2,OutVal = (X=-40,Y=0.0,Z=-20.0),InterpMode = CIM_CurveAuto),
								Points[2] = (InVal = 0.5,OutVal = (X=10,Y=0.0,Z=30.0),InterpMode = CIM_CurveAuto),
								Points[3] = (InVal = 0.6,OutVal = (X=55,Y=0.0,Z=50.0),InterpMode = CIM_CurveAuto),
								Points[4] = (InVal = 1.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto)
							)
						)}
*/

	IronsightWeaponRecoilLocMod[0] = (X=2,Y=1.0,Z=1.0)
	IronsightWeaponRecoilLocMod[1] = (X=2,Y=1.0,Z=1.0)

	IronsightWeaponRecoilRotMod[0] = (X=0.1,Y=0.25,Z=0.25)
	IronsightWeaponRecoilRotMod[1] = (X=0.1,Y=0.25,Z=0.25)
}
