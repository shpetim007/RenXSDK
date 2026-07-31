/*********************************************************
*
* File: Rx_Vehicle_Mig35_Weapon.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_Mig35_Weapon extends Rx_Vehicle_MultiWeapon;


DefaultProperties
{
    
    InventoryGroup=0
    
    ClipSize(0) = 100
    ClipSize(1) = 4

    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 4.0
    ReloadTime(1) = 6.0
    
    FireInterval(0)=0.05
    FireInterval(1)=0.2
    
    Spread(0)=0.015
    Spread(1)=0.0
	
	RecoilImpulse = -0.0f
    
    // gun config
    FireTriggerTags(0)="GattlingGunFire"
   
    AltFireTriggerTags(0)="MissileFireLeft"
    AltFireTriggerTags(1)="MissileFireRight"
	
	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5'
   
    VehicleClass=Class'RenX_Game.Rx_Vehicle_A10'

    WeaponFireSnd(0)     = None 	// SoundCue'RX_VH_A-10.Sounds.SC_A-10_Gun'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_Mig35_Gun'
    WeaponFireSnd(1)     = SoundCue'RX_VH_Mig35.Sounds.SC_Mig35_Missile'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_Mig35_Missile'
   
    //==========================================
    //LOCKING PROPERTIES
    //==========================================
    
    LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
    LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

    LockTolerance=0.5

    LockRange            = 60000 //2360
    ConsoleLockAim       = 0.992000
    LockAim              = 0.997000
    LockCheckTime        = 0.1
    LockAcquireTime      = 0.2 // change this!!!!!!!!!
    StayLocked           = 0.3 // change this, too

    
     // AI
    bRecommendSplashDamage=True
    bTargetLockingActive = true;
    
    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True

    /*-------------------------*/
	/* Reloading Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.98, 0.98))
	VetRankInfo(2)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))

	//Veterans
	VetRankInfo(3)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.9, 0.9))
	VetRankInfo(4)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.88, 0.88))
	VetRankInfo(5)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.85, 0.85))

	//ELITE
	VetRankInfo(6)= (ROFModifier = (0.85, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.8, 0.8))
	VetRankInfo(7)= (ROFModifier = (0.85, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.78, 0.78))
	VetRankInfo(8)= (ROFModifier = (0.85, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.75, 0.75))

	//HEROIC
	VetRankInfo(9)= (ROFModifier = (0.85, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 100), ReloadSpeedmod = (0.70, 0.70))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  
}
