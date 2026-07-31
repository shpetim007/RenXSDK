class FA_TicketConfig extends Object
config(FireteamAssault);

var config int InitialAttackerTickets;

static function int GetInitialTickets()
{
	return default.InitialAttackerTickets;
}

static function int GetZoneGainTickets()
{
	return static.GetInitialTickets();
}
