class Rx_VoteMenuChoice_Commander extends Rx_VoteMenuChoice;

var SoundCue IonTestSnd;
var SoundCue ElectedSound;
var int ComID, CandidateRank;
var string ComName;
var Rx_Controller ComC;
var string HR_Teamname;
var int CurrentTier;
var bool VotingIn;
var bool bForceConcluded;

function Init()
{
	// enable console
	ToTeam = Handler.PlayerOwner.PlayerReplicationInfo.Team.TeamIndex;
}


function array<string> GetDisplayStrings()
{
	local array<string> ret;

	if (CurrentTier == 0)
	{
		// Changing these to i|String, to match the required style to split them for the new side menu funciton.
		ret.AddItem("1|Elect");
		ret.AddItem("2|Impeach");
	}

	return ret;
}

function KeyPress(byte T)
{
	local bool bIsCommanderAssigned;
	local Byte bRequestorTeam;
	local int i;
	local GameReplicationInfo LGRI;
	local Rx_PRI LPRI;

	//Check whether a commander is assigned to the team 
	LGRI = Handler.PlayerOwner.WorldInfo.GRI;
	bIsCommanderAssigned = false;
	bRequestorTeam = Handler.PlayerOwner.GetTeamNum();
	
	for (i = 0; i < LGRI.PRIArray.Length; i++)
	{
		LPRI = Rx_PRI(LGRI.PRIArray[i]);

		if(LPRI == None)
		{
			continue;
		}

		if (LPRI.bIsCommander == true && LPRI.GetTeamNum() == bRequestorTeam)
		{
			bIsCommanderAssigned = true;
			break;
		}
	}


	if (CurrentTier == 0)
	{
		// accept 1, 2
		if (T == 1 || T == 2)
		{
			switch (T)
			{
				case 1:
				VotingIn = true;
				break;
				case 2:
				VotingIn = false; 
				break;
			}
		
			if(Handler.PlayerOwner.WorldInfo.NetMode != NM_Standalone)
			{
				if(VotingIn) 
				{
					Handler.PlayerOwner.ShowVoteMenuConsole("PlayerID or name of Commander candidate: ");
					CurrentTier=1;
				}
				else if (bIsCommanderAssigned == false)
				{
					//`log("No commander on team!!!");
					Handler.PlayerOwner.CTextMessage("-There is no commander on your team-",'Red');
					Handler.Terminate();
					return;
				}
				else
				Finish();
			}
			else
			Finish(); 
		}
	}
}

function InputFromConsole(string text)
{
	local string Pname;
	local Rx_PRI P_PRI;

	Pname = Right(text, Len(text) - 33);
	
	//`log("Playername was" $ Pname) ;
	
	//Parse player name from string. Thankfully someone else already wrote a function to parse names =D
	
	P_PRI= Handler.PlayerOwner.ParsePlayer(Pname);

	Pname = P_PRI.PlayerName;
	
	if(P_PRI == None || (P_PRI.GetTeamNum() != Handler.PlayerOwner.GetTeamNum() || !P_PRI.bCanBeVotedCommander))
	{
		//`log("Failed to find player PRI, terminating vote.");
		Handler.PlayerOwner.CTextMessage("-Vote Failed-",'Red');
		Handler.Terminate();
	}
	else
	{
		//`log("Setting ComName to"@Pname);
		ComName=Pname	;
		
		ComID=FindPlayerIDfromName(Pname);
			
		Finish();
	}
}

function bool GoBack()
{
	switch (CurrentTier)
	{
	case 0:
		return true; // kill this submenu
	case 1:
		CurrentTier = 0;
		// enable console
		//Handler.PlayerOwner.ShowVoteMenuConsole("PlayerID or name of Commander candidate : ");
		return false;
	}
}


function string SerializeParam()
{

	//`log("000000000000000Serialize returning " $ ComName);
	return string(ComID) $ "\n" $ string(CandidateRank) $"\n" $ string(VotingIn);

}

function DeserializeParam(string param)
{
	local Rx_Controller c;
	local int i;
	//Fancy work with strings stolen from AddBots
	
 
	i = InStr(param, "\n");
	//`log(ComID);
	ComID = int(Left(param, i));
	//	`log("COMID: "@ComID);
	param = Right(param, Len(param) - i - 1);
	i = InStr(param, "\n");
	CandidateRank = 0 ;// int(Left(param, i));
	//`log("Rank: "@CandidateRank);
	param = Right(param, Len(param) - i - 1);
	VotingIn = bool(param);
	//`log("VoteIn: "@VotingIn);
	

	if(ComID !=0){
	foreach VoteInstigator.AllActors(class'Rx_Controller', c)
		{
		if (c.PlayerReplicationInfo.PlayerID == ComID)
			{
				ComC = c;
				break;
			}
		}
	
	if (ComC == none)
		{
			bPendingDelete = true;
			Rx_Game(VoteInstigator.WorldInfo.Game).DestroyVote(self);
		}
	}
}

function Finish()
{
	//`log("Sending vote with Class:"@self.Class @"Serialized Parameter: "@SerializeParam() @ "To Team: " @ToTeam);
	
	//Inject for standalones to just
	if(Handler.PlayerOwner.WorldInfo.NetMode == NM_Standalone) 
	{
		ComC = Handler.PlayerOwner;
		Execute(Rx_Game(Handler.PlayerOwner.WorldInfo.Game)); 
		Handler.Terminate();
		return;
	}
	Handler.PlayerOwner.SendVote(self.Class, SerializeParam(), ToTeam);

	Handler.Terminate();
}



function int FindPlayerIDfromName (string Pname)
{
local Rx_PRI LPRI;
local int P_ID, i;
local GameReplicationInfo LGRI;

LGRI = Handler.PlayerOwner.WorldInfo.GRI;

for (i=0;i < LGRI.PRIArray.Length;i++)
	{
		LPRI=Rx_PRI(LGRI.PRIArray[i]);
		
		//`log(LPRI);
		
		if (LPRI.PlayerName == Pname)
		{
			//`log(LPRI.PlayerName);
			P_ID = LPRI.PlayerID ;
	//`log("000000000000000 Player ID found as" @ P_ID)	;	
			return P_ID;
			break;
		}
	
	}
	if(P_ID == 0) return -8008;
}


function string ComposeTopString()
{
	HR_Teamname = Rx_Game(VoteInstigator.WorldInfo.Game).GetTeamName(ToTeam);
	
//`log("0112121121221212 Composing Top string 11111111");
	if(VotingIn) 
	{
		if(ComC == VoteInstigator)	
			return super.ComposeTopString() $ " volunteers to be " $ HR_Teamname$"'s Commander" ;
		else
			return super.ComposeTopString() $ " wants to vote " $ class'Rx_HUD'.static.CleanHTMLMessage(ComC.PlayerReplicationInfo.PlayerName) $ " for " $ HR_Teamname $ "'s Commander" ;
	}

	else
		return super.ComposeTopString() $ " wants to vote OUT" @ HR_Teamname $"'s" @ "Commander" ;	

}

function ServerInit(Rx_Controller instigator, string param, int t)
{
	local string params;
	 
	ToTeam = t;
	VoteInstigator = instigator;

	//Load team colors from Rx_HUD
	GDIColor = class<Rx_HUD>(Rx_Game(instigator.WorldInfo.Game).HUDClass).default.GDIColor;
	NodColor = class<Rx_HUD>(Rx_Game(instigator.WorldInfo.Game).HUDClass).default.NodColor;
	HostColor = class<Rx_HUD>(Rx_Game(instigator.WorldInfo.Game).HUDClass).default.HostColor;

	DeserializeParam(param);

	if(!VotingIn && Rx_PRI(VoteInstigator.PlayerReplicationInfo).bIsCommander)
	{
		Execute(Rx_Game(VoteInstigator.WorldInfo.Game));
		Rx_Game(VoteInstigator.WorldInfo.Game).DestroyVote(self);
		return;
	}

	TopString = ComposeTopString();
	EndTime = instigator.WorldInfo.TimeSeconds + TimeLeft;
	
	// Log vote called.
	params = ParametersLogString();
	if (params != "")
		Rx_Game(instigator.WorldInfo.Game).RxLog("VOTE"`s "Called;" `s TeamTypeToString(t) `s class `s "by" `s `PlayerLog(instigator.PlayerReplicationInfo) `s params);
	else
		Rx_Game(instigator.WorldInfo.Game).RxLog("VOTE"`s "Called;" `s TeamTypeToString(t) `s class `s "by" `s `PlayerLog(instigator.PlayerReplicationInfo) );

/*
	if (`RxGameObject.NumPlayers == 1) {
		`RxGameObject.RxLog("VOTE" `s "Results;" `s TeamTypeToString(ToTeam) `s class `s "pass" `s "Yes=1" `s "No=0");
		Execute(`RxGameObject);
		`RxGameObject.DestroyVote(self);
	}
*/

	// update on players
	UpdatePlayers(instigator.WorldInfo);

	if(t != -1)
	{
		Rx_GRI(instigator.WorldInfo.GRI).VoteChoiceClass[t] = Class;
		Rx_GRI(instigator.WorldInfo.GRI).VoteSubject[t] = ComC.PlayerReplicationInfo;
		Rx_GRI(instigator.WorldInfo.GRI).VoteExtraParams[t] = "Election";
	}
	else
	{
		Rx_GRI(instigator.WorldInfo.GRI).VoteChoiceClass[2] = Class;
		Rx_GRI(instigator.WorldInfo.GRI).VoteSubject[2] = ComC.PlayerReplicationInfo;
		Rx_GRI(instigator.WorldInfo.GRI).VoteExtraParams[2] = "Impeachment";
	}

}





function Execute(Rx_Game game)
{

//local Rx_Controller CON ;
//`log("0112121121221212 Attempting to execute");

//Find applicable player controllers
	if(VotingIn) 
	{
		game.ChangeCommander(ToTeam, Rx_PRI(ComC.PlayerReplicationInfo));
	}
	else
	{
		if(Rx_PRI(VoteInstigator.PlayerReplicationInfo).bIsCommander)
			game.CTextBroadcast(ToTeam,VoteInstigator.PlayerReplicationInfo.PlayerName@"has abdicated their Commander role",'Red');

		game.RemoveCommander(ToTeam);	
	}
}

static function bool bIsAvailable(Rx_Controller MyHandler)
{
	return Rx_GRI(MyHandler.WorldInfo.GRI).bEnableCommanders;
}

function PlayerVoteNo(Rx_Controller p)
{
	if(ComC == p && CanConcludeVote(p))
	{
		ConcludeVote();
		return;
	}

	super.PlayerVoteNo(p);

}

function PlayerVoteYes(Rx_Controller p)
{
	if(!VotingIn && p.PlayerReplicationInfo.Team.TeamIndex == ToTeam && Rx_PRI(p.PlayerReplicationInfo).bIsCommander && CanConcludeVote(p))
	{
		ConcludeVote();
		return;
	}	

	super.PlayerVoteYes(p);
}

function bool CanConcludeVote(Rx_Controller p)
{
	local int i;

	if(VotingIn)
	{
		for (i = 0; i < No.Length; i++)
		{
			if (No[i] == p)
			{
				return true;
			}
		}
	}
	else
	{
		for (i = 0; i < Yes.Length; i++)
		{
			if (Yes[i] == p)
			{
				return true;
			}
		}
	}

	return false;
}

function ConcludeVote()
{
	local Rx_Game G;

	G = `RxGameObject;

	if(VotingIn)
	{
		G.RxLog("VOTE" `s "Results;" `s TeamTypeToString(ToTeam) `s class `s "fail" `s "Cancelled by candidate" );
		G.CTextBroadcast(ComC.GetTeamNum(),"-Vote Cancelled :"@ComC.PlayerReplicationInfo.PlayerName@"declined to be the Commander-",'Red');
		Rx_PRI(ComC.PlayerReplicationInfo).DisallowCommander();
	}
	else
	{
		G.RxLog("VOTE" `s "Results;" `s TeamTypeToString(ToTeam) `s class `s "pass" `s "approved by Commander" );
		G.CTextBroadcast(ComC.GetTeamNum(),"-"$ComC.PlayerReplicationInfo.PlayerName@"abdicated willingly-");
		Execute(G);
	}

	G.DestroyVote(self);

}

static function ModifyVote(Rx_Controller RxC, out String out_content, out int out_yes, out int out_no, out int out_yesNeeded, out int out_timeLeft)
{
	if(Rx_GRI(RxC.WorldInfo.GRI).VoteExtraParams[RxC.GetTeamNum()] ~= "Election" && RxC.PlayerReplicationInfo == Rx_GRI(RxC.WorldInfo.GRI).VoteSubject[RxC.GetTeamNum()] && out_content != "")
		out_content $=  ". Vote 'No' twice to decline";

	else if(Rx_GRI(RxC.WorldInfo.GRI).VoteExtraParams[RxC.GetTeamNum()] ~= "Impeachment" && Rx_PRI(RxC.PlayerReplicationInfo).bIsCommander && out_content != "")
		out_content $= ". Vote 'Yes' twice to abdicate";

}


DefaultProperties
{
	HR_Teamname = "NULL"
	MenuDisplayString = "Vote Commander"
}
