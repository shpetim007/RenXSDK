
class Rx_TeamInfo extends UTTeamInfo;

var array<Vehicle>  Vehicles;
var int             vehicleCount;
var int             VehicleLimit;
var int             mineCount;
var int             mineLimit;
var int 			PlayerSize;
var color           TeamColors[3];
var string          TeamNames[3];
var byte            ReplicatedSize;    
var float           LastAttackTime; // to warn every 30sec for attacks on team
var repnotify int   LastAirstrikeTime;
var protected float RenScore;
var protected int   ReplicatedRenScore;
var protected int   Kills;  // total kills for the team
var protected int   Deaths; // total deaths for the team
var protected float	Command_Points, Maximum_CP; //The maximum CP you can have at any given time. Rises with the number of dead buildings you have
var bool			bHarvesterStopped; 
var Rx_Vehicle 		CurrentHarvester;
var bool			bHasHarv;
var bool			bDominating;
var array<Rx_Building_Team_Internals> EnemyBuildings; //Track Enemy buildings for score
var array<int>		PowersOnCoolDown; //Optimization for ticking down support power timers only when necessary
var float			SupportPowerCooldowns[6];
var int				ReplicatedCoolDowns[6]; //Replicated integers so they don't change as constantly 
var const int		MAX_SUPPORT_POWERS; 

replication
{
	
	if( bNetDirty && (Role==ROLE_Authority) )
		ReplicatedSize, vehicleCount, mineCount, ReplicatedRenScore, Kills, Deaths, LastAirstrikeTime, VehicleLimit, mineLimit, Command_Points, Maximum_CP, CurrentHarvester, bHasHarv, bHarvesterStopped, ReplicatedCoolDowns;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'LastAirstrikeTime' )
    {
		LastAirstrikeTime = WorldInfo.TimeSeconds;
    }
    else
    {
		Super.ReplicatedEvent(VarName);
	}
}


/** vehicle creation */
function addVehicle(Vehicle V)
{
   Vehicles.AddItem(V);
}

simulated function int GetVehicleCount()
{
	return VehicleCount;
}

simulated function string GetTeamName()
{
   return default.TeamNames[TeamIndex];
}

function Initialize(int NewTeamIndex)
{
	TeamIndex = NewTeamIndex;
}

simulated function byte GetTeamNum()
{
   return TeamIndex;
}

simulated function string GetHumanReadableName()
{
    return default.TeamNames[TeamIndex];
}

simulated function color GetHUDColor()
{
    return default.TeamColors[TeamIndex];
}

function color GetTextColor()
{
    return default.TeamColors[TeamIndex];
}

simulated function color GetTeamColor()
{
   return default.TeamColors[TeamIndex];
}

function bool AddToTeam( Controller Other )
{
   local bool bRet;
   
   bRet = super.AddToTeam(Other);
   if (Rx_Bot_Scripted(Other) == None && bRet && Other.bIsPlayer && Rx_PRI(Other.PlayerReplicationInfo) != None) {
      	ReplicatedSize++; // here we go.. replicated team size for everyone
    	Rx_PRI(Other.PlayerReplicationInfo).SetCredits( Rx_Game(WorldInfo.Game).InitialCredits );   
	    if(Rx_Game(WorldInfo.Game).TeamCredits[TeamIndex].PlayerRI.Find(Rx_PRI(Other.PlayerReplicationInfo)) < 0)
	    	Rx_Game(WorldInfo.Game).TeamCredits[TeamIndex].PlayerRI.AddItem(Rx_PRI(Other.PlayerReplicationInfo));
   }
   Size = ReplicatedSize;

   if(PlayerController(Other) != None && !Other.PlayerReplicationInfo.bOnlySpectator)
  	 PlayerSize++;
   return bRet;
}

function RemoveFromTeam(Controller Other)
{
	if (Rx_Bot_Scripted(Other) == None && Other.bIsPlayer)
	{
	   ReplicatedSize--;
   		Rx_Game(WorldInfo.Game).TeamCredits[TeamIndex].PlayerRI.RemoveItem(Rx_PRI(Other.PlayerReplicationInfo));
   	}
	super.RemoveFromTeam(Other);
	Size = ReplicatedSize;

   if(PlayerController(Other) != None && !Other.PlayerReplicationInfo.bOnlySpectator)
  	 PlayerSize--;
}

function DecreaseVehicleCount(optional class<Rx_Vehicle> VehicleClass) 
{
	vehicleCount = Max(vehicleCount - 1, 0);
}

function IncreaseVehicleCount(optional class<Rx_Vehicle> VehicleClass) 
{
	vehicleCount++;
}

simulated function bool IsAtVehicleLimit()
{
	if (vehicleCount == VehicleLimit)
	{
		return true;
	}
	return false;
}

simulated function int GetDisplayRenScore()
{
	return ReplicatedRenScore;
}

simulated function int GetRenScore()
{
	return ReplicatedRenScore;
}

//Called by buildings when they die to get rid of any weird precision errors
function RoundUpRenScore() 
{
	RenScore = FCeil(RenScore);
	ReplicatedRenScore = RenScore;
}

function UpdateAOWScore() 
{
	local Rx_Building_Team_Internals BuildInternals; 
	local float TotalScore;

	//Populate team buildings
	if(EnemyBuildings.Length == 0)
	{
		foreach WorldInfo.AllActors(class'Rx_Building_Team_Internals', BuildInternals)
		{
			if(BuildInternals.GetTeamNum() == GetTeamNum() ||  Rx_Building_TechBuilding_Internals(BuildInternals) != none)
				continue;
			
			EnemyBuildings.AddItem(BuildInternals);
			
			TotalScore+=BuildInternals.GetAOWScoreValue(); 
		}
	}
	else
	{
		foreach EnemyBuildings(BuildInternals)
		{
			TotalScore+=BuildInternals.GetAOWScoreValue();  
		}
	}

	RenScore = TotalScore;
	ReplicatedRenScore = int(TotalScore);
}

function AddRenScore( float inScore, optional bool bBuildingDamage)
{
	local Rx_Game RXG; 

	RXG = Rx_Game(WorldInfo.Game);

	if((!RXG.bTeamScoreIsBuildingDamage) || (RXG.bTeamScoreIsBuildingDamage && bBuildingDamage ))
	{
		RenScore += inScore;
		ReplicatedRenScore = RenScore;

	if(RXG.PointsToWinBy > 0)
	{
		RXG.EvaluatePoints();
	}

		if (RXG.UpcomingScoreEvent != None && RXG.UpcomingScoreEvent.ScoreRequired < RenScore)
		{
			RXG.UpcomingScoreEvent.ScoreReached(self);
			RXG.UpcomingScoreEvent = RXG.UpcomingScoreEvent.Next;
		}
	}
}

simulated function AddKill( optional int numKills = 1 )
{
	Kills += numKills;
}

simulated function int GetKills()
{
	return Kills;
}

simulated function AddDeath( optional int numDeaths = 1)
{
	Deaths += numDeaths;
}

simulated function int GetDeaths()
{
	return Deaths;
}

simulated function float GetKDRatio()
{
	if (Deaths == 0)
	{
		return Kills;
	} 
	else
	{
		return float(int((float(Kills)/float(Deaths)) * 100) / 100);
	}	
}

function bool BotNameTaken(string BotName)
{
//	local int i;
	local PlayerReplicationInfo PRI;

	ForEach WorldInfo.GRI.PRIArray(PRI)
	{
		if (UTPlayerReplicationInfo(PRI) != None && UTPlayerReplicationInfo(PRI).PlayerName == BotName)
			return true;
	}

	return false;
}

/*Command Points*/
simulated function float GetCommandPoints()
{
	return Command_Points; 
}

simulated function AddCommandPoints(float CP, optional string AddMessage = "")
{
	local Rx_PRI CommandersPRI; 
	Command_Points=fmin(Command_Points+CP, Maximum_CP);  
	
	if(ROLE == ROLE_Authority && AddMessage != "") 
	{
		CommandersPRI = Rx_Game(WorldInfo.Game).Commander_PRI[GetTeamNum()];
		if(CommandersPRI != none) Rx_Controller(CommandersPRI.Owner).ClientSendFeelGoodMessage(AddMessage,"CP") ;
	}
}

function InitCommandPoints(float MaxNum, float Num)
{
	Maximum_CP = MaxNum; 
	Command_Points = Num;
}

simulated function float GetMaxCommandPoints()
{
	return Maximum_CP; 
} 

function ToggleHarvStopped()
{
	bHarvesterStopped = bHarvesterStopped ? false : true; 
}

function bool bGetHarvStopped(){
	return bHarvesterStopped;
}

function SetDominating(bool bNewDominate)
{
	bDominating = bNewDominate; 
}

function bool GetDominating()
{
	return bDominating; 
}

simulated function bool GetPowerOnCoolDown(int CheckNum)
{
	return WorldInfo.NetMode == NM_Client ? ReplicatedCoolDowns[CheckNum] > 0: SupportPowerCooldowns[CheckNum] > 0;
}

function SetPowerOnCoolDown(int CheckNum)
{
	if(CheckNum >= MAX_SUPPORT_POWERS)
		SetAllPowersOnCoolDown(true);

	SupportPowerCooldowns[CheckNum] = GetPowerCoolDown(CheckNum) ;
	PowersOnCoolDown.AddItem(CheckNum);
}

simulated function float GetPowerCoolDown(int CheckNum)
{
	if(GetTeamNum() == 0)
	{
		return class'Rx_CommandMenuChoice_SupportPowers'.default.GDI_SP[CheckNum].CooldownTime ;
	}
	else
	{
		return class'Rx_CommandMenuChoice_SupportPowers'.default.Nod_SP[CheckNum].CooldownTime ;
	}
}

simulated function float GetPowerCurrentCoolDown(int CheckNum)
{
	if(WorldInfo.NetMode == NM_Client)
		return ReplicatedCoolDowns[CheckNum];
	else
		return SupportPowerCooldowns[CheckNum];
}

function SetAllPowersOnCoolDown(optional bool bBadFaith=false)
{
	local int i; 

	if(ROLE == ROLE_AUTHORITY)
		for(i=0;i<MAX_SUPPORT_POWERS;i++) {
			SupportPowerCooldowns[i] = bBadFaith ? 9999.0 : GetPowerCooldown(i);
			ReplicatedCoolDowns[i] =  bBadFaith ? 9999.0 : GetPowerCooldown(i);
			if(PowersOnCoolDown.Find(i) == -1)
				PowersOnCoolDown.AddItem(i);
		}
}

function TickPowerCoolDowns(float DeltaTime)
{
	local int i; 
	if(PowersOnCoolDown.Length > 0)
	{
		for(i=PowersOnCoolDown.Length-1; i>=0; i--)
		{
			SupportPowerCooldowns[PowersOnCoolDown[i]] = fmax(0, SupportPowerCooldowns[PowersOnCoolDown[i]]-1.0); 
			
			if(WorldInfo.NetMode == NM_DedicatedServer)
				ReplicatedCoolDowns[PowersOnCoolDown[i]] = SupportPowerCooldowns[PowersOnCoolDown[i]];
			
			if(SupportPowerCooldowns[PowersOnCoolDown[i]] <= 0.0) 
				PowersOnCoolDown.Remove(i,1);
		}
	}
}

defaultproperties
{
	TeamNames(0)="GDI"
	TeamNames(1)="Nod"
	TeamNames(2)="Civilians"
	TeamIndex=2
	TeamColors(0)=(B=0,G=198,R=255,A=255)
	TeamColors(1)=(B=0,G=0,R=255,A=255)
	TeamColors(2)=(B=230,G=230,R=230,A=255)
	Name="Renegade_TeamInfo"
	bAlwaysRelevant=true
	LastAirstrikeTime=0

	MAX_SUPPORT_POWERS = 6
}
