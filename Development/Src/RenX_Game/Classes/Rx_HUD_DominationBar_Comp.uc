class Rx_HUD_DominationBar_Comp extends Rx_HUD_Component ; 

var float WinningTeam; //0 = GDI 1=Nod. 0.5 is nobody
var float WinningTeamPct; 
var MaterialInstanceConstant BarMIC, InstancedMIC;
var vector2d BarPosition; 
var float ScreenPositionY, XSize, ScreenPositionX; 

function Update(float DeltaTime, Rx_HUD HUD) 
{
    if(InstancedMIC == none)
        SetupMICS(); 
    
	super.Update(DeltaTime, HUD);
}

function UpdateWinningTeam(float NewWinner)
{
    if(InstancedMIC !=none)
    {
        InstancedMIC.SetScalarParameterValue('WinningTeam', NewWinner);
    }
}

function UpdateWinningPercent(float NewPct)
{
    if(InstancedMIC !=none)
    {
        InstancedMIC.SetScalarParameterValue('WinningPct', NewPct);
    }
}

function SetupMICs()
{
    InstancedMIC = new(Outer) class'MaterialInstanceConstant';
    InstancedMIC.SetParent(BarMIC); 
    InstancedMIC.SetScalarParameterValue('WinningPct', 0);
    InstancedMIC.SetScalarParameterValue('WinningTeam', 0);
}

function bool GetIsUltraWide()
{
    return (RenxHUD.SizeX / RenxHUD.SizeY) > AspectRatio16x9*1.1;  
}

function Draw() {
    local float PosX, PosY; 
    local float ResY, ResX;

    if(RenxHud == none || Rx_GRI(RenxHud.PlayerOwner.WorldInfo.GRI).TimeStatus == "Marathon" )
        return; 

    if(InstancedMIC != none)
    {
        //ResX = RenxHUD.SizeX / 1280.0;
        ResY = RenxHUD.SizeY / 720.0;
        ResX = RenxHUD.SizeX / 1280.0;

        PosX = (ScreenPositionX * ResX) - (XSize*0.5*ResX);
        PosY = (ScreenPositionY + (GetIsUltraWide() ? -12 : 0)) * ResY; 

        RenXHud.Canvas.SetPos(PosX, PosY);
        //RenXHud.Canvas.DrawMaterialTile(Marquees[0].CardMIC, 1000, 148,1.0,1.0,1.0,1.0);
        RenXHud.Canvas.DrawMaterialTile(InstancedMIC, XSize*ResX, 16*ResY,,,1.0,1.0);
    }
}

DefaultProperties
{
    BarMIC = MaterialInstanceConstant'RenxHUD.MIC_AOW_DomBar'
    ScreenPositionY = 670
    ScreenPositionX = 638
    XSize = 384.0
}