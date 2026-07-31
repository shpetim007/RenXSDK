class TS_DmgType_ParticleIonCannon extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_PARTICLEIONCNNON
    DeathStatsName=DEATHS_PARTICLEIONCNNON
    SuicideStatsName=SUICIDES_PARTICLEIONCNNON

    DamageWeaponFireMode=2
    NodeDamageScaling=0.5

    CustomTauntIndex=10

    VehicleDamageScaling=0.3
    lightArmorDmgScaling=0.3
    AircraftDamageScaling=0.3
    BuildingDamageScaling=0.3
    MCTDamageScaling=2.0
    MineDamageScaling=2.0

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.75
    Inf_KevlarDamageScaling = 0.875
    Inf_LazarusDamageScaling = 1.0
    Inf_NoArmourDamageScaling = 1.0
    
    
    BleedDamageFactor=0.2
    BleedCount=5
    
    KDamageImpulse=10
    KDeathUpKick=10

    IconTextureName="T_WeaponIcon_ParticleIonCannon"
    IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
}