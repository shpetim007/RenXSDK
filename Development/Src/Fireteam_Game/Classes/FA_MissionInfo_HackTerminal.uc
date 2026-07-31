class FA_MissionInfo_HackTerminal extends FA_MissionInfo;

static function bool Initialize(TS_MissionManager TSMM, byte AttackingTeam) /*Note the CurrentAttackers/CurrentDefenders are not set yet when Initializing*/
{
	local FA_TerminalObjective Terminal;
	local FA_Zone Zone;
	local bool bSuccess;
	local Actor WorkingActor;

	ForEach TSMM.WorldInfo.AllActors(class'FA_TerminalObjective', Terminal)
	{
		if (Terminal.bBeenUsed) continue;

		ForEach TSMM.WorldInfo.AllActors(class'FA_Zone', Zone)
		{
			if (Zone.ZoneIndex == FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone() && Zone.EncompassesPoint(Terminal.Location))
			{
				WorkingActor = Terminal;
				break;
			}
		}

		if (WorkingActor != None)
			break;
	}
	
	// No terminal found
	if (TSIfc_MissionObjective(WorkingActor) == none)
	{
		`log("Can not find a working actor for"@default.Class@"zone"@FA_GRI(TSMM.WorldInfo.GRI).GetCurrentZone()); 
		bSuccess = false;
	}
	else // Found terminal
	{
		`log("Setting"@WorkingActor@"as objective");
		TSMM.AddObjective(WorkingActor, Obj_CAPTURE, AttackingTeam);
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
	if (TSMM.CurrentMissionPhase == 0 && ByTeam == TSMM.CurrentAttackers)
	{
		TSMM.UpdateObjective(PickupActor, Obj_SECURE, 0); // Change to secure/defend this
		TSMM.SetPhase(1); 
	}

	if (TSMM.CurrentMissionPhase == 1 && ByTeam == TSMM.CurrentDefenders)
	{
		TSMM.SetPhase(0);
		TSMM.UpdateObjective(PickupActor, Obj_CAPTURE, 1); // Change to secure/defend this
		static.RewardDisarm(ByTeam, TSMM);
	}
}

//Timer expiration means Attackers win
static function ProcessTimerExpired(byte AttackingTeam, TS_MissionManager TSM)
{
	// This should never occur but if it does... catch it
	if (TSM.CurrentMissionPhase == 0) return;
	//Mission Only has one target
	TSM.ClearObjectives();
	TSM.SendClientMsg("SUCCESS: Terminal secured", "FAILURE: Terminal compromised!", 0);
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
		TSMM.SendClientMsg("UPDATE: Defend hacked terminal!", "FAILURE: Re-capture terminal!", 0);
		return true; 
	}
	
	return bSuccess == 1;
}

DefaultProperties
{
	MissionName = "Terminal Hack"
	MissionTagName = "Hack"
	
	MissionObjectives(0) = (strAttackerObj = "Hack the Terminal", strDefenderObj = "Defend the Terminal")
	MissionObjectives(1) = (strAttackerObj = "Defend the Terminal", strDefenderObj = "Re-Secure the Terminal")

	// FA Rewards
	DisarmReward(0) = 100 //0-Disarmer 1-Disarmed
	DisarmReward(1) = 0 
}