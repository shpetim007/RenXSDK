
class Gen_Vehicle_ScorpionTank_Weapon extends Rx_Vehicle_MultiWeapon;


var	SoundCue WeaponDistantFireSnd[2];	// A second firing sound to be played when weapon fires. (Used for distant sound)
var int MissileRecoilCount;


simulated function FireAmmunition()
{
    Super.FireAmmunition();
	
	if( WeaponDistantFireSnd[CurrentFireMode] != None )
			WeaponPlaySound( WeaponDistantFireSnd[CurrentFireMode] );

	if(CurrentFireMode == 1)
	{
		if(GEN_Vehicle_ScorpionTank(MyVehicle) != none)
			GEN_Vehicle_ScorpionTank(MyVehicle).SetShowMissile(false);
	}
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return CurrFireMode == 0;
}

simulated function SetWeaponRecoil() {
	DeltaPitchX = 0.0;
	if(CurrentFireMode == 0) {
		recoiltime = 1.2;
		bWasNegativeRecoil = false;
		bWasPositiveRecoilSecondTime = false;
		RandRecoilIncrease = Rand(10);
	} else {
		if(recoiltime > 0) {
			MissileRecoilCount += 2;
		} else {
	        MissileRecoilCount = 0;
		}
		recoiltime = 1.2;
		bWasNegativeRecoil = false;
		bWasPositiveRecoilSecondTime = false;
		RandRecoilIncrease = Rand(2);
	}
}

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local float DeltaPitch;
	
	if(recoiltime > 0) {
		recoiltime -= Deltatime;
		DeltaPitchXOld = DeltaPitchX;
		if(CurrentFireMode == 0) {
			DeltaPitchX += (Deltatime*(30.0-RandRecoilIncrease/2.0));
			DeltaPitch = (10.0+RandRecoilIncrease)*sin(DeltaPitchX);
		} else {
			DeltaPitchX += (Deltatime*(20.0-MissileRecoilCount-RandRecoilIncrease/2.0));
			DeltaPitch = (5.0+RandRecoilIncrease)*sin(DeltaPitchX);
		}

		if(DeltaPitch>0) {		
			if(bWasNegativeRecoil) {
				bWasPositiveRecoilSecondTime = true;
				return;
			} else {
				DeltaPitch = Deltapitch;
			}
		}
		if(DeltaPitch<0) {
			if(bWasPositiveRecoilSecondTime) {
				return;
			}		
			bWasNegativeRecoil = true;
		}
		out_DeltaRot.Pitch += DeltaPitch;
		//`log("DeltaPitchX"$DeltaPitchX-DeltaPitchXOld);
		//`log("DeltaPitch"$DeltaPitch);
	}
}

simulated function SecondaryReloadTimer()
{
	if(GEN_Vehicle_ScorpionTank(MyVehicle) != none && WorldInfo.NetMode != NM_DedicatedServer)
	{
		GEN_Vehicle_ScorpionTank(MyVehicle).SetShowMissile(true);
	}
	
	super.SecondaryReloadTimer();
}

DefaultProperties
{
    InventoryGroup=14
    
    SecondaryLockingDisabled=false
    
    ClipSize(0) = 1
    ClipSize(1) = 1

    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 1.2// 3.0 2.0
    ReloadTime(1) = 8.0
    
    FireInterval(0)= 0.1
    FireInterval(1)=0.2
    bFastRepeater = false
    
    Spread(0)=0.01
    Spread(1)=0.05
	
	RecoilImpulse = -0.10f
    
	CloseRangeAimAdjustRange = 600  
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true  
 
    // gun config
    FireTriggerTags(0)="FireL"
    FireTriggerTags(1)="FireR"

    AltFireTriggerTags(0)="AltFireR"
   
    VehicleClass=Class'Gen_Vehicle_ScorpionTank'

    WeaponFireSnd(0)     = SoundCue'Gen_VH_ScorpionTank.Sounds.SC_ScorpionTank_Fire_1P'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Gen_Vehicle_ScorpionTank_Cannon'
    WeaponFireSnd(1)     = SoundCue'Gen_VH_ScorpionTank.Sounds.SC_ScorpionTank_RocketFire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Gen_Vehicle_ScorpionTank_Rocket'
	
	WeaponDistantFireSnd(0)=None=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'
	WeaponDistantFireSnd(1)=SoundCue'TS_VH_HoverMRLS.Sounds.SC_Missile_DistantFire'

	WeaponProjectiles_Heroic(0)= Class'Gen_Vehicle_ScorpionTank_Cannon'
	WeaponProjectiles_Heroic(1)= Class'Gen_Vehicle_ScorpionTank_Rocket'
 
	WeaponFireSounds_Heroic(0)=SoundCue'Gen_VH_ScorpionTank.Sounds.SC_ScorpionTank_Fire_1P'
	WeaponFireSounds_Heroic(1)=SoundCue'RX_VH_M2Bradley.Sounds.SC_M2Bradley_Rocket'
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'

    //==========================================
    //LOCKING PROPERTIES
    //==========================================
    
    LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
    LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

	LockTolerance=0.25

    LockRange            = 8500
    ConsoleLockAim       = 0.997000
    LockAim              = 0.998000
    LockCheckTime        = 0.1
    LockAcquireTime      = 0.7 // change this!!!!!!!!!
    StayLocked           = 0.1 // change this, too

    
     // AI
    bRecommendSplashDamage=True
    bTargetLockingActive = true;

	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (DamageModifier = (1.0,1.0), ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (DamageModifier = (1.0,1.0), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.975, 0.975))
	VetRankInfo(2)= (DamageModifier = (1.0,1.0), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.975, 0.975))

	//Veterans
	VetRankInfo(3)= (DamageModifier = (1.0,1.0), ROFModifier = (0.925,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (DamageModifier = (1.0,1.0), ROFModifier = (0.925,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.925, 0.925))
	VetRankInfo(5)= (DamageModifier = (1.0,1.0), ROFModifier = (0.925,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.925, 0.925))

	//ELITE
	VetRankInfo(6)= (DamageModifier = (1.0,1.0), ROFModifier = (0.85,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.90, 0.90))
	VetRankInfo(7)= (DamageModifier = (1.0,1.0), ROFModifier = (0.85,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.85, 0.85))
	VetRankInfo(8)= (DamageModifier = (1.0,1.0), ROFModifier = (0.85,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.85, 0.85))

	//HEROIC
	VetRankInfo(9)= (DamageModifier = (1.0,1.0), ROFModifier = (0.7,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.75, 0.75))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

/***********************************/

SF_Tolerance = 7


FM0_ROFTurnover = 8; //9 for most automatics. Single shot weapons should be more, except the shotgun
FM1_ROFTurnover = 2; 


bOkAgainstLightVehicles = True
bOkAgainstArmoredVehicles = True
bOkAgainstBuildings = True
}

