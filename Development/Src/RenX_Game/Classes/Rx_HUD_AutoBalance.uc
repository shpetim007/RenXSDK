class Rx_HUD_AutoBalance extends Rx_Hud_Component;

var Rx_GRI GameReplicationInfo;
var float basePositionXPercentage,basePositionYPercentage;
var float textSize;
var float lineSpacingY;
//var float timerEnd;
var bool bBalancingCompleted;
var bool bCancelationNotified;
var float rewardAmount;
var string Team0Name, Team1Name;

var font DrawFont;

function Update(float DeltaTime, Rx_HUD HUD)
{
    if(!bEnabled || hiddenByPlayer)
        return;
    super.Update(DeltaTime,HUD);
    // Base our scale on 1080p, that means we design the look in 1080p and then it scales up properly
    ResScaleX = RenxHud.Canvas.SizeX / 1920.0;
    ResScaleY = RenxHud.Canvas.SizeY / 1080.0;

    if (Team0Name == "" || Team1Name == "")
    {
        Team0Name = Rx_TeamInfo(RenXHud.WorldInfo.GRI.Teams[0]).GetTeamName();
        Team1Name = Rx_TeamInfo(RenXHud.WorldInfo.GRI.Teams[1]).GetTeamName();
    }
}

function Draw()
{
    local Vector2D textPosition;
    local int bonus;
    if(!bEnabled || hiddenByPlayer)
        return;

    GameReplicationInfo=Rx_GRI(RenxHud.WorldInfo.GRI);
    if(GameReplicationInfo.bAutobalanceInProgress)
    {
        rewardAmount = GameReplicationInfo.BalanceReward;
        bBalancingCompleted=false;
        textPosition.X=RenxHud.Canvas.SizeX*BasePositionXPercentage;
        textPosition.Y=RenxHud.Canvas.SizeY*basePositionYPercentage;
        if(!GameReplicationInfo.bAutoBalanceForced)
        {
            DrawAutoBalanceText("Auto balancing volunteers only",textPosition,C_Neu);
        }
        else
        {
            DrawAutoBalanceText("Auto balancing on death",textPosition,C_Neu);
        }
        textPosition.Y+=lineSpacingY*ResScaleY;
        
        if(GameReplicationInfo.TeamNeedingPlayers == TEAM_GDI)
        {
            DrawAutoBalanceText(Team0Name@"needs players!",textPosition,C_GDI);
        }
        else
        {
            DrawAutoBalanceText(Team1Name@"needs players!",textPosition,C_Nod);
        }

        textPosition.Y+=lineSpacingY*ResScaleY;
        if(GameReplicationInfo.TeamNeedingPlayers != RenxHUD.PlayerOwner.GetTeamNum()){
            DrawAutoBalanceText(UDKPlayerInput(RenXHud.PlayerOwner.PlayerInput).GetUDKBindNameFromCommand("VolunteerPress") @ " to volunteer",textPosition,C_Neu);

            textPosition.Y+=lineSpacingY*ResScaleY;
            bonus=rewardAmount;
            if(Rx_GRI(RenxHud.WorldInfo.GRI).bAutoBalanceVpRewardEnabled)
            {
                DrawAutoBalanceText("Bonus:" @ bonus @ " VP",textPosition,C_Neu);
            }
            else
            {
                DrawAutoBalanceText("Bonus:" @ bonus @ " credits",textPosition,C_Neu);
            }
        }else
        {
            DrawAutoBalanceText("Looking for volunteers...",textPosition,C_Neu);
        }
    }
    else
    {
        //temp = `AUTO_BALANCE_TIME;
        //timerEnd = RenxHud.WorldInfo.TimeSeconds+temp;
    }

    if(GameReplicationInfo.bBalanceAchieved && !bBalancingCompleted && !GameReplicationInfo.bBalanceCancelled)
    {
        Rx_Controller(RenxHUD.PlayerOwner).CTextMessage("Balancing Complete"); 
        bBalancingCompleted=true;
    }else if(!bBalancingCompleted && GameReplicationInfo.bBalanceCancelled)
    {
        Rx_Controller(RenxHUD.PlayerOwner).CTextMessage("Balancing Cancelled"); 
        bBalancingCompleted=true;
    }
}

function DrawAutoBalanceText(string text,Vector2D Position,color textColor)
{
    local Vector2D RenderPosition;
    local float TextWidth, TextHeight;
    local float ScaleX,ScaleY;

    ScaleX=textSize*ResScaleY;
    ScaleY=textSize*ResScaleY;

	RenderPosition = Position;
    
    Canvas.Font = DrawFont;

	Canvas.TextSize(text, TextWidth, TextHeight,ScaleX,ScaleY);
	// Handle the horizontal alignment
    RenderPosition.X -= (TextWidth * 0.5f);
	// Handle the vertical alignment
    RenderPosition.Y -= (TextHeight * 0.5f);

    // Set the canvas position
    Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
    
    // Set the text color
    Canvas.SetDrawColor(textColor.R, textColor.G, textColor.B, 255);
	// Render the text
    Canvas.DrawText(text, false, ScaleX, ScaleY);

    //Reset the draw color
	Canvas.SetDrawColor(255, 255, 255, 255);
}

function Init(Rx_HUD HUD)
{
}

defaultproperties
{
    basePositionXPercentage=0.5
    basePositionYPercentage=0.13
    textSize=1
    lineSpacingY=35;

    //Colors for Factions
    C_Neu = (R=88,G=214,B=217,A=255)
    C_GDI = (R=255,G=236,B=105,A=255)
    C_Nod = (R=255,G=51,B=0,A=255)
    bEnabled=true
    DrawFont=Font'RenxHUD.Font.AgentConDB'
}
