class TS_DmgType_ParticleCannon extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_PARTICLECANNON
    DeathStatsName=DEATHS_PARTICLECANNON
    SuicideStatsName=SUICIDES_PARTICLECANNON

    DamageWeaponFireMode=2
    NodeDamageScaling=0.5
    CustomTauntIndex=10

    VehicleDamageScaling=0.133333
    lightArmorDmgScaling=0.166667
	AircraftDamageScaling=0.166667
    BuildingDamageScaling=0.1
	MCTDamageScaling=0.2
	MineDamageScaling=2.0
	
	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 0.75
	Inf_KevlarDamageScaling = 0.875
	Inf_LazarusDamageScaling = 1.0
	Inf_NoArmourDamageScaling = 1.0
	
	bCausesBleed=false

	IconTextureName="T_WeaponIcon_ParticleCannon"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_PortableIonCannon'
}