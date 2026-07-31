class TS_Weapon_CyborgPurifier extends TS_Weapon_HeatLimited
implements (TSIfc_MultiModeWeapon);

var byte WeaponMode;


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
        //Repeater
        case 0:
        MinRecoil = default.MinRecoil;
        MaxRecoil = default.MaxRecoil;
        RecoilInterpSpeed = default.RecoilInterpSpeed;
        RecoilSpreadDeclineSpeed = default.RecoilSpreadDeclineSpeed;
        RecoilDeclinePct = default.RecoilDeclinePct;
        IronSightMinRecoilDamping = default.IronSightMinRecoilDamping;
        IronSightMaxRecoilDamping = default.IronSightMaxRecoilDamping;
        FireDelayTime = default.FireDelayTime;
        ShotCost[0] = default.ShotCost[0];
        ShotCost[1] = default.ShotCost[0];
        Spread[0] = default.Spread[0];
        Spread[1] = default.Spread[0];
        WeaponPreFireSnd[0] = default.WeaponPreFireSnd[0];
        WeaponPreFireSnd[1] = default.WeaponPreFireSnd[0];
        WeaponFireSnd[0] = default.WeaponFireSnd[0];
        WeaponFireSnd[1] = default.WeaponFireSnd[0];
        WeaponPostFireSnd[0] = default.WeaponPostFireSnd[0];
        WeaponPostFireSnd[1] = default.WeaponPostFireSnd[0];
        WeaponProjectiles[0] = default.WeaponProjectiles[0];
        WeaponProjectiles[1] = default.WeaponProjectiles[0];
        FireInterval[0] = default.FireInterval[0];
        FireInterval[1] = default.FireInterval[0];
        HeatIncreasePerShot[0] = default.HeatIncreasePerShot[0];
        HeatIncreasePerShot[1] = default.HeatIncreasePerShot[0];
        MuzzleHeatPerShot = default.MuzzleHeatPerShot;
        bSuccess = true; 
        break;

        //Cannon
        case 1:
        MinRecoil = 1750;
        MaxRecoil = 2000;
        RecoilInterpSpeed = 30;
        RecoilSpreadDeclineSpeed = 3;
        RecoilDeclinePct = 0.8;
        IronSightMinRecoilDamping = 0.045714;
        IronSightMaxRecoilDamping = 0.06;
        FireDelayTime = 3.0;
        ShotCost[0] = default.ShotCost[1];
        ShotCost[1] = default.ShotCost[1];
        Spread[0] = default.Spread[1];
        Spread[1] = default.Spread[1];
        WeaponPreFireSnd[0] = default.WeaponPreFireSnd[1];
        WeaponPreFireSnd[1] = default.WeaponPreFireSnd[1];
        WeaponFireSnd[0] = default.WeaponFireSnd[1];
        WeaponFireSnd[1] = default.WeaponFireSnd[1];
        WeaponPostFireSnd[0] = default.WeaponPostFireSnd[1];
        WeaponPostFireSnd[1] = default.WeaponPostFireSnd[1];
        WeaponProjectiles[0] = default.WeaponProjectiles[1];
        WeaponProjectiles[1] = default.WeaponProjectiles[1];
        FireInterval[0] = default.FireInterval[1];
        FireInterval[1] = default.FireInterval[1];
        HeatIncreasePerShot[0] = default.HeatIncreasePerShot[1];
        HeatIncreasePerShot[1] = default.HeatIncreasePerShot[1];
        MuzzleHeatPerShot = 0.2f;
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
    WeaponModeNames(0)="Normal"
    WeaponModeNames(1)="Heavy"
   // Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgPlasmaCannon.Mesh.SK_CyborgPlasmaCannon_1P'
        AnimSets(0)=AnimSet'RX_WP_LaserChaingun.Anims.AS_LCG_1P'
        Animations=MeshSequenceA
        FOV=90
        Scale=2.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgPlasmaCannon.Mesh.SK_CyborgPlasmaCannon_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'TS_Attachment_CyborgPurifier'
    
    ArmsAnimSet = AnimSet'RX_WP_LaserChaingun.Anims.AS_LCG_Arms'
    
    PlayerViewOffset=(X=-25.0,Y=8.0,Z=-10.0)
    
    FireOffset=(X=35,Y=15,Z=-25)
    
    LeftHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
    LeftHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=0)
    RightHandIK_Relaxed_Offset = (X=0.0,Y=0.0,Z=0.0)
    RightHandIK_Relaxed_Rotation = (Pitch=0,Yaw=0,Roll=-0)

    LeftHandIK_Offset=(X=0,Y=0,Z=0)
    bUseHandIKWhenRelax=False
    bByPassHandIK=true

    
    //-------------- Recoil
    RecoilDelay = 0.0
    MinRecoil = -50.0
    MaxRecoil = -70.0
    MaxTotalRecoil = 10000.0
    RecoilInterpSpeed = 90.0
    RecoilDeclinePct = 1.5
    RecoilDeclineSpeed = 45.0
    MaxSpread = 0.05
    RecoilSpreadIncreasePerShot = 0.0
    RecoilSpreadDeclineSpeed = 0.05
    RecoilSpreadDecreaseDelay = 0.15
    RecoilSpreadCrosshairScaling = 2000;

    // Yaw
    RecoilYawMultiplier = 1.5
    RecoilYawModifier = 0.5
    RecoilInterpSpeedYaw = -1.0
    RecoilDeclineSpeedYaw = 2.0

    // Roll
    RecoilRollMultiplier = 2.0
    RecoilRollModifier = 0.5
    RecoilInterpSpeedRoll = 60.0
    RecoilDeclineSpeedRoll = 12.0

    // IronSights
    IronSightMinRecoilDamping = 2
    IronSightMaxRecoilDamping = 2
    IronSightMaxTotalRecoilDamping = 2
    IronSightRecoilYawDamping = 2
    IronSightRecoilRollDamping = 2
    IronSightMaxSpreadDamping = 2
    IronSightSpreadIncreasePerShotDamping = 2

    //-----------------------------------//

    ShotCost(0)=1
    ShotCost(1)=50
    
    ShouldFireOnRelease(0)=0
    ShouldFireOnRelease(1)=0
    
    FireInterval(0)=+0.083333
    FireInterval(1)=+0.1

    EquipTime=0.75
    PutDownTime=0.5

    WeaponFireTypes(0)=EWFT_Projectile
    WeaponFireTypes(1)=EWFT_Projectile
    
    WeaponProjectiles(0)=class'TS_Projectile_CyborgPurifier'
    WeaponProjectiles(1)=class'TS_Projectile_CyborgPurifier_Heavy'

    Spread(0)=0.0025
    Spread(1)=0.0
    
    IronSightAndScopedSpread(0)= 0.0
    IronSightAndScopedSpread(1)= 0.0

    FireDelayTime = 1.0
    bCharge = true

    ClipSize = 1000
    CoolThreshold = 30

    Ammo_Increment = 25
    AmmoIncrementRate = 1.0

    HeatIncreasePerShot[0] = 2
    HeatIncreasePerShot[1] = 100
    HeatDecreasePerSec = 30

    ReloadSound(0)=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Reload'
    ReloadSound(1)=SoundCue'TS_WP_CyborgPlasmaCannon.Sounds.SC_Reload'

    WeaponPreFireAnim[0]="WeaponFireStart"
    WeaponPreFireAnim[1]="WeaponFireStart"
    WeaponFireAnim[0]="WeaponFireLoop"
    WeaponFireAnim[1]="WeaponFireLoop"
    WeaponPostFireAnim[0]="WeaponFireEnd"
    WeaponPostFireAnim[1]="WeaponFireEnd"

    ArmPreFireAnim[0]="WeaponFireStart"
    ArmPreFireAnim[1]="WeaponFireStart"
    ArmFireAnim[0]="WeaponFireLoop"
    ArmFireAnim[1]="WeaponFireLoop"
    ArmPostFireAnim[0]="WeaponFireEnd"
    ArmPostFireAnim[1]="WeaponFireEnd"

    SwapFromAbilityAnim="WeaponAimedToRest"
    SwapFromAbilityArmAnim="WeaponAimedToRest"

//****************************************************\\
//*************** TS Weapon Sound Tags ***************\\
//****************************************************\\

    // Weapon Equip & Put down sounds
    WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
    WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(7)=(SoundStartTag=PostFire,SoundEndTag=,SoundForOwner=SoundCue'RX_WP_FlameThrower.Sounds.FlameThrower_FireEndCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(8)=(SoundStartTag=SwappedFire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_Flamethrower.Sounds.Snd_Flamethrower_GrenadeFire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
    WeaponSounds(9)=(SoundStartTag=SwappedFire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_Flamethrower.Sounds.Snd_Flamethrower_GrenadeFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)
    


    /****************************************/ 
    
    WeaponPreFireSnd[0]=SoundCue'TS_WP_PlasmaCannon.Sounds.SC_PlasmaCannon_Fire_Start'
    WeaponPreFireSnd[1]=SoundCue'TS_WP_PlasmaCannon.Sounds.SC_PlasmaCannon_AltFire_Start'
    WeaponFireSnd[0]=SoundCue'TS_WP_FlameThrower.Sounds.SC_FlameThrower_Fire_Loop'
    WeaponFireSnd[1]=none
    WeaponPostFireSnd[0]=none //SoundCue'RX_WP_FlameThrower.Sounds.FlameThrower_FireEndCue'
    WeaponPostFireSnd[1]=none //SoundCue'TS_WP_Flamethrower.Sounds.Snd_Flamethrower_GrenadeFire'

    WeaponPutDownSnd=none //SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_PutDown'
    WeaponEquipSnd=none //SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip'

    PickupSound=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip'

    FireSocket="MuzzleFlashSocket"

    MuzzleFlashSocket="MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Flamethrower.Effects.P_CyborgPurifier_MuzzleFlash'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=none

    CrosshairWidth = 256
    CrosshairHeight = 256
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
    // CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Glass' // MaterialInstanceConstant'RenXHud.MI_Reticle_Dot'

    InventoryGroup=1
    GroupWeight=1
    InventoryMovieGroup=11

    WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_CyborgPlasmaCannon'

    // Muzzle heat
    MuzzleHeatPerShot = 0.004f               // Heat increase per shot
    MuzzleHeatCooldownTimeInterval = 0.05f // Time between each decrease tick
    MuzzleHeatCooldownAmount = -0.0025f     // Amount to decrease per cooldown tick
    MinMuzzleHeatRequired = 0.1f            // Minimum heat required for it to be shown
    MuzzleHeatCooldownWaitTime = 0.5f       // Time between firing and starting decrease ticks
    
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

    MaxDesireability=0.8
    AIRating=+0.6
    CurrentRating=+0.6
    AimError = 545 


    //==========================================
    // IRON SIGHT PROPERTIES
    //==========================================
    
    // IronSight:
    bIronSightCapable = true
    bDisplayCrosshairInIronsight = true
    IronSightViewOffset=(X=-25.0,Y=8.0,Z=-10.0)
    IronSightFireOffset=(X=35,Y=7,Z=-10)
    IronSightBobDamping=6
    IronSightPostAnimDurationModifier=1.0
    // This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
    ZoomedFOVSub=25.0 
    ZoomedWeaponFov=90.0
    ZoomedTargetFOV=65.0
    
    // New lower speed movement values for use while zoom aiming
    ZoomGroundSpeed=160.0
    ZoomAirSpeed=340.0
    ZoomWaterSpeed=11

    /** one1: Added. */
    BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_PlasmaCannon'
    
    bLocSync = true; 
}
