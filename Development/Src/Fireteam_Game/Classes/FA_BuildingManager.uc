class FA_BuildingManager extends TS_BuildingManager;

simulated function NotifyPowerChange(byte InTeam, bool NewPower)
{

}

simulated function bool TeamHasPower(byte InTeam)
{
	return true;
}