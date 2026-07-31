class Rx_VoteMenuChoice_StopHarvester extends Rx_VoteMenuChoice;

var string actionText;
var string broadcastedText;
var bool bHarvesterState;
var Rx_Controller ComC;

function Init()
{
	ToTeam = Handler.PlayerOwner.PlayerReplicationInfo.Team.TeamIndex;
	bHarvesterState = Rx_TeamInfo(VoteInstigator.PlayerReplicationInfo.Team).bGetHarvStopped();
	Finish();
}

function ServerInit(Rx_Controller instigator, string param, int t)
{
	super.ServerInit(instigator, param, t);

	bHarvesterState = Rx_TeamInfo(VoteInstigator.PlayerReplicationInfo.Team).bGetHarvStopped();

	//Automatically pass the voting when it's a singleplayer mode or if there is only one player on the server
	if( VoteInstigator.WorldInfo.NetMode != NM_Standalone && (Rx_Game(instigator.WorldInfo.Game).Teams[0].Size + Rx_Game(instigator.WorldInfo.Game).Teams[1].Size) > 1 )
	{
		broadcastedText = "A HARVESTER ";
		if(!bHarvesterState)
			actionText = "STOP";
		else
			actionText = "START";
		broadcastedText = broadcastedText $ actionText $ " VOTE HAS BEEN STARTED";

		Rx_Game(instigator.WorldInfo.Game).CTextBroadcast(ToTeam, broadcastedText, 'Red', 120,,true);

		// update on players
		UpdatePlayers(instigator.WorldInfo);
		if(t != -1)
			Rx_GRI(instigator.WorldInfo.GRI).VoteChoiceClass[t] = Class;

		else
			Rx_GRI(instigator.WorldInfo.GRI).VoteChoiceClass[2] = Class;
	}

}

function string ComposeTopString()
{
	bHarvesterState = Rx_TeamInfo(VoteInstigator.PlayerReplicationInfo.Team).bGetHarvStopped();

	if(!bHarvesterState)
		actionText = "stop";
	else
		actionText = "start";

	return super.ComposeTopString() $ " wants to "$ actionText $" the harvester";
}

function Execute(Rx_Game game)
{
	VoteInstigator.CommandHarvesterFromVoting();
}

function Finish()
{
	Handler.PlayerOwner.SendVote(self.Class, SerializeParam(), ToTeam);

	Handler.Terminate();
}

DefaultProperties
{
	MenuDisplayString = "Stop/Start Harvester"
}

//TODO!: DOROBIĆ OPISY JAK W PRZYPADKU Rx_VoteMenuChoice_Kick.uc!