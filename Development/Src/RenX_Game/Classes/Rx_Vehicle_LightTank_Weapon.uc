/*********************************************************
*
* File: Rx_Vehicle_LightWeapon.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_LightTank_Weapon extends Rx_Vehicle_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

DefaultProperties
{
    InventoryGroup=13
    
    // reload config
    ClipSize = 1
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
     
    bReloadAfterEveryShot = true
    ReloadTime(0) = 0.65 //0.75 //Closer to Med DPS at 0.65 
    ReloadTime(1) = 0.65 //0.75

    ReloadSound(0)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
    ReloadSound(1)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
    
	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ReloadSpeedmod = (0.99, 0.99))
	VetRankInfo(2)= (ReloadSpeedmod = (0.975, 0.975))

	//Veterans
	VetRankInfo(3)= (ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (ReloadSpeedmod = (0.94, 0.94))
	VetRankInfo(5)= (ReloadSpeedmod = (0.925, 0.925))

	//ELITE
	VetRankInfo(6)= (ReloadSpeedmod = (0.9, 0.9))
	VetRankInfo(7)= (ReloadSpeedmod = (0.89, 0.89))
	VetRankInfo(8)= (ReloadSpeedmod = (0.875, 0.875))

	//HEROIC
	VetRankInfo(9)= (ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

	// gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'RenX_Game.Rx_Vehicle_LightTank'

    FireInterval(0)=1.5
    FireInterval(1)=1.5

    Spread(0)=0.0025000
    Spread(1)=0.0025000
	
	RecoilImpulse = -0.2f //-0.3f
	bHasRecoil = true
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true

    WeaponFireSnd(0)     = SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Fire_1P'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_LightTank_Projectile'
    WeaponFireSnd(1)     = SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Fire_1P'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_LightTank_Projectile'
	
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_LightTank_Projectile_Heroic'
	WeaponProjectiles_Heroic(1)= Class'Rx_Vehicle_LightTank_Projectile_Heroic'
	
	WeaponFireSounds_Heroic(0)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Fire_1P_Heroic'
	WeaponFireSounds_Heroic(1)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Fire_1P_Heroic'
	
	
	WeaponDistantFireSnd=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'
   
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'

    // AI
    bRecommendSplashDamage=True
    bOkAgainstLightVehicles = True
	bOkAgainstArmoredVehicles = True
	bOkAgainstBuildings = True
	
	FM0_ROFTurnover = 2; //9 for most automatics. Single shot weapons should be more, except the shotgun
	CloseRangeAimAdjustRange=600

	bDebugWeapon = false 
}
