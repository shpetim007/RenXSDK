class TS_DmgType_ParticleIonCannon_Large extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_PARTICLEIONCANNON
    DeathStatsName=DEATHS_PARTICLEIONCANNON
    SuicideStatsName=SUICIDES_PARTICLEIONCANNON

//    DamageWeaponClass=class'Rx_Weapon_PersonalIonCannon'
    DamageWeaponFireMode=2
    VehicleDamageScaling=0.8
    NodeDamageScaling=0.5

    CustomTauntIndex=10
    lightArmorDmgScaling=1.0
    BuildingDamageScaling=2.0
	MCTDamageScaling=2.0
	MineDamageScaling=2.0
	
	BleedDamageFactor=0.01
	BleedCount=8
	
	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.0
	Inf_KevlarDamageScaling = 1.0
	Inf_LazarusDamageScaling = 1.0
	Inf_NoArmourDamageScaling = 1.0
	
	KDamageImpulse=20000
	KDeathUpKick=100

	IconTextureName="T_WeaponIcon_ParticleIonCannon"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
}