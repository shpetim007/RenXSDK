class Rx_Rcon_Command_PurgeAFK extends Rx_Rcon_Command;

function string trigger(string parameters)
{
	local Rx_Controller c;

	foreach `WorldInfoObject.Game.AllActors(class'Rx_Controller', c)
	{
		if (Rx_PRI(c.PlayerReplicationInfo).bisAFK)
		{
			`WorldInfoObject.Game.AccessControl.KickPlayer(c, "kicked for inactivity");
		}
	}

	return "";
}

function string getHelp(string parameters)
{
	return "Kicks all AFK players." @ getSyntax();
}

DefaultProperties
{
	triggers.Add("purgeafk");
	Syntax="Syntax: purgeafk";
}