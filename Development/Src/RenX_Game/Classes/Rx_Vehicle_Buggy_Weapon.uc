/*********************************************************
*
* File: RxVehicle_Buggy_Weapon.uc
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
class Rx_Vehicle_Buggy_Weapon extends Rx_Vehicle_Weapon_Reloadable;

DefaultProperties
{
    InventoryGroup=4
    
    // reload config
    ClipSize = 100
    InitalNumClips = 999
    MaxClips = 999

    ShotCost(0)=1
    ShotCost(1)=1

    ReloadTime(0) = 2.0
    ReloadTime(1) = 2.0

    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"

    ReloadSound(0)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
    ReloadSound(1)=SoundCue'RX_VH_Apache.Sounds.SC_Reload_Gun'
	
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256
	
    // gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'RenX_Game.Rx_Vehicle_Buggy'

    FireInterval(0)=0.11
    FireInterval(1)=0.11
    bFastRepeater=true
 
    Spread(0)=0.0075
    Spread(1)=0.0075
	
	RecoilImpulse = -0.01f
	
	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (DamageModifier = (1.0, 1.0), ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (DamageModifier = (1.025, 1.025), ROFModifier = (0.99,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.98, 0.98))
	VetRankInfo(2)= (DamageModifier = (1.05, 1.05), ROFModifier = (0.975,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))


	//Veterans
	VetRankInfo(3)= (DamageModifier = (1.10, 1.10), ROFModifier = (0.95,1.0), ClipSizeMod = (25, 0), ReloadSpeedmod = (0.90, 0.90))
	VetRankInfo(4)= (DamageModifier = (1.125, 1.125), ROFModifier = (0.94,1.0), ClipSizeMod = (25, 0), ReloadSpeedmod = (0.88, 0.88))
	VetRankInfo(5)= (DamageModifier = (1.15, 1.15), ROFModifier = (0.925,1.0), ClipSizeMod = (25, 0), ReloadSpeedmod = (0.85, 0.85))

	//ELITE
	VetRankInfo(6)= (DamageModifier = (1.25, 1.25), ROFModifier = (0.90,1.0), ClipSizeMod = (50, 0), ReloadSpeedmod = (0.80, 0.80))
	VetRankInfo(7)= (DamageModifier = (1.30, 1.30), ROFModifier = (0.89,1.0), ClipSizeMod = (50, 0), ReloadSpeedmod = (0.78, 0.78))
	VetRankInfo(8)= (DamageModifier = (1.35, 1.35), ROFModifier = (0.875,1.0), ClipSizeMod = (50, 0), ReloadSpeedmod = (0.75, 0.75))

	//HEROIC
	VetRankInfo(9)= (DamageModifier = (1.50, 1.50), ROFModifier = (0.85,1.0),ClipSizeMod = (100, 0), ReloadSpeedmod = (0.70, 0.70))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

    WeaponFireSnd(0)     = none //SoundCue'RX_VH_Buggy.Sounds.SC_Buggy_Fire'
//    WeaponFireTypes(0)   = EWFT_Projectile
//    WeaponProjectiles(0) = Class'Rx_Vehicle_Buggy_Projectile'
    WeaponFireSnd(1)     = none //SoundCue'RX_VH_Buggy.Sounds.SC_Buggy_Fire'
//    WeaponFireTypes(1)   = EWFT_Projectile
//    WeaponProjectiles(1) = Class'Rx_Vehicle_Buggy_Projectile'
    // AI
    bRecommendSplashDamage=False
	
	
	WeaponRange=7000.0 //6000.0

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_None

	InstantHitDamage(0)=16
	InstantHitDamage(1)=16
	
	HeadShotDamageMult=2.5

	InstantHitDamageTypes(0)=class'Rx_DmgType_Buggy'
	InstantHitDamageTypes(1)=class'Rx_DmgType_Buggy'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
	bInstantHit=true

	BeamTemplates[0]=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Large'
	BeamTemplates_Heroic[0]= ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Large_Heroic'
	
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	
	ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Dirt_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Stone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Metal_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Metal')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Glass_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Wood_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Wood')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Water')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Water',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Water')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_FX_Munitions.Impact_Bullet.P_Bullet_Impact_Flesh',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Flesh')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumGround_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumCrystal_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumGround_Blue_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_TiberiumCrystal_Blue_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Glass')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Mud_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Mud')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_WhiteSand_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_YellowSand_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Dirt')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Grass_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Grass')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_YellowStone_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Snow_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Snow')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_FX_Munitions2.Particles.bullets.P_Bullet_Impact_Snow_Heavy',Sound=SoundCue'RX_SoundEffects.Bullet_Impact.SC_BulletImpact_Stone')

}
