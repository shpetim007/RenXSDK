class TS_DmgType_PulseRiflePulse extends TS_DmgType_Burn;

defaultproperties
{
    KillStatsName=KILLS_PULSERIFLECANNON
    DeathStatsName=DEATHS_PULSERIFLECANNON
    SuicideStatsName=SUICIDES_PULSERIFLECANNON

//    DamageWeaponClass=class'Rx_Weapon_LaserRifle'
    DamageWeaponFireMode=2
    VehicleDamageScaling=1.0
    NodeDamageScaling=0.5
 
    CustomTauntIndex=10
    lightArmorDmgScaling=1.0
    BuildingDamageScaling=2.0
	MCTDamageScaling=5.0
	MineDamageScaling=2.0

	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.0 //0.95     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.0 //0.95	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
	Inf_LazarusDamageScaling = 1.0 //0.95  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	Inf_NoArmourDamageScaling = 1.0
	
	BleedDamageFactor=0.01
	BleedCount=8
	
	KDamageImpulse=5000000000//20000
	KDeathUpKick=50

	IconTextureName="T_WeaponIcon_PulseRifle"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PulseRifle'
}