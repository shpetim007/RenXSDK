class FA_PlayerStart_DropPod extends TS_PlayerStart_DropPod
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
var(FireteamAssault) Team FATeamIndex;

function PostBeginPlay()
{
	local FA_Zone TheZone;
	
	ForEach WorldInfo.AllActors(class'FA_Zone', TheZone)
	{
		if (TheZone.ZoneIndex == ZoneIndex && (TeamIndex == ALL || TheZone.CanSpawnHere(TeamIndex)))
			TheZone.AddDropPoint(self);
	}
}

DefaultProperties
{
	DropPodClass=class'FA_Vehicle_DropPod'
}