class Rx_Rcon_Command_AdminSpawn extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	local Rx_PRI PRI;
	local string error;
	local Pawn P;
	local class<Rx_FamilyInfo> FamClass;

	PRI = Rx_Game(`WorldInfoObject.Game).ParsePlayer(parameters, error);
	
	if (PRI == None)
		return error;

	if (Controller(PRI.Owner) == None)
		return "Error: Player has no controller!";
	
	Rx_Controller(PRI.Owner).SetPlayerIsReady();

	if (Controller(PRI.Owner).Pawn != None)
		P = Controller(PRI.Owner).Pawn;
	
	if (PRI.Team != None)
		PRI.Team.RemoveFromTeam(Controller(PRI.Owner));

	if (Rx_Controller(PRI.Owner) != None)
	{
		Rx_Controller(PRI.Owner).BindVehicle(None);
	}
	PRI.DestroyATMines();
	PRI.DestroyRemoteC4();

	FamClass = class<Rx_FamilyInfo>(DynamicLoadObject("RenX_Game.Rx_FamilyInfo_Admin", class'Class'));

	Rx_Controller(PRI.Owner).CTextMessage("Attempting to set you to RenX_Game.Rx_FamilyInfo_Admin", 'Green');
	PRI.SetChar(FamClass, P, true, true);
	PRI.SetIsSpy(true);
	return "";
}

function string getHelp(string parameters)
{
	return "Spawns a player as admin character (no team, invisible)." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("AdminSpawn");
	triggers.Add("aspawn");
	Syntax="Syntax: AdminSpawn Player[string]";
}
