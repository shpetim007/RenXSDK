class FA_MissionInfo extends TS_MissionInfo;

var float DisarmReward[2];

static function RewardDisarm(byte DisarmingTeam, TS_MissionManager TSMM)
{
	local TS_Controller C; 
	
	ForEach TSMM.WorldInfo.AllControllers(class'TS_Controller', C)
	{

		if (C.GetTeamNum() == 255) continue;

		TS_PRI(C.PlayerReplicationInfo).AddCredits(C.GetTeamNum() == DisarmingTeam ? default.DisarmReward[0] : default.DisarmReward[1]);
	}
}

DefaultProperties
{
	bDrawDefenders = true

	// FA Rewards
	DisarmReward(0) = 0 //0-Disarmer 1-Disarmed
	DisarmReward(1) = 0 

	/*Standard Rewards*/
	VPReward(0) = 0 //0-Winner 1-Loser
	VPReward(1) = 0
	
	CredReward(0) = 0 //0-Winner 1-Loser
	CredReward(1) = 0
	
	UPReward(0) = 0 //0-Winner 1-Loser
	UPReward(1) = 0 //0-Winner 1-Loser
	
	SupplyReward(0) = 0
	SupplyReward(1) = 0
}