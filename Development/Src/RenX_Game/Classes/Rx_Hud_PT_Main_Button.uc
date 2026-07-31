class Rx_Hud_PT_Main_Button extends Rx_Hud_Button;

var int menuType;

var Texture2D PTIconTexture;
var string Title;
var string desc;
var string desc2;  
var string cost;
var string hotkey;
var string factoryName;
var string factoryStatus;
var string factorySubtext;
var string factoryName2;
var string factoryStatus2;
var string factorySubtext2;
var string toprightLabel;
var int type;
var int damage;
var int range;
var int rateOfFire;
var int magCap;

// Drawing offsets and sizes for different menu types
// Icon
var float IconOffsetX, IconOffsetY,IconOffsetYItem, IconOffsetXSecondary,IconOffsetYSecondary;
var float IconWidth, IconHeight;
var float IconWidthSecondary, IconHeightSecondary;

// Title
var float TitleOffsetX, TitleOffsetY;
var float TitleScale;

// Description
var float DescOffsetX, DescOffsetY,DescOffsetItemY;
var float DescScale;

// Cost
var float CostOffsetX, CostOffsetY;
var float CostScale;

// Factory Name
var float FactoryNameOffsetX, FactoryNameOffsetY;
var float FactoryNameOffsetX2, FactoryNameOffsetY2;
var float FactoryNameScale;

// Factory Status
var float FactoryStatusOffsetX, FactoryStatusOffsetY;
var float FactoryStatusOffsetX2, FactoryStatusOffsetY2;
var float FactoryStatusScale;

// Factory subtext
var float FactorySubtextOffsetX, FactorySubtextOffsetY;
var float FactorySubtextScale;

// TopRightLabel
var float TopRightLabelOffsetX, TopRightLabelOffsetY;
var float TopRightLabelScale;

// Hotkey
var float HotkeyOffsetX, HotkeyOffsetY;
var float HotkeyScale;

var float ItemSubtextOffsetX, ItemSubtextOffsetY;
var float ItemSubtextScale;
// Stats bars (for weapons/classes)
var float StatsBarTextScale;
var float StatsBarTextOffsetX,StatsBarTextOffsetY;
var float StatsOffsetX, StatsOffsetY;
var float StatsBarWidth, StatsBarHeight;
var float StatsBarSpacing;
var float StatsBarSpacingY;

//Colors
var Color gdiTextColor;
var Color nodTextColor;
var Color selectedColor;
var Color disabledColor;

var float buttonDetectionWidth;
var float buttonDetectionHeight;

function Draw()
{
    local int Hover,Clicked,Selected,Inactive;

    if(!bEnabled)
        return;
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
    // Draw based on menu type
    switch(menuType)
    {
        case 0:
            drawMenuButton();
            break;
        case 1:
            drawClassButton();
            break;
        case 2:
            drawWeaponButton();
            break;
        case 3:
            drawItemButton();
            break;
        case 4:
            drawVehicleButton();
            break;
    }

    buttonWidth=buttonDetectionWidth*ResScaleY;
    buttonHeight=buttonDetectionHeight*ResScaleY;

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

function Update(float DeltaTime, Rx_HUD HUD)
{
	Canvas = HUD.Canvas;
	if (RenxHud == none)
	{
		RenxHud = HUD;
	}
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

function drawMenuButton()
{
    local vector2D iconPos, titlePos, descPos, hotkeyPos,costPos;
    local vector2D factoryNamePos,factoryStatusPos,factorySubtextPos,topRightPos;
    
    // Draw icon
    if(PTIconTexture != none)
    {
        iconPos.x = positionX + (IconOffsetXSecondary * ResScaleY);
        iconPos.y = positionY + (IconOffsetYSecondary * ResScaleY);
        RenXHud.Canvas.SetPos(iconPos.x, iconPos.y);
        RenxHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255);
        RenXHud.Canvas.DrawTile(PTIconTexture, IconWidth * ResScaleY, IconHeight * ResScaleY, 0, 0, PTIconTexture.GetSurfaceWidth(), PTIconTexture.GetSurfaceHeight());
        RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
    }
    // Draw title
    titlePos.x = positionX + (TitleOffsetX * ResScaleY);
    titlePos.y = positionY + (TitleOffsetY * ResScaleY);
    DrawAlignedText(Title, titlePos, currentColor, Alpha, TitleScale* ResScaleY, TitleScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    
    // Draw description
    /*if(desc != "")
    {
        descPos.x = positionX + (DescOffsetX * ResScaleY);
        descPos.y = positionY + (DescOffsetY * ResScaleY);
        DrawAlignedText(desc, descPos, currentColor, Alpha, DescScale* ResScaleY, DescScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    }*/
    
    // Draw hotkey
    if(hotkey != "")
    {
        hotkeyPos.x = positionX + (HotkeyOffsetX * ResScaleY);
        hotkeyPos.y = positionY + (HotkeyOffsetY * ResScaleY);
        DrawAlignedText(hotkey, hotkeyPos, currentColor, Alpha, HotkeyScale* ResScaleY, HotkeyScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }

        // Draw cost
    costPos.x = positionX + (CostOffsetX * ResScaleY);
    costPos.y = positionY + (CostOffsetY * ResScaleY);
    DrawAlignedText("MENU", costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);


    //Factory description text is sized differently for each button because why the fuck not
    if(title=="CHARACTERS")
    {
        factoryNamePos.x = positionX + (FactoryNameOffsetX * ResScaleY);
        factoryNamePos.y = positionY + (FactoryNameOffsetY * ResScaleY);
        DrawAlignedText(factoryName, factoryNamePos, currentColor, Alpha, FactoryNameScale* ResScaleY, FactoryNameScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        factoryStatusPos.x = positionX + (FactoryStatusOffsetX * ResScaleY);
        factoryStatusPos.y = positionY + (FactoryStatusOffsetY * ResScaleY);
        DrawAlignedText(factoryStatus, factoryStatusPos, currentColor, Alpha, FactoryStatusScale* ResScaleY, FactoryStatusScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        factorySubtextPos.x = positionX + (FactorySubtextOffsetX * ResScaleY);
        factorySubtextPos.y = positionY + (FactorySubtextOffsetY * ResScaleY);
        DrawAlignedText(factorySubtext, factorySubtextPos, currentColor, Alpha, FactorySubtextScale* ResScaleY, FactorySubtextScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);
    }
    if(title=="VEHICLES")
    {
        factoryNamePos.x = positionX + (FactoryNameOffsetX * ResScaleY);
        factoryNamePos.y = positionY + (FactoryNameOffsetY * ResScaleY);
        DrawAlignedText(factoryName, factoryNamePos, currentColor, Alpha, FactoryNameScale* ResScaleY, FactoryNameScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        factoryStatusPos.x = positionX + (FactoryStatusOffsetX * ResScaleY);
        factoryStatusPos.y = positionY + (FactoryStatusOffsetY * ResScaleY);
        DrawAlignedText(factoryStatus, factoryStatusPos, currentColor, Alpha, FactoryStatusScale* ResScaleY, FactoryStatusScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        factoryNamePos.x = positionX + (FactoryNameOffsetX2 * ResScaleY);
        factoryNamePos.y = positionY + (FactoryNameOffsetY2 * ResScaleY);
        DrawAlignedText(factoryName2, factoryNamePos, currentColor, Alpha, FactoryNameScale* ResScaleY, FactoryNameScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        factoryStatusPos.x = positionX + (FactoryStatusOffsetX2 * ResScaleY);
        factoryStatusPos.y = positionY + (FactoryStatusOffsetY2 * ResScaleY);
        DrawAlignedText(factoryStatus2, factoryStatusPos, currentColor, Alpha, FactoryStatusScale* ResScaleY, FactoryStatusScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);

        topRightPos.x = positionX + (TopRightLabelOffsetX * ResScaleY);
        topRightPos.y = positionY + (TopRightLabelOffsetY * ResScaleY);
        DrawAlignedText(toprightLabel, topRightPos, currentColor, Alpha, TopRightLabelScale* ResScaleY, TopRightLabelScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);
    }
    if(title=="REFILL")
    {
        factoryStatusPos.x = positionX + (FactoryStatusOffsetX * ResScaleY);
        factoryStatusPos.y = positionY + (FactoryStatusOffsetY * ResScaleY);
        DrawAlignedText(factoryStatus, factoryStatusPos, currentColor, Alpha, FactoryStatusScale* ResScaleY, FactoryStatusScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);
        factorySubtext=desc;
        factorySubtextPos.x = positionX + (FactorySubtextOffsetX * ResScaleY);
        factorySubtextPos.y = positionY + (FactorySubtextOffsetY * ResScaleY);
        DrawAlignedText(factorySubtext, factorySubtextPos, currentColor, Alpha, FactorySubtextScale* ResScaleY, FactorySubtextScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignBottom, false);
    }
    if(title=="ITEM")
    {
        if(desc != "")
        {
            descPos.x = positionX + (ItemSubtextOffsetX * ResScaleY);
            descPos.y = positionY + (ItemSubtextOffsetY * ResScaleY);
            DrawAlignedText(desc, descPos, currentColor, Alpha, ItemSubtextScale* ResScaleY, FactorySubtextScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
        }
    }
}

function drawClassButton()
{
    local vector2D iconPos, titlePos, descPos, costPos, hotkeyPos, statsPos;
    
    // Draw icon
    if(PTIconTexture != none)
    {
        if(PTIconTexture != none)
        {
            iconPos.x = positionX + (IconOffsetX * ResScaleY);
            iconPos.y = positionY + (IconOffsetY * ResScaleY);
            RenXHud.Canvas.SetPos(iconPos.x, iconPos.y);
            RenxHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255);
            RenXHud.Canvas.DrawTile(PTIconTexture, IconWidth * ResScaleY, IconHeight * ResScaleY, 0, 0, PTIconTexture.GetSurfaceWidth(), PTIconTexture.GetSurfaceHeight());
            RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
        }
    }
    
    // Draw title
    titlePos.x = positionX + (TitleOffsetX * ResScaleY);
    titlePos.y = positionY + (TitleOffsetY * ResScaleY);
    DrawAlignedText(Title, titlePos, currentColor, Alpha, TitleScale* ResScaleY, TitleScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    
    // Draw description
    if(desc != "")
    {
        descPos.x = positionX + (DescOffsetX * ResScaleY);
        descPos.y = positionY + (DescOffsetY * ResScaleY);
        DrawAlignedText(desc, descPos, currentColor, Alpha, DescScale* ResScaleY, DescScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
    
    // Draw cost
    costPos.x = positionX + (CostOffsetX * ResScaleY);
    costPos.y = positionY + (CostOffsetY * ResScaleY);
    if(cost=="0"){
        DrawAlignedText("FREE", costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);
    }else
    {
        DrawAlignedText("$"$cost, costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);
    }
    // Draw hotkey
    if(hotkey != "")
    {
        hotkeyPos.x = positionX + (HotkeyOffsetX * ResScaleY);
        hotkeyPos.y = positionY + (HotkeyOffsetY * ResScaleY);
        DrawAlignedText(hotkey, hotkeyPos, currentColor, Alpha, HotkeyScale* ResScaleY, HotkeyScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
    
    // Draw stats bars
    statsPos.x = positionX + (StatsOffsetX * ResScaleY);
    statsPos.y = positionY + (StatsOffsetY * ResScaleY);
    drawStatBars(statsPos, damage, range, rateOfFire, magCap);
}

function drawWeaponButton()
{
    local vector2D iconPos, titlePos, descPos, costPos, hotkeyPos, statsPos;
    
    // Draw icon
    if(PTIconTexture != none)
    {
        iconPos.x = positionX + (IconOffsetX * ResScaleY);
        iconPos.y = positionY + (IconOffsetY * ResScaleY);
        RenXHud.Canvas.SetPos(iconPos.x, iconPos.y);
        RenxHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255);
        RenXHud.Canvas.DrawTile(PTIconTexture, IconWidth * ResScaleY, IconHeight * ResScaleY, 0, 0, PTIconTexture.GetSurfaceWidth(), PTIconTexture.GetSurfaceHeight());
        RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
    }
    
    // Draw title
    titlePos.x = positionX + (TitleOffsetX * ResScaleY);
    titlePos.y = positionY + (TitleOffsetY * ResScaleY);
    DrawAlignedText(Title, titlePos, currentColor, Alpha, TitleScale* ResScaleY, TitleScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    
    // Draw description
    if(desc != "")
    {
        descPos.x = positionX + (DescOffsetX * ResScaleY);
        descPos.y = positionY + (DescOffsetY * ResScaleY);
        DrawAlignedText(desc, descPos, currentColor, Alpha, DescScale* ResScaleY, DescScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
    
    // Draw cost
    costPos.x = positionX + (CostOffsetX * ResScaleY);
    costPos.y = positionY + (CostOffsetY * ResScaleY);
    DrawAlignedText("$"$cost, costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);
    
    // Draw hotkey
    if(hotkey != "")
    {
        hotkeyPos.x = positionX + (HotkeyOffsetX * ResScaleY);
        hotkeyPos.y = positionY + (HotkeyOffsetY * ResScaleY);
        DrawAlignedText(hotkey, hotkeyPos, currentColor, Alpha, HotkeyScale* ResScaleY, HotkeyScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
    
    // Draw stats bars if type == 2 (weapons with stats)
    if(type == 2)
    {
        statsPos.x = positionX + (StatsOffsetX * ResScaleY);
        statsPos.y = positionY + (StatsOffsetY * ResScaleY);
        drawStatBars(statsPos, damage, range, rateOfFire, magCap);
    }
}

function drawItemButton()
{
    local vector2D iconPos, titlePos, descPos, costPos, hotkeyPos;
    //local float XSize, YSize;
    
    // Draw icon
    if(PTIconTexture != none)
    {
        iconPos.x = positionX + (IconOffsetX * ResScaleY);
        iconPos.y = positionY + (IconOffsetYItem * ResScaleY);
        RenXHud.Canvas.SetPos(iconPos.x, iconPos.y);
        RenxHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255);
        RenXHud.Canvas.DrawTile(PTIconTexture, IconWidth * ResScaleY, IconHeight * ResScaleY, 0, 0, PTIconTexture.GetSurfaceWidth(), PTIconTexture.GetSurfaceHeight());
        RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
    }
    
    // Draw title
    titlePos.x = positionX + (TitleOffsetX * ResScaleY);
    titlePos.y = positionY + (TitleOffsetY * ResScaleY);
    DrawAlignedText(Title, titlePos, currentColor, Alpha, TitleScale* ResScaleY, TitleScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    
    // Draw first description
    if(desc != "")
    {
        descPos.x = positionX + (DescOffsetX * ResScaleY);
        descPos.y = positionY + (DescOffsetItemY * ResScaleY);
        DrawAlignedTextMultiLine(desc, descPos, currentColor, Alpha, DescScale* ResScaleY, DescScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignCustom, false);
    }
    
    // Draw cost
    costPos.x = positionX + (CostOffsetX * ResScaleY);
    costPos.y = positionY + (CostOffsetY * ResScaleY);
    DrawAlignedText("$"$cost, costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);
    
    // Draw hotkey
    if(hotkey != "")
    {
        hotkeyPos.x = positionX + (HotkeyOffsetX * ResScaleY);
        hotkeyPos.y = positionY + (HotkeyOffsetY * ResScaleY);
        DrawAlignedText(hotkey, hotkeyPos, currentColor, Alpha, HotkeyScale* ResScaleY, HotkeyScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
}

function drawVehicleButton()
{
    local vector2D iconPos, titlePos, descPos, costPos, hotkeyPos;
    
    // Draw icon
    if(PTIconTexture != none)
    {
        iconPos.x = positionX + (IconOffsetX * ResScaleY);
        iconPos.y = positionY + (IconOffsetY * ResScaleY);
        RenXHud.Canvas.SetPos(iconPos.x-((PTIconTexture.SizeX * ResScaleY)/2), iconPos.y-((PTIconTexture.SizeY * ResScaleY)/2));
        RenxHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255);
        RenXHud.Canvas.DrawTile(PTIconTexture, (PTIconTexture.SizeX * ResScaleY), PTIconTexture.SizeY * ResScaleY, 0, 0, PTIconTexture.GetSurfaceWidth(), PTIconTexture.GetSurfaceHeight());
        RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
    }
    
    // Draw title
    titlePos.x = positionX + (TitleOffsetX * ResScaleY);
    titlePos.y = positionY + (TitleOffsetY * ResScaleY);
    DrawAlignedText(Title, titlePos, currentColor, Alpha, TitleScale* ResScaleY, TitleScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignMiddle, false);
    
    // Draw description
    if(desc != "")
    {
        descPos.x = positionX + (DescOffsetX * ResScaleY);
        descPos.y = positionY + (DescOffsetY * ResScaleY);
        DrawAlignedText(desc, descPos, currentColor, Alpha, DescScale* ResScaleY, DescScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
    
    // Draw cost
    costPos.x = positionX + (CostOffsetX * ResScaleY);
    costPos.y = positionY + (CostOffsetY * ResScaleY);
    DrawAlignedText("$"$cost, costPos, currentColor, Alpha, CostScale* ResScaleY, CostScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignBottom, false);
    
    // Draw hotkey
    if(hotkey != "")
    {
        hotkeyPos.x = positionX + (HotkeyOffsetX * ResScaleY);
        hotkeyPos.y = positionY + (HotkeyOffsetY * ResScaleY);
        DrawAlignedText(hotkey, hotkeyPos, currentColor, Alpha, HotkeyScale* ResScaleY, HotkeyScale* ResScaleY, EHorizontalAlignment.AlignLeft, EVerticalAlignment.AlignTop, false);
    }
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

function drawStatBars(vector2D basePos, int damageVal, int rangeVal, int rateVal, int magVal)
{
    local float currentY,XPos;
    local int i;
    local vector2D textPosition;
    
    XPos=basePos.X;
    currentY = basePos.y;
    

    //RenXHud.Canvas.TextSize("Damage",XSize,YSize,StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY);
    textPosition.x = basePos.X-StatsBarTextOffsetX*ResScaleX;
    textPosition.y = currentY+StatsBarTextOffsetY*ResScaleY;
    DrawAlignedText("Damage", textPosition, currentColor, Alpha, StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignMiddle, false);
    // Draw damage bar
    for(i = 0; i < 6; i++)
    {
        i<damageVal?RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255):RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 128);
        RenXHud.Canvas.SetPos(basePos.x, currentY);
        RenXHud.Canvas.DrawRect(StatsBarWidth * ResScaleY, StatsBarHeight * ResScaleY);
        basePos.x+=StatsBarWidth * ResScaleY+FMax(StatsBarSpacing*ResScaleY,1);
    }
    
    basePos.x=XPos;
    currentY += (StatsBarHeight* ResScaleY + StatsBarSpacingY*ResScaleX) ;
    
    //RenXHud.Canvas.TextSize("Range",XSize,YSize,StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY);
    textPosition.x = basePos.X-StatsBarTextOffsetX*ResScaleX;
    textPosition.y = currentY+StatsBarTextOffsetY*ResScaleY;
    DrawAlignedText("Range", textPosition, currentColor, Alpha, StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignMiddle, false);
    // Draw range bar
    for(i = 0; i < 6; i++)
    {
        i<rangeVal?RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255):RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 128);
        RenXHud.Canvas.SetPos(basePos.x, currentY);
        RenXHud.Canvas.DrawRect(StatsBarWidth * ResScaleY, StatsBarHeight * ResScaleY);
        basePos.x+=StatsBarWidth * ResScaleY+FMax(StatsBarSpacing*ResScaleY,1);
    }
    basePos.x=XPos;
    currentY += (StatsBarHeight* ResScaleY + StatsBarSpacingY*ResScaleX) ;
    
    //RenXHud.Canvas.TextSize("Rate of Fire",XSize,YSize,StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY);
    textPosition.x = basePos.X-StatsBarTextOffsetX*ResScaleX;
    textPosition.y = currentY+StatsBarTextOffsetY*ResScaleY;
    DrawAlignedText("Rate of Fire", textPosition, currentColor, Alpha, StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignMiddle, false);
    // Draw rate of fire bar
    for(i = 0; i < 6; i++)
    {
        i<rateVal?RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255):RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 128);
        RenXHud.Canvas.SetPos(basePos.x, currentY);
        RenXHud.Canvas.DrawRect(StatsBarWidth * ResScaleY, StatsBarHeight * ResScaleY);
        basePos.x+=StatsBarWidth * ResScaleY+FMax(StatsBarSpacing*ResScaleY,1);
    }
    
    basePos.x=XPos;
    currentY += (StatsBarHeight* ResScaleY + StatsBarSpacingY*ResScaleX) ;
    
    //RenXHud.Canvas.TextSize("Magazine Capacity",XSize,YSize,StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY);
    textPosition.x = basePos.X-StatsBarTextOffsetX*ResScaleX;
    textPosition.y = currentY+StatsBarTextOffsetY*ResScaleY;
    DrawAlignedText("Magazine Capacity", textPosition, currentColor, Alpha, StatsBarTextScale* ResScaleY, StatsBarTextScale* ResScaleY, EHorizontalAlignment.AlignRight, EVerticalAlignment.AlignMiddle, false);
    // Draw mag capacity bar
    for(i = 0; i < 6; i++)
    {
        i<magVal?RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 255):RenXHud.Canvas.SetDrawColor(currentColor.R, currentColor.G, currentColor.B, 128);
        RenXHud.Canvas.SetPos(basePos.x, currentY);
        RenXHud.Canvas.DrawRect(StatsBarWidth * ResScaleY, StatsBarHeight * ResScaleY);
        basePos.x+=StatsBarWidth * ResScaleY+FMax(StatsBarSpacing*ResScaleY,1);
    }
    
    RenXHud.Canvas.SetDrawColor(255, 255, 255, 255);
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


    /*if(bCenteredDraw){
        RenXHUD.Canvas.SetPos(buttonPositionX-((buttonDetectionWidth*ResScaleY)/2), buttonPositionY-((buttonDetectionHeight*ResScaleY)/2));

    }else
    {
        RenXHUD.Canvas.SetPos(buttonPositionX, buttonPositionY);
    }
    RenXHUD.Canvas.DrawBox(buttonWidth,buttonHeight);
    `log(bCenteredDraw);*/
}

DefaultProperties
{
    ButtonBackgroundConstant = MaterialInstanceConstant'RX_HUD_Canvas.pt_menu.MI_PT_CharacterButton'
    buttonBackgroundWidth=340
    buttonBackgroundHeight=178
    
    buttonDetectionWidth=305
    buttonDetectionHeight=150

    // Icon defaults
    IconOffsetX=-59
    IconOffsetY=-73
    IconOffsetYItem=-55
    IconWidth=242
    IconHeight=126

    IconOffsetXSecondary=-59
    IconOffsetYSecondary=-62

    IconWidthSecondary=242
    IconHeightSecondary=126
    
    // Title defaults
    TitleOffsetX=-89
    TitleOffsetY=-50
    TitleScale=0.6
    
    // Description defaults
    DescOffsetX=-135
    DescOffsetY=-18.5
    DescOffsetItemY=-38
    DescScale=0.3

    
    // Cost defaults
    CostOffsetX=135
    CostOffsetY=60
    CostScale=0.567

    //Factory Name
    FactoryNameOffsetX=-130
    FactoryNameOffsetY=-29
    FactoryNameOffsetX2=-130
    FactoryNameOffsetY2=5
    FactoryNameScale=0.333

    //Factory Status
    FactoryStatusOffsetX=-130
    FactoryStatusOffsetY=-15
    FactoryStatusOffsetX2=-130
    FactoryStatusOffsetY2=20
    FactoryStatusScale=0.433

    //Factory Subtext
    FactorySubtextOffsetX=-130
    FactorySubtextOffsetY=-10
    FactorySubtextScale=0.333

    ItemSubtextOffsetX=-130
    ItemSubtextOffsetY=-13
    ItemSubtextScale=0.417
   

    //TopRightLabel
    TopRightLabelOffsetX=100
    TopRightLabelOffsetY=-60
    TopRightLabelScale=0.433


    // Hotkey defaults
    HotkeyOffsetX=-138
    HotkeyOffsetY=-50
    HotkeyScale=0.667
    
    // Stats bar defaults
    StatsBarTextScale=0.233
    StatsBarTextOffsetX=5
    StatsBarTextOffsetY=1
    StatsOffsetX=80
    StatsOffsetY=20
    StatsBarWidth=7
    StatsBarHeight=7
    StatsBarSpacing=1
    StatsBarSpacingY=2

    gdiTextColor=(R=254,G=212,B=64,A=255)
    nodTextColor=(R=255,G=1,B=1,A=255)
    selectedColor=(R=1,G=255,B=1,A=255)
    disabledColor=(R=205,G=205,B=205,A=255)


    clickCooldown=0
    stickySelection=true
}