class FA_Weapon_Beacon extends Rx_Weapon_Beacon;

simulated function bool IsValidPosition() 
{
	local FA_MissionArea_DeployBeacon DB;

	if (!super.IsValidPosition()) return false;

	ForEach Owner.TouchingActors(class'FA_MissionArea_DeployBeacon', DB)
		return true;

	return false;
}