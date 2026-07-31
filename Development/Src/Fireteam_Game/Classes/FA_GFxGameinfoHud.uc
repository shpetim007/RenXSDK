class FA_GFxGameinfoHud extends TS_GFxGameinfoHud;

var GFxObject BottomInfo_Stats;
var GFxObject PowerLabel, PowerCounter;
var GFxObject TCLabel, TCCounter;
var GFxObject TeamStatusMC[2];

exec function InitializeHUDVars()
{
	super.InitializeHUDVars();

	BottomInfo_Stats	= GetVariableObject("_root.BottomInfo.Stats");
	PowerLabel			= BottomInfo_Stats.GetObject("MinesLabel");
	PowerCounter		= BottomInfo_Stats.GetObject("Mines");
	TCLabel				= BottomInfo_Stats.GetObject("CPLabel");
	TCCounter			= BottomInfo_Stats.GetObject("CP");
	PowerLabel.SetVisible(false);
	PowerCounter.SetVisible(false);
	TCLabel.SetVisible(false);
	TCCounter.SetVisible(false);
}

function SetupScoreboard()
{
	super.SetupScoreboard();

	TeamStatusMC[0] = Scoreboard.GetObject("TeamStatus0");
	TeamStatusMC[1] = Scoreboard.GetObject("TeamStatus1");

	TeamBaseMC[0] = TeamStatusMC[0].GetObject("Team0Base");
	TeamBaseMC[1] = TeamStatusMC[1].GetObject("Team1Base");

	TeamStatusMC[0].SetVisible(false);
	TeamStatusMC[1].SetVisible(false);
}

function TickHUD()
{
	local Pawn MyPawn;
	local Rx_PRI TempPRI;

	if (!bMovieIsOpen || bIsPriorityHidden) {
		return;
	}

	if( RxPC == None)
		RxPC = Rx_Controller(GetPC());

	if (RxPC == None) 
	{
		return;
	}
	else
	{
		if (RxPC.IsSpectating() && Pawn(RxPC.ViewTarget) != None)
			TempPRI = Rx_PRI(Pawn(RxPC.ViewTarget).PlayerReplicationInfo);
		else
			TempPRI = Rx_PRI(RxPC.PlayerReplicationInfo);

		if(RxPRI == None || RxPRI != TempPRI)
		{
			RxPRI = TempPRI;
		}

		if(RxGRI == None)
			RxGRI = Rx_GRI(RxPC.WorldInfo.GRI);	
	}

	if(RxPC.IsSpectating() && Pawn(RxPC.ViewTarget) != None)
		MyPawn = Pawn(RxPC.ViewTarget);
	else
		MyPawn = RxPC.Pawn;

	if (MyPawn != None)
	{
		if (bPlayerDead)
		{
			bPlayerDead = false;
			SetLivingHUDVisible(true);
		}
	}
	else
	{
		if (!bPlayerDead)
		{
			bPlayerDead = true;
			SetLivingHUDVisible(false);
		}		
	}

	if (Scoreboard != None)
		UpdateScoreboard();

	if (!bBuildingSetup)
		SetupBuildings();
	else
	{
		if(RxPC.WorldInfo.TimeSeconds - LastBuildingUpdateTime > 0.5)
		LastBuildingUpdateTime = RxPC.WorldInfo.TimeSeconds;
		if(IsBuildingAmountMismatched()) // if there's a mismatch in building number, reupdate 
		{
			bBuildingSetup = false;
		}
	}

	if (RxPRI != none)
	{
		if(!RxPC.IsSpectating())
		{
			UpdateCredits(RxPRI.GetCredits());
		}
		else if(Pawn(RxPC.ViewTarget) != None) 
		{
			UpdateCredits(Rx_PRI(Pawn(RxPC.ViewTarget).PlayerReplicationInfo).GetCredits());	
		}
	}

	HandleCapturePoints();

	UpdateTicketsGFx();
}

function UpdateDominationTime()
{
	if (FA_TeamInfo(RxPC.WorldInfo.GRI.Teams[0]).IsAttacker())
	{
		TeamStatus[0].SetText(FA_TeamInfo(RxPC.WorldInfo.GRI.Teams[0]).GetTickets());
		
	}
	else
	{
		TeamStatus[1].SetText(FA_TeamInfo(RxPC.WorldInfo.GRI.Teams[1]).GetTickets());
		
	}
}

function UpdateTicketsGFx()
{
	if (FA_TeamInfo(RxPC.WorldInfo.GRI.Teams[0]).IsAttacker())
	{
		TeamStatusMC[0].SetVisible(true);
	}
	else
	{
		TeamStatusMC[1].SetVisible(true);
	}
}

DefaultProperties
{
	MovieInfo           = SwfMovie'FAHud.FAGameinfoHud'
}