class Rx_VoteMenuChoice_Kick extends Rx_VoteMenuChoice;

var int KickID;
var Rx_Controller KickC;

var int KickOption;
var array<int> TargetPlayerIDs;
var array<string> TargetDisplayStrings;

var int CurrentTier;
var int CurrentPlayerPage, MaxPlayerPage;

/*
function PopulateTargets() {
	local GameReplicationInfo GRI;
	local int i;

	// Populate GRI
	GRI = Handler.PlayerOwner.WorldInfo.GRI;

	// Populate result
	for (i = 0; i < GRI.PRIArray.Length; ++i) 
	{
		if(Rx_PRI(GRI.PRIArray[i]) == None)
			continue;
//		if (!GRI.PRIArray[i].bBot) 
//		{
			TargetPlayerIDs.AddItem(GRI.PRIArray[i].PlayerID);
			TargetDisplayStrings.AddItem(GRI.PRIArray[i].PlayerName);
//		}
	}
	MaxPlayerPage = FCeil(float(TargetPlayerIDs.Length) / 8.f);
}
*/
function PopulateTargets() 
{
	local GameReplicationInfo GRI;
	local int i;
	local int KeyNum;

	// Populate GRI
	GRI = Handler.PlayerOwner.WorldInfo.GRI;

	TargetPlayerIDs.Length = 0;
	TargetDisplayStrings.Length = 0;

	// Populate result
	for (i = 0; i < GRI.PRIArray.Length; ++i) 
	{
		if (!GRI.PRIArray[i].bBot) 
		{
			KeyNum = (TargetPlayerIDs.Length % 10) + 1;
			TargetPlayerIDs.AddItem(GRI.PRIArray[i].PlayerID);
			TargetDisplayStrings.AddItem(string(KeyNum) $ "|"$ GRI.PRIArray[i].PlayerName);
		}
	}
}

function array<string> GetDisplayStrings()
{
	local array<string> ret;

	if (CurrentTier == 0)
	{
		ret.AddItem("1|Kick Player");
		ret.AddItem("2|Kick AFKs");
	}
	else if (CurrentTier == 1)
	{
		if (TargetDisplayStrings.Length > 0)
		{
			ret = TargetDisplayStrings;
		}
	}

	return ret;
}

function string SerializeParam()
{
	return string(KickOption) $"\n" $ string(KickID);
}

function ServerInit(Rx_Controller instigator, string param, int t)
{
	super.ServerInit(instigator, param, t);

	if (KickC != None && KickC != VoteInstigator)
		KickC.CTextMessage("A vote kick has been started against you!", 'Red', 180.f, 2.0f, false, true, VoteWarningSound);
}

function DeserializeParam(string param)
{
	local Rx_Controller c;
	local int i;
	
	i = InStr(param, "\n");
	KickOption = int(Left(param, i));

	if(KickOption == 1)
	{
		param = Right(param, Len(param) - i - 1);
		KickID = int(param);

		foreach VoteInstigator.AllActors(class'Rx_Controller', c)
		{
			if (c.PlayerReplicationInfo.PlayerID == KickID)
			{
				if (c.PlayerReplicationInfo.bAdmin || Rx_PRI(c.PlayerReplicationInfo).bModerator)
				{
					VoteInstigator.CTextMessage("You can not kick a moderator.", 'Red');
					break;
				}

				KickC = c;
				break;
			}
		}
		if (KickC == none)
		{
			bPendingDelete = true;
			Rx_Game(VoteInstigator.WorldInfo.Game).DestroyVote(self);
		}
	}
}

function ServerSecondTick(Rx_Game game)
{
	if (KickOption == 1 && KickC == none) game.DestroyVote(self);
	else super.ServerSecondTick(game);
}

function string ComposeTopString()
{
	local string FontColor;

	if (KickOption == 1)
	{
		if(KickC == VoteInstigator)
			return super.ComposeTopString() $ " wants to get out of the game";

		if(KickC.GetTeamNum() == 0)
			FontColor = GDIColor;
		else if(KickC.GetTeamNum() == 1)
			FontColor = NodColor;
		else
			FontColor = HostColor;

		return super.ComposeTopString() $ " wants to kick " $"<font color='" $FontColor $"'>"$ class'Rx_HUD'.static.CleanHTMLMessage(KickC.PlayerReplicationInfo.PlayerName)$"</font>";
	}
	else
	{
		return super.ComposeTopString() $ " wants to kick " $"<font color='" $HostColor $"'>" $"all AFK players" $"</font>";
	}
}

function string ParametersLogString()
{
	if (KickC == None)
		return "";
	return "player" `s `PlayerLog(KickC.PlayerReplicationInfo);
}

function Execute(Rx_Game game)
{
	local Rx_Controller c;

	if(KickOption == 1)
		game.AccessControl.KickPlayer(KickC, "voted to be kicked");
	else
	{
		foreach game.AllActors(class'Rx_Controller', c)
		{
			if (Rx_PRI(c.PlayerReplicationInfo).bisAFK)
			{
				game.AccessControl.KickPlayer(c, "voted to be kicked");
//				break;
			}
		}
	}
}

// TODO: Put this somewhere else so it can be used in a generic way
function KeyPress(byte InputIndex)
{ 
	local int ParsedSelection; 

	if (CurrentTier == 0)
	{
		// accept 1, 2
		if (InputIndex == 1 || InputIndex == 2)
		{
			KickOption = InputIndex;
			if (InputIndex == 1)
			{
				PopulateTargets();
				CurrentTier = 1;
			}
			else
				Finish(); 
		}
	}
	else
	{
//		if(InputIndex == 9)
//		{
//			if(CurrentPlayerPage + 1 < MaxPlayerPage)
//				CurrentPlayerPage++;
//		}

//		else if(InputIndex == 10)
//		{
//			if(CurrentPlayerPage > 0)
//				CurrentPlayerPage--;
//		}

//		else
//		{
			// Get selection index based on input
			ParsedSelection = Rx_HUD(Handler.PlayerOwner.myHUD).IndexForKey(InputIndex)-1;

			// Sanity check selection index
			if (ParsedSelection >= 0 && ParsedSelection < TargetPlayerIDs.Length) 
			{
				KickID = TargetPlayerIDs[ParsedSelection];
				Finish();
			} 
//		}
	}
}

DefaultProperties
{
	MenuDisplayString = "Kick Player"
}
