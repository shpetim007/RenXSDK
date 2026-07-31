class Rx_CapturableMCT_RadarDome_Internals extends Rx_CapturableMCT_Fort_Internals;

function ChangeTeamReplicate(TEAM ToTeam, optional bool bChangeFlag=false)
{
	super.ChangeTeamReplicate(ToTeam,bChangeFlag); 
	SetTeamVisible(ToTeam);
}

function SetTeamVisible (TEAM ToTeam)
{
	local Controller PC;
	local Rx_Controller TRxPC; 
	local Rx_Bot TRxB; 
	
	//Went in too deep... shoulda' used PRI . May convert later
	foreach AllActors(class'Controller',PC)
	{
		//`log(PC); 
		if(PC.GetTeamNum() != 0 && PC.GetTeamNum() != 1) {
			;
			continue; 
		}
		//Handle Rx_Controllers
		if(Rx_Controller(PC) != none )
		{
			TRxPC = Rx_Controller(PC); 
				if(ToTeam != 0 && ToTeam != 1) 
			{
				TRxPC.SetRadarVisibility(1); 
				continue;
			}
			
			if(TRxPC.GetTeamNum() != ToTeam ) TRxPC.SetRadarVisibility(2); //Set Enemy team visible
			else
			if(TRxPC.GetTeamNum() == ToTeam ) TRxPC.SetRadarVisibility(1);  //Set Friendlies back to invisible on radar 
		}
		
		//Handle Bots
		if(Rx_Bot(PC) != none )
		{
			
			TRxB = Rx_Bot(PC); 
			//`log("SET BOT STATUS " @ TRxB.GetTeamNum() @ ToTeam );
				if(ToTeam != 0 && ToTeam != 1) 
			{
				TRxB.SetRadarVisibility(1); 
				continue;
			}
			
			if(TRxB.GetTeamNum() != ToTeam ) TRxB.SetRadarVisibility(2); //Set Enemy team visible
			else
			if(TRxB.GetTeamNum() == ToTeam ) TRxB.SetRadarVisibility(1);  //Set Friendlies back to invisible on radar 
		}
	}
}

DefaultProperties
{
   
   
}
