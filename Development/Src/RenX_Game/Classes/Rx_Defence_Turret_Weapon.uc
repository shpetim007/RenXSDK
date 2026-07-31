/*********************************************************
*
* File: Rx_Defence_Turret_Weapon.uc
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
class Rx_Defence_Turret_Weapon extends Rx_Defence_Weapon;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

simulated function bool UsesClientSideProjectiles(byte FireMode)
{
	return false;
}

DefaultProperties
{
    InventoryGroup=9
    
    // reload config
    ClipSize = 1
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
     
    ReloadTime(0) = 2
    ReloadTime(1) = 2

    ReloadSound(0)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
    ReloadSound(1)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'

    // gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'Rx_Defence_Turret'

    FireInterval(0)=0.1
    FireInterval(1)=0.1

    Spread(0)=0.0025000
    Spread(1)=0.0025000

    WeaponFireSnd(0)     = SoundCue'RX_DEF_Turret.Sounds.SC_Turret_Fire'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Defence_Turret_Projectile'
    WeaponFireSnd(1)     = SoundCue'RX_DEF_Turret.Sounds.SC_Turret_Fire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Defence_Turret_Projectile'
	
	WeaponDistantFireSnd=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'
  
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5'

    // AI
    bRecommendSplashDamage=True
    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True
	
	
	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ReloadSpeedmod = (0.98, 0.98))
	VetRankInfo(2)= (ReloadSpeedmod = (0.95, 0.95))

	//Veterans
	VetRankInfo(3)= (ReloadSpeedmod = (0.9, 0.9,))
	VetRankInfo(4)= (ReloadSpeedmod = (0.88, 0.88))
	VetRankInfo(5)= (ReloadSpeedmod = (0.85, 0.85))

	//ELITE
	VetRankInfo(6)= (ReloadSpeedmod = (0.8, 0.8))
	VetRankInfo(7)= (ReloadSpeedmod = (0.78, 0.78))
	VetRankInfo(8)= (ReloadSpeedmod = (0.75, 0.75))

	//HEROIC
	VetRankInfo(9)= (ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  
}
