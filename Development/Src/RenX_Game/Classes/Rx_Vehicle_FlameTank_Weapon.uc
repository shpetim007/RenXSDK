/*********************************************************
*
* File: Rx_Vehicle_FlameTank_Weapon.uc
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
class Rx_Vehicle_FlameTank_Weapon extends Rx_Vehicle_Weapon;

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.9) {
			MaxFinalAimAdjustment = 0.450;	
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

simulated function bool UsesClientSideProjectiles(byte FireMode)
{
	return true;
}

DefaultProperties
{
    InventoryGroup=7

    // gun config
    FireTriggerTags(0)="FlameLeft"
    FireTriggerTags(1)="FlameRight"
    AltFireTriggerTags(0)="FlameLeft"
    AltFireTriggerTags(1)="FlameRight"
    VehicleClass=Class'Rx_Vehicle_FlameTank'
	bCheckIfBarrelInsideWorldGeomBeforeFiring=true 
	
    FireInterval(0)=0.05
    FireInterval(1)=0.05
    bFastRepeater=true
	
	
    Spread(0)=0.0
    Spread(1)=0.0

    /*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ROFModifier = (0.99,0.99), BuildingDamageMod = (1.0,1.0))
	VetRankInfo(2)= (ROFModifier = (0.975,0.975), BuildingDamageMod = (1.0,1.0))

	//Veterans
	VetRankInfo(3)= (ROFModifier = (0.95,0.95), BuildingDamageMod = (1.075,1.075))
	VetRankInfo(4)= (ROFModifier = (0.94,0.94), BuildingDamageMod = (1.075,1.075))
	VetRankInfo(5)= (ROFModifier = (0.925,0.925), BuildingDamageMod = (1.075,1.075))

	//ELITE
	VetRankInfo(6)= (ROFModifier = (0.90,0.90), BuildingDamageMod = (1.15,1.15))
	VetRankInfo(7)= (ROFModifier = (0.89,0.89), BuildingDamageMod = (1.15,1.15))
	VetRankInfo(8)= (ROFModifier = (0.875,0.875), BuildingDamageMod = (1.15,1.15))

	//HEROIC
	VetRankInfo(9)= (ROFModifier = (0.85,0.85), BuildingDamageMod = (1.20,1.20))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  
	
	RecoilImpulse = -0.0f
    
	CloseRangeAimAdjustRange = 800    

    WeaponFireSnd(0)     = none
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_FlameTank_Projectile'
    WeaponFireSnd(1)     = none
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_FlameTank_Projectile'
  
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_FlameTank_Projectile_Heroic'
	WeaponProjectiles_Heroic(1)= Class'Rx_Vehicle_FlameTank_Projectile_Heroic'
  
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'

    // AI
    bRecommendSplashDamage=false
    bIgnoreDownwardPitch = true

    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True
    bOkAgainstBuildings = True
    bDebugWeapon = true 
}
