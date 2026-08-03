class Rx_Game_MainMenu extends Rx_Game;

var config String MainMenuMovieClass;
var Rx_GFxFrontEnd MainMenuMovie; // retained for config compatibility; no longer started

event InitGame( string Options, out string ErrorMessage )
{
	super.InitGame(Options, ErrorMessage);

	LANBroadcast.start(false);
}

function StartMatch()
{
	local Rx_Controller PC;

	PC = Rx_Controller(GetALocalPlayerController());
	if(PC != None && PC.myHUD != none)
	{
		Rx_HUD(PC.myHUD).bShowHUD = true;
		if(Rx_HUD(PC.myHUD).CanvasFrontEnd == none)
			Rx_HUD(PC.myHUD).CanvasFrontEnd = new class'Rx_HUD_CanvasFrontEnd';
		Rx_HUD(PC.myHUD).SetInputCursorActiveNoDelay(true);
	}
}

DefaultProperties
{
	//bQuickStart = true;
	GameType = 0 // 0 = Rx_Game_MainMenu
}
