class FA_MissionInfo_SecureArea extends FA_MissionInfo;

//Classes we need to spawn 
var class<TS_MissionArea> CaptureAreaClass;

/****************************************
*Generic Attack-type mission where we 	*
*spawn one vehicle to destroy.			*
*****************************************/
static function bool Initialize(TS_MissionManager TSMM, byte AttackingTeam) /*Note the CurrentAttackers/CurrentDefenders are not set yet when Initializing*/
{
	local array<Actor> SpawnedActors; 
	local Actor WorkingActor;
	local vector ThingSpawnLocation; 
	local rotator ThingSpawnRotation; 
	local TS_MissionArea SpawnedMissionArea;
	local bool 	bSuccess;
	local int	SetNum; 
	
	SetNum = TSMM.InitializeSetNum(default.MissionTagName, 'AreaSpawn', 255); //Set the set number up here for TS_MissionManager to hold 
	
	TSMM.FindWaypointLocandRot(default.MissionTagName, 'AreaSpawn', 255,ThingSpawnLocation, ThingSpawnRotation, SetNum);
	
	if(ThingSpawnLocation == vect(0,0,0))//Waypoint not found
	{
		`log("Waypoint not found");
		return false; 
	}
	
	/*Attempt to spawn our thing*/
	WorkingActor = TSMM.Spawn(default.CaptureAreaClass, TSMM,, ThingSpawnLocation, ThingSpawnRotation,, true); 
	
	if(WorkingActor != none)
	{
		SpawnedActors.AddItem(WorkingActor); //Add to spawned actors 
		
		SpawnedMissionArea = TS_MissionArea(WorkingActor); 
	}
	
	//Don't accept none, or anything that's the incorrect interface
	if(TSIfc_MissionObjective(WorkingActor) == none)
	{
		`log("Incorrect Interface, or Spawn failed"); 
		bSuccess = false;
	}
	else //Using correct interface; continue. 
	{
		TSMM.AddObjective(WorkingActor, Obj_CAPTURE, AttackingTeam);
		bSuccess = true; 
	}
	
	//Clean up actors if we failed 
	if(!bSuccess)
		ForEach SpawnedActors(WorkingActor){
			WorkingActor.Destroy(); 
		}
	else
	{
		TSMM.SetCustomObjective(0,AttackingTeam,default.MissionTagName, 'AreaSpawn');
		
		if(SpawnedMissionArea != none){
			SpawnedMissionArea.InitCapturePoint(TSMM.GetOppositeTeam(AttackingTeam), TSMM.GetObjectiveCustomName(0), true, 500.0);
		}
		
		TSMM.SetAttackers(AttackingTeam);
		TSMM.SetMissionTimer(default.MissionTime[0]); //Set Initial time either team has to capture the point 
	}
	
	return bSuccess;
}

/*Destruction of a mission area is.... basically impossible*/
static function ProcessTargetDestroyed(Actor Target, TS_MissionManager TSMM);

static function ProcessTargetPickedUp(Actor PickupActor, byte ByTeam, TS_MissionManager TSMM, optional Controller Holder); //Used by deployables when picked up, and vehicles when entered

//Timer expiration means Attackers win
static function ProcessTimerExpired(byte AttackingTeam, TS_MissionManager TSM)
{
	// This should never occur but if it does... catch it
	if (TSM.CurrentMissionPhase == 0) return;
	//Mission Only has one target
	TSM.ClearObjectives();
	TSM.SendClientMsg("SUCCESS: Area secured", "FAILURE: Area compromised!", 0);
	TSM.DoMissionComplete(M_AttackerWon); //Attackers won
}

static function ProcessTargetTouchObjective(Actor TouchingActor, Actor ObjectiveTarget, TS_MissionManager TSMM);

static function ProcessCaptureObjective(Actor CapturedActor, byte TeamByte, TS_MissionManager TSMM) /*0/1 called for capture. 255 called for neutralized*/
{
	if (TSMM.CurrentMissionPhase == 0 && TeamByte == TSMM.CurrentAttackers)
	{
		TSMM.SetPhase(1);
	}

	else if (TSMM.CurrentMissionPhase == 1 && TeamByte == TSMM.CurrentDefenders)
		TSMM.SetPhase(0);
}

static function bool InitPhase(int OldPhase, int NewPhase, TS_MissionManager TSMM) 
{
	if (NewPhase == 1)
	{
		TSMM.SetMissionTimer(default.MissionTime[1]);
		TSMM.SendClientMsg("UPDATE: Defend captured area!", "FAILURE: Re-capture area!", 0);
	}
	else if (NewPhase == 0)
	{
		TSMM.SendClientMsg("UPDATE: Capture area!", "UPDATE: Defend area!", 0);
	}
	return true; 
}

DefaultProperties
{
	MissionName = "Secure Area"
	MissionTagName = SecureArea
	MissionTime(0) = 180.0 //3 minutes
	MissionTime(1) = 60.0 //180.0 //180.0
	
	MissionObjectives(0) = (strAttackerObj = "Capture the area", strDefenderObj = "Defend the area")
	MissionObjectives(1) = (strAttackerObj = "Defend the area", strDefenderObj = "Re-Capture the area")
	
	CaptureAreaClass = class'TS_MissionArea'
	
	/**
	Necessary Waypoints:
	AreaSpawn

	*/
}