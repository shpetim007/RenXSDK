class Rx_DmgType_HumveeTOW extends Rx_DmgType_Shell;

defaultproperties
{
    KillStatsName=KILLS_TOWHUMVEE
    DeathStatsName=DEATHS_TOWHUMVEE
    SuicideStatsName=SUICIDES_TOWHUMVEE

    VehicleDamageScaling=0.88 //1.0
	lightArmorDmgScaling=1.0
	AircraftDamageScaling=1.0
    BuildingDamageScaling=0.96f
	MineDamageScaling=2.0

	IconTextureName="T_DeathIcon_TOWHumvee"
	IconTexture=Texture2D'RX_VH_Humvee.UI.T_DeathIcon_Humvee'
}