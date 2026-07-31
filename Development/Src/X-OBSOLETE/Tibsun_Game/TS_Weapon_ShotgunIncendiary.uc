class TS_Weapon_ShotgunIncendiary extends TS_Weapon_Reloadable;
//implements (TSIfc_MultiModeWeapon);

var int NumPellets, ShotLayer, NumSpreadLayers;
var bool bUseConstantSpread;

var float LayerDensity; //Used to change spread per shot/Create rediculous patterns

var float Additive; //Circular additive used in predictable spread pattern  

//var byte WeaponMode;


var MaterialInstanceConstant    MCounterTens, MCounterOnes, MSights;
var MaterialInterface TeamSkin;
var byte TeamIndex;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MSights = Mesh.CreateAndSetMaterialInstanceConstant(3);

	MCounterOnes = Mesh.CreateAndSetMaterialInstanceConstant(2);
	MCounterTens = Mesh.CreateAndSetMaterialInstanceConstant(1);
}

simulated function UpdateAmmoCounter()
{
	local int Ones, Tens;
	if ( WorldInfo.NetMode != NM_DedicatedServer)
	{
		Ones = CurrentAmmoInClip%10;
		Tens = ((CurrentAmmoInClip - Ones)/10)%10;

		MCounterOnes.SetScalarParameterValue('CounterClamp', Float(Ones));
		MCounterTens.SetScalarParameterValue('CounterClamp', Float(Tens));
	}
}


simulated function SetSkin(Material NewMaterial)
{
	if( ( Instigator != none ) && ( NewMaterial == none ) ) // Clear the materials
	{
		Mesh.SetMaterial(0,TeamSkin);

		MCounterOnes.SetScalarParameterValue('TeamColour', TeamIndex);
		MCounterTens.SetScalarParameterValue('TeamColour', TeamIndex);

		MSights.SetScalarParameterValue('TeamColour', TeamIndex);
	}
	else
	{
		Super.SetSkin(NewMaterial);
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


simulated function CustomFire()
{
    local int i;
    Rx_Pawn(Owner).ShotgunPelletCount = 0;
    for (i=0; i < NumPellets; i++)
    {
		if (i>0 && Rx_Controller(Instigator.Controller) != none) 
			Rx_Controller(Instigator.Controller).AddShot(); //One gets called in FireAmmunition already 

		if (bInstantHit && CheckInstantFire())
		{
			InstantFire();
		}
		else
			ProjectileFire();
    	
		//super.ProjectileFire();
    	CurrentAmmoInClipClientside++;
    }
    CurrentAmmoInClipClientside--;
}

/** Modified version of Rx_Weapon::TryHeadshot(...) that allows Shotgun headshots to work. */
simulated function bool TryHeadshot(byte FiringMode, ImpactInfo Impact, optional float DmgReduction = 1.0) 
{
	local float Scaling;
	local int HeadDamage;
    	
	if(FiringMode == 0)
	{
		if (Instigator == None || VSize(Instigator.Velocity) < Instigator.GroundSpeed * Instigator.CrouchedPct)
		{
			Scaling = SlowHeadshotScale;
		}
		else
		{
			Scaling = RunningHeadshotScale;
		}

		HeadDamage = InstantHitDamage[FiringMode]* HeadShotDamageMult;
		if ( (Rx_Pawn(Impact.HitActor) != None && Rx_Pawn(Impact.HitActor).TakeHeadShot(Impact, HeadShotDamageType, HeadDamage, Scaling, Instigator.Controller, false,,DmgReduction)))
		{
			SetFlashLocation(Impact.HitLocation);
			return true;
		}
	}
	return false;
}

simulated function bool IsInstantHit()
{
	return true; //CurrentFireMode == 0; 
}


simulated function rotator AddSpread(rotator BaseAim)
{
	if(bUseConstantSpread) return ShotgunAddSpread(BaseAim); 
	else
	return super.AddSpread(BaseAim);
}

simulated function rotator ShotgunAddSpread(rotator BaseAim)
{
	local vector X, Y, Z;
	local float CurrentSpreadX, RandY, RandZ;
	
	CurrentSpreadX = Spread[CurrentFireMode] + (ShotLayer*1.0*LayerDensity) ;
	

	ShotLayer++;
	if (CurrentSpreadX == 0)
	{
		return BaseAim;
	}
	else
	{
		// Add in consistent, circular spread
		GetAxes(BaseAim, X, Y, Z);
		RandY = sin(Additive * DegToRad);
		RandZ = cos(DegToRad*Additive);
		
		Additive += (360.0/NumPellets) ;
		
		if(Additive >= 360) Additive=0; 
		if(ShotLayer >= NumSpreadLayers) ShotLayer=0;
		
		return rotator(X + RandY * CurrentSpreadX * Y + RandZ * CurrentSpreadX * Z);
	}
}



defaultproperties
{
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
        bCauseActorAnimEnd=true
    End Object

    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'RX_WP_FlakCannon.Mesh.SK_FlakCannon_1P'
        AnimSets(0)=AnimSet'RX_WP_FlakCannon.Anims.AS_FlakCannon_Weapon'
        Animations=MeshSequenceA
		Scale=2.5
        FOV=75.0
    End Object

    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_FlakCannon.Mesh.SK_FlakCannon_Back'
        // Translation=(X=-10)
        Scale=1.0
    End Object
	
    ArmsAnimSet = AnimSet'RX_WP_FlakCannon.Anims.AS_FlakCannon_Arms'

	AttachmentClass=class'TS_Attachment_ShotgunIncendiary'

    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_ShotgunIncendiary'

    PlayerViewOffset=(X=5.0,Y=-3.0,Z=-2.0)

    FireOffset=(X=4,Y=8,Z=-10)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	RightHandIK_Offset=(X=6,Y=-6,Z=-2)
	LeftHandIK_Relaxed_Offset = (X=1.000000,Y=-2.000000,Z=3.000000)

	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 700.0
	MaxRecoil = 800.0
	MaxTotalRecoil = 30000.0
	RecoilInterpSpeed = 25.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 5.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.001
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.5
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

    Spread(0)=0.03
    Spread(1)=0.01

	IronSightAndScopedSpread(0)= 0.025
	IronSightAndScopedSpread(1)= 0.00001

	SpreadScoped = 0.04
	SpreadNoScoped = 0.06

    EquipTime=0.75
	//PutDownTime=0.3

    NumPellets = 7
    ClipSize = 12
    InitalNumClips = 5
	MaxClips = 5
	
	Ammo_Increment = 8
	AmmoIncrementRate = 1.0

	bAutoFire = False
 
    FireInterval(0)=0.75
    FireInterval(1)=1.1

    FireAnimLength[0] = 1.0
	FireAnimLength[1] = 1.1

	ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0
    
	WeaponFireTypes(0)=EWFT_Custom
	WeaponFireTypes(1)=EWFT_Projectile
        
	WeaponProjectiles(0)=class'TS_Projectile_Shotgun_Incendiary'
	WeaponProjectiles(1)=class'TS_Projectile_Shotgun_Incendiary'


	ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"



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


    ReloadSound(0)=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Reload'
    ReloadSound(1)=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Reload'
    PickupSound=SoundCue'TS_WP_Shotgun.Sounds.SC_Shotgun_Equip'

    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0

    MuzzleFlashSocket=MuzzleFlashSocket
    FireSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_1P'
    MuzzleFlashDuration=0.1
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
//	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_None'

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=7

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Shotgun'
    
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
	IronSightViewOffset=(X=5,Y=-8.36,Z=0)
	IronSightFireOffset=(X=0,Y=0,Z=-2)
	IronSightBobDamping=30
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=10.0 
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
	IronSightSpreadIncreasePerShotDamping = 5		// 4		1.7
	

	
	bLocSync = true; 
	LocSyncIncrement = 4; 
	
	bUseConstantSpread = false
	
	NumSpreadLayers = 2 //6 
	LayerDensity = 0.03
	ROFTurnover = 4
}
