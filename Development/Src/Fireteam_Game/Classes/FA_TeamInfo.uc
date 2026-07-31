class FA_TeamInfo extends TS_TeamInfo;

var bool bIsAttacker;
var int RespawnTickets;

replication
{
	if (bNetDirty && Role == ROLE_Authority)
		bIsAttacker, RespawnTickets;
}

function Initialize(int NewTeamIndex)
{
	super.Initialize(NewTeamIndex);

	bIsAttacker = FA_MapInfo(WorldInfo.GetMapInfo()).AttackingTeam == NewTeamIndex;

	if (bIsAttacker)
		InitAsAttacker();

	`log(self@"inited"@`showvar(bIsAttacker));
}

function InitAsAttacker()
{
	RespawnTickets = FA_Game(WorldInfo.Game).TicketConfigClass.static.GetInitialTickets();
}

function ZoneCaptured(byte CapturedZone)
{
	RespawnTickets = FA_Game(WorldInfo.Game).TicketConfigClass.static.GetZoneGainTickets();
}

simulated function int GetTickets()
{
	return IsAttacker() ? RespawnTickets : 9999;
}

simulated function bool CanSpawnPlayer()
{
	return GetTickets() > 0;
}

simulated function bool IsAttacker()
{
	return bIsAttacker;
}

simulated function bool IsDefender()
{
	return !IsAttacker();
}

function AddRespawnTickets(int Count)
{
	RespawnTickets += Count;
}

function ConsumeRespawnTickets(Controller RespawningPlayer, int Count)
{
	if (ShouldConsumeTickets(RespawningPlayer))
		RespawnTickets -= Count;
}

function SetRespawnTickets(int NewTotal)
{
	RespawnTickets = NewTotal;
}

function bool ShouldConsumeTickets(Controller RespawningPlayer)
{
	// Cancel ticket if overridden by mutator for whatever reason
	if (FA_Game(WorldInfo.Game).GetBaseFAMutator() != None && FA_Game(WorldInfo.Game).GetBaseFAMutator().CancelConsumeTicket(RespawningPlayer, self))
		return false;

	return IsAttacker();
}

// Disable domination in team info
function AddDominationTime(float In_Time){}

simulated function bool PowerLow()
{
	return false;
}

simulated function float GetPower()
{
	return 999.f;
}

DefaultProperties
{
	bIsAttacker = false
	TechLevel = 3
}