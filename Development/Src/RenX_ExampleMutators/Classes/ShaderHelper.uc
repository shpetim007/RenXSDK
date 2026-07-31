class ShaderHelper extends UTMutator;

var const private array<string> CommandsToRun;

auto state Run
{
	Begin:
	   RunCommands();
	   Sleep(1.0);
	   goto('Begin');
}

function RunCommands()
{
	local string Command;

	ForEach CommandsToRun(Command)
	{
		WorldInfo.Game.ConsoleCommand(Command);
	}
}

DefaultProperties
{
	CommandsToRun(0)="saveshaders"
	CommandsToRun(1)="exit"
}