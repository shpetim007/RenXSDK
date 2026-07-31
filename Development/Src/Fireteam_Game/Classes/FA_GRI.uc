class FA_GRI extends TS_GRI;

enum Zone
{
	ZONE_1,
	ZONE_2,
	ZONE_3,
	ZONE_4,
	ZONE_5,
	ZONE_6,
	ZONE_7
};

var repnotify protectedwrite byte CurrentZoneIndex;
var protectedwrite byte MaxZoneIndex, PreviousZoneIndex;

var protectedwrite bool bSuddenDeath, bZoneGracePeriod;

var protectedwrite int InitialTickets, ZoneGainTickets;

replication
{
	if ((bNetDirty || bNetInitial) && Role == ROLE_Authority)
		CurrentZoneIndex, MaxZoneIndex, bSuddenDeath, PreviousZoneIndex, bZoneGracePeriod, InitialTickets;
}

simulated function ReplicatedEvent(name VarName)
{
	super.ReplicatedEvent(VarName);
	if(VarName == 'CurrentZoneIndex')
	{
		UpdateClientMap();
	}
}

simulated function UpdateClientMap()
{
	local TS_Controller MyC;

	MyC = TS_Controller(GetALocalPlayerController());

	if(MyC != None)
	{
		MyC.UpdateMinimapTextures();
	}
}

function ActivateSuddenDeath()
{
	bSuddenDeath = true;
}

simulated function bool IsAttacker(Controller C)
{
	return C.GetTeamNum() == FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam;
}

simulated function FA_TeamInfo GetAttackingTeam()
{
	return FA_TeamInfo(Teams[FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam]);
}

simulated function FA_TeamInfo GetDefendingTeam()
{
	if (FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam == 0)
		return FA_TeamInfo(Teams[1]);

	return FA_TeamInfo(Teams[0]);
}

simulated function byte GetCurrentZone()
{
	return CurrentZoneIndex;
}

simulated function byte GetMaxZone()
{
	return MaxZoneIndex;
}

simulated function byte GetUncapturedZoneCount()
{
	// Add one because it starts at 0
	return (MaxZoneIndex - CurrentZoneIndex) + 1;
}

// ZONE CHANGE MUST COME THROUGH HERE!!!
function SetActiveZone(byte NewZone)
{
	local FA_Zone TheZone;

	PreviousZoneIndex = CurrentZoneIndex;
	CurrentZoneIndex = NewZone;

	if (CurrentZoneIndex > MaxZoneIndex)
		Rx_Game(WorldInfo.Game).EndRxGame("Conquest", FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam);

	FA_TeamInfo(Teams[FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam]).ZoneCaptured(NewZone - 1);

	TriggerGlobalEventClass(class'FA_SeqEvent_ZoneCaptured', self, NewZone - 1);

	StartGracePeriod();

	`log("Zone"@NewZone-1@"was just captured, zone"@CurrentZoneIndex@"is now active."@GetUncapturedZoneCount()@"zones remain.");

	FA_MissionManager(FA_Game(WorldInfo.Game).MissionManager).NotifyZoneCaptured(PreviousZoneIndex, CurrentZoneIndex);

	if(WorldInfo.NetMode != NM_DedicatedServer)
	{
		UpdateClientMap();
	}
//	FA_Game(WorldInfo.Game).NotifyUpdateMinimap();

	// Find the max zone index
	ForEach AllActors(class'FA_Zone', TheZone)
		TheZone.bActive = TheZone.IsActiveZone();
}

function AdvanceZone()
{
	SetActiveZone(GetCurrentZone() + 1);
}

event StartGracePeriod()
{
	bZoneGracePeriod = true;

	SetTimer(FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[GetCurrentZone()].EscapeGracePeriod, false, nameof(EndGracePeriod));

	`log("Zone grace period started for"@PreviousZoneIndex$". Will end in"@FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[GetCurrentZone()].EscapeGracePeriod$"seconds.");

	Rx_Game(WorldInfo.Game).CTextBroadcast(255, "You have" @ FA_MapInfo(WorldInfo.GetMapInfo()).ZoneInfos[GetCurrentZone()].EscapeGracePeriod @ "seconds to travel to Zone" @ CurrentZoneIndex+1);
}

event EndGracePeriod()
{
	`log("Zone grace period ended for"@PreviousZoneIndex);
	bZoneGracePeriod = false;
}

simulated event PostBeginPlay()
{
	local FA_Zone TheZone;

	super.PostBeginPlay();

	// Find the max zone index
	ForEach AllActors(class'FA_Zone', TheZone)
	{
		if (TheZone.ZoneIndex > MaxZoneIndex)
			MaxZoneIndex = TheZone.ZoneIndex;
	}

	if (MaxZoneIndex == 0)
		`warn("Max zones is 0! No zones found or zoneindex not properly set.");
	else
		`log(`showvar(MaxZoneIndex));

	if (Role == ROLE_Authority)
	{
		InitialTickets = FA_Game(class'WorldInfo'.static.GetWorldInfo().Game).TicketConfigClass.static.GetInitialTickets();
		ZoneGainTickets = FA_Game(class'WorldInfo'.static.GetWorldInfo().Game).TicketConfigClass.static.GetZoneGainTickets();
	}
}

DefaultProperties
{
	CurrentZoneIndex = 0
	MaxZoneIndex = 0
	bSuddenDeath = false
	bZoneGracePeriod = false
	bInfinitePower = true
}