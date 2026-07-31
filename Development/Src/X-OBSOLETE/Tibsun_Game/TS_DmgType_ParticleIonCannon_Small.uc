class TS_DmgType_ParticleIonCannon_Small extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_PARTICLEIONCANNON
    DeathStatsName=DEATHS_PARTICLEIONCANNON
    SuicideStatsName=SUICIDES_PARTICLEIONCANNON

//    DamageWeaponClass=class'Rx_Weapon_PersonalIonCannon'
    DamageWeaponFireMode=2
    VehicleDamageScaling=0.1
    NodeDamageScaling=0.5

    CustomTauntIndex=10
    lightArmorDmgScaling=0.2
    BuildingDamageScaling=0.05
	MCTDamageScaling=2.0
	MineDamageScaling=2.0
	
	BleedDamageFactor=0.01
	BleedCount=8
	
	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 0.75 //0.95     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 0.875 //0.95	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
	Inf_LazarusDamageScaling = 1.0 //0.95  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	Inf_NoArmourDamageScaling = 1.0
	
	KDamageImpulse=20000
	KDeathUpKick=100

	IconTextureName="T_WeaponIcon_ParticleIonCannon"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
}