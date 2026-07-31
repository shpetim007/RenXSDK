class FA_PRI extends TS_PRI;

simulated function bool IsAttacker()
{
	if (FA_TeamInfo(Team) != None)
		return FA_TeamInfo(Team).IsAttacker();

	return false;
}

reliable server function ServerHack(Actor HackedActor)
{
    local FA_TerminalObjective Terminal;

    Terminal = FA_TerminalObjective(HackedActor);

    if (Terminal != none)
    {
        `log("hacks called on "@Terminal);
        Terminal.hacks(fa_controller(owner));
    }
}