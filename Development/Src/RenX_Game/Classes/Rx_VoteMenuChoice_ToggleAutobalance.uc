class Rx_VoteMenuChoice_ToggleAutobalance extends Rx_VoteMenuChoice;

function Init()
{
	Finish();
}

function ServerInit(Rx_Controller instigator, string param, int t)
{
	local string currentState;
	super.ServerInit(instigator, param, t);

	if(Rx_Game(instigator.WorldInfo.Game).bAutoBalancerEnabled)
	{
		currentState="Vote started to disable autobalance";
	}
	else
	{
		currentState="Vote started to enable autobalance";
	}

	Rx_Game(instigator.WorldInfo.Game).CTextBroadcast(t, currentState, 'Green', 120,,true);
}

function string ComposeTopString()
{
	return super.ComposeTopString() $ " wants to toggle <font color='"$HostColor$"'>autobalance</font>";
}

function Execute(Rx_Game game)
{
	game.ToggleAutoBalance("vote");
}

DefaultProperties
{
	MenuDisplayString = "Toggle AutoBalance"
}
