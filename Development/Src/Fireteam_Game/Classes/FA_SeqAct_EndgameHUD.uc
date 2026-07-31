class FA_SeqAct_EndgameHUD extends SeqAct_Toggle;

event Activated()
{
	local FA_Controller C;

	C = FA_Controller(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());

	if (C != None)
		C.ActivateEndgameScoreboard();
}

defaultproperties
{
	ObjName="Endgame Scoreboard"
	ObjCategory="Fireteam Assault"

	InputLinks.Empty
	VariableLinks.Empty
	EventLinks.Empty

	InputLinks(0)=(LinkDesc="Turn On")
}
