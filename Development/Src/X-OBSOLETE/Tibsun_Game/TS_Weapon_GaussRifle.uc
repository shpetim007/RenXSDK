class TS_Weapon_GaussRifle extends TS_Weapon_HeatLimited    //TS_Weapon_Charged
implements (TSIfc_MultiModeWeapon);

var byte WeaponMode;


var MaterialInstanceConstant 	MCounterTens, MCounterOnes;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	MCounterOnes = Mesh.CreateAndSetMaterialInstanceConstant(2);
	MCounterTens = Mesh.CreateAndSetMaterialInstanceConstant(3);
}

simulated function UpdateAmmoCounter()
{
	local int Ones, Tens;
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		Ones = CurrentAmmoInClip%10;
		Tens = ((CurrentAmmoInClip - Ones)/10)%10;

		MCounterOnes.SetScalarParameterValue('CounterClamp', Float(Ones));
		MCounterTens.SetScalarParameterValue('CounterClamp', Float(Tens));
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







/************************/
/*TSIfc_MultiModeWeapon*/
/************************/

simulated function bool NextWeaponMode() //Set the next weapon mode and return if we were able to set it 
{
    local bool bSuccess;

    if(!HasAnyAmmo() || IsReloading() || bRecoveringFromAction)
        return false; 
    
    OnActionStart(); //beginning of an action, so call to stop fire and everything else

    if(WeaponMode >= 1)
        WeaponMode = 0; 
    else
        WeaponMode +=1;

    /*BEGIN CODE FOR SETTING WEAPON MODE*/
    switch(WeaponMode)
    {
        // Gauss Auto-Cannon
        case 0:
        bAutoFire = true;
        bInstantHit = default.bInstantHit;
        WeaponRange = default.WeaponRange;
        BoltActionReload = false;
        FireDelayTime = default.FireDelayTime;
        ShotCost[0] = default.ShotCost[0];
        Spread[0] = default.Spread[0];
        FireInterval[0] = default.FireInterval[0];
        WeaponProjectiles[0] = default.WeaponProjectiles[0];
        MinRecoil = default.MinRecoil;
        MaxRecoil = default.MaxRecoil;
        WeaponRecoilLocMin[0] = default.WeaponRecoilLocMin[0];
        WeaponRecoilLocMax[0] = default.WeaponRecoilLocMax[0];
        WeaponRecoilAnimTime[0] = default.WeaponRecoilAnimTime[0];
        WeaponPreFireSnd[0] = default.WeaponPreFireSnd[0];
        WeaponSounds[0].SoundForOwner = default.WeaponSounds[0].SoundForOwner;
        WeaponSounds[1].SoundForOther = default.WeaponSounds[1].SoundForOther;
        InstantHitDamage[0] = default.InstantHitDamage[0];
        InstantHitDamageTypes[0] = default.InstantHitDamageTypes[0];
        WeaponFireTypes[0] = default.WeaponFireTypes[0];
        MuzzleHeatPerShot = default.MuzzleHeatPerShot;
//        MuzzleFlashPSCTemplate = default.MuzzleFlashPSCTemplate;
        bSuccess = true; 
        break;

        // Charged Railgun
        case 1:
        bAutoFire = false;
        bInstantHit = false;
        WeaponRange = 15000;
        BoltActionReload = true;
        FireDelayTime = 1.5;
        ShotCost[0] = default.ShotCost[1];
        Spread[0] = default.Spread[1];
        FireInterval[0] = default.FireInterval[1];
        WeaponProjectiles[0] = default.WeaponProjectiles[1];
        MinRecoil = default.MinRecoil * 4.0;
        MaxRecoil = default.MaxRecoil * 4.0;
        WeaponRecoilLocMin[0] = default.WeaponRecoilLocMin[1];
        WeaponRecoilLocMax[0] = default.WeaponRecoilLocMax[1];
        WeaponRecoilAnimTime[0] = default.WeaponRecoilAnimTime[1];
        WeaponPreFireSnd[0] = default.WeaponPreFireSnd[1];
        WeaponSounds[0].SoundForOwner = default.WeaponSounds[7].SoundForOwner;
        WeaponSounds[1].SoundForOther = default.WeaponSounds[8].SoundForOther;
        InstantHitDamage[0] = default.InstantHitDamage[1];
        InstantHitDamageTypes[0] = default.InstantHitDamageTypes[1];
        WeaponFireTypes[0] = default.WeaponFireTypes[1];
        MuzzleHeatPerShot = default.MuzzleHeatPerShot * 8;
//        MuzzleFlashPSCTemplate = ParticleSystem'TS_WP_Railgun.Effects.P_MuzzleFlash_1P';
        bSuccess = true;  
        break;

        default: 
        break; 
    }

    PlayWeaponAnimation( SwapFromAbilityAnim, ActionToReadyTime);
    PlayArmAnimation( SwapFromAbilityArmAnim, ActionToReadyTime);

    WeaponPlaySound(SoundCue'TS_WP_AutoRifle.Sounds.S_PulseRifle_ModeSwap');
    OnActionStop(); //Also end of an action if we made it this far 

    if(ROLE < ROLE_AUTHORITY)
        ServerNextWeaponMode(); 

    return bSuccess; 
}
simulated function byte GetWeaponMode()
{
    return WeaponMode;
} //Returns the mode this weapon is currently in

simulated function string GetWeaponModeName()
{
    return WeaponModeNames[GetWeaponMode()];
}

simulated function array<string> GetWeaponModeNames()
{
    return WeaponModeNames;
}

reliable server function ServerNextWeaponMode()
{
    NextWeaponMode(); 
} 

DefaultProperties
{
    WeaponModeNames(0)="Single"
    WeaponModeNames(1)="Charged"
    // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_GaussRifle.Mesh.SK_WP_GaussRifle'
        AnimSets(0)=AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_1P'
        Animations=MeshSequenceA
        Scale=3.0
        FOV=75.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_GaussRifle.Mesh.SK_GaussRifle_Back'
        // Translation=(X=-15)
        Scale=1.0
    End Object

    ArmsAnimSet = AnimSet'TS_WP_Railgun_Light.Anims.AS_WP_Railgun_Arms'

    PlayerViewOffset=(X=10.0,Y=17.0,Z=-22.0)
    
    FireOffset=(X=5,Y=15,Z=-10)

    
    LeftHandIK_Offset=(X=2.0,Y=0.5,Z=0.0)
    LeftHandIK_Relaxed_Offset=(X=6.0,Y=-0.0,Z=3.0)
    LeftHandIK_Relaxed_Rotation=(Pitch=-3094,Yaw=4369,Roll=4369)
//  RightHandIK_Offset=(X=5.19,Y=-4.9,Z=2.04)
    RightHandIK_Relaxed_Offset=(X=2.0,Y=3.0,Z=0.0)
    RightHandIK_Relaxed_Rotation=(Pitch=910,Yaw=3640,Roll=1820)


    AttachmentClass = class'TS_Attachment_GaussRifle'
	


    //-------------- Recoil
    RecoilDelay = 0.0
    MinRecoil = 250.0
    MaxRecoil = 300.0
    MaxTotalRecoil = 50000.0
    RecoilInterpSpeed = 35.0
    RecoilDeclinePct = 0.5
    RecoilDeclineSpeed = 5.0
    MaxSpread = 0.15
    RecoilSpreadIncreasePerShot = 0.015
    RecoilSpreadDeclineSpeed = 0.25
    RecoilSpreadDecreaseDelay = 0.75
    RecoilSpreadCrosshairScaling = 1000;

    // Yaw
    RecoilYawMultiplier = 1.0
    RecoilYawModifier = 0.5
    RecoilInterpSpeedYaw = 35.0
    RecoilDeclineSpeedYaw = 5.0

    // Roll
    RecoilRollMultiplier = 2.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 35.0
    RecoilDeclineSpeedRoll = 5.0

    // IronSights
    IronSightMinRecoilDamping = 1.5
    IronSightMaxRecoilDamping = 1.5
    IronSightMaxTotalRecoilDamping = 1
    IronSightRecoilYawDamping = 2
    IronSightRecoilRollDamping = 2
    IronSightMaxSpreadDamping = 10
    IronSightSpreadIncreasePerShotDamping = 10



    WeaponRecoilLocMin(0) = (X=-7,Y=0.25,Z=0.25)
    WeaponRecoilLocMax(0) = (X=-10,Y=-0.25,Z=-0.25)

    IronsightWeaponRecoilLocMod(0) = (X=1,Y=0.25,Z=0.25)

    WeaponRecoilLocMin(1) = (X=-11,Y=0.25,Z=0.25)
    WeaponRecoilLocMax(1) = (X=-12,Y=-0.25,Z=-0.25)
    
    IronsightWeaponRecoilLocMod(1) = (X=1,Y=0.25,Z=0.25)

    WeaponRecoilRotMin[0] = (Pitch=60,Yaw=-182,Roll=-182)
    WeaponRecoilRotMax[0] = (Pitch=120,Yaw=182,Roll=910)

    IronsightWeaponRecoilRotMod = (X=0.25,Y=0.1,Z=0.1)

    WeaponRecoilAnimTime[0] = 0.7
    WeaponRecoilAnimTime[1] = 1.5


    //-----------------------------------//



    BobDamping=1.2

    bAutoFire = true
	GroupWeight=2

    InventoryGroup=1

    ShotCost(0)=1
    ShotCost(1)=2
    FireInterval(0)=0.65 
    FireInterval(1)=0.65
    
    EquipTime=1.0
	//PutDownTime=0.5
	ActionToReadyTime = 0.4
    
    Spread(0)=0.01
    Spread(1)=0.065
	IronSightAndScopedSpread(0)= 0.0001
	IronSightAndScopedSpread(1)= 0.0001
 
    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile

    WeaponProjectiles(0)=class'TS_Projectile_GaussRifle'
    WeaponProjectiles(1)=class'TS_Projectile_GaussRifle_Charged'

    ClipSize = 40
    InitalNumClips = 1
    MaxClips = 1
    
    Ammo_Increment = 8
    AmmoIncrementRate = 1.0

    FireDelayTime = 0.25
    bCharge = true

    bInstantHit = true
    WeaponRange = 10000

    HeatIncreasePerShot[0] = 17
    HeatIncreasePerShot[1] = 100
    HeatDecreasePerSec = 50

    InstantHitDamage(0)=40
    InstantHitDamage(1)=120
    
    HeadShotDamageMult=1.5

    InstantHitDamageTypes(0)=class'TS_DmgType_GaussRifle'
    InstantHitDamageTypes(1)=class'TS_DmgType_GaussRifle_Charged'

    InstantHitMomentum(0)=10000
    InstantHitMomentum(1)=10000

    //For instant hit weapons 
    bPierceInfantry = true
    bPierceVehicles = false
    MaximumPiercingAbility  =  10
    CurrentPiercingPower    =  10

    BoltActionReload=false
    bUnzoomDuringBoltActionReloading = false

    BoltReloadTime(0) = 2.0 //2.0f (Factor in RefireBoltReloadInterrupt) 
    BoltReloadTime(1) = 2.0 //2.0f

    ReloadTime(0) = 2.0
    ReloadTime(1) = 2.0

    RefireBoltReloadInterrupt(0)=1.0
    RefireBoltReloadInterrupt(1)=1.0
    
    BoltReloadAnimName(0) = "WeaponBolt"
    BoltReloadAnimName(1) = "WeaponBolt"
    BoltReloadArmAnimName(0) = "WeaponBolt"
    BoltReloadArmAnimName(1) = "WeaponBolt"

    ReloadAnimName(0) = "WeaponBolt"
    ReloadAnimName(1) = "WeaponBolt"
    ReloadArmAnimName(0) = "WeaponBolt"
    ReloadArmAnimName(1) = "WeaponBolt"

    ReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    ReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'

    BoltReloadSound(0)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    BoltReloadSound(1)=SoundCue'TS_WP_Railgun_Light.Sounds.S_Railgun_BoltReload'
    
    WeaponPreFireAnim[0]="WeaponIdle"     //WeaponCharge
    WeaponPreFireAnim[1]="WeaponIdle"
    WeaponFireAnim[0]="WeaponIdle"
    WeaponFireAnim[1]="WeaponIdle"
    WeaponPostFireAnim[0]="WeaponIdle"
    WeaponPostFireAnim[1]="WeaponIdle"

    ArmPreFireAnim[0]="WeaponIdle"
    ArmPreFireAnim[1]="WeaponIdle"
    ArmFireAnim[0]="WeaponIdle"
    ArmFireAnim[1]="WeaponIdle"
    ArmPostFireAnim[0]="WeaponIdle"
    ArmPostFireAnim[1]="WeaponIdle"

    SwapFromAbilityAnim = "WeaponIdle"
    SwapFromAbilityArmAnim = "WeaponIdle" 


    /****************************************/
    /*       TS Weapon Sound Tagss          */
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_GaussRifle.Sounds.SC_GaussRifle_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_GaussRifle.Sounds.SC_GaussRifle_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)

    WeaponSounds(7) = (SoundStartTag=,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire);
    WeaponSounds(8) = (SoundStartTag=,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Railgun.Sounds.SC_Railgun_Fire_3P',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false);


    /****************************************/



    WeaponPreFireSnd[0]=SoundCue'TS_WP_GaussRifle.Sounds.SC_ChargeUp'
    WeaponPreFireSnd[1]=SoundCue'TS_WP_Railgun.Sounds.SC_XOMAC_ChargeUp'
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none
    WeaponPostFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'

    PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_MuzzleFlash_1P'
    MuzzleFlashPSCTemplateADS=ParticleSystem'TS_WP_GaussRifle.Effects.P_MuzzleFlash_ADS'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
	
	CrosshairWidth = 180
	CrosshairHeight = 180

    CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
    IconCoordinates=(U=726,V=532,UL=165,VL=51)
    InventoryMovieGroup=14

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_GaussRifle'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_GaussRifle'

	bLocSync = true; 
	ROFTurnover = 2;
	
	//Speed modifier for Pawns with this in their inventory
	WeaponSpeedModifier = 0.0	


    /****************************************/
    /* AI */
    /****************************************/ 
    bSplashJump = False
    bLockedAimWhileFiring = False
    bMeleeWeapon = False
    bRecommendSplashDamage = False
    
    bSniping = True 
    bFastRepeater = False   

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

    MaxDesireability=0.7
    AIRating=+0.5
    CurrentRating=+0.5
    AimError = 100


	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = true
	bDisplayCrosshairInIronsight = false
    AimRate=200

	IronSightViewOffset=(X=65.0,Y=0.849,Z=-22.0)
	IronSightFireOffset=(X=5.0,Y=0.0,Z=-15.0)
	IronSightBobDamping=12
	IronSightPostAnimDurationModifier=1.0
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=30.0 
    ZoomedWeaponFov=15.0
	InverseZoomOffset=0.0

	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=160.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	


	MuzzleHeatPerShot=0.125
	MinMuzzleHeatRequired=0.100000
	MuzzleHeatCooldownWaitTime=3.000000



}
