class Rx_HUD_Cursor extends Rx_Hud_Component;

//MIC
var MaterialInstanceConstant CursorMaterial,CursorInstance;

var float cursorSizeX,cursorSizeY;
var float xOffset,yOffset;
function Draw()
{
    if(!bEnabled || hiddenByPlayer)
        return;
    if(CursorInstance==none){
        CursorInstance= new(Outer)  class'MaterialInstanceConstant';
        CursorInstance.SetParent(CursorMaterial);
    }
    //Draw Cursor
    RenXHUD.Canvas.SetPos(MousePosition.X+(xOffset*ResScaleY), MousePosition.Y+(yOffset*ResScaleY));
    RenxHud.Canvas.DrawMaterialTile(CursorInstance, cursorSizeX * ResScaleX, cursorSizeY * ResScaleY); 
}


function Update(float DeltaTime, Rx_HUD HUD)
{
    if(!bEnabled || hiddenByPlayer)
        return;
    super.Update(DeltaTime,HUD);
	UpdateResolutionScaleLimited(HUD);
}

DefaultProperties
{
    CursorMaterial = MaterialInstanceConstant'Rx_HUD_Canvas.pt_menu.MI_Menu_Cursor'
    cursorSizeX = 69
    cursorSizeY = 138
    XOffset=-28;
    YOffset=-15;
    bEnabled=false;
    hiddenByPlayer=false
}