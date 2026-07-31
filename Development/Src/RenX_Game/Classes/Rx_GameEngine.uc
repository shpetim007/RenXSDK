class Rx_GameEngine extends GameEngine;

`include(Engine\Classes\HttpStatusCodes.uci)

// Networking
var Rx_TCPLink_DLLBind DllCore;
var Rx_UDPLink_DLLBind UDPDllCore;

// Discord
var Discord_DLLBind DiscordDll;

// Epic Online Services (EOS)
//var Rx_EOSUDK_DLLBind EOSUDKDLL;
//var Rx_EOSUDK EOSUDK;

// RCON
var Rx_Rcon Rcon;
var private Rx_Rcon_Out RconOut;
var private Rx_Rcon_Out_Tasci RconOutTasci;
var private Rx_Rcon_Commands_Container RconCommands;

// Team management
struct PlayerAccount
{
	var string	PlayersID; /*Added an S just so it doesn't overlap PRI's PlayerID for my own sanity */
	var float		PlayerAggregateScore; // based on Playerscore/VP/Kills-Deaths
};

var array<PlayerAccount> GDIPlayers;
var array<PlayerAccount> NodPlayers;
var string				 StaticCommanderID[2];

// Package management
var Rx_PackageManager PackageManager;
var Rx_PackageDownloader PackageDownloader;

// HWID
var privatewrite string HWID;

struct ByteArrayWrapper {
	var array<byte> array;
};

var bool ContactedSessionServer, AttemptedContact;
var float SessionServerContactInterval, SavedContactTime;

/** Initialization */


final function Initialize()
{
	`log("Initializing Rx_GameEngine. Game Version: " $ `RxGameObject.GameVersion);
	
	if (DllCore == None)
		DllCore = new class'Rx_TCPLink_DLLBind';

	if (UDPDllCore == None)
		UDPDllCore = new class'Rx_UDPLink_DLLBind';

	if (DiscordDll == None)
	{
	  	DiscordDll = new class'Discord_DLLBind';

	  	InitDiscordRPC();
	}

	SetToken();

	/*if (PackageManager == None)
	{
		PackageManager = new class'Rx_PackageManager';
		PackageManager.Initialize();
	}

	if (PackageDownloader == None)
	{
		PackageDownloader = new class'Rx_PackageDownloader';
		PackageDownloader.Initialize();
	}*/

	if (RconCommands == None)
	{
		RconCommands = new class'Rx_Rcon_Commands_Container';
		RconCommands.InitRconCommands();
	}

	if (!ContactedSessionServer && class'WorldInfo'.static.GetWorldInfo().NetMode != NM_DedicatedServer)
	{
		InitSessionServer();
	}
}

final function InitEOS()
{
	/*if(EOSUDKDLL == None)
	{
		EOSUDKDLL = new class'Rx_EOSUDK_DLLBind';
		if(EOSUDKDLL != None)
			`log("EOS Bound",true);

		if(EOSUDK == None)
			EOSUDK = new class'Rx_EOSUDK';
	}
		
	if(!EOSUDK.isInit() && EOSUDK != None)
	{
		
		`log("EOS INIT: "@EOSUDK.InitEOS());
		// Should EOS host the VOIP (server) or login to the server
		if( GetCurrentWorldInfo().NetMode == NM_DedicatedServer)
		{
			`RxEngineObject.EOSUDKDLL.createPlatform(1,HWID);
			`RxEngineObject.EOSUDKDLL.platformTick();
			`RxEngineObject.EOSUDKDLL.createAntiCheatServer();
		}
		else
		{
			`RxEngineObject.EOSUDKDLL.createPlatform(0,HWID);
			`RxEngineObject.EOSUDKDLL.platformTick();
			`RxEngineObject.EOSUDKDLL.createAntiCheatClient();
		}
	}*/
}

private final function InitSessionServer()
{
	local HttpRequestInterface HTTPRequest;
	local JsonObject Payload;
	local string PayloadString;

	Payload = new class'JsonObject';
	Payload.SetStringValue("hwid", HWID);
	PayloadString = class'JsonObject'.static.EncodeJson(Payload);

	`log("Contacting session API",, 'Session API');

	HTTPRequest = class'HttpFactory'.static.CreateRequest();
	HTTPRequest.SetURL("http://rx-session.totemarts.services");
	HTTPRequest.SetVerb("PUT");
	HTTPRequest.SetContentAsString(PayloadString);
	HTTPRequest.OnProcessRequestComplete = OnComplete;
	HTTPRequest.ProcessRequest();
}

function OnComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface InHttpResponse, bool bDidSucceed)
{
	AttemptedContact = true;

	if (InHttpResponse == None)
	{
		// Just stop since we can't even get a response
		ContactedSessionServer = true;
	}

	if (!bDidSucceed)
	{
		`log("Get failed. Error code:" @ InHttpResponse.GetResponseCode(),, 'Session API');
		return;
	}

	if (InHttpResponse != None && InHttpResponse.GetResponseCode() == `HTTP_STATUS_OK)
	{
		`log("Get succeeded.",, 'Session API');
		ContactedSessionServer = true;
	}
}

private final function InitDiscordRPC()
{

}

private final function SetToken()
{
	local ByteArrayWrapper token;
	local byte token_byte;

	if (HWID == "")
	{
		DllCore.c_token(token);

		foreach token.array(token_byte)
		{
			HWID $= Chr(token_byte);
		}
	}
}

/** Team management */

function TeamInfo GetInitialTeam(PlayerReplicationInfo PRI)
{
	local string ID;
	local PlayerAccount TempPlayerAccount;
	local int index, gdi_size, nod_size;
	local TeamInfo Teams[2];

	ID = `WorldInfoObject.Game.OnlineSub.UniqueNetIdToString(PRI.UniqueId);
	Teams[0] = `RxGameObject.Teams[TEAM_GDI];
	Teams[1] = `RxGameObject.Teams[TEAM_NOD];
	if (ID == `BlankSteamID || ID == "")
		ID = PRI.PlayerName;

	// Check if they're assigned to GDI
	index = GDIPlayers.Find('PlayersID',ID);
	if (index >= 0)
	{
//		Rx_Pri(PRI).OldRenScore = GDIPlayers[index].PlayerAggregateScore;
		return Teams[TEAM_GDI];
	}

	// Check if they're assigned to Nod
	index = NodPlayers.Find('PlayersID',ID);
	if (index >= 0)
	{
//		Rx_Pri(PRI).OldRenScore = NodPlayers[index].PlayerAggregateScore;
		return Teams[TEAM_NOD];
	}

	//Build a player account for them
	TempPlayerAccount.PlayersID = ID;

	// New player; figure out which team they need to be on

	if (GDIPlayers.Length == NodPlayers.Length)
	{
		gdi_size = Rx_TeamInfo(Teams[TEAM_GDI]).PlayerSize;
		nod_size = Rx_TeamInfo(Teams[TEAM_NOD]).PlayerSize;

		if (PRI.Team == `RxGameObject.Teams[TEAM_GDI])
			gdi_size -= 1;
		else if (PRI.Team == `RxGameObject.Teams[TEAM_NOD])
			nod_size -= 1;

		if (gdi_size > nod_size)
			return Teams[TEAM_NOD];

		if (nod_size > gdi_size)
			return Teams[TEAM_GDI];

		return Teams[Rand(2)];
	}

	if (GDIPlayers.Length > NodPlayers.Length)
	{
		NodPlayers.AddItem(TempPlayerAccount);
		return Teams[TEAM_NOD];
	}

	GDIPlayers.AddItem(TempPlayerAccount);
	return Teams[TEAM_GDI];
}

function ClearTeams()
{
	GDIPlayers.Length = 0;
	NodPlayers.Length = 0;
}

function AddGDIPlayer(PlayerReplicationInfo PRI)
{
	local string ID;
	local PlayerAccount TempPlayerAccount;

	ID = `WorldInfoObject.Game.OnlineSub.UniqueNetIdToString(PRI.UniqueId);
	if (ID == `BlankSteamID || ID == "")
		ID = PRI.PlayerName;

	TempPlayerAccount.PlayersID = ID;
	TempPlayerAccount.PlayerAggregateScore = Rx_Pri(PRI).OldRenScore;

	GDIPlayers.AddItem(TempPlayerAccount);
}

function AddNodPlayer(PlayerReplicationInfo PRI)
{
	local string ID;
	local PlayerAccount TempPlayerAccount;

	ID = `WorldInfoObject.Game.OnlineSub.UniqueNetIdToString(PRI.UniqueId);
	if (ID == `BlankSteamID || ID == "")
		ID = PRI.PlayerName;

	TempPlayerAccount.PlayersID = ID;
	TempPlayerAccount.PlayerAggregateScore = Rx_Pri(PRI).OldRenScore;

	NodPlayers.AddItem(TempPlayerAccount);
}

/** RCON */

final function init_rcon()
{
	local Rx_Rcon_Out_Tasci TmpOutTasci;

	if (RconOut == None && `RxGameObject.bListed && `RxGameObject.GameVersion != "EDITOR-DEV")
	{
		RconOut = new class'Rx_Rcon_Out';
		RconOut.connect();
	}

	if (RconOutTasci == None && `RxGameObject.bListed)
	{
		TmpOutTasci = new class'Rx_Rcon_Out_Tasci';
		// Looks like it's not possible to access a configuration variable
		// without creating an instance of a class (doesn't work in static methods).
		// Use this little workaround.
		if (TmpOutTasci.IsEnabled()) {
			RconOutTasci = TmpOutTasci;
			RconOutTasci.connect();
		}
	}

	if (Rcon == None)
	{
		Rcon = new class'Rx_Rcon';

		if (Rcon.bEnableRcon)
			Rcon.InitRcon();
		else
			Rcon = None;
	}
}

final function RconOutLog(string txt)
{
	if (RconOut != None)
		RconOut.SendLog(txt);

	if (RconOutTasci != None)
		RconOutTasci.SendLog(txt);
}

final function RconLog(string txt)
{
	if (RconOut != None)
		RconOut.SendLog(txt);

	if (RconOutTasci != None)
		RconOutTasci.SendLog(txt);

	if (Rcon != None)
		Rcon.SendLog(txt);
}

final function RconLogPub(string txt)
{
	if (RconOut != None)
		RconOut.SendLog(txt);

	if (RconOutTasci != None)
		RconOutTasci.SendLog(txt);

	if (Rcon != None && `RxGameObject.bIsCompetitive == false)
		Rcon.SendLog(txt);
}

final function RxTick(float DeltaTime)
{
	if (PackageManager != None)
		PackageManager.Tick(DeltaTime);

	if (PackageDownloader != None)
		PackageDownloader.Tick(DeltaTime);

	if (RconOut != None)
		RconOut.Tick(DeltaTime);

	if (RconOutTasci != None)
		RconOutTasci.Tick(DeltaTime);

	if (Rcon != None)
		Rcon.Tick(DeltaTime);

	if (!ContactedSessionServer && AttemptedContact)
	{
		SavedContactTime += DeltaTime;

		if (SavedContactTime >= SessionServerContactInterval)
		{
			SavedContactTime = 0;
			InitSessionServer();
		}
	}
	
}

final function ReconnectDevBot(Rx_Controller PC)
{
	if (PC.bIsDev)
	{
		RconOut.Close();
		RconOut.connect();

		if (RconOutTasci != none) {
			RconOutTasci.Close();
			RconOutTasci.connect();
		}
	}
}

final function OnGameover()
{
	RconOut.HaltResolve();
	if (RconOutTasci != none) {
		RconOutTasci.HaltResolve();
	}
}

/** RCON Commands */

final function string RconCommand(string CommandLine)
{
	local string command, parameters;
	local Rx_Rcon_Command cmd;
	//local string feedback;
	//local Rx_Mutator mut;

	if (InStr(CommandLine," ") >= 0)
	{
		command = Left(CommandLine,InStr(CommandLine," "));
		parameters = Split(CommandLine," ",true);
	}
	else
	{
		command = CommandLine;
		parameters = "";
	}
	command = Locs(command);

	// Check dynamic command list
	cmd = RconCommands.GetCommand(command);
	if (cmd != None)
		return cmd.trigger(parameters);

	// existing UDK/UT commands to block:
	if (RconCommands.IsBlockedCommand(command))
		return "Blocked ConsoleCommand";

	// Not a Rcon implemented command, try as ConsoleCommand.
	GetCurrentWorldInfo().Game.ConsoleCommand(CommandLine);
	return "Non-existent RconCommand - executed as ConsoleCommand";
}

final function bool HasRconCommand(string trigger)
{
	return RconCommands.GetCommand(trigger) != None;
}

final function string GetRconCommandsString()
{
	local string result;
	local Rx_Rcon_Command cmd;

	foreach RconCommands.RconCommands(cmd)
		if (cmd.getTriggerCount() != 0)
			result $= `rcon_delim $ cmd.getTrigger(0);

	return result;
}

final function string GetRconCommandHelpString(string trigger, string parameters)
{
	return RconCommands.GetCommand(trigger).getHelp(parameters);
}

final function AddRCONCommand(class<Rx_Rcon_Command> Command)
{
	RconCommands.SpawnCommand(Command);
}

function SetStaticCommanderID(byte TeamByte, Rx_PRI PRI)
{
	local string ID;

	//`log("Set Commander ID: " @ TeamByte @ PRI.PlayerName);

	if(TeamByte > 1) return;

	ID = `WorldInfoObject.Game.OnlineSub.UniqueNetIdToString(PRI.UniqueId);
	if (ID == `BlankSteamID || ID == "")
		ID = PRI.PlayerName;

	StaticCommanderID[TeamByte] = ID;
}

function ClearStaticCommanderID(byte TeamByte)
{
	if(TeamByte > 1) return;

	StaticCommanderID[TeamByte] = "";
}

function bool IsPlayerCommander(PlayerReplicationInfo PRI)
{
	local string ID;

	ID = `WorldInfoObject.Game.OnlineSub.UniqueNetIdToString(PRI.UniqueId);
	if (ID == `BlankSteamID || ID == "")
		ID = PRI.PlayerName;

	`log("Player:" @ ID @ "CIDs:" @ StaticCommanderID[0] @ StaticCommanderID[1] ) ;
	if(StaticCommanderID[0] == ID || StaticCommanderID[1] == ID) return true;

	return false ;
}

DefaultProperties
{
	ContactedSessionServer = false
	SessionServerContactInterval = 15
}
