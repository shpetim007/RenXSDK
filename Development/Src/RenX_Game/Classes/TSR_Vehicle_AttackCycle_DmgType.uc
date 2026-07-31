class TSR_Vehicle_AttackCycle_DmgType extends Rx_DmgType_Shell;

defaultproperties
{
    KillStatsName=KILLS_ATTACKCYCLE
    DeathStatsName=DEATHS_ATTACKCYCLE
    SuicideStatsName=SUICIDES_ATTACKCYCLE

    VehicleDamageScaling=0.48
	lightArmorDmgScaling=0.48
	AircraftDamageScaling=0.60
    BuildingDamageScaling=0.96f
	MineDamageScaling=2.0

	IconTextureName="T_DeathIcon_ReconBike"
	IconTexture=Texture2D'TS_VH_ReconBike.Materials.T_DeathIcon_ReconBike'
}