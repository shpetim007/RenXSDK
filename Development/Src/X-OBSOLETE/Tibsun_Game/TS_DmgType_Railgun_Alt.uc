class TS_DmgType_Railgun_Alt extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_RAILGUN
    DeathStatsName=DEATHS_RAILGUN
    SuicideStatsName=SUICIDES_RAILGUN

//    DamageWeaponClass=class'Rx_Weapon_LaserRifle'
    DamageWeaponFireMode=2
    VehicleDamageScaling=0.2
    NodeDamageScaling=0.5
 
    CustomTauntIndex=10
    lightArmorDmgScaling=0.2
    BuildingDamageScaling=0.2
	MCTDamageScaling=1.0
	MineDamageScaling=2.0

	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.0 //0.95     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.0 //0.95	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
	Inf_LazarusDamageScaling = 1.25 //0.95  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	
	BleedDamageFactor=0.01
	BleedCount=2
	
	KDamageImpulse=20000
	KDeathUpKick=100

	IconTextureName="T_WeaponIcon_Railgun"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_Railgun'
}