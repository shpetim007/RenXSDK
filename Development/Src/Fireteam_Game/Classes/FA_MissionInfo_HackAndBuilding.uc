class FA_MissionInfo_HackAndBuilding extends FA_MissionInfo;

static function bool Initialize(TS_MissionManager TSMM, byte AttackingTeam) /*Note the CurrentAttackers/CurrentDefenders are not set yet when Initializing*/
{
	local FA_TerminalObjective Terminal;
	local FA_Zone Zone;
	local bool bSuccess;
	local Actor TerminalActor, BuildingActor;
	local TS_Building_Team_Internals Internals;

	ForEach TSMM.WorldInfo.AllActors(class'FA_TerminalObjective', Terminal)
	{
		if (Terminal.bBeenUsed) continue;

		ForEach TSMM.WorldInfo.AllActors(class'FA_Zone', Zone)
		{
			if (Zone.ZoneIndex == FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone() && Zone.EncompassesPoint(Terminal.Location))
			{
				TerminalActor = Terminal;
				break;
			}
		}

		if (TerminalActor != None)
			break;
	}

	ForEach TSMM.WorldInfo.AllActors(class'TS_Building_Team_Internals', Internals)
	{
		ForEach TSMM.WorldInfo.AllActors(class'FA_Zone', Zone)
		{
			if (Zone.ZoneIndex == FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone() && Zone.EncompassesPoint(Internals.BuildingVisuals.Location))
			{
				BuildingActor = Internals;
				break;
			}
		}

		if (BuildingActor != None)
			break;
	}
	
	// No terminal found
	if (TSIfc_MissionObjective(TerminalActor) == none || TSIfc_MissionObjective(BuildingActor) == none)
	{
		`log("Can not find a working actor for"@default.Class@"zone"@FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone()); 
		bSuccess = false;
	}
	else // Found terminal & building
	{
		TSMM.AddObjective(TerminalActor, Obj_CAPTURE, AttackingTeam);
		TSMM.AddObjective(BuildingActor, Obj_ATTACK, AttackingTeam);
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
		TS_Building_Team_Internals(BuildingActor).HealthLocked = false;
		TSMM.SetMissionTimer(default.MissionTime[0]);
	}
	
	return bSuccess;
}

static function ProcessTargetPickedUp(Actor PickupActor, byte ByTeam, TS_MissionManager TSMM, optional Controller Holder) //Used by deployables when picked up, and vehicles when entered
{
	if (TSMM.CurrentMissionPhase == 0 && ByTeam == TSMM.CurrentAttackers)
	{
		TSMM.UpdateObjective(PickupActor, Obj_SECURE, 0); // Change to secure/defend this
		TSMM.SetPhase(1); 
	}

	if (TSMM.CurrentMissionPhase == 1 && ByTeam == TSMM.CurrentDefenders)
	{
		TSMM.SetPhase(0);
		static.RewardDisarm(ByTeam, TSMM);
		TSMM.UpdateObjective(PickupActor, Obj_CAPTURE, 1); // Change to secure/defend this
	}
}

//Timer expiration means Attackers win
static function ProcessTimerExpired(byte AttackingTeam, TS_MissionManager TSM)
{
	local Actor Objective;

	// This should never occur but if it does... catch it
	if (TSM.CurrentMissionPhase == 0) return;

	TSM.SendClientMsg("SUCCESS: Terminal secured", "FAILURE: Terminal compromised!", 0);

	ForEach TSM.CurrentMissionTargets(Objective)
	{
		if (FA_TerminalObjective(Objective) != None)
			TSM.RemoveObjective(Objective);
	}

	if (TSM.CurrentMissionTargets.length == 0)
		TSM.DoMissionComplete(M_AttackerWon); //Attackers won
}

static function ProcessTargetDestroyed(Actor Target, TS_MissionManager TSM)
{
	TSM.SendClientMsg("SUCCESS: Building Destroyed", "FAILURE: Building Lost", 0);
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
		`log("Setting mission timer to"@FA_TerminalObjective(TSMM.CurrentMissionTargets[0]).HackCaptureTime);
		TSMM.SetMissionTimer(FA_TerminalObjective(TSMM.CurrentMissionTargets[0]).HackCaptureTime);
		TSMM.StoreMissionTime(); //Both teams will have the same time to complete securing the objective
		TSMM.SendClientMsg("UPDATE: Defend hacked terminal!", "UPDATE: Re-capture terminal!", 0);
		return true; 
	}
	
	return bSuccess == 1;
}

DefaultProperties
{
	MissionName = "Kill Building and Hack"
	
	MissionObjectives(0) = (strAttackerObj = "Hack the Terminal", strDefenderObj = "Defend the Terminal")
	MissionObjectives(1) = (strAttackerObj = "Defend the Terminal", strDefenderObj = "Re-Secure the Terminal")

	// FA Rewards
	DisarmReward(0) = 100 //0-Disarmer 1-Disarmed
	DisarmReward(1) = 0 
}