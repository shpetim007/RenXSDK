class Rx_DmgType_Coreshot extends Rx_DmgType
	abstract;

DefaultProperties
{
	KillStatsName=KILLS_CORESHOT
	DeathStatsName=DEATHS_CORESHOT
	SuicideStatsName=SUICIDES_CORESHOT
	DamageWeaponFireMode=0
	bSeversHead=false
	bHeadGibCamera=false
	bNeverGibs=true
	VehicleDamageScaling=0.4
	NodeDamageScaling=0.4
	CustomTauntIndex=3
	bCausesBloodSplatterDecals=false
	
	DeathAnim=H_M_Death_Headshot//Probably replace this
	
	KDamageImpulse=100
	KDeathUpKick=50
}