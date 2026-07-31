class Rx_Rcon_Command_RestoreBuilding extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	//local Rx_Building Building;
	local array<string> ParsedParameters;
	local TEAM TargetTeam;
	local string Target;
	local bool force;

	if (parameters == "")
		return "Error: Too few parameters." @ getSyntax();

	ParsedParameters = SplitString(parameters, " ", true);

	if (ParsedParameters.length < 2)
		return "Error: building and team are required. "@ getSyntax();

	Target = ParsedParameters[0];
	TargetTeam = TEAM(byte(ParsedParameters[1]));
	force = ParsedParameters[3] != "" && ParsedParameters[3] ~= "force" ? true : false;

	if (len(Target) <= 0 || (TargetTeam != 0 && TargetTeam != 1))
		return "Error: Wrong parameters. " @ getSyntax();

	return Rx_GRI(`WorldInfoObject.GRI).ServerRestoreBuilding(Target, TargetTeam, force);
}

function string getHelp(string parameters)
{
	return "Restores a building to a functional state with full health and armor." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("restore");
	triggers.Add("restorebuilding");
	triggers.Add("rb");
	Syntax="Syntax: restore Building[String] Team[Byte]";
}