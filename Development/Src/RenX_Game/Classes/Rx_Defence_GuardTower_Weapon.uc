
class Rx_Defence_GuardTower_Weapon extends Rx_Defence_Weapon;

simulated function bool UsesClientSideProjectiles(byte FireMode)
{
	return false;
}

DefaultProperties
{
    
    InventoryGroup=9
    
    // reload config
    ClipSize = 60
    InitalNumClips = 999
    MaxClips = 999
     
    ShotCost(0)=1
    ShotCost(1)=1
     
    ReloadTime(0) = 3.0
    ReloadTime(1) = 3.0
     
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"
     
    ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
    ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
    
    // gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'Rx_Defence_GuardTower'

    FireInterval(0)=0.08
    FireInterval(1)=0.08

    Spread(0)=0.015
    Spread(1)=0.015
  
    WeaponFireSnd(0)     = none //SoundCue'RX_VH_Humvee.Sounds.SC_Humvee_Fire'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Defence_GuardTower_Projectile'
    WeaponFireSnd(1)     = none //SoundCue'RX_VH_Humvee.Sounds.SC_Humvee_Fire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Defence_GuardTower_Projectile'
    // AI
    bRecommendSplashDamage=False
    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True

    /*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ROFModifier = (0.99, 0.99), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.99, 0.99))
	VetRankInfo(2)= (ROFModifier = (0.975, 0.975), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.975, 0.975))

	//Veterans
	VetRankInfo(3)= (ROFModifier = (0.95, 0.95), ClipSizeMod = (20, 0), ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (ROFModifier = (0.94, 0.94), ClipSizeMod = (20, 0), ReloadSpeedmod = (0.94, 0.94))
	VetRankInfo(5)= (ROFModifier = (0.925, 0.925), ClipSizeMod = (20, 0), ReloadSpeedmod = (0.925, 0.925))

	//ELITE
	VetRankInfo(6)= (ROFModifier = (0.90, 0.90), ClipSizeMod = (40, 0), ReloadSpeedmod = (0.90, 0.90))
	VetRankInfo(7)= (ROFModifier = (0.89, 0.89), ClipSizeMod = (40, 0), ReloadSpeedmod = (0.89, 0.89))
	VetRankInfo(8)= (ROFModifier = (0.875, 0.875), ClipSizeMod = (40, 0), ReloadSpeedmod = (0.875, 0.875))

	//HEROIC
	VetRankInfo(9)= (ROFModifier = (0.85, 0.85), ClipSizeMod = (60, 0), ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  
}
