class Rx_Game_MainMenu extends Rx_Game;

var config String MainMenuMovieClass;
var Rx_GFxFrontEnd MainMenuMovie;

event InitGame( string Options, out string ErrorMessage )
{
	super.InitGame(Options, ErrorMessage);

	LANBroadcast.start(false);
}

function StartMatch()
{
	local Rx_Controller PC;
	local class<Rx_GFxFrontEnd> MovieClass;

	PC = Rx_Controller(GetALocalPlayerController());
	MovieClass = class<Rx_GFxFrontEnd>(DynamicLoadObject(MainMenuMovieClass,class'Class'));

	if(MainMenuMovie != None)
		return;

	if(PC != None && MovieClass != None && PC.myHUD != none)
	{
		Rx_HUD(PC.myHUD).bShowHUD = false;
		MainMenuMovie = new(PC) MovieClass;
		MainMenuMovie.SetTimingMode(TM_Real);
		MainMenuMovie.Start();

	}
}

DefaultProperties
{
	//bQuickStart = true;
	GameType = 0 // 0 = Rx_Game_MainMenu
}
