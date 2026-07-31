class Rx_Hud_PT_Center_Button extends Rx_Hud_Button;

//Colors
var Color gdiTextColor;
var Color nodTextColor;
var Color selectedColor;
var Color disabledColor;

function Draw()
{
    local int Hover,Clicked,Selected,Inactive;

    switch (currentButtonState)
    {
        case EButtonState.Selected:
            Hover=0;
            Clicked=0;
            Selected=1;
            Inactive=0;
        	break;
        case EButtonState.Hover:
            Hover=1;
            Clicked=0;
            Selected=0;
            Inactive=0;
        	break;
        case EButtonState.Click:
            Hover=0;
            Clicked=1;
            Selected=0;
            Inactive=0;
        	break;
        case EButtonState.Inactive:
            Hover=0;
            Clicked=0;
            Selected=0;
            Inactive=1;
        	break;
        case EButtonState.Error:
            Hover=0;
            Clicked=0;
            Selected=0;
            Inactive=0;
        	break;
        case EButtonState.Idle:
            Hover=0;
            Clicked=0;
            Selected=0;
            Inactive=0;
        	break;
    }

    if(ButtonBackgroundInstance!=none){
        ButtonBackgroundInstance.SetScalarParameterValue('TeamNum', Rx_Controller(RenXHud.Owner).GetTeamNum());
        ButtonBackgroundInstance.SetScalarParameterValue('Hover', Clicked);
        ButtonBackgroundInstance.SetScalarParameterValue('Hover', Hover);
        ButtonBackgroundInstance.SetScalarParameterValue('Selected', Selected);
        ButtonBackgroundInstance.SetScalarParameterValue('Disabled', Inactive);
    }

    drawButtonBackground();
    drawButtonText();
    buttonWidth=buttonBackgroundWidth*ResScaleY;
    buttonHeight=buttonBackgroundHeight*ResScaleY;

    if(currentButtonState==EButtonState.Click){
         currentResetFrames++;

        if(clickResetDelayFrames <= currentResetFrames)
        {
            clickReset();   
        }
    }
}

function drawButtonBackground()
{
    local float buttonPositionX,buttonPositionY;
    // Button background
    buttonPositionX=(positionX);
    buttonPositionY=(positionY);

    if(bCenteredDraw){
        RenXHUD.Canvas.SetPos(buttonPositionX-((buttonBackgroundWidth*ResScaleY)/2), buttonPositionY-((buttonBackgroundHeight*ResScaleY)/2));
    }else
    {
        RenXHUD.Canvas.SetPos(buttonPositionX, buttonPositionY);
    }

    if(bBackgroundAngled)
    {
        RenXHud.Canvas.DrawRotatedMaterialTile(ButtonBackgroundInstance,backgroundRotation, buttonBackgroundWidth*ResScaleY, buttonBackgroundHeight*ResScaleY);
    }else
    {
        RenXHud.Canvas.DrawMaterialTile(ButtonBackgroundInstance, buttonBackgroundWidth*ResScaleY, buttonBackgroundHeight*ResScaleY,,,,,true);
    }
}

function drawButtonText()
{
    local vector2D textPosition;
    textPosition.x = positionX+(buttonTextOffsetX*ResScaleY);        
    textPosition.y = positionY+(buttonTextOffsetY*ResScaleY);
    DrawAlignedText(currentButtonText,textPosition,currentDropShadow,Alpha,TextScaleX*ResScaleY,textScaleY*ResScaleY,EHorizontalAlignment.AlignCenter,EVerticalAlignment.AlignMiddle,true);
    DrawAlignedText(currentButtonText,textPosition,currentColor,Alpha,TextScaleX*ResScaleY,textScaleY*ResScaleY,EHorizontalAlignment.AlignCenter,EVerticalAlignment.AlignMiddle,false);
}

function updateButtonText()
{
    switch (currentButtonState)
	{
	    case EButtonState.Idle:
            currentButtonText=buttonTextIdle;
            currentColor=Rx_Controller(RenXHud.Owner).GetTeamNum()==0?gdiTextColor:nodTextColor;
	    	break;
	    case EButtonState.Click:
            currentButtonText=buttonTextClick;
	    	break;
	    case EButtonState.Hover:
            currentButtonText=buttonTextHover;
            currentColor=Rx_Controller(RenXHud.Owner).GetTeamNum()==0?gdiTextColor:nodTextColor;
	    	break;
        case EButtonState.Selected:
            currentButtonText=buttonTextSelected;
            currentColor=selectedColor;
            break;
        case EButtonState.Inactive:
            currentButtonText=buttonTextInactive;
            currentColor=disabledColor;
        	break;         
	}
}

DefaultProperties
{
    ButtonBackgroundConstant = MaterialInstanceConstant'RX_HUD_Canvas.pt_menu.MI_PT_CenterButton'

    buttonBackgroundWidth=545
    buttonBackgroundHeight=86   

    gdiTextColor=(R=254,G=212,B=64,A=255)
    nodTextColor=(R=255,G=1,B=1,A=255)
    selectedColor=(R=1,G=255,B=1,A=255)
    disabledColor=(R=205,G=205,B=205,A=255)
}
