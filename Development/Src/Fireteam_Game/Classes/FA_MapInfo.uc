class FA_MapInfo extends TS_MapInfo;

enum Team
{
	TEAM_GDI,
	TEAM_NOD
};

struct FAZoneInfo
{
	var() Texture MinimapTexture[2];
	var() class<FA_MissionInfo> MissionClass;
	var() int EscapeGracePeriod;
	var() int MissionsNeededToProgress;

	StructDefaultProperties
	{
		MissionClass = None
		EscapeGracePeriod = 30
		MissionsNeededToProgress = 1
	}
};

var(FireteamAssault) Team AttackingTeam<ToolTip=The attacking team.>;
var(FireteamAssault) bool bUseEndgameCinematic<ToolTip=Does this map use custom cinematics at the end of the match?>;
var(FireteamAssault) FAZoneInfo ZoneInfos[7];

simulated function Texture GetMinimapTexture()
{
	local int TeamIndex;

	TeamIndex = class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().GetTeamNum();

	if (TeamIndex != 0 && TeamIndex != 1)
		TeamIndex = 0;

	return ZoneInfos[FA_GRI(class'WorldInfo'.static.GetWorldInfo().GRI).GetCurrentZone()].MinimapTexture[TeamIndex];
}

DefaultProperties
{
	AttackingTeam = TEAM_GDI
	bUseEndgameCinematic = false
/*
	// GDI Infantry
	GDIInfantryArray.Empty
	GDIInfantryArray[0]  = class'TS_FamilyInfoSet_CQ_GDI_Assault'
	GDIInfantryArray[1]  = class'TS_FamilyInfoSet_CQ_GDI_Engineer'
	GDIInfantryArray[2]  = class'TS_FamilyInfoSet_CQ_GDI_Recon'
	GDIInfantryArray[3]  = class'TS_FamilyInfoSet_CQ_GDI_Heavy'
	
	// Nod Infantry
	NodInfantryArray.Empty
	NodInfantryArray[0]  = class'TS_FamilyInfoSet_CQ_Nod_Assault'
	NodInfantryArray[1]  = class'TS_FamilyInfoSet_CQ_Nod_Engineer'
	NodInfantryArray[2]  = class'TS_FamilyInfoSet_CQ_Nod_Recon'
	NodInfantryArray[3]  = class'TS_FamilyInfoSet_CQ_Nod_Heavy'
*/	
	// GDI Vehicles
	GDIVehicleArray.Empty
	
	// Nod Vehicles
	NodVehicleArray.Empty
}