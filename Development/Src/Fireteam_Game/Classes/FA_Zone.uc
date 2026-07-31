class FA_Zone extends TS_PlayAreaVolume
implements(TSIfc_RespawnPoint)
placeable;

enum Team
{
	TEAM_GDI,
	TEAM_NOD,
	ALL
};

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

var(FireteamAssault) Zone ZoneIndex;
var(FireteamAssault) Team TeamIndex;
var(FireteamAssault) bool bIsSpawnpoint;
var(FireteamAssault) bool bZoneEnabled;

var array<FA_PlayerStart> SpawnPoints;
var array<FA_PlayerStart_DropPod> DropSpawnPoints;

replication
{
	if (bNetInitial)
		TeamIndex, ZoneIndex;

	if(bNetDirty || bNetInitial)
		bZoneEnabled;
}

simulated function PostBeginPlay()
{
	local FA_PlayerStart StartPoint;

	super.PostBeginPlay();

	if(!bIsSpawnpoint)
		return;

	ForEach AllActors(class'FA_PlayerStart', StartPoint)
	{
		if (self.EncompassesPoint(StartPoint.Location) && StartPoint.ZoneIndex == ZoneIndex)
			SpawnPoints.AddItem(StartPoint);
	}
}

function AddDropPoint(FA_PlayerStart_DropPod SpawnPoint)
{
	DropSpawnPoints.AddItem(SpawnPoint);
}

simulated function bool CanDrop(Controller Player)
{
	if (ShouldSpawnHere() && SpawnPoints.Length > 0 && (TeamIndex == ALL || Player.GetTeamNum() == TeamIndex))
		return true;

	return false;
}

function float RatePlayerStart(PlayerStart P, byte TeamNum, Controller Player, float InitialRate)
{
	if(Player.GetTeamNum() <= 1 && Player.GetTeamNum() >= 0)
		TeamNum = Player.GetTeamNum();


	if(SpawnPoints.Find(P) < 0)
		return -1000;

	if(UTTeamPlayerStart(P).TeamNumber <= 1 && UTTeamPlayerStart(P).TeamNumber != TeamNum)
	{
		return -1000;
	}

	return InitialRate;
}

simulated function bool RespawnPointAvailableFor(Controller Player)
{
	return CanDrop(Player);
}

simulated function bool RespawnPointVisibleFor(Controller Player)
{
	return CanDrop(Player);
}

simulated function vector GetTechTreeSourcePoint(Controller Player)
{
	if (SpawnPoints.length > 0)
		return SpawnPoints[0].Location;

	return Location;
}

simulated function string GetSpawnName()
{
	return "Zone" $ ZoneIndex + 1;
}

simulated function Texture GetSpawnIcon()
{
	return Texture2D'TSHUD.OutpostIcons.TS_OutpostIcon_A';
}

simulated function Vector GetSpawnColor()
{
	return vect(0,0,0);
}

simulated function bool GetForceColor()
{
	return false;
}

function HandlePlayerRespawn(Controller Player)
{
	local Pawn PlayerPawn;
	local TS_Controller TSP;

	TSP = TS_Controller(Player);

	PlayerPawn = Player.Pawn;

	if (PlayerPawn == None)
		return;

	// if contested, you can only drop via droppod
	if(TSP != None && TSP.PreferredSpawnMethod == 0 && AttemptDropPodSpawn(Player))
	{
		return;
	}

	if (AttemptGroundSpawn(Player))
		return;
}

function bool AttemptDropPodSpawn(Controller Player)
{
	local FA_PlayerStart_DropPod DP;
	local array<FA_PlayerStart_DropPod> DPList;

	foreach DropSpawnPoints(DP)
	{
		if (DP.FATeamIndex < 2 && DP.FATeamIndex != Player.GetTeamNum())
			continue;

		DPList.AddItem(DP);
	}

	if (DPList.Length <= 0)
		return false;

	DPList[Rand(DPList.Length)].DropPlayer(Player);
	return true;
}

function bool AttemptGroundSpawn(Controller Player)
{
	local FA_PlayerStart DP;
	local array<FA_PlayerStart> DPList;
	local int i;

	foreach SpawnPoints(DP)
	{
		if (DP.TeamNumber < 2 && DP.TeamNumber != Player.GetTeamNum())
			continue;

		DPList.AddItem(DP);
	}

	if(DPList.Length > 0)
	{
		i = Rand(DPList.Length);
		`log("Spawning in"@self@"at"@`showvar(DPList[i].Location));
		Player.Pawn.SetLocation(DPList[i].Location);
		Player.Pawn.SetRotation(DPList[i].Rotation);
		return true;
	}

	return false;
}

simulated function AddDefence(TS_Defence MyDefence);

simulated function RemoveDefence(TS_Defence MyDefence);

function bool IsAcceptableAreaVolume(Rx_AreaVolume V, Pawn P)
{
	if (!super.IsAcceptableAreaVolume(V, P))
		return false;

	if (FA_Zone(V).IsActiveZone() && (FA_Zone(V).TeamIndex == ALL || FA_Zone(V).TeamIndex == P.GetTeamNum() || P.GetTeamNum() > 1))
	{
		return true;
	}

	return false;
}

simulated function bool CanSpawnHere(coerce byte InTeamNum)
{
	return bZoneEnabled && (TeamIndex == ALL ? true : TeamIndex == InTeamNum);
}

simulated function bool IsActiveZone()
{
	return bZoneEnabled && (ZoneIndex == FA_GRI(WorldInfo.GRI).GetCurrentZone() || (ZoneIndex == FA_GRI(WorldInfo.GRI).PreviousZoneIndex && FA_GRI(WorldInfo.GRI).bZoneGracePeriod));
}

simulated function bool ShouldSpawnHere()
{
	return bZoneEnabled && ZoneIndex == FA_GRI(WorldInfo.GRI).GetCurrentZone() && SpawnPoints.Length > 0;	
}

/* epic ===============================================
* ::OnToggle
*
* Scripted support for toggling a playerstart, checks which
* operation to perform by looking at the action input.
*
* Input 1: turn on
* Input 2: turn off
* Input 3: toggle
*
* =====================================================
*/
simulated function OnToggle(SeqAct_Toggle action)
{
	if (action.InputLinks[0].bHasImpulse)
	{
		// turn on
		bZoneEnabled = true;
	}
	else
	if (action.InputLinks[1].bHasImpulse)
	{
		// turn off
		bZoneEnabled = false;
	}
	else
	if (action.InputLinks[2].bHasImpulse)
	{
		// toggle
		bZoneEnabled = !bZoneEnabled;
	}
}

DefaultProperties
{
	ZoneIndex = ZONE_1
	TeamIndex = ALL
	bIsSpawnpoint = true
	bZoneEnabled = true

	bStatic=false
	bReplicateMovement=true
	Physics=PHYS_Interpolating
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	RemoteRole=ROLE_SimulatedProxy
}