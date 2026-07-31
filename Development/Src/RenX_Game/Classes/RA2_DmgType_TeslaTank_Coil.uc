class RA2_DmgType_TeslaTank_Coil extends Rx_DmgType_VoltRifle_Alt;

DefaultProperties
{

	VehicleDamageScaling=0.45 //0.2857142857 //0.4
	lightArmorDmgScaling=0.45 //0.2857142857 //0.4
    AircraftDamageScaling= 0.45 //0.4285714286 //0.6 //Low flying aircraft be damned. 
    BuildingDamageScaling= 1.0 //0.2857142857 //0.4
    MCTDamageScaling=3.0
    MineDamageScaling=1.0

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.6  //1.0     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
    Inf_KevlarDamageScaling = 0.6 //1.0    //Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% - EDIT2 : Applied penalty to Kevlar infantry against splash damage, now that there's a NONE armour category
    Inf_LazarusDamageScaling = 0.6 //1.0  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
    Inf_NoArmourDamageScaling = 0.6 //Damage modifier for no armour

	IconTextureName="T_VehicleIcon_TeslaTank"
	IconTexture=Texture2D'RA2_VH_TeslaTank.Textures.T_DeathIcon_TeslaTank'

}
