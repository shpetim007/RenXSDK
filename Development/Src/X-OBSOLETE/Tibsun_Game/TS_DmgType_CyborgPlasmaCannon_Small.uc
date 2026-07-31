class TS_DmgType_CyborgPlasmaCannon_Small extends TS_DmgType_Burn;

defaultproperties
{
    KillStatsName=KILLS_PLASMACANNON
    DeathStatsName=DEATHS_PLASMACANNON
    SuicideStatsName=SUICIDES_PLASMACANNON

    DamageWeaponFireMode=2
    NodeDamageScaling=0.5

    CustomTauntIndex=10

    VehicleDamageScaling=0.33333
    lightArmorDmgScaling=0.33333
    AircraftDamageScaling=0.33333
    BuildingDamageScaling=0.33333
    MCTDamageScaling=2.0
    MineDamageScaling=2.0

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.75
    Inf_KevlarDamageScaling = 0.875
    Inf_LazarusDamageScaling = 1.0
    Inf_NoArmourDamageScaling = 1.0

    //Destroyable obstacles
//    lightObstacleArmorScaling=2.0f
//    heavyObstacleArmorScaling=2.0f
    
    BleedDamageFactor=0.0167
    BleedCount=5

	IconTextureName="T_WeaponIcon_CyborgPlasmaCannon"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_CyborgPlasmaCannon'
}