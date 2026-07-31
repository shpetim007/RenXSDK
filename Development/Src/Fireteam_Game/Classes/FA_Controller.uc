class FA_Controller extends TS_Controller;

reliable client function GotoOutOfTickets()
{
	SetTimer(1.0f, false, 'GoToOOT');
}

function GoToOOT()
{
	GoToState('OutOfTickets');
}

state OutOfTickets extends Spectating
{
	function BeginState(Name PrevState)
	{
		super.BeginState(PrevState);

		SetTimer(0.5, true, nameof(TryRestart));
	}

	function TryRestart()
	{
		ServerRestartPlayer();
	}

	function EndState(Name NextState)
	{
		super.EndState(NextState);

		ClearTimer(nameof(TryRestart));
	}
}

exec function CaptureZone(int ZoneToCapture)
{
	if (ZoneToCapture == 0)
		ZoneToCapture = 1;

	// Convert from zone name (1 is index 0) to index
	ZoneToCapture = Max(0, ZoneToCapture-1);

	`log("Capturing zone"@ZoneToCapture+1@"by command");

	FA_GRI(WorldInfo.GRI).SetActiveZone(ZoneToCapture + 1);
}

exec function AdvanceZone()
{
	FA_GRI(WorldInfo.GRI).SetActiveZone(FA_GRI(WorldInfo.GRI).GetCurrentZone() + 1);
	TS_Game(WorldInfo.Game).MissionManager.ClearObjectives();
	TS_Game(WorldInfo.Game).MissionManager.RemoveCurrentMission();
}

exec function SetTickets(int TeamNum, int NewTotal)
{
	if (TeamNum != 0 && TeamNum != 1)
		return;

	FA_TeamInfo(WorldInfo.GRI.Teams[TeamNum]).SetRespawnTickets(NewTotal);
}

function ActivateEndgameScoreboard()
{
	`warn("Called activate endgame scoreboard not in round end state!");
}

state RoundEnded
{
	ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, TakeDamage, Suicide, DrawHud, ServerRestartPlayer;
	
	function BeginState(Name PreviousStateName)
	{
		if(Com_Menu != none)
		{
			DestroyOldComMenu(); //Kill Vet menu on death	
		}
	
		Super(PlayerController).BeginState(PreviousStateName);
		
		MapVote = -1;
		bFrozen = false;
		// this is a good stop gap measure for any cases that we miss / other code getting turned on / called
		// there is never a case where we want the tilt to be on at this point
		SetOnlyUseControllerTiltInput(FALSE);
		SetUseTiltForwardAndBack(TRUE);
		SetControllerTiltActive(FALSE);

		if (UTGame(WorldInfo.Game) != None)
		{
			// don't let player restart the game until the end game sequence is complete
			SetTimer(FMax(GetTimerRate(), UTGame(WorldInfo.Game).ResetTimeDelay), false);
		}

		bAlreadyReset = false;

		if (myHUD != None)
		{

			if (Rx_HUD(myHUD).HudMovie != none && Rx_HUD(myHUD).HudMovie.bMovieIsOpen)
				Rx_HUD(myHUD).HudMovie.Close(true);

			Rx_HUD(myHUD).HudMovie = none;

			if (!FA_MapInfo(WorldInfo.GetMapInfo()).bUseEndgameCinematic)
			{
				SetTimer(EndgameScoreboardDelay, false, nameof(ShowScoreboard));
				SetTimer(3.0f, false, nameof(FadeOutScoreboard));
				SetTimer(35.0f, false, nameof(CompleteFade));
			}
		}
	}

	function ActivateEndgameScoreboard()
	{
		SetTimer(EndgameScoreboardDelay, false, nameof(ShowScoreboard));
		SetTimer(3.0f, false, nameof(FadeOutScoreboard));
		SetTimer(35.0f, false, nameof(CompleteFade));
	}

	function ShowScoreboard()
	{
		if (Rx_HUD(myHUD) != none)
		{
			if (Rx_HUD(myHUD).Scoreboard == None)
				Rx_HUD(myHUD).SetShowScores(true);
			else
			{
				Rx_HUD(myHUD).Scoreboard.Start();
				Rx_HUD(myHUD).Scoreboard.EndGameScoreboard.SetVisible(true);
				Rx_HUD(myHUD).Scoreboard.ServerName.SetVisible(true);
			}
		}
		
		AutoContinueToNextRound();
	}	
}

exec function Use()
{
    local Rx_HackableInterface hackable;

    super.Use();

    hackable = Rx_HackableInterface(Rx_HUD(myHUD).ScreenCentreActor);
    if (hackable != None) {
        `log("attempt hack"@hackable);
        FA_PRI(PlayerReplicationInfo).ServerHack(Rx_HUD(myHUD).ScreenCentreActor);
    }
}

reliable client function ServerHack(Rx_HackableInterface hackable)
{
	if (FA_TerminalObjective(hackable) != none)
	{
		`log("hacks called on "@hackable);
		FA_TerminalObjective(hackable).hacks(self);
	}
}

exec function ListSpawns()
{
	local Actor Spawn;

	foreach AllActors(class'Actor',Spawn,class'TSIfc_RespawnPoint')
		`log(Spawn@TSIfc_RespawnPoint(Spawn).GetSpawnName()@TSIfc_RespawnPoint(Spawn).RespawnPointAvailableFor(self)@TSIfc_RespawnPoint(Spawn).RespawnPointVisibleFor(self)@Spawn.GetTeamNum()@Spawn.Location);
}

function bool ValidPTUse(Actor PT)
{
	return true;
}

DefaultProperties
{
	PTMenuClass = class'FA_GFxPurchaseMenu_Loadout'
	RespawnPTMenuClass = class'FA_GFxPurchaseMenu_Respawn'
}