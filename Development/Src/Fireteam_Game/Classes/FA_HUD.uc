class FA_HUD extends TS_HUD;

event PostRender() 
{
	local Rx_Controller PC;

	PC = Rx_Controller(PlayerOwner);

	super.PostRender();

	if (PC == None) return;

	if (PC.IsInState('OutOfTickets'))
	{
		Canvas.SetPos(Canvas.ClipX * 0.5,Canvas.ClipY * 0.5);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawText("Out of tickets :(");
	}
}

DefaultProperties
{
	GIHudMovieClass = class'FA_GFxGameinfoHud'
}