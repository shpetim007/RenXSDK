class FA_PlayerStart extends UTTeamPlayerStart
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