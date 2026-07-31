class Rx_Rcon_Command_MakeModerator extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	local Rx_PRI PRI;
	local string error;

	if (parameters == "")
		return "Error: Too few parameters." @ getSyntax();

	PRI = Rx_Game(`WorldInfoObject.Game).ParsePlayer(parameters, error);
	
	if (PRI == None)
		return error;

	// Target must be human
	if (PlayerController(PRI.Owner) == None)
		return "Error: Player is not human";

	// Check if they're already logged in as a moderator
	if (PRI.bModerator) 
		return "Error: Player already Moderator";

	// Mark target a moderator
	PRI.bModerator = true;
	return "Set player as Moderator";
}

function string getHelp(string parameters)
{
	return "Gives a player moderator permissions." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("makemoderator");
	Syntax="Syntax: MakeModerator Player[String]";
}
