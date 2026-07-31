class Rx_Rcon_Command extends Object abstract;

var protected array<string> triggers;
var protected string Syntax;

function bool matches(string trigger)
{
	local string checking;

	trigger = Locs(trigger);

	ForEach triggers(checking)
	{
		if (trigger == Locs(checking))
			return true;
	}

	return false;
}

function addTrigger(string trigger)
{
	triggers.AddItem(Locs(trigger));
}

function int getTriggerCount()
{
	return triggers.Length;
}

function string getTrigger(int index)
{
	return triggers[index];
}

function string getSyntax()
{
	return syntax;
}

function string trigger(string parameters);

// This should always be overridden by sub-classes.
function string getHelp(string parameters)
{
	return getSyntax();
}

DefaultProperties
{
}
