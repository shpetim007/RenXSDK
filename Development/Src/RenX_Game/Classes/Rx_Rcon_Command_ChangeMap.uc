class Rx_Rcon_Command_ChangeMap extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	if (parameters == "")
		return "Error: Too few parameters." @ getSyntax();

	if(Rx_Game(`WorldInfoObject.Game) != None && !Rx_Game(`WorldInfoObject.Game).MapPackageExists(parameters))
		return "Error: Server cannot find map :"@parameters;

	`WorldInfoObject.ServerTravel(parameters);

	return "Switching to"@ parameters;
}

function string getHelp(string parameters)
{
	return "Changes the map immediately." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("changemap");
	triggers.Add("setmap");
	Syntax="Syntax: ChangeMap URL[String]";
}