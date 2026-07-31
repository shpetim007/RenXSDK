class FA_Mutator extends TS_Mutator;

// Return true to stop a ticket from being consumed by this player when respawning
event bool CancelConsumeTicket(Controller RespawningPlayer, FA_TeamInfo TeamInfo)
{
	return false;
}