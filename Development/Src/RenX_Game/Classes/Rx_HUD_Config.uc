/**
 * Client-side selection for the in-game HUD implementation.
 *
 * Values are loaded from UDKGame/Config/UDKRenegadeX.ini, whose defaults are
 * distributed through UDKGame/Config/DefaultRenegadeX.ini.
 */
class Rx_HUD_Config extends Object
	config(RenegadeX);

var config bool bUseCanvasHUD;
