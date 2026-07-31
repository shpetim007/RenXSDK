class Rx_Rcon_Command_ChangeName extends Rx_Rcon_Command;

simulated function SetName(PlayerReplicationInfo PRI, string parameters)
{
	PRI.PlayerName = parameters;
}

function string trigger(string parameters)
{
	local int pos;
	local string Recipient;
	local UTPlayerController TargetPlayerPC;

	if (parameters == "")
		return "Error: Too few parameters." @ getSyntax();
	
	pos = InStr(parameters," ",,true);
	if (pos != -1)
	{
		Recipient = Left(parameters,pos);
		parameters = Mid(parameters, pos+1);
	}
	else
		return "Error: Too few parameters." @ getSyntax();

	TargetPlayerPC = UTPlayerController(`WorldInfoObject.Game.AccessControl.GetControllerFromString(Recipient));
	if ( TargetPlayerPC.PlayerReplicationInfo == none )
	{
		return "Player not found.";
	}

	SetName(TargetPlayerPC.PlayerReplicationInfo, parameters);
	return "";
}

function string getHelp(string parameters)
{
	return "Changes a player's name." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("changename");
	triggers.Add("changeplayername");
	Syntax="Syntax: ChangeName Player[String] Name[String]";
}
