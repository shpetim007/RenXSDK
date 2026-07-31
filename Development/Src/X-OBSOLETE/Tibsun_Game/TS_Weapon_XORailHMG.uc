class TS_Weapon_XORailHMG extends TS_Weapon_Charged
 ;
	
/*Override with certain weapons if they have special cases for burst firing only. Usually a weapon just is or isn't*/
/*
simulated function bool GetIsBurstFire(){
	return CurrentFireMode == 0; 
}
*/

var int		ScanDistance; 

var MaterialInstanceConstant MCounterHundreds, MCounterTens, MCounterOnes, MDistThousands, MDistHundreds, MDistTens, MDistOnes, MSights;

var Name CounterName;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MSights = Mesh.CreateAndSetMaterialInstanceConstant(1);

	MCounterOnes = Mesh.CreateAndSetMaterialInstanceConstant(4);
	MCounterTens = Mesh.CreateAndSetMaterialInstanceConstant(3);
	MCounterHundreds = Mesh.CreateAndSetMaterialInstanceConstant(2);

	MDistOnes = Mesh.CreateAndSetMaterialInstanceConstant(8);
	MDistTens = Mesh.CreateAndSetMaterialInstanceConstant(7);
	MDistHundreds = Mesh.CreateAndSetMaterialInstanceConstant(6);
	MDistThousands = Mesh.CreateAndSetMaterialInstanceConstant(5);
}

simulated function UpdateAmmoCounter()
{
	local int Ones, Tens, Hundreds;
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Ones = CurrentAmmoInClip%10;
		Tens = ((CurrentAmmoInClip - Ones)/10)%10;
		Hundreds = (CurrentAmmoInClip > 99 ? 1 : 0); // right way to go, it's never bigger then 100 (should be)

		MCounterOnes.SetScalarParameterValue(CounterName, Float(Ones));
		MCounterTens.SetScalarParameterValue(CounterName, Float(Tens));
		MCounterHundreds.SetScalarParameterValue(CounterName, Float(Hundreds));
	}
}

simulated function CheckDistance() 
{
	local rotator aimdir;
	local vector hitloc, norm, loc;
	local Actor hit;
	local float fDistance;
	local int Ones, Tens, Hundreds, Thousands;

	aimdir = Instigator.GetBaseAimRotation();

	loc = InstantFireStartTrace();
	hit = Trace(hitloc, norm, loc + vector(aimdir) * (9999 * 52.5), loc, true);
	if (hit == none) 
	{  //too far away
		MDistOnes.SetScalarParameterValue(CounterName, 10.0);
		MDistTens.SetScalarParameterValue(CounterName, 10.0);
		MDistHundreds.SetScalarParameterValue(CounterName, 10.0);
		MDistThousands.SetScalarParameterValue(CounterName, 10.0);
	} 
	else 
	{
		fDistance = VSize(Instigator.location - hitloc) / 52.5;

		Ones = fDistance%10;
		Tens = ((fDistance-Ones)/10)%10.0;
		Hundreds = ((fDistance-Ones-Tens)/100)%10.0;
		Thousands = ((fDistance-Ones-Tens-Hundreds)/1000)%10.0;

		MDistOnes.SetScalarParameterValue(CounterName, Float(Ones));
		MDistTens.SetScalarParameterValue(CounterName, Float(Tens));
		MDistHundreds.SetScalarParameterValue(CounterName, Float(Hundreds));
		MDistThousands.SetScalarParameterValue(CounterName, Float(Thousands));
	}
}

simulated function StartZoom(UTPlayerController PC)
{
	SetTimer(0.2, true, 'CheckDistance');
	super.StartZoom(PC);
}

simulated function EndZoom(UTPlayerController PC)
{
	ClearTimer('CheckDistance');
	super.EndZoom(PC);
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

DefaultProperties
{
	CounterName=CounterClamp

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_LightRailgun_1P'
		AnimSets(0)=AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_LightRailgun_1P'
		Animations=MeshSequenceA
		Scale=3.0
		FOV=90.0
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_LightRailgun_Back'
		// Translation=(X=-15)
		Scale=1.0
	End Object

	ArmsAnimSet = AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_LightRailgun_Arms'

	PlayerViewOffset=(X=5.0,Y=16.0,Z=-24.0)
	
	FireOffset=(X=200,Y=45,Z=-30)
	
	LeftHandIK_Offset=(X=2.0,Y=0.5,Z=0.0)
	LeftHandIK_Relaxed_Offset=(X=6.0,Y=-0.0,Z=3.0)
	LeftHandIK_Relaxed_Rotation=(Pitch=-3094,Yaw=4369,Roll=4369)
//	RightHandIK_Offset=(X=5.19,Y=-4.9,Z=2.04)
	RightHandIK_Relaxed_Offset=(X=2.0,Y=3.0,Z=0.0)
	RightHandIK_Relaxed_Rotation=(Pitch=910,Yaw=3640,Roll=1820)


	AttachmentClass = class'TS_Attachment_XORailHMG'
	
	BobDamping=1.1
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 100.0
	MaxRecoil = 150.0
	MaxTotalRecoil = 1000.0
	RecoilInterpSpeed = 45.0
	RecoilDeclinePct = 0.4
	RecoilDeclineSpeed = 8.0
	MaxSpread = 0.1
	RecoilSpreadIncreasePerShot = 0.001
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
    FireInterval(0)=+0.09
    FireInterval(1)=+0.09
    ReloadTime(0) = 4.0
    ReloadTime(1) = 4.0
   
    EquipTime=0.1
	PutDownTime=0.1
	ActionToReadyTime = 0.15

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile

	WeaponProjectiles(0)=class'TibSun_Game.TS_Projectile_XORailHMG'
	WeaponProjectiles(1)=class'TibSun_Game.TS_Projectile_XORailHMG'
    
	Spread(0)=0.001
    Spread(1)=0.001

    FireDelayTime = 0.8
    bCharge = true
 
    ClipSize = 60
    InitalNumClips = 6
    MaxClips = 6
    
    Ammo_Increment = 5
	AmmoIncrementRate = 1.0

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
    
	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)

	// Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(7)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun_Light.Sounds.SC_XORailHMG_FireStop',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(8)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun_Light.Sounds.SC_XORailHMG_FireStop',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)



    /****************************************/ 


 
	WeaponPreFireSnd[0]=SoundCue'TS_WP_Railgun_Light.Sounds.SC_XORailHMG_FireStart'
	WeaponPreFireSnd[1]=none
    WeaponFireSnd[0]=SoundCue'TS_WP_Railgun_Light.Sounds.SC_XORailHMG_FireLoop'
    WeaponFireSnd[1]=none
	WeaponPostFireSnd[0]=none //SoundCue'TS_WP_Railgun_Light.Sounds.SC_XORailHMG_FireStop'
	WeaponPostFireSnd[1]=none

	WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'
	ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_Light_Reload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_Light_Reload'

	PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    MuzzleFlashSocket=MuzzleFlashSocket
    FireSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_XORailHMG_MuzzleFlash_1P'
    MuzzleFlashDuration=0.1
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_Chaingun'
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=4

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_MG'

    
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

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 400
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=-10.0,Y=0.85,Z=-22.45)
	IronSightFireOffset=(X=200,Y=45,Z=-30)
	IronSightBobDamping=10
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=35.0 
	ZoomedWeaponFov=5.0
	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11

	AimRate=100
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2
	IronSightMaxRecoilDamping = 2
	IronSightMaxTotalRecoilDamping = 2
	IronSightRecoilYawDamping = 2
	IronSightMaxSpreadDamping = 2
	IronSightSpreadIncreasePerShotDamping = 4

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_MachineGun'

	/**********************/
	
	//Burst Fire Variables//
//	TimeBetweenBursts = 0.08
//	BurstNum = 4
//	Burst_Cooldown(0) = 0.75
//	Burst_Cooldown(1) = 0.75


	// Muzzle heat
	MuzzleHeatPerShot = 0.005f				// Heat increase per shot
	MuzzleHeatCooldownTimeInterval = 0.025f	// Time between each decrease tick
	MuzzleHeatCooldownAmount = -0.0025f		// Amount to decrease per cooldown tick
	MinMuzzleHeatRequired = 0.1f			// Minimum heat required for it to be shown
	MuzzleHeatCooldownWaitTime = 0.5f		// Time between firing and starting decrease ticks

}
