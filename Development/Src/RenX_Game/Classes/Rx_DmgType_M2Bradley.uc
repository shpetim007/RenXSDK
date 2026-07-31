class Rx_DmgType_M2Bradley extends Rx_DmgType_Shell;

defaultproperties
{
    KillStatsName=KILLS_M2BRADLEY
    DeathStatsName=DEATHS_M2BRADLEY
    SuicideStatsName=SUICIDES_M2BRADLEY

    VehicleDamageScaling=0.5 //0.75
	lightArmorDmgScaling=0.85
    BuildingDamageScaling=1.1f

    ////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.0     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.0	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20%
	Inf_LazarusDamageScaling = 1.0  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	Inf_NoArmourDamageScaling = 1.0 //Damage modifier for no armour

	IconTextureName="T_DeathIcon_LightTank"
	IconTexture=Texture2D'RX_VH_M2Bradley.UI.T_DeathIcon_M2Bradley'

}