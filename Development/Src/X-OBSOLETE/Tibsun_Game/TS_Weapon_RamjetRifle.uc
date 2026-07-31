class TS_Weapon_RamjetRifle extends TS_Weapon_Scoped;


simulated function bool IsInstantHit()
{
	return false;
}

defaultproperties
{
	bScopeDetectsEnemies = false;
	
    Begin Object class=AnimNodeSequence Name=MeshSequenceA
    End Object

	// Weapon SkeletalMesh
    Begin Object Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'RX_WP_Ramjet.Mesh.SK_RamjetRifle_1P'
        AnimSets(0)=AnimSet'RX_WP_Ramjet.Anims.AS_RamjetRifle_1P'
        Materials(0)=MaterialInstanceConstant'RX_WP_Ramjet.Materials.MI_WP_Ramjet_Black'
        Materials(1)=MaterialInstanceConstant'RX_WP_Ramjet.Materials.MI_WP_Ramjet_Black_Lens'
        Animations=MeshSequenceA
        FOV=75
		Scale=3.0
    End Object

    // Weapon SkeletalMesh
    Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'RX_WP_Ramjet.Mesh.SK_WP_Ramjet_Back'
        //Translation=(X=-5)
        Scale=1.0
    End Object

    AttachmentClass=class'TS_Attachment_RamjetRifle'
	
	LeftHandIK_Offset=(X=0.0,Y=0.0,Z=0.0)
	RightHandIK_Offset=(X=2.0,Y=2.0,Z=-1.0)
	
	LeftHandIK_Relaxed_Offset = (X=0.000000,Y=-0.500000,Z=0.000000)
	LeftHandIK_Relaxed_Rotation = (Pitch=-3640,Yaw=0,Roll=0)
	RightHandIK_Relaxed_Offset = (X=0.000000,Y=2.000000,Z=-4.000000)
	RightHandIK_Relaxed_Rotation = (Pitch=-2730,Yaw=2730,Roll=5461)

    ArmsAnimSet=AnimSet'RX_WP_Ramjet.Anims.AS_RamjetRifle_Arms'
	
	FireOffset=(X=0,Y=0,Z=-3)	//(X=0,Y=7,Z=-5)

	PlayerViewOffset=(X=8.0,Y=1.0,Z=-2.75)
	
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 500.0
	MaxRecoil = 600.0
	MaxTotalRecoil = 5000.0
	RecoilYawModifier = 0.25 // will be a random value between 0 and this value for* every shot
	RecoilYawMultiplier = 1.0
	RecoilInterpSpeed = 25.0
	RecoilDeclinePct = 0.9
	RecoilDeclineSpeed = 3.0
	MaxSpread = 0.2
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.05
	RecoilSpreadDecreaseDelay = 1.0
	RecoilSpreadCrosshairScaling = 1000;

	// Roll
	RecoilRollMultiplier = 2.0
	RecoilRollModifier = 0.5
	RecoilInterpSpeedRoll = 60.0
	RecoilDeclineSpeedRoll = 12.0

    bAutoFire = false
	GroupWeight=1

	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = False
	bSniping = True 
	bFastRepeater = False	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.7
	AIRating=+0.5
	CurrentRating=+0.5
	AimError = 100

    InventoryGroup=1

    ShotCost(0)=1
    ShotCost(1)=0
    FireInterval(0)=1.0 //+0.5
    FireInterval(1)=1.0 //+0.5
    
    EquipTime=0.75
	//PutDownTime=0.3
	ActionToReadyTime = 0.4
    
    Spread(0)=0.15
	IronSightAndScopedSpread(0)= 0.001

    WeaponFireTypes(0)= EWFT_Projectile

    WeaponProjectiles(0)=class'TS_Projectile_RamjetRifle'

    FiringStatesArray(1)=Active

    ClipSize = 4
    InitalNumClips = 6
	MaxClips = 6
	
	Ammo_Increment = 4
	AmmoIncrementRate = 1

	BoltActionReload=true
	BoltReloadTime(0) = 2.5f
	BoltReloadTime(1) = 2.5f

	RefireBoltReloadInterrupt(0)=1.0
	RefireBoltReloadInterrupt(1)=1.0

	BoltReloadAnimName(0) = "WeaponBolt"
	BoltReloadAnimName(1) = "WeaponBolt"
	BoltReloadArmAnimName(0) = "WeaponBolt"
	BoltReloadArmAnimName(1) = "WeaponBolt"
	
	BoltReloadSound(0)=SoundCue'RX_WP_Ramjet.Sounds.SC_Ramjet_Reload_Stop'
	BoltReloadSound(1)=SoundCue'RX_WP_Ramjet.Sounds.SC_Ramjet_Reload_Stop'

    
    PerBulletReload = true
    /** Shotgun uses a 3-state reloading system **/
    ReloadAnimName(2) = "WeaponReloadStart"
    ReloadArmAnimName(2) = "WeaponReloadStart"
    ReloadAnim3PName(2) = "H_M_Shotgun_Reload_Start"
    ReloadSound(2)=SoundCue'RX_WP_Ramjet.Sounds.SC_Ramjet_Reload_Start'
    ReloadTime(2) = 0.6
    ReloadAnimName(1) = "WeaponReloadLoop"
    ReloadArmAnimName(1) = "WeaponReloadLoop"
    ReloadAnim3PName(1) = "H_M_Shotgun_Reload_Loop"
    ReloadSound(1)=SoundCue'RX_WP_Ramjet.Sounds.SC_Ramjet_Reload_Loop'
    ReloadTime(1) = 0.7
    ReloadAnimName(0) = "WeaponReloadStop"
    ReloadArmAnimName(0) = "WeaponReloadStop"
    ReloadAnim3PName(0) = "H_M_Shotgun_Reload_Stop"
    ReloadSound(0)=SoundCue'RX_WP_Ramjet.Sounds.SC_Ramjet_Reload_Stop'
    ReloadTime(0) = 1.7



    /****************************************/
    /*		 TS Weapon Sound Tagss 			*/
    /****************************************/ 

    // Weapon Fire for Player Only & for everyone else Only
    WeaponSounds(0)=(SoundStartTag=Fire,SoundEndTag=,SoundForOwner=SoundCue'TS_WP_MarksmanRifle.Sounds.SC_MarksmanRifle_Fire',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false,ClipParameterName=ClipParameter,StartParameterName=InitialFire)
	WeaponSounds(1)=(SoundStartTag=Fire,SoundEndTag=,SoundForOther=SoundCue'TS_WP_MarksmanRifle.Sounds.SC_MarksmanRifle_DistantFire',bPlayForOwner=false,bPlayForOther=true,bFirstPersonOnly=false)

	// Weapon Equip & Put down sounds
	WeaponSounds(2)=(SoundStartTag=Equip,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)
	WeaponSounds(3)=(SoundStartTag=PutDown,SoundForOwner=SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue',bPlayForOwner=true,bPlayForOther=false,bFirstPersonOnly=false)


	/****************************************/



    WeaponFireSnd[0]=none //SoundCue'TS_WP_MarksmanRifle.Sounds.SC_MarksmanRifle_Fire'
    WeaponFireSnd[1]=none //SoundCue'TS_WP_MarksmanRifle.Sounds.SC_MarksmanRifle_Fire'

    WeaponPutDownSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_PutDownCue'
    WeaponEquipSnd=none //SoundCue'RX_WP_Ramjet.Sounds.Ramjet_EquipCue'

    PickupSound=SoundCue'RX_WP_TacticalRifle.Sounds.SC_TacticalRifle_Equip'

    MuzzleFlashSocket=MuzzleFlashSocket
    FireSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_Ramjet.Effects.P_MuzzleFlash_1P'
    MuzzleFlashDuration=0.1
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

    // Configure the zoom
    HudMaterial=Material'RenX_AssetBase.PostProcess.M_SniperScope_2'

    bZoomedFireMode(0)=0
    bZoomedFireMode(1)=1
    
	CrosshairWidth = 256
	CrosshairHeight = 256
	
	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'
//  CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_None'

    CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
    IconCoordinates=(U=726,V=532,UL=165,VL=51)
    InventoryMovieGroup=14

	WeaponIconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_RamjetRifle'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_RamjetRifle'
	
	
	//==========================================
	// IRON SIGHT PROPERTIES
	//==========================================
	
	// IronSight:
	bIronSightCapable = false
	bDisplayCrosshairInIronsight = false		
	IronSightViewOffset=(X=4,Y=-6.45,Z=0.0)
	IronSightFireOffset=(X=0,Y=0,Z=-15)
	IronSightBobDamping=3
	IronSightPostAnimDurationModifier=0.2

	// IronSight additional vars to the vars in AimingWeaponClass (1 means unchanged, higher values mean more dmaping):
	IronSightMinRecoilDamping = 5					// 2		1.5
	IronSightMaxRecoilDamping = 5					// 2		1.5
	IronSightMaxTotalRecoilDamping = 5				// 2		1.5
	IronSightRecoilYawDamping = 5					// 1		1.0
	IronSightMaxSpreadDamping = 5					// 2		1.5
	IronSightSpreadIncreasePerShotDamping = 100		// 4		1.7


	//==========================================
	// SCOPE PROPERTIES
	//==========================================
/*
	ZoomedRate = 60.0
    ZoomedFOVIncrement = 15
    ZoomedFOVMin = 20.0 // Lower is more zoomed
    ZoomedFOVMax = 20.0 // Higher is less zoomed
    ZoomedTargetFOV = 20.0

    ZoomRecoilMaxIntensity = 1.0
    ZoomRecoilRecoveryRate = 5
    ZoomRecoilRate = 75
*/
	FireOffsetZoomed=(X=0,Y=0,Z=-15)

    //For scope wallhack ability 
	TI_Attack=(Texture = Texture2D'RenXTargetSystem.T_NavMarker_Max_Red', U= 0, V = 0, UL = 64, VL = 64)
	ScanDistance = 250 //Meters (~52.5uu)
	
	bLocSync = true; 
	ROFTurnover = 2;


	/****************************************/
    /*	 TS Recoil Camera & Weapon Mods 	*/
    /****************************************/ 

	CameraRecoilLocMin[0] = (X=-1,Y=-0.0,Z=0.0)
	CameraRecoilLocMin[1] = (X=-1,Y=-0.0,Z=0.0)

	CameraRecoilLocMax[0] = (X=-0.5,Y=0.0,Z=0.0)
	CameraRecoilLocMax[1] = (X=-0.5,Y=0.0,Z=0.0)
	
	CameraRecoilRotMin[0] = (Pitch = 150,Roll = 187, Yaw = -25)
	CameraRecoilRotMin[1] = (Pitch = 150,Roll = 187, Yaw = -25)

	CameraRecoilRotMax[0] = (Pitch = 150,Roll = 187, Yaw = 25)
	CameraRecoilRotMax[1] = (Pitch = 150,Roll = 187, Yaw = 25)

	IronsightCameraRecoilLocMod[0] = (X=0.25,Y=0.25,Z=0.25)
	IronsightCameraRecoilLocMod[1] = (X=0.25,Y=0.25,Z=0.25)

	IronsightCameraRecoilRotMod[0] = (X=0.25,Y=0.25,Z=0.25)
	IronsightCameraRecoilRotMod[1] = (X=0.25,Y=0.25,Z=0.25)

	IronsightWeaponRecoilLocMod[0] = (X=0.25,Y=0.25,Z=0.25)
	IronsightWeaponRecoilLocMod[1] = (X=0.25,Y=0.25,Z=0.25)

	IronsightWeaponRecoilRotMod[0] = (X=0.25,Y=0.25,Z=0.25)
	IronsightWeaponRecoilRotMod[1] = (X=0.25,Y=0.25,Z=0.25)

	
	CamRecoilRotAnim[0] = 	{(
								Points[0] = (InVal = 0.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[1] = (InVal = 0.01,OutVal = (X=-0.2,Y=-0.2,Z=-0.2),InterpMode = CIM_CurveAuto),
								Points[2] = (InVal = 0.025,OutVal = (X=1.0,Y=1.0,Z=1.0),InterpMode = CIM_CurveAuto),
								Points[3] = (InVal = 0.125,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[4] = (InVal = 0.4,OutVal = (X=-1,Y=-3.0,Z=-3.0),InterpMode = CIM_CurveAuto),
								Points[5] = (InVal = 0.5,OutVal = (X=-0.5,Y=3.0,Z=-2.0),InterpMode = CIM_CurveAuto),
								Points[6] = (InVal = 0.65,OutVal = (X=-1.0,Y=-2.0,Z=-4.0),InterpMode = CIM_CurveAuto),
								Points[7] = (InVal = 0.8f,OutVal = (X=0.5,Y=0.5,Z=0.5),InterpMode = CIM_CurveAuto),
								Points[8] = (InVal = 1.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto)
							)}
	CamRecoilRotAnim[1] = 	{(
								Points[0] = (InVal = 0.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[1] = (InVal = 0.01,OutVal = (X=-0.2,Y=-0.2,Z=-0.2),InterpMode = CIM_CurveAuto),
								Points[2] = (InVal = 0.025,OutVal = (X=1.0,Y=1.0,Z=1.0),InterpMode = CIM_CurveAuto),
								Points[3] = (InVal = 0.125,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto),
								Points[4] = (InVal = 0.4,OutVal = (X=-1,Y=-3.0,Z=-3.0),InterpMode = CIM_CurveAuto),
								Points[5] = (InVal = 0.5,OutVal = (X=-0.5,Y=3.0,Z=-2.0),InterpMode = CIM_CurveAuto),
								Points[6] = (InVal = 0.65,OutVal = (X=-1.0,Y=-2.0,Z=-4.0),InterpMode = CIM_CurveAuto),
								Points[7] = (InVal = 0.8f,OutVal = (X=0.5,Y=0.5,Z=0.5),InterpMode = CIM_CurveAuto),
								Points[8] = (InVal = 1.f,OutVal = (X=0,Y=0.0,Z=0.0),InterpMode = CIM_CurveAuto)
							)}

	CamRecoilAnimTime[0] = 4.0;
	CamRecoilAnimTime[1] = 4.0;

}