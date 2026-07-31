class FA_Game extends TS_Game;

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

var class<FA_TicketConfig> TicketConfigClass;

function StartMatch()
{
	//local TS_Building_Team_Internals BuildingInternals;

	super(Rx_Game).StartMatch();

	if (MissionManager != None)
		MissionManager.InitializeMissions();

	BuildInitialBuildings();

	//foreach `WorldInfoObject.AllActors(class'TS_Building_Team_Internals', BuildingInternals)
	//	BuildingInternals.HealthLocked = true;
}

function InitMapSize(){}

function CheckMapSizes(){}

function FA_Mutator GetBaseFAMutator()
{
	local Mutator M;

	for (M = BaseMutator; M != None; M = M.NextMutator)
	{
		if (FA_Mutator(M) != None)
			return FA_Mutator(M);
	}

	return None;
}

// Tie tickets to spawning
function RestartPlayer(Controller NewPlayer)
{
	if (FA_TeamInfo(NewPlayer.PlayerReplicationInfo.Team).CanSpawnPlayer())
	{
		if (NewPlayer.PlayerReplicationInfo.Deaths > 0)
			FA_TeamInfo(NewPlayer.PlayerReplicationInfo.Team).ConsumeRespawnTickets(NewPlayer, 1);

		super.RestartPlayer(NewPlayer);
	}
	else
	{
		if (FA_GRI(WorldInfo.GRI).bSuddenDeath)
		{
			FA_Controller(NewPlayer).GotoOutOfTickets();
		}
		else
		{
			EndRxGame("Elimination", FA_GRI(WorldInfo.GRI).GetDefendingTeam().TeamIndex);
		}
	}
}

function bool IsValidEndReason(string Reason)
{
	return (Reason ~= "Domination" || Reason ~= "Conquest" || Reason ~= "Elimination" || Reason ~= "Triggered");
}

// Add extra time to ren end time so we can play cinematics
State MatchOver
{
	function BeginState(name PreviousState)
	{
		local Rx_Mutator Rx_Mut;
		RenEndTime = WorldInfo.RealTimeSeconds + MapVoteTime + 60;
		UTGameReplicationInfo(GameReplicationInfo).bMatchIsOver = true;
		super(UTTeamGame).BeginState(PreviousState);
		
		Rx_Mut = GetBaseRXMutator();
		if (Rx_Mut != None)
		{
			Rx_Mut.OnMatchEnd();
		}
	}
}

// Only spectate same team players if out of tickets
function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
	if (Viewer.IsInState('OutOfTickets') && Viewer.GetTeamNum() != ViewTarget.GetTeamNum())
		return false;
	
	return super.CanSpectate(Viewer, ViewTarget);
}

// Only spawn in active zones
function float RatePlayerStart(PlayerStart P, byte TeamNum, Controller Player)
{
	local float Ret;
	local FA_Zone PlayZone;
	
	Ret = super.RatePlayerStart(P,TeamNum,Player);

	if (Ret < 0.f)
		return Ret;

	ForEach AllActors(class'FA_Zone', PlayZone)
	{
		if (FA_PlayerStart(P) == None) return -9;

		if (PlayZone.ShouldSpawnHere() && PlayZone.CanSpawnHere(TeamNum) && FA_PlayerStart(P).ZoneIndex == PlayZone.ZoneIndex)
			return 1.f;
	}

	return -9;
}

/*
function NotifyUpdateMinimap()
{
	local TS_Controller C;

	ForEach DynamicActors(class'TS_Controller', C)
	{
		C.UpdateMinimapTextures();
	}
}
*/

function EndRxGame(string Reason, byte WinningTeamNum)
{
	if (bGameEnded || Reason ~= "Buildings") return;

	super.EndRxGame(Reason, WinningTeamNum);

	if (Reason ~= "Elimination")
	{
		SpawnEndGamePayload();
		Rx_GRI(WorldInfo.GRI).WinnerReason = "By Elimination";
	}

	if (Reason ~= "Conquest")
	{
		SpawnEndGamePayload();
		Rx_GRI(WorldInfo.GRI).WinnerReason = "By Conquest";
	}

	TriggerGlobalEventClass(class'FA_SeqEvent_GameOver', self, FA_GRI(WorldInfo.GRI).GetAttackingTeam().TeamIndex == WinningTeamNum ? 0 : 1);
}

simulated function GiveTeamCredits(float Credits, byte TeamNum, optional PlayerReplicationInfo ExcludedPRI) 
{
	local PlayerReplicationInfo pri;
	local int index;
	
	for (index = 0; index < WorldInfo.GRI.PRIArray.Length; ++index)
	{
		pri = WorldInfo.GRI.PRIArray[index];
		if (pri != ExcludedPRI && Rx_PRI(pri) != None && pri.GetTeamNum() == TeamNum && RX_PRI(pri).GetCredits() < MaximumPassiveCredits)
			Rx_PRI(pri).addCredits(Credits);
	}
}

// ONLY CALL THIS FROM ENDRXGAME
// TODO: Something for kismet end cinematic?
final private function SpawnEndGamePayload()
{
	
}

DefaultProperties
{
	PurchaseSystemClass = class'FA_PurchaseSystem'
	DefaultPawnClass = class'TS_Pawn'
	PlayerControllerClass = class'FA_Controller'
	VehicleManagerClass = class'TS_VehicleManager'
	HUDClass = class'FA_HUD'
	GameReplicationInfoClass = class'FA_GRI'
	PlayerReplicationInfoClass = class'FA_PRI'
	TeamInfoClass = class'FA_TeamInfo'
	VictoryMessageClass = class'TS_VictoryMessage'
	HelipadVehicleManagerClass = class'TS_HelipadVehicleManager'
	BuildingManagerClass = class'FA_BuildingManager'
	MissionManagerClass = class'FA_MissionManager'
	SquadManagerClass = class'TS_SquadManager'

	TicketConfigClass = class'FA_TicketConfig'
	
	//BotClass = class'TibSun_Game.TS_Bot_Dummy'
	bAllowDeployedDefenceKills = false

	EndGameDelay = 60

	MapPrefixes.Empty
	MapPrefixes.Add("FA")
	Acronym = "FA"
	GameType = 4 // 4 = FA_Game

	PowerUpClasses.Empty
	
	ScoreEvents.Empty

	ForbiddenWeapons[0] = class'TS_Weapon_Blueprint_GDI'
	ForbiddenWeapons[1] = class'TS_Weapon_Blueprint_Nod'
}