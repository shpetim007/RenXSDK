/*********************************************************
*
* File: Rx_Vehicle_Orca_Weapon.uc
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
class Rx_Vehicle_Orca_Weapon extends Rx_Vehicle_MultiWeapon;

var	SoundCue WeaponDistantFireSnd[2];					/* A second firing sound to be played when weapon fires. (Used for distant sound) */


simulated function FireAmmunition()
{
    Super.FireAmmunition();
	if( WeaponDistantFireSnd[CurrentFireMode] != None )
			WeaponPlaySound( WeaponDistantFireSnd[CurrentFireMode] );
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return CurrFireMode == 1;
}

simulated function GetFireStartLocationAndRotation(out vector SocketLocation, out rotator SocketRotation) {
    
    super.GetFireStartLocationAndRotation(SocketLocation, SocketRotation);    
    
    if( (Rx_Bot(MyVehicle.Controller) != None) && (Rx_Bot(MyVehicle.Controller).GetFocus() != None) ) {
        if(class'Rx_Utils'.static.OrientationOfLocAndRotToB(SocketLocation,SocketRotation,Rx_Bot(MyVehicle.Controller).GetFocus()) > 0.6) {
			MaxFinalAimAdjustment = 0.350;	
        } else {
            MaxFinalAimAdjustment = 0.990;
        }
    }
}

function byte BestMode()
{
	if(bLockedOnTarget && !PrimaryReloading)
		return 0;
	
	if(!SecondaryReloading)
		return 1;
	
	return 0;	
}


DefaultProperties
{
  	bIgnoreDownwardPitch = true
  	bFastRepeater=true
  
    InventoryGroup=19
    
    ClipSize(0) = 8
	ClipSize(1) = 100
    
    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 8.0
	ReloadTime(1) = 3.0
        
    FireInterval(0)=0.4
	FireInterval(1)=0.05
    
    Spread(0)=0.05
	Spread(1)=0.015
	
	RecoilImpulse = -0.0f
   
    // gun config
    FireTriggerTags(0)="FireLeft"
	FireTriggerTags(1)="FireRight"
   
    AltFireTriggerTags(0)="GunFire"
//  AltFireTriggerTags(1)="FireRight"

	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
 
    VehicleClass=Class'RenX_Game.Rx_Vehicle_Orca'

    WeaponFireSnd(0)     = SoundCue'RX_VH_Orca.Sounds.SC_Orca_Missile'
    WeaponFireTypes(0)   = EWFT_Projectile
    WeaponProjectiles(0) = Class'Rx_Vehicle_Orca_Missile'
	WeaponFireSnd(1)     = none // SoundCue'RX_VH_APC_GDI.Sounds.SC_APC_Fire'
	WeaponFireTypes(1)   = EWFT_Projectile
	WeaponProjectiles(1) = Class'Rx_Vehicle_Orca_Gun'
	
//	ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Missiles'
//	ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
	
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_Orca_Missile_Heroic'
	WeaponProjectiles_Heroic(1)= Class'Rx_Vehicle_Orca_Gun'
 
	WeaponFireSounds_Heroic(0)=SoundCue'RX_VH_Orca.Sounds.SC_Orca_Missile_Heroic'
	
	WeaponDistantFireSnd(0)=SoundCue'RX_VH_Orca.Sounds.SC_Missile_DistantFire'
	WeaponDistantFireSnd(1)=None		// The gun sound is being handled in the vehicle class
	
	
	
/*	
	WeaponRange=4500.0

	WeaponFireTypes(1)=EWFT_InstantHit

	InstantHitDamage(0)=12
	InstantHitDamage(1)=12
	
	HeadShotDamageMult=2.5

	InstantHitDamageTypes(0)=class'Rx_DmgType_Orca_Gun'
	InstantHitDamageTypes(1)=class'Rx_DmgType_Orca_Gun'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
	bInstantHit=true
	

	BeamTemplates[1]=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_GDI_Large'
	
	DefaultAltImpactEffect=(ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	
	AltImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Dirt_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
    AltImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	AltImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
    AltImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Metal_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Metal')
    AltImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Glass_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
    AltImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Wood_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Wood')
    AltImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Water')
    AltImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Water')
	AltImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Flesh',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Flesh')
	AltImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumGround_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	AltImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumCrystal_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
	AltImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumGround_Blue_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	AltImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumCrystal_Blue_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
	AltImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Mud_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Mud')
	AltImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_WhiteSand_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	AltImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_YellowSand_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	AltImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Grass_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Grass')
	AltImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_YellowStone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	AltImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Snow_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Snow')
	AltImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Snow_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
*/
	
	
	
     
    //==========================================
    //LOCKING PROPERTIES
    //==========================================
    
    LockAcquiredSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLock_Cue'
    LockLostSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_SeekLost_Cue'

    LockTolerance=0.25

    LockRange            = 4500
    ConsoleLockAim       = 0.997000
    LockAim              = 0.998000
    LockCheckTime        = 0.1
    LockAcquireTime      = 0.7 // change this!!!!!!!!!
    StayLocked           = 0.1 // change this, too

    
     // AI
    bRecommendSplashDamage=True
    bTargetLockingActive = true;

	/*-------------------------*/
	/* Reloading Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (ROFModifier = (1.0, 0.99), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.98, 0.98))
	VetRankInfo(2)= (ROFModifier = (1.0, 0.975), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))

	//Veterans
	VetRankInfo(3)= (ROFModifier = (1.0, 0.95), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.9, 0.9))
	VetRankInfo(4)= (ROFModifier = (1.0, 0.94), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.88, 0.88))
	VetRankInfo(5)= (ROFModifier = (1.0, 0.925), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 20), ReloadSpeedmod = (0.85, 0.85))

	//ELITE
	VetRankInfo(6)= (ROFModifier = (0.85, 0.9), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.8, 0.8))
	VetRankInfo(7)= (ROFModifier = (0.85, 0.89), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.78, 0.78))
	VetRankInfo(8)= (ROFModifier = (0.85, 0.875), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (2, 50), ReloadSpeedmod = (0.75, 0.75))

	//HEROIC
	VetRankInfo(9)= (ROFModifier = (0.85, 0.85), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (4, 100), ReloadSpeedmod = (0.70, 0.70))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

SF_Tolerance = 120; //For now, till it becomes an issue


FM0_ROFTurnover = 4; //9 for most automatics. Single shot weapons should be more, except the shotgun
FM1_ROFTurnover = 6; 

    bOkAgainstLightVehicles = True
    bOkAgainstArmoredVehicles = True
    bOkAgainstBuildings = True
}
