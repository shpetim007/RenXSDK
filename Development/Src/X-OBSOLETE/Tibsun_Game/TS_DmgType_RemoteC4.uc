class TS_DmgType_RemoteC4 extends Rx_DmgType_TimedC4;

DefaultProperties
{

////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 0.50     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 0.75 // 0.80	//Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
	Inf_LazarusDamageScaling = 1.0  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	Inf_NoArmourDamageScaling = 1.0 //Damage modifier for no armour

    VehicleDamageScaling=2.5
    lightArmorDmgScaling=2.5
    BuildingDamageScaling=1.0
	AircraftDamageScaling=2.5
    MCTDamageScaling=2.0
	MineDamageScaling=2.0
	
	IconTextureName="T_WeaponIcon_RemoteC4"
	IconTexture=Texture2D'RX_WP_RemoteC4.UI.T_WeaponIcon_RemoteC4'
	
}
