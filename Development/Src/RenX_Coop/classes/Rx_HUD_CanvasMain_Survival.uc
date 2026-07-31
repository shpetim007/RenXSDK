/** Canvas extension for Survival's wave-specific game information. */
class Rx_HUD_CanvasMain_Survival extends Rx_HUD_CanvasMain;

function Draw()
{
	local Rx_GRI_Survival GRI;
	local string WaveInfo;
	local float S;

	Super.Draw();
	if(Canvas == None || RenxHud == None || bShowOverview || bShowFullScoreboard)
		return;

	GRI = Rx_GRI_Survival(RenxHud.WorldInfo.GRI);
	if(GRI == None)
		return;

	S = GetScale();
	if(GRI.TimeUntilNextWave > 0)
		WaveInfo = "NEXT WAVE  " $ int(GRI.TimeUntilNextWave);
	else
		WaveInfo = "WAVE  " $ GRI.WaveNumber;

	DrawTextAt(WaveInfo, Canvas.SizeX*0.5, 68*S, NeutralColor, 0.6*S, 1);
}

