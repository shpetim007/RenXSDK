/*********************************************************
*
* File: Rx_Vehicle_Apache_Weapon.uc
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
class Rx_Vehicle_Apache_Weapon extends Rx_Vehicle_MultiWeapon;

var	SoundCue WeaponDistantFireSnd[2];					/* A second firing sound to be played when weapon fires. (Used for distant sound) */


simulated function FireAmmunition()
{
    Super.FireAmmunition();
	if( WeaponDistantFireSnd[CurrentFireMode] != None )
			WeaponPlaySound( WeaponDistantFireSnd[CurrentFireMode] );
}

simulated function bool UsesClientSideProjectiles(byte CurrFireMode)
{
	return CurrFireMode == 0;
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
	if(bLockedOnTarget && !SecondaryReloading)
		return 1;
	
	if(!PrimaryReloading)
		return 0;
	
	return 1;	
}


DefaultProperties
{
    bIgnoreDownwardPitch = true
    bFastRepeater=true
    
    InventoryGroup=18
    
    SecondaryLockingDisabled=false
    
    ClipSize(0) = 40
    ClipSize(1) = 16

    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 3.0
    ReloadTime(1) = 8.0
    
    FireInterval(0)=0.15
    FireInterval(1)=0.2
    
    Spread(0)=0.015
    Spread(1)=0.05
 
    // gun config
    FireTriggerTags(0)="GunFire"
   
    AltFireTriggerTags(0)="FireLeft"
    AltFireTriggerTags(1)="FireRight"
	
	RecoilImpulse = -0.0f
	
	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Tank_Type5A'
   
    VehicleClass=Class'RenX_Game.Rx_Vehicle_Apache'

    WeaponFireSnd(0)     = none // SoundCue'RX_VH_Apache.Sounds.SC_Apache_Gun'
	WeaponFireTypes(0)   = EWFT_Projectile
	WeaponProjectiles(0) = Class'Rx_Vehicle_Apache_Gun'
    WeaponFireSnd(1)     = SoundCue'RX_VH_Apache.Sounds.SC_Apache_Missile'
    WeaponFireTypes(1)   = EWFT_Projectile
    WeaponProjectiles(1) = Class'Rx_Vehicle_Apache_Missile'
	
//	ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
//	ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Missiles'
	
	WeaponDistantFireSnd(0)=None		// The gun sound is being handled in the vehicle class
	WeaponDistantFireSnd(1)=SoundCue'RX_SoundEffects.Missiles.SC_Missile_DistantFire'
	
	WeaponProjectiles_Heroic(0)= Class'Rx_Vehicle_Apache_Gun_Heroic'
	WeaponProjectiles_Heroic(1)= Class'Rx_Vehicle_Apache_Missile_Heroic'
 
	WeaponFireSounds_Heroic(0)=none
	WeaponFireSounds_Heroic(1)=SoundCue'RX_VH_Apache.Sounds.SC_Apache_Missile_Heroic'
	
/*	
	WeaponRange=4500.0

	WeaponFireTypes(0)=EWFT_InstantHit

	InstantHitDamage(0)=30
	
	HeadShotDamageMult=2.5

	InstantHitDamageTypes(0)=class'Rx_DmgType_Apache_Gun'

	InstantHitMomentum(0)=10000
	
	bInstantHit=true
	

	BeamTemplates[0]=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Apache'
	
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Stone',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone')
	
    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Dirt',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Stone',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Stone',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Metal',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Metal')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Glass',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Wood',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Wood')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Water',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Water',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Incendiary_Impact_Flesh',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Flesh')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibGround_Green',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibCrystal_Green',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibGround_Blue',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_TibCrystal_Blue',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Glass')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Mud',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Water')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_WhiteSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_YellowSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Grass',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_YellowSand',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Snow',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Dirt')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Incendiary_Snow',Sound=SoundCue'RX_WP_TacticalRifle.Sounds.Impact.SC_BulletImpact_Stone')
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
VetRankInfo(0) = (ROFModifier = (1.0, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0));
VetRankInfo(1) = (ROFModifier = (0.99, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.98, 0.98));
VetRankInfo(2) = (ROFModifier = (0.975, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95));

//Veterans
VetRankInfo(3) = (ROFModifier = (0.95, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (10, 2), ReloadSpeedmod = (0.9, 0.9));
VetRankInfo(4) = (ROFModifier = (0.94, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (10, 2), ReloadSpeedmod = (0.88, 0.88));
VetRankInfo(5) = (ROFModifier = (0.925, 1.0), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (10, 2), ReloadSpeedmod = (0.85, 0.85));

//ELITE
VetRankInfo(6) = (ROFModifier = (0.9, 0.9), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (25, 4), ReloadSpeedmod = (0.8, 0.8));
VetRankInfo(7) = (ROFModifier = (0.89, 0.9), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (25, 4), ReloadSpeedmod = (0.78, 0.78));
VetRankInfo(8) = (ROFModifier = (0.875, 0.9), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (25, 4), ReloadSpeedmod = (0.75, 0.75));

//HEROIC
VetRankInfo(9) = (ROFModifier = (0.85, 0.85), BuildingDamageMod = (1.0, 1.0), ClipSizeMod = (50, 6), ReloadSpeedmod = (0.70, 0.70));

/*-------------------------*/
/* End Veterancy		   */
/*-------------------------*/  

FM0_ROFTurnover = 6; //9 for most automatics. Single shot weapons should be more, except the shotgun
FM1_ROFTurnover = 4; 

    bOkAgainstLightVehicles = True
	bOkAgainstArmoredVehicles = True
	bOkAgainstBuildings = True
}
