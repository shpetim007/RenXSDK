class APB_Vehicle_TeslaTank_Weapon extends Rx_Vehicle_Weapon_Reloadable;


DefaultProperties
{
    
    InventoryGroup=13
    
    // reload config
    ClipSize = 3
    InitalNumClips = 999
    MaxClips = 999
     
    ShotCost(0)=1
    ShotCost(1)=1
     
    ReloadTime(0) = 3.5
    ReloadTime(1) = 3.5
     
    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"
     
    ReloadSound(0)=SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Charge'
    ReloadSound(1)=SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Charge'
	
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256
     
    // gun config
    FireTriggerTags(0)="MainGun"
    AltFireTriggerTags(0)="MainGun"
    VehicleClass=Class'APB_Vehicle_TeslaTank'

    FireInterval(0)=0.15
    FireInterval(1)=0.15
    bFastRepeater=true

    Spread(0)=0.02
    Spread(1)=0.02
	
	RecoilImpulse = -0.01f
  
    WeaponFireSnd(0)    	= SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Attack'
    WeaponFireSnd(1)     	= SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Attack'
	WeaponFireSounds_Heroic(0) = SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Attack_Heroic'
	WeaponFireSounds_Heroic(1) = SoundCue'APB_VH_SOV_TeslaTank.APB_Tesla_Attack_Heroic' 

    bRecommendSplashDamage=true

	InstantHitDamageRadius[0] = 80;
	InstantHitDamageRadius[1] = 80;

	InstantHitDamageRadiusDoFull[0] = false;
	InstantHitDamageRadiusDoFull[1] = false;

	InstantHitDamageRadiusIgnoreTeam[0] = false;
	InstantHitDamageRadiusIgnoreTeam[1] = false;
	
	WeaponRange=4500.0

	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_None

	InstantHitDamage(0)=65
	InstantHitDamage(1)=65
	
	HeadShotDamageMult=1

	InstantHitDamageTypes(0)=class'Rx_DmgType_TeslaTank'
	InstantHitDamageTypes(1)=class'Rx_DmgType_TeslaTank'

	InstantHitMomentum(0)=10000
	InstantHitMomentum(1)=10000
	
	bInstantHit=true
	
	BeamTemplates[0]=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Lightning'
	
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	
	ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')

	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (DamageModifier = (1.0,1.0), ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (DamageModifier = (1.025,1.025), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.99, 0.99))
	VetRankInfo(2)= (DamageModifier = (1.05,1.05), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.97, 0.97))

	//Veterans
	VetRankInfo(3)= (DamageModifier = (1.07692308,1.07692308), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (DamageModifier = (1.1,1.1), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.94, 0.94))
	VetRankInfo(5)= (DamageModifier = (1.15,1.15), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.92, 0.92))

	//ELITE
	VetRankInfo(6)= (DamageModifier = (1.25 ,1.25 ), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.9, 0.9))
	VetRankInfo(7)= (DamageModifier = (1.35,1.35), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.89, 0.89))
	VetRankInfo(8)= (DamageModifier = (1.45,1.45), ROFModifier = (1.0,1.0) ,ClipSizeMod = (0, 0), ReloadSpeedmod = (0.87, 0.87))

	//HEROIC
	VetRankInfo(9)= (DamageModifier = (1.50,1.50), ROFModifier = (1.0,1.0) ,ClipSizeMod = (1, 1), ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

}
