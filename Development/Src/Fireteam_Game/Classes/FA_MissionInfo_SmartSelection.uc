class FA_MissionInfo_SmartSelection extends FA_MissionInfo;

static function bool Initialize(TS_MissionManager TSMM, byte AttackingTeam) /*Note the CurrentAttackers/CurrentDefenders are not set yet when Initializing*/
{
	local FA_Zone Zone;
	local bool bSuccess;
	local Actor Actor;
	local array<Actor> ObjectiveActors;
	local array<FA_Zone> Zones;

	ForEach TSMM.WorldInfo.AllActors(class'FA_Zone', Zone)
		if (Zone.ZoneIndex == FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone())
			Zones.AddItem(Zone);

	ForEach TSMM.WorldInfo.AllActors(class'Actor', Actor, class'TSIfc_MissionObjective')
	{
		if (TS_Vehicle(Actor) != None || TS_Pawn(Actor) != None || (TS_Defence(Actor) != None && !TS_Defence(Actor).bEnableAsObjective)) continue;

		ForEach Zones(Zone)
		{
			if (TS_Building_Team_Internals(Actor) != None && !Zone.EncompassesPoint(TS_Building_Team_Internals(Actor).BuildingVisuals.Location))
				continue;

			else if (FA_TerminalObjective(Actor) != None && (FA_TerminalObjective(Actor).bBeenUsed || !Zone.EncompassesPoint(Actor.Location)))
				continue;

			else if (!Zone.EncompassesPoint(Actor.Location))
				continue;

			ObjectiveActors.AddItem(Actor);
		}
	}
	
	// Nothing found
	if (ObjectiveActors.length == 0)
	{
		`log("Can not find a working actor for"@default.Class@"zone"@FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone()); 
		bSuccess = false;
	}
	else // Found something
	{
		ForEach ObjectiveActors(Actor)
		{
			TSMM.AddObjective(Actor, Obj_ATTACK, AttackingTeam);
		}
		bSuccess = true; 
	}
	
	//Clean up actors if we failed 
	if (!bSuccess)
	{
		`log("Failed to start"@default.Class);	
	}
	else
	{
		//TSMM.SetCustomObjective(0, AttackingTeam, default.MissionTagName, 'Terminal');
		TSMM.SetAttackers(AttackingTeam);
		TSMM.SetMissionTimer(default.MissionTime[0]);
	}
	
	return bSuccess;
}

static function ProcessTargetPickedUp(Actor PickupActor, byte ByTeam, TS_MissionManager TSMM, optional Controller Holder) //Used by deployables when picked up, and vehicles when entered
{
	if (ByTeam == TSMM.CurrentAttackers)
	{
		TSMM.UpdateObjective(PickupActor, Obj_SECURE, 0); // Change to secure/defend this 
		TSMM.SendClientMsg("UPDATE: Defend hacked terminal!", "UPDATE: Re-capture terminal!", 0);
	}

	if (ByTeam == TSMM.CurrentDefenders)
	{
		static.RewardDisarm(ByTeam, TSMM);
		TSMM.UpdateObjective(PickupActor, Obj_CAPTURE, 1); // Change to secure/defend this
	}
}

static function ProcessTargetDestroyed(Actor Target, TS_MissionManager TSM)
{
	TSM.SendClientMsg("UPDATE:"@Target.GetHumanReadableName()@"Destroyed", "UPDATE:"@Target.GetHumanReadableName()@"Lost", 0);
	TSM.RemoveObjective(Target);

	if (TSM.CurrentMissionTargets.length == 0)
		TSM.DoMissionComplete(M_AttackerWon); //Attackers won
} 

static function bool InitPhase(int OldPhase, int NewPhase, TS_MissionManager TSMM)
{
	local byte 	bSuccess; 
	
	bSuccess = 1;
	
	if(NewPhase == 1) //This mission doesn't backtrack phases
	{
		TSMM.SetMissionTimer(FA_TerminalObjective(TSMM.CurrentMissionTargets[0]).HackCaptureTime);
		TSMM.StoreMissionTime(); //Both teams will have the same time to complete securing the objective
		TSMM.SendClientMsg("UPDATE: Defend hacked terminal!", "UPDATE: Re-capture terminal!", 0);
		return true; 
	}
	
	return bSuccess == 1;
}

DefaultProperties
{
	MissionName = "Auto Select"
	
	MissionObjectives(0) = (strAttackerObj = "Finish all objectives", strDefenderObj = "Defend all objectives")

	// FA Rewards
	DisarmReward(0) = 100 //0-Disarmer 1-Disarmed
	DisarmReward(1) = 0 
}