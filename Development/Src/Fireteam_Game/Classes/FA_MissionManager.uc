class FA_MissionManager extends TS_MissionManager;

struct AnnounceCooldown
{
	var string TypeName;
	var float NextPlayTime;
};

var int MissionsNeededToProgress;
var class<FA_Announcer> AnnouncerClass;
var array<AnnounceCooldown> AnnouncementCooldowns_GDI, AnnouncementCooldowns_Nod;

simulated function PostBeginPlay()
{
	super.PostBeginPlay(); 
	
	if (WorldInfo.NetMode != NM_Client)
	{
		//SetTimer(15, false, 'InitializeMissions');
		MissionsNeededToProgress = FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[FA_GRI(WorldInfo.GRI).GetCurrentZone()].MissionsNeededToProgress;
	}
}

function InitializeMissions()
{
	TryMission();
}

function TryMission()
{
	local byte AttackerTeam; 
	local class<TS_MissionInfo> SelectedMission;
	
	if (CurrentMissionClass != none)
		return; 
	
	SelectedMission = SelectMission(AttackerTeam); //rand(PotentialMissions.Length) ;
	
	if (SelectedMission != none && BeginCombatMission(SelectedMission, AttackerTeam) )
	{
		CurrentMissionClass = SelectedMission; //default.PotentialMissions[iTry];
		UpdateObjectiveText();
		TS_Game(WorldInfo.Game).CTextBroadcast(255, "New Mission Directive", 'LightGreen', 90.0);
		SetTimer(1.5,false,'PlayMissionStartSnd');
		`log("Mission Started" @ "Set:" $ MissionSet @ "AttackingTeam:" $ AttackerTeam); //Do Nothing 
	}
	else
	{
		`log("Mission Failed to start"); 
		MissionSet = 0; 
		SetTimer(10.0,false,'TryMission');
	}
		
}

function RemoveCurrentMission()
{
	CurrentMissionClass = none; 
	SetTimer(2, false, 'TryMission');
}

function class<TS_MissionInfo> SelectMission(out byte oMissionAttackers)
{
	oMissionAttackers = FA_GRI(WorldInfo.GRI).GetAttackingTeam().TeamIndex;
	return FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[FA_GRI(WorldInfo.GRI).GetCurrentZone()].MissionClass;
}

simulated function UpdateMissionTimer()
{
	if (CurrentMissionPhase == 1)
		super.UpdateMissionTimer();
}

event NotifyZoneCaptured(byte PreviousZoneIndex, byte CurrentZoneIndex)
{

}

/*TODO: Add CompletedObjective to check what should happen on notifies then determine if the mission is over or not*/
function DoMissionComplete(CompletionStatus Status)
{
	`log("Mission Completed:" @ "Winners:" @ CurrentAttackers @ Status); 
	
	if(Status == M_AttackerWon)
	{
		`log("Attackers Won!");
		BroadcastLocalizedTeamMessage(CurrentAttackers,MessageClass,0,,,self);/*Play Objective Succeeded sound for Attackers*/	
		BroadcastLocalizedTeamMessage(CurrentDefenders,MessageClass,1,,,self); /*Play Objective Failed sound for Defenders*/
		CurrentMissionClass.static.RewardWinners(CurrentAttackers, self); 
	}
	else if(Status == M_DefenderWon){
		`log("DEFENDERS WON!!");
		BroadcastLocalizedTeamMessage(CurrentAttackers,MessageClass,1,,,self); /*Play Objective Failed sound for Attackers*/
		BroadcastLocalizedTeamMessage(CurrentDefenders,MessageClass,0,,,self); /*Play Objective Succeeded sound for Defenders*/
		CurrentMissionClass.static.RewardWinners(CurrentDefenders, self); 
	}
	else {
		`log("EVERYONES A FAILURE!!!");
		BroadcastLocalizedTeamMessage(CurrentAttackers,MessageClass,1,,,self); /*Play Objective Failed sound for Attackers*/
		BroadcastLocalizedTeamMessage(CurrentDefenders,MessageClass,1,,,self); /*Play Objective Failed sound for Defenders*/
	}
	
	/*Clean up everything except the Current Mission Class*/
	SetAttackers(255);
	CurrentMissionPhase = 0; 
	HighestMissionPhase = 0;
	ClearTimer('UpdateMissionTimer');
	SetMissionTimer(0);
	StoredMissionTime = 0; 
	MissionSet = 0; 
	MissionsCompleted++;

	CheckMoveZone(); 

	if (FA_TerminalObjective(CurrentMissionTargets[0]) != None)
		FA_TerminalObjective(CurrentMissionTargets[0]).TriggerEventClass(Class'FA_SeqEvent_TerminalHack', None, 2);

	/*We set a timer so the mission will stick around for awhile (Gives us time to replicate things like sounds or whatnot, and players get to process their failure)*/
	SetTimer(MissionLingerTime,false,'RemoveCurrentMission');
}

function CheckMoveZone()
{
	if (MissionsCompleted >= MissionsNeededToProgress)
	{
		FA_GRI(WorldInfo.GRI).AdvanceZone();
		MissionsCompleted = 0;
		MissionsNeededToProgress = FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[FA_GRI(WorldInfo.GRI).GetCurrentZone()].MissionsNeededToProgress;

		AnnounceSound(true, "ZoneCaptured");
		AnnounceSound(false, "ZoneLost");
	}
}

function bool FindWaypointLocandRot(name TagName, name SubTagName, byte TeamByte ,out vector outVec, out rotator outRot, optional int ForSet = 0, optional bool SetGenericExtractionTag = false, optional bool bSetPurge = false) //Has potential to be slow. Only call on events 
{
	local array<MissionWaypointInfo> AvailableWaypoints;
	local MissionWaypointInfo WP;
	local int RandI; ;
	
	//Find all applicable Waypoints 
	ForEach MissionWayPointArray(WP)
	{
		//Tag checked 1st, as it's most likely to be wrong
		if(WP.MissionTagName == TagName && WP.SubTag == SubTagName && (WP.TeamNum == TeamByte || TeamByte == 255 ) && WP.SetNum == ForSet && WP.ZoneIndex == FA_GRI(WorldInfo.GRI).GetCurrentZone())
		{
			AvailableWaypoints.AddItem(WP);
		}
		else
			continue; //Hurry on through 
	}
	
	if(AvailableWaypoints.Length == 0)
	{
		`log("Found no applicable waypoints"); 
		return false; 
	}
	else if(AvailableWaypoints.Length == 1){
		outVec = AvailableWaypoints[0].WPLocation;
		outRot = AvailableWaypoints[0].WPRotation;
	}
	else {
		//TODO: Make this not random; figure out based on an algorithm
		RandI = Rand(AvailableWaypoints.Length);
		outVec = AvailableWaypoints[RandI].WPLocation;
		outRot = AvailableWaypoints[RandI].WPRotation;
	}
	
	return true;
}

// ATTACKERS
// ZoneCaptured
// ObjectiveCaptured, ObjectiveDisarmed, ObjectiveArmed
// HalfTickets, QuarterTickets, TenthTickets

// BOTH
// NewObjective

// DEFENDERS
// ZoneLost
// ObjectiveLost, ObjectiveUnderAttack, ObjectiveRecovered
// EnemyHalfTickets, EnemyQuarterTickets, EnemyTenthTickets
// In this 
function AnnounceSound(bool bForAttackers, string AnnouncementType)
{
	local byte TeamNum;

	TeamNum = bForAttackers ? CurrentAttackers : CurrentDefenders;

	if (TeamNum != 0 && TeamNum != 1) return;

	if (IsAnnounceOnCooldown(TeamNum, AnnouncementType)) return;

	PlayAnnouncement(AnnouncerClass.static.GetSoundOfType(AnnouncementType, TeamNum), TeamNum);

	AddCooldown(TeamNum, AnnouncementType);
}

function PlayAnnouncement(SoundCue InCue, byte InTeam)
{
	local TS_Controller C; 

	if (InCue == None) return;
	
	ForEach WorldInfo.AllControllers(class'TS_Controller', C)
		if (C.GetTeamNum() == InTeam) C.ReliableClientPlaySound(InCue);
}

function AddCooldown(byte TeamNum, string AnnouncementType)
{
	local AnnounceCooldown NewCD;
	local float NextPlayTime;

	if (TeamNum != 0 && TeamNum != 1) return;

	NextPlayTime = WorldInfo.RealTimeSeconds + AnnouncerClass.static.GetCooldownOfType(AnnouncementType);

	if (TeamNum == 0 ? AnnouncementCooldowns_GDI.Find('TypeName', AnnouncementType) == INDEX_NONE : AnnouncementCooldowns_Nod.Find('TypeName', AnnouncementType) == INDEX_NONE)
	{
		NewCD.TypeName = AnnouncementType;
		NewCD.NextPlayTime = NextPlayTime;

		TeamNum == 0 ? AnnouncementCooldowns_GDI.AddItem(NewCD) : AnnouncementCooldowns_Nod.AddItem(NewCD);
	}
	else
	{
		if (TeamNum == 0)
			AnnouncementCooldowns_GDI[AnnouncementCooldowns_GDI.Find('TypeName', AnnouncementType)].NextPlayTime = NextPlayTime;
		else
			AnnouncementCooldowns_Nod[AnnouncementCooldowns_Nod.Find('TypeName', AnnouncementType)].NextPlayTime = NextPlayTime;
	}
}

function bool IsAnnounceOnCooldown(byte TeamNum, string AnnouncementType)
{
	if (TeamNum != 0 && TeamNum != 1) return false;

	if (TeamNum == 0 ? AnnouncementCooldowns_GDI.Find('TypeName', AnnouncementType) == INDEX_NONE : AnnouncementCooldowns_Nod.Find('TypeName', AnnouncementType) == INDEX_NONE) return false;

	if (TeamNum == 0)
		return AnnouncementCooldowns_GDI[AnnouncementCooldowns_GDI.Find('TypeName', AnnouncementType)].NextPlayTime < WorldInfo.RealTimeSeconds;
	else
		return AnnouncementCooldowns_Nod[AnnouncementCooldowns_Nod.Find('TypeName', AnnouncementType)].NextPlayTime < WorldInfo.RealTimeSeconds;

	return false;
}

DefaultProperties
{
	PotentialMissions.Empty

	PotentialMissions.Add(class'FA_MissionInfo_HackTerminal')

	MissionsNeededToProgress = -1

	AnnouncerClass = class'FA_Announcer'
}