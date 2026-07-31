/*********************************************************
*
* File: RxVehicle_Artillery_Weapon.uc
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
class Rx_Vehicle_Artillery_Weapon extends Rx_Vehicle_Weapon_Reloadable;

var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)

simulated function FireAmmunition()
{
	super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.7) {
    		if(VSizeSq(Rx_Bot(MyVehicle.Controller).GetFocus().location - MyVehicle.location) < Square(CloseRangeAimAdjustRange))
    			MaxFinalAimAdjustment = 0.450;	
			else            
            	MaxFinalAimAdjustment = 0.990;
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

simulated function SetWeaponRecoil() {
	DeltaPitchX = 0.0;
	recoiltime = 1.6;
	bWasNegativeRecoil = false;
	bWasPositiveRecoilSecondTime = false;
	RandRecoilIncrease = Rand(4);
}

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local float DeltaPitch;
	
	if(recoiltime > 0) {
		recoiltime -= Deltatime;
		DeltaPitchXOld = DeltaPitchX;
		DeltaPitchX += (Deltatime*(10.0-RandRecoilIncrease/2.0));
		DeltaPitch = (20.0+RandRecoilIncrease)*sin(DeltaPitchX);

		if(DeltaPitch>0) {		
			if(bWasNegativeRecoil) {
				DeltaPitch = DeltaPitch*2.4;
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
			DeltaPitch = Deltapitch;	
		}
		out_DeltaRot.Pitch += DeltaPitch;
		//`log("DeltaPitchX"$DeltaPitchX-DeltaPitchXOld);
		//`log("DeltaPitch"$DeltaPitch);
	}
}

DefaultProperties
{
    InventoryGroup=20

    // reload config
    ClipSize = 1
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
     
    bReloadAfterEveryShot = true
    ReloadTime(0) = 0.75		// 1.5
    ReloadTime(1) = 0.75		// 1.5
    
	CloseRangeAimAdjustRange = 600   
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true 

    ReloadSound(0)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'
    ReloadSound(1)=SoundCue'RX_VH_LightTank.Sounds.SC_LightTank_Reload'

/*-------------------------*/
/* Weapon Veterancy Block */
/*-------------------------*/

//RECRUIT
VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ReloadSpeedmod = (1.0, 1.0))
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
   VehicleClass=Class'RenX_Game.Rx_Vehicle_Artillery'

   FireInterval(0)=1.5
   FireInterval(1)=1.5

   Spread(0)=0.0025000
   Spread(1)=0.0025000
   
   bHasRecoil = true
   RecoilImpulse = -0.5f
 
   WeaponFireSnd(0)     = SoundCue'RX_VH_Artillery.Sounds.Arty_FireCue'
   WeaponFireTypes(0)   = EWFT_Projectile
   WeaponProjectiles(0) = Class'Rx_Vehicle_Artillery_Projectile_Arc' //_Arc
   WeaponFireSnd(1)     = SoundCue'RX_VH_Artillery.Sounds.Arty_FireCue'
   WeaponFireTypes(1)   = EWFT_Projectile
   WeaponProjectiles(1) = Class'Rx_Vehicle_Artillery_Projectile_Arc' //_Arc
   
   //Heroic Modifiers
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_Artillery_Projectile_Arc_Heroic'
	WeaponProjectiles_Heroic(1)= Class'Rx_Vehicle_Artillery_Projectile_Arc_Heroic'
	
	WeaponFireSounds_Heroic(0)=SoundCue'RX_VH_Artillery.Sounds.Arty_FireCue_Heroic'
	WeaponFireSounds_Heroic(1)=SoundCue'RX_VH_Artillery.Sounds.Arty_FireCue_Heroic'
   
   WeaponDistantFireSnd=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'

   // CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Artillery'
   CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
   
//	CrosshairWidth = 512
//	CrosshairHeight = 512
   
    // AI
   bRecommendSplashDamage=True
   
   FM0_ROFTurnover = 2; //9 for most automatics. Single shot weapons should be more, except the shotgun

    bOkAgainstLightVehicles = True
	bOkAgainstArmoredVehicles = True
	bOkAgainstBuildings = True
}
