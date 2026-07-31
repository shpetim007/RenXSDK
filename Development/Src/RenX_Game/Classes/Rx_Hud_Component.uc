class Rx_Hud_Component extends Object;

var Canvas Canvas;
var protected Rx_Hud RenxHud;

var protected const Color ColorGreyedOut;
var protected const Color ColorWhite;
var protected const Color ColorRed;
var protected const Color ColorYellow;
var protected const Color ColorGreen;
var protected const Color ColorBlue;
var protected const Color ColorBlue2;
var protected const Color ColorBlue3;

enum STANCE
{
	STANCE_NEUTRAL,
	STANCE_ENEMY,
	STANCE_FRIENDLY
};

var bool hiddenByPlayer; // hide this component when it is set by the player


var bool bEnabled;

//Colors for factions
var Color C_UltraNeu,C_Neu, C_GDI, C_Nod,C_Green,C_White,C_Gray,C_OffWhite, C_BlueishWhite, C_BlueishGray ,C_UltraGreen,C_Ghostly_Neu,C_Muted_Red,C_Muted_Neu,C_FireOrange,C_EmberRed;
//Colors for drop shadow
var Color C_Shadow_Neu,C_Shadow_GDI,C_Shadow_Nod,C_Shadow_Green,C_Shadow_Offwhite;
//Colors for menu
var Color MC_GDI,MC_NOD,MC_GDI_Shadow,MC_NOD_Shadow,MC_Neu,MC_Neu_Shadow;

var FontRenderInfo FRInfo;

//Margin for drop shadow x and y
var int dropShadowMargin;
//Maximum alpha for the dropshadow
var float dropShadowMaxAlpha;

//Visibility
var float AlphaMax;
var float AlphaMin;
var float Alpha;

//Resolution Scale variables, use to scale your UI according to resolution in the Update function
var float ResScaleX, ResScaleY; 
//Example;
/*
Base our scale on 1080p, that means we design the look in 1080p and then it scales up properly
ResScaleX = FClamp(RenxHud.Canvas.SizeX / 1920.0, 0, 1);
ResScaleY = FClamp(RenxHud.Canvas.SizeY / 1080.0, 0, 1);
*/

var vector2D MousePosition;
var bool bEnableMouse;

enum EHorizontalAlignment
{
    AlignLeft,
    AlignCenter,
    AlignRight
};

enum EVerticalAlignment
{
    AlignTop,
	AlignMiddle,
    AlignBottom,
    AlignCustom,//Use to align text vertically with a provided parameter
};

//Button stuff
enum EButtonFunction
{
    Pressable, //Click to press 
    Selectable,//Click to enable, disable through outside calls
	Toggle, //Click to enable, Click again to disable           //Not implemented yet
    HoverRelease,//Hover to select, deinit to execute click     //Not implemented yet
};

enum EButtonState
{
    Idle,
    Click,
    Hover,
    Selected,
    Error,
    Inactive,
    Locked
};

enum EButtonOnclickParameter
{
    empty,
    selectionIndex
};

enum RenderState
{
    Intro,
    Outro,
    Ready,
    Dismissed
};

var RenderState currentRenderState;

var float ScrollAmount;

struct LineMessage //used for multi line fading out text with an icon
{
	var string Message;
	var float Lifetime;	
	var float TotalLifetime;
	var Texture2D image;
    var Color MsgColor;
};

struct ChatMessage //use for chat messages
{
	var string Title;
	var string Message;
    var color titleColor;
    var color messageColor;
	var float Lifetime;	
	var float TotalLifetime;
};


//Override variables
var float globalScaleOverride; // this variable is combined with the resolution scale to resize items accordingly
//var float hiddenByPlayer; // hide this component when it is set by the player // Moved to rx hud component

var string hudTooltip;//to be used when the mouse hovers over this, hovering needs to be wired up first!
var color hudTooltipColor;


function UpdateResolutionScaleLimited(Rx_HUD HUD)
{
    ResScaleX = RenxHud.Canvas.SizeX / 1920.0;
	ResScaleY = RenxHud.Canvas.SizeY / 1080.0;

	if(ResScaleX<1){
		ResScaleY = FMin(RenxHud.Canvas.SizeY / 1080.0,ResScaleX);
	}
}

function updateResolutionScale()
{
    ResScaleX = RenxHud.Canvas.SizeX / 1920.0;
    ResScaleY = RenxHud.Canvas.SizeY / 1080.0;
    ResScaleY=FMin(ResScaleX,ResScaleY);
}

function Update(float DeltaTime, Rx_HUD HUD)
{
	Canvas = HUD.Canvas;
	if (RenxHud == none)
	{
		RenxHud = HUD;
	}
}


function DrawAlignedText(string text,Vector2D Position,color textColor,float textAlpha,float scaleX,float scaleY,
EHorizontalAlignment HorizontalAlignment,EVerticalAlignment VerticalAlignment,optional bool bDropshadow,optional float CustomVertical)
{
    local Vector2D RenderPosition;
    local float TextWidth, TextHeight;

	RenderPosition = Position;
    if(Canvas != none)
	    Canvas.TextSize(text, TextWidth, TextHeight,ScaleX,ScaleY);
	// Handle the horizontal alignment
    if (HorizontalAlignment == AlignCenter)
    {
        RenderPosition.X -= (TextWidth * 0.5f);
    }
    else if (HorizontalAlignment == AlignRight)
    {
        RenderPosition.X -= TextWidth;
    }

	// Handle the vertical alignment
    if (VerticalAlignment == AlignMiddle)
    {
        RenderPosition.Y -= (TextHeight * 0.5f);
    }
    else if (VerticalAlignment == AlignTop)
    {
        RenderPosition.Y -= TextHeight;
    }
    else if (VerticalAlignment == AlignCustom)
    {
        RenderPosition.Y -= (TextHeight*CustomVertical);
    }
    if(Canvas == none)
        return;

	
    // Check if text is within canvas bounds
    if (RenderPosition.X < 0 || RenderPosition.X > Canvas.SizeX ||
        RenderPosition.Y < 0 || RenderPosition.Y > Canvas.SizeY ||
		RenderPosition.X + TextWidth > Canvas.SizeX || RenderPosition.Y + TextHeight > Canvas.SizeY)
    {
        // Text is completely outside canvas bounds, don't draw
        return;
    }


    if(bDropshadow){
	    // Set the canvas position
        Canvas.SetPos(RenderPosition.X+dropShadowMargin, RenderPosition.Y+dropShadowMargin);
    }
    else
    {
        // Set the canvas position
        Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
    }

    // Set the text color
    Canvas.SetDrawColor(textColor.R, textColor.G, textColor.B, textAlpha);
    // Render the text

    Canvas.DrawText(text, false, ScaleX, ScaleY);

    //Reset the draw color
	Canvas.SetDrawColor(255, 255, 255, 255);
}

//Alternative function to draw multi line text as text size and width calculation is inaccurate when multi line text is used
function DrawAlignedTextMultiLine(string text,Vector2D Position,color textColor,float textAlpha,float scaleX,float scaleY,
EHorizontalAlignment HorizontalAlignment,EVerticalAlignment VerticalAlignment,optional bool bDropshadow,optional float CustomVertical)
{
    local Vector2D RenderPosition;
    local float TextWidth, TextHeight;
    local float LineWidth, LineHeight;
    local array<string> Lines;
    local int i;

    RenderPosition = Position;
    
    if(Canvas == none)
        return;
    
    // Split text by newlines and find the longest line's width
    Lines = SplitString(text, "\n", false);
    TextWidth = 0;
    TextHeight = 0;
    
    for(i = 0; i < Lines.Length; i++)
    {
        Canvas.TextSize(Lines[i], LineWidth, LineHeight, ScaleX, ScaleY);
        if(LineWidth > TextWidth)
            TextWidth = LineWidth;
        TextHeight += LineHeight;
    }
    
    // If no newlines found, measure normally
    if(Lines.Length == 0)
    {
        Canvas.TextSize(text, TextWidth, TextHeight, ScaleX, ScaleY);
    }

    // Handle the horizontal alignment
    if (HorizontalAlignment == AlignCenter)
    {
        RenderPosition.X -= (TextWidth * 0.5f);
    }
    else if (HorizontalAlignment == AlignRight)
    {
        RenderPosition.X -= TextWidth;
    }

    // Handle the vertical alignment
    if (VerticalAlignment == AlignMiddle)
    {
        RenderPosition.Y -= (TextHeight * 0.5f);
    }
    else if (VerticalAlignment == AlignTop)
    {
        RenderPosition.Y -= TextHeight;
    }
    else if (VerticalAlignment == AlignCustom)
    {
        RenderPosition.Y -= (TextHeight*CustomVertical);
    }

    // Check if text is within canvas bounds
    if (RenderPosition.X < 0 || RenderPosition.X > Canvas.SizeX ||
        RenderPosition.Y < 0 || RenderPosition.Y > Canvas.SizeY ||
        RenderPosition.X + TextWidth > Canvas.SizeX || RenderPosition.Y + TextHeight > Canvas.SizeY)
    {
        // Text is completely outside canvas bounds, don't draw
        return;
    }

    if(bDropshadow){
        Canvas.SetPos(RenderPosition.X+dropShadowMargin, RenderPosition.Y+dropShadowMargin);
    }
    else
    {
        Canvas.SetPos(RenderPosition.X, RenderPosition.Y);
    }

    Canvas.SetDrawColor(textColor.R, textColor.G, textColor.B, textAlpha);
    Canvas.DrawText(text, false, ScaleX, ScaleY);
    Canvas.SetDrawColor(255, 255, 255, 255);
}

function setEnabled(bool enable)
{
    bEnabled=enable;
}

function UpdateCursorPosition(int x, int y)
{
    MousePosition.x = x;
    MousePosition.y = y;
}

function checkForClick(int MousePositionX,int MousePositionY)
{
    return;
}

function checkForClickRelease(int MousePositionX,int MousePositionY)
{
    return;
}

function checkForRightClickRelease(int MousePositionX,int MousePositionY)
{
    return;
}

function checkForLeftClick(int MousePositionX,int MousePositionY)
{
    return;
}

function checkForRightClick(int MousePositionX,int MousePositionY)
{
    return;
}

function OnScroll(float Amount)
{
	ScrollAmount+=Amount;
}

function ConsoleCommand( string Command )
{
	local PlayerController PC;

	PC = RenxHud.PlayerOwner;
	if( PC != None )
	{
		PC.ConsoleCommand(Command);
	}
}

function toggleComponent()
{
    bEnabled=!bEnabled;
}

function STANCE GetStance(Actor inActor)
{
	if (RenXHud.PlayerOwner.IsSpectating())
	{
		return inActor.GetTeamNum() == TEAM_GDI ? STANCE_FRIENDLY : STANCE_ENEMY;
	}

	if (inActor.GetTeamNum() != TEAM_GDI && inActor.GetTeamNum() != TEAM_NOD)
	{
		return STANCE_NEUTRAL;
	} 
	else if (inActor.GetTeamNum() == RenxHud.PlayerOwner.GetTeamNum())
	{
		return STANCE_FRIENDLY;
	}
	else
	{
		return STANCE_ENEMY;
	}
}

function bool IsStealthedEnemyUnit(pawn inPawn)
{
	local RxIfc_Stealth StealthPawn; 

	if(RenxHud.PlayerOwner.IsSpectating())
		return false;
	
	StealthPawn = RxIfc_Stealth(inPawn);
	
	if ( StealthPawn!= none && GetStance(inPawn) == STANCE_ENEMY)
	{
		if (!StealthPawn.GetIsinTargetableState())
		{
			return true;
		}
	}
	return false;
}

function bool IsEnemySpy(Rx_Pawn inPawn)
{
	if (inPawn.isSpy() && GetStance(inPawn) == STANCE_ENEMY)
		return true;
	else
		return false;
}

function float GetWeaponRange()
{
	return RenxHud.GetWeaponRange();
}

function float GetWeaponTargetingRange()
{
	return RenxHud.GetWeaponTargetingRange();
}

function bool IsPTorMCT (actor a)
{
	if (Rx_BuildingAttachment_MCT(a) != none || Rx_BuildingAttachment_PT(a) != none)
		return true;
	else return false;
}

function bool IsBuildingComponent (actor a)
{
	if (Rx_BuildingAttachment(a) != none || Rx_Building(a) != none || Rx_Building_Internals(a) != none)
		return true;
	else return false;
}

function bool IsTechBuildingComponent (actor a)
{
	if(a.isA('Rx_CapturableMCT'))
		return false;
	else if (Rx_Building_TechBuilding_Internals(a) != none)
		return true;
	else if ( Rx_Building_Techbuilding(a) != none )
		return true;
	else if (Rx_BuildingAttachment(a) != none && Rx_Building_TechBuilding_Internals(Rx_BuildingAttachment(a).OwnerBuilding) != none)
		return true;
	else return false;
}

function Vehicle GetDrivenVehicle()
{
	if (RenxHud.PlayerOwner != none && RenxHud.PlayerOwner.Pawn != none && RenxHud.PlayerOwner.Pawn.DrivenVehicle != none)
	{
		return RenxHud.PlayerOwner.Pawn.DrivenVehicle;
	}
	else return none;
}

function bool IsActorInView (actor inActor, optional bool IgnoreTrace = false)
{
	local Vector screenCoords;
	local Vector2D screenCoords2d;
	local Vector canvasOrigin, acotrDir, hitnorm, hitloc;
	local Rx_SmokeScreen DummyActor;
	local Actor temp;

	if (IsBuildingComponent(inActor) && !IsPTorMCT(inActor))
		return true;

	screenCoords = Canvas.Project(inActor.Location);

	if (screenCoords.X > Canvas.SizeX || screenCoords.X < 0 ||
		screenCoords.Y > Canvas.SizeY || screenCoords.Y < 0 ||
		screenCoords.Z <= 0)
	{
		return false; // Actor is not onscreen.
	}
	else if (!IgnoreTrace) // Actor is onscreen, so draw name if visible to camera.
	{
		screenCoords2d.X = screenCoords.X; 
		screenCoords2d.Y = screenCoords.Y;
		Canvas.DeProject(screenCoords2d,canvasOrigin,acotrDir);

		// We want to do a full trace on enemy pawns to hide them behind dynamic objects.
		if (Rx_Pawn(inActor) != none && GetStance(inActor) == STANCE_ENEMY) 
		{
			temp = inActor.trace(hitloc,hitnorm,canvasOrigin);
			if (temp == (RenxHud.PlayerOwner.ViewTarget) || temp == none)
			{
				foreach inActor.TraceActors(class'Rx_SmokeScreen', DummyActor, hitloc, hitnorm, canvasOrigin)
					return false;
				return true;
			}
			else return false;
		}
		// Others (vehicles and friendly pawns) are ok to do fast trace and draw names behind dynamic objects since they're less gameplay critical to be hidden.
		else 
			return (inActor.FastTrace(canvasOrigin,,,true));
	}
	else return true;
}

// as a bit of extension, when actor is not in play or you need to take a bit of offset...

function bool IsLocationInView (vector inVector, optional bool IgnoreTrace = false)
{
	local Vector screenCoords;
	local Vector2D screenCoords2d;
	local Vector canvasOrigin, acotrDir;

	screenCoords = Canvas.Project(inVector);

	if (screenCoords.X > Canvas.SizeX || screenCoords.X < 0 ||
		screenCoords.Y > Canvas.SizeY || screenCoords.Y < 0 ||
		screenCoords.Z <= 0)
	{
		return false; // location is not onscreen.
	}
	else if (!IgnoreTrace) // location is onscreen
	{
		screenCoords2d.X = screenCoords.X; 
		screenCoords2d.Y = screenCoords.Y;
		Canvas.DeProject(screenCoords2d,canvasOrigin,acotrDir);

		return (RenxHud.PlayerOwner.FastTrace(canvasOrigin,inVector,,true));
	}
	else return true;
}

function Draw()
{

}

function float GetAlphaForDistance(float distance, float maxDistance, optional float maxAlphaPercentage = 0.8)
{
	local float fAlpha, maxAlphaDist;

	if (distance <maxDistance)
	{
		maxAlphaDist = maxDistance * maxAlphaPercentage;
		if(distance >= maxAlphaDist)
		{
			fAlpha = FMin((maxDistance - distance) / (maxDistance - maxAlphaDist), 1.f);

			return fAlpha;
		}
		else return 1.f;
	}
	
	return 0.f;
}

function float GetResolutionModifier()
{
	return FMax(0.75,RenXHud.ViewportSize.Y / 1080);
}



DefaultProperties
{
	ColorGreyedOut = (R = 0, G = 0, B = 0, A = 100)
	ColorWhite = (R = 255, G = 255, B = 255, A = 255)
	ColorRed = (R = 255, G = 62, B = 0, A = 255)
	ColorYellow = (R = 255, G = 215, B = 0, A = 255)
	ColorGreen = (R = 93, G = 255, B = 0, A = 255)
	ColorBlue = (R = 167, G = 227, B = 255, A = 255)
	ColorBlue2 = (R = 50, G = 50, B = 255, A = 150)
	ColorBlue3 = (R = 50, G = 255, B = 255, A = 255) //Used on armour bar/text for targeting box.

	bEnabled=true;
}
