class Rx_Hud_Button extends Rx_Hud_Component;

var protected float positionX,positionY;
var protected float buttonWidth,buttonHeight;//to be used for a rectangular button //width and height where button clicks can be detected
var protected float buttonBackgroundWidth,buttonBackgroundHeight;
var protected float buttonTextWidth,buttonTextHeight;
var float buttonTextOffsetX,buttonTextOffsetY;
var MaterialInstanceConstant ButtonBackgroundConstant;
var MaterialInstanceConstant ButtonBackgroundInstance;

var EButtonState returnState;
var EButtonState currentButtonState;
var EButtonFunction buttonType;
var bool buttonToggle; //to be used with Toggle buttons
var string buttonTextIdle,buttonTextHover,buttonTextClick,buttonTextSelected,buttonTextError,buttonTextInactive;
var string currentButtonText;

var protected float textScaleX,textScaleY;
var int clickResetDelayFrames,currentResetFrames;

var Color idleColor,idleDropShadow;
var Color hoverColor,hoverDropShadow;

var Color currentColor,currentDropShadow;

var int ButtonIndex;//use for buttons that select some sort of index

var EButtonOnclickParameter buttonOnclickParameter;

var bool IgnoreScalingForPosition;//Given when scaling is to be done externally
var bool currentlySelected;//Used for selection flow
var bool stickySelection;//When checked selection will stay after the regular flow is done 
var bool stateDisabled; // use if you want to set the button state from the outside
var bool bBackgroundAngled;
var bool bDetectMouseFromText;

var Rotator backgroundRotation;

var bool bDetectClicks;

var bool bBackgroundAlignedTopLeft;

var bool bCenteredDraw;//Draw by taking off half the size from the current position

var float currentClickCooldown;//prevents the button from being spam clicked
var float doubleClickTime;
var float clickCooldown;

var SoundCue HoverSound;
var SoundCue SelectSound;

function Update(float DeltaTime, Rx_HUD HUD)
{
    super.Update(DeltaTime,HUD);
    updateResolutionScale();
    updateButtonText();
    if(!stateDisabled){
        if(checkMouseWithinBoundaries(MousePosition.x,MousePosition.y) && bDetectClicks)
        {
            if(currentButtonState!=EButtonState.Hover && !currentlySelected){
                currentButtonState = EButtonState.Hover;
                Rx_Controller(HUD.Owner).PlaySound(HoverSound,true);
                hoverFunction(ButtonIndex);
            }
        }
        else
        {
            if(currentButtonState==EButtonState.Hover && bDetectClicks)
            {
                hoverLeaveFunction(ButtonIndex);
            }
            if(returnState!=EButtonState.Idle)
            {
                currentButtonState=returnState;
            }
            else{
                currentButtonState = EButtonState.Idle;
            }
            if(currentlySelected){
                currentButtonState = EButtonState.selected;
            }
        }
    }

    if(currentClickCooldown>=0)
    {
        currentClickCooldown-=DeltaTime;
    }
}

function Draw()
{
    local int Hover,Clicked,Selected,Error,Inactive,Locked;
    if(!bEnabled)
    {
        return;
    }

    switch (currentButtonState)
    {
        case EButtonState.Selected:
            Hover=0;
            Clicked=0;
            Selected=1;
            Error=0;
            Inactive=0;
            Locked=0;
        	break;
        case EButtonState.Hover:
            Hover=1;
            Clicked=0;
            Selected=0;
            Error=0;
            Inactive=0;
            Locked=0;
        	break;
        case EButtonState.Click:
            Hover=0;
            Clicked=1;
            Selected=0;
            Error=0;
            Inactive=0;
            Locked=0;
        	break;
        case EButtonState.Inactive:
            Hover=0;
            Clicked=0;
            Selected=0;
            Error=0;
            Inactive=1;
            Locked=0;
        	break;
        case EButtonState.Error:
            Hover=0;
            Clicked=0;
            Selected=0;
            Error=1;
            Inactive=0;
            Locked=0;
        	break;
        case EButtonState.Idle:
            Hover=0;
            Clicked=0;
            Selected=0;
            Error=0;
            Inactive=0;
            Locked=0;
        	break;
        case EButtonState.Locked:
            Hover=0;
            Clicked=0;
            Selected=0;
            Error=0;
            Inactive=0;
            Locked=1;
    }

    if(ButtonBackgroundInstance!=none){
        ButtonBackgroundInstance.SetScalarParameterValue('Hover', Hover);
        ButtonBackgroundInstance.SetScalarParameterValue('Clicked', Clicked);
        ButtonBackgroundInstance.SetScalarParameterValue('Selected', Selected);
        ButtonBackgroundInstance.SetScalarParameterValue('Error', Error);
        ButtonBackgroundInstance.SetScalarParameterValue('Locked', Locked);
        ButtonBackgroundInstance.SetScalarParameterValue('Inactive', Inactive);
    }

    drawButtonBackground();
    drawButtonText();

    if(currentButtonState==EButtonState.Click){
         currentResetFrames++;

        if(clickResetDelayFrames <= currentResetFrames)
        {
            clickReset();   
        }
    }

    if(currentButtonState==EButtonState.Hover){
        RenXHUD.currentTooltip=hudTooltip;
        RenXHUD.currrentTooltipColor=hudTooltipColor;
    }
}

function setButtonOpacity(float opacity)
{
    ButtonBackgroundInstance.SetScalarParameterValue('Opacity', Opacity/255);
    Alpha=opacity;
}

function updateButtonText()
{
    switch (currentButtonState)
	{
	    case EButtonState.Idle:
            currentButtonText=buttonTextIdle;
            currentColor=idleColor;
            currentDropShadow=idleDropShadow;
	    	break;
	    case EButtonState.Click:
            currentButtonText=buttonTextClick;
	    	break;
	    case EButtonState.Hover:
            currentButtonText=buttonTextHover;
            currentColor=hoverColor;
            currentDropShadow=hoverDropShadow;
	    	break;
        case EButtonState.Selected:
            currentButtonText=buttonTextSelected;
            currentColor=hoverColor;
            currentDropShadow=hoverDropShadow;
            break;
        case EButtonState.Inactive:
            currentButtonText=buttonTextInactive;
            currentColor=hoverColor;
            currentDropShadow=hoverDropShadow;
        	break;
        case EButtonState.Error:
            currentButtonText=buttonTextError;
            currentColor=hoverColor;
            currentDropShadow=hoverDropShadow;
        	break;                
	}
}

function setGlobalText(string text)
{
    buttonTextIdle=text;
    buttonTextHover=text;
    buttonTextClick=text;
    buttonTextSelected=text;
    buttonTextInactive=text;
    buttonTextError=text;
}

function Init(Rx_HUD HUD)
{
    if(ButtonBackgroundInstance==none)
    {
        ButtonBackgroundInstance= new(Outer)  class'MaterialInstanceConstant';
        ButtonBackgroundInstance.SetParent(ButtonBackgroundConstant);
    }
}

function drawButtonBackground()
{
    local float buttonPositionX,buttonPositionY;
    // Button background
    buttonPositionX=(positionX);
    buttonPositionY=(positionY);

    if(bCenteredDraw){
        RenXHUD.Canvas.SetPos(buttonPositionX-((buttonBackgroundWidth)/2), buttonPositionY-((buttonBackgroundHeight)/2));
    }else
    {
        RenXHUD.Canvas.SetPos(buttonPositionX, buttonPositionY);
    }

    if(bBackgroundAngled)
    {
        RenXHud.Canvas.DrawRotatedMaterialTile(ButtonBackgroundInstance,backgroundRotation, buttonBackgroundWidth, buttonBackgroundHeight);
    }else
    {
        RenXHud.Canvas.DrawMaterialTile(ButtonBackgroundInstance, buttonBackgroundWidth, buttonBackgroundHeight,,,,,true);
    }
    
}

function drawButtonText()
{
    local vector2D textPosition;
    textPosition.x = positionX+(buttonTextOffsetX*ResScaleY);        
    textPosition.y = positionY+(buttonTextOffsetY*ResScaleY);
    DrawAlignedText(currentButtonText,textPosition,currentDropShadow,Alpha,TextScaleX,textScaleY,EHorizontalAlignment.AlignCenter,EVerticalAlignment.AlignMiddle,true);
    DrawAlignedText(currentButtonText,textPosition,currentColor,Alpha,TextScaleX,textScaleY,EHorizontalAlignment.AlignCenter,EVerticalAlignment.AlignMiddle,false);
}


/*This is a delegate!
This means that when you create an instance of this class
You can assign a function like you would a property
when this function is called it will call the function you assigned instead!

so;

MyCoolBigBoyButton.OnButtonClicked = callMeAnyTime

will make it so that when the MyCoolBigBoyButton's OnButtonClicked function is called
it will instead call the callMeAnyTime function
pretty cool huh?
*/
delegate OnButtonClicked();
delegate OnButtonClickedWithIndex(int index);
delegate OnDoubleClicked();
delegate OnDoubleClickedWithIndex(int index);

function bool checkMouseWithinBoundaries(int MousePositionX,int MousePositionY)
{
    local float buttonPositionX, buttonPositionY;
    local float textPositionX, textPositionY;
    
    buttonPositionX = (positionX);
    buttonPositionY = (positionY);
    
    // Check if we should use text position for hit detection
    if(bDetectMouseFromText) {
        // Text position using the offsets
        textPositionX = positionX + (buttonTextOffsetX * ResScaleY);
        textPositionY = positionY + (buttonTextOffsetY * ResScaleY);
        
        // Treat like centered draw even if it's not set
        return (
            MousePositionX >= fmax((textPositionX - ((buttonWidth) / 2)), 0)
            && MousePositionX <= (textPositionX + ((buttonWidth) / 2)) 
            && MousePositionY >= fmax((textPositionY - ((buttonHeight) / 2)), 0)
            && MousePositionY <= (textPositionY + ((buttonHeight) / 2))
        );
    }
    // Standard hit detection - check if we should use the top-left aligned or non-centered approach
    else if(bBackgroundAlignedTopLeft || !bCenteredDraw) {
        return (
            MousePositionX >= (buttonPositionX)
            && MousePositionX <= (buttonPositionX + (buttonWidth)) 
            && MousePositionY >= (buttonPositionY) 
            && MousePositionY <= (buttonPositionY + (buttonHeight))
        );
    }
    // Check centered approach
    else {
        return (
            MousePositionX >= fmax((buttonPositionX - ((buttonWidth) / 2)), 0)
            && MousePositionX <= (buttonPositionX + ((buttonWidth) / 2)) 
            && MousePositionY >= fmax((buttonPositionY - ((buttonHeight) / 2)), 0)
            && MousePositionY <= (buttonPositionY + ((buttonHeight) / 2))
        );
    }
}

function checkForClick(int MousePositionX,int MousePositionY)
{
    if(!bEnabled)
        return;
    if(currentClickCooldown >=0)
    {
        if(clickCooldown-currentClickCooldown >= DoubleClickTime)
        {
            OnDoubleClicked();
            OnDoubleClickedWithIndex(ButtonIndex);
        }
        return;
    }
    if(checkMouseWithinBoundaries(MousePositionX,MousePositionY) && bDetectClicks)
    {
        switch (buttonType)
		{
		    case Pressable:
                callClickFunction();
                if(!stateDisabled)
                    currentButtonState = EButtonState.Click;
		    	break;
            case Selectable:
                callClickFunction();
                if(!stateDisabled)
                    currentButtonState = EButtonState.Selected;
                break;
		    case Toggle:
                callClickFunction();
                if(!stateDisabled)
                    currentButtonState = EButtonState.Selected;
		    	break;
		    case HoverRelease:
                callClickFunction();
                if(!stateDisabled)
                    currentButtonState = EButtonState.Click;
		    	break;
		}
    }
}


function highlightOnClick(int MousePositionX,int MousePositionY)
{
    if(!bDetectClicks || !bEnabled)
        return;

    if(checkMouseWithinBoundaries(MousePositionX,MousePositionY))
    {
        currentButtonState = EButtonState.Selected;
        currentlySelected = true;
    }
}

function executeOnRelease(int MousePositionX,int MousePositionY)
{
    if(!bDetectClicks || !bEnabled)
        return;

    if(currentClickCooldown >=0)
    {
        if(clickCooldown-currentClickCooldown >= DoubleClickTime)
        {
            OnDoubleClicked();
            OnDoubleClickedWithIndex(ButtonIndex);
        }
        return;
    }
    if(checkMouseWithinBoundaries(MousePositionX,MousePositionY) )
    {
        callClickFunction();
    }

    if(!stickySelection){//Don't reset to idle if our selection is sticky
        currentButtonState = EButtonState.Idle;
        currentlySelected = false;
    }
}


function callClickFunction()
{
    currentClickCooldown=clickCooldown;
    Rx_Controller(RenXHud.Owner).PlaySound(SelectSound,true);
    switch (buttonOnclickParameter)
	{
	    case EButtonOnclickParameter.Empty:
            OnButtonClicked();
	    	break;
        case EButtonOnclickParameter.selectionIndex:
            OnButtonClickedWithIndex(ButtonIndex);
	}
    
}

delegate hoverFunction(int index);
delegate hoverLeaveFunction(int index);


function UpdateCursorPosition(int x, int y)
{
    super.UpdateCursorPosition(x,y);
}

function clickReset()
{
    currentResetFrames=0;
    if(!stateDisabled){
        if(checkMouseWithinBoundaries(MousePosition.x,MousePosition.y))
        {
            currentButtonState = Hover;
        }
        else
        {
            currentButtonState = Idle;
        }
    }
}

//Receieve positions unscaled, scale them according to resolution alongside 
//the offset and assign it so we don't have to do it again anywhere else
function setPosition(float x,float y,optional float offsetX,optional float offsetY,optional bool bIgnoreScaling)
{
    if(bIgnoreScaling)
    {
        positionX=X + (OffsetX);
        positionY=Y + (offsetY);
    }
    else
    {
        positionX=X*ResScaleY + (OffsetX*ResScaleY);
        positionY=Y*ResScaleY + (offsetY*ResScaleY);
    }
}

function setSize(float x,float y)
{
    buttonWidth=x*ResScaleY;
    buttonHeight=y*ResScaleY;
}

function setBackgroundSize(float x,float y)
{
    buttonBackgroundWidth=x*ResScaleY;
    buttonBackgroundHeight=y*ResScaleY;
}

function setTextScale(float x,float y,optional bool bIgnoreScaling)
{
    if(bIgnoreScaling)
    {
        TextScaleX=x;
        TextScaleY=y;
    }else
    {
        TextScaleX=x*ResScaleY;
        textScaleY=y*ResScaleY;
    }

}

function setHoverState()
{
    currentButtonState=Hover;
}

function setIdleState()
{
    currentButtonState=Idle;
}

function setSelectedState()
{
    currentButtonState=Selected;
}

function LockButtonToSelectedState()
{
    currentButtonState=Selected;
    stateDisabled=true;
}

function deActivateButton()
{
    currentButtonState=Inactive;
    stateDisabled=true;
    bDetectClicks=false;
}

function setButtonInactiveMode()
{
    returnState=Inactive;
    currentButtonState=Inactive;
}

function setButtonDefaultMode()
{
    returnState=idle;
    currentButtonState=idle;
}

function setButtonErrortMode()
{
    returnState=Error;
    currentButtonState=Error;
}

function lockButton()
{
    currentButtonState=Locked;
    stateDisabled=true;
}

function errorButton()
{
    currentButtonState=Error;
    stateDisabled=true;
}

function ActivateButtonStates()
{
    stateDisabled=false;
    bDetectClicks=true;
}

function vector2D getPosition()
{
    local vector2D position;

    position.X=positionX;
    position.Y=positionY;

    return position;
}

DefaultProperties
{
    SelectSound=SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundTest3_Cue'
    HoverSound=SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundTest4_Cue'
    ButtonBackgroundConstant = MaterialInstanceConstant'TS_HUD_Canvas.buildMenu.Materials.MI_Button_Simple'
    buttonType=Pressable

    //buttonTextIdle="Button Idle"
    //buttonTextHover="Button Hover"
    //buttonTextClick="Button Click"
    //buttonTextSelected="Button Selected"
    //buttonTextInactive="Button Inactive"
    //buttonTextError="Button Error"
    currentButtonText=""
    positionX=0
    positionY=0
    buttonWidth=169
    buttonHeight=68
    buttonBackgroundWidth=169
    buttonBackgroundHeight=68
    textScaleX=1
    textScaleY=1
    clickResetDelayFrames=1
    currentResetFrames=0
    currentButtonState=idle
    idleColor = (R=88,G=214,B=217,A=255)
    idleDropShadow = (R=31,G=31,B=31,A=255)
    hoverColor = (R=112,G=213,B=74,A=255)
    hoverDropShadow = (R=56,G=99,B=28,A=255)
    currentColor =(R=88,G=214,B=217,A=255)
    currentDropShadow = (R=31,G=31,B=31,A=255)

    buttonOnclickParameter=Empty;
    currentlySelected=false;
    stateDisabled=false;
    bBackgroundAngled=false;
    bDetectClicks=true;
    bCenteredDraw=true;
    bDetectMouseFromText=false

    Alpha=255

    clickCooldown=0.5
    doubleClickTime=0.1
}
