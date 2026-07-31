class TS_DmgType_CyborgVulcanCannon extends TS_DmgType_Bullet;

defaultproperties
{
    KillStatsName=KILLS_CYBORGVULCANCANNON
    DeathStatsName=DEATHS_CYBORGVULCANCANNON
    SuicideStatsName=SUICIDES_CYBORGVULCANCANNON

//  DamageWeaponClass=class'Rx_Weapon_LaserRifle'
    DamageWeaponFireMode=2
    NodeDamageScaling=0.5
	
    CustomTauntIndex=10

    VehicleDamageScaling=0.15
    lightArmorDmgScaling=0.4
    AircraftDamageScaling=0.4
    BuildingDamageScaling=0.2
    MCTDamageScaling=2.0
    MineDamageScaling=2.0
    
    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.75 //0.95     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
    Inf_KevlarDamageScaling = 0.875 //0.95  //Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% -Remotes OP 
    Inf_LazarusDamageScaling = 1.0 //0.95  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
    Inf_NoArmourDamageScaling = 1.0


	IconTextureName="T_WeaponIcon_CyborgVulcan"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_CyborgVulcan'
}