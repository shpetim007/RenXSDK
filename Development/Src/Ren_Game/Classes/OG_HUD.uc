class OG_HUD extends Rx_HUD;

// Remove hit indicator
function ShowHitMarker(optional bool bHeadShot = false){}	

DefaultProperties
{
	TargetingBoxClass = class'OG_Hud_TargetingBox'
	PlayerNamesClass = class'OG_Hud_PlayerNames'
	HudMovieClass = class'OG_GFxHud'
}