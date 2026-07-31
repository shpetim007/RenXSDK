/**
 * RxGame
 *
 * */
class Rx_Game extends UTTeamGame
	config(RenegadeX);

`define SupressNullDamageType(Statement) if (DamageType != class'DamageType') `Statement
`define GAMEINFO(dummy)
`include(RenX_Game\RenXStats.uci);
`undefine(GAMEINFO)

/** one1: Current vote in progress. */
var Rx_VoteMenuChoice GlobalVote;
var Rx_VoteMenuChoice GDIVote;
var Rx_VoteMenuChoice NODVote;
var float VotePersonalCooldown;
var float VoteTeamCooldown_GDI, VoteTeamCoolDown_Nod, NextChangeMapTime_GDI, NextChangeMapTime_Nod;
var bool IgnoreGameServerVersionCheck;

var config bool bUnlockCheatingBots;
var config bool bFixedMapRotation;
var Rx_LANBroadcast LANBroadcast;
var OnlineGameSettings GameSettings;
var globalconfig bool bRemoveVariantMapsInVoteList;

var globalconfig array<string> MapHistory; // In order of most recent (0 = Most Recent)
var int MapHistoryMax; // Max number of recently played maps to hold in memory

var bool bCreditsFromKillScore;

struct MapPlayerNumLimits
{
	var string MapName;
	var int MapMinPlayers;
	var int MapMaxPlayers;
};
var globalconfig array<MapPlayerNumLimits> MapsWithPlayerNumLimits;

var config float FirstMinuteThreshold;
var config float FirstMinuteMaxIdleTime;

var config int RecentMapsToExclude;
var config int MaxMapVoteSize;
var config int CnCModeTimeLimit;
var config int DMModeTimeLimit;
var globalconfig float TeamMmrAnnouncementInterval;
var config int MapVoteTime; // replaces EndGameDelay *Tommy
var int VPMilestones[10]; //Config
var int MaxInitialVeterancy; //Maximum veterancy you can be given at the beginning of a game
var float CurrentBuildingVPModifier[2]; //Modifier based on number buildings currently destroyed. 1st building kill awards the least, and gradually rises with each kill
var int CreditTickRate; // Frequency in seconds that credit ticks occur
var private float CreditTickTimer;
var float MaxBuildingVPMod; 

/** Team Numbers in handy ENUM form */
enum TEAM
{
	TEAM_GDI,
	TEAM_NOD,
	TEAM_UNOWNED
};

struct TeamCreditStruct
{
	var array<RxIfc_Refinery> Refinery;
	var array<Rx_PRI> PlayerRI;
};

var class<UTHudBase>					HudClass;
var float								EndGameDelay; //legacy float, use MapVoteTime instead *Tommy
var float								RenEndTime;
var int									MineLimit;
var globalconfig int 							VehicleLimit;
var	SoundCue							BoinkSound;

struct MapMineAndVehLimit
{
	var name MapName;
	var int MineLimit;
	var int VehicleLimit;
};
var globalconfig array<MapMineAndVehLimit> MapSpecificMineAndVehLimit;

var bool                                bAddRepGunDefenderNOD;
var bool                                bAddRepGunDefenderGDI;

var TeamCreditStruct                    TeamCredits[2]; // stores PRI's and ref for GDI(0) and Nod(1)

var int				                    MaxPlayerNameLength;
var array<string>                       DisallowedNames;

var config int                          InitialCredits;  // the initial credits a player gets when they spawn in
//var config float                        CreditTickRateModifier; // How much faster or slower do we tick credits (not implemented)
var config bool	                        SpawnCrates; // whether or not to spawn crates in this game
var config float                        CrateRespawnAfterPickup; // interval for crate respawn (after pickup)
var config bool                         bBotsDisabled;
var config bool 						bBotVotesDisabled;
var config int                          DonationsDisabledTime;
var config float						MaxServerUptime;

var config bool                         bReserveVehiclesToBuyer;
var config bool							bAllowPowerUpDrop;
var config bool 						bUsePedestal;
var int									RTC_DisableTime; //Amount of time changing teams [sans admin forcing team changes] is disabled. 0 is never ADD TO CONFIG

//Surrender Specific Variables
var config int 	SurrenderDisabledTime;
var bool bGDIHasSurrendered, bNodHasSurrendered ;
var int SurrenderStartTime ;
var config int SurrenderLength; //How long till a surrender vote actually ends the game.
var bool bCountingToSurrender; //Are we counting down rapidly now?
var config bool bEnableAirdrops; 
var globalconfig bool bSurrenderAtTimeLimit; 

//ChangeMap
var config int 	ChangeMapDisabledTime;

// Automatically kicking AFKs. See AutoKickAFKTimer for explanation.
var config bool bAutoKickAFKEnabled;
var config float AutoKickAFKMinimumServerFullSeconds;
var config float AutoKickAFKMinimumCurrentAFKSeconds;
var config float AutoKickAFKMinimumTotalAFKSeconds;
var float MaxPlayersStartTime; // Timestamp when server hit capacity. Meaningless if server is not at capacity.
var float AutoKickAFKCheckInterval; // How often to check to kick AFKs.

//Bounty Variables

struct BountyList
{
	var string RankName;
	var int Threshold;
	var float CreditsBase;
	var float CreditsMult;
	var float VPBase;
	var float VPMult;
};

var config Array<BountyList> BountyRankList;
var config int BountyPermaspotRank;

var class<Rx_PurchaseSystem>			PurchaseSystemClass, HelipadPurchaseSystemClass;
var Rx_PurchaseSystem                   PurchaseSystem;
var class<Rx_VehicleManager>			VehicleManagerClass, HelipadVehicleManagerClass;
var Rx_VehicleManager                   VehicleManager;
var class<Rx_TeamInfo>					TeamInfoClass;
var Rx_PlayerMonitor					PlayerMonitor;
var class<Rx_PlayerMonitor>				PlayerMonitorClass;
var Rx_FPSMonitor                       FPSMonitor;
var class<Rx_FPSMonitor>                FPSMonitorClass;
var bool							    bCanPlayEvaBuildingUnderAttackGDI;
var bool							    bCanPlayEvaBuildingUnderAttackNOD;
var byte						        WinnerTeamNum;
var Rx_Building_Nod_Defense				Obelisk;
var Rx_Building_GDI_Defense				AGT;
var int SmokeScreenCount;   // Optimisation - Used to track if there is an active SmokeScreen and allows AI to skip traces for SmokeScreens if there are none.

var Rx_ServerListQueryHandler ServiceBrowser;
var Rx_VersionQueryHandler VQueryHandler;

var const float EndgameCamDelay, EndgameSoundDelay;

var bool bHasPlayArea, bHasDenyArea;

var Rx_AuthenticationService authenticationService;
var config bool bHostsAuthenticationService;

/**Provides Map Information stored in the .ini file. (expensive to get, so cache here). */
var array<Rx_UIDataProvider_MapInfo> MapDataProviderList;

/** Name of the class that manages maplists and map cycles */
var string MapListManagerClassName;
var Rx_MapListManager MapListManager;

// Skirmish options:
var int AFKPlayers[2];
var int GDIBotCount;
var int NODBotCount;
var int GDIDifficulty;
var int NODDifficulty;
var int PlayerTeam;
var int NodAttackingValue;
var int GDIAttackingValue;
var bool bInitialBotsCreated; //Checks if the initial bot number was created in Skirmish, so it won't create them 4 times over.

var int Port;
var config array<string> SteamLogins;

var config bool bIsCompetitive;
var config bool bFillSpaceWithBots;
var bool bIsClanWars;
var Rx_MatchInfo MatchInfo;

var array<Rx_CratePickup> AllCrates;

/** Does the server allow non-admin clients to PM each other. */
var config bool bAllowPrivateMessaging;
/** Restrict PMing to just teammates. */
var config bool bPrivateMessageTeamOnly;

// Determines how teams are organized between matches. 0 = static, 1 = swap, 2 = random swap, 3 = shuffle, 4 = traditional (assign as players connect), 5 = traditional + free swap, 6 = ladder rank
var config int TeamMode;
var array<string> JoinedPlayerIDs;

var int buildingArmorPercentage; //Always 50 if enabled

var bool UsePurchaseSystem; //Should gamemode setup the purchase system

var config bool bListed;
var config string TravelURL;
var config bool bFailover;

var int RTC_TimeLimit;

struct ServerInfo
{
	var string ServerName;
	var string NamePrefix;
	var string ServerIP;
	var string ServerPass;
	var string ServerPort;
	var int GameType;
	var string Mapname;
	var string GameVersion;
	var int NumPlayers;
	var int MaxPlayers;
	var bool Ranked;
	var int Ping;
	var bool bInGame;
	var bool bPassword;

	//nBab
	var int VehicleLimit;
	var int MineLimit;
	var int TimeLimit;
	var bool SteamRequired;
	var bool CratesEnabled;
	var int TeamMode;
	var bool isLAN; //Is this server a local area network server (rather than internet).
};

var array<ServerInfo> ListServers;
//var string ServerListRawData;

/**@Shahman: Version of this build*/
var globalconfig string GameVersion;
/**@Shahman: Game Version Number*/
var globalconfig int GameVersionNumber;
/**@MPalko: Retrieves latest version from the website*/

var int GameType; // < 0 = Invalid, 0 = Rx_Game_MainMenu, 1 = Rx_Game, 2 = TS_Game, 3 = SP_Game, [3, 1000) = RenX Unused/Reserved, [1000, 2^31 - 1] Unassigned / Mod space

var config bool bLogRcon;

var globalconfig bool bDisableDemoRequests;
var bool ClientDemoInProgress;

var bool bForceNonSeamless;

var array<class<Rx_ScoreEvent> > ScoreEvents;
var Rx_ScoreEvent UpcomingScoreEvent;
var Rx_ScoreEvent LastScoreEvent;

var array<class<Rx_PickUp> > PowerUpClasses;

enum BuildingCheck
{
	BC_TeamsHaveBuildings,
	BC_GDIDestroyed,
	BC_NodDestroyed,
	BC_TeamsHaveNoBuildings
};

var class<Rx_CommanderController> CommanderControllerClass;
var Rx_CommanderController CommanderController; //TODO ...... basically all of this

//var Rx_SystemSettingsHandler SystemSettingsHandler;

//var array<string> GDI_SpotMarkers, Nod_SpotMarkers; //Capture a list of spot markers at the beginning of the game to determine which ones are GDI/Nod-based.

//Awards [0 for GDI  1 for Nod]
var Rx_PRI Award_MVP[2], Award_Offense[2], Award_Defense[2], Award_Support[2];

/**Team Management**/

struct TC_Request
{
	var Rx_PRI PPRI;
	var int TimeStamp;
};

var array<TC_Request> RTC_GDI, RTC_Nod;

/*****************************************
*Remember the Commander stuff?? Okay let's finally do that (2+ years later)
******************************************/

var config bool bEnableCommanders; //, bEnableSupportPowers, bEnableSquads, bEnableObjectives ; //Self explanatory
var Rx_PRI Commander_PRI[2]; //Hold the PRI of the commander(s?) 0 for Geeds 1 for Nod
var config int		InitialCP, Max_CP;
var array<PlayerReplicationInfo> TargetedPlayers_GDI, TargetedPlayers_Nod;
var int			CP_TickRate;
var int			LastDecayMsgTime[2];
var int			CPReward_Emplacement, CPReward_Infantry, CPReward_Vehicle;

var config bool bUseStaticCommanders;

var int DestroyedBuildings_Nod, DestroyedBuildings_GDI;

var config float BotAutoWarningThreshold;

//Optimizations
var config bool bVehiclesAlwaysRelevant, bInfantryAlwaysRelevant;

var Rx_StatAPI StatAPI;

/*****************************************
*End of significantly less complicated Commander things
******************************************/

var int Defence_IDs; //Hold and create the ID's for Rx_Defences so they can stop being stupid to work with for client > server
var int Scripted_IDs;
var config int MinPlayersForNukes;

//Score System
var config bool		bUseLegacyScoreSystem;
var Rx_GameObjective	FirstObjective, PrevO;	//I know it doesn't make sense to put PrevO here, but if I put it on local, it'll give warning :/

var bool bPedestalDetonated;
var byte PedestalDetonator;
var bool bAllowDeployedDefenceKills;

/*****************************************
*Game ending sequence stuff
******************************************/
var bool bGameAboutToEnd;
var Actor GameAboutToEndFocus;
/*****************************************
*Auto balancing
******************************************/
var globalconfig bool bAutoBalancerEnabled;
var globalconfig bool bWasAutoBalancerEnabled;
var globalconfig bool bAutoBalanceForced;//Enable swap on death
var bool bCurrentlyShuffling;
var globalconfig int AutobalanceThreshold;
var globalconfig float AutoBalanceCreditReward;
var globalconfig float AutoBalanceVpReward;
var globalconfig float TimeTillFirstAutoBalance;//Time till autobalance is allowed //Seconds // After game starts
var globalconfig float AutoBalanceCooldown;//Cooldown between attempts //Seconds
var globalconfig float AutoBalanceMaximumRewardTime;//Time in game when max reward can be given
var bool bAutoBalanceCurrentlyAllowed;//Used to denote points when autobalance is not allowed even when enabled
var float GameStartTime;//used to denote how much of the reward should be given
var globalconfig bool bMercyImportantGameObject;//Show mercy if the player has placed down a nuke
var globalconfig int bMercyScoreThreshold;//Show mercy if they have scored more than this
var globalconfig bool bMercyPreviouslyBalanced;//Don't balance someone if we balanced them last time
var globalconfig int AutoBalanceDuration;//How long should the auto balance attempt last, 0 for forever
var globalconfig bool bAutoBalanceRewardVp;//if we should reward vp instead of credits
var bool bAutoBalanceSwapOnDeath;//used to provide a warm up period for the first ten seconds to allow volunteers to switch
var array<int> LastBalancedPlayerIds;

/*****************************************
*
******************************************/
var SoundCue BountyWarnSound;
var const int MaxVetRank;

/* New AOW variables (Should all be exposed in config*/
var globalconfig bool bEnableOverTime;
var globalconfig bool bWasOverTimeEnabled;
var globalconfig bool bWasLastGameTDM;
var globalconfig float OverTimeTimeLimit, SuddenDeathTimeLimit;

var globalconfig bool bBuildingsRevive; //Should ALWAYS be false for Marathon, unless you're a masochist
var globalconfig float BuildingReviveTime; //In Seconds
var globalconfig bool bTeamScoreIsBuildingDamage; 
var globalconfig bool bWasTeamScoreIsBuildingDamage; 
var globalconfig bool bStructuresAutoRevive; //Should structures automatically revive when the timer hits 0?

enum eOverTimeState {
	E_Regulation,
	E_Overtime,
	E_DoubleOverTime,
}; 

var eOverTimeState OverTimeState;
var globalconfig int PointsToWinBy;
var globalconfig float SuddenDeath_DmgMult; 

var SoundCue OverTimeStartSound[2]; //Start Sounds for when Overtime begins
var SoundCue SuddenDeathStartSound; //Start Sounds for when Overtime begins
var SoundCue TwoMinuteWarnSound; 

//Overtime/SD Marquees 
var Texture2D T_Marquee_OT; 
var Texture2D T_Marquee_SD; 
var Texture2D T_Marquee_2MW;
var Texture2D T_Marquee_5MW;
var Texture2D T_Marquee_Domination[2];
var Texture2D T_Marquee_LostDomination[2];

//Marquees for Game modes
var Texture2D T_Marquee_AOW;
var Texture2D T_Marquee_Marathon;


var bool bWarnedTwoMinutes; 
var bool bWarnedFiveMinutes; 

/* Variables for map vote control */
var globalconfig bool bAdminsStartMapVote; //If true then end-game map-votes aren't starte till admins use a command to start it
var bool bStartRestarting; 

var globalconfig bool bShowOtherGameTypes;

delegate NotifyServerListUpdate();

function PreBeginPlay()
{
	local class<Rx_GameplayEventsWriter> GameplayEventsWriterClass;
	local color C;
	local Rx_Building B;

	// Map change fixes all time issues, so we can stop this countdown.
	if(IsTimerActive(nameof(ServerIsOnlineForTooLong)))
		ClearTimer(nameof(ServerIsOnlineForTooLong));

	//Optionally setup the gameplay event logger
   if (bLogGameplayEvents && GameplayEventsWriterClassName != "")
   {
      GameplayEventsWriterClass = class<Rx_GameplayEventsWriter>(FindObject(GameplayEventsWriterClassName, class'Class'));
      if ( GameplayEventsWriterClass != None )
      {
         `log("Recording game events with"@GameplayEventsWriterClass);
         GameplayEventsWriter = new(self) GameplayEventsWriterClass;
         //Optionally begin logging here
         GameplayEventsWriter.StartLogging(0.5f);
      }
      else
      {
         `log("Unable to record game events with"@GameplayEventsWriterClassName);
      }
   }
   else
   {
      `log("Gameplay events will not be recorded.");
   }

	Super.PreBeginPlay();

	`RecordGameIntStat(MATCH_STARTED,1);
	`RecordGameStringStat(GAME_CLASS,"RenX");

	GameSettings = OnlineSub.GameInterface.GetGameSettings(WorldInfo.Game.PlayerReplicationInfoClass.default.SessionName);

	if(GameSettings == none)
		`log("GameSettings is none");
	else
		`log("bIsLanMatch: "@GameSettings.bIsLanMatch);

	if((WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer) && GameSettings != none && GameSettings.bIsLanMatch)
	{
		LANBroadcast.start(true);
		SetTimer(1, true, 'SendLANBroadcast');
	}

	if(WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer)
	{
		FPSMonitor = Spawn(FPSMonitorClass, self,'FPSMonitor',Location,Rotation);
	}

	if ( Role == ROLE_Authority )
	{
		ForEach `WorldInfoObject.AllActors(class'Rx_Building', B)
		{
			if (Rx_Building_Helipad_Nod(B) != None || Rx_Building_Helipad_GDI(B) != None)
			{
				VehicleManagerClass = HelipadVehicleManagerClass;
				PurchaseSystemClass = HelipadPurchaseSystemClass;
			}
		}

		`log("spawning purchase system"@PurchaseSystemClass);
		PurchaseSystem = spawn(PurchaseSystemClass, self,'PurchaseSystem',Location,Rotation);
		VehicleManager = spawn(VehicleManagerClass, self,'VehicleManager',Location,Rotation);

		PurchaseSystem.SetVehicleManager(VehicleManager);

		PlayerMonitor = spawn(PlayerMonitorClass, self,'PlayerMonitor',Location,Rotation);
	}

	if(Rx_MapInfo(WorldInfo.GetMapInfo()).MapBotType == navmesh)
		BotClass = class'RenX_Game.Rx_Bot_Mesh';

	`log("Rx_Game::PreBeginPlay"@`showvar(BotClass) @ bInfantryAlwaysRelevant);


	Teams[TEAM_GDI].AI.EnemyTeam = Teams[TEAM_NOD];
	Teams[TEAM_NOD].AI.EnemyTeam = Teams[TEAM_GDI];

	c.R=255;
	Teams[TEAM_NOD].TeamColor = c;
	c.G=255;
	Teams[TEAM_GDI].TeamColor = c;


	`RecordTeamStringStat(CREATED, Teams[TEAM_GDI], "Ready");
	`RecordTeamStringStat(CREATED, Teams[TEAM_NOD], "Ready");


	VehicleManager.Initialize(self, Teams[TEAM_GDI], Teams[TEAM_NOD]);

	if(bHostsAuthenticationService) {
		authenticationService = Spawn(class'Rx_AuthenticationService');
	}

	if (ServiceBrowser == None && WorldInfo.NetMode == NM_StandAlone)
	{
		ServiceBrowser = new(self)class'Rx_ServerListQueryHandler';
	}

	/* Spawn our Rx_VersionQueryHandler, so we can access it from external classes and use it's functions. */
	if (VQueryHandler == None && WorldInfo.NetMode == NM_StandAlone)
	{
		VQueryHandler = new(self)class'Rx_VersionQueryHandler';
		VQueryHandler.GetFromServer();
	}

// 	// Create our Graphic Adapter check class.
// 	GraphicAdapterCheck = Spawn(class'Rx_GraphicAdapterCheck');
// 	GraphicAdapterCheck.CheckGraphicAdapter();

	ListServers.length = 0;

	//Create our systemsettingshandler here
	//SystemSettingsHandler = Spawn(class'Rx_SystemSettingsHandler');

	MaxMapVoteSize = Clamp(MaxMapVoteSize, 1, 14);
	RecentMapsToExclude = Clamp(RecentMapsToExclude, 0, 14);


	//Get out map info here
	SetupMapDataList();
}

function GoToWarmupStandy()
{
	local Actor A;

	ForEach WorldInfo.AllActors(class'Actor', A)
	{
		if (Rx_Vehicle(A) != None && Rx_Defence(A) == None)
			A.Destroy();

		if (Rx_Weapon_DeployedActor(A) != None)
			A.Destroy();
	}
}

function WarmupStandbyComplete()
{
	local Rx_Building_Refinery Ref;

	ForEach WorldInfo.AllActors(class'Rx_Building_Refinery', Ref)
	{
		Ref.RequestHarvester();
	}
	
	// 500000 seconds is 5.78703704 days, ideally this should never be called!
	if(MaxServerUptime > 0) // 0 = let the server grind to a halt from being on too long
		SetTimer(MaxServerUptime,false,nameof(ServerIsOnlineForTooLong));
}

function ServerIsOnlineForTooLong()
{
	RxLog("Game has been on too long! Restarting in 30 seconds!");
	WorldInfo.Game.Broadcast(None, "Game has been on too long! Restarting in 30 seconds!");
	SetTimer(30,false,nameof(RestartGameNow));
}

function RestartGameNow()
{
	WorldInfo.ServerTravel("?Restart",GetTravelType());
}

function SendLANBroadcast()
{
	LANBroadcast.SendBroadcast();
}

function bool AddServerInfo(ServerInfo s)
{
	local string ourIPaddress;
	local int i;
	local InternetLink il;
	local ServerInfo si;
	local bool found;
	local IpAddr addr;

	`Entry(,'DevNet');

	// get our ip
	il = `RxGameObject.spawn(class'InternetLink');
	il.GetLocalIP(addr);
	ourIPaddress = il.IpAddrToString(addr);
	//ipaddresstostring returns port aswell, need to get just ip.
	i = InStr(ourIPaddress, ":");
		if(i != -1)
			ourIPaddress = Left(ourIPaddress, i);

	//check if server is us.
	if ((WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer) && s.ServerIP == ourIPaddress)
		return false;

	//check if server is already in list.
	Foreach ListServers(si)
	{
		if(si.ServerName == s.ServerName && si.ServerIP == s.ServerIP)
			found = true;
	}

	if(!found)
	{
		s.Ping = -1; // Make ping unset for fresh servers.
		ListServers.AddItem(s);
		AddServerPing(s.ServerIP, ListServers.Length - 1);
		return true;
	}
	else
		return false;
}

function SetupMapDataList()
{
	local array<UDKUIResourceDataProvider> ProviderList;
	local int i;

	// make sure default map exists
	class'UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(class'Rx_UIDataProvider_MapInfo', ProviderList);

	//hack until we solve the sorting issue
	for (i = ProviderList.length; i >= 1; i--)
	{
		if (Rx_UIDataProvider_MapInfo(ProviderList[i-1]) == none) {
			`log("NONE - ProviderList[i-1]? " $ Rx_UIDataProvider_MapInfo(ProviderList[i-1]).MapName);
			continue;
		}
		//`log("------YOSH----------" @ Rx_UIDataProvider_MapInfo(ProviderList[i]) @ "---------YOSH----------");
		MapDataProviderList.AddItem(Rx_UIDataProvider_MapInfo(ProviderList[i-1]));
	}
	if (MapDataProviderList.Length > 0) {
		MapDataProviderList.Sort(MapListSort);
	}
}

function bool MapPackageExists (coerce string PackageName)
{
	local int i, MapNum;

	MapNum=MapDataProviderList.Length;

	for(i=0; i < MapNum; i++)
	{
		if(PackageName ~= MapDataProviderList[i].MapName)
		{
		return true;
		}
		else continue;
	}
	return false;
}

delegate int MapListSort(Rx_UIDataProvider_MapInfo A, Rx_UIDataProvider_MapInfo B)
{
	if(A.FriendlyName == B.FriendlyName)	// Handepsilon - I spent 4 hours pulling my hair out trying to figure out what was wrong with my game. It turns out this was the culprit. This is never happening again...
	{
		`warn("Fatal Error! Sorting failed due to duplicate FriendlyName : ("$A.FriendlyName$") on 2 or more maps! Please use different names!!");
		return 0;
	}

	return A.FriendlyName < B.FriendlyName ? 0 : -1;
}

event exec viewmode (string VM)
{
	return;
}

event exec FogDensity()
{
	return;
}

/** one1: added */
function PostBeginPlay()
{
	local string CappedName;
	local class<Rx_ScoreEvent> Event;
	local Rx_AreaVolume V;
	//local Rx_MatchInfo m;

	SetupObjectives();

	if(!WorldInfo.IsMenuLevel())
	{
		// Used to turn back on autobalance after a defence map
		if(bWasAutoBalancerEnabled)
			bAutoBalancerEnabled = true;
		if(Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap) // if deathmatch map, switch to UT's team AI
		{
			RxLog("GAME" @ "Is a deathmatch map, changing to use deathmatch classes.");
			TeamAIType[0] = class'UTTeamAI';
			TeamAIType[1] = class'UTTeamAI';
			BotClass      = class'RenX_Game.Rx_Bot';
			DefaultPawnClass = class'Renx_Game.Rx_Pawn_DM'; //Normalized Pawn
			if(bEnableOverTime)
				bWasOverTimeEnabled = true; // This will persist through level changes, allowing us to restore later
			if(bTeamScoreIsBuildingDamage)
				bWasTeamScoreIsBuildingDamage = true;
			bTeamScoreIsBuildingDamage = false;
			bWasLastGameTDM = true;
			`log("GAME" @ WorldInfo.GetMapName() @ "Is a TDM map, disabling OverTime!");
			bEnableOverTime = false; // No overtime for TDM!
		}
		else if(bWasLastGameTDM) // This should only be true if we just changed from a TDM map...
		{
			bTeamScoreIsBuildingDamage = bWasTeamScoreIsBuildingDamage;
			bWasLastGameTDM = false; // reset for next time
			if(!bEnableOverTime && bWasOverTimeEnabled)
			{
				RxLog("GAME" @ "Is a CNC map. Restoring OverTime to:" @ bWasOverTimeEnabled);
				bEnableOverTime = bWasOverTimeEnabled;
			}
			TeamAIType[0] = class'RenX_Game.RX_TeamAI';
			TeamAIType[1] = class'RenX_Game.RX_TeamAI';
			BotClass      = class'RenX_Game.Rx_Bot';
			DefaultPawnClass = class'Renx_Game.Rx_Pawn';
		}
		else // This seperation is to stop TS_Game using Rx_Pawn... 
		{
			bWasLastGameTDM = false; // reset for next time
			if(!bEnableOverTime && bWasOverTimeEnabled)
			{
				RxLog("GAME" @ "Is a CNC map. Restoring OverTime to:" @ bWasOverTimeEnabled);
				bEnableOverTime = bWasOverTimeEnabled;
			}
		}
	}
	

	super.PostBeginPlay();

	if (Rx_GameEngine(class'Engine'.static.GetEngine()) != none)
		Rx_GameEngine(class'Engine'.static.GetEngine()).Initialize();

	if ((WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer) && !GameSettings.bIsLanMatch)
	{
		if (Rx_GameEngine(class'Engine'.static.GetEngine()) != none)
			Rx_GameEngine(class'Engine'.static.GetEngine()).init_rcon();

		StatAPI = new class'Rx_StatAPI';

		if (!StatAPI.bPostToAPI)
			StatAPI = None;

		if (StatAPI != None)
		{
			StatAPI.GameStart(WorldInfo.GRI.ServerName, string(WorldInfo.GetPackageName()), string(WorldInfo.Game.Class), string(GameVersionNumber));

			if (StatAPI.APIUpdateInterval != 0)
				SetTimer(StatAPI.APIUpdateInterval, true, 'GameUpdate');
		}

		Spawn(class'Rx_WebServer');
	}
	else
	{
		if (bIsClanWars)
			bIsClanWars=false;
	}

	SetTimer(1.f, true, 'VoteTimer');

	if(WorldInfo.NetMode == NM_DedicatedServer && TeamMmrAnnouncementInterval > 0)
	{
	    SetTimer(TeamMmrAnnouncementInterval, true, 'DoEvaMessageWithTeamMMRs');
	}

	if (bAutoKickAFKEnabled) {
		SetTimer(AutoKickAFKCheckInterval, true, 'AutoKickAFKTimer');
	}

	/* Strip Day/Night from Field/Canyon/Mesa or whatever other map*/

	CappedName = string(WorldInfo.GetPackageName());

	if (right(CappedName, 6) ~= "_NIGHT") CappedName = Left(CappedName, Len(CappedName)-6);

	if (right(CappedName, 4) ~= "_DAY") CappedName = Left(CappedName, Len(CappedName)-4);

	//RecordToMapHistory(string(WorldInfo.GetPackageName()));

	RecordToMapHistory(CappedName);

	/** Initialize score events */
	foreach ScoreEvents(Event)
	{
		if (UpcomingScoreEvent == None)
		{
			UpcomingScoreEvent = new Event;
			LastScoreEvent = UpcomingScoreEvent;
		}
		else
		{
			LastScoreEvent.Next = new Event;
			LastScoreEvent = LastScoreEvent.Next;
		}
	}

	RxLog("MAP"`s"Loaded;"`s GetPackageName() );

	`RecordGameFloatStat(ROUND_STARTED,1.0);

	if (VehicleManager != None)
		VehicleManager.CheckVehicleSpawn();

	

	if(Rx_GRI(WorldInfo.GRI) != none)
	{
		Rx_GRI(WorldInfo.GRI).SetTimeStatus(TimeLimit > 0 ? "AOW" : "Marathon");
		Rx_GRI(GameReplicationInfo).MinPlayersForNukes = MinPlayersForNukes;
		Rx_GRI(GameReplicationInfo).bAirDropsEnabled = bEnableAirdrops;  
	}

	foreach AllActors(class'Rx_AreaVolume',V)
	{
		if(!bHasPlayArea && Rx_PlayAreaVolume(V) != None)
			bHasPlayArea = true;

		if(!bHasDenyArea && Rx_DenyAreaVolume(V) != None)
			bHasDenyArea = true;

		if(bHasDenyArea && bHasPlayArea)
			break;
	}

	//Init autobalancer variables
	InitAutoBalancer();

	GameStartTime=WorldInfo.TimeSeconds;
}

function SetupObjectives()
{
	local Rx_GameObjective O;

	foreach AllActors(class'Rx_GameObjective',O)
	{
		if(Rx_ScriptedObj(O) == None)	// skip scripted objective as they are not supposed to be used by anything else than the Rx_Bot_Scripted
		{
			if(O == FirstObjective)
				break;

			if(FirstObjective == None)
			{
				FirstObjective = O;
				FirstObjective.bFirstObjective = true;
			}

			if(PrevO != None)
			{
				PrevO.NextObjective = O;
			}

			PrevO = O;
		}
	}
}

function GameUpdate()
{
	local Rx_Controller c;
	local int GDICount, NodCount;

	if (StatAPI != None)
	{
		ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Rx_Controller', c)
		if (c.GetTeamNum() == 0)
			GDICount++;
		else if (c.GetTeamNum() == 1)
			NodCount++;

		StatAPI.GameUpdate(string(Rx_TeamInfo(Teams[TEAM_GDI]).GetDisplayRenScore()), string(Rx_TeamInfo(Teams[TEAM_NOD]).GetDisplayRenScore()), string(GDICount), string(NodCount));
	}
}

function SwapTeamsHelper(class<Controller> ControllerType)
{
	local Controller PC;

	foreach WorldInfo.AllControllers(ControllerType, PC)
	{
		if ( (PC.PlayerReplicationInfo != None) && (PC.PlayerReplicationInfo.Team != None) )
		{
			if (PC.PlayerReplicationInfo.Team.TeamIndex == TEAM_GDI)
			{
				SetTeam(PC, Teams[TEAM_NOD], false);
				if (PC.Pawn != None)
					PC.Pawn.PlayerChangedTeam();
			}
			else if (PC.PlayerReplicationInfo.Team.TeamIndex == TEAM_NOD)
			{
				SetTeam(PC, Teams[TEAM_GDI], false);
				if (PC.Pawn != None)
					PC.Pawn.PlayerChangedTeam();
			}
		}
	}
}

function SwapTeams()
{
	SwapTeamsHelper(class'PlayerController');
	SwapTeamsHelper(class'Rx_Bot');
}

function byte PickTeam(byte num, Controller C)
{
	if (bIsClanWars)
		return MatchInfo.PickTeam(Rx_Controller(C));
	return super.PickTeam(num, C);
}

function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
{
	local byte AntiTeamByte;

	if(num < 3) AntiTeamByte = num == 0 ? 1 : 0 ;

	if (super.ChangeTeam(Other, num, bNewTeam))
	{

		if (Rx_Controller(Other) != None)
		{
			Rx_Controller(Other).BindVehicle(None);
//			Rx_Controller(Other).VoteTopString = "";
		}
		if (Rx_PRI(Other.PlayerReplicationInfo) != None )
		{
			PenalizeBounty(Rx_PRI(Other.PlayerReplicationInfo),AntiTeamByte);

			if(Rx_PRI(Other.PlayerReplicationInfo) == Commander_PRI[AntiTeamByte])
				RemoveCommander(AntiTeamByte);

			if(Commander_PRI[AntiTeamByte] != none)
				Rx_PRI(Other.PlayerReplicationInfo).SetCommander(Commander_PRI[AntiTeamByte]);
			else
				Rx_PRI(Other.PlayerReplicationInfo).RemoveCommander(AntiTeamByte);

			if(WorldInfo.NetMode == NM_StandAlone && Rx_Controller(Other) != none)
				ChangeCommander(num, Rx_PRI(Other.PlayerReplicationInfo)) ;

			Rx_PRI(Other.PlayerReplicationInfo).DestroyATMines();
			Rx_PRI(Other.PlayerReplicationInfo).DestroyRemoteC4();
			//Rx_PRI(Other.PlayerReplicationInfo).DestroyDrones();
		}
		return true;
	}
	return false;
}

function SetTeam(Controller Other, UTTeamInfo NewTeam, bool bNewTeam)
{
	local Actor A;
	local TeamInfo OldTeam;

	if(Rx_Bot_Scripted(Other) != None)
	{
		Rx_Bot_Scripted(Other).AssignedTeam = Rx_TeamInfo(NewTeam);
		if(Rx_Pawn_Scripted(Other.Pawn) != None)
			Rx_Pawn_Scripted(Other.Pawn).TeamNum = Rx_TeamInfo(NewTeam).TeamIndex;

		return;
	}


	if (Other.PlayerReplicationInfo == None )
	{
		return;
	}

	`RecordPlayerIntStat(TEAMCHANGE,Other,NewTeam.TeamIndex);

	if (Other.PlayerReplicationInfo.Team != None || !ShouldSpawnAtStartSpot(Other))
	{
		// clear the StartSpot, which was a valid start for his old team
		Other.StartSpot = None;
	}

	// remove the controller from his old team
	if ( Other.PlayerReplicationInfo.Team != None )
	{
		OldTeam = Other.PlayerReplicationInfo.Team;
		Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
		Other.PlayerReplicationInfo.Team = none;

		//Clear Binds/locks/C4s
		if (Rx_Controller(Other) != None)
		{
			Rx_Controller(Other).BindVehicle(None);
//			Rx_Controller(Other).VoteTopString = "";
		}
		if (Rx_PRI(Other.PlayerReplicationInfo) != None)
		{
			Rx_PRI(Other.PlayerReplicationInfo).DestroyATMines();
			Rx_PRI(Other.PlayerReplicationInfo).DestroyRemoteC4();
		}

	}

	//Just set them to commander
	if(WorldInfo.NetMode == NM_StandAlone && Rx_Controller(Other) != none) ChangeCommander(NewTeam.TeamIndex, Rx_PRI(Other.PlayerReplicationInfo)) ;

	if ( NewTeam==None || (NewTeam!= none && NewTeam.AddToTeam(Other)) )
	{
		if ( (NewTeam!=None) && ((WorldInfo.NetMode != NM_Standalone) || (PlayerController(Other) == None) || (PlayerController(Other).Player != None)) );
	}

	if (bNewTeam)
		AnnounceTeamJoin(Other.PlayerReplicationInfo, NewTeam, OldTeam);

	if ( (PlayerController(Other) != None) && (LocalPlayer(PlayerController(Other).Player) != None) )
	{
		// if local player, notify level actors
		ForEach AllActors(class'Actor', A)
		{
			A.NotifyLocalPlayerTeamReceived();
		}

	}

	if(bAutoBalancerEnabled && WorldInfo.NetMode != NM_Standalone && !bGameEnded &&  IsInState('MatchInProgress')){//start auto balance or check if its still required
		if(!bCurrentlyShuffling){
			CheckForAutoBalance();
		}
		else
		{
			CheckBalanceConditions();
		}
	}
}

function AnnounceTeamJoin(PlayerReplicationInfo PRI, TeamInfo NewTeam, optional TeamInfo OldTeam, optional bool bBroadcast = true)
{
	if (OldTeam == None)
		RxLog("PLAYER"`s "TeamJoin;"`s `PlayerLog(PRI) `s "joined"`s GetTeamName(NewTeam.GetTeamNum()) `s "score" `s Rx_Pri(PRI).GetRenScore() `s "last round score" `s Rx_Pri(PRI).OldRenScore `s "time" `s WorldInfo.TimeSeconds);
	else
		RxLog("PLAYER"`s "TeamJoin;"`s `PlayerLog(PRI) `s "joined"`s GetTeamName(NewTeam.GetTeamNum()) `s "left" `s GetTeamName(OldTeam.GetTeamNum()) `s "score" `s Rx_Pri(PRI).GetRenScore() `s "last round score" `s Rx_Pri(PRI).OldRenScore `s "time" `s WorldInfo.TimeSeconds);

	if (bBroadcast)
		BroadcastLocalizedMessage( GameMessageClass, 3, PRI, None, NewTeam );
}

function bool AllowedName(string playername)
{
	local int i;

	// If length of name is less than 3 characters
	if (Len(playername) < 3)
		return false;
	// Or exists in the disallowed list
	for (i = 0; i < DisallowedNames.Length; i++)
	{
		if (playername ~= DisallowedNames[i])
			return false;
	}
	return true;
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
    local Controller APlayer;

	if(UTPlayerController(Other).bServerMutedText)
	{
		Rx_Controller(Other).CTextMessage("Can not change name while muted.", 'Red');
		return;
	}

	if(bIsCompetitive && bNameChange)
	{
		Rx_Controller(Other).CTextMessage("Can not change name in competitive play.", 'Red');
		return;
	}

	if (bNameChange && Rx_Controller(Other) != None && WorldInfo.TimeSeconds < Rx_Controller(Other).NextNameChangeTime)
	{
		Rx_Controller(Other).CTextMessage("Name change available in " $ Max(Int(Rx_Controller(Other).NextNameChangeTime - WorldInfo.TimeSeconds), 1) $ " seconds.", 'Red');
		return;
	}

	s = class'Rx_BroadcastHandler'.static.CleanMessage(s);
	s = Rx_BroadcastHandler(BroadcastHandler).ApplyChatFilter(s);
	if (!AllowedName(S))
		s = DefaultPlayerName;

	if (Left(s,Len(DefaultPlayerName)) ~= DefaultPlayerName && ( int(Mid(s,Len(DefaultPlayerName),1)) != 0 || Mid(s,Len(DefaultPlayerName),1) ~= "0" ) )
	{
		Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName$Other.PlayerReplicationInfo.PlayerID);
		return;
	}

    if ( bNameChange && Other.PlayerReplicationInfo.playername~=S )
    {
		return;
	}

	// Not allowed pidX where x is a digit, to avoid trying to confuse people when using pid to parse player.
	if (Left(s,3) ~= "pid" && ( int(Mid(s,3,1)) != 0 || Mid(s,3,1) ~= "0" ) )
	{
		if (!bNameChange)
			Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName$Other.PlayerReplicationInfo.PlayerID);
		return;
	}

    // Cap player name's at 15 characters...
	if (Len(s)>MaxPlayerNameLength)
	{
		s = Left(S,MaxPlayerNameLength);
	}

	foreach WorldInfo.AllControllers(class'Controller', APlayer)
	{
		if (APlayer.bIsPlayer && APlayer.PlayerReplicationInfo.playername ~= S)
		{
			if ( PlayerController(Other) != None )
			{
					PlayerController(Other).ReceiveLocalizedMessage( GameMessageClass, 8 );
					if ( Other.PlayerReplicationInfo.PlayerName ~= DefaultPlayerName )
					{
						if (bNameChange)
						{
							RxLog("PLAYER"`s "NameChange;" `s `PlayerLog(Other.PlayerReplicationInfo)`s"to:"`s DefaultPlayerName$Other.PlayerReplicationInfo.PlayerID);
							if (Rx_Controller(Other) != None)
								Rx_Controller(Other).UpdateNameChangeTime();
						}
						Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName$Other.PlayerReplicationInfo.PlayerID);
					}
				return;
			}
		}
	}

	if (bNameChange)
	{
		RxLog("PLAYER"`s "NameChange;" `s `PlayerLog(Other.PlayerReplicationInfo)`s"to:"`s S);
		if (Rx_Controller(Other) != None)
			Rx_Controller(Other).UpdateNameChangeTime();
	}
    Other.PlayerReplicationInfo.SetPlayerName(S);
}

function static string GetTeamName(byte Index)
{
	switch (Index)
	{
	case TEAM_GDI:
		return "GDI";
	case TEAM_NOD:
		return "Nod";
	default:
		return "Neutral";
	}
}

exec function GetTeamSizes()
{
	`log("GDI: "$ Teams[0].Size $"Nod: "$Teams[1].Size);
}

function TeamDonate(Rx_Controller Donor, float Credits)
{
	local float share;
	local Controller c;
	local byte teamNum;

	teamNum = Donor.GetTeamNum();

	if (Teams[teamNum].Size < 2)    // Need to have at least 1 teammate.
		return;

	share = Credits / (Teams[teamNum].Size - 1);

	foreach WorldInfo.AllControllers(class'Controller', c)
	{
		if (c.GetTeamNum() == teamNum && Rx_PRI(c.PlayerReplicationInfo) != None && c != Donor && !c.PlayerReplicationInfo.bBot)
		{
			Rx_PRI(c.PlayerReplicationInfo).AddCredits(share);
			if (PlayerController(c) != None)
				PlayerController(c).ClientMessage(Donor.PlayerReplicationInfo.PlayerName $ " team-donated you " $ share $" credits.");
		}
	}
	Rx_PRI(Donor.PlayerReplicationInfo).RemoveCredits(Credits);
}

function DeletedPRITeamDonate(Rx_PRI Donor, float Credits)
{
	local float share;
	local Controller c;
	local byte teamNum;

	teamNum = Donor.OldTeamID;

	if (Teams[teamNum].Size < 2)    // Need to have at least 1 teammate.
		return;

	share = Credits / (Teams[teamNum].Size - 1);

	foreach WorldInfo.AllControllers(class'Controller', c)
	{
		if (c.GetTeamNum() == teamNum && Rx_PRI(c.PlayerReplicationInfo) != None && c.PlayerReplicationInfo != Donor )
		{
			Rx_PRI(c.PlayerReplicationInfo).AddCredits(share);
			if (PlayerController(c) != None)
				PlayerController(c).ClientMessage(Donor.PlayerName $ " has left. You received" $ share $" credits.");
		}
	}
	Donor.RemoveCredits(Credits);
}

function Array<string> BuildClientList(string seperator)
{
	local Rx_Controller C;
	local string SteamID;
	local string AdminStatus;
	local Array<string> list;

	foreach WorldInfo.AllControllers(class'Rx_Controller', C)
	{
		SteamID = OnlineSub.UniqueNetIdToString(C.PlayerReplicationInfo.UniqueId);

		if (Rx_PRI(C.PlayerReplicationInfo).bModerator)
			AdminStatus = "Mod";
		else if (C.PlayerReplicationInfo.bAdmin)
			AdminStatus = "Admin";
		else
			AdminStatus = "None";

		if (SteamID == `BlankSteamID)
			SteamID = "-----NO-STEAM-----";
		List.AddItem(C.PlayerReplicationInfo.PlayerID$seperator$C.GetPlayerNetworkAddress()$seperator$SteamID$seperator$AdminStatus$seperator$Class.static.GetTeamName(C.PlayerReplicationInfo.Team.TeamIndex)$seperator$C.PlayerReplicationInfo.PlayerName);
	}
	return List;
}

/** Log messages for Gameplay/Server-management events. Will be written to the logfile with a RenX tag, and sent out to any Log Subscribers over Rcon. */
final function RxLog(string Msg)
{
	if (bLogRcon)
		`log(Msg,true,'Rx');

	if(bLogRcon && !(worldinfo.IsPlayInEditor() || worldinfo.IsPlayInPreview()))
		Rx_GameEngine(class'Engine'.static.GetEngine()).RconLog(Msg);
}

final function RxLogPub(string Msg)
{
	if (bLogRcon)
		`log(Msg,true,'Rx');

	if(bLogRcon && !(worldinfo.IsPlayInEditor() || worldinfo.IsPlayInPreview()))
		Rx_GameEngine(class'Engine'.static.GetEngine()).RconLogPub(Msg);
}

function LogBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{
	local Rx_Mutator Rx_Mut;

	RxLog("GAME"`s "Destroyed;"`s "building"`s Building.Class `s "by"`s `PlayerLog(Destroyer)`s "with"`s DamageType);

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		Rx_Mut.OnBuildingDestroyed(Destroyer, BuildingInternals, Building, DamageType);
	}
}

function SendPM(PlayerController Sender, int RecipientID, String msg)
{
	local PlayerReplicationInfo PRI;

	// If PMing is not allowed, only allow Admins to do so.
	if (!bAllowPrivateMessaging && !Sender.PlayerReplicationInfo.bAdmin)
	{
		Sender.ClientMessage("This server does not allow Private Messaging.");
		return;
	}

	if (UTPlayerController(Sender).bServerMutedText)
	{
		Sender.ClientMessage("You are muted from chat, including Private Messaging.");
		return;
	}

	PRI = FindPlayerByID(RecipientID);

	if (PRI.bBot || PRI == Sender.PlayerReplicationInfo)    // can't PM to bots or yourself.
		return;
	if (bPrivateMessageTeamOnly && PRI.Team != Sender.PlayerReplicationInfo.Team)   // If game doesn't allow PMing the enemy.
	{
		Sender.ClientMessage("This server only allows Private Messaging to teammates.");
		return;
	}
	Rx_BroadcastHandler(BroadcastHandler).BroadcastPM(Sender, Rx_Controller(PRI.Owner), Msg);
	return;
}

function PlayerReplicationInfo FindPlayerByID(int ID)
{
	local PlayerReplicationInfo PRI;

	foreach GameReplicationInfo.PRIArray(PRI)
		if (PRI.PlayerID == ID)
			return PRI;
}

// For Servers, use Rx_Controller::ParsePlayer as server. ANY CHANGES HERE SHOULD BE MADE TO THE RX_CONTROLLER FUNCTION AS WELL.
function Rx_PRI ParsePlayer(String in, optional out string Error)
{
	//local int id;
	local string temp;
	local int id;
	local PlayerReplicationInfo PRI, Match;

	//The UE3 console has problems if the first character is a symbol, disabled finding by ID for the mo.

	// If the first char is a #, then try to parse by player id.
	if (Left(in,3) ~= "pid")
	{
		id = int(Mid(in, 3));
		if (id != 0)
		{
			// Parsed numbers after the "pid", now check to see if there were non-numeric characters as well
			temp = string(id);
			if ( Len(temp) == Len(Mid(in, 3)) )
			{
				// Equal length means there were no non-numerics in the string at all, so continue to find by Player ID
				foreach GameReplicationInfo.PRIArray(PRI)
					if (PRI.PlayerID == id)
						return Rx_PRI(PRI);
			}
		}
	}


	// Failed to find by ID, Attempt to find by Name
	temp = Caps(in); // make case insensitive
	foreach GameReplicationInfo.PRIArray(PRI)
	{
		if (InStr(Caps(PRI.PlayerName), temp) != -1)
		{
			if (Match == None)
				Match = PRI;
			else
			{
				// Multiple matches, abort.
				Error = "Multiple player matches on \""$in$"\", please be more specific.";
				return None;
			}
		}
	}

	if (Match != None)
	{
		// We found one match by name.
		return Rx_PRI(Match);
	}
	Error = "No player matches on \""$in$"\" found.";
	return None;
}

exec function AddAdministrator(int id)
{
	Rx_AccessControl(AccessControl).AddAdmin(None, FindPlayerByID(id), false);
}

function ClientRequestDemoRec(Rx_Controller who)
{
	if (bDisableDemoRequests)
		return;

	if (!WorldInfo.IsRecordingDemo())
	{
		ClientDemoInProgress = true;
		RxLog("DEMO"`s"Record;"`s"client request by"`s`PlayerLog(who.PlayerReplicationInfo));
		ConsoleCommand("demorec" @ GameVersionNumber $ "-" $ string(WorldInfo.GetPackageName()) $ "-%td");
		SetTimer(120,false,'StopDemoRecording');
	}
}

function AdminDemoRec(Rx_Controller who)
{
	if (WorldInfo.IsRecordingDemo())
	{
		if (ClientDemoInProgress)
		{
			ClearTimer('StopDemoRecording');
			StopDemoRecording();
			AdminRecord(who);
		}
	}
	else
		AdminRecord(who);
}

function AdminRecord(Rx_Controller who)
{
	if (who != None)
		RxLog("DEMO"`s"Record;"`s"admin command by"`s`PlayerLog(who.PlayerReplicationInfo));
	else
		RxLog("DEMO"`s"Record;"`s"rcon command");
	ConsoleCommand("demorec" @ GameVersionNumber $ "-" $ string(WorldInfo.GetPackageName()) $ "-%td");
}

function StopDemoRecording()
{
	RxLog("DEMO" `s "RecordStop;");
	ClientDemoInProgress = false;
	ConsoleCommand("demostop");
}

/** one1: added */
event VoteTimer()
{
	if (GlobalVote != none)
		GlobalVote.ServerSecondTick(self);
	if (GDIVote != none)
		GDIVote.ServerSecondTick(self);
	if (NODVote != none)
		NODVote.ServerSecondTick(self);
}

function DestroyVote(Rx_VoteMenuChoice vote)
{
	vote.DestroyVote(self);

	if (GlobalVote == vote)
		GlobalVote = none;
	else if (GDIVote == vote)
		GDIVote = none;
	else if (NODVote == vote)
		NODVote = none;
}

// AFK autokicking. This only kicks (pun intended) if these circumstances align.
// Globally:
// 1. AFK autokicking must be enabled in the config.
// 2. The server must be full for a minimum period of time.
// Then per candidate (player currently AFK):
// 3. A candidate to be kicked must be AFK for a minimum period of time
//    (on top of the threshold to go AFK, so MinimumCurrentAFKSeconds = 5 really means
//    approx 185 seconds since last AFK reset in Rx_PRI).
// 4. A candidate to be kicked must be AFK for a minimum total period of time
//    (so someone who's been AFK for 30 seconds but has previously in the game been marked as
//     AFK for 60 seconds will be considered to have 90 seconds total AFK time).
// 5. The candidate must not be an admin.
//
// Because the game automatically declares everyone AFK at the start of the match instead of
// after the usual interval the configuration settings should be considered carefully, e.g.
// with MinimumCurrentAFKSeconds and MinimumTotalAFKSeconds to 15 people can be kicked at the
// very start of the match just for not paying attention for a few seconds.
event AutoKickAFKTimer() {
	local Rx_Controller C;
	local Rx_PRI PRI;
	local float Now;
	local float CurrentAFKSeconds;

	Now = WorldInfo.TimeSeconds;

	if (AtCapacity(false) && bAutoKickAFKEnabled &&
		(WorldInfo.TimeSeconds - MaxPlayersStartTime) > AutoKickAFKMinimumServerFullSeconds) {
		foreach WorldInfo.AllControllers(class'Rx_Controller', C)
		{
			PRI = Rx_PRI(C.PlayerReplicationInfo);
			if (PRI != none && PRI.bisAFK && !PRI.bAdmin) {
				CurrentAFKSeconds = Now - PRI.LastAFKStart;
				if (CurrentAFKSeconds >= AutoKickAFKMinimumCurrentAFKSeconds &&
					(CurrentAFKSeconds + PRI.PreviousAFKTime) >= AutoKickAFKMinimumTotalAFKSeconds) {
					AccessControl.KickPlayer(C, "too long inactivity on full server");
				}
			}
		}
	}
}

function GenericPlayerInitialization(Controller C)
{
	HUDType = HudClass;
	super(GameInfo).GenericPlayerInitialization(C);
}

function PostLoginCommon(PlayerController NewPlayer, string PlayerUUID, string GameUUID)
{
	local string SteamID;
	SteamID = OnlineSub.UniqueNetIdToString(NewPlayer.PlayerReplicationInfo.UniqueId);

	//RxLog("[OSUUID]" @ "" @ NewPlayer.PlayerReplicationInfo.PlayerName @ "" @ NewPlayer.GetPlayerNetworkAddress() @ "" @ GameUUID);

	if (SteamID == `BlankSteamID || SteamID == "") 
	{ // Non-steam users
		RxLog("PLAYER" `s "Enter;" `s `PlayerLog(NewPlayer.PlayerReplicationInfo) `s "from" `s NewPlayer.GetPlayerNetworkAddress() `s "hwid" `s PlayerUUID `s "nosteam" `s "UUID" `s GameUUID);
	}
	else 
	{ // Steam users
		RxLog("PLAYER" `s "Enter;" `s `PlayerLog(NewPlayer.PlayerReplicationInfo) `s "from" `s NewPlayer.GetPlayerNetworkAddress() `s "hwid" `s PlayerUUID `s "steamid"`s SteamID `s "UUID" `s GameUUID);
	}
}

event PostLogin( PlayerController NewPlayer )
{
	local int AvgVeterancy;
	local PlayerReplicationInfo PRI;
	local int num;
	local Rx_Mutator Rx_Mut;
	local Rx_PRI NewPRI;

	local string NewPlayerUUID;

	local int PlayerListIndex, i;
	local bool bRejoined;

	
	Rx_Controller(NewPlayer).RequestDeviceUUID();
	NewPlayerUUID = Rx_Controller(NewPlayer).PlayerUUID;
	//Remove the need to cast 50 times in this function
	NewPRI = Rx_Pri(NewPlayer.PlayerReplicationInfo);



	i = JoinedPlayerIDs.Find(NewPlayerUUID);
	if(i >= 0)
	{
		bRejoined = true;
	}
	else
	{
		JoinedPlayerIDs.AddItem(NewPlayerUUID);
	}

	if (TeamMode != 4)
	{
		SetTeam(NewPlayer, UTTeamInfo(`RxEngineObject.GetInitialTeam(NewPlayer.PlayerReplicationInfo)), false);
		//`log("Call PostLogin: " @ `RxEngineObject.IsPlayerCommander(NewPlayer.PlayerReplicationInfo));
		if(bUseStaticCommanders && `RxEngineObject.IsPlayerCommander(NewPlayer.PlayerReplicationInfo) ) ChangeCommander(NewPlayer.GetTeamNum(), NewPRI, true);
	}

	AnnounceTeamJoin(NewPlayer.PlayerReplicationInfo, NewPlayer.PlayerReplicationInfo.Team, None, false);

	super.PostLogin(NewPlayer);

	NewPRI.ReplicatedNetworkAddress = NewPlayer.PlayerReplicationInfo.SavedNetworkAddress;

	if(NewPlayerUUID == "")
	{
		NewPlayerUUID = NewPRI.PlayerName;
	}
	PlayerListIndex = PlayerMonitor.MyPlayersInfo.Find('UUID',NewPlayerUUID);
	if(PlayerListIndex >= 0)
	{
		if(!bRejoined)
		{
			PlayerMonitor.MyPlayersInfo[PlayerListIndex].JoinedGame += 1;
		}
		else
		{
			PlayerMonitor.MyPlayersInfo[PlayerListIndex].SavedScore -= 	PlayerMonitor.MyPlayersInfo[PlayerListIndex].LastGameScore;
		}
		PlayerMonitor.MyPlayersInfo[PlayerListIndex].LastGameScore = 0;

		NewPRI.OldRenScore = PlayerMonitor.MyPlayersInfo[PlayerListIndex].SavedScore / PlayerMonitor.MyPlayersInfo[PlayerListIndex].JoinedGame;
		PlayerMonitor.MyPlayersInfo[PlayerListIndex].PlayerName = NewPRI.PlayerName;
		PlayerMonitor.SaveConfig();
	}
	else
	{
		PlayerMonitor.AddNewInfo(NewPlayerUUID,0,NewPRI.PlayerName);
	}
	if(MatchIsInProgress() || WorldInfo.NetMode == NM_Standalone)
		Rx_Controller(newPlayer).bPlayerIsReady = true; // if match is already started, set us as Ready

	if(bDelayedStart) // we want bDelayedStart, but still want players to spawn immediatly upon connect
		RestartPlayer(newPlayer);

	/**Needed anything that happened when a player first joined. If the team is using airdrops, it'll update them correctly **/

	//Nods (Could probably make this cleaner looking, but at the moment I'm just making sure it works)
	if(bEnableAirdrops &&  NewPRI != None && (NewPRI.GetTeamNum() == TEAM_NOD) && VehicleManager.bNodIsUsingAirdrops)
	{
		if(NewPRI.AirdropCounter == 0)
		{
			NewPRI.AirdropCounter++;
			//Rx_Pri(NewPlayer.PlayerReplicationInfo).LastAirdropTime=WorldInfo.TimeSeconds;
		}
	}
	//Disable veterancy accordingly for surrenders
	if(NewPRI != None && NewPRI.GetTeamNum() == TEAM_Nod && bNodHasSurrendered)
	{
		NewPRI.DisableVeterancy(true);
	}

	//GDI
	if(bEnableAirdrops && NewPRI != None && (NewPRI.GetTeamNum() == TEAM_GDI) && VehicleManager.bGDIIsUsingAirdrops)
	{
		if(NewPRI.AirdropCounter == 0)
		{
			NewPRI.AirdropCounter++;
			//Rx_Pri(NewPlayer.PlayerReplicationInfo).LastAirdropTime=WorldInfo.TimeSeconds;
		}
	}

	//Disable veterancy accordingly for surrenders
	if(NewPRI != None && NewPRI.GetTeamNum() == TEAM_GDI && bGDIHasSurrendered)
	{
		NewPRI.DisableVeterancy(true);
	}


	if(!Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap && NewPRI != none)
	{

		//Set Commander if they exist
		if(NewPRI.GetTeamNum() == 0 && Commander_PRI[0] != none)
			NewPRI.SetCommander(Commander_PRI[0]) ;
		else if(NewPRI.GetTeamNum() == 1 && Commander_PRI[1] != none) {
			NewPRI.SetCommander(Commander_PRI[1]) ;
		}

			//Give average veterancy
			foreach GameReplicationInfo.PRIArray(PRI)
			{
			if(Rx_PRI(PRI) == none)
				continue;

					if (PRI.GetTeamNum() == NewPRI.GetTeamNum())
					{
						AvgVeterancy+=Rx_PRI(PRI).Veterancy_Points;
						num++;
					}

			}
			if(num > 0) AvgVeterancy=min(MaxInitialVeterancy,AvgVeterancy/(num+2));
					NewPRI.InitVP(
					AvgVeterancy,
					Rx_Game(WorldInfo.Game).VPMilestones[0],
					Rx_Game(WorldInfo.Game).VPMilestones[1],
					Rx_Game(WorldInfo.Game).VPMilestones[2]);
	}

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		// Why are we passing steam ID here? It's already available through NewPlayer
		Rx_Mut.OnPlayerConnect(NewPlayer, OnlineSub.UniqueNetIdToString(NewPlayer.PlayerReplicationInfo.UniqueId));
	}

	if (bFailover) {
		Rx_Controller(NewPlayer).SetFailoverURL(TravelURL);
	}

	ServerUpdateDiscordPresence();

	CheckForBeaconToggle();

	Rx_Controller(NewPlayer).AutoReactionSeconds = BotAutoWarningThreshold;

	Rx_Controller(NewPlayer).AddMarquee(default.TimeLimit > 0 ? T_Marquee_AOW : T_Marquee_Marathon, 5.0);

}

function ServerUpdateDiscordPresence() {
	local Rx_Controller P;
	foreach WorldInfo.AllControllers(class'Rx_Controller', P) {
		P.ClientUpdateDiscordPresence(MaxPlayers);
	}
}

function CheckForBeaconToggle()
{
	if(NumPlayers + (NumBots / 2) >= MinPlayersForNukes && !Rx_GRI(GameReplicationInfo).bEnableNuke)
	{
		RxLog("Game has reached minimum limit for Beacon,"@NumPlayers@"Players and"@NumBots@"Bots out of"@MinPlayersForNukes);
		Rx_GRI(GameReplicationInfo).bEnableNuke = true; // don't turn off until new game so that players don't waste the nuke they bought
	}
}

function Logout( Controller Exiting )
{
	local UTPlayerReplicationInfo PRI;
	local UTPlayerController ExitingPC;
	local int i;
	local Rx_Mutator Rx_Mut;

	if (Rx_Controller(Exiting) != None)
	{
		Rx_Controller(Exiting).BindVehicle(None);
		PlayerMonitor.UpdateInfo(Rx_Controller(Exiting));
	}
	if (Rx_PRI(Exiting.PlayerReplicationInfo) != None && Rx_Bot_Scripted(Exiting) == None)
	{

		PenalizeBounty(Rx_PRI(Exiting.PlayerReplicationInfo),Exiting.GetTeamNum());

		for(i=0;i<2;i++)
		{
			if(Exiting.PlayerReplicationInfo == Commander_PRI[i] && !bGameEnded)
			{
				CTextBroadcast(Exiting.GetTeamNum(), Caps("!!!Our Commander has left the game!!!"));
				RemoveCommander(i);
			}
		}

		Rx_PRI(Exiting.PlayerReplicationInfo).DestroyATMines();
		Rx_PRI(Exiting.PlayerReplicationInfo).DestroyRemoteC4();
	}

	PRI = UTPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
	if ( PRI.bHasFlag )
	{
		PRI.GetFlag().Drop();
	}


	// Remove from all mute lists so they can rejoin properly
	ExitingPC = UTPlayerController( Exiting );
	if( ExitingPC != None )
	{
		RemovePlayerFromMuteLists( ExitingPC );
//		if(Rx_PRI(PRI) != None && Rx_PRI(PRI).GetCredits() > InitialCredits)
//			TeamDonate(Rx_Controller(ExitingPC), Rx_PRI(PRI).GetCredits() -  InitialCredits);
	}

	Super(UDKGame).Logout(Exiting);
	if(Rx_Bot_Scripted(Exiting) == None && Exiting.Class.Name != 'TS_Bot_Dummy')
	{
		if (Exiting.IsA('UTBot') && !UTBot(Exiting).bSpawnedByKismet)
		{
			i = ActiveBots.Find('BotName', Exiting.PlayerReplicationInfo.PlayerName);
			if (i != INDEX_NONE)
			{
				ActiveBots[i].bInUse = false;
			}
			NumBots--;
		}

		if ( NeedPlayers() )
		{
			AddBot();
		}

		if (MaxLives > 0)
		{
			CheckMaxLives(None);
		}

	}

	RxLog("PLAYER"`s "Exit;"`s `PlayerLog(Exiting.PlayerReplicationInfo));

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Bot_Scripted(Exiting) == None &&Rx_Mut != None)
	{
		Rx_Mut.OnPlayerDisconnect(Exiting);
	}

	//if(Rx_Controller(Exiting) != none)
		//`RecordLoginChange(LOGOUT,Exiting,Exiting.PlayerReplicationInfo.PlayerName,Exiting.PlayerReplicationInfo.UniqueId, false)

	ServerUpdateDiscordPresence();



	if(bAutoBalancerEnabled && WorldInfo.NetMode != NM_Standalone && !bGameEnded &&  IsInState('MatchInProgress')){//start auto balance or check if its still required
		if(!bCurrentlyShuffling){
			SetTimer(5, false, nameof(CheckForAutoBalance));//check for rebalance after a delay
		}
		else
		{
			CheckBalanceConditions();
		}
	}
}

function bool NeedPlayers()
{
	if(GameType == 0)
		return false;

	return super.NeedPlayers();
}

function KillBot(UTBot B)
{
	if(DesiredPlayerCount > 1)
		DesiredPlayerCount--;
	Super.KillBot(B);
}

exec function KillBots()
{
	local UTBot B;

	bPlayersVsBots = false;

	foreach WorldInfo.AllControllers(class'UTBot', B)
	{
		if(Rx_Bot_Scripted(B) == None) // so we don't accidentally kill our scripted bots
			KillBot(B);
	}
}

exec function KillScriptedBots()		// ONLY USE THIS AS EXPERIMENTAL TOOL
{
	local Rx_Bot_Scripted B;

	foreach WorldInfo.AllControllers(class'Rx_Bot_Scripted', B)
	{
		KillBot(B);
	}
}

function String getPlayerStatsStringFromPri(Rx_Pri pri)
{
	local String ret;
	if(OnlineSub == None) {
		OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
	}
	if(OnlineSub.UniqueNetIdToString(pri.UniqueId) == `BlankSteamID) {
		return "";
	}
	ret = ret$OnlineSub.UniqueNetIdToString(pri.UniqueId)$",";
	ret = ret$Repl(Repl(pri.PlayerName,";",""), ",","")$",";
	ret = ret$pri.GetRenScore()$",";
	ret = ret$pri.GetRenPlayerKills()$",";
	ret = ret$pri.deaths$",";
	ret = ret$pri.GetTeamNum()$",";
	if(GameReplicationInfo.Winner == None) {
		ret = ret$2;
	} else if(GameReplicationInfo.Winner.GetTeamNum() == pri.GetTeamNum()) {
		ret = ret$1;
	} else {
		ret = ret$0;
	}
	`log(ret);
	return ret;
}

static function string GuidToHex(Guid in_guid)
{
	return class'Rx_RconConnection'.static.intToHex(in_guid.A) $ class'Rx_RconConnection'.static.intToHex(in_guid.B) $ class'Rx_RconConnection'.static.intToHex(in_guid.C) $ class'Rx_RconConnection'.static.intToHex(in_guid.D);
}

/** Fetches a server variable by name. */
function string GetGameProperty(string prop)
{
	switch(Caps(prop))
	{
		// ServerInfo defaults
	case "PORT":
		return string(Port);
	case "NAME": // Alias
	case "SERVERNAME":
		return WorldInfo.GRI.ServerName;
	case "LEVEL": // Alias
	case "MAP": // Alias
	case "PACKAGE": // Alias
	case "PACKAGENAME": // Alias
	case "GETPACKAGENAME": // Alias(Function)
		return string(GetPackageName());
	case "LEVELGUID": // Alias
	case "MAPGUID": // Alias
	case "PACKAGEGUID": // Alias
	case "GUID":
		return GuidToHex(GetPackageGuid(GetPackageName()));
	case "PLAYERS": // Alias
	case "NUMPLAYERS":
		return string(NumPlayers);
	case "BOTS": // Alias
	case "NUMBOTS":
		return string(NumBots);

		// GameInfo defaults
	case "PLAYERLIMIT": // Alias
	case "MAXPLAYERS":
		return string(MaxPlayers);
	case "VEHICLELIMIT":
		return string(VehicleLimit);
	case "MINELIMIT":
		return string(MineLimit);
	case "TIMELIMIT":
		return string(TimeLimit);
	case "BPASSWORDED": // Alias
	case "REQUIRESPASSWORD": // Alias(Function)
		return string(AccessControl.RequiresPassword());
	case "BSTEAMREQUIRED": // Alias
	case "BREQUIRESTREAM":
		return string(Rx_AccessControl(AccessControl).bRequireSteam);
	case "BPRIVATEMESSAGETEAMONLY":
		return string(bPrivateMessageTeamOnly);
	case "BALLOWPRIVATEMESSAGING":
		return string(bAllowPrivateMessaging);
	case "BAUTOBALANCETEAMS": // Alias
	case "BSPAWNCRATES": // Alias
	case "SPAWNCRATES":
		return string(SpawnCrates);
	case "CRATERESPAWNAFTERPICKUP":
		return string(CrateRespawnAfterPickup);

		// Some others in Rx_Game (hey, maybe somebody will want it -shrugs-)
	case "BFIXEDMAPROTATION":
		return string(bFixedMapRotation);
	case "RECENTMAPSTOEXCLUDE":
		return string(RecentMapsToExclude);
	case "MAXMAPVOTESIZE":
		return string(MaxMapVoteSize);
	case "INITIALCREDITS":
		return string(InitialCredits);
	case "BBOTSDISABLED":
		return string(bBotsDisabled);
	case "DONATIONSDISABLEDTIME":
		return string(DonationsDisabledTime);
	case "BRESERVEVEHICLESTOBUYER":
		return string(bReserveVehiclesToBuyer);
	case "BISCOMPETITIVE":
	case "BCOMPETITIVE":
		return string(bIsCompetitive);
	case "BISCLANWARS":
		return string(bIsClanwars);
	case "BLISTED":
		return string(bListed);
	case "BUNLISTED":
		return string(!bListed);
	case "GAMEVERSION":
		return GameVersion;
	case "GAMEVERSIONNUMBER":
		return string(GameVersionNumber);
	case "BDISABLEDEMOREQUESTS":
		return string(bDisableDemoRequests);
	case "GAMEMODE":
	case "MODE":
		return string(WorldInfo.Game.Class);
	case "MATCHIISNPROGRESS":
	case "MATCHINPROGRESS":
	case "MIP":
		return string(MatchIsInProgress());
	case "MATCHSTATE":
	case "GAMESTATE":
		return string(GetStateName());

		// Not found
	default:
		return "ERR_UNKNOWNVAR";
	}
}

event InitGame( string Options, out string ErrorMessage )
{
	//local int MapIndex;

	LANBroadcast = new class'Rx_LANBroadcast';

	if(Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap)
	{
		RxLog("GAME" @ "Is a deathmatch map. Timelimit set to:" @ DMModeTimeLimit);
		SetTimeLimit(DMModeTimeLimit);
		bSpawnInTeamArea = false;
	} else if(CnCModeTimeLimit != TimeLimit)
	{
		RxLog("GAME" @ "Is a CNC map. Timelimit reset to:" @ CnCModeTimeLimit);
		SetTimeLimit(CnCModeTimeLimit);
		bSpawnInTeamArea = true;
	}

	if (WorldInfo.NetMode == NM_Standalone)
		TeamMode = 4;

	super.InitGame(Options, ErrorMessage);
	TeamFactions[TEAM_GDI] = "GDI";
	TeamFactions[TEAM_NOD] = "Nod";
	if(bFillSpaceWithBots)
		DesiredPlayerCount = Rx_MapInfo(WorldInfo.GetMapInfo()).MinNumPlayers;
	else
		DesiredPlayerCount = 1;
	bCanPlayEvaBuildingUnderAttackGDI = true;
	bCanPlayEvaBuildingUnderAttackNOD = true;

	if (Role == ROLE_Authority )
	{
		FindRefineries(); // Find the refineries so we can give players credits
	}

	IgnoreGameServerVersionCheck = HasOption( Options, "IgnoreGameServerVersionCheck");

	GDIBotCount = GetIntOption( Options, "GDIBotCount",0);
	NODBotCount = GetIntOption( Options, "NODBotCount",0);
	AdjustedDifficulty = 5;
	GDIDifficulty = GetIntOption( Options, "GDIDifficulty",4);
	NODDifficulty = GetIntOption( Options, "NODDifficulty",4);
	GDIDifficulty += 3;
	NODDifficulty += 3;

	if (WorldInfo.NetMode == NM_DedicatedServer) //Static limits on-line
	{
		MineLimit = Rx_MapInfo(WorldInfo.GetMapInfo()).MineLimit;
		//VehicleLimit= Rx_MapInfo(WorldInfo.GetMapInfo()).VehicleLimit;
	}
	else if(WorldInfo.NetMode == NM_Standalone)
	{
		MineLimit = GetIntOption( Options, "MineLimit", MineLimit);
		//VehicleLimit = GetIntOption( Options, "VehicleLimit", VehicleLimit);
		bDelayedStart = false;
		//AddInitialBots();
	}

	InitialCredits = GetIntOption(Options, "StartingCredits", InitialCredits);
	PlayerTeam = GetIntOption( Options, "Team",0);
	GDIAttackingValue = GetIntOption( Options, "GDIAttackingStrengh",0.7);
	NodAttackingValue = GetIntOption( Options, "NodAttackingStrengh",0.7);
	//Port = GetIntOption( Options, "PORT",7777);
	Port = `GamePort;
	//GamePassword = ParseOption( Options, "GamePassword");


	// Initialize the maplist manager
	InitializeMapListManager();

	//adding fort mutator (nBab) - HANDEPSILON // No longer needed
	/*
	if (WorldInfo.GetmapName() == "Fort")
	{
		AddMutator("RenX_nBabMutators.Fort");
		BaseMutator.InitMutator(Options, ErrorMessage);
	}
	*/
}


function InitializeMapListManager(optional string MLMOverrideClass)
{
	local class<Rx_MapListManager> MapListManagerClass;

	if (MLMOverrideClass == "")
		MLMOverrideClass = MapListManagerClassName;

	if (MLMOverrideClass != "")
		MapListManagerClass = Class<Rx_MapListManager>(DynamicLoadObject(MLMOverrideClass, Class'Class'));

	if (MapListManagerClass == none)
		MapListManagerClass = Class'Rx_MapListManager';

	MapListManager = Spawn(MapListManagerClass);

	if (MapListManager == none && MapListManagerClass != Class'Rx_MapListManager')
	{
		`log("Unable to spawn maplist manager of class '"$MLMOverrideClass$"', loading the default maplist manager");
		MapListManager = Spawn(Class'Rx_MapListManager');
	}

	MapListManager.Initialize();
}
function int InitBotDifficultyFromBaseDifficulty(int Difficulty)
{
	local int ret;
	if(Difficulty == 0) {
		ret = 2;
	} else if(Difficulty == 1) {
		ret = 4;
	} else if(Difficulty == 2) {
		ret = 6;
	} else if(Difficulty == 3) {
		ret = 7;
	}
	return ret;
}

function AddInitialBots()
{

	if( bInitialBotsCreated) return;

	if(GDIBotCount > 0) {
		AdjustedDifficulty = GDIDifficulty;
		AddRedBots(GDIBotCount);

		`log("GDIDifficulty"$GDIDifficulty);
	}
	if(NODBotCount > 0) {
		AdjustedDifficulty = NODDifficulty;
		AddBlueBots(NODBotCount);
		`log("NODDifficulty"$NODDifficulty);
	}
	bInitialBotsCreated=true;
}

function CreateTeam(int TeamIndex)
{
	if (TeamIndex > 2) // only 2: GDI and NOD
	  return;

	Teams[TeamIndex] = spawn(TeamInfoClass);
	Teams[TeamIndex].Faction = TeamFactions[TeamIndex];
	Teams[TeamIndex].Initialize(TeamIndex);

	Rx_TeamInfo(Teams[TeamIndex]).VehicleLimit = VehicleLimit;
	Rx_TeamInfo(Teams[TeamIndex]).mineLimit = MineLimit;
	//Setup CP
	Rx_TeamInfo(Teams[TeamIndex]).InitCommandPoints(Max_CP, InitialCP);


	Teams[TeamIndex].AI = Spawn(TeamAIType[TeamIndex]);
	Teams[TeamIndex].AI.Team = Teams[TeamIndex];
	Rx_TeamAI(Teams[TeamIndex].AI).InitializeOrderList();
	GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
	Teams[TeamIndex].AI.SetObjectiveLists();
	if(TeamIndex == TEAM_GDI) {
		Rx_TeamAI(Teams[TeamIndex].AI).MinAttackersRatio[TEAM_GDI] = GDIAttackingValue/100.0;
		`log("GDI:"$Rx_TeamAI(Teams[TeamIndex].AI).MinAttackersRatio[TEAM_GDI]);
	} else {
		Rx_TeamAI(Teams[TeamIndex].AI).MinAttackersRatio[TEAM_Nod] = NodAttackingValue/100.0;
		`log("Nod:"$Rx_TeamAI(Teams[TeamIndex].AI).MinAttackersRatio[TEAM_Nod]);
	}

}

function bool CheckCheatBot()
{
	return Rx_TeamAI(Teams[0].AI).bCanGetCheatBot;
}

function bool ToggleForceBot()
{
	local bool bNewSetup;
	local int BotNeeded;

	bNewSetup = !bFillSpaceWithBots;

	bFillSpaceWithBots = bNewSetup;

	if(bFillSpaceWithBots)
	{
		DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, Rx_MapInfo(WorldInfo.GetMapInfo()).MinNumPlayers), 1, 64);
		BotNeeded = DesiredPlayerCount - NumPlayers - NumBots;

		if(BotNeeded > 0)
			AddBots(BotNeeded);
	}
	else
	{
		DesiredPlayerCount = NumPlayers+NumBots;
	}



	return true;
}

function bool ToggleCheatBot()
{

	if(Teams[0].AI == None)
		return false;


	if(Rx_TeamAI(Teams[0].AI).bCanGetCheatBot)
	{
		Rx_TeamAI(Teams[0].AI).bCanGetCheatBot = false;
		Rx_TeamAI(Teams[1].AI).bCanGetCheatBot = false;
	}

	else
	{
		Rx_TeamAI(Teams[0].AI).bCanGetCheatBot = true;
		Rx_TeamAI(Teams[1].AI).bCanGetCheatBot = true;
	}


	Rx_GRI(WorldInfo.GRI).bCanRequestCheatBots = CheckCheatBot();

	return true;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	if(Rx_Bot_Scripted(PlayerPawn.Controller) != None)
		return;

	if(Rx_Pri(PlayerPawn.PlayerReplicationInfo) != none)
	{
		Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GetStartClass(PlayerPawn.GetTeamNum(), PlayerPawn.PlayerReplicationInfo);
		`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		PlayerPawn.NotifyTeamChanged();
	}

	if(Rx_Bot(PlayerPawn.Controller) != None)
	{
		if(!Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = Rx_Bot(PlayerPawn.Controller).BotBuy(Rx_Bot(PlayerPawn.Controller), true);
		}

		else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_GDI) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GDIInfantryClasses[Rand(6)];
			`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		} else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_NOD) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.NodInfantryClasses[Rand(6)];
			`LogRxPub("GAME" `s "Spawn;" `s "player" `s `PlayerLog(PlayerPawn.PlayerReplicationInfo) `s "character" `s UTPlayerReplicationInfo(PlayerPawn.PlayerReplicationInfo).CharClassInfo);
		}

		PlayerPawn.NotifyTeamChanged();
	}

	/**else if(Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap)
	{
		if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_GDI) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.GDIInfantryClasses[Rand(PurchaseSystem.GDIInfantryClasses.Length)];
		} else if(PlayerPawn.PlayerReplicationInfo.GetTeamNum() == TEAM_NOD) {
			Rx_Pri(PlayerPawn.PlayerReplicationInfo).CharClassInfo = PurchaseSystem.NodInfantryClasses[Rand(PurchaseSystem.NodInfantryClasses.Length)];
		}
		PlayerPawn.NotifyTeamChanged();
	}*/

	super.SetPlayerDefaults(PlayerPawn);

	if(Rx_Controller(PlayerPawn.Controller) != None && PurchaseSystem.IsStealthBlackHand( Rx_PRI(PlayerPawn.PlayerReplicationInfo) ) )
	{
		Rx_Controller(PlayerPawn.Controller).SetJustBaughtEngineer(false);
		Rx_Controller(PlayerPawn.Controller).SetJustBaughtHavocSakura(false);
		Rx_Controller(PlayerPawn.Controller).ChangeToSBH(true);
	}
	else if(Rx_Bot(PlayerPawn.Controller) != None  && Rx_Bot_Scripted(PlayerPawn.Controller) == None && PurchaseSystem.IsStealthBlackHand( Rx_PRI(PlayerPawn.PlayerReplicationInfo) ) )
	{
		Rx_Bot(PlayerPawn.Controller).ChangeToSBH(true);
	} else {
		if (Rx_Controller(PlayerPawn.Controller) != none) {
			Rx_Controller(PlayerPawn.Controller).SetJustBaughtEngineer(false);
			Rx_Controller(PlayerPawn.Controller).SetJustBaughtHavocSakura(false);
			Rx_Controller(PlayerPawn.Controller).RemoveCurrentSidearmAndExplosive();
		}
		Rx_Pri(PlayerPawn.PlayerReplicationInfo).equipStartWeapons();
	}


}

function AddDefaultInventory( Pawn PlayerPawn )
{
	local int i;
	for (i=0; i<DefaultInventory.Length; i++)
	{
		// Ensure we don't give duplicate items
		if (PlayerPawn.FindInventoryType( DefaultInventory[i] ) == None)
		{
			// Only activate the first weapon
			PlayerPawn.CreateInventory(DefaultInventory[i], (i > 0));
		}
	}
	PlayerPawn.AddDefaultInventory();
}

static function string GetPRILogName(PlayerReplicationInfo PRI)
{
	if (Rx_PRI(PRI) != None)
		return class'Rx_PRI'.static.LogNameOf(PRI);
	else if (Rx_DefencePRI(PRI) != None)
		return class'Rx_DefencePRI'.static.LogNameOf(PRI);
	else if (Rx_ScriptedBotPRI(PRI) != None)
		return class'Rx_ScriptedBotPRI'.static.LogNameOf(PRI);
	else
	{
		`log("Tried to get LogName of a non-Rx PRI class.");
		return"";
	}
}

function DropPowerUp(Rx_Pawn Killed)
{
	local Rx_Pickup PowerUp;
	local int index;

	if (PowerUpClasses.Length == 0)
		return;

	index = Rand(PowerUpClasses.Length + Killed.GetRxFamilyInfo().default.PowerUpClasses.Length);

	if (index < PowerUpClasses.Length)
		PowerUp = Spawn(PowerUpClasses[index], Self, , Killed.Location, Killed.Rotation, , true);
	else
		PowerUp = Spawn(Killed.GetRxFamilyInfo().default.PowerUpClasses[index - PowerUpClasses.Length], Self, , Killed.Location, Killed.Rotation, , true);

	PowerUp.PickupsRemaining = 1;
	PowerUp.SetTimer(PowerUp.DespawnTime, false, 'Expire');
}

// managed extra score for kills and destruction (only player and vehicles)
function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local Rx_PRI PlayerPRI;
	local string KillerLogStr;
	local string OwnerLogStr;
	local bool		bEnemyKill;
	local UTPlayerReplicationInfo KillerPRI, KilledPRI;
	local UTVehicle V;

	local Rx_Mutator Rx_Mut;
	local bool bPlayerDeath;
	local Rx_Bot_Scripted B;

	if(bAllowDeployedDefenceKills && Rx_Defence_Controller(Killer) != None && Rx_Defence(Killer.Pawn).Deployer != None)
	{
		Killed(Controller(Rx_Defence(Killer.Pawn).Deployer.Owner), KilledPlayer, KilledPawn, damageType);
		return;
	}
	bPlayerDeath = Rx_Bot_Scripted(KilledPlayer) == None;

	if(BountyRankList.Length > 0)
		UpdatePlayerBounty(Killer, KilledPlayer, KilledPawn);

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		Rx_Mut.OnPlayerKill(Killer, KilledPlayer, KilledPawn, damageType);
	}

	if ( Killer != None )
	{
		PlayerPRI = Rx_PRI(Killer.PlayerReplicationInfo);

		// Adds logging for AIControllers, but passes objects with a PRI on to normal logging.
		if (AIController(Killer) != None && Killer.PlayerReplicationInfo == None)
			KillerLogStr = Class.static.GetTeamName(Killer.GetTeamNum()) $ ",ai," $ Killer.Pawn.Class.name;
		else
			KillerLogStr = `PlayerLog(Killer.PlayerReplicationInfo);

		// score for vehicles here
		if ( Rx_Vehicle(KilledPawn) != None && KilledPawn.GetTeamNum() != Killer.GetTeamNum() )
		{
			if (PlayerPRI != None)
				PlayerPRI.AddScoreToPlayerAndTeam(Rx_Vehicle(KilledPawn).PointsForDestruction);

			OwnerLogStr = (Rx_Vehicle(KilledPawn).BoundPRI != none) ? `PlayerLog(Rx_Vehicle(KilledPawn).BoundPRI) : "";

			if (Rx_Defence(KilledPawn) != None)
				RxLog("GAME"`s "Destroyed;" `s "defence" `s KilledPawn.Class `s "by" `s KillerLogStr`s "with"`s damageType `s OwnerLogStr);
			else if (Rx_Defence_Emplacement(KilledPawn) != None)
				RxLog("GAME"`s "Destroyed;" `s "emplacement" `s KilledPawn.Class `s "by" `s KillerLogStr`s "with"`s damageType `s OwnerLogStr);
			else
			{
				RxLog("GAME"`s "Destroyed;" `s "vehicle" `s KilledPawn.Class `s "by" `s KillerLogStr`s "with"`s damageType `s OwnerLogStr);
/*				if(!bPlayerDeath)
				{
					B = Rx_Bot_Scripted(KilledPlayer);

					if(B != None && !B.ShouldSurviveVehicleDeath())
					{
						HandleScriptedDeath(B);
					}
				}
*/
			}
		}
/*		else if(Rx_Vehicle(KilledPawn) != None && KilledPlayer != None && !bPlayerDeath)
		{
			B = Rx_Bot_Scripted(KilledPlayer);

			if(B != None && !B.ShouldSurviveVehicleDeath())
			{
				HandleScriptedDeath(B);
			}
		}
*/
		// score for pawns here
		else if ( Rx_Pawn(KilledPawn) != None && KilledPlayer != none)
		{

			// If scripted bot death, interact with its' spawner, if there's any
/*			if(!bPlayerDeath)
			{
				B = Rx_Bot_Scripted(KilledPlayer);

				if(B != None)
				{
					HandleScriptedDeath(B);
				}
			}
*/
			if (PlayerPRI != None)
			{
				if (KilledPlayer.GetTeamNum() != Killer.GetTeamNum() )
				{
					PlayerPRI.AddScoreToPlayerAndTeam(class<Rx_FamilyInfo>(Rx_Pawn(KilledPawn).CurrCharClassInfo).default.PointsForKill, bCreditsFromKillScore);
					if(bPlayerDeath)
					{
						Rx_TeamInfo(PlayerPRI.Team).AddKill();
						Rx_TeamInfo(KilledPlayer.PlayerReplicationInfo.Team).AddDeath();
					}
				}
				if(Killer != KilledPlayer && PlayerController(Killer) != none && bPlayerDeath)
				{
					Rx_Controller(PlayerController(Killer)).PlayKillSound();
					//if(Rx_Controller(PlayerController(Killer)).bSuspect)
					Rx_Controller(PlayerController(Killer)).SLogKill(damageType, KilledPlayer.PlayerReplicationInfo.Playername);
				}
			}


			if (KilledPlayer != none && Killer != KilledPlayer)
			{
				if(bPlayerDeath)
					RxLog("GAME"`s "Death;"`s "player"`s `PlayerLog(KilledPlayer.PlayerReplicationInfo)`s "by"`s KillerLogStr `s "with"`s damageType `s Rx_Pawn(KilledPawn).bHeadshot);
				else
					RxLog("GAME"`s "Death;"`s "player"`s KillerLogStr`s "killed a Scripted Bot");
			}
			else
				RxLog("GAME"`s "Death;"`s "player"`s KillerLogStr`s "suicide by"`s damageType);

			if (bAllowPowerUpDrop)
				DropPowerUp(Rx_Pawn(KilledPawn));
		}
	}
	else if (KilledPlayer != none && Rx_PRI(KilledPlayer.PlayerReplicationInfo) != None)    // ignore ai being destroyed (notably harvester death due to refinery lost)
	{
		`SupressNullDamageType(RxLog("GAME"`s "Death;"`s "player"`s `PlayerLog(KilledPlayer.PlayerReplicationInfo)`s "died by"`s damageType));
	}

	if (KilledPlayer != none && Rx_Vehicle(KilledPawn) == None && !bPlayerDeath)
	{
		B = Rx_Bot_Scripted(KilledPlayer);
		if(B != None)
		{
			HandleScriptedDeath(B, Killer);
		}
	}

	if (bPlayerDeath && UTBot(KilledPlayer) != None )
		UTBot(KilledPlayer).WasKilledBy(Killer);

	if ( Killer != None )
		KillerPRI = UTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( KilledPlayer != None )
		KilledPRI = UTPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);

	bEnemyKill = ( ((KillerPRI != None) && (KillerPRI != KilledPRI) && (KilledPRI != None)) && (!bTeamGame || (KillerPRI.Team != KilledPRI.Team)) );

	if ( (KillerPRI != None) && UTVehicle(KilledPawn) != None )
	{
		KillerPRI.IncrementVehicleKillStat(UTVehicle(KilledPawn).GetVehicleKillStatName());
	}
	if (bPlayerDeath && KilledPRI != None)
	{
		KilledPRI.LastKillerPRI = KillerPRI;

		if(Rx_PRI(KilledPRI) != None)
		{
			if ( class<UTDamageType>(DamageType) != None )
			{
				class<UTDamageType>(DamageType).static.ScoreKill(KillerPRI, KilledPRI, KilledPawn);
			}
			else
			{
				// assume it's some kind of environmental damage
				if ( (KillerPRI == KilledPRI) || (KillerPRI == None) )
				{
					KilledPRI.IncrementSuicideStat('SUICIDES_ENVIRONMENT');
				}
				else
				{
					KillerPRI.IncrementKillStat('KILLS_ENVIRONMENT');
					KilledPRI.IncrementDeathStat('DEATHS_ENVIRONMENT');
				}
			}
			if ( KilledPRI.Spree > 4 )
			{
				EndSpree(KillerPRI, KilledPRI);
			}
			else
			{
				KilledPRI.Spree = 0;
			}
		}

		if ( KillerPRI != None )
		{
			KillerPRI.IncrementKills(bEnemyKill);

			if ( bEnemyKill )
			{
				V = UTVehicle(KilledPawn);

				if ( !bFirstBlood )
				{
					bFirstBlood = True;
					BroadcastLocalizedMessage( class'UTFirstBloodMessage', 0, KillerPRI );
					KillerPRI.IncrementEventStat('EVENT_FIRSTBLOOD');
				}
			}
		}
	}

    if( KilledPlayer != None && KilledPlayer.bIsPlayer )
	{
		KilledPlayer.PlayerReplicationInfo.IncrementDeaths();
		KilledPlayer.PlayerReplicationInfo.SetNetUpdateTime(FMin(KilledPlayer.PlayerReplicationInfo.NetUpdateTime, WorldInfo.TimeSeconds + 0.3 * FRand()));
		BroadcastDeathMessage(Killer, KilledPlayer, damageType);
	}

    if( KilledPlayer != None  && bPlayerDeath)
	{
		ScoreKill(Killer, KilledPlayer);
	}

	DiscardInventory(KilledPawn, Killer);

	if(Killer != none)
		NotifyKilled(Killer, KilledPlayer, KilledPawn, damageType);

    if ( (WorldInfo.NetMode == NM_Standalone) && (PlayerController(KilledPlayer) != None) )
    {
		// clear telling bots not to get into nearby vehicles
		for ( V=VehicleList; V!=None; V=V.NextVehicle )
			if ( WorldInfo.GRI.OnSameTeam(KilledPlayer,V) )
				V.PlayerStartTime = 0;
	}

	if(bPlayerDeath)
		ScoreRenKill(Killer,KilledPlayer);

	if(Killer != none && KilledPlayer != none)
	{
		`RecordDeathEvent(NORMAL, Killer, damageType, KilledPlayer);
	}
	else if(KilledPlayer != none)
	{
		`RecordDeathEvent(NORMAL, none, damageType, KilledPlayer);
	}

	if(bAutoBalancerEnabled)
	{
		if(Rx_GRI(GameReplicationInfo).bAutobalanceInProgress && KilledPlayer.GetTeamNum()!=Rx_GRI(GameReplicationInfo).TeamNeedingPlayers && bAutoBalanceForced && bAutoBalanceSwapOnDeath)
		{
			ProcessVolunteer(Rx_Controller(KilledPlayer),true);
		}
	}
}

function HandleScriptedDeath(Rx_Bot_Scripted B, Controller Killer)
{
	local Rx_Bot_Scripted_Customizeable BCust;
	TriggerEventClass(class'SeqEvent_Death',B);

	BCust = Rx_Bot_Scripted_Customizeable(B);

	if(BCust != None && BCust.MySpawner != None)
	{
		BCust.MySpawner.NotifyPawnDeath(BCust);
	}
}

function UpdatePlayerBounty(Controller Killer, Controller Victim, Pawn KilledPawn)
{
	local Rx_PRI KillerPRI, VictimPRI;

	if(Vehicle(KilledPawn) == None && Rx_PRI(Victim.PlayerReplicationInfo) != None)
	{
		if(Killer != None)
			KillerPRI = Rx_PRI(Killer.PlayerReplicationInfo);

		VictimPRI = Rx_PRI(Victim.PlayerReplicationInfo);

		if(KillerPRI != None && Victim.GetTeamNum() != Killer.GetTeamNum())
			IncrementBounty(KillerPRI);


		if(KillerPRI != None && KillerPRI != VictimPRI && KillerPRI.GetTeamNum() != VictimPRI.GetTeamNum())
			RewardBounty(KillerPRI, VictimPRI);
		else
			PenalizeBounty(VictimPRI, VictimPRI.GetTeamNum());
	}
}

function IncrementBounty(Rx_PRI KillerPRI)
{
	local int i;
	local bool bAnnounceBounty;

	KillerPRI.BountyKill++;

	for(i=0;i<BountyRankList.Length;i++)
	{
		if(KillerPRI.BountyKill >= BountyRankList[i].Threshold && KillerPRI.BountyRank < i)
		{
			KillerPRI.BountyRank = i;
			KillerPRI.BountyName = BountyRankList[i].RankName;
			if(BountyPermaspotRank >= 0 && KillerPRI.BountyRank >= BountyPermaspotRank && !KillerPRI.IsTimerActive('BountySpot'))
			{
				KillerPRI.SetTimer(1.0, true, 'BountySpot');
			}
			if(BountyPermaspotRank >= 0 && KillerPRI.BountyRank == BountyPermaspotRank && Rx_Controller(KillerPRI.Owner) != None)
			{
				Rx_Controller(KillerPRI.Owner).CTextMessage("WARNING - You are being tracked as priority target",'Red',120,,,true, BountyWarnSound);
			}

			bAnnounceBounty = true;
			break;
		}
	}

	if(KillerPRI.BountyRank >= 0)
	{
		KillerPRI.BountyCredits =  BountyRankList[KillerPRI.BountyRank].CreditsBase + (BountyRankList[KillerPRI.BountyRank].CreditsMult * KillerPRI.BountyKill);
		KillerPRI.BountyVP = BountyRankList[KillerPRI.BountyRank].VPBase + (BountyRankList[KillerPRI.BountyRank].VPMult * KillerPRI.BountyKill);

		if (bAnnounceBounty)
			AnnounceBounty(KillerPRI);
	}
}

function RewardBounty(Rx_PRI Killer, Rx_PRI Victim)
{
	if(Victim.BountyRank >= 0) //non-ranked doesn't get bounty
	{
		Killer.AddCredits(Victim.BountyCredits);
		if(Rx_Controller(Killer.Owner) != None)
		{
			Rx_Controller(Killer.Owner).DisseminateVPString("["$Victim.PlayerName@"Bounty - "$Victim.BountyName$"]&"$Round(Victim.BountyVP)$"&");
		}
		else
			Killer.AddVP(Victim.BountyVP);

		AnnounceClaim(Killer,Victim);

	}

	ResetBounty(Victim);
}

function PenalizeBounty(Rx_PRI PenalizedPRI, byte PenalizedTeam)
{
	local int TeamSize;
	local Rx_PRI RxPRI;
	local Controller C;

	if(PenalizedPRI.BountyRank < 0)
	{
		ResetBounty(PenalizedPRI);
		return;
	}

	TeamSize = Teams[1 - PenalizedTeam].Size;

	foreach WorldInfo.AllControllers(class'Controller', c)
	{
		RxPRI = Rx_PRI(c.PlayerReplicationInfo);

		if(RxPRI == None || RxPRI == PenalizedPRI || c.GetTeamNum() == PenalizedTeam)
			continue;

		RxPRI.AddCredits(PenalizedPRI.BountyCredits * 2 / TeamSize);
		if(Rx_Controller(c) != None)
		{
			Rx_Controller(c).DisseminateVPString("["$PenalizedPRI.PlayerName@"Humiliation - "$PenalizedPRI.BountyName$"]&"$Round(PenalizedPRI.BountyVP * 2 / TeamSize)$"&");
		}
		else
			RxPRI.AddVP(PenalizedPRI.BountyVP  * 2 / TeamSize);

	}
	AnnounceClaim(None,PenalizedPRI, true, PenalizedTeam);

	ResetBounty(PenalizedPRI);
}

function ResetBounty(Rx_PRI Victim)
{
	Victim.BountyRank = -1;
	Victim.BountyName = "";
	Victim.BountyKill = 0;
	Victim.BountyCredits = 0;
	Victim.BountyVP = 0;

	if(Victim.IsTimerActive('BountySpot'))
	{
		Victim.ClearTimer('BountySpot');
	}
}

function AnnounceBounty(Rx_PRI Killer)
{
	local string Announcement;

	Announcement = Killer.PlayerName @ "is now ranked"@ Killer.BountyName$"!";

	Rx_Controller(Killer.Owner).CTextMessage("You are now ranked"@Killer.BountyName@"("$Round(Killer.BountyCredits)$")");

	WorldInfo.Game.Broadcast(None, Announcement);
}

function AnnounceClaim(Rx_PRI Killer, Rx_PRI Victim, optional bool bHumiliation, optional int VictimTeam = -1)
{
	local string Announcement;

	if(VictimTeam < 0)
		VictimTeam = Victim.GetTeamNum();

	if(!bHumiliation)
		Announcement = Killer.PlayerName @ "has claimed"@ Victim.PlayerName$"'s bounty! ("$Round(Victim.BountyCredits)$")";
	else
		Announcement = Victim.PlayerName@"has died. Their bounty ("$Round(Victim.BountyCredits)$") was split!";

	WorldInfo.Game.Broadcast(None, Announcement);
}

function GameEventsPoll()
{
	local Rx_Vehicle V;

	ForEach `WorldInfoObject.AllPawns(class'Rx_Vehicle', V)
	{
		if(RxIfc_Harvester(V) == none)
		{
			`RecordGamePositionStat(VEHICLE_LOCATION_POLL,V.Location, 1);
			if(v.Team == TEAM_GDI)
			{
				`RecordGamePositionStat(VEHICLE_LOCATION_POLL_GDI,V.Location, 1);
			}
			else if(v.Team == TEAM_NOD)
				`RecordGamePositionStat(VEHICLE_LOCATION_POLL_NOD,V.Location, 1);
		}

		`RecordGamePositionStat(VEHICLE_WITH_HARV_LOCATION_POLL,V.Location, 1);
	}

}

function ScoreRenKill(Controller Killer, Controller Other)
{
	if ( Killer != None && killer.PlayerReplicationInfo != None && Rx_PRI(killer.PlayerReplicationInfo) != None &&
		 Other != None && Other.PlayerReplicationInfo != None && Rx_PRI(Other.PlayerReplicationInfo) != None && Killer != Other)
	{
		Rx_PRI(Killer.PlayerReplicationInfo).AddRenKill(,!Other.bIsPlayer || Rx_Bot_Scripted(Other) != None);
	}

}

/** Suppress death messages caused by team switch and disconnects. */
function BroadcastDeathMessage(Controller Killer, Controller Other, class<DamageType> DamageType)
{
	if (DamageType == class'DamageType' && (Killer == Other || Killer == None))
		return;

	if (Killer == Other)
		BroadcastLocalized(self,DeathMessageClass, 1, None, Other.PlayerReplicationInfo, DamageType);
	else if (Killer == None)
		BroadcastLocalized(self,DeathMessageClass, 2, None, Other.PlayerReplicationInfo, DamageType);
	else
		super.BroadcastDeathMessage(Killer, Other, DamageType);
}

function EndSpree(UTPlayerReplicationInfo Killer, UTPlayerReplicationInfo Other);

function bool CheckScore(PlayerReplicationInfo Scorer)
{
	return false;
}

function UTBot OnAddBot(UTBot bot)
{
	if (bot != None)
	{
		`LogRxPub("GAME" `s "Spawn;" `s "bot" `s `PlayerLog(bot.PlayerReplicationInfo));
		//`RecordLoginChange(LOGIN,bot,bot.PlayerReplicationInfo.PlayerName,bot.PlayerReplicationInfo.UniqueId, false)
		CheckForBeaconToggle();
	}
	return bot;
}

function InitializeBot(UTBot NewBot, UTTeamInfo BotTeam, const out CharacterInfo BotInfo)
{
	Rx_Bot(NewBot).RxInitialize(AdjustedDifficulty, BotInfo, BotTeam);

	if(Rx_Bot_Scripted(NewBot) == None)
		{
			BotTeam.AddToTeam(NewBot);
			ChangeName(NewBot, BotInfo.CharName, false);
			BotTeam.SetBotOrders(NewBot);
		}
}

exec function AddBots(int Num)
{
	local int AddCount;

	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers+NumBots)+Num, 1, 64);

	// add up to 8 immediately, then the rest automatically via game timer.
	while ( (NumPlayers + NumBots < DesiredPlayerCount) && (AddBot() != none) && (AddCount < 8) )
	{
		`log("added bot");
		AddCount++;
	}
}

exec function RxAddBots(int Num, optional int Skill, optional String ToTeam)
{
	local int AddCount;
	local bool bUseTeamIndex;
	local int TeamIndex;

	if(ToTeam != "")
	{
		bUseTeamIndex = true;

		if(ToTeam ~= "GDI")
		{
			TeamIndex = 0;
		}
		else if (ToTeam ~= "Nod")
		{
			TeamIndex = 1;
		}
		else
			bUseTeamIndex = false;
	}

	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers+NumBots)+Num, 1, 64);

	// add up to 8 immediately, then the rest automatically via game timer.
	while ( (NumPlayers + NumBots < DesiredPlayerCount) && (RxAddBot(Skill, ,bUseTeamIndex,TeamIndex) != none) && (AddCount < 8) )
	{
		`log("added bot");
		AddCount++;
	}
}

exec function UTBot AddNamedBot(string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{

	DesiredPlayerCount = Clamp(Max(DesiredPlayerCount, NumPlayers + NumBots) + 1, 1, 64);
	return AddBot(BotName, bUseTeamIndex, TeamIndex);
}

function UTBot RxAddBot(optional int Skill, optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local int first, second;
	local PlayerController PC;
	local UTBot B;

	if(bBotsDisabled || (NumPlayers+NumBots >= MaxPlayers))
		return None;

	if(bUseTeamIndex)
	{
		B = OnAddBot(super.AddBot(BotName, bUseTeamIndex, TeamIndex));
	}
	else
	{
		first = 0;
		second = 1;
		// imbalance teams in favor of bot team in single player
		if (  WorldInfo.NetMode == NM_Standalone )
		{
			ForEach LocalPlayerControllers(class'PlayerController', PC)
			{
				if ( (PC.PlayerReplicationInfo.Team != None) && (PC.PlayerReplicationInfo.Team.TeamIndex == 1) )
				{
					first = 1;
					second = 0;
				}
				break;
			}
		}

		if ( Rx_TeamInfo(Teams[first]).Size < Rx_TeamInfo(Teams[second]).Size )
		{
			B = OnAddBot(super.AddBot(BotName, true, first));
		}
		else
		{
			B = OnAddBot(super.AddBot(BotName, true, second));
		}
	}

	if(B != None && Skill > 0)
	{
		Skill = Clamp(Skill,1,9);
		B.Skill = Skill;
		B.ResetSkill();
	}

	return B;
}

function UTBot AddBot(optional string BotName, optional bool bUseTeamIndex, optional int TeamIndex)
{
	local int first, second;
	local PlayerController PC;

	if(bBotsDisabled || (NumPlayers+NumBots >= MaxPlayers))
		return None;

	if(bUseTeamIndex)
	{
		return OnAddBot(super.AddBot(BotName, bUseTeamIndex, TeamIndex));
	}
	else
	{
		first = 0;
		second = 1;
		// imbalance teams in favor of bot team in single player
		if (  WorldInfo.NetMode == NM_Standalone )
		{
			ForEach LocalPlayerControllers(class'PlayerController', PC)
			{
				if ( (PC.PlayerReplicationInfo.Team != None) && (PC.PlayerReplicationInfo.Team.TeamIndex == 1) )
				{
					first = 1;
					second = 0;
				}
				break;
			}
		}

		if ( Rx_TeamInfo(Teams[first]).Size < Rx_TeamInfo(Teams[second]).Size )
		{
			return OnAddBot(super.AddBot(BotName, true, first));
		}
		else
		{
			return OnAddBot(super.AddBot(BotName, true, second));
		}
	}
}

function bool TooManyBots(Controller botToRemove)
{
	if(NumPlayers+NumBots > 64) // if exceeding player limit, there's *way* too many
		return true;
/*
	if(bFillSpaceWithBots)
		return false;

	if ((Rx_Bot(botToRemove).GetTeamNum() == TEAM_GDI && Teams[TEAM_GDI].Size > Teams[TEAM_NOD].Size)
			|| (Rx_Bot(botToRemove).GetTeamNum() == TEAM_NOD && Teams[TEAM_NOD].Size > Teams[TEAM_GDI].Size))
	{
			return true;
	}
*/
	return false;
}

function DetonatePedestal(Rx_Weapon_DeployedBeacon Beacon)
{
	local Rx_Building_Team_Internals B;
	local Rx_Controller PC;
	local String LostTeamName;

	bPedestalDetonated = true;
	PedestalDetonator = Beacon.GetTeamNum();
	if(PedestalDetonator == TEAM_GDI)
		LostTeamName = "Nod";
	else
		LostTeamName = "GDI";

	foreach AllActors(class'Rx_Building_Team_Internals', B)
	{
		if(B.GetTeamNum() == Beacon.GetTeamNum())
		{
			B.HealthLocked = true;
		}
	}

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
		if (PC.GetTeamNum() == PedestalDetonator)
		{
			PC.CTextMessage(Caps(LostTeamName@"base has been eradicated!"),'Green',180);
		}
		else
		{
			PC.CTextMessage(Caps(LostTeamName@"base has been eradicated!"),'Red',180);
		}
	}

	SetTimer(4, false, 'PedestalEndGame');
}

function PedestalEndGame ()
{
	EndRxGame("Buildings",PedestalDetonator);
}

function CheckBuildingsDestroyed(Actor destroyedBuilding, Rx_Controller StarPC)
{
	local BuildingCheck Check;
	local PlayerReplicationInfo pri;
	local Rx_Controller PC;

	/*Show message where people will actually see it -Yosh (Remember the outrage when destruction and beacon messages were moved to the middle left? Yeah.. neither do the people that ranted about it.)*/
	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
		if(!Rx_Building(destroyedBuilding).bSignificant)
		{
			if(StarPC != None && PC.GetTeamNum() == StarPC.GetTeamNum())
				PC.DisseminateVPString("[Team Building Kill Bonus]&" $ class'Rx_VeterancyModifiers'.default.Ev_BuildingDestroyed*Rx_Game(WorldInfo.Game).CurrentBuildingVPModifier[StarPC.GetTeamNum()] $ "&");
			continue;
		}

		if (StarPC == none && !bPedestalDetonated)
			PC.CTextMessage(Caps("The"@destroyedBuilding.GetHumanReadableName()@ "was destroyed!"),'Red', 180);
		else if (PC.GetTeamNum() == StarPC.GetTeamNum())
		{
			if(!bPedestalDetonated)
				PC.CTextMessage(Caps("The"@destroyedBuilding.GetHumanReadableName()@ "was destroyed!"),'Green',180);

			PC.DisseminateVPString("[Team Building Kill Bonus]&" $ class'Rx_VeterancyModifiers'.default.Ev_BuildingDestroyed*Rx_Game(WorldInfo.Game).CurrentBuildingVPModifier[StarPC.GetTeamNum()] $ "&");
		}
		else if (!bPedestalDetonated)
		{
			PC.CTextMessage(Caps("The"@destroyedBuilding.GetHumanReadableName()@ "was destroyed!"),'Red',180);
		}
	}
	//End show message where people will actually look at it.

	if (Role == ROLE_Authority)
	{
		CurrentBuildingVPModifier[destroyedBuilding.GetTeamNum()] = fmin(MaxBuildingVPMod, CurrentBuildingVPModifier[destroyedBuilding.GetTeamNum()]+1.0);

		if(!bPedestalDetonated && Rx_Building(destroyedBuilding).bSignificant)	// don't check victory for insignificant buildings
		{
			Check = CheckBuildings();
			if (Check == BC_GDIDestroyed || Check == BC_NodDestroyed || Check == BC_TeamsHaveNoBuildings)
			{
				if(Check == BC_GDIDestroyed)
					EndRxGame("Buildings",TEAM_NOD);
				else if(Check == BC_NodDestroyed)
					EndRxGame("Buildings",TEAM_GDI);
				else
					EndRxGame("Buildings",255);
			}
			else
			{
				if(bBuildingsRevive && BuildingReviveTime > 0)
				{
					Rx_Building(destroyedBuilding).StartRevival(BuildingReviveTime);
				}
			}
		}

		//Still repair insignificant team buildings
		if(!bPedestalDetonated && !Rx_Building(destroyedBuilding).bSignificant && bBuildingsRevive && BuildingReviveTime > 0)
		{
			Rx_Building(destroyedBuilding).StartRevival(BuildingReviveTime);
		}

		if (bEnableAirdrops && (RxIfc_FactoryVehicle(destroyedBuilding) != None || Rx_Building_AirTower(destroyedBuilding) != none && (Rx_Building_Helipad_Nod(destroyedBuilding) == None && Rx_Building_Helipad_GDI(destroyedBuilding) == None)))
		{
			if(destroyedBuilding.GetTeamNum() == 1 && PurchaseSystem.AreTeamFactoriesDestroyed(TEAM_NOD))
			{
				foreach WorldInfo.GRI.PRIArray(pri)
				{
					if(Rx_Pri(pri) != None && (Rx_Pri(pri).GetTeamNum() == TEAM_NOD) && Rx_Pri(pri).AirdropCounter == 0)
					{
						Rx_Pri(pri).AirdropCounter++;
						Rx_Pri(pri).LastAirdropTime=WorldInfo.TimeSeconds;
					}
				}
				VehicleManager.bNodIsUsingAirdrops = true;
				VehicleManager.NodAdditionalAirdropProductionDelay = 20.0;
			}
			else if(destroyedBuilding.GetTeamNum() == 0 && PurchaseSystem.AreTeamFactoriesDestroyed(TEAM_GDI))
			{
				foreach WorldInfo.GRI.PRIArray(pri)
				{
					if(Rx_Pri(pri) != None && (Rx_Pri(pri).GetTeamNum() == TEAM_GDI) && Rx_Pri(pri).AirdropCounter == 0)
					{
						Rx_Pri(pri).AirdropCounter++;
						Rx_Pri(pri).LastAirdropTime=WorldInfo.TimeSeconds;
					}
				}
				VehicleManager.bGDIIsUsingAirdrops = true;
				VehicleManager.GDIAdditionalAirdropProductionDelay = 20.0;
			}
		}

	if(Rx_Building(destroyedBuilding).GetTeamNum() == 0)
			DestroyedBuildings_GDI++;
		else
			DestroyedBuildings_Nod++;

	}


}


/** CheckBuildings()
 *
 *
 *  RETURNS:
 *   BC_TeamsHaveBuildings      - both teams got min. 1 building left
 *   BC_GDIDestroyed            - means GDI lost all buildings (but Nod not!)
 *   BC_NodDestroyed            - means Nod lost all buildings (but GDI not!)
 *   BC_TeamsHaveNoBuildings    - means both teams lost all buildings
 **/
function BuildingCheck CheckBuildings ()
{
	local Rx_Building B;
	local bool BuildGDI, BuildNod;


	foreach AllActors(class'Rx_Building', B)
	{
		if(Rx_Building_Techbuilding(B) != None || !B.bSignificant)
			continue;
		if (B.GetTeamNum() == TEAM_GDI && !(B.IsDestroyed()) ) // GDI
		{
			BuildGDI = true;
		}
		else if (B.GetTeamNum() == TEAM_NOD && !(B.IsDestroyed())) // Nod
		{
			BuildNod = true;
		}
	}

	if ( !BuildGDI && BuildNod )
	{
		return BC_GDIDestroyed;
	}
	else if ( BuildGDI && !BuildNod )
	{
		return BC_NodDestroyed;
	}
	else if ( !BuildGDI && !BuildNod )
	{
		return BC_TeamsHaveNoBuildings;
	}

	return BC_TeamsHaveBuildings;
}

State MatchOver
{
	function BeginState( name PreviousState )
	{
		local Rx_Mutator Rx_Mut;

		//`log("################################ -( MatchOver:BeginState() )-");
		RenEndTime = WorldInfo.RealTimeSeconds + MapVoteTime + 10;
		`log("RenEndTime: " $ RenEndTime);
		//M.Palko endgame crash track log.
		`log("------------------------------Now in state: MatchOver");
		UTGameReplicationInfo(GameReplicationInfo).bMatchIsOver = true;
		//M.Palko endgame crash track log.
		`log("------------------------------Game rep info bMatchIsOver set to true");
		super.BeginState(PreviousState);

		Rx_Mut = GetBaseRXMutator();
		if (Rx_Mut != None)
		{
			Rx_Mut.OnMatchEnd();
		}
	}

	function RestartGame()
	{
		LANBroadcast.close();
		if((RenEndTime < WorldInfo.RealTimeSeconds) && (!bAdminsStartMapVote || (bAdminsStartMapVote && bStartRestarting)))
		{
			EndLogging("Game Ended");
			super(GameInfo).RestartGame();
		}
	}
}

function RestartGame()
{
	LANBroadcast.close();
	Super.RestartGame();
}

function bool IsWinningTeam( TeamInfo T )
{
	local Rx_TeamInfo Tinfo;
	Tinfo = Rx_TeamInfo(T);

	if (Tinfo != none && Tinfo.TeamIndex == WinnerTeamNum)
		return true;
	else return false;
}

State MatchInProgress
{
	function BeginState( Name PreviousState )
	{
		super.BeginState(PreviousState);
	}

	function EndState( Name NextStateName )
	{
		super.EndState(NextStateName);
	}

	function SwapTeams()
	{
		Global.SwapTeams();
		Broadcast(None, "Teams have been swapped.");
	}

	function Timer()
	{
		local PlayerController P;

		Global.Timer();
		if ( !bFinalStartup )
		{
			bFinalStartup = true;
			PlayStartupMessage();
		}
		// force respawn failsafe
		if ( ForceRespawn() )
		{
			foreach WorldInfo.AllControllers(class'PlayerController', P)
			{
				if (P.Pawn == None && !P.PlayerReplicationInfo.bOnlySpectator && !P.IsTimerActive('DoForcedRespawn'))
				{
					P.ServerReStartPlayer();
				}
			}
		}
		if ( NeedPlayers() )
		{
			AddBot();
		}

		if ( bOverTime )
		{
			EndGame(None,"TimeLimit");
		}
		else if ( default.TimeLimit > 0 )
		{
			GameReplicationInfo.bStopCountDown = false;
			if ( GameReplicationInfo.RemainingTime <= 0 )
			{
				EndGame(None,"TimeLimit");
			}
			else if(default.TimeLimit > 2 && !bWarnedTwoMinutes && GameReplicationInfo.RemainingTime <= 120)
			{
				MarqueeBroadcast(255, T_Marquee_2MW, 4.0, TwoMinuteWarnSound);
				bWarnedTwoMinutes = true; 
			}
			else if(default.TimeLimit > 5 && !bWarnedFiveMinutes && GameReplicationInfo.RemainingTime <= 300)
			{
				MarqueeBroadcast(255, T_Marquee_5MW, 4.0, TwoMinuteWarnSound);
				bWarnedFiveMinutes = true; 
			}
		}
		else if ( (MaxLives > 0) && (NumPlayers + NumBots != 1) )
		{
			CheckMaxLives(none);
		}
	}
}

function FindRefineries()
{
	local Rx_Building ref;

	foreach AllActors(class'Rx_Building', ref,class'RxIfc_Refinery')
	{
//		if(!ref.ShouldSpawnHarvester())
//			continue;


		if (ref.GetTeamNum() == TEAM_GDI ) // GDI
		{
			TeamCredits[TEAM_GDI].Refinery.AddItem(RxIfc_Refinery(ref));
		}
		else if (ref.GetTeamNum() == TEAM_NOD ) // Nod
		{
			TeamCredits[TEAM_NOD].Refinery.AddItem(RxIfc_Refinery(ref));
		}

	}
}

function StartMatch()
{
	local Controller PC;
	local Rx_Mutator Rx_Mut;

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		Rx_Mut.OnMatchStart();
	}

	RxLog("MAP" `s "Start;" `s GetPackageName());

	super.StartMatch();

	if (TeamMode != 4)
	{
		AdjustTeamBalance();
		AdjustTeamSize();
		AdjustAFKs();
	}
	else
	{
		`RxEngineObject.ClearTeams();
	}

	if (TeamCredits[TEAM_GDI].PlayerRI.Length > 0)
	{
		TeamCredits[TEAM_GDI].PlayerRI.Remove(0, TeamCredits[TEAM_GDI].PlayerRI.Length-1);
	}
	if (TeamCredits[TEAM_NOD].PlayerRI.Length > 0)
	{
		TeamCredits[TEAM_NOD].PlayerRI.Remove(0, TeamCredits[TEAM_NOD].PlayerRI.Length-1);
	}

	foreach WorldInfo.AllControllers( class'Controller', PC )
	{
		if(UTPlayerController(PC) != None || Rx_Bot(PC) != None) {

			if(TeamCredits[PC.GetTeamNum()].PlayerRI.Find(Rx_PRI(PC.PlayerReplicationInfo)) < 0) {
				TeamCredits[PC.GetTeamNum()].PlayerRI.AddItem(Rx_PRI(PC.PlayerReplicationInfo));
				Rx_PRI(PC.PlayerReplicationInfo).SetCredits( Rx_Game(WorldInfo.Game).InitialCredits );

			}
		}

		if (Rx_Controller(PC) != None)
		{
			Rx_Controller(PC).ClientUpdateDiscordPresence(MaxPlayers);

			if(PC.PlayerReplicationInfo.bOnlySpectator)
			{
				Rx_Controller(PC).SetPlayerIsReady();
			}

			if(!Rx_Controller(PC).bPlayerIsReady)
			{
				Rx_PRI(PC.PlayerReplicationInfo).ServerDeclareAFK();
			}
		}
	}

	if(!Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap)
		VehicleManager.SpawnInitialHarvesters();

}

// Teams are balanced and sorted into lists at the end of a map. But incase someone leaves at the start of the new map, some players might need to be switched to bring back balance to the force.
// Balances based on player rankings from last map.
function AdjustTeamBalance()
{
	local float team1ranking;
	local float team2ranking;
	local Rx_Controller highestRankedPlayer;
	local PlayerReplicationInfo pri;
	local Rx_Mutator Rx_Mut;


	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		if(Rx_Mut.adjustTeamBalance())
			return;
	}

	if(TeamMode != 3) // if our server doesn't do shuffle, don't
		return;

	foreach WorldInfo.GRI.PRIArray(pri)
	{
		if(Rx_Pri(pri) != None)
			if(pri.Team.TeamIndex == TEAM_GDI)
				team1ranking += Rx_PRI(pri).OldRenScore;
			else
				team2ranking += Rx_PRI(pri).OldRenScore;
		if(TeamMode != 1 && TeamMode != 2 && Rx_Controller(pri.owner) != None && !Rx_Controller(pri.owner).bPlayerIsReady)
		{
			AFKPlayers[pri.GetTeamNum()] += 1;
		}
	}

	if(team1ranking == 0.0 && team2ranking == 0.0)
		return;

	if(team1ranking > team2ranking)
		highestRankedPlayer = getHighestRankedPlayer(TEAM_GDI);
	else
		highestRankedPlayer = getHighestRankedPlayer(TEAM_NOD);

	while(highestRankedPlayer != None && Abs(team1ranking - team2ranking) > Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore)
	{
		if(highestRankedPlayer.GetTeamNum() == TEAM_GDI)
		{
			SetTeam(highestRankedPlayer, Teams[TEAM_NOD], true);
			if (highestRankedPlayer.Pawn != None)
				highestRankedPlayer.Pawn.PlayerChangedTeam();
			team1ranking -= Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore;
			team2ranking += Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore;
		} else
		{
			SetTeam(highestRankedPlayer, Teams[TEAM_GDI], true);
			if (highestRankedPlayer.Pawn != None)
				highestRankedPlayer.Pawn.PlayerChangedTeam();
			team2ranking -= Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore;
			team1ranking += Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore;
		}
        if(team1ranking > team2ranking) {
            highestRankedPlayer = getHighestRankedPlayer(TEAM_GDI);
        } else {
            highestRankedPlayer = getHighestRankedPlayer(TEAM_NOD);
        }
	}
}

function AdjustTeamSize()
{
	local int difference;
	local Controller PC;
	local Rx_Mutator Rx_Mut;

	Rx_Mut = GetBaseRXMutator();
	if (Rx_Mut != None)
	{
		if(Rx_Mut.adjustTeamSize())
			return;
	}

	// Make sure teams are even
	difference = (Teams[TEAM_GDI].Size - AFKPlayers[TEAM_GDI]) - (Teams[TEAM_NOD].Size - AFKPlayers[TEAM_NOD]);

	if (difference > 1) // too many on GDI
	{
		while (difference > 1)
		{
			PC = getLowestRankedPlayer(TEAM_GDI); // switch lowest ranked player to have minimal influence on balance
			SetTeam(PC, Teams[TEAM_NOD], true);
			if (PC.Pawn != None)
				PC.Pawn.PlayerChangedTeam();
			difference -= 2;
		}
	}
	else if (difference < -1) // too many on Nod
	{
		while (difference < -1)
		{
			PC = getLowestRankedPlayer(TEAM_NOD);
			SetTeam(PC, Teams[TEAM_GDI], true);
			if (PC.Pawn != None)
				PC.Pawn.PlayerChangedTeam();
			difference += 2;
		}
	}
	// else // teams are close enough
}

// and now we adjust these slackers
function AdjustAFKs()
{
	local int difference;
	local Rx_Controller PC;

	difference = (AFKPlayers[TEAM_GDI]) - (AFKPlayers[TEAM_NOD]);

	if(Abs(difference) <= 1)
		return;

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
		if(PC.bPlayerIsReady)
		{
			continue;
		}

		if(difference > 0 && PC.GetTeamNum() == 0)
		{
			SetTeam(PC, Teams[TEAM_NOD], true);
			if (PC.Pawn != None)
				PC.Pawn.PlayerChangedTeam();

			difference -= 2;
		}
		else if(difference < 0 && PC.GetTeamNum() == 1)
		{
			SetTeam(PC, Teams[TEAM_GDI], true);
			if (PC.Pawn != None)
				PC.Pawn.PlayerChangedTeam();

			difference += 2;
		}
		if(Abs(difference) <= 1)
			return;
	}
}

function Rx_Controller getLowestRankedPlayer(int teamNum)
{
	local Rx_Controller PC, lowestRankedPlayer;

	lowestRankedPlayer = None;

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
		if (PC.PlayerReplicationInfo.GetTeamNum() == teamNum)
		{
			if(TeamMode != 1 && TeamMode != 2 && !PC.bPlayerIsReady && lowestRankedPlayer != None && lowestRankedPlayer.bPlayerIsReady)
				continue;

			if(lowestRankedPlayer == None
				|| Rx_Pri(PC.PlayerReplicationInfo).OldRenScore < Rx_Pri(lowestRankedPlayer.PlayerReplicationInfo).OldRenScore
				|| (TeamMode != 1 && TeamMode != 2 && PC.bPlayerIsReady && !lowestRankedPlayer.bPlayerIsReady))
			{
				lowestRankedPlayer = PC;
			}
		}

	return lowestRankedPlayer;
}

function Rx_Controller getHighestRankedPlayer(int teamNum)
{
	local Rx_Controller PC, highestRankedPlayer;

	highestRankedPlayer = None;

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
		if (PC.PlayerReplicationInfo.GetTeamNum() == teamNum)
		{
			if(TeamMode != 1 && TeamMode != 2 && !PC.bPlayerIsReady && highestRankedPlayer != None && highestRankedPlayer.bPlayerIsReady)
				continue;

			if(highestRankedPlayer == None
				|| Rx_Pri(PC.PlayerReplicationInfo).OldRenScore > Rx_Pri(highestRankedPlayer.PlayerReplicationInfo).OldRenScore
				|| (TeamMode != 1 && TeamMode != 2 && !highestRankedPlayer.bPlayerIsReady && PC.bPlayerIsReady))
			{
				highestRankedPlayer = PC;
			}
		}

	return highestRankedPlayer;
}

exec function QuickStart()
{
	StartMatch();
}

/**
 * Pops up a scaleform dialog. Note: Grabs scaleform instance from frontmenu kismit.
 * @param form The form to use inside the dialog
 * @param diagType the type of dialog to popup
 */
exec function PopUpDialog(string form, string diagType)
{
	local array<SequenceObject> a;

	class'WorldInfo'.static.GetWorldInfo().GetGameSequence().FindSeqObjectsByClass(class'GFxAction_OpenMovie', false, a);
	if(a.Length == 1);
		Rx_GFXFrontEnd(GFxAction_OpenMovie(a[0]).MoviePlayer).OpenDialog(form,diagType, -1, -1, true);
}

/**
 * Pops up the scaleform VersionOutOfDateDialog. Note: Grabs scaleform instance from frontmenu kismit.
 */
exec function PopUpOutOfDateDialog()
{
	local array<SequenceObject> a;

	class'WorldInfo'.static.GetWorldInfo().GetGameSequence().FindSeqObjectsByClass(class'GFxAction_OpenMovie', false, a);
	if(a.Length == 1);
		Rx_GFXFrontEnd(GFxAction_OpenMovie(a[0]).MoviePlayer).OpenVersionOutOfDateDialog();
}

/**
 * Pops up the scaleform ShowDownloadProgressDialog. Note: Grabs scaleform instance from frontmenu kismit.
 */
exec function PopUpShowDownloadProgressDialog(string title, string size)
{
	local array<SequenceObject> a;

	class'WorldInfo'.static.GetWorldInfo().GetGameSequence().FindSeqObjectsByClass(class'GFxAction_OpenMovie', false, a);
	if(a.Length == 1);
		Rx_GFXFrontEnd(GFxAction_OpenMovie(a[0]).MoviePlayer).OpenShowDownloadProgressDialog(title, size);
}

/**
 * Updates the scaleform UpdateDownloadProgressDialog. Note: Grabs scaleform instance from frontmenu kismit.
 */
exec function UpdateDownloadProgressDialog(float loaded, float size)
{
	local array<SequenceObject> a;

	class'WorldInfo'.static.GetWorldInfo().GetGameSequence().FindSeqObjectsByClass(class'GFxAction_OpenMovie', false, a);
	if(a.Length == 1);
		Rx_GFXFrontEnd(GFxAction_OpenMovie(a[0]).MoviePlayer).UpdateDownloadProgressDialog(loaded, size);
}

function Rx_PurchaseSystem GetPurchaseSystem()
{
	return PurchaseSystem;
}

function EndGame(PlayerReplicationInfo Winner, string Reason )
{
	local float ScoreDiff, GDIScore, NodScore; 

	`logd("Rx_Game::EndGame");

	GDIScore = Rx_TeamInfo(Teams[TEAM_GDI]).GetRenScore();
	NodScore = Rx_TeamInfo(Teams[TEAM_NOD]).GetRenScore();
	
	ScoreDiff = abs(GDIScore - NodScore); 

	if(Reason ~= "triggered" || (Reason ~= "TimeLimit" && (!bEnableOvertime || GetOverTimeState() == E_DoubleOverTime)))
	{
		if(bSurrenderAtTimeLimit)
		{
			if(GDIScore > NodScore)
				BeginSurrender(TEAM_GDI, true);
			else if(NodScore > GDIScore)
				BeginSurrender(TEAM_NOD, true);
			else
				EndRxGame("Draw",TEAM_UNOWNED);
		}
		else
		{
			if(GDIScore > NodScore)
				EndRxGame(Reason,TEAM_GDI);
			else if(NodScore > GDIScore)
				EndRxGame(Reason,TEAM_NOD);
			else
				EndRxGame("Draw",TEAM_UNOWNED);
		}	
	}
	else if (Reason ~= "TimeLimit" && bEnableOvertime)
	{
		if(ScoreDiff > PointsToWinBy)
		{
			if(GDIScore > NodScore)
				BeginSurrender(TEAM_GDI, true);
			else if(NodScore > GDIScore)
				BeginSurrender(TEAM_NOD, true);
		}
		else
		{
			switch(GetOverTimeState())
			{
				case E_Regulation:
				SetOverTimeState(E_OverTime);
				break;

				case E_OverTime:
				SetOverTimeState(E_DoubleOverTime);
				break;

			}
		}
	}

	// for other victory conditions EndRxGame gets directly called
}

function bool IsValidEndReason(string Reason)
{
	return (Reason ~= "Buildings" || Reason ~= "TimeLimit" || Reason ~= "triggered" || Reason ~= "Surrender" || Reason ~= "Score Domination" || Reason ~= "Draw");
}

function EndRxGame(string Reason, byte WinningTeamNum )
{
	local Rx_Controller c;
	local int GDICount, NodCount;
	local string OTString;
	local Rx_GRI RXGRI; 
	// MPalko: This no longer calles Super(). Was extremely messy, so everything is done right here now.

	//M.Palko endgame crash track log.
	`log("------------------------------EndRxGame called, Reason: " @ Reason @ " Winning Team Num: " @ WinningTeamNum);


	// Make sure end game is a valid reason, and then verify the game is over.
	//Yosh: Added Surrender on the off chance we can get that built into the flash for the end-game screen
	if (IsValidEndReason(Reason) && !bGameEnded) {

		RXGRI = Rx_GRI(WorldInfo.GRI);

		// From super(), manualy integrated.
		bGameEnded = true;
		//EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
		EndTime = 0;//WorldInfo.RealTimeSeconds + EndTimeDelay;

		if (bFixedMapRotation)
			Rx_GRI(GameReplicationInfo).SetFixedNextMap(GetNextMapInRotationName());
		else
			Rx_GRI(GameReplicationInfo).SetupEndMapVote(BuildMapVoteList(), true);

		// Allow replication to happen before reporting scores, stats, etc.
		// @Shahman: Ensure that the timer is longer than camera end game delay, otherwise the transition would not be as smooth.
		SetTimer( EndgameCamDelay + 0.5f,false,nameof(PerformEndGameHandling) );

		// Set winning team and endgame reason.
		WinnerTeamNum = WinningTeamNum;
		RXGRI.WinnerTeamNum = WinnerTeamNum;
		//Stop this timer from counting down in the background... whoops >_>
		if(isTimerActive('PlaySurrenderClockGameOverAnnouncment')) ClearTimer('PlaySurrenderClockGameOverAnnouncment');

		if(bBuildingsRevive)
			CancelTeamBuildingRevives(255); 

		if (WinnerTeamNum == 0 || WinnerTeamNum == 1)
			GameReplicationInfo.Winner = Teams[WinnerTeamNum];
		else
			GameReplicationInfo.Winner = none;
		
		if(bEnableOverTime)
		{
			switch (GetOverTimeState())
			{
				case E_Regulation:
				OTString = "";
				break;

				case E_OverTime:
				OTString = "In Overtime";
				break;

				case E_DoubleOverTime:
				OTString = "In Sudden Death";
				break;
			}
		}

		if(Reason ~= "TimeLimit") {
			RXGRI.WinBySurrender=false;
			RXGRI.WinnerReason = "By Points" @ OTString;
		} else if(Reason ~= "Buildings") {
			RXGRI.WinBySurrender=false;
			RXGRI.WinnerReason = "By Base Destruction" @ OTString;
		} else if (Reason ~= "Score Domination") {
			RXGRI.WinnerReason = "By Score Domination" @ OTString;
			RXGRI.WinBySurrender=true;
			if(GameSpeed != 1.0) SetTimer(0.75f,false, 'ResetGameSpeed'); //IF it was by surrender, it may have very well changed the game speed.
		} 
		else if (Reason ~= "Surrender") {
			RXGRI.WinnerReason = "By Surrender" @ OTString;
			RXGRI.WinBySurrender=true;
			if(GameSpeed != 1.0) SetTimer(0.75f,false, 'ResetGameSpeed'); //IF it was by surrender, it may have very well changed the game speed.
		} else if (Reason ~= "Draw") {
			RXGRI.WinnerReason = "But It's Really a Draw" @ OTString;
			RXGRI.WinBySurrender=true;
			if(GameSpeed != 1.0) SetTimer(0.75f,false, 'ResetGameSpeed'); //IF it was by surrender, it may have very well changed the game speed.
		} else {
			RXGRI.WinBySurrender=false;
			RXGRI.WinnerReason = "triggered";
		}

		// Set everyone's camera focus
		SetTimer(EndgameCamDelay,false,nameof(SetEndgameCam));

		// Send game result to RxLog
		if (WinningTeamNum == TEAM_GDI || WinningTeamNum == TEAM_NOD)
			RxLog("GAME"`s "MatchEnd;"`s "winner"`s GetTeamName(WinningTeamNum)`s  Reason `s"GDI="$Rx_TeamInfo(Teams[TEAM_GDI]).GetDisplayRenScore()`s"Nod="$Rx_TeamInfo(Teams[TEAM_NOD]).GetDisplayRenScore());
		else
			RxLog("GAME"`s "MatchEnd;"`s "tie"`s Reason `s"GDI="$Rx_TeamInfo(Teams[TEAM_GDI]).GetDisplayRenScore()`s"Nod="$Rx_TeamInfo(Teams[TEAM_NOD]).GetDisplayRenScore());

		CalculateEndGameAwards(0);
		CalculateEndGameAwards(1);
		AssignAwards(0);
		AssignAwards(1);

		if (StatAPI != None)
		{
			ForEach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Rx_Controller', c)
			{
				if (c.GetTeamNum() == 0)
					GDICount++;
				else if (c.GetTeamNum() == 1)
					NodCount++;
			}

			StatAPI.GameEnd(string(Rx_TeamInfo(Teams[TEAM_GDI]).GetDisplayRenScore()), string(Rx_TeamInfo(Teams[TEAM_NOD]).GetDisplayRenScore()), string(GDICount), string(NodCount), int(WinningTeamNum), Reason);
			ClearTimer('GameUpdate');
		}

		//M.Palko endgame crash track log.
		`log("------------------------------Triggering game ended kismet events");

		// trigger any Kismet "Game Ended" events
		TriggerKismetGameEnded();

		//@Shahman: Match over state will be called after the camera transition has been made.

		if(Rx_GRI(GameReplicationInfo).bAutobalanceInProgress){
			CancelAutoBalance("game_end");
		}
	}
}

function float CalcPlayerScoreThisMatch(Rx_Pri pri)
{
	local float ret;

	ret = pri.GetRenScore();
	if(ret < 1.0)
		ret = 0.0;
	else
		ret = loge(pri.GetRenScore());

	if(pri.GetRenKills() - pri.Deaths > 0)
		ret += loge((pri.GetRenKills() - pri.Deaths) / 2.0);

	return ret;
}

function PerformEndGameHandling()
{
	`log("################################ -( PerformEndGameHandling() )-");
	`RecordGameIntStat(ROUND_ENDED,1);
	`RecordGameIntStat(MATCH_ENDED,1);
	super.PerformEndGameHandling();
}

function SetEndgameCam()
{
	//`log("################################ -( SetEndgameCam() )-");
	SetRxEndGameFocus(FindEndgameFocus());
}

function Actor FindEndgameFocus()
{
	// For now, we just return the first endgame camera we find.
	local Rx_EndgameCamera Focus;
	foreach AllActors(class'Rx_EndgameCamera',Focus)
	{
		return Focus;
	}
	return none;
}

function SetRxEndGameFocus(Actor Focus)
{
	local Controller P;
	//`log("################################ -( SetRxEndGameFocus() )-");
	EndGameFocus = Focus;

	if ( EndGameFocus != None )
		EndGameFocus.bAlwaysRelevant = true;

	foreach WorldInfo.AllControllers(class'Controller', P)
	{
		if(Rx_Controller(P) != None || Rx_Bot(P) != None)			// So that any players and player-like bots will go into roundended state
			P.GameHasEnded( EndGameFocus, (P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) );
	}

	//M.Palko endgame crash track log.
	`log("------------------------------Sending to match over state");

	// Finally, go to match over state...after 9 seconds delay
	//SetTimer(9.0, false, nameof(SetMatchOverState));
	GotoState('MatchOver');

}


/**Special case to end game via surrender:
1st play the surrender message across all controllers via CText
then play the surrender announcement (as they sound weird coming after the screen fades)
then wait a second or two before ending the game
**/

function BeginSurrender(int TeamI, optional bool bForced)
{
	local Rx_Controller P;
	local Rx_Mutator Rx_Mut;
	local string TeamName;

	if(bGDIHasSurrendered || bNodHasSurrendered) return; //Catch any surrenders that get through after a team's already happened.

	Rx_Mut = GetBaseRxMutator();
	if (Rx_Mut != None)
	{
		Rx_Mut.OnTeamSurrender(TeamI);
	}

	if(bForced)
	{
		Rx_GRI(WorldInfo.GRI).WinnerReason = "By Forced Surrender";
		Rx_GRI(WorldInfo.GRI).WinBySurrender=true;
	}
	else
	{
		Rx_GRI(WorldInfo.GRI).WinnerReason = "By Surrender";
		Rx_GRI(WorldInfo.GRI).WinBySurrender=true;
	}
	

	switch (TeamI)
	{
		case 0:
			TeamName = GetTeamName(1);
		break;
		case 1:
			TeamName = GetTeamName(0);
		break;
	}

	foreach WorldInfo.AllControllers(class'Rx_Controller', P)
	{
		P.CTextMessage(bForced ? Caps(TeamName) @ "FORCED TO SURRENDER!" : Caps(TeamName) @ "SURRENDERED!",,120, 1.0) ;
	}

	

	SetGameSpeed(0.5);//fancy... but we'll see how it holds up online
	/*Both of these play the appropriate surrender Announcement AND start the small countdown to end the game. The delay for sounds make it a bit more obvious a team surrendered. */
	if(TeamI==1)
	{
		bGDIHasSurrendered = true;
		SetTimer(1.0, false, 'PlayGDISurrender');
		if(bForced)
		SetSurrenderTimeState(0); 
	}
	else
	{
		bNodHasSurrendered = true;
		SetTimer(1.0, false, 'PlayNodSurrender'); //Account for time increase (1 second)
		SetSurrenderTimeState(1); 
	}

}

function PlayGDISurrender()
{
local Rx_Controller PC;

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
	PC.ClientPlayAnnouncement(VictoryMessageClass, 5);
	}

	SurrenderStartTime = WorldInfo.TimeSeconds ;

	ResetGameSpeed();

	InitSurrender(0) ;

	//SetTimer(0.75, false, 'FinishGDISurrender') ;

}

function PlayNodSurrender()
{
local Rx_Controller PC;

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
		PC.ClientPlayAnnouncement(VictoryMessageClass, 4);
	}

	SurrenderStartTime = WorldInfo.TimeSeconds ;


	ResetGameSpeed();

	InitSurrender(1) ;
	//SetTimer(0.75, false, 'FinishNodSurrender') ;

}

function PlaySurrenderClockGameOverAnnouncment()
{
	local int TotalTime, TimeMinutes, TimeInSeconds;

	TotalTime = (SurrenderStartTime + SurrenderLength ) - WorldInfo.TimeSeconds ;

	if(TotalTime <= 0)
	{

		ClearTimer('PlaySurrenderClockGameOverAnnouncment');
		if(bGDIHasSurrendered) FinishGDISurrender();
		else
		if(bNodHasSurrendered) FinishNodSurrender();
		else
		return;
	}

	TimeMinutes = (TotalTime / 60);

	TimeInSeconds = (TotalTime % 60) ;

		if(TotalTime > 60) CTextBroadcast(255, "-Game Ending in:" @ TimeMinutes+1 $ "m-", 'White',,1.0) ;
		else
		CTextBroadcast(255, "-Game Ending in:" @ TimeInSeconds $ "s-" , 'White',,1.0) ;

	if(!bCountingToSurrender && TotalTime <= 60) //Setup to countdown
	{
	bCountingToSurrender = true;
	ClearTimer('PlaySurrenderClockGameOverAnnouncment');
	SetTimer(50.0,true,'PlaySurrenderClockGameOverAnnouncment');
	}
	else
	if(bCountingToSurrender && TotalTime >=9)
	{
	ClearTimer('PlaySurrenderClockGameOverAnnouncment');
	SetTimer(1.0,true,'PlaySurrenderClockGameOverAnnouncment');
	}



}

function InitSurrender (byte SurrenderingTeam)
{
	local Rx_PRI RxPRI;
	local PlayerReplicationInfo PRI ;
	//local Actor SurrActor;

	foreach GameReplicationInfo.PRIArray(PRI)
	{

	if(Rx_PRI(PRI) != none && PRI.GetTeamNum() == SurrenderingTeam)
		{
			RxPRI=Rx_PRI(PRI);
			RxPRI.DisableVeterancy(true);
		}
		else
		if(Rx_PRI(PRI) != none && PRI.GetTeamNum() != SurrenderingTeam)
		{
			RxPRI=Rx_PRI(PRI);
			RxPRI.TickVPToFull();
			//RxPRI.AddCredits(15000);
			//RxPRI.Vrank=3;
		}
	}

	//ForEach WorldInfo.AllActors(class'Actor', SurrActor, class'RxIfc_NotifySurrender')
	//{
	//	RxIfc_NotifySurrender(SurrActor).OnSurrender(SurrenderingTeam);
	//}

	PlaySurrenderClockGameOverAnnouncment();
	SetTimer(60.0, true, 'PlaySurrenderClockGameOverAnnouncment');
}


function FinishGDISurrender()
{
	if(Rx_GRI(WorldInfo.GRI).WinnerReason ~= "By Surrender")
	{
		EndRxGame("Surrender", 1);
	}
	else if(Rx_GRI(WorldInfo.GRI).WinnerReason ~= "By Forced Surrender")
	{
		EndRxGame("Score Domination", 1);
	}

}

function FinishNodSurrender()
{
	if(Rx_GRI(WorldInfo.GRI).WinnerReason ~= "By Surrender")
	{
		EndRxGame("Surrender", 0);
	}
	else if(Rx_GRI(WorldInfo.GRI).WinnerReason ~= "By Forced Surrender")
	{
		EndRxGame("Score Domination", 0);
	}

}

function ResetGameSpeed()
{
	SetGameSpeed(1);
}

/*Surrender functions over*/


private function SetMatchOverState()
{
	GotoState('MatchOver');
}

private function TriggerKismetGameEnded()
{
	local Sequence GameSequence;
	local array<SequenceObject> Events;
	local int i;
	// trigger any Kismet "Game Ended" events
	GameSequence = WorldInfo.GetGameSequence();
	if (GameSequence != None)
	{
		GameSequence.FindSeqObjectsByClass(class'UTSeqEvent_GameEnded', true, Events);
		for (i = 0; i < Events.length; i++)
		{
			UTSeqEvent_GameEnded(Events[i]).CheckActivate(self, None);
		}
	}
}

/*
 * Adds crate to global array and sets one random active
 * */
function AddCrateAndActivateRnd(Rx_CratePickup InCrate)
{
   local Rx_CratePickup tmpCrate;
   local int activeCratesNum;
   activeCratesNum = 0;
   if (!SpawnCrates)
   {
      InCrate.GotoState('Disabled');
   }
   else
   {
      AllCrates.AddItem(InCrate);

      foreach AllCrates(tmpCrate)
      {
         if (tmpCrate.getIsActive())
            activeCratesNum++;
      }


      if (activeCratesNum > Rx_MapInfo(WorldInfo.GetMapInfo()).NumCratesToBeActive)
         InCrate.DeactivateCrate();
      else
         InCrate.ActivateCrate();

   }
}

/*
 * called after crate was picked up and next one should be activated
 * used with config to delay crate respawn set by user
 * */
function ActivateRandomCrate()
{
   local Rx_CratePickup tmpCrate;
   local array<Rx_CratePickup> CratesNotActive;

   // get non active crates
   foreach AllCrates(tmpCrate)
   {
      if(!tmpCrate.getIsActive())
      {
         CratesNotActive.AddItem(tmpCrate);
      }
   }
   // activate a rnd one

   CrateRespawnAfterPickup = 60.0f - Worldinfo.GRI.ElapsedTime % 60.0f;
   if(CrateRespawnAfterPickup == 0.0)
   		CrateRespawnAfterPickup = 1.0;

   CratesNotActive[Rand(CratesNotActive.Length)].setActiveIn(CrateRespawnAfterPickup);
}

function PlayEndOfMatchMessage()
{
/*	local Rx_Controller PC;


	//M.Palko endgame crash track log.
	`log("------------------------------Playing end of match message");

	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
	{
		if (IsAWinner(PC))
		{
			if ( PC.GetTeamNum() == 0 )
			{
				if(!WasSurrenderWin()) PC.ClientPlayAnnouncement(VictoryMessageClass, 0); // GDI Win
				//else
				//PC.ClientPlayAnnouncement(VictoryMessageClass, 4);
			}
			else
			{
				if(!WasSurrenderWin()) PC.ClientPlayAnnouncement(VictoryMessageClass, 1); // Nod Win
				//else
				//PC.ClientPlayAnnouncement(VictoryMessageClass, 5); // Nod Win through GDI Surrender
			}
		}
		else
		{
			if ( PC.GetTeamNum() == 0 )
			{
			if(!WasSurrenderWin())	PC.ClientPlayAnnouncement(VictoryMessageClass, 2); // GDI Defeat
			//else
			//PC.ClientPlayAnnouncement(VictoryMessageClass, 5); // Nod Win through GDI Surrender
			}
			else
			{
				if(!WasSurrenderWin()) PC.ClientPlayAnnouncement(VictoryMessageClass, 3); // Nod Defeat
				//else
				//PC.ClientPlayAnnouncement(VictoryMessageClass, 4); // GDI Win through Nod Surrender

			}
		}
	}

*/
}

simulated function bool WasSurrenderWin()
{

	return Rx_Gri(GameReplicationInfo).WinBySurrender;

}

simulated function int getVehicleLimit()
{
   return VehicleLimit;
}

function Rx_VehicleManager GetVehicleManager()
{
	return VehicleManager;
}

function ReduceDamage(out int Damage, pawn injured, Controller instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	local float TempDifficulty;

	// if scripted bot is involved, further modify the damage

	if(Rx_Bot_Scripted(injured.Controller) != None)
		Damage = Damage * Rx_Bot_Scripted(injured.Controller).DamageTakenModifier;

	if(Rx_Bot_Scripted(instigatedBy) != None)
		Damage = Damage * Rx_Bot_Scripted(instigatedBy).DamageDealtModifier;

	TempDifficulty = WorldInfo.Game.GameDifficulty;
	WorldInfo.Game.GameDifficulty = 5.0;
	super.ReduceDamage(Damage,injured,instigatedBy,HitLocation,Momentum,DamageType,DamageCauser);
	WorldInfo.Game.GameDifficulty = TempDifficulty;
}

function bool CanPlayBuildingUnderAttackMessage(byte TeamNum)
{
	if(TeamNum == TEAM_GDI) {
		return bCanPlayEvaBuildingUnderAttackGDI;
	} else {
		return bCanPlayEvaBuildingUnderAttackNOD;
	}
}

function ResetBuildingUnderAttackEvaTimer(byte TeamNum)
{
	if(TeamNum == TEAM_GDI) {
		bCanPlayEvaBuildingUnderAttackGDI = false;
		SetTimer(30.0,false,'ResetBuildingUnderAttackEvaGDI');
	} else {
		bCanPlayEvaBuildingUnderAttackNOD = false;
		SetTimer(30.0,false,'ResetBuildingUnderAttackEvaNOD');
	}
}

function ResetBuildingUnderAttackEvaGDI()
{
	bCanPlayEvaBuildingUnderAttackGDI = true;
}

function ResetBuildingUnderAttackEvaNOD()
{
	bCanPlayEvaBuildingUnderAttackNOD = true;
}

function TriggerRemoteKismetEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int i;
	GameSeq = WorldInfo.GetGameSequence();
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(class'SeqEvent_RemoteEvent', true, AllSeqEvents);
		for(i = 0; i < AllSeqEvents.Length; i++)
		{
			if(SeqEvent_RemoteEvent(AllSeqEvents[i]).EventName == EventName)
				SeqEvent_RemoteEvent(AllSeqEvents[i]).CheckActivate(WorldInfo, None);
		}
	}
}

function string Unescape(string Text)
{
	return class'Rx_RconConnection'.static.ProcessEscapeSequences(Text);
}


function bool ProcessNewServerInfo(JsonObject ServerData, bool isServerLan)
{
	local JsonObject ServerMoreData;
	local ServerInfo si;

	si.GameVersion = Unescape(ServerData.GetStringValue("Game Version"));
	if (IgnoreGameServerVersionCheck || si.GameVersion == GameVersion) {


		si.ServerName = Unescape(ServerData.GetStringValue("Name"));

		`logd(`Location@`showvar(si.ServerName),,'DevNet');

		si.ServerIp = ServerData.GetStringValue("IP");
		si.ServerPort = string(ServerData.GetIntValue("Port"));
		si.MapName = Unescape(ServerData.GetStringValue("Current Map"));
		si.NamePrefix = ServerData.GetStringValue("NamePrefix");
		si.NumPlayers = ServerData.GetIntValue("Players");

		ServerMoreData = ServerData.GetObject("Variables");

		si.VehicleLimit = ServerMoreData.GetIntValue("Vehicle Limit");
		si.MineLimit = ServerMoreData.GetIntValue("Mine Limit");
		si.MaxPlayers = ServerMoreData.GetIntValue("Player Limit");
		si.TimeLimit = ServerMoreData.GetIntValue("Time Limit");
		si.TeamMode = ServerMoreData.GetIntValue("Team Mode");
		si.GameType = ServerMoreData.GetIntValue("Game Type");
		si.SteamRequired = ServerMoreData.GetBoolValue("bSteamRequired");
		si.bPassword = ServerMoreData.GetBoolValue("bPassworded");
		si.CratesEnabled = ServerMoreData.GetBoolValue("bSpawnCrates");
		si.Ranked = ServerMoreData.GetBoolValue("bRanked");

		si.isLAN = isServerLan;

		`logd(`Location@`ShowVar(isServerLan)@`ShowVar(si.isLAN),,'DevNet');

		return AddServerInfo(si);
	}
	return false;
}

function AddServerPing(string ServerIp, int Index)
{
	`Entry(`ShowVar(ServerIp)@`ShowVar(Index),'DevNet');

	// TODO: Make this only ping servers that are actually being displayed; minimal pings should result in most accurate pings, and reduce unnecessary requests
	`RxEngineObject.DllCore.start_ping_request(ServerIp);
}

function HandleServerData(JsonObject MasterServerData)
{
	local JsonObject ServerData;
	local bool bIsNewServer;

	bIsNewServer = false;

	foreach MasterServerData.ObjectArray(ServerData)
	{
		`logd("HandleServerData: Server:"@ServerData,,'DevNet');
		if(ProcessNewServerInfo(ServerData, false))
			bIsNewServer = true;
	}

	if(bIsNewServer)
	{
		NotifyServerListUpdate();
	}
}

function StartPings()
{
	`Entry(,'DevNet');

	if(ListServers.Length > 0)
	{
		if(!IsTimerActive('PollServerPings'))
			SetTimer(0.5f, true, 'PollServerPings');
	}
}

/* Using Rx_VersionQueryHandler, we will fetch the data from the release JSON and parse the information here. The info is stored in the class VQueryHandler */
function HandleVersionData(JsonObject VersionData)
{
	VQueryHandler.QueryedVersionNumber = VersionData.GetObject("game").GetIntValue("version_number");
	VQueryHandler.QueryedVersionName = VersionData.GetObject("game").GetStringValue("version_name");
}

function PollServerPings() {
	local int index;
	local int pending_requests;

	// TODO: Make this only update the servers actively being displayed, and just trigger a Poll() during a scroll
	// Update any server pings
	for (index = 0; index != ListServers.Length; ++index) {
		if (ListServers[index].Ping == -1) {
			// response was previously pending; try updating
			ListServers[index].Ping = `RxEngineObject.DllCore.get_ping(ListServers[index].ServerIP);

			if (ListServers[index].Ping == -1) {
				// request is still pending; increment counter
				++pending_requests;
			}
		}
	}

	// If there aren't any pending requests remaining, clear out the timer
	if (pending_requests == 0) {
		ClearTimer(nameof(PollServerPings));
	}

	// This doesn't feel right... This method originally took in an index, but was later changed to not use it? Whatever
	NotifyPingFinished();
}

delegate NotifyPingFinished();

function bool FindInactivePRI(PlayerController PC)
{
	local bool ret;
	local int oldId;
	oldId = PC.PlayerReplicationInfo.PlayerID;
	ret = super.FindInactivePRI(PC);
	if(ret)
	{
		TeamCredits[PC.GetTeamNum()].PlayerRI.AddItem(Rx_PRI(PC.PlayerReplicationInfo));
		if (oldId != PC.PlayerReplicationInfo.PlayerID)
			`LogRx("PLAYER" `s "ChangeID;" `s "to" `s PC.PlayerReplicationInfo.PlayerID `s "from" `s oldId);

		Rx_PRI(PC.PlayerReplicationInfo).bDonateOnDelete = false;
	}
	return ret;
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	super.GetSeamlessTravelActorList(bToEntry, ActorList);

	if (MatchInfo != None)
		ActorList.AddItem(MatchInfo);
}

function NotifyNavigationChanged(NavigationPoint N)
{
	local UTBot B;

	/**
	// if a point becomes unblocked, force bots to repath in case it's faster than their current one
	if (!N.bBlocked)
	{
		foreach WorldInfo.AllControllers(class'UTBot', B)
		{
			//B.bForceRefreshRoute = true; // dont always do that because the harv does unblocking a lot
		}
	}
	*/

	if (N.bBlocked)
	{
		foreach WorldInfo.AllControllers(class'UTBot', B)
		{
			//if(B.NextRoutePath != None && B.NextRoutePath.GetEnd() == N)
			//if(B.CurrentPath != None && B.CurrentPath.GetEnd() == N) {
			if(B.NextRoutePath != None && B.NextRoutePath.GetEnd() == N || B.MoveTarget != None && B.MoveTarget == N) {
				//`log("ddd");
				B.bForceRefreshRoute = true; // dont always do that because the harv does unblocking a lot
			}
		}
	}

	// only if close to blocked node
}

function Actor GetObelisk()
{
	return Obelisk;
}
function Actor GetAGT()
{
	return AGT;
}

function RestartPlayer(Controller NewPlayer)
{
	local Rx_Hud RxHUD;
	local Rx_PRI RxPRI;


	if(bPedestalDetonated)
		return;

	if(Rx_Controller(newPlayer) != None && !Rx_Controller(newPlayer).bPlayerIsReady)
		return;

	RxPRI = Rx_PRI(NewPlayer.PlayerReplicationInfo);

	super.RestartPlayer(NewPlayer);

	if(Rx_Bot(NewPlayer) != None) {

		if(Rx_Bot(NewPlayer).bAttackingEnemyBase) {
			Rx_Bot(NewPlayer).bAttackingEnemyBase = false;
			Rx_Bot(NewPlayer).bInvalidatePreviousSO = true;
		}

		if(NewPlayer.PlayerReplicationInfo.Deaths > 0 && Rx_Bot(NewPlayer).Squad != None && UTSquadAI(Rx_Bot(NewPlayer).Squad).GetOrders() == 'Attack') {
			UTSquadAI(Rx_Bot(NewPlayer).Squad).RemoveBot(Rx_Bot(NewPlayer));
			Rx_TeamAI(UTTeamInfo(NewPlayer.PlayerReplicationInfo.Team).AI).PutOnOffense(Rx_Bot(NewPlayer));
		}
		else if(Rx_Bot(NewPlayer).GetOrders() == 'Follow')
		{
			UTTeamInfo(Rx_Bot(NewPlayer).Squad.Team).AI.SetBotOrders(Rx_Bot(NewPlayer));
		}

//	    if(Rx_Bot(NewPlayer).IsInBuilding()) {
//	   		Rx_Bot(NewPlayer).setStrafingDisabled(true);
//	    }
	}
	else if(PlayerController(NewPlayer) != None) {
		RxHUD = Rx_Hud(PlayerController(NewPlayer).myHUD);
		if (WorldInfo.NetMode != NM_DedicatedServer && RxHUD != None)
			RxHUD.ClearPlayAreaAnnouncement();
		else
			Rx_Controller(NewPlayer).ClearPlayAreaAnnouncementClient();
		if(Rx_Controller(NewPlayer) != None)
			Rx_Controller(NewPlayer).RefillCooldownTime=0;
	}
	if((NewPlayer.GetTeamNum() == 0 || NewPlayer.GetTeamNum() == 1) && TeamCredits[NewPlayer.GetTeamNum()].PlayerRI.Find(RxPRI) < 0)
	{
		TeamCredits[NewPlayer.GetTeamNum()].PlayerRI.AddItem(RxPRI);
		RxPRI.SetCredits( Rx_Game(WorldInfo.Game).InitialCredits );
	}

	if(GetALocalPlayerController() != none && GetALocalPlayerController().Player != none)
		LocalPlayer(GetALocalPlayerController().Player).ClearPostProcessSettingsOverride();

	//`RecordPlayerSpawn(NewPlayer, NewPlayer.Pawn.Class, NewPlayer.GetTeamNum());
}

/** Calling this advances the cycle and thus should not be called just to get the name of the next map, use GetNextMapInRotationName() */
function string GetNextMap()
{
	local int GameIndex;

	/** Yosh: Had to comment this out for the sake of getting patch 5003 out in a timely manner.
	From what I could tell by looking at it quickly, the game never sets an active map list for the manager, so you just get thrown back on the same map.
	if (MapListManager != none) {
		`log(MapListManager.GetNextMap());
		return MapListManager.GetNextMap();
	}
	*/

	if (bFixedMapRotation)
	{
		GameIndex = class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name);
		if (GameIndex != INDEX_NONE)
		{
			MapCycleIndex = GetNextMapInRotationIndex();
			//TODO: Add to fixed map rotation to cycle between day/night maps.
			class'UTGame'.default.MapCycleIndex = MapCycleIndex;
			class'UTGame'.static.StaticSaveConfig();

			return class'UTGame'.default.GameSpecificMapCycles[GameIndex].Maps[MapCycleIndex];
		}
	}
	else
	{
		return Rx_Gri(GameReplicationInfo).GetMapVoteName();
	}

	return "";
}

function int GetNextMapInRotationIndex()
{
	local int MapIndex, GameIndex;
	local array<string> MapList;

	GameIndex = class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name);
	MapList = class'UTGame'.default.GameSpecificMapCycles[GameIndex].Maps;
	MapIndex = GetCurrentMapCycleIndex(MapList);
	if (MapIndex == INDEX_NONE)
	{
		// assume current map is actually zero
		MapIndex = 0;
	}
	return (MapIndex + 1 < class'UTGame'.default.GameSpecificMapCycles[GameIndex].Maps.length) ? (MapIndex + 1) : 0;
}

function string GetNextMapInRotationName()
{
	return class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps[GetNextMapInRotationIndex()];
}

function RecordToMapHistory(string LatestMap)
{
	local int i;

	if (MapHistory.Length < MapHistoryMax)
		i = MapHistory.Length;
	else
		i = MapHistoryMax - 1;

	while (i>0)
	{
		MapHistory[i] = MapHistory[i-1];
		--i;
	}
	MapHistory[0] = LatestMap;
	SaveConfig();
}

function array<string> BuildMapVoteList()
{
	local array<string> MapPool, SecondaryMapPool;
	local string MapName, MapToRemove, index;
	local int i;

	if(bShowOtherGameTypes)
	{
		MapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', 'Rx_Game')].Maps;
		SecondaryMapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', 'Rx_Game_Cooperative')].Maps;
		foreach SecondaryMapPool(index)
		{
			MapPool.AddItem(index);
		}
		SecondaryMapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', 'Rx_Game_Survival')].Maps;
		foreach SecondaryMapPool(index)
		{
			MapPool.AddItem(index);
		}
	}
	else
		MapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps;
	for (i=0; i<RecentMapsToExclude && i<MapHistory.Length; ++i)
	{
		MapName = MapHistory[i];

		// Check if the current map in history is an X variant and remove normal variant
		if (bRemoveVariantMapsInVoteList && GetRightMost(MapName) ~= "_X")
		{
			`log(MapName @ "is an X variant, attempting to remove normal variant"@Left(MapName, Len(MapName) - 2));
			MapToRemove = Left(MapName, Len(MapName) - 2);
			MapPool.RemoveItem(MapToRemove);
		}

		// Check if the current map in history HAS an X variant and remove it
		if (bRemoveVariantMapsInVoteList && MapPool.Find(MapName $ "_X") != INDEX_NONE)
		{
			`log(MapName @ "has an X variant, attempting to remove the X variant"@MapName $ "_X");
			MapToRemove = MapName $ "_X";
			MapPool.RemoveItem(MapToRemove);
		}

		MapPool.RemoveItem(MapName);
	}


	for (i=0; i < MapsWithPlayerNumLimits.Length; ++i)
	{
		if(MapPool.Find(MapsWithPlayerNumLimits[i].MapName) != INDEX_NONE && (MapsWithPlayerNumLimits[i].MapMinPlayers > NumPlayers || MapsWithPlayerNumLimits[i].MapMaxPlayers < NumPlayers))
		{
			MapPool.RemoveItem(MapsWithPlayerNumLimits[i].MapName);
		}
	}

	while (MapPool.Length > MaxMapVoteSize)
		MapPool.Remove(Rand(MapPool.Length), 1);

	return MapPool;
}

/*Functions added to add/remove maps from the rotation while in-game*/

exec function bool AddMapToRotation(string MapName) /*Return if the given map name was a valid map, then add a map to the map rotation*/
{
	local array<string> MapPool;

	MapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps;

	if(!bDoesMapExist(MapName))
	{
		`log("Did not find map, adding to rotation");

		//if( !MapPackageExists(MapName) ) return false;

		MapPool.AddItem(MapName);
		EditMapArray(MapPool);
		saveconfig();
		return true;
	}
	return false;
}

exec function bool RemoveMapFromRotation(string MapName) /*Return if the given map name was a valid map, then remove a map from the map rotation*/
{
	local array<string> MapPool;

	MapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps;

	if(bDoesMapExist(MapName))
	{
		`log("Found map"@MapName$", removing from rotation.");
		//insert code to verify is legitimate map
		MapPool.RemoveItem(MapName);
		EditMapArray(MapPool);
		saveconfig();
		return true;
	}
	return false;
}

function bool bDoesMapExist(string MapName)
{
	local array<string> MapPool;

	MapPool = class'UTGame'.default.GameSpecificMapCycles[class'UTGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps;

	if (MapPool.Find(MapName) != -1)
	{
		`log(MapName@"does exist.");
		return true;
	}

	return false;
}

function EditMapArray(array<string> NewMapList)
{
	local int i;

	GameSpecificMapCycles[GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps.Length=0; //Delete the old map list

	for(i = 0; i < NewMapList.Length; i++)
	{
		`log("Adding item" @ NewMapList[i]) ;
		GameSpecificMapCycles[GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps.AddItem(NewMapList[i]) ; //create the new map list
	}
}

exec function GetMapRotation() //Obviously get the map-rotation
{
	local array<string> MapPool;
	local int i;

	MapPool = default.GameSpecificMapCycles[default.GameSpecificMapCycles.Find('GameClassName', Class.Name)].Maps;

		RxLog("Generating Map List");
		for(i = 0; i < MapPool.Length; i++)
		{
			RxLog("Map"`s i `s ":" `s MapPool[i]);
		}
}

exec function ExitGameAndOpenLauncher()	// For the time being, just exit the game. Will open launcher/reopen launcher to prompt for download at a later date.
{
	//ConsoleCommand("Exit");
	`log("Attempting to close game and open launcher now"@Rx_GameEngine(class'Engine'.static.GetEngine()).DllCore.UpdateGame());
	Rx_GameEngine(class'Engine'.static.GetEngine()).DllCore.UpdateGame();
}

/** Modifeid version of UTGame::ProcessServerTravel and supercall to GameInfo. Adds map change Rxlog and Seamless travel control. */
function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	// GameInfo Locals
	local PlayerController LocalPlayer;
	local bool bSeamless;
	local string NextMap;
	local Guid NextMapGuid;
	local int OptionStart;
	local string MapGameType;
	// UTGame Locals
	local Controller C;

	if (!IsInState('MatchOver'))
	{
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			C.GameHasEnded();
		}
		GotoState('MatchOver');
	}

	// SUPER CALL TO GAMEINFO
	bLevelChange = true;
	EndLogging("mapchange");

	bSeamless = false;

	if (InStr(Caps(URL), "?RESTART") != INDEX_NONE)
	{
		NextMap = string(WorldInfo.GetPackageName());
	}
	else
	{
		OptionStart = InStr(URL, "?");
		if (OptionStart == INDEX_NONE)
		{
			NextMap = URL;
		}
		else
		{
			NextMap = Left(URL, OptionStart);
		}
	}
	NextMapGuid = GetPackageGuid(name(NextMap));

	if (bSeamless)
		RxLog("MAP"`s"Changing;"`s NextMap `s "seamless");
	else
		RxLog("MAP"`s"Changing;"`s NextMap `s "nonseamless");

	// Set the teams for the next round
	class'Rx_TeamManager'.static.SetTeams();

	// Remove bots
	DesiredPlayerCount = NumPlayers;
	KillBots();

	OptionStart = InStr(URL, "-");
	MapGameType = Left(URL, OptionStart);
	if(MapGameType ~= "DEF")
		URL = URL $ "?Game=RenX_Coop.RX_Game_Survival";
	else if(MapGameType ~= "CNC" || MapGameType ~= "TDM")
		URL = URL $ "?Game=RenX_Game.RX_Game";
	RxLog("MAP" $ " Travel URL: " $ URL);
	// Notify clients we're switching level and give them time to receive.
	if (TravelURL != "") {
		LocalPlayer = ProcessClientTravel(TravelURL, NextMapGuid, false, bAbsolute);
	}
	else {
		LocalPlayer = ProcessClientTravel(URL, NextMapGuid, bSeamless, bAbsolute);
	}

	`log("ProcessServerTravel:"@URL);
	WorldInfo.NextURL = URL;
	if (WorldInfo.NetMode == NM_ListenServer && LocalPlayer != None)
	{
		WorldInfo.NextURL $= "?Team="$LocalPlayer.GetDefaultURL("Team")
							$"?Name="$LocalPlayer.GetDefaultURL("Name")
							$"?Class="$LocalPlayer.GetDefaultURL("Class")
							$"?Character="$LocalPlayer.GetDefaultURL("Character");
	}

	// Notify access control, to cleanup online subsystem references
	if (AccessControl != none)
	{
		AccessControl.NotifyServerTravel(bSeamless);
	}

	// Trigger cleanup of online delegates
	ClearOnlineDelegates();

	if (bSeamless)
	{
		WorldInfo.SeamlessTravel(WorldInfo.NextURL, bAbsolute);
		WorldInfo.NextURL = "";
	}
	// Switch immediately if not networking.
	else if (WorldInfo.NetMode != NM_DedicatedServer && WorldInfo.NetMode != NM_ListenServer)
	{
		WorldInfo.NextSwitchCountdown = 0.0;
	}
	// END OF SUPER CALL

	// on dedicated servers, add a delay to the travel process to give clients a little more time to construct any meshes
	// since that process will get cut off when the server completely finishes travelling
	if (WorldInfo.NetMode == NM_DedicatedServer && WorldInfo.IsInSeamlessTravel())
	{
		WorldInfo.SetSeamlessTravelMidpointPause(true);
		SetTimer(7.0, false, 'ContinueSeamlessTravel');
	}
}

/**
 * Notifies all clients to travel to the specified URL.
 *
 * @param	URL				a string containing the mapname (or IP address) to travel to, along with option key/value pairs
 * @param	NextMapGuid		the GUID of the server's version of the next map
 * @param	bSeamless		indicates whether the travel should use seamless travel or not.
 * @param	bAbsolute		indicates which type of travel the server will perform (i.e. TRAVEL_Relative or TRAVEL_Absolute)
 */
function PlayerController ProcessClientTravel( out string URL, Guid NextMapGuid, bool bSeamless, bool bAbsolute )
{
	local PlayerController P, LP;

	// We call PreClientTravel directly on any local PlayerPawns (ie listen server)
	foreach WorldInfo.AllControllers(class'PlayerController', P)
	{
		P.ClientForceGarbageCollection();
		if (NetConnection(P.Player) != None)
		{
			// remote player
			P.ClientTravel(URL, TRAVEL_Relative, bSeamless, NextMapGuid);
		}
		else
		{
			// local player
			LP = P;
			P.PreClientTravel(URL, bAbsolute ? TRAVEL_Absolute : TRAVEL_Relative, bSeamless);
		}
	}

	return LP;
}

function Rx_Mutator GetBaseRxMutator()
{
	local Mutator M;

	if (BaseMutator == None) return None;

	for (M = BaseMutator; M != None; M = M.NextMutator)
	{
		if (Rx_Mutator(M) != None)
			return Rx_Mutator(M);
	}

	return None;
}

simulated function GiveTeamCredits(float Credits, byte TeamNum, optional PlayerReplicationInfo ExcludedPRI)
{
	local PlayerReplicationInfo pri;
	local int index;

	for (index = 0; index < WorldInfo.GRI.PRIArray.Length; ++index)
	{
		pri = WorldInfo.GRI.PRIArray[index];
		if (pri != ExcludedPRI && Rx_PRI(pri) != None && pri.GetTeamNum() == TeamNum)
			Rx_PRI(pri).addCredits(Credits);
	}
}

function bool AreTeamRefineriesDestroyed(byte teamNum) // a check for harvy spawn
{
	local int i;

	if(TeamCredits[teamNum].Refinery.length <= 0)
		return true;

	for(i=0; i<TeamCredits[teamNum].Refinery.length; i++)
	{
		if(!Rx_Building(TeamCredits[teamNum].Refinery[i]).IsDestroyed() && TeamCredits[teamNum].Refinery[i].ShouldSpawnHarvester())
			return false;
	}

	return true;
}

function float GetTeamRefineryCreditsSum(byte teamNum)
{
	local int i;
	local float Credits;

	if(TeamCredits[teamNum].Refinery.length <= 0)
		return 0;

	for(i=0; i<TeamCredits[teamNum].Refinery.length; i++)
	{

		if(!Rx_Building(TeamCredits[teamNum].Refinery[i]).IsDestroyed())
			Credits += TeamCredits[teamNum].Refinery[i].GetCreditsPerTick();

	}
	return Credits;
}

function TickCredits(byte TeamNum)
{
	local float CreditTickAmount;

	CreditTickAmount = Rx_MapInfo(WorldInfo.GetMapInfo()).BaseCreditsPerTick;

	CreditTickAmount += GetTeamRefineryCreditsSum(TeamNum);

	GiveTeamCredits(CreditTickAmount, TeamNum);

	//Sync Credit and CP ticks

	Rx_TeamInfo(Teams[0]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_GDI*0.5)) ;
	Rx_TeamInfo(Teams[1]).AddCommandPoints(default.CP_TickRate+(DestroyedBuildings_Nod*0.5)) ;
}

function TickSupportPowerCooldowns(float DeltaTime)
{
	Rx_TeamInfo(Teams[0]).TickPowerCoolDowns(DeltaTime) ;
	Rx_TeamInfo(Teams[1]).TickPowerCoolDowns(DeltaTime) ;
}

function Tick(float DeltaTime)
{
	if(!(worldinfo.IsPlayInEditor() || worldinfo.IsPlayInPreview()))
		Rx_GameEngine(class'Engine'.static.GetEngine()).RxTick(DeltaTime);

	// Credit ticking
	CreditTickTimer -= DeltaTime;

	LANBroadcast.Tick(DeltaTime);

	if (CreditTickTimer <= 0 && WorldInfo.GRI.bMatchHasBegun)
	{
		TickCredits(TEAM_GDI);
		TickCredits(TEAM_NOD);
		TickSupportPowerCooldowns(DeltaTime); 
		// Reset timer
		CreditTickTimer = CreditTickRate;
	}
}

function LANRecievedLineSubscriber(string Line)
{
	`log("Rx_Game: LANRecievedLineSubscriber:" @ Line);
}

function bool MapPackageHasDayNight (string ThePackage)
{
	return false;
}

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
	local bool ret;

	ret = super.PickupQuery(Other,ItemClass,Pickup);
	if(!ret)
		return false;

	if(ItemClass == class'Rx_Weapon_IonCannonBeacon' && Other.GetTeamNum() == TEAM_NOD)
	{
		return false;
	}
	if(ItemClass == class'Rx_Weapon_NukeBeacon' && Other.GetTeamNum() == TEAM_GDI)
	{
		return false;
	}
	return ret;
}

function RxConsFail(PlayerController Con)
{
	if(Con != none)
	{
		Rx_Controller(Con).ResetRxConsole();
		RxLog("Player" `s `PlayerLog(Con.PlayerReplicationInfo) `s"Kicked for CONSOLE MISMATCH;");
		AccessControl.KickPlayer(Con, "CONSOLE MISMATCH");
	}
}

exec function QueueDownload(string PackageName)
{
	`RxEngineObject.PackageDownloader.QueueDownload(PackageName);
}

function CalculateEndGameAwards(byte ForTeam)
{
local PlayerReplicationInfo PRI;
local Rx_PRI RxPRI, Offensive_PRI, Defensive_PRI, Support_PRI, MVP_PRI;
local float HighestOffensiveScore, HighestDefensiveScore, HighestSupportScore, HighestTotalScore;

	foreach GameReplicationInfo.PRIArray(PRI)
		{

		if(Rx_PRI(PRI) != none && PRI.GetTeamNum() == ForTeam)
			{
				RxPRI=Rx_PRI(PRI);

				RxPRI.UpdateAllScores(); //Refresh all scores

				//Is its offensive score higher than the current? If so, set it to the highest
				if(RxPRI.Score_Offense > HighestOffensiveScore)
				{
					HighestOffensiveScore = RxPRI.Score_Offense;
					Offensive_PRI = RxPRI;
				}
				//Same For Defense
				if(RxPRI.Score_Defense > HighestDefensiveScore)
				{
					HighestDefensiveScore = RxPRI.Score_Defense;
					Defensive_PRI = RxPRI;
				}
				//Same For Defense
				if(RxPRI.Score_Support > HighestSupportScore)
				{
					HighestSupportScore = RxPRI.Score_Support;
					Support_PRI = RxPRI;
				}
				//Lastly, for the grand total to find MVP
				if(RxPRI.GetTotalScore() > HighestTotalScore)
				{
					HighestTotalScore = RxPRI.GetTotalScore();
					MVP_PRI = RxPRI;
				}
			}
		}

	if(MVP_PRI != none)
		{
			Award_MVP[ForTeam] = MVP_PRI;
			//`log("MVP Score:" @ Award_MVP[ForTeam].GetTotalScore() @ Award_MVP[ForTeam].PlayerName  );
		}
	if(Offensive_PRI != none)
		{
			Award_Offense[ForTeam] = Offensive_PRI;
			//`log("Offense Score: " @ Award_Offense[ForTeam].Score_Offense );
		}
	if(Defensive_PRI != none)
		{
			Award_Defense[ForTeam] = Defensive_PRI;
			//`log("Defense Score: " @ Award_Defense[ForTeam].Score_Defense);
		}
	if(Support_PRI != none)
		{
			Award_Support[ForTeam] = Support_PRI;
			//`log("Support Score: " @ Award_Support[ForTeam].Score_Support);
		}




}

function AssignAwards(byte ForTeam)
{
	local string RMVP, RBO,RBD,RBS;
	if(ForTeam > 1) return;

	if(Award_MVP[ForTeam] != none) RMVP = Award_MVP[ForTeam].PlayerName;
	if(Award_Offense[ForTeam] != none) RBO = Award_Offense[ForTeam].PlayerName;
	if(Award_Defense[ForTeam] != none) RBD = Award_Defense[ForTeam].PlayerName;
	if(Award_Support[ForTeam] != none) RBS = Award_Support[ForTeam].PlayerName;

	Rx_GRI(GameReplicationInfo).SetAwards(ForTeam,RMVP,RBO,RBD,RBS);
}

/*****************************************************
*********************Team Management******************
******************************************************/

function bool RTCDisabled()
{
	return WorldInfo.TimeSeconds < RTC_DisableTime;
}

function string GetRTCDisabledTimeString()
{
	return max(0,RTC_DisableTime - WorldInfo.TimeSeconds)/60 $ ":" $ int((RTC_DisableTime - WorldInfo.TimeSeconds) % 60) ;

}

function AddTeamChangeRequest(Rx_PRI PRI)
{
	local TC_Request RTC_Ticket;
	local bool bCanSwitch;
	local Rx_Controller RxC;
	local string TeamString;

	bCanSwitch = true;

	RTC_Ticket.PPRI = PRI;
	RTC_Ticket.TimeStamp = WorldInfo.TimeSeconds;

	if(RTC_GDI.Find('PPRI', PRI) != -1) bCanSwitch = false;
	else
	if(RTC_Nod.Find('PPRI', PRI) != -1) bCanSwitch = false;

	if(!bCanSwitch)
	{
		Rx_Controller(PRI.Owner).CTextMessage("You already have a change request");
		return;
	}

	if(PRI.GetTeamNum() == 0)
	{
		RTC_GDI.AddItem(RTC_Ticket);
		TeamString = "to"@(GetTeamName(1));
	}
	else
	{
		RTC_Nod.AddItem(RTC_Ticket);
		TeamString = "to"@(GetTeamName(0));
	}


	foreach WorldInfo.AllControllers(class'Rx_Controller', RxC)
	{
		RxC.CTextMessage(class'Rx_HUD'.static.CleanHTMLMessage(PRI.PlayerName) @ "wants to swap" @ TeamString, 'Orange', 80);
	}

	CleanupRTC();
	if(TeamsAreEven()) ProcessRTC();

}

function bool TeamsAreEven()
{
	local int T1_Players, T2_Players;
	local PlayerReplicationInfo PRI;

	if(WorldInfo.NetMode == NM_StandAlone) return false;
	else
	{
		CleanupRTC();

		foreach WorldInfo.GRI.PRIArray(PRI)
		{
			if(PRI.bBot) continue;
			else
			if(PRI.GetTeamNum() == 0) T1_Players++;
			else
			if(PRI.GetTeamNum() == 1) T2_Players++;
		}

	}
	//`log(T1_Players @ "/" @ T2_Players);

	if(T1_Players == T2_Players) return true;

	return false;
}

function CleanupRTC()
{
	local TC_Request RT;

	//Clean out GDI RTCs
	foreach RTC_GDI(RT)
		{
			if(WorldInfo.TimeSeconds - RT.TimeStamp >= RTC_TimeLimit)
			{
				Rx_Controller(RT.PPRI.Owner).CTextMessage("-Team change request expired-") ;
				RTC_GDI.RemoveItem(RT);
			}
		}
		//Clean out Nod RTCs
		foreach RTC_Nod(RT)
		{
			if(WorldInfo.TimeSeconds - RT.TimeStamp >= RTC_TimeLimit)
			{
				Rx_Controller(RT.PPRI.Owner).CTextMessage("-Team change request expired-") ;
				RTC_Nod.RemoveItem(RT);
			}
		}
}

function ProcessRTC()
{
	local int i;
	local int CredAmount;
	for(i=0;i<RTC_GDI.Length;i++)
	{
	if(RTC_GDI[i].PPRI != none && RTC_Nod[i].PPRI !=none)
		{
			/*Process GDI Player*/

			//Remove commander status from either of them
			if(RTC_GDI[i].PPRI == Commander_PRI[0]) RemoveCommander(0);
			if(RTC_Nod[i].PPRI == Commander_PRI[1]) RemoveCommander(1);

			CredAmount = RTC_GDI[i].PPRI.GetCredits();
			SetTeam(Controller(RTC_GDI[i].PPRI.Owner),Teams[TEAM_Nod], true);

			if (Controller(RTC_GDI[i].PPRI.Owner).Pawn != None)
				Controller(RTC_GDI[i].PPRI.Owner).Pawn.Destroy();

			RTC_GDI[i].PPRI.SetCredits(CredAmount);

			/*Process Nod Player*/


			CredAmount = RTC_Nod[i].PPRI.GetCredits();
			SetTeam(Controller(RTC_Nod[i].PPRI.Owner),Teams[TEAM_GDI], true);

			if (Controller(RTC_Nod[i].PPRI.Owner).Pawn != None)
				Controller(RTC_Nod[i].PPRI.Owner).Pawn.Destroy();

			RTC_Nod[i].PPRI.SetCredits(CredAmount);

			//SetTeam(Controller(RTC_Nod[i].PPRI.Owner) ,Teams[TEAM_GDI], true);
			CTextBroadcast(255, Caps("SWAPPED:" @ RTC_GDI[i].PPRI.PlayerName @ "and" @ RTC_Nod[i].PPRI.PlayerName));
			RTC_GDI.Remove(i,1);
			RTC_Nod.Remove(i,1);
		}
	}

}

function CTextBroadcast(byte TeamByte,string TEXT, optional name Colour = 'LightBlue', optional float TIME = 60.0, optional float Size = 1.0, optional bool bWarning, optional SoundCue BeepSound)
{
	local Rx_Controller P;

	if(TeamByte == 0 || TeamByte == 1)
	{
		foreach WorldInfo.AllControllers(class'Rx_Controller', P)
		{
			if(P.GetTeamNum() == TeamByte)
				P.CTextMessage(TEXT,Colour,TIME, Size,,bWarning, BeepSound) ;
			else
				continue;
		}
	}
	else
	{
	foreach WorldInfo.AllControllers(class'Rx_Controller', P)
		{
			P.CTextMessage(TEXT,Colour,TIME, Size,,bWarning, BeepSound) ;
		}
	}
}

function MarqueeBroadcast(byte TeamByte,Texture2D MarqueeTex, float LingerTime, optional SoundCue MarqueeSound)
{
	local Rx_Controller P;

	if(TeamByte == 0 || TeamByte == 1)
	{
		foreach WorldInfo.AllControllers(class'Rx_Controller', P)
		{
			if(P.GetTeamNum() == TeamByte)
				P.AddMarquee(MarqueeTex, LingerTime, MarqueeSound);
			else
				continue;
		}
	}
	else
	{
		foreach WorldInfo.AllControllers(class'Rx_Controller', P)
		{
			P.AddMarquee(MarqueeTex, LingerTime, MarqueeSound);
		}
	}
}

function bool TeamHasSurrendered()
{
	return bGDIHasSurrendered || bNodHasSurrendered ;
}

/****************************
*Commander Functions
****************************/

function ChangeCommander(byte ToTeam, Rx_PRI RxPRI, optional bool bIsInitialSetting = false)
{
	local Rx_PRI PRIi;
	local byte AntiTeamByte;

	if(ToTeam < 3) AntiTeamByte = ToTeam == 0 ? 1 : 0 ;

	if(!bEnableCommanders)
		return;

	RemoveCommander(ToTeam);

	Commander_PRI[ToTeam] = RxPRI;

	if(bUseStaticCommanders && !bIsInitialSetting) `RxEngineObject.SetStaticCommanderID(ToTeam, RxPRI);

	if (Commander_PRI[AntiTeamByte] == None)
	{
		CTextBroadcast(AntiTeamByte, "Enemy commander detected, elect your own!", 'Red', 90, 1.5, true);
	}
	else
		CTextBroadcast(AntiTeamByte, "Enemy commander detected", 'Red', 90, 1.5, true);

	Rx_TeamInfo(Teams[toTeam]).SetAllPowersOnCoolDown(false);

	foreach AllActors(class'Rx_PRI', PRIi)
	{
	if(PRIi.GetTeamNum() == ToTeam )
		{
			PRIi.SetCommander(RxPRI);
		}
	}
}

function RemoveCommander(byte ToTeam)
{
	local Rx_PRI PRIi;

	Commander_PRI[ToTeam] = none;

	//if(bUseStaticCommanders) `RxEngineObject.ClearStaticCommanderID(ToTeam);

	foreach AllActors(class'Rx_PRI', PRIi)
	{
	if(PRIi.GetTeamNum() == ToTeam )
		{
			PRIi.RemoveCommander(ToTeam);
		}
	}
}

function int GetFreeTarget(byte TeamByte, byte TargetType, PlayerReplicationInfo RxPRI)
{
	local int i;

	//Geeds
	if(TeamByte == 1 && TargetType == 1)
	{
			if(TargetedPlayers_Nod.Find(RxPRI) != -1)
			{
				return -1 ; //Found, tell PRI to just refresh its timer
			}
			else
			{
				for (i=0;i<=TargetedPlayers_Nod.Length;i++)
				{
					if(i==TargetedPlayers_Nod.Length)
					{
						//`log("Adding new target" $ i);
						TargetedPlayers_Nod.AddItem(RxPRI);
						return i+1;
					}
					else
					if(TargetedPlayers_Nod[i] == none)
					{
						//`log("Found occurrence NONE - I is " $ i);
						TargetedPlayers_Nod[i] = RxPRI;
						return i+1;
					}
				}


			}
	}
	else
	//Nod's Attack target logic
	if(TeamByte == 0 && TargetType == 1)
	{
			if(TargetedPlayers_GDI.Find(RxPRI) != -1)
			{
				return -1 ; //Found, tell PRI to just refresh its timer
			}
			else
			{
				for (i=0;i<=TargetedPlayers_GDI.Length;i++)
				{
					if(i==TargetedPlayers_GDI.Length)
					{
						//`log("Adding new target" $ i);
						TargetedPlayers_GDI.AddItem(RxPRI);
						return i+1;
					}
					else
					if(TargetedPlayers_GDI[i] == none)
					{
						//`log("Found occurrence NONE - I is " $ i);
						TargetedPlayers_GDI[i] = RxPRI;
						return i+1;
					}
				}


			}
	}

	return 9999;
}

function RemoveTarget(byte TeamByte, PlayerReplicationInfo RxPRI, optional byte Special) //Special (USed for a target being destroyed or what not)
{
	local int i;
	local bool bPlayDecayMsg; //Don't spam decay messages. We get it, Yosh! We done fucked up!

	bPlayDecayMsg = false;//(WorldInfo.TimeSeconds - LastDecayMsgTime[TeamByte]) >= 3.0 ;

	if(TeamByte == 0 )
	{
		i = TargetedPlayers_GDI.Find(RxPRI);

		if (i != -1) TargetedPlayers_GDI[i] = none ; //.Remove(i,1) ;

		switch (Special)
		{
			//0-9 Infantry
			case 0:
			if(bPlayDecayMsg)
			{
				CTextBroadcast(1,"--Infantry Target Decayed--",'White');
				LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
			}
			break;
			case 1:
				//CTextBroadcast(1,"--Infantry Target Eliminated--",'Green');
				Rx_TeamInfo(Teams[1]).AddCommandPoints(CPReward_Infantry, "Command Target Elimination&" $ CPReward_Infantry $ "&") ;
				break;

			//10's Ground vehicles

				case 10:
				if(bPlayDecayMsg)
				{
					CTextBroadcast(1,"--Vehicle Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}
				break;

			case 11:
				//CTextBroadcast(1,"--Vehicle Target Eliminated--",'Green');
				Rx_TeamInfo(Teams[1]).AddCommandPoints(CPReward_Vehicle, "Command Target Elimination&" $ CPReward_Vehicle $ "&") ;
				break;

			//30's Emplacement messages

			case 30 :
				if(bPlayDecayMsg)
				{
					CTextBroadcast(1,"--Emplacement Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}
				break;

			case 31 :
				//CTextBroadcast(1,"--Emplacement Target Destroyed--",'Green');
				Rx_TeamInfo(Teams[1]).AddCommandPoints(CPReward_Emplacement, "Command Target Elimination&" $ CPReward_Emplacement $ "&") ;
				break;

			//40's = Aircraft messages
			case 40 :
				if(bPlayDecayMsg)
				{
					CTextBroadcast(1,"--Aircraft Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}

				break;

			case 41 :
				//CTextBroadcast(1,"--Aircraft Target Destroyed--",'Green');
				Rx_TeamInfo(Teams[1]).AddCommandPoints(CPReward_Vehicle, "Command Target Elimination&" $ CPReward_Vehicle $ "&") ;
				break;

				//100+ for special messages
			case 100:
				if(bPlayDecayMsg)
				{
					//CTextBroadcast(1,"--Stealth Target Lost--",'LightBlue');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}

			break;

			default:
			break;
		}
	}
	else
	if(TeamByte == 1 )
	{
		i = TargetedPlayers_Nod.Find(RxPRI);

		if (i != -1) TargetedPlayers_Nod[i] = none ; //.Remove(i,1) ;

		switch (Special)
		{
			//0-9 Infantry
			case 0:
				if(bPlayDecayMsg)
				{
					CTextBroadcast(0,"--Infantry Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}

			break;

			case 1:
				//CTextBroadcast(0,"--Infantry Target Eliminated--",'Green');
				Rx_TeamInfo(Teams[0]).AddCommandPoints(CPReward_Infantry, "Command Target Elimination&" $ CPReward_Infantry $ "&") ;
				break;

				//10's Ground vehicles

			case 10:
				if(bPlayDecayMsg)
				{
					CTextBroadcast(0,"--Vehicle Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}
				break;

			case 11:
				//CTextBroadcast(0,"--Vehicle Target Eliminated--",'Green');
				Rx_TeamInfo(Teams[0]).AddCommandPoints(CPReward_Vehicle, "Command Target Elimination&" $ CPReward_Vehicle $ "&") ;
				break;

			//30's Emplacement messages

			case 30 :
				if(bPlayDecayMsg)
				{
					CTextBroadcast(0,"--Emplacement Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}
				break;

			case 31 :
				//CTextBroadcast(0,"--Emplacement Target Destroyed--",'Green');
				Rx_TeamInfo(Teams[0]).AddCommandPoints(CPReward_Emplacement, "Command Target Elimination&" $ CPReward_Emplacement $ "&") ;
				break;

				//40's = Aircraft messages
			case 40 :
				if(bPlayDecayMsg)
				{
					CTextBroadcast(0,"--Aircraft Target Decayed--",'White');
					LastDecayMsgTime[TeamByte] = WorldInfo.TimeSeconds;
				}
				break;

			case 41 :
				//CTextBroadcast(0,"--Aircraft Target Destroyed--",'Green');
				Rx_TeamInfo(Teams[0]).AddCommandPoints(CPReward_Vehicle, "Command Target Elimination&" $ CPReward_Vehicle $ "&") ;
				break;

				//100+ for special messages
			case 100:
				//CTextBroadcast(0,"--Stealth Target Lost--",'LightBlue');
				break;

			default:
				break;
		}
	}
	else
	`log("-------RECIEVED INAPPROPRIATE TEAM BYTE-------" @ TeamByte);

}


function int GetDefenceID() //Are there ever going to be over like ... 10billion defences on a map? Unlikely.Assign as they come
{
	Defence_IDs++;
	return Defence_IDs;

}

function int GetScriptedID() //basically the same deal as above. About the 10 billion part though, only time will tell
{
	Scripted_IDs++;
	return Scripted_IDs;

}


function bool CanSpectate( PlayerController Viewer, PlayerReplicationInfo ViewTarget )
{
	if(!Controller(ViewTarget.Owner).bIsPlayer || Rx_PRI(ViewTarget) == None)
	{
		return false;
	}

	return true;
}

/** AddInactivePRI()
* Add PRI to the inactive list, remove from the active list
*/
function AddInactivePRI(PlayerReplicationInfo PRI, PlayerController PC)
{
	local int i;
	local PlayerReplicationInfo NewPRI, CurrentPRI;
	local bool bIsConsole;
//	local int TeamID;

	// don't store if it's an old PRI from the previous level or if it's a spectator
	if (!PRI.bFromPreviousLevel && !PRI.bOnlySpectator)
	{
		NewPRI = PRI.Duplicate();
		WorldInfo.GRI.RemovePRI(NewPRI);

		// make PRI inactive
		NewPRI.RemoteRole = ROLE_None;

		// delete after 5 minutes (EDIT: This is fu**ing Renegade... Give them an hour)
		NewPRI.LifeSpan = 3600; //300;
		if(Rx_PRI(PRI) != None // Player is human and can store a lingeringPawn
			&& PC.Pawn != None
			&& (PC.Pawn.IsA('Rx_Pawn') || PC.Pawn.IsA('Rx_Vehicle'))) { // Pawn is a character or vehicle (i.e: not a camera))
			Rx_PRI(NewPRI).OldTeamID = PRI.GetTeamNum();
			Rx_PRI(NewPRI).bDonateOnDelete = true;
		}
		// On console, we have to check the unique net id as network address isn't valid
		bIsConsole = WorldInfo.IsConsoleBuild();

		// make sure no duplicates
		for (i=0; i<InactivePRIArray.Length; i++)
		{
			CurrentPRI = InactivePRIArray[i];
			if ( (CurrentPRI == None) || CurrentPRI.bDeleteMe ||
				(!bIsConsole && (CurrentPRI.SavedNetworkAddress == NewPRI.SavedNetworkAddress)) ||
				(bIsConsole && CurrentPRI.UniqueId == NewPRI.UniqueId) )
			{
				InactivePRIArray.Remove(i,1);
				i--;
			}
		}
		InactivePRIArray[InactivePRIArray.Length] = NewPRI;

		// cap at 16 saved PRIs [What is this plebian nonsense?] we'll make it 64.. and probably crash servers
		if ( InactivePRIArray.Length > 64 )
		{
			InactivePRIArray.Remove(0, InactivePRIArray.Length - 64);
		}
	}

	PRI.Destroy();
	// Readjust the skill rating now that this player has left
	RecalculateSkillRating();
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local string ThisMapPrefix;
	local int i,pos;
	local class<GameInfo> NewGameType, testGameType;
	local string GameOption;


	if (Left(MapName, 9) ~= "EnvyEntry" || Left(MapName, 14) ~= "UDKFrontEndMap" )
	{
		NewGameType = class'UTEntryGame';
	}

	// allow commandline to override game type setting
	GameOption = ParseOption( Options, "Game");
	if ( GameOption != "" )
	{
		NewGameType = Default.class;
	}

	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
	MapName = StripPlayOnPrefix( MapName );

	// replace self with appropriate gametype if no game specified
	pos = InStr(MapName,"-");
	ThisMapPrefix = left(MapName,pos);
	for (i = 0; i < default.MapPrefixes.length; i++)
	{
		if (default.MapPrefixes[i] ~= ThisMapPrefix)
		{
			 NewGameType = Default.class;
		}
	}

	// change game type
	for ( i=0; i<Default.DefaultMapPrefixes.Length; i++ )
	{
		if ( Default.DefaultMapPrefixes[i].Prefix ~= ThisMapPrefix )
		{
			testGameType = class<GameInfo>(DynamicLoadObject(Default.DefaultMapPrefixes[i].GameType,class'Class'));
			if ( testGameType != None )
			{
				NewGameType = testGameType;
			}
		}
	}
	for ( i=0; i<Default.CustomMapPrefixes.Length; i++ )
	{
		if ( Default.CustomMapPrefixes[i].Prefix ~= ThisMapPrefix )
		{
			testGameType = class<GameInfo>(DynamicLoadObject(Default.CustomMapPrefixes[i].GameType,class'Class'));
			if ( testGameType != None )
			{
				NewGameType = testGameType;
			}
		}
	}
	
	if(NewGameType != none)
		return NewGameType;

    return Default.class;
}

function DoEvaMessageWithTeamMMRs()
{

	local PlayerReplicationInfo pri;
	local float score;
	local float gdiMMR;
	local float nodMMR;
	local string PlayerUUID;
	local int PlayerListIndex;

	foreach WorldInfo.GRI.PRIArray(pri)
	{
		if(Rx_Pri(pri) != None && Rx_Controller(pri.Owner) != None && pri.Team != None)
		{
			Rx_Controller(pri.Owner).RequestDeviceUUID();
			PlayerUUID = Rx_Controller(pri.Owner).PlayerUUID;
			if(PlayerUUID == "")
			{
				PlayerUUID = pri.PlayerName;
			}
			PlayerListIndex = PlayerMonitor.MyPlayersInfo.Find('UUID',PlayerUUID);
			if(PlayerListIndex >= 0)
			{
				score = PlayerMonitor.MyPlayersInfo[PlayerListIndex].SavedScore / PlayerMonitor.MyPlayersInfo[PlayerListIndex].JoinedGame;
			}
			else
			{
				score = PlayerMonitor.CalcPlayerScore(Rx_Pri(pri));
			}
			if(pri.Team.TeamIndex == TEAM_GDI)
				gdiMMR += score;
			else
				nodMMR += score;
		}
	}
	WorldInfo.Game.Broadcast(None, "Current Team-MMR: GDI="@gdiMMR@",Nod="@nodMMR);
}


//Check if autobalance is applicable
//This is where auto balance is started!
function CheckForAutoBalance()
{
	local int sizeGDI,sizeNOD;
	local int difference;
	local int teamToBalanceFor;
	//local float temp;
	if(!bAutoBalanceCurrentlyAllowed)
	{
		return;
	}
	`log("Checking team sizes for auto balance...");
	sizeGDI = Teams[TEAM_GDI].size;
	sizeNOD = Teams[TEAM_NOD].size;
	`log("Team sizes are: "@ " GDI: "@ sizeGDI @ " NOD: " @ sizeNOD);

	if(sizeGDI==sizeNod)
		return;

	if(sizeGDI<sizeNod)
	{
		difference=sizeNOD-sizeGDI;
		teamToBalanceFor=TEAM_GDI;
	}
	else{
		difference=sizeGDI-sizeNod;
		teamToBalanceFor=TEAM_NOD;
	}

	`log("Difference is: "@ difference);
	`log("threshold is: "@ AutobalanceThreshold);
	if(difference >=AutobalanceThreshold)
	{
		//temp = `AUTO_BALANCE_TIME;
		`log("Threshold reached starting vote");
		RxLog("AUTOBALANCE" `s "Enabled;" `s "gdi_count" `s sizeGDI `s "nod_count" `s sizeNOD `s "threshold" `s AutobalanceThreshold);
		bAutoBalanceSwapOnDeath=false;//Don't swap on death for the first ten seconds
		SetTimer(10, false, nameof(EnableAutoBalanceDeathSwap));
		Rx_GRI(GameReplicationInfo).bAutobalanceInProgress=true;
		Rx_GRI(GameReplicationInfo).TeamNeedingPlayers=teamToBalanceFor;
		bCurrentlyShuffling=true;
		Rx_GRI(GameReplicationInfo).bBalanceAchieved=false;
		Rx_GRI(GameReplicationInfo).bBalanceCancelled=false;
		if(!bAutoBalanceRewardVp)
		{
			Rx_GRI(GameReplicationInfo).BalanceReward=Clamp(AutoBalanceCreditReward*((WorldInfo.TimeSeconds-gameStartTime)/AutoBalanceMaximumRewardTime),0,AutoBalanceCreditReward);
		}
		else
		{
			Rx_GRI(GameReplicationInfo).BalanceReward=Clamp(AutoBalanceVpReward*((WorldInfo.TimeSeconds-gameStartTime)/AutoBalanceMaximumRewardTime),0,AutoBalanceVpReward);
		}

		if(AutoBalanceDuration!=0)
			SetTimer(AutoBalanceDuration, false, nameof(CancelAutoBalanceWithFailure));
	}
}

function EnableAutoBalanceDeathSwap()
{
	bAutoBalanceSwapOnDeath=true;
}

function CancelAutoBalance(string Reason)
{
	Rx_GRI(GameReplicationInfo).bAutobalanceInProgress=false;
	Rx_GRI(GameReplicationInfo).TeamNeedingPlayers=-1;
	bCurrentlyShuffling=false;
	Rx_GRI(GameReplicationInfo).bBalanceAchieved=true;
	Rx_GRI(GameReplicationInfo).bBalanceCancelled=true;
	bAutoBalanceSwapOnDeath=false;
	RxLog("AUTOBALANCE" `s "Cancelled;" `s "reason" `s Reason `s "gdi_count" `s Teams[TEAM_GDI].size `s "nod_count" `s Teams[TEAM_NOD].size `s "threshold" `s AutobalanceThreshold);
}

function CancelAutoBalanceWithFailure()//We weren't able to auto balance within the given timeframe, cancel it and give it a cooldown
{
	Rx_GRI(GameReplicationInfo).bAutobalanceInProgress=false;
	Rx_GRI(GameReplicationInfo).TeamNeedingPlayers=-1;
	Rx_GRI(GameReplicationInfo).bBalanceAchieved=true;
	Rx_GRI(GameReplicationInfo).bBalanceCancelled=false;
	bAutoBalanceSwapOnDeath=false;
	bCurrentlyShuffling=false;
	//Allow auto balance after a delay (cooldown)
	DisAllowAutoBalance();
	//Start Timer to allow auto balance
	SetTimer(AutoBalanceCooldown, false, 'AllowAutoBalance');

	RxLog("AUTOBALANCE" `s "Failed;" `s "gdi_count" `s Teams[TEAM_GDI].size `s "nod_count" `s Teams[TEAM_NOD].size `s "threshold" `s AutobalanceThreshold);
}

//Deprecated
function FinalizeAutoBalance()
{
	local Controller PC;
	local array<Controller> toBeSwapped;
	local int teamNeedingPlayersIndex;

	teamNeedingPlayersIndex=Rx_GRI(GameReplicationInfo).TeamNeedingPlayers;

	`log("Finalizing balancing...");
	// randomly set all players to a team
	ForEach WorldInfo.AllControllers(class'Controller', PC)
	{
		if (Rx_Bot(PC) == None && PlayerController(PC) == None || PlayerController(PC).GetTeamNum()==teamNeedingPlayersIndex) continue;

		if (PC.PlayerReplicationInfo != None && PC.PlayerReplicationInfo.Team != None)
		{
			toBeSwapped.AddItem(PC);

			if(toBeSwapped.Length + Teams[teamNeedingPlayersIndex].size >= Teams[1-teamNeedingPlayersIndex].size)
			{
				break;
			}
		}
	}

	ForEach toBeSwapped(PC)
	{
		`log(PC.GetHumanReadableName()@" Voluntold to switch teams");

		if(Teams[teamNeedingPlayersIndex].size >= Teams[1-teamNeedingPlayersIndex].size)
		{
			break;
		}

		`log(PC.GetHumanReadableName()@"set to GDI");
		SetTeam(PC, Teams[Rx_GRI(GameReplicationInfo).TeamNeedingPlayers], false);
		if (PC.Pawn != None) PC.Pawn.PlayerChangedTeam();
	}

	Rx_GRI(GameReplicationInfo).bAutobalanceInProgress=false;
	Rx_GRI(GameReplicationInfo).TeamNeedingPlayers=-1;
	bCurrentlyShuffling=false;
	Rx_GRI(GameReplicationInfo).bBalanceAchieved=true;
	Rx_GRI(GameReplicationInfo).bBalanceCancelled=false;

	`log("Teams should now be balanced...");
}

function ProcessVolunteer(Rx_Controller PC,bool bForced)
{
	local int tempCredits,tempVp,currentCredits;
	local string newTeam,oldTeam;
	local string reason,volunteerName;

	if(CheckForDisqualification(PC)) return;

	`log(PC.GetHumanReadableName()@"set to GDI");

	currentCredits=Rx_PRI(PC.PlayerReplicationInfo).GetCredits();

	SetTeam(PC, Teams[Rx_GRI(GameReplicationInfo).TeamNeedingPlayers], false);
	if (PC.Pawn != None) PC.Pawn.PlayerChangedTeam();

	if(!bAutoBalanceRewardVp){
		tempCredits=Clamp(AutoBalanceCreditReward*((WorldInfo.TimeSeconds-gameStartTime)/AutoBalanceMaximumRewardTime),0,AutoBalanceCreditReward);
	}
	else
	{
		tempVp=Clamp(AutoBalanceVpReward*((WorldInfo.TimeSeconds-gameStartTime)/AutoBalanceMaximumRewardTime),0,AutoBalanceVpReward);
		Rx_PRI(PC.PlayerReplicationInfo).AddVP(tempVp);
	}


	Rx_PRI(PC.PlayerReplicationInfo).AddCredits(tempCredits+currentCredits);


	newTeam=(Rx_GRI(GameReplicationInfo).TeamNeedingPlayers == 0? "GDI" : "Nod");
	oldTeam=(PC.GetTeamNum()== 0 ? "GDI" : "Nod");
	reason =(bForced ? "forced" : "voluntary");
	volunteerName =PC.PlayerReplicationInfo.PlayerName;
	RxLog("AUTOBALANCE" `s "Swapped;" `s volunteerName `s "joined" `s newTeam `s "left" `s oldTeam `s "reason" `s reason `s "credit_reward" `s tempCredits `s "vp_reward" `s tempVp);

	CheckBalanceConditions();

	LastBalancedPlayerIds.AddItem(Rx_PRI(PC.PlayerReplicationInfo).PlayerID);

}

function bool CheckForDisqualification(Rx_Controller PC)//Is there a reason we can't auto balance this guy?
{
	local Rx_Weapon_DeployedBeacon beacon;

	if(bMercyPreviouslyBalanced && LastBalancedPlayerIds.Find(Rx_PRI(PC.PlayerReplicationInfo).PlayerID)!=-1)
	{
		LastBalancedPlayerIds.RemoveItem(Rx_PRI(PC.PlayerReplicationInfo).PlayerID);//Shown Mercy, Remove them from the list so they can be balanced next time
		return true;
	}

	if(bMercyScoreThreshold > 0 && Rx_PRI(PC.PlayerReplicationInfo).ScoreInLastMinute >= bMercyScoreThreshold)
	{
		return true;
	}

	if(bMercyImportantGameObject)
	{
		foreach `WorldInfoObject.AllActors(class'Rx_Weapon_DeployedBeacon', beacon) //They own a beacon, let them be
			if (beacon.InstigatorController == PC)
				return true;
	}

	if(Rx_PRI(PC.PlayerReplicationInfo).bIsCommander)//WE'RE NOT MOVING THE COMMANDER ARE YOU INSANE?
	{
		return true;
	}

	return false;
}

function CheckBalanceConditions()//use to see if balance is complete or no longer required //This is where auto balancing is finished
{
	local int sizeGDI,sizeNOD;
	local int teamNeedingPlayersSize,teamGivingPlayersSize;
	`log("RE-Checking team sizes for auto balance...");
	sizeGDI = Teams[TEAM_GDI].size;
	sizeNOD = Teams[TEAM_NOD].size;

	teamNeedingPlayersSize=Teams[Rx_GRI(GameReplicationInfo).TeamNeedingPlayers].size;
	teamGivingPlayersSize=Teams[1-(Rx_GRI(GameReplicationInfo).TeamNeedingPlayers)].size;

	if(sizeGDI==sizeNod || teamNeedingPlayersSize>teamGivingPlayersSize)
	{
		if(sizeGDI==sizeNod)
		{
			`log("Balance achieved...");
		}
		else
		{
			if(WorldInfo.NetMode != NM_Standalone && !bCurrentlyShuffling && !bGameEnded &&  IsInState('MatchInProgress'))
				CheckForAutoBalance();
		}

		ClearTimer(nameof(CancelAutoBalanceWithFailure));
		Rx_GRI(GameReplicationInfo).bAutobalanceInProgress=false;
		Rx_GRI(GameReplicationInfo).TeamNeedingPlayers=-1;
		Rx_GRI(GameReplicationInfo).bBalanceAchieved=true;
		Rx_GRI(GameReplicationInfo).bBalanceCancelled=false;
		bAutoBalanceSwapOnDeath=false;
		bCurrentlyShuffling=false;

		//Allow auto balance after a delay (cooldown)
		DisAllowAutoBalance();
		//Start Timer to allow auto balance
		SetTimer(AutoBalanceCooldown, false, 'AllowAutoBalance');

		RxLog("AUTOBALANCE" `s "Success;" `s "gdi_count" `s Teams[TEAM_GDI].size `s "nod_count" `s Teams[TEAM_NOD].size `s "threshold" `s AutobalanceThreshold);
	}
}

//Used to turn the auto balancer on or off completely!
function ToggleAutoBalance(string Reason)
{
	bAutoBalancerEnabled=!bAutoBalancerEnabled;
	if(Rx_GRI(GameReplicationInfo).bAutobalanceInProgress)
	{
		CancelAutoBalance(Reason);
	}
	`log("Toggling auto balance...");
}

//Init the auto balancer, called when game starts
function InitAutoBalancer()
{
	Rx_GRI(GameReplicationInfo).bAutoBalanceForced=bAutoBalanceForced;
	Rx_GRI(GameReplicationInfo).BalanceReward=AutoBalanceCreditReward;
	Rx_GRI(GameReplicationInfo).bAutoBalanceVpRewardEnabled=bAutoBalanceRewardVp;

	//Allow auto balance after a delay (initial cooldown)
	DisAllowAutoBalance();
	//Start Timer to allow auto balance
	SetTimer(TimeTillFirstAutoBalance, false, 'AllowAutoBalance');
}

//Helper functions to cool down auto balance // Used for cooldowns ONLY
function AllowAutoBalance()
{
	bAutoBalanceCurrentlyAllowed=true;
}

function DisAllowAutoBalance()
{
	bAutoBalanceCurrentlyAllowed=false;
}

/* ALL OUT WAR GAME TIME STATE */
function eOverTimeState GetOverTimeState()
{
	return OverTimeState; 
}

function SetOverTimeState(eOverTimeState NewState)
{
	local Rx_GRI RxGRI; 

	RxGRI = Rx_GRI(WorldInfo.GRI); 

	OverTimeState = NewState; 

	if(OverTimeState == E_OverTime)
	{
		MarqueeBroadcast(0, T_Marquee_OT, 4.0,OverTimeStartSound[0]);
		MarqueeBroadcast(1, T_Marquee_OT, 4.0,OverTimeStartSound[1]);  

		//CTextBroadcast(0,">> ENTERING OVERTIME <<", 'Red', 180.0, 1.0, true, OverTimeStartSound[0]);
		//CTextBroadcast(1,">> ENTERING OVERTIME <<", 'Red', 180.0, 1.0, true, OverTimeStartSound[1]);
		SetTimeLimit(OverTimeTimeLimit);
		SetRevivesEnabled(false); 
		//SetTimer(3.5,false, 'PlayBuildingReviveMessage');

		if(RxGRI != none)
			RxGRI.SetTimeStatus("Overtime");
	}
	else if(OverTimeState == E_DoubleOverTime)
	{
		MarqueeBroadcast(0, T_Marquee_SD, 4.0,SuddenDeathStartSound);
		MarqueeBroadcast(1, T_Marquee_SD, 4.0,SuddenDeathStartSound);  
		//CTextBroadcast(255,">> ENTERING SUDDEN DEATH <<", 'Red', 180.0, 1.0, true);
		SetTimeLimit(SuddenDeathTimeLimit);
		//SetBuildingsRepairable(false, 255); 
		SetBuildingDamageMultiplier(SuddenDeath_DmgMult, 255);
		//SetTimer(3.5,false, 'PlayBuildingRepairsDisabled');
		if(RxGRI != none)
			RxGRI.SetTimeStatus("S. Death");
	}
}

function SetRevivesEnabled(bool bEnable)
{
	bBuildingsRevive = bEnable; 
}

function PlayBuildingReviveMessage()
{
	if(bBuildingsRevive)
	{
		 CTextBroadcast(255,">> BUILDING REVIVAL ENABLED <<", 'Red', 180.0, 1.0, false);
	}
	else
	{
		CTextBroadcast(255,">> BUILDING REVIVAL DISABLED <<", 'Red', 180.0, 1.0, true, SoundCue'RX_WP_IonCannon.Sounds.SC_StrikImminent_Siren');
	}
}

function PlayBuildingRepairsDisabled()
{
	CTextBroadcast(255,">> BUILDING REPAIRS DISABLED <<", 'Red', 180.0, 1.0, true, SoundCue'RX_WP_IonCannon.Sounds.SC_StrikImminent_Siren');
}

function SetBuildingsRepairable(bool bNewRepair, byte TeamByte)
{
	local Rx_Building B; 
	
	foreach AllActors(class'Rx_Building', B)
	{
		if( (TeamByte != 255 && B.GetTeamNum() != TeamByte) || Rx_Building_Techbuilding(B) != None || !B.bSignificant)
			continue;

		B.SetCanRepair(bNewRepair);
	}
}

function SetBuildingDamageMultiplier(float NewMult, byte TeamByte)
{
	local Rx_Building B; 
	
	foreach AllActors(class'Rx_Building', B)
	{
		if( (TeamByte != 255 && B.GetTeamNum() != TeamByte) || Rx_Building_Techbuilding(B) != None || !B.bSignificant)
			continue;

		B.SetDamageMultiplier(NewMult);
	}
}

function SetTimeLimit(float NewTimeLimit)
{
	if(ROLE == ROLE_Authority)
	{
		TimeLimit = NewTimeLimit; 
		RxLog("GAME" @ "Setting timelimit to:" @ TimeLimit);

		if(Rx_GRI(WorldInfo.GRI) != none)
			Rx_GRI(WorldInfo.GRI).SetTimeLimit(NewTimeLimit);

	}
}

function SetSurrenderTimeState(byte SurrenderingTeam)
{
	local Rx_GRI RxGRI; 

	RxGRI = Rx_GRI(WorldInfo.GRI); 

	SetTimeLimit(SurrenderLength+1);
	SetRevivesEnabled(false); 
	CancelTeamBuildingRevives(SurrenderingTeam);
	//SetTimer(3.5,false, 'PlayBuildingReviveMessage');

	if(RxGRI != none)
		RxGRI.SetTimeStatus("GameOver");
}

function CancelTeamBuildingRevives(byte TeamByte)
{
	local Rx_Building B; 
	
	foreach AllActors(class'Rx_Building', B)
	{
		if( (TeamByte != 255 && B.GetTeamNum() != TeamByte) || Rx_Building_Techbuilding(B) != None || !B.bSignificant)
			continue;
		B.CancelRevive();
	}
}

function EvaluatePoints()
{
	local Rx_TeamInfo GDITeam, NodTeam; 
	local byte WinningTeam;

	if(TimeLimit == 0 || PointsToWinBy <= 0 || bGDIHasSurrendered || bNodHasSurrendered)
		return; 

	GDITeam = Rx_TeamInfo(Teams[TEAM_GDI]); 
	NodTeam = Rx_TeamInfo(Teams[TEAM_NOD]); 

	WinningTeam = GDITeam.GetRenScore() > NodTeam.GetRenScore() ? 0 : 1;
	UpdateTeamWinPct(WinningTeam, abs(GDITeam.GetRenScore() - NodTeam.GetRenScore()) / float(PointsToWinBy));

	//One team is dominating
	if(abs(GDITeam.GetRenScore() - NodTeam.GetRenScore()) >= PointsToWinBy)
	{
		//Check if GDI Dominating
		if(!GDITeam.GetDominating() && GDITeam.GetRenScore() >= NodTeam.GetRenScore()+PointsToWinBy)
		{
			GDITeam.SetDominating(true); 
			NodTeam.SetDominating(false);

			MarqueeBroadcast(0, T_Marquee_Domination[0], 4.0, TwoMinuteWarnSound);
			MarqueeBroadcast(1, T_Marquee_Domination[0], 4.0, TwoMinuteWarnSound);

		}
		else if(!NodTeam.GetDominating() && NodTeam.GetRenScore() >= GDITeam.GetRenScore()+PointsToWinBy)
		{
			NodTeam.SetDominating(true); 
			GDITeam.SetDominating(false);

			MarqueeBroadcast(1, T_Marquee_Domination[1], 4.0, TwoMinuteWarnSound);
			MarqueeBroadcast(0, T_Marquee_Domination[1], 4.0, TwoMinuteWarnSound);
		}
	}
	else 
	{
		if(GDITeam.GetDominating())
		{
			GDITeam.SetDominating(false);
			MarqueeBroadcast(0, T_Marquee_LostDomination[0], 4.0, TwoMinuteWarnSound);
			MarqueeBroadcast(1, T_Marquee_LostDomination[0], 4.0, TwoMinuteWarnSound);
		}	
		
		if(NodTeam.GetDominating())
		{
			NodTeam.SetDominating(false);
			MarqueeBroadcast(0, T_Marquee_LostDomination[1], 4.0, TwoMinuteWarnSound);
			MarqueeBroadcast(1, T_Marquee_LostDomination[1], 4.0, TwoMinuteWarnSound);
		}
	}
}

function bool GetStructuresAutoRevive()
{
	return bStructuresAutoRevive; 
}

function UpdateTeamWinPct(byte WinningTeamByte, float NewPct)
{
	if(Rx_GRI(WorldInfo.GRI) != none)
	{
		Rx_GRI(WorldInfo.GRI).SetWinPct(WinningTeamByte == 0 ? -1.0*NewPct : NewPct); 
	}
}

function BeginMapVote()
{
	RenEndTime = WorldInfo.RealTimeSeconds + float(MapVoteTime);
    bStartRestarting = true;
}

DefaultProperties
{

	MapListManagerClassName="RenX_game.Rx_MapListManager";

	EndgameCamDelay = 1.0f
	EndgameSoundDelay = 1.0f

	bCreditsFromKillScore = true

	UsePurchaseSystem = true;
	bAllowDeployedDefenceKills = true

	buildingArmorPercentage = 50

	bUseSeamlessTravel = true

	MaxPlayerNameLength        = 20

	DisallowedNames[0]          = "---"
	DisallowedNames[1]          = "----"
	DisallowedNames[2]          = "-----"
	DisallowedNames[3]          = "------"
	DisallowedNames[4]          = "-------"
	DisallowedNames[5]          = "--------"
	DisallowedNames[6]          = "Host"

	CountDown				   = 11
	EndGameDelay			   = 45.0
	bMustHaveMultiplePlayers   = false
	bPauseable                 = true
	bUseClassicHUD             = true
	bSpawnInTeamArea		   = true
	bFirstBlood                = true
	Port 				       = 7777

	HudClass                   = class'Rx_HUD'
	VictoryMessageClass        = class'Rx_VictoryMessage'
	DeathMessageClass          = class'Rx_DeathMessage'
	bUndrivenVehicleDamage	   = true
	PlayerControllerClass	   = class'Rx_Controller'
	DefaultPawnClass           = class'Rx_Pawn'
	PlayerReplicationInfoClass = class'Rx_PRI'
	BroadcastHandlerClass      = class'Rx_BroadcastHandler'
	AccessControlClass         = class'Rx_AccessControl'
	TeamInfoClass			   = class'Rx_TeamInfo'

	GameReplicationInfoClass   = class'Rx_GRI'
	PurchaseSystemClass        = class'Rx_PurchaseSystem'
	HelipadPurchaseSystemClass = class'Rx_HelipadPurchaseSystem'
	VehicleManagerClass        = class'Rx_VehicleManager'
	HelipadVehicleManagerClass = class'Rx_HelipadVehicleManager'
	CommanderControllerClass   = class'Rx_CommanderController'
	FPSMonitorClass            = class'Rx_FPSMonitor'

	PlayerMonitorClass		   = class'Rx_PlayerMonitor'

	BoinkSound				   = SoundCue'RX_SoundEffects.SFX.SC_Boink'

	MapPrefixes.Empty
	MapPrefixes.Add("CNC")
	Acronym						= "RxGame"

	NumBots						= 0
	NumPlayers					= 0
	bPlayersVsBots				= false
	MineLimit					= 30

	/** class setup props */
	BotClass                      = class'RenX_Game.Rx_Bot_Waypoints'

	TeamAIType(0)                 = class'Rx_TeamAI'
	TeamAIType(1)                 = class'Rx_TeamAI'

	/** DefaultInventory */
	DefaultInventory(0)           = class'Rx_Weapon_AutoRifle_GDI'

	bDelayedStart=true
	bSkipPlaySound=true

	MaxPlayersAllowed			  = 64

	MapHistoryMax                 = 10
	VotePersonalCooldown          = 60
	VoteTeamCoolDown_GDI		  = 180
	VoteTeamCoolDown_Nod		  = 180

	//SurrenderDisabledTime		= 600
	RTC_DisableTime				= 0
	RTC_TimeLimit				= 20

	MaxVetRank = 9 //Starts at 0
	//VPMilestones(0) = 80 //VP needed for Veteran
	//VPMilestones(1) = 200 //VP Needed for Elite
	//VPMilestones(2) = 600 //VP Needed for Heroic

	VPMilestones(0) = 30 //VP needed for Recruit I
	VPMilestones(1) = 60 //VP needed for Recruit II
	VPMilestones(2) = 100 //VP needed for Veteran
	VPMilestones(3) = 150 //VP Needed for Veteran I
	VPMilestones(4) = 200 //VP Needed for Veteran II
	VPMilestones(5) = 250 //VP Needed for Elite
	VPMilestones(6) = 400 //VP Needed for Elite I
	VPMilestones(7) = 550 //VP Needed for Elite II
	VPMilestones(8) = 700 //VP Needed for Heroic

	GameType = 1 // 1 = Rx_Game

	PowerUpClasses.Add(class'Rx_Pickup_Ammo');
	MaxInitialVeterancy = 400
	CurrentBuildingVPModifier[0] = 1.0
	CurrentBuildingVPModifier[1] = 1.0

	MaxBuildingVPMod = 5.0
	CreditTickRate = 1.0
	CP_TickRate	   = 1.0

	CPReward_Emplacement= 50
	CPReward_Infantry	= 10
	CPReward_Vehicle	= 10

	bGameAboutToEnd=false
	AutoKickAFKCheckInterval = 15.0 // Check to kick AFKs every 15 seconds if enabled.
	BountyWarnSound = SoundCue'RX_WP_IonCannon.Sounds.SC_StrikImminent_Siren';
	OverTimeStartSound[0] = SoundCue'rx_interfacesound.OverTime.SC_OverTime_Start_GDI'
	OverTimeStartSound[1] = SoundCue'rx_interfacesound.OverTime.SC_OverTime_Start_Nod'
	SuddenDeathStartSound = SoundCue'rx_interfacesound.OverTime.SN_SuddenDeath_Start_Cue'
	TwoMinuteWarnSound = SoundCue'rx_interfacesound.OverTime.SC_2MinuteWarn'

	T_Marquee_OT = Texture2D'RenxHUD.Cards.T_OTMessage'
	T_Marquee_SD = Texture2D'RenxHUD.Cards.T_SDMessage'
	T_Marquee_2MW = Texture2D'RenxHUD.Cards.T_OTMessage_2MinuteWarn'
	T_Marquee_5MW = Texture2D'RenxHUD.Cards.T_OT_5MinWarn'
	T_Marquee_AOW = Texture2D'RenxHUD.Cards.T_Card_GM_AOW'
	T_Marquee_Marathon = Texture2D'RenxHUD.Cards.T_Card_GM_Marathon'
	T_Marquee_Domination(0) = Texture2D'RenxHUD.Cards.T_Card_GDIDom'
	T_Marquee_Domination(1) = Texture2D'RenxHUD.Cards.T_Card_NodDom'
	T_Marquee_LostDomination(0) = Texture2D'RenxHUD.Cards.T_Card_GDIDomLost'
	T_Marquee_LostDomination(1) = Texture2D'RenxHUD.Cards.T_Card_NodDomLost'
}
