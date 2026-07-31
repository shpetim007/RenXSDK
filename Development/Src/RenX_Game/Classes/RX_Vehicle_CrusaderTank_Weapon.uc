/*********************************************************
*
* File: Rx_Vehicle_CrusaderTank_Weapon.uc
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
class Rx_Vehicle_CrusaderTank_Weapon extends Rx_Vehicle_MultiWeapon;

var	SoundCue WeaponDistantFireSnd[2];					/* A second firing sound to be played when weapon fires. (Used for distant sound) */


simulated function FireAmmunition()
{
    Super.FireAmmunition();
	
	if( WeaponDistantFireSnd[CurrentFireMode] != None )
			WeaponPlaySound( WeaponDistantFireSnd[CurrentFireMode] );
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return true;
}

simulated function SetWeaponRecoil() {
	if(CurrentFireMode == 0) 
	{
		DeltaPitchX = 0.0;
		super.SetWeaponRecoil();
	} 
	else 
	{
		return; //Recoil on a coaxial gun just looks weird 
	}
}

simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local float DeltaPitch;
	
	if(recoiltime > 0) {
		recoiltime -= Deltatime;
		if(CurrentFireMode == 0) 
		{
			super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
		} 
		else 
		{
			DeltaPitchX += (Deltatime*(20.0 - RandRecoilIncrease/2.0));
			DeltaPitch = (0.0+RandRecoilIncrease)*sin(DeltaPitchX);
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
	}
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
	if(FiringModeNum == 0 && Rx_Vehicle_CrusaderTank(MyVehicle) != none)
	{
		Rx_Vehicle_CrusaderTank(MyVehicle).FiringAmbient.Stop();
	}
		
	super.SetCurrentFireMode(FiringModeNum);
}

DefaultProperties
{
    InventoryGroup=19
    
    ClipSize(0) = 1
	ClipSize(1) = 30
    
    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 1.4 //Adjust for not being bReloadAfterEveryShot
	ReloadTime(1) = 3.0

    ReloadSound(0)=SoundCue'RX_VH_CrusaderTank.Sounds.SC_Crusader_Reload' //SoundCue'RX_VH_MediumTank.Sounds.SC_MediumTank_Reload'
    ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'

    // gun config
    FireTriggerTags(0)="FirePrimary"
    AltFireTriggerTags(0)="FireSecondary"
    VehicleClass=Class'Rx_Vehicle_CrusaderTank'

    FireInterval(0)=0.1 
    FireInterval(1)=0.14
    
    Spread(0)=0.0025
    Spread(1)=0.01
	
	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ROFModifier = (1.0,0.99) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.99, 0.99))
	VetRankInfo(2)= (ROFModifier = (1.0,.975) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.975, 0.975))

	//Veterans
	VetRankInfo(3)= (ROFModifier = (1.0,0.95) ,ClipSizeMod = (0, 10), ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (ROFModifier = (1.0,0.94) ,ClipSizeMod = (0, 10), ReloadSpeedmod = (0.94, 0.94))
	VetRankInfo(5)= (ROFModifier = (1.0,0.925) ,ClipSizeMod = (0, 10), ReloadSpeedmod = (0.925, 0.925))

	//ELITE
	VetRankInfo(6)= (ROFModifier = (1.0,0.9) ,ClipSizeMod = (0, 25), ReloadSpeedmod = (0.9, 0.9))
	VetRankInfo(7)= (ROFModifier = (1.0,0.89) ,ClipSizeMod = (0, 25), ReloadSpeedmod = (0.89, 0.89))
	VetRankInfo(8)= (ROFModifier = (1.0, 0.875) ,ClipSizeMod = (0, 25), ReloadSpeedmod = (0.875, 0.875))

	//HEROIC
	VetRankInfo(9)= (ROFModifier = (1.0,0.85) ,ClipSizeMod = (0, 50), ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  
	

	//RecoilImpulse = -0.3f
	bHasRecoil = true
	bCheckIfBarrelInsideWorldGeomBeforeFiring = true
	

	WeaponFireSnd(0)     = SoundCue'RX_VH_CrusaderTank.Sounds.SC_CrusaderTank_Fire_1P'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_CrusaderTank_Projectile'
    WeaponFireSnd(1)     = none // SoundCue'RX_VH_Humvee.Sounds.SC_Humvee_Fire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_MediumTank_Gun'
    
	WeaponDistantFireSnd(0)=None=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_DistantFire'
	WeaponDistantFireSnd(1)=None

	WeaponProjectiles_Heroic(0) = class'Rx_Vehicle_CrusaderTank_Projectile_Heroic'
  
    //CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5'
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
    

    // AI
    bRecommendSplashDamage=True
	bOkAgainstLightVehicles = True
	bOkAgainstArmoredVehicles = True
	bOkAgainstBuildings = True
	CloseRangeAimAdjustRange= 600
	
	bSimultaneousFire = true

	bDebugWeapon = false 
}
