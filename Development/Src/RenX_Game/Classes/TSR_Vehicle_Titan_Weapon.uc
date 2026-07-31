/*********************************************************
*
* File: TSR_Vehicle_Titan_Weapon.uc
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
class TSR_Vehicle_Titan_Weapon extends Rx_Vehicle_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

DefaultProperties
{
    InventoryGroup=15
    
    // reload config
    ClipSize = 1
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
     
    bReloadAfterEveryShot = true
    ReloadTime(0) = 0.75
    ReloadTime(1) = 0.75

    ReloadSound(0)=SoundCue'TS_VH_Titan.Sounds.SC_Reload'
    ReloadSound(1)=SoundCue'TS_VH_Titan.Sounds.SC_Reload'

    // gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'TSR_Vehicle_Titan'

    FireInterval(0)=1.5
    FireInterval(1)=1.5
    
    Spread(0)=0.0025000
    Spread(1)=0.0025000
	
	RecoilImpulse = -0.0f
	bHasRecoil = true
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true
	

	WeaponFireSnd(0)     = SoundCue'TS_VH_Titan.Sounds.SC_Cannon_Fire'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'TSR_Vehicle_Titan_Cannon'
    WeaponFireSnd(1)     = SoundCue'TS_VH_Titan.Sounds.SC_Cannon_Fire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'TSR_Vehicle_Titan_Cannon'
    
	WeaponDistantFireSnd=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'
  
    //CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5'
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
    

    // AI
    bRecommendSplashDamage=True
	
    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True
    bOkAgainstBuildings = True
}
