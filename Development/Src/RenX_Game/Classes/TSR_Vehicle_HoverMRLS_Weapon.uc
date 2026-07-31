/*********************************************************
*
* File: TSR_Vehicle_HoverMRLS_Weapon.uc
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
class TSR_Vehicle_HoverMRLS_Weapon extends Rx_Vehicle_Weapon_Reloadable;



var	SoundCue WeaponDistantFireSnd;	// A second firing sound to be played when weapon fires. (Used for distant sound)


/*********************************************************************************************
 * Shoot methods
 *********************************************************************************************/

simulated function FireAmmunition()
{
    Super.FireAmmunition();
	WeaponPlaySound( WeaponDistantFireSnd );
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return false;
}

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.7) {
			MaxFinalAimAdjustment = 0.450;	
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

simulated function SetWeaponRecoil() {
	DeltaPitchX = 0.0;	
	recoiltime = 1.2;
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
		DeltaPitchX += (Deltatime*(20.0-RandRecoilIncrease/2.0));
		DeltaPitch = (5.0+RandRecoilIncrease)*sin(DeltaPitchX);

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
			DeltaPitch = Deltapitch;	
		}
		out_DeltaRot.Pitch += DeltaPitch;
		//`log("DeltaPitchX"$DeltaPitchX-DeltaPitchXOld);
		//`log("DeltaPitch"$DeltaPitch);
	}
}

DefaultProperties
{
    InventoryGroup=16

    // reload config
    ClipSize = 8
    InitalNumClips = 999
    MaxClips = 999
    
    ShotCost(0)=1
    ShotCost(1)=1
    
    ReloadTime(0) = 4.0
    ReloadTime(1) = 4.0
	
	RecoilImpulse = -0.05f
	
	CloseRangeAimAdjustRange = 50    
    
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"
  
    // gun config
    FireTriggerTags(0)="TurretFire01"
    FireTriggerTags(1)="TurretFire02"
    
    AltFireTriggerTags(0)="TurretFire01"
    AltFireTriggerTags(1)="TurretFire02"
    
    VehicleClass=Class'RenX_Game.TSR_Vehicle_HoverMRLS'
    
    FireInterval(0)=0.3
    FireInterval(1)=0.3
    bFastRepeater=true
    
    Spread(0)=0.3
    Spread(1)=0.3
   
    WeaponFireSnd(0)     = SoundCue'TS_VH_HoverMRLS.Sounds.SC_HoverMRLS_Fire'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'TSR_Vehicle_HoverMRLS_Projectile'

    WeaponFireSnd(1)     = SoundCue'TS_VH_HoverMRLS.Sounds.SC_HoverMRLS_Fire'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'TSR_Vehicle_HoverMRLS_Projectile'
	
	//Heroic Modifiers
	WeaponProjectiles_Heroic(0)= Class'TSR_Vehicle_HoverMRLS_Projectile_Heroic'
	WeaponProjectiles_Heroic(1)= Class'TSR_Vehicle_HoverMRLS_Projectile_Heroic'
	
	ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Missiles'
    ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Missiles'
	
	WeaponDistantFireSnd=SoundCue'TS_VH_HoverMRLS.Sounds.SC_Missile_DistantFire'
    
    CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
    
    // AI
    bRecommendSplashDamage=True

    bTargetLockingActive = true
    bHasRecoil = true
    
    //==========================================
    // LOCKING PROPERTIES
    //==========================================
    LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
    LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

    LockTolerance		 = 0.2 			// 0.5		// How many seconds to stay locked

    LockRange            = 12000
    ConsoleLockAim       = 0.9975			// 0.997000
    LockAim              = 0.9975			// 0.998000
    LockCheckTime        = 0.1			// 0.1
    LockAcquireTime      = 1.0 			// 0.7
    StayLocked           = 0.1 			// 0.1		// This does nothing    
    
    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True
    bOkAgainstBuildings = True
}