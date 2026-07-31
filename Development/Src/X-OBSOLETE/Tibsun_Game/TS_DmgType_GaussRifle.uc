class TS_DmgType_GaussRifle extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_RAILGUN
    DeathStatsName=DEATHS_RAILGUN
    SuicideStatsName=SUICIDES_RAILGUN

//    DamageWeaponClass=class'Rx_Weapon_LaserRifle'
    DamageWeaponFireMode=2
    NodeDamageScaling=0.5

    CustomTauntIndex=10

    VehicleDamageScaling=0.25
    lightArmorDmgScaling=0.5
    AircraftDamageScaling=0.5
    BuildingDamageScaling=0.1
    MCTDamageScaling=2.0
    MineDamageScaling=2.0

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.75
    Inf_KevlarDamageScaling = 0.875
    Inf_LazarusDamageScaling = 1.0
    Inf_NoArmourDamageScaling = 1.0

    //Destroyable obstacles
//  lightObstacleArmorScaling=2.0f
//  heavyObstacleArmorScaling=2.0f
    
    BleedDamageFactor=0.025
    BleedCount=5
    
    KDamageImpulse=20000
    KDeathUpKick=100

    IconTextureName="T_WeaponIcon_GaussRifle"
    IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_GaussRifle'
}