class TS_Weapon_GrenadeLauncher extends TS_Weapon_Reloadable
implements (TSIfc_MultiModeWeapon);


var byte WeaponMode;

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
				if (!TS_Projectile_GrenadeLauncher_Sticky(D).bExploded)
					TS_Projectile_GrenadeLauncher_Sticky(D).Explode(D.location,vect(0,0,0));

				if (!TS_Projectile_GrenadeLauncher_Bouncy(D).bExploded)
					TS_Projectile_GrenadeLauncher_Bouncy(D).Explode(D.location,vect(0,0,0));
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
		// Full Choke
		case 0:
		WeaponProjectiles[0] = default.WeaponProjectiles[0];
		bSuccess = true; 
		break;

		// Slug
		case 1:
		WeaponProjectiles[0] = default.WeaponProjectiles[1];
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
	bAutoFire = false

	// Weapon SkeletalMesh
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'RX_WP_GrenadeLauncher.Mesh.SK_GrenadeLauncher_1P'
		AnimSets(0)=AnimSet'RX_WP_GrenadeLauncher.Anims.AS_GrenadeLauncher_1P'
		Animations=MeshSequenceA
		Scale=2.5
		FOV=75.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_GrenadeLauncher.Mesh.SK_GrenadeLauncher_Back'
        Scale=1.0
    End Object

    AttachmentClass = class'Rx_Attachment_GrenadeLauncher'

	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_GrenadeLauncher'

	ArmsAnimSet = AnimSet'RX_WP_GrenadeLauncher.Anims.AS_GrenadeLauncher_Arms'

	PlayerViewOffset=(X=0.0,Y=2.0,Z=-5.0)
	
	LeftHandIK_Offset=(X=0,Y=0,Z=0)
	RightHandIK_Offset=(X=6,Y=-5,Z=-0.5)
	
	LeftHandIK_Relaxed_Offset = (X=0.000000,Y=-2.000000,Z=4.000000)
	
	FireOffset=(X=20,Y=17,Z=-20)
	
	//-------------- Recoil
	RecoilDelay = 0.05
	RecoilSpreadDecreaseDelay = 0.7
	MinRecoil = -80.0
	MaxRecoil = -100.0
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
	ShotCost(1)=0
	FireInterval(0)=1.0
	FireInterval(1)=0.0
	ReloadTime(0) = 2.5
	ReloadTime(1) = 0
    
    EquipTime=0.5
	//PutDownTime=0.25
	ActionToReadyTime=0.35

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Custom

	WeaponProjectiles(0)=class'TS_Projectile_GrenadeLauncher_Bouncy'
	WeaponProjectiles(1)=class'TS_Projectile_GrenadeLauncher_Sticky'

	Spread(0)=0.0
	Spread(1)=0.0
	
	ClipSize = 1
    InitalNumClips = 16
	MaxClips = 16
	
	Ammo_Increment = 2
	AmmoIncrementRate = 1.0

    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
    ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"

    SwapFromAbilityAnim = "WeaponAimedToRest"
	SwapFromAbilityArmAnim = "WeaponAimedToRest"


	/****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_VH_Wolverine_HD.Sounds.SC_GrenadeLauncher_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_VH_Wolverine_HD.Sounds.SC_GrenadeLauncher_Fire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/


    WeaponFireSnd[0]=none //SoundCue'TS_VH_Wolverine_HD.Sounds.SC_GrenadeLauncher_Fire'
    WeaponFireSnd[1]=none

    WeaponPutDownSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Equip'
    WeaponEquipSnd=none //SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_PutDown'
    ReloadSound(0)=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Reload'
    ReloadSound(1)=SoundCue'RX_WP_FlakCannon.Sounds.SC_FlakCannon_Reload'

    PickupSound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltAutoRifle_Equip'

    MuzzleFlashSocket="MuzzleFlashSocket"
    FireSocket = "MuzzleFlashSocket"
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_GrenadeLauncher.Effects.MuzzleFlash_1P'
    MuzzleFlashDuration=3.3667
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'

    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_GrenadeLauncher'
	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Glass'
	
	CrosshairWidth = 256
	CrosshairHeight = 256

    InventoryGroup=2
    InventoryMovieGroup=9

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_GrenadeLauncher'
	
	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = false
	bSniping = False 
	bFastRepeater = False	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.4
	AIRating=+0.25
	CurrentRating=+0.25
	AimError = 200	
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = false	
	bDisplayCrosshairInIronsight = false
	IronSightViewOffset=(X=-5.0,Y=-8.160004,Z=-4.029900)
	IronSightFireOffset=(X=10,Y=8.5,Z=-10)
	IronSightBobDamping=20
	IronSightPostAnimDurationModifier=0.2
	// This sets how much we want to zoom in, this is a value to be subtracted because smaller FOV values are greater levels of zoom
	ZoomedFOVSub=30.0 
	ZoomedTargetFOV=60.0

	// New lower speed movement values for use while zoom aiming
	ZoomGroundSpeed=175.0
	ZoomAirSpeed=340.0
	ZoomWaterSpeed=11
	
	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 2				// 2		1.5
	IronSightMaxRecoilDamping = 2				// 2		1.5
	IronSightMaxTotalRecoilDamping = 2			// 2		1.5
	IronSightRecoilYawDamping = 2					// 1		1.0
	IronSightRecoilRollDamping = 2
	IronSightMaxSpreadDamping = 2				// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 2		// 4		1.7
}
