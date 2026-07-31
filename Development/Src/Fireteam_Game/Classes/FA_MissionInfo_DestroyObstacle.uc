class FA_MissionInfo_DestroyObstacle extends FA_MissionInfo;

static function bool Initialize(TS_MissionManager TSMM, byte AttackingTeam)
{
	local array<Actor> WorkingActors;
	local bool bSuccess; 
	local FA_DestroyableObjective Objective;
	local FA_Zone Zone;
	local Actor AnActor;

	ForEach TSMM.WorldInfo.AllActors(class'FA_DestroyableObjective', Objective)
	{
		if (Objective.GetTeamNum() == AttackingTeam) continue;

		ForEach TSMM.WorldInfo.AllActors(class'FA_Zone', Zone)
			if (Zone.ZoneIndex == FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone() && Zone.EncompassesPoint(Objective.Location) && WorkingActors.Find(Objective) == INDEX_NONE)
				WorkingActors.AddItem(Objective);
	}

	//Don't accept none, or anything that's the incorrect interface
	if (TSIfc_MissionObjective(WorkingActors[0]) == None)
	{
		`log("Incorrect Interface, or Spawn failed"); 
		bSuccess = false;
	}
	else //Using correct interface; continue. 
	{
		ForEach WorkingActors(AnActor)
		{
			TSMM.AddObjective(AnActor, Obj_ATTACK, AttackingTeam);
		}

		bSuccess = true; 
	}

	if (!bSuccess)
		`log("Unable to find a building for" @ default.class @ `showvar(WorkingActors[0]));
	else
	{
		//TSMM.SetCustomObjective(0, AttackingTeam, default.MissionTagName, 'Building');
		TSMM.SetAttackers(AttackingTeam);
		TSMM.SetMissionTimer(default.MissionTime[0]); 
	}

	return bSuccess;
}

static function ProcessTargetDestroyed(Actor Target, TS_MissionManager TSM)
{
	TSM.SendClientMsg("SUCCESS: Building Destroyed", "FAILURE: Building Lost", 0);
	TSM.RemoveObjective(Target);

	if (TSM.CurrentMissionTargets.length == 0)
		TSM.DoMissionComplete(M_AttackerWon); //Attackers won
} 

DefaultProperties
{
	MissionName = "Destroy the Building"
	MissionObjectives(0) = (strAttackerObj = "Destroy the building", strDefenderObj = "Defend the building")
}