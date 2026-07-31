class Rx_Hud_PTMenu extends Rx_Hud_Component
dependson(Rx_InventoryManager);

//Data
var protected class<Rx_FamilyInfo>                OwnedFamilyInfo;
enum PurchaseBlockTypeCanvas
{
	EPBT_MENU,
	EPBT_CLASS,
	EPBT_WEAPON,
	EPBT_ITEM,
	EPBT_VEHICLE
};

struct PTMenuBlockCanvas
{
	var int 									id;
	var Texture                                 PTIconTexture;
	var PurchaseBlockTypeCanvas                 BlockType;
	var string 									hotkey;
	var string 									title;
	var string 									cost;
	var int 									type;
	var int 									iconID;
	var string 									desc;
	var string 									desc2;  
	var int 									damage;
	var int 									range;
	var int 									rateOfFire;
	var int 									magCap;
	var bool                                    bEnable;
	var bool                                    bSilo;
	
	StructDefaultProperties
	{
		id		        =	0
		PTIconTexture   =   Texture2D'RenXPurchaseMenu.T_WeaponIcon_MissingCameo'
		BlockType       =   EPBT_MENU
		hotkey	        =	""
		title	        =	""
		cost	        =	""
		type	        =	0
		iconID	        =	0
		desc	        =	""
		desc2	        =	""  
		damage	        =	0
		range	        =	0
		rateOfFire	    =	0
		magCap	        =	0
		bEnable         =   true
		bSilo           =   false
	}
};


struct PTVehicleBlockCanvas
{
	var int 									id;
	var Texture                                 PTIconTexture;
	var PurchaseBlockTypeCanvas                 BlockType;
	var string 									hotkey;
	var string 									title;
	var string 									cost;
	var int 									iconID;
	var string 									desc;
	var bool                                    bEnable;
	var bool                                    bAircraft;
	StructDefaultProperties
	{
		id		    =	0
		BlockType   =   EPBT_VEHICLE
		hotkey	    =	""
		title	    =	""
		cost	    =	""
		iconID	    =	0
		desc	    =	""
		bEnable     =   false //true
		bAircraft   =   false
	}
};

struct PTEquipmentBlockCanvas
{
	var int 									id;
	var Texture                                 PTIconTexture;
	var string 									title;
	var string 									desc;
	//obsolete. please use icon instead
	var int 									iconID;
	var string 									hotkey;
	//var array<>                                 BindingList;
	var bool                                    bEnable;
	var bool                                    bFree;
	var class<Rx_Weapon>                        WeaponClass;
	StructDefaultProperties
	{
		id		        =	0
		title			=	""
		desc			=	""
		iconID			=	0
		bEnable         =   true
		bFree           =   false
		WeaponClass     =   none
	}
};

var array<PTMenuBlockCanvas> 							GDIMainMenuData;
var array<PTMenuBlockCanvas> 							GDIItemMenuData;
var array<PTMenuBlockCanvas> 							GDIWeaponMenuData;
var array<PTMenuBlockCanvas> 							GDIClassMenuData;
var array<PTVehicleBlockCanvas> 						GDIVehicleMenuData;

var array<PTMenuBlockCanvas> 							NodMainMenuData;
var array<PTMenuBlockCanvas> 							NodItemMenuData;
var array<PTMenuBlockCanvas> 							NodWeaponMenuData;
var array<PTMenuBlockCanvas> 							NodClassMenuData;
var array<PTVehicleBlockCanvas> 						NodVehicleMenuData;

var array<PTEquipmentBlockCanvas>                     GDIEquipmentSideArmData;
var array<PTEquipmentBlockCanvas>                     NodEquipmentSideArmData;
var array<PTEquipmentBlockCanvas>                     GDIEquipmentExplosiveData;
var array<PTEquipmentBlockCanvas>                     NodEquipmentExplosiveData;

var Rx_BuildingAttachment_PT                    rxBuildingOwner;
var Rx_PurchaseSystem                           rxPurchaseSystem;
var Rx_Controller                               rxPC;
var Rx_Hud                                      rxHUD;
var Rx_PRI                                      rxPRI;
var int                                         TeamID;
var float                                       PlayerCredits;
var int                                         VehicleCount;

var Rx_PTPlayerSpot             				PawnShowcaseSpot;
var Rx_PT_Pawn 									DummyPawn;
var Rx_PTVehicleSpot							VehicleShowcaseSpot;
var Rx_PT_Vehicle	            				DummyVehicle;

//Buttons
var array<Rx_Hud_PT_Main_Button> MainTabButtons;
var array<Rx_Hud_PT_Main_Button> SubTabButtons;
var array<Rx_Hud_PT_Main_Vehicle_Button> VehicleTabButtons;
var Rx_Hud_PT_Main_Button tempButton;
var Rx_Hud_PT_Main_Vehicle_Button temp2button;

var Rx_Hud_PT_Left_Button exitButton;
var Rx_Hud_PT_Left_Button creditsButton;

var Rx_Hud_PT_Center_Button centerButton;

var Rx_Hud_PT_Right_Button backButton;
var Rx_Hud_PT_Right_Button purchaseButton;

//Offsets
var float TabsBasePositionOffsetX,TabsBasePositionOffsetY;
var float TabXSpacing,TabYSpacing;
var float VehicleTabXSpacing,VehicleTabYSpacing;
var float overdriveOpacity;

var float ExitButtonPositionOffsetX, ExitButtonPositionOffsetY;
var float BackButtonPositionOffsetX, BackButtonPositionOffsetY;
var float CenterButtonPositionOffsetX, CenterButtonPositionOffsetY;
var float CreditsButtonPositionOffsetX, CreditsButtonPositionOffsetY;
var float PurchaseButtonPositionOffsetX, PurchaseButtonPositionOffsetY;

var float vehiclesAnimationPaddingY;

// Vehicle menu specific offsets
var float VehicleTabsBasePositionOffsetX, VehicleTabsBasePositionOffsetY;

var float bottomBarPadding;
var float TabOffscreenPaddingX;
//Sounds
var SoundCue 									PurchaseSound;


//State
var int currentMenuState;
var int previousMenuState;

//Animations
var bool fadeInPlaying;
var bool fadeOutPlaying;
var float menuFadeInTotalTime;
var float menuFadeOutTotalTime;
var float menuFadeStartTime;
var float menuFadeAnimationProgress;

// Submenu animations
var bool submenuFadeInPlaying;
var bool submenuFadeOutPlaying;
var float submenuFadeStartTime;
var float submenuFadeAnimationProgress;

// Vehicle menu animations
var bool vehicleMenuFadeInPlaying;
var bool vehicleMenuFadeOutPlaying;
var float vehicleMenuFadeStartTime;
var float vehicleMenuFadeAnimationProgress;

var bool firstDrawerfadeInPlaying;
var bool firstDrawerfadeOutPlaying;
var float firstDrawerFadeInTotalTime;
var float firstDrawerFadeOutTotalTime;
var float firstDrawerFadeStartTime;
var float firstDrawerFadeAnimationProgress;

var bool secondDrawerfadeInPlaying;
var bool secondDrawerfadeOutPlaying;
var float secondDrawerFadeInTotalTime;
var float secondDrawerFadeOutTotalTime;
var float secondDrawerFadeStartTime;
var float secondDrawerFadeAnimationProgress;


var int currentlySelectedButtonIndex;

// Chat Log Display Variables
var float ChatLogX, ChatLogY;
var float ChatLogWidth, ChatLogHeight;
var float ChatLogPadding;
var float ChatLogTitleScale;
var float ChatLogTextScale;
var float ChatLogLineSpacing;
var float ChatLogTitleHeight;
var float ChatLogBorderThickness;
var byte ChatLogBackgroundAlpha;

// Chat log animations
var bool chatLogFadeInPlaying;
var float chatLogFadeInTotalTime;
var float chatLogFadeStartTime;
var float chatLogFadeAnimationProgress;

/** one1: Rotation increment for single key push (or tick). */
var int                         				RotationIncrement;
var float                                       LastCursorXPosition,MouseRotationIncrement;
var bool 										RotatingDummy;

function Update(float DeltaTime, Rx_HUD HUD)
{
    local int i;
    local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
    local float currentTime;
	super.Update(DeltaTime,HUD);
	UpdateResolutionScaleLimited(HUD);
	for (i = 0; i < 10; i++)
    {
        MainTabButtons[i].Update(DeltaTime, HUD);
		SubTabButtons[i].Update(DeltaTime, HUD);
		if(i < VehicleTabButtons.Length)
			VehicleTabButtons[i].Update(DeltaTime, HUD);
    }

	ExitButton.Update(DeltaTime, HUD);
	BackButton.Update(DeltaTime, HUD);
	centerButton.Update(DeltaTime, HUD);
	CreditsButton.Update(DeltaTime, HUD);
	PurchaseButton.Update(DeltaTime, HUD);

	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
    currentTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
	PlayerCredits = rxPRI.GetCredits();
    if(fadeInPlaying)
    {
        menuFadeAnimationProgress = (currentTime - menuFadeStartTime) / menuFadeInTotalTime;
		if(menuFadeAnimationProgress>=1){
			FadeInPlaying=false;
            if(exitButton.stateDisabled)
            {
                exitButton.stateDisabled=false;
                creditsButton.stateDisabled=false;
                centerButton.stateDisabled=false;
                backButton.stateDisabled=false;
                purchaseButton.stateDisabled=false;
                for (i = 0; i < 10; i++)
                {
                    MainTabButtons[i].stateDisabled=false;
                    SubTabButtons[i].stateDisabled=false;
                    VehicleTabButtons[i].stateDisabled=false;
                }
            }
        }
    }

    if(fadeOutPlaying)
    {
        menuFadeAnimationProgress = (currentTime - menuFadeStartTime) / menuFadeOutTotalTime;
		if(menuFadeAnimationProgress>=1)
		{
			fadeOutPlaying=false;
		}
    }
	
	// Submenu animations
	if(submenuFadeInPlaying)
	{
		submenuFadeAnimationProgress = (currentTime - submenuFadeStartTime) / menuFadeInTotalTime;
		if(submenuFadeAnimationProgress >= 1)
			submenuFadeInPlaying = false;
	}
	
	if(submenuFadeOutPlaying)
	{
		submenuFadeAnimationProgress = (currentTime - submenuFadeStartTime) / menuFadeOutTotalTime;
		if(submenuFadeAnimationProgress >= 1)
		{
			submenuFadeOutPlaying = false;
		}
	}
	
	// Vehicle menu animations
	if(vehicleMenuFadeInPlaying)
	{
		vehicleMenuFadeAnimationProgress = (currentTime - vehicleMenuFadeStartTime) / menuFadeInTotalTime;
		if(vehicleMenuFadeAnimationProgress >= 1)
			vehicleMenuFadeInPlaying = false;
	}
	
	if(vehicleMenuFadeOutPlaying)
	{
		vehicleMenuFadeAnimationProgress = (currentTime - vehicleMenuFadeStartTime) / menuFadeOutTotalTime;
		if(vehicleMenuFadeAnimationProgress >= 1)
		{
			vehicleMenuFadeOutPlaying = false;
		}
	}

	if(firstDrawerfadeInPlaying)
	{
	    firstDrawerFadeAnimationProgress = (currentTime - firstDrawerFadeStartTime) / firstDrawerFadeInTotalTime;
	    if(firstDrawerFadeAnimationProgress >= 1)
	        firstDrawerfadeInPlaying = false;
	}

	if(firstDrawerfadeOutPlaying)
	{
	    firstDrawerFadeAnimationProgress = (currentTime - firstDrawerFadeStartTime) / firstDrawerFadeOutTotalTime;
	    if(firstDrawerFadeAnimationProgress >= 1)
	        firstDrawerfadeOutPlaying = false;
	}

	if(secondDrawerfadeInPlaying)
	{
	    secondDrawerFadeAnimationProgress = (currentTime - secondDrawerFadeStartTime) / secondDrawerFadeInTotalTime;
	    if(secondDrawerFadeAnimationProgress >= 1)
	        secondDrawerfadeInPlaying = false;
	}

	if(secondDrawerfadeOutPlaying)
	{
	    secondDrawerFadeAnimationProgress = (currentTime - secondDrawerFadeStartTime) / secondDrawerFadeOutTotalTime;
	    if(secondDrawerFadeAnimationProgress >= 1)
	        secondDrawerfadeOutPlaying = false;
	}

	if(chatLogFadeInPlaying)
	{
	    chatLogFadeAnimationProgress = (currentTime - chatLogFadeStartTime) / chatLogFadeInTotalTime;
	    if(chatLogFadeAnimationProgress >= 1)
	        chatLogFadeInPlaying = false;
	}
}


function Draw()
{
	local int i,column;
	local vector2d BasePosition,TabsBasePositionCurrent,TabsBasePositionPrevious,CurrentPosition,CurrentVehiclePosition,PreviousPosition,ExitButtonPosition,BackButtonPosition,CenterButtonPosition,CreditsButtonPosition,PurchaseButtonPosition;
	local array<PTMenuBlockCanvas> currentMenuBlock;
	local int teamNum;
	local array<PTVehicleBlockCanvas> currentVehicleMenuBlock;
	local vector2d VehiclePosition;
	local int vehRow;
	if(!bEnabled)
	{
		return;
	}

	UpdateDummyLookAt();

	if(RotatingDummy && DummyPawn != none){
		//last - current
		MouseRotationIncrement = LastCursorXPosition - MousePosition.X;
		//difference used on rotation
		RotateDummyPawn(DummyPawn.Rotation.Yaw + ( MouseRotationIncrement ) );
	}

	TeamNum = rxPC.GetTeamNum();
	RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);
	RenXHud.Canvas.Font = Font'RX_HUD_Canvas.pt_menu.ArenaCondensedBold';
	//Base positions
    BasePosition.X = (RenxHud.Canvas.SizeX/2);
    BasePosition.Y = (RenxHud.Canvas.SizeY/2);

	TabsBasePositionCurrent.X = BasePosition.X+(TabsBasePositionOffsetX*ResScaleY);
	TabsBasePositionCurrent.Y = BasePosition.Y+(TabsBasePositionOffsetY*ResScaleY);

	TabsBasePositionPrevious.X = BasePosition.X+(TabsBasePositionOffsetX*ResScaleY);
	TabsBasePositionPrevious.Y = BasePosition.Y+(TabsBasePositionOffsetY*ResScaleY);

	VehiclePosition.X = BasePosition.X+(VehicleTabsBasePositionOffsetX*ResScaleY);
	VehiclePosition.Y = BasePosition.Y+(VehicleTabsBasePositionOffsetY*ResScaleY);	
	// Apply appropriate animations based on menu state
	if(currentMenuState == 0) // Main menu
	{
	    if(fadeInPlaying)
	    {
	        // Check if we're returning from a submenu or opening fresh
	        if(previousMenuState == 1 || previousMenuState == 3)
	        {
	            // Returning from submenu
	            // Main menu coming in from RIGHT
	            TabsBasePositionCurrent.X += (RenxHud.Canvas.SizeX - TabsBasePositionCurrent.X) * (1 - menuFadeAnimationProgress);
	            // Submenu going out to RIGHT (animate it too!)
	            if(submenuFadeOutPlaying)
	            {
	                TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) * submenuFadeAnimationProgress;
	            }
	            else
	            {
	                TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY); // Keep submenu offscreen right if not animating
	            }

				//Vehicle stay up
				VehiclePosition.Y -= (TabsBasePositionCurrent.Y + vehiclesAnimationPaddingY*ResScaleY) * 1;	
	        }
	        else
	        {
	            // Initial open - come from RIGHT
	            TabsBasePositionCurrent.X += (RenxHud.Canvas.SizeX - TabsBasePositionCurrent.X) * (1 - menuFadeAnimationProgress);
	            TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY); // Keep submenu offscreen right

				if(vehicleMenuFadeOutPlaying)
	    		{
	    		    // Vehicles going up to top
	    		    VehiclePosition.Y -= (TabsBasePositionCurrent.Y + vehiclesAnimationPaddingY*ResScaleY) * vehicleMenuFadeAnimationProgress;
	    		}
				else
				{
					//Vehicle stay up
					VehiclePosition.Y -= (TabsBasePositionCurrent.Y + vehiclesAnimationPaddingY*ResScaleY) * 1;	
				}
	        }
	    }
	    else if(fadeOutPlaying)
	    {
	        // Going to submenu - main menu goes RIGHT
	        TabsBasePositionCurrent.X += (RenxHud.Canvas.SizeX - TabsBasePositionCurrent.X) * menuFadeAnimationProgress;
	        TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY); // Keep submenu offscreen right
	    }
	    else
	    {
	        // Main menu is visible at normal position, submenu is off-screen RIGHT
	        TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY);

			// Vehicles are offscreen
	    	VehiclePosition.Y -= (TabsBasePositionCurrent.Y + vehiclesAnimationPaddingY*ResScaleY);
	    }
	}
	else if(currentMenuState == 1 || currentMenuState == 3) // Submenu (Classes or Items)
	{
	    if(submenuFadeInPlaying)
	    {
	        // Submenu coming in from RIGHT
	        TabsBasePositionCurrent.X += (RenxHud.Canvas.SizeX - TabsBasePositionCurrent.X) * (1 - submenuFadeAnimationProgress);
	        // Main menu fading out to RIGHT (if still animating)
	        if(fadeOutPlaying)
	        {
	            TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) * menuFadeAnimationProgress;
	        }
	        else
	        {
	            TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY); // Keep main menu off-screen RIGHT
	        }
	    }
	    else if(submenuFadeOutPlaying)
	    {
	        // Submenu going TO RIGHT
	        TabsBasePositionCurrent.X += (RenxHud.Canvas.SizeX - TabsBasePositionCurrent.X) * submenuFadeAnimationProgress;
	        // Main menu stays off-screen RIGHT
	        TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY);
	    }
	    else
	    {
	        // Submenu is visible at normal position, main menu is off-screen RIGHT
	        TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY);
	    }
	}
	else if(currentMenuState == 2) // Vehicles
	{
	    if(vehicleMenuFadeInPlaying)
	    {
	        // Vehicles coming down from top
	        VehiclePosition.Y -= (VehiclePosition.Y + vehiclesAnimationPaddingY*ResScaleY) * (1 - vehicleMenuFadeAnimationProgress);
	        // Main menu fading out to RIGHT (if still animating)
	        if(fadeOutPlaying)
	        {
	            TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) * menuFadeAnimationProgress;
	        }
	        else
	        {
	            TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY); // Keep main menu offscreen right
	        }
	    }
	    else
	    {
	        // Vehicle menu is visible, keep main menu off-screen right
	        TabsBasePositionPrevious.X += (RenxHud.Canvas.SizeX - TabsBasePositionPrevious.X) + (TabOffscreenPaddingX * ResScaleY);
	    }
	}
	CurrentPosition=TabsBasePositionCurrent;
	PreviousPosition=TabsBasePositionPrevious;
	CurrentVehiclePosition=VehiclePosition;
	column=0;

	switch(currentMenuState) {
		case 0://Main menu
			currentmenuBlock=TeamNum==0?GDIMainMenuData:NodMainMenuData;
			currentVehicleMenuBlock.Length=0;
			break;
		case 1://Classes
			currentmenuBlock=TeamNum==0?GDIClassMenuData:NodClassMenuData;
			currentVehicleMenuBlock.Length=0;
			break;
		case 2://Vehicles
			currentmenuBlock.Length=0;
			currentVehicleMenuBlock=TeamNum==0?GDIVehicleMenuData:NodVehicleMenuData;
			break;
		case 3://Item
			currentmenuBlock=TeamNum==0?GDIItemMenuData:NodItemMenuData;
			currentVehicleMenuBlock.Length=0;
			break;
	}

switch(currentMenuState) {
    case 0://Main menu
        for (i = 0; i < 10; i++)
        {
            if(currentmenuBlock.Length!=0 && i<currentmenuBlock.Length){
                MainTabButtons[i].bEnabled=true;
                MainTabButtons[i].menuType = int(currentMenuBlock[i].BlockType);
                MainTabButtons[i].PTIconTexture = Texture2D(currentMenuBlock[i].PTIconTexture);
                MainTabButtons[i].hotkey = currentMenuBlock[i].hotkey;
                MainTabButtons[i].title = currentMenuBlock[i].title;
                MainTabButtons[i].desc = currentMenuBlock[i].desc;
                MainTabButtons[i].cost = currentMenuBlock[i].cost;
                MainTabButtons[i].type = currentMenuBlock[i].type;
                MainTabButtons[i].damage = currentMenuBlock[i].damage;
                MainTabButtons[i].range = currentMenuBlock[i].range;
                MainTabButtons[i].rateOfFire = currentMenuBlock[i].rateOfFire;
                MainTabButtons[i].magCap = currentMenuBlock[i].magCap;
                MainTabButtons[i].factoryName = rxPurchaseSystem.GetFactoryDescriptionCanvas(TeamID, currentMenuBlock[i].title, rxPC,0);
                MainTabButtons[i].factoryStatus = rxPurchaseSystem.GetFactoryDescriptionCanvas(TeamID, currentMenuBlock[i].title, rxPC,1);
                MainTabButtons[i].factorySubtext = rxPurchaseSystem.GetFactoryDescriptionCanvas(TeamID, currentMenuBlock[i].title, rxPC,2);
				MainTabButtons[i].factoryName2 = rxPurchaseSystem.GetFactoryDescriptionCanvas(TeamID, currentMenuBlock[i].title, rxPC,3);
                MainTabButtons[i].factoryStatus2 = rxPurchaseSystem.GetFactoryDescriptionCanvas(TeamID, currentMenuBlock[i].title, rxPC,4);
                MainTabButtons[i].ButtonIndex=i;
                MainTabButtons[i].OnButtonClickedWithIndex=MainPtButtonClicked;
                
                if(currentMenuBlock[i].title=="VEHICLES")
                    MainTabButtons[i].toprightLabel = "( "$ Rx_TeamInfo(rxPRI.Team).GetVehicleCount() $ " )";
                
                // Handle VEHICLES button state
                if(currentMenuBlock[i].title=="VEHICLES")
                {
                    if(rxPurchaseSystem.AreVehiclesDisabled(TeamID, rxPC) && !Rx_GRI(rxPC.WorldInfo.GRI).bAirdropsEnabled)
                    {
                        MainTabButtons[i].deActivateButton();
                    }
                    else
                    {
                        MainTabButtons[i].ActivateButtonStates();
                    }
                }
                // Handle REFILL button state
                else if(currentMenuBlock[i].title=="REFILL")
                {
                    if(rxPC.RefillCooldown() > 0)
                    {
                        MainTabButtons[i].deActivateButton();
                    }
                    else
                    {
                        MainTabButtons[i].ActivateButtonStates();
                    }
                }
            }
            else{
                MainTabButtons[i].bEnabled=false;
            }
        }
    break;

    case 1://Classes
        for (i = 0; i < 10; i++)
        {
            if(currentmenuBlock.Length!=0 && i<currentmenuBlock.Length){
                SubTabButtons[i].bEnabled=!rxPurchaseSystem.AreHighTierPayClassesDisabled(TeamID) || i <= 2;
                SubTabButtons[i].menuType = int(currentMenuBlock[i].BlockType);
                SubTabButtons[i].PTIconTexture = Texture2D(currentMenuBlock[i].PTIconTexture);
                SubTabButtons[i].hotkey = currentMenuBlock[i].hotkey;
                SubTabButtons[i].title = currentMenuBlock[i].title;
                SubTabButtons[i].desc = currentMenuBlock[i].desc;
                SubTabButtons[i].cost = currentMenuBlock[i].cost;
                SubTabButtons[i].type = currentMenuBlock[i].type;
                SubTabButtons[i].damage = currentMenuBlock[i].damage;
                SubTabButtons[i].range = currentMenuBlock[i].range;
                SubTabButtons[i].rateOfFire = currentMenuBlock[i].rateOfFire;
                SubTabButtons[i].magCap = currentMenuBlock[i].magCap;
                SubTabButtons[i].ButtonIndex=i;
                SubTabButtons[i].OnButtonClickedWithIndex=SubPtButtonClicked;
                
                // Handle class button state based on credits
                PlayerCredits < rxPurchaseSystem.GetClassPrice(TeamID, IndexToClass(i+5, TeamID)) ? SubTabButtons[i].deActivateButton() : SubTabButtons[i].ActivateButtonStates();
            }
            else{
                SubTabButtons[i].bEnabled=false;
            }
        }
    break;

    case 2://Vehicles
        for (i = 0; i < 10; i++)
        {
            if(currentVehicleMenuBlock.Length!=0 && i<currentVehicleMenuBlock.Length){
                VehicleTabButtons[i].bEnabled=currentVehicleMenuBlock[i].bEnable;
                VehicleTabButtons[i].menuType = int(currentVehicleMenuBlock[i].BlockType);
                VehicleTabButtons[i].PTIconTexture = Texture2D(currentVehicleMenuBlock[i].PTIconTexture);
                VehicleTabButtons[i].hotkey = currentVehicleMenuBlock[i].hotkey;
                VehicleTabButtons[i].title = currentVehicleMenuBlock[i].title;
                VehicleTabButtons[i].desc = currentVehicleMenuBlock[i].desc;
                VehicleTabButtons[i].cost = currentVehicleMenuBlock[i].cost;
                VehicleTabButtons[i].type = 0;
                VehicleTabButtons[i].damage = 0;
                VehicleTabButtons[i].range = 0;
                VehicleTabButtons[i].rateOfFire = 0;
                VehicleTabButtons[i].magCap = 0;
                VehicleTabButtons[i].ButtonIndex=i;
                VehicleTabButtons[i].OnButtonClickedWithIndex=VehiclePtButtonClicked;
                
                // Update cost with airdrop consideration
                VehicleTabButtons[i].cost = string(rxPurchaseSystem.GetVehiclePricesSafe(TeamID, currentVehicleMenuBlock[i].ID, rxPurchaseSystem.AirdropAvailable(rxPRI)));
                
                // Handle vehicle button states
                if(rxPurchaseSystem.AreVehiclesDisabled(TeamID, rxPC))
                {
                    // All vehicles disabled
                    VehicleTabButtons[i].deActivateButton();
                }
                else if((rxPurchaseSystem.AreHighTierVehiclesDisabled(TeamID) && i > 1 && !currentVehicleMenuBlock[i].bAircraft)
                        || (rxPurchaseSystem.AreAirVehiclesDisabled(TeamID) && currentVehicleMenuBlock[i].bAircraft))
                {
                    // High-tier or air vehicles disabled
                    VehicleTabButtons[i].deActivateButton();
                }
                else if(rxBuildingOwner.AreAircraftDisabled() && currentVehicleMenuBlock[i].bAircraft)
                {
                    // Aircraft disabled by building
                    VehicleTabButtons[i].deActivateButton();
					VehicleTabButtons[i].bEnabled=false;
                }
                else if(PlayerCredits < rxPurchaseSystem.GetVehiclePricesSafe(TeamID, currentVehicleMenuBlock[i].ID, rxPurchaseSystem.AirdropAvailable(rxPRI)))
                {
                    // Not enough credits
                    VehicleTabButtons[i].deActivateButton();
                }
                else
                {
                    // Vehicle is available
                    VehicleTabButtons[i].ActivateButtonStates();
                }
            }
            else{
                VehicleTabButtons[i].bEnabled=false;
            }
        }
    break;

    case 3://Item
        for (i = 0; i < 10; i++)
        {
            if(currentmenuBlock.Length!=0 && i<currentmenuBlock.Length && currentMenuBlock[i].bEnable){
                SubTabButtons[i].bEnabled=true;
                SubTabButtons[i].menuType = int(currentMenuBlock[i].BlockType);
                SubTabButtons[i].PTIconTexture = Texture2D(currentMenuBlock[i].PTIconTexture);
                SubTabButtons[i].hotkey = currentMenuBlock[i].hotkey;
                SubTabButtons[i].title = currentMenuBlock[i].title;
                SubTabButtons[i].desc = currentMenuBlock[i].desc;
                SubTabButtons[i].desc2 = currentMenuBlock[i].desc2;
                SubTabButtons[i].cost = currentMenuBlock[i].cost;
                SubTabButtons[i].type = currentMenuBlock[i].type;
                SubTabButtons[i].damage = 0;
                SubTabButtons[i].range = 0;
                SubTabButtons[i].rateOfFire = 0;
                SubTabButtons[i].magCap = 0;
                SubTabButtons[i].ButtonIndex=i;
                SubTabButtons[i].OnButtonClickedWithIndex=ItemPtButtonClicked;

                // Handle item button state
                if (rxPurchaseSystem.IsItemBuyable(rxPC, TeamID, i) && PlayerCredits > rxPurchaseSystem.GetItemPrices(TeamID, i) && !rxPurchaseSystem.IsEquiped(rxPC, TeamID, i, CLASS_ITEM))
                {
                    SubTabButtons[i].ActivateButtonStates();
                } 
                else 
                {
                    SubTabButtons[i].deActivateButton();
                    if(ClassIsChildOf(rxPurchaseSystem.GetItemClass(TeamID,i),class'Rx_Weapon_Beacon') && !Rx_Gri(rxPC.WorldInfo.GRI).bEnableNuke)
                    {
                        SubTabButtons[i].desc = Rx_GRI(rxPC.WorldInfo.Gri).MinPlayersForNukes $ " Players needed";
                    }
                }
            }
            else{
                SubTabButtons[i].bEnabled=false;
            }
        }
    break;
}

	vehRow=0;
	// Draw the appropriate buttons based on menu state
	switch(currentMenuState) {
	    case 0://Main menu
	        for (i = 0; i < 10; i++)
	        {
	            MainTabButtons[i].SetPosition(CurrentPosition.X, CurrentPosition.Y, 0, 0, true);
	            SubTabButtons[i].SetPosition(PreviousPosition.X, PreviousPosition.Y, 0, 0, true);
				VehicleTabButtons[i].SetPosition(CurrentVehiclePosition.X, CurrentVehiclePosition.Y, 0, 0, true);
	
	            if(column==0){
	                CurrentPosition.X+=TabXSpacing*ResScaleY;
	                PreviousPosition.X+=TabXSpacing*ResScaleY;  

	                column=1;
	            }else
	            {
	                CurrentPosition.Y+=TabYSpacing*ResScaleY;
	                CurrentPosition.X=TabsBasePositionCurrent.X;
	                PreviousPosition.Y+=TabYSpacing*ResScaleY;  
	                PreviousPosition.X=TabsBasePositionPrevious.X;  
	                column=0;
	            }
				vehRow++;
				if(i==0 || vehRow!=4)
				{
					CurrentVehiclePosition.X+=VehicleTabXSpacing*ResScaleY;
				}else
				{
					CurrentVehiclePosition.Y+=VehicleTabYSpacing*ResScaleY;  
	                CurrentVehiclePosition.X=VehiclePosition.X;  
					vehRow=0;
				}
	        }
	        break;

	    case 1://Classes
	        for (i = 0; i < 10; i++)
	        {
	            MainTabButtons[i].SetPosition(PreviousPosition.X, PreviousPosition.Y, 0, 0, true);
	            SubTabButtons[i].SetPosition(CurrentPosition.X, CurrentPosition.Y, 0, 0, true);
	
	            if(column==0){
	                CurrentPosition.X+=TabXSpacing*ResScaleY;
	                PreviousPosition.X+=TabXSpacing*ResScaleY;  
	                column=1;
	            }else
	            {
	                CurrentPosition.Y+=TabYSpacing*ResScaleY;
	                CurrentPosition.X=TabsBasePositionCurrent.X;
	                PreviousPosition.Y+=TabYSpacing*ResScaleY;  
	                PreviousPosition.X=TabsBasePositionPrevious.X;  
	                column=0;
	            }
	        }
	        break;

		case 2://Vehicles
		    for (i = 0; i < 10; i++)
		    {
		        // Always position main menu buttons off-screen
		        MainTabButtons[i].SetPosition(PreviousPosition.X, PreviousPosition.Y, 0, 0, true);

		        // Only position vehicle buttons if they're enabled
		        if(i < VehicleTabButtons.Length && VehicleTabButtons[i].bEnabled)
		        {
		            VehicleTabButtons[i].SetPosition(CurrentVehiclePosition.X, CurrentVehiclePosition.Y, 0, 0, true);
		        }

		        // Update positions for next iteration
		        if(column==0){
		            CurrentPosition.X+=TabXSpacing*ResScaleY;
		            PreviousPosition.X+=TabXSpacing*ResScaleY;  
		            column=1;
		        }else
		        {
		            CurrentPosition.Y+=TabYSpacing*ResScaleY;
		            CurrentPosition.X=TabsBasePositionCurrent.X;
		            PreviousPosition.Y+=TabYSpacing*ResScaleY;  
		            PreviousPosition.X=TabsBasePositionPrevious.X;  
		            column=0;
		        }
		        vehRow++;
		        if(i==0 || vehRow!=4)
		        {
		            CurrentVehiclePosition.X+=VehicleTabXSpacing*ResScaleY;
		        }else
		        {
		            CurrentVehiclePosition.Y+=VehicleTabYSpacing*ResScaleY;  
		            CurrentVehiclePosition.X=VehiclePosition.X;  
		            vehRow=0;
		        }
		    }
		    break;
	    case 3://Item
	        for (i = 0; i < 10; i++)
	        {
	            MainTabButtons[i].SetPosition(PreviousPosition.X, PreviousPosition.Y, 0, 0, true);
	            SubTabButtons[i].SetPosition(CurrentPosition.X, CurrentPosition.Y, 0, 0, true);
	
	            if(column==0){
	                CurrentPosition.X+=TabXSpacing*ResScaleY;
	                PreviousPosition.X+=TabXSpacing*ResScaleY;  
	                column=1;
	            }else
	            {
	                CurrentPosition.Y+=TabYSpacing*ResScaleY;
	                CurrentPosition.X=TabsBasePositionCurrent.X;
	                PreviousPosition.Y+=TabYSpacing*ResScaleY;  
	                PreviousPosition.X=TabsBasePositionPrevious.X;  
	                column=0;
	            }
	        }
	        break;
	}

	for (i = 0; i < MainTabButtons.Length; i++)
	{
	    MainTabButtons[i].Draw();
	}

	for (i = 0; i < SubTabButtons.Length; i++)
	{
	    SubTabButtons[i].Draw();
	}

	// Draw vehicle buttons separately since they have their own array
	for (i = 0; i < VehicleTabButtons.Length; i++)
	{
	    VehicleTabButtons[i].Draw();
	}
	RenxHud.Canvas.SetDrawColor(255, 255, 255, 255);

	// Calculate base button positions
	ExitButtonPosition.X = BasePosition.X + (ExitButtonPositionOffsetX * ResScaleY);
	ExitButtonPosition.Y = BasePosition.Y + (ExitButtonPositionOffsetY * ResScaleY);
	
	BackButtonPosition.X = BasePosition.X + (BackButtonPositionOffsetX * ResScaleY);
	BackButtonPosition.Y = BasePosition.Y + (BackButtonPositionOffsetY * ResScaleY);
	
	CenterButtonPosition.X = BasePosition.X + (CenterButtonPositionOffsetX * ResScaleY);
	CenterButtonPosition.Y = BasePosition.Y + (CenterButtonPositionOffsetY * ResScaleY);
	
	CreditsButtonPosition.X = BasePosition.X + (CreditsButtonPositionOffsetX * ResScaleY);
	CreditsButtonPosition.Y = BasePosition.Y + (CreditsButtonPositionOffsetY * ResScaleY);
	
	PurchaseButtonPosition.X = BasePosition.X + (PurchaseButtonPositionOffsetX * ResScaleY);
	PurchaseButtonPosition.Y = BasePosition.Y + (PurchaseButtonPositionOffsetY * ResScaleY);

	// Apply first drawer animation (Exit, Credits, Purchase buttons)
	if(firstDrawerfadeInPlaying)
	{
	    ExitButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - ExitButtonPosition.Y) * (1 - firstDrawerFadeAnimationProgress);
	    CreditsButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CreditsButtonPosition.Y) * (1 - firstDrawerFadeAnimationProgress);
	    PurchaseButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - PurchaseButtonPosition.Y) * (1 - firstDrawerFadeAnimationProgress);
	}

	/*if(firstDrawerfadeOutPlaying)//Should never play!
	{
	    //ExitButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - ExitButtonPosition.Y) * firstDrawerFadeAnimationProgress;
	    CreditsButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CreditsButtonPosition.Y) * firstDrawerFadeAnimationProgress;
	    PurchaseButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - PurchaseButtonPosition.Y) * firstDrawerFadeAnimationProgress;
	}*/

	// Apply second drawer animation (Back and Center buttons)
	if(secondDrawerfadeInPlaying)
	{
	    BackButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - BackButtonPosition.Y) * (1 - secondDrawerFadeAnimationProgress);
	    
		//Only fade in the center button if relevant
		if(currentMenuState==2)
		{
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * (1 - secondDrawerFadeAnimationProgress);
		}
		else
		{
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * 1;
		}

	}else if(secondDrawerfadeOutPlaying)
	{
	    BackButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - BackButtonPosition.Y) * secondDrawerFadeAnimationProgress;
		if(previousMenuState==2)
		{
	    	CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * secondDrawerFadeAnimationProgress;
		}
		else
		{
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * 1;
		}
	} else{
			switch(currentMenuState) {
		case 0://Main menu
			BackButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - BackButtonPosition.Y) * 1;
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * 1;
			break;
		case 1://Classes
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * 1;
			break;
		case 2://Vehicles
			//Do nothing both buttons are visible
			break;
		case 3://Item
			CenterButtonPosition.Y += (RenxHud.Canvas.SizeY+bottomBarPadding*ResScaleY - CenterButtonPosition.Y) * 1;
			break;
	}

	}

	ExitButton.buttonTextOffsetX=-40;
	BackButton.buttonTextOffsetX=-50;
	centerButton.buttonTextOffsetX=-160;
	CreditsButton.buttonTextOffsetX=0;
	purchaseButton.buttonTextOffsetX=-35;
	
	ExitButton.buttonhotkeyOffsetX=12;
	backButton.buttonhotkeyOffsetX=20;

	purchaseButton.buttonhotkeyOffsetX=35;

	ExitButton.setTextScale(0.55,0.55,true);
	backButton.setTextScale(0.55,0.55,true);
	centerButton.setTextScale(0.55,0.55,true);
	creditsButton.setTextScale(0.55,0.55,true);
	purchaseButton.setTextScale(0.55,0.55,true);

	ExitButton.HotkeyScale=0.43;
	BackButton.HotkeyScale=0.40;
	purchaseButton.HotkeyScale=0.44;

	switch(currentMenuState) {
		case 0://Main menu
			//ExitButton.SetPosition(ExitButtonPosition.X, ExitButtonPosition.Y, 0, 0, true);
			ExitButton.setGlobalText("Exit ");
			ExitButton.hotkey= "[ Escape ]";
			//ExitButton.Draw();

			//CreditsButton.SetPosition(CreditsButtonPosition.X, CreditsButtonPosition.Y, 0, 0, true);
			CreditsButton.setGlobalText("Credits: " $ int(rxPRI.GetCredits()));
			//CreditsButton.Draw();

			//PurchaseButton.SetPosition(PurchaseButtonPosition.X, PurchaseButtonPosition.Y, 0, 0, true);
			PurchaseButton.setGlobalText("Purchase ");
			PurchaseButton.hotkey= "[ Enter ]";
			//PurchaseButton.Draw();
			break;
		case 1://Classes
			//ExitButton.SetPosition(ExitButtonPosition.X, ExitButtonPosition.Y, 0, 0, true);
			ExitButton.setGlobalText("Exit ");
			ExitButton.hotkey= "[ Escape ]";
			//ExitButton.Draw();

			//BackButton.SetPosition(BackButtonPosition.X, BackButtonPosition.Y, 0, 0, true);
			BackButton.setGlobalText("Back ");
			BackButton.hotkey= "[ Back Space ]";
			//BackButton.Draw();

			//CreditsButton.SetPosition(CreditsButtonPosition.X, CreditsButtonPosition.Y, 0, 0, true);
			CreditsButton.setGlobalText("Credits: " $ int(rxPRI.GetCredits()));
			//CreditsButton.Draw();

			//PurchaseButton.SetPosition(PurchaseButtonPosition.X, PurchaseButtonPosition.Y, 0, 0, true);
			PurchaseButton.setGlobalText("Purchase ");
			PurchaseButton.hotkey= "[ Enter ]";
			//PurchaseButton.Draw();
			break;
		case 2://Vehicles
			//ExitButton.SetPosition(ExitButtonPosition.X, ExitButtonPosition.Y, 0, 0, true);
			ExitButton.setGlobalText("Exit ");
			ExitButton.hotkey= "[ Escape ]";
			//ExitButton.Draw();

			//BackButton.SetPosition(BackButtonPosition.X, BackButtonPosition.Y, 0, 0, true);
			BackButton.setGlobalText("Back ");
			BackButton.hotkey= "[ Back Space ]";
			//BackButton.Draw();

			//centerButton.SetPosition(CenterButtonPosition.X, CenterButtonPosition.Y, 0, 0, true);
			centerButton.setGlobalText("Vehicles: " $ VehicleCount $" / " $ Rx_TeamInfo(rxPRI.Team).VehicleLimit);
			//centerButton.Draw();

			//CreditsButton.SetPosition(CreditsButtonPosition.X, CreditsButtonPosition.Y, 0, 0, true);
			CreditsButton.setGlobalText("Credits: " $ int(rxPRI.GetCredits()));
			//CreditsButton.Draw();

			//PurchaseButton.SetPosition(PurchaseButtonPosition.X, PurchaseButtonPosition.Y, 0, 0, true);
			PurchaseButton.setGlobalText("Purchase ");
			PurchaseButton.hotkey= "[ Enter ]";
			//PurchaseButton.Draw();
			break;
		case 3://Item
			//ExitButton.SetPosition(ExitButtonPosition.X, ExitButtonPosition.Y, 0, 0, true);
			ExitButton.setGlobalText("Exit ");
			ExitButton.hotkey= "[ Escape ]";
			//ExitButton.Draw();

			//BackButton.SetPosition(BackButtonPosition.X, BackButtonPosition.Y, 0, 0, true);
			BackButton.setGlobalText("Back ");
			BackButton.hotkey= "[ Back Space ]";
			//BackButton.Draw();

			//CreditsButton.SetPosition(CreditsButtonPosition.X, CreditsButtonPosition.Y, 0, 0, true);
			CreditsButton.setGlobalText("Credits: " $ int(rxPRI.GetCredits()));
			//CreditsButton.Draw();

			//PurchaseButton.SetPosition(PurchaseButtonPosition.X, PurchaseButtonPosition.Y, 0, 0, true);
			PurchaseButton.setGlobalText("Purchase ");
			PurchaseButton.hotkey= "[ Enter ]";
			//PurchaseButton.Draw();
			break;
	}

	ExitButton.SetPosition(ExitButtonPosition.X, ExitButtonPosition.Y, 0, 0, true);
	BackButton.SetPosition(BackButtonPosition.X, BackButtonPosition.Y, 0, 0, true);
	centerButton.SetPosition(CenterButtonPosition.X, CenterButtonPosition.Y, 0, 0, true);
	CreditsButton.SetPosition(CreditsButtonPosition.X, CreditsButtonPosition.Y, 0, 0, true);
	PurchaseButton.SetPosition(PurchaseButtonPosition.X, PurchaseButtonPosition.Y, 0, 0, true);

	centerButton.Draw();
	ExitButton.Draw();	
	BackButton.Draw();
	CreditsButton.Draw();
	PurchaseButton.Draw();

	ExitButton.OnButtonClicked=ClosePT;
	BackButton.OnButtonClicked=GoBackToMainMenu;
	PurchaseButton.OnButtonClicked=SelectPurchase;

	DrawChatLog();
}


function SetPurchaseSystem(Rx_PurchaseSystem inPS )
{
	rxPurchaseSystem = inPS;
}

function SetTeam(int inTeamID)
{
	TeamID    =   inTeamID;
}

function Init(Rx_Controller controller,Rx_BuildingAttachment_PT PTOwner)
{
	local int i; 
	rxPC						=	controller;
	rxHUD						=	Rx_HUD(rxPC.myHUD);
	rxBuildingOwner				=   PTOwner;
	rxPRI						=	Rx_PRI(rxPC.PlayerReplicationInfo);

	rxPC.bIsInPurchaseTerminal	=   true;
	rxHUD.bShowHUD				=   false;
	rxHUD.bCrosshairShow        =   false;
	OwnedFamilyInfo = Rx_Pawn(RxPC.Pawn).GetRxFamilyInfo();
	currentlySelectedButtonIndex=-1;


	SetupPTDummyActor();
	GetMapUnitData();


	if (MainTabButtons.Length == 0)
    {
        // Create a tab button for each tab in the Tabs array
        for (i = 0; i < 10; i++)
        {
            tempButton = new class'Rx_Hud_PT_Main_Button';
            //tempButton.OnButtonClickedWithIndex = OnTabButtonClicked;
            
            // Add the new button to our array
            tempButton.setGlobalText("Test");
            
            tempButton.buttonOnclickParameter = EButtonOnclickParameter.selectionIndex;
            tempButton.ButtonIndex = i;
            tempButton.Init(RenxHud);
            tempButton.stateDisabled=true;
            MainTabButtons.AddItem(tempButton);
        }

		for (i = 0; i < 10; i++)
        {
            tempButton = new class'Rx_Hud_PT_Main_Button';
            //tempButton.OnButtonClickedWithIndex = OnTabButtonClicked;
            
            // Add the new button to our array
            tempButton.setGlobalText("Test");
            
            tempButton.buttonOnclickParameter = EButtonOnclickParameter.selectionIndex;
            tempButton.ButtonIndex = i;
            tempButton.Init(RenxHud);
            tempButton.stateDisabled=true;
            SubTabButtons.AddItem(tempButton);
        }

		for (i = 0; i < 10; i++)
        {
            temp2button = new class'Rx_Hud_PT_Main_Vehicle_Button';
            //tempButton.OnButtonClickedWithIndex = OnTabButtonClicked;
            
            // Add the new button to our array
            temp2button.setGlobalText("Test");
            
            temp2button.buttonOnclickParameter = EButtonOnclickParameter.selectionIndex;
            temp2button.ButtonIndex = i;
            temp2button.Init(RenxHud);
            temp2Button.stateDisabled=true;
            VehicleTabButtons.AddItem(temp2button);
        }

		exitButton = new class'Rx_Hud_PT_Left_Button';
		exitButton.Init(RenxHud);
		creditsButton = new class'Rx_Hud_PT_Left_Button';
		creditsButton.Init(RenxHud);	
		centerButton = new class'Rx_Hud_PT_Center_Button';
		centerButton.Init(RenxHud);
		backButton = new class'Rx_Hud_PT_Right_Button';
		backButton.Init(RenxHud);
		purchaseButton = new class'Rx_Hud_PT_Right_Button';
		purchaseButton.Init(RenxHud);

        exitButton.stateDisabled=true;
        creditsButton.stateDisabled=true;
        centerButton.stateDisabled=true;
        backButton.stateDisabled=true;
        purchaseButton.stateDisabled=true;
    }

    for (i = 0; i < 10; i++)
    {
		MainTabButtons[i].currentlySelected=false;
        SubTabButtons[i].currentlySelected=false;
        VehicleTabButtons[i].currentlySelected=false;
    }
}

function OpenPT()
{
	bEnabled=true;
	rxHUD.SetInputCursorActive(true);
	rxHUD.RxCursor.bEnabled=true;
	currentMenuState=0;
	previousMenuState=0;
	StartMenuFadeIn();
	StartFirstDrawerFadeIn();
	StartChatLogFadeIn();
}

function ClosePT()
{
	bEnabled=false;
	rxPC.bIsInPurchaseTerminal = false;
	rxPC.bIsInPurchaseTerminalVehicleSection = false;
	rxHUD.bShowHUD				=   true;
	rxHUD.SetInputCursorActive(false);
	if (DummyPawn != none) {
		DummyPawn.SetHidden(true);
		DummyPawn.Destroy();
		DummyPawn = none;  
	}
	if (DummyVehicle != none) {
		DummyVehicle.SetHidden(true);
		DummyVehicle.Destroy();
		DummyVehicle = none;  
	}
	if (rxBuildingOwner != none) {
		rxBuildingOwner.StopCreditTick();
		rxBuildingOwner.StopInsufCreditsTimeout();
	}
	currentMenuState=0;
	previousMenuState=0;
	rxHUD.RxCursor.bEnabled=false;
	currentlySelectedButtonIndex=-1;
}

// New function to handle going back to main menu
function GoBackToMainMenu()
{
	previousMenuState = currentMenuState;
	currentMenuState = 0;
	currentlySelectedButtonIndex = -1;
	
	// Reset selections
	ResetButtonSelections();
	
	// Start animations
	if(previousMenuState == 2)
	{
		StartVehicleMenuFadeOut();
		StartMenuFadeIn();
		StartSecondDrawerFadeOut();
	}
	else
	{
    	StartSubmenuFadeOut();
    	StartMenuFadeIn();  
    	StartSecondDrawerFadeOut();
	}
	StartSecondDrawerFadeOut();
	

	rxPC.bIsInPurchaseTerminalVehicleSection = false;
	// Show appropriate dummy model
	DummyPawn.SetHidden(false);
	DummyVehicle.SetHidden(true);
	
	// Reset to default character
	DummyPawn.SetCharacterClassFromInfo(Rx_Pawn(rxPC.Pawn).CurrCharClassInfo);
	DummyPawn.RefreshAttachedWeapons();
}

// Reset all button selections
function ResetButtonSelections()
{
	local int i;
	for (i = 0; i < 10; i++)
	{
		MainTabButtons[i].currentlySelected = false;
		SubTabButtons[i].currentlySelected = false;
		if(i < VehicleTabButtons.Length)
			VehicleTabButtons[i].currentlySelected = false;
	}
}

// **************************************************************** //
//																	//
//						DUMMY ACTOR MANAGEMENTS 					//
//																	//
// **************************************************************** //
function SetupPTDummyActor()
{
	local vector loc;
	local rotator rot;

	if(DummyPawn == None) {
		foreach rxPC.AllActors(class'Rx_PTPlayerSpot', PawnShowcaseSpot) {
			if(PawnShowcaseSpot.TeamNum == rxPC.GetTeamNum()) {
				break;
			}	
		}
		
		loc = PawnShowcaseSpot.location;
		loc.Z += 50;
		rot = PawnShowcaseSpot.Rotation;
		//rot.Yaw += (-16384) * 2; // one1: comment this out to have original pawn rotation
		
		DummyPawn = rxPC.Spawn(class'Rx_PT_Pawn',rxPC,,loc,rot,,true);
		DummyPawn.bIsInvisible = true;
		DummyPawn.SetHidden(true); 

		//TODO:Temp placeholder
		DummyPawn.SetHidden(false);
		DummyPawn.SetCharacterClassFromInfo(Rx_Pawn(rxPC.Pawn).CurrCharClassInfo);
		DummyPawn.RefreshAttachedWeapons();
	}

	if (DummyVehicle == none) {
		foreach rxPC.AllActors(class'Rx_PTVehicleSpot', VehicleShowcaseSpot) {
			if(VehicleShowcaseSpot.TeamNum == rxPC.GetTeamNum()) {
				break;
			}	
		}
		loc = VehicleShowcaseSpot.location;
		rot = VehicleShowcaseSpot.Rotation;

		DummyVehicle = rxPC.Spawn(class'Rx_PT_Vehicle', rxPC, , loc, rot, , true);
		DummyVehicle.SetHidden(true); //it was true earlier
	}
}
/** one1: Modified. */
function ChangeDummyPawnClass(int classNum) 
{
    local class<Rx_FamilyInfo> rxCharInfo;   
	
	if (TeamID == TEAM_GDI) 
	{
	 	rxCharInfo = rxPurchaseSystem.GDIInfantryClasses[classNum];	
	} else 
	{
		rxCharInfo = rxPurchaseSystem.NodInfantryClasses[classNum];	
	}
	DummyPawn.SetHidden(false);
	DummyPawn.SetCharacterClassFromInfo(rxCharInfo);
	DummyPawn.RefreshAttachedWeapons();
}

/** one1: Modified; do not spawn new actor each roll-over, just replace skeletalmesh. */
function ChangeDummyVehicleClass (int classNum) 
{
	local class<Rx_Vehicle> vehicleClass;
		
	if (DummyVehicle == None) 
	{
		DummyVehicle = rxPC.Spawn(class'Rx_PT_Vehicle', rxPC, , VehicleShowcaseSpot.Location, VehicleShowcaseSpot.Rotation, , true);
	}
	
 	DummyVehicle.SetHidden(false);
	if(rxPC.GetTeamNum() == TEAM_GDI) {
	 	vehicleClass = rxPurchaseSystem.GDIVehicleClasses[classNum].default.VehicleClass;	
	} else {
		vehicleClass = rxPurchaseSystem.NodVehicleClasses[classNum].default.VehicleClass;	
	}	

	DummyVehicle.SetSkeletalMesh(vehicleClass.default.SkeletalMeshForPT);
}

function UpdateCursorPosition(int x, int y)
{
	local int i;
    for (i = 0; i < 10; i++)
    {
        MainTabButtons[i].UpdateCursorPosition(x,y);
        SubTabButtons[i].UpdateCursorPosition(x,y);
    }
	
	for (i = 0; i < VehicleTabButtons.Length; i++)
	{
		VehicleTabButtons[i].UpdateCursorPosition(x,y);
	}

	ExitButton.UpdateCursorPosition(x,y);
	BackButton.UpdateCursorPosition(x,y);
	centerButton.UpdateCursorPosition(x,y);
	CreditsButton.UpdateCursorPosition(x,y);
	PurchaseButton.UpdateCursorPosition(x,y);

	super.UpdateCursorPosition(x,y);
}

function checkForLeftClick(int MousePositionX,int MousePositionY)
{
	local int i;
	
	switch(currentMenuState) {
		case 0: // Main menu
			for (i = 0; i < 10; i++)
			{
				MainTabButtons[i].highlightOnClick(MousePositionX,MousePositionY);
			}
			break;
		case 1: // Classes
		case 3: // Items
			for (i = 0; i < 10; i++)
			{
				SubTabButtons[i].highlightOnClick(MousePositionX,MousePositionY);
			}
			break;
		case 2: // Vehicles
			for (i = 0; i < VehicleTabButtons.Length; i++)
			{
				VehicleTabButtons[i].highlightOnClick(MousePositionX,MousePositionY);
			}
			break;
	}

	ExitButton.highlightOnClick(MousePositionX,MousePositionY);
	BackButton.highlightOnClick(MousePositionX,MousePositionY);
	centerButton.highlightOnClick(MousePositionX,MousePositionY);
	CreditsButton.highlightOnClick(MousePositionX,MousePositionY);
	PurchaseButton.highlightOnClick(MousePositionX,MousePositionY);
}

function checkForRightClick(int MousePositionX,int MousePositionY)
{
	rxPC.PlaySound(SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundTest2_Cue');
	LastCursorXPosition = MousePosition.X;
	RotatingDummy=true;
}

function checkForLeftClickRelease(int MousePositionX,int MousePositionY)
{
	local int i;
	
	switch(currentMenuState) {
		case 0: // Main menu
			for (i = 0; i < 10; i++)
			{
				MainTabButtons[i].executeOnRelease(MousePositionX,MousePositionY);
			}
			break;
		case 1: // Classes
		case 3: // Items
			for (i = 0; i < 10; i++)
			{
				SubTabButtons[i].executeOnRelease(MousePositionX,MousePositionY);
			}
			break;
		case 2: // Vehicles
			for (i = 0; i < VehicleTabButtons.Length; i++)
			{
				VehicleTabButtons[i].executeOnRelease(MousePositionX,MousePositionY);
			}
			break;
	}

	ExitButton.executeOnRelease(MousePositionX,MousePositionY);
	BackButton.executeOnRelease(MousePositionX,MousePositionY);
	centerButton.executeOnRelease(MousePositionX,MousePositionY);
	CreditsButton.executeOnRelease(MousePositionX,MousePositionY);
	PurchaseButton.executeOnRelease(MousePositionX,MousePositionY);
}

function checkForRightClickRelease(int MousePositionX,int MousePositionY)
{
	RotatingDummy=false;
}

function OnKeyPress(name key)
{
    local int SelectedIndex;
    local int i;
    
    SelectedIndex = -1;
    
    // Handle special action keys
    switch (key)
    {
        case 'Escape':
            SetLoadout();
            ClosePT();
            return;
            
        case 'Enter':
            SelectPurchase();
            return;
            
        case 'BackSpace':
            if (currentMenuState != 0) // Not in main menu
            {
                GoBackToMainMenu();
            }
            return;
		case 'Left':
			/* one1: Added. Left arrow keys rotate character. */
			if (DummyPawn != none) {
				RotateDummyPawn(DummyPawn.Rotation.Yaw + RotationIncrement);
			}
			break;
		case 'Right':
			/* one1: Added. right arrow keys rotate character. */
			if (DummyPawn != none) {
				RotateDummyPawn(DummyPawn.Rotation.Yaw - RotationIncrement);
			}
			break;
    }
    
    // Handle number keys (1-0)
    switch (key)
    {
        case 'One':
            SelectedIndex = 0;
            break;
        case 'Two':
            SelectedIndex = 1;
            break;
        case 'Three':
            SelectedIndex = 2;
            break;
        case 'Four':
            SelectedIndex = 3;
            break;
        case 'Five':
            SelectedIndex = 4;
            break;
        case 'Six':
            SelectedIndex = 5;
            break;
        case 'Seven':
            SelectedIndex = 6;
            break;
        case 'Eight':
            SelectedIndex = 7;
            break;
        case 'Nine':
            SelectedIndex = 8;
            break;
        case 'Zero':
            SelectedIndex = 9;
            break;
    }
    
    // Handle special menu navigation keys (only in main menu)
    if (currentMenuState == 0)
    {
        switch (key)
        {
            case 'R': // Refill
                if (MainTabButtons[5].bEnabled)
                {
                    MainPtButtonClicked(5);
                }
                return;
                
            case 'C': // Characters
                if (MainTabButtons[6].bEnabled)
                {
                    MainPtButtonClicked(6);
                }
                return;
                
            case 'V': // Vehicles
                if (MainTabButtons[7].bEnabled)
                {
                    MainPtButtonClicked(7);
                }
                return;
                
            case 'Q': // Items
                if (MainTabButtons[8].bEnabled)
                {
                    MainPtButtonClicked(8);
                }
                return;
        }
    }
    
    // Process number key selection based on current menu state
    if (SelectedIndex != -1)
    {
        switch (currentMenuState)
        {
            case 0: // Main menu
                if (SelectedIndex < MainTabButtons.Length && MainTabButtons[SelectedIndex].bEnabled)
                {
                    // Reset all selections first
                    for (i = 0; i < MainTabButtons.Length; i++)
                    {
                        MainTabButtons[i].currentlySelected = false;
                    }
                    
                    // Select and trigger the button
                    MainTabButtons[SelectedIndex].currentlySelected = true;
                    MainPtButtonClicked(SelectedIndex);
                }
                break;
                
            case 1: // Classes menu
                if (SelectedIndex < SubTabButtons.Length && SubTabButtons[SelectedIndex].bEnabled)
                {
                    // Reset all selections first
                    for (i = 0; i < SubTabButtons.Length; i++)
                    {
                        SubTabButtons[i].currentlySelected = false;
                    }
                    
                    // Select and trigger the button
                    SubTabButtons[SelectedIndex].currentlySelected = true;
                    SubPtButtonClicked(SelectedIndex);
                }
                break;
                
            case 2: // Vehicles menu
                if (SelectedIndex < VehicleTabButtons.Length && VehicleTabButtons[SelectedIndex].bEnabled)
                {
                    // Reset all selections first
                    for (i = 0; i < VehicleTabButtons.Length; i++)
                    {
                        VehicleTabButtons[i].currentlySelected = false;
                    }
                    
                    // Select and trigger the button
                    VehicleTabButtons[SelectedIndex].currentlySelected = true;
                    VehiclePtButtonClicked(SelectedIndex);
                }
                break;
                
            case 3: // Items menu
                if (SelectedIndex < SubTabButtons.Length && SubTabButtons[SelectedIndex].bEnabled)
                {
                    // Reset all selections first
                    for (i = 0; i < SubTabButtons.Length; i++)
                    {
                        SubTabButtons[i].currentlySelected = false;
                    }
                    
                    // Select and trigger the button
                    SubTabButtons[SelectedIndex].currentlySelected = true;
                    ItemPtButtonClicked(SelectedIndex);
                }
                break;
        }
    }
}

//
//Animation
//

function StartMenuFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	FadeInPlaying=true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	menuFadeStartTime=Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartMenuFadeOut()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	fadeOutPlaying=true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	menuFadeStartTime=Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartSubmenuFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	submenuFadeInPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	submenuFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartSubmenuFadeOut()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	submenuFadeOutPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	submenuFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartVehicleMenuFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	vehicleMenuFadeInPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	vehicleMenuFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartVehicleMenuFadeOut()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	vehicleMenuFadeOutPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	vehicleMenuFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartFirstDrawerFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	firstDrawerfadeInPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	firstDrawerFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartFirstDrawerFadeOut()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	firstDrawerfadeOutPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	firstDrawerFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartSecondDrawerFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	secondDrawerfadeInPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	secondDrawerFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartSecondDrawerFadeOut()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	secondDrawerfadeOutPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	secondDrawerFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

function StartChatLogFadeIn()
{
	local int Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec;
	chatLogFadeInPlaying = true;
	GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
	chatLogFadeStartTime = Hour * 3600 + Min * 60 + Sec + MSec / 1000.0;
}

//Button Event Handlers

function MainPtButtonClicked(int index)
{
	local int i;

	if(currentlySelectedButtonIndex==index)
	{
		SelectPurchase();
	}
	currentlySelectedButtonIndex=index;

	for (i = 0; i < 10; i++)
    {
		if(MainTabButtons[i].ButtonIndex==index)
		{
			MainTabButtons[i].currentlySelected=true;
		}
		else
		{
			MainTabButtons[i].currentlySelected=false;
		}
    }

	SelectMenu(index);
}

function SubPtButtonClicked(int index)
{
	local int i;

	if(currentlySelectedButtonIndex==index)
	{
		SelectPurchase();
	}
	currentlySelectedButtonIndex=index;

	for (i = 0; i < 10; i++)
    {
		if(SubTabButtons[i].ButtonIndex==index)
		{
			SubTabButtons[i].currentlySelected=true;
		}
		else
		{
			SubTabButtons[i].currentlySelected=false;
		}
    }

	SelectMenu(index);
}

function ItemPtButtonClicked(int index)
{
	local int i;

	if(currentlySelectedButtonIndex==index)
	{
		SelectPurchase();
	}
	currentlySelectedButtonIndex=index;

	for (i = 0; i < 10; i++)
    {
		if(SubTabButtons[i].ButtonIndex==index)
		{
			SubTabButtons[i].currentlySelected=true;
		}
		else
		{
			SubTabButtons[i].currentlySelected=false;
		}
    }

	// Items don't have preview models, just select for purchase
}

function VehiclePtButtonClicked(int index)
{
	local int i;

	if(currentlySelectedButtonIndex==index)
	{
		SelectPurchase();
	}
	currentlySelectedButtonIndex=index;

	for (i = 0; i < VehicleTabButtons.Length; i++)
    {
		if(VehicleTabButtons[i].ButtonIndex==index)
		{
			VehicleTabButtons[i].currentlySelected=true;
		}
		else
		{
			VehicleTabButtons[i].currentlySelected=false;
		}
    }

	SelectMenu(index);
}


//
//Purchasing
//

function SelectMenu(int selectedIndex)
{
    if(!rxPC.bIsInPurchaseTerminal)//Sometimes mouse events happen while we're closing the menu
        return;

	switch (selectedIndex)
	{
		case 0: 
			if (currentMenuState==0){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData[selectedIndex].ID : NodMainMenuData[selectedIndex].ID);
			}
			else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;		
		case 1: 
			if (currentMenuState==0){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData[selectedIndex].ID : NodMainMenuData[selectedIndex].ID);
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
		case 2: 
			if (currentMenuState==0){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData[selectedIndex].ID : NodMainMenuData[selectedIndex].ID);
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
		case 3: 
			if (currentMenuState==0){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData[selectedIndex].ID : NodMainMenuData[selectedIndex].ID);
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
		case 4: 
			if (currentMenuState==0){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIMainMenuData[selectedIndex].ID : NodMainMenuData[selectedIndex].ID);
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
		case 5: 
			if (currentMenuState==0) {
				// REFILL
				rxPC.PlaySound(SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundRefill');
				
				//set the current weapon to defaults so we can force perform our loadouts
		
				if (rxPC.CurrentSidearmWeapon == none) {
					rxPC.CurrentSidearmWeapon = class'Rx_InventoryManager'.default.SidearmWeapons[0];
				}
				
				if (rxPC.CurrentExplosiveWeapon == none) {
					if (rxPC.bJustBaughtEngineer 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Hotwire' 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Technician'){
						rxPC.RemoveAllExplosives();
						if (TeamID == TEAM_GDI) {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_GDI_Hotwire'.default.ExplosiveWeapons[0];
						} else {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_Nod_Technician'.default.ExplosiveWeapons[0];
						}
						rxPC.SetAdvEngineerExplosives(rxPC.CurrentExplosiveWeapon);
					} else if (rxPC.bJustBaughtHavocSakura 
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_GDI_Havoc'
					|| Rx_Pawn(rxPC.Pawn).GetRxFamilyInfo() == class'Rx_FamilyInfo_Nod_Sakura' ) {
						rxPC.RemoveAllExplosives();
						if (TeamID == TEAM_GDI) {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_GDI_Havoc'.default.ExplosiveWeapons[0];
						} else {
							rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager_Nod_Sakura'.default.ExplosiveWeapons[0];
						}
						rxPC.AddExplosives(rxPC.CurrentExplosiveWeapon);
					}  else {
						rxPC.RemoveAllExplosives();
						rxPC.CurrentExplosiveWeapon = class'Rx_InventoryManager'.default.ExplosiveWeapons[0];
						rxPC.AddExplosives(rxPC.CurrentExplosiveWeapon);
					}
				}

				SetLoadout();
				rxPC.PerformRefill(rxPC);
				ClosePT();
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				if (TeamID == TEAM_NOD) {
					ChangeDummyVehicleClass(NodVehicleMenuData[selectedIndex].ID);
				}
				else{
					ChangeDummyVehicleClass(GDIVehicleMenuData[selectedIndex].ID);
				}
			}
			break;
		case 6: 
			if (currentMenuState==0) {
				// CHARACTERS menu
				previousMenuState = currentMenuState;
				currentMenuState = 1;
				currentlySelectedButtonIndex = -1;
				
				// Start animations
				StartMenuFadeOut();
				StartSubmenuFadeIn(); 
				StartSecondDrawerFadeIn();
				
			} else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			} else if (currentMenuState==2) {
				//if (!rxBuildingOwner.AreAircraftDisabled()) {
					ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
				//}
			}
			break;
		case 7: 
			if (currentMenuState==0) { 
				// VEHICLES menu
				previousMenuState = currentMenuState;
				currentMenuState = 2;
				currentlySelectedButtonIndex = -1;
				rxPC.bIsInPurchaseTerminalVehicleSection = true;
				
				// Start animations
				StartMenuFadeOut();
				StartVehicleMenuFadeIn(); 
				StartSecondDrawerFadeIn();
				
				// Switch dummy models
				DummyPawn.SetHidden(true);
				DummyVehicle.SetHidden(false);

			}else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID);
			}
			else if (currentMenuState==2) {
				//if (!rxBuildingOwner.AreAircraftDisabled()) {
					ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
				//}
			}
			break;
		case 8: 
			if (currentMenuState==0)
			{
				// ITEMS menu
				previousMenuState = currentMenuState;
				currentMenuState = 3;
				currentlySelectedButtonIndex = -1;
				
				// Start animations
				StartMenuFadeOut();
				StartSubmenuFadeIn();
				StartSecondDrawerFadeIn();
			}
			else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID); 
			}
			else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
		case 9: 
			if (currentMenuState==0)
			{
			}
			else if (currentMenuState==1){
				ChangeDummyPawnClass(TeamID == TEAM_GDI ? GDIClassMenuData[selectedIndex].ID : NodClassMenuData[selectedIndex].ID); 
			}
			else if (currentMenuState==2) {
				ChangeDummyVehicleClass(TeamID == TEAM_GDI ? GDIVehicleMenuData[selectedIndex].ID : NodVehicleMenuData[selectedIndex].ID);
			}
			break;
	}
}

function SetLoadout(optional bool CharChange = false) 
{
	if(CharChange) 
	{
	SetSidearmLoadout(true);
	SetExplosiveLoadout(true);
	}
	else
	{
	SetSidearmLoadout();
	SetExplosiveLoadout();
	}
}

function SetExplosiveLoadout (optional bool CharChange = false)
{
	/**
	 * If the explosive selected is not the same as player loadout explosives,
	 *      make the change
	 * 
	 * */
	local int SelectedIndex;
	local class<Rx_Weapon> explosiveClass;
	local array<PTEquipmentBlockCanvas> EquipmentExplosiveData;

	EquipmentExplosiveData  = teamID == TEAM_GDI ? GDIEquipmentExplosiveData    : NodEquipmentExplosiveData;

	SelectedIndex = currentlySelectedButtonIndex;
		selectedindex=-1;
	if (SelectedIndex >= 0) {
		
		if(!CharChange) explosiveClass = EquipmentExplosiveData[SelectedIndex].WeaponClass; /*only set the explosive class to something else if it isn't a Character Change*/

		
		if (rxPC.CurrentExplosiveWeapon != explosiveClass && explosiveClass !=none) {
			rxPC.RemoveAllExplosives();
			rxPC.AddExplosives(explosiveClass);
		}
		
	}
	
}

function SetSidearmLoadout(optional bool CharChange = false) /*added boolean value to see if this is for a total character swap. If it is, we changeup sidearms/explosives that can be carried. */
{
	local int SelectedIndex;
	local class<Rx_Weapon> sidearmClass;
	local array<PTEquipmentBlockCanvas> EquipmentSidearmData;

	EquipmentSidearmData = teamID == TEAM_GDI ? GDIEquipmentSidearmData : NodEquipmentSidearmData;

	SelectedIndex = currentlySelectedButtonIndex;
	if (SelectedIndex >= 0) {
		
		if(!CharChange) sidearmClass = EquipmentSidearmData[SelectedIndex].WeaponClass; /*only set the sidearm class to something else if it isn't a Character Change*/
		
		
		if (rxPC.CurrentSidearmWeapon != sidearmClass && sidearmClass !=none) {
			rxPC.SetSidearmWeapon(EquipmentSidearmData[SelectedIndex].WeaponClass);
		} else {
		}
		
	}
}

function SelectPurchase()
{
	switch(currentMenuState) {
		case 0://Main menu
			SelectClassPurchase();
			break;
		case 1://Classes
			SelectClassPurchase();	
			break;
		case 2://Vehicles
			SelectVehiclePurchase();
			break;
		case 3://Item
			SelectItemPurchase();
			break;
	}
}


function SelectClassPurchase() 
{
	local int data;
	local int Price;

	OwnedFamilyInfo = Rx_Pawn(RxPC.Pawn).GetRxFamilyInfo();


	//if it is not selected or not existed, then exit?
	if (currentlySelectedButtonIndex==-1){
		
		return;
	}

	data = currentlySelectedButtonIndex;

	if(currentMenuState==1)
	{
		data+=5;
	}
	
	if (rxPurchaseSystem != None)
		Price = rxPurchaseSystem.GetClassPrice(TeamID, IndexToClass(data, TeamID));

	//if we have enough credits, proceed with purchase
	if (PlayerCredits >= Price) {
		rxPC.PlaySound(PurchaseSound);
		if(OwnedFamilyInfo != IndexToClass(data, TeamID))
		{
			rxPC.CheckIsPTPurchaseValidStart();
			rxPC.PurchaseCharacter(TeamID, IndexToClass(data, TeamID));

			//set the current weapon to defaults so we can force perform our loadouts
			rxPC.CurrentSidearmWeapon = rxPurchaseSystem.GetFamilyClass(TeamID, data).default.InvManagerClass.default.SidearmWeapons[0];
			rxPC.CurrentExplosiveWeapon = rxPurchaseSystem.GetFamilyClass(TeamID, data).default.InvManagerClass.default.ExplosiveWeapons[0];
		
			SetLoadout(true);
			
			rxPC.SwitchWeapon(0);
		}
		else
		{
			rxPC.PerformRefill(rxPC);
		}
		ClosePT();
	}

}

function SelectVehiclePurchase() 
{
	local int data;
	local int Price;

	if (currentlySelectedButtonIndex==-1){
		return;
	}
	data = currentlySelectedButtonIndex;
	
	Price = rxPurchaseSystem == None ? 0 : rxPurchaseSystem.GetVehiclePricesSafe(TeamID, data, rxPurchaseSystem.AirdropAvailable(rxPRI));
	if (PlayerCredits >= Price) {
		rxPC.PlaySound(PurchaseSound);
		rxPC.PurchaseVehicle(TeamID, data);
		ClosePT();
	}
}

function SelectWeaponPurchase() 
{
	local int data;
	local int Price;

	if (currentlySelectedButtonIndex==-1){
		return;
	}
	data = currentlySelectedButtonIndex;
	Price = rxPurchaseSystem == None ? 0 : rxPurchaseSystem.GetWeaponPrices(TeamID, data);
	if (PlayerCredits >= Price) {
		rxPC.PlaySound(PurchaseSound);
		rxPC.PurchaseWeapon(TeamID, data);
		ClosePT();
	}
}

function SelectItemPurchase() 
{
	local int data;
	local int Price;

	if (currentlySelectedButtonIndex==-1){
		return;
	}
	data = currentlySelectedButtonIndex;
	Price = rxPurchaseSystem == None ? 0 : rxPurchaseSystem.GetItemPrices(TeamID, data);
	if (PlayerCredits >= Price) {
		rxPC.PlaySound(PurchaseSound);
		rxPC.PurchaseItem(TeamID, data);
		ClosePT();
	}
}

function class<Rx_FamilyInfo> IndexToClass(int index, byte TeamNum) {
	if (rxPurchaseSystem != None) {
		if (TeamNum == TEAM_GDI)
			return rxPurchaseSystem.GDIInfantryClasses[index];
		else
			return rxPurchaseSystem.NodInfantryClasses[index];
	}

	return None;
}


function GetMapUnitData()
{
	local class<Rx_FamilyInfo> FamInfo; 
	local class<Rx_Vehicle_PTInfo> PTInfo; 
    local class<Rx_Weapon> ItemInfo;
	local int i; 
	
	//Updates default properties to contain the units in the PurchaseSystem
	
	//VEHICLES - GDI
	for(i=0; i<rxPurchaseSystem.GDIVehicleClasses.Length; i++)
	{
		PTInfo = rxPurchaseSystem.GDIVehicleClasses[i];
		if(PTInfo == none)
		{
			GDIVehicleMenuData[i].bEnable = false;
			continue; 
		}
		else
			GDIVehicleMenuData[i].bEnable = true;
	
		GDIVehicleMenuData[i].PTIconTexture = PTInfo.default.PTIconTexture; 
		GDIVehicleMenuData[i].title = PTInfo.default.title;
		GDIVehicleMenuData[i].cost = PTInfo.default.cost;
		GDIVehicleMenuData[i].iconID = PTInfo.default.iconID;
		GDIVehicleMenuData[i].bAircraft = PTInfo.default.bAircraft;
		GDIVehicleMenuData[i].desc = StripHTMLTags(PTInfo.default.desc); 
	}
	
	//VEHICLES - NOD
	for(i=0; i<rxPurchaseSystem.NodVehicleClasses.Length; i++)
	{
		PTInfo = rxPurchaseSystem.NodVehicleClasses[i];
		if(PTInfo == none)
		{
			NodVehicleMenuData[i].bEnable = false;
			continue; 
		}
		else
			NodVehicleMenuData[i].bEnable = true;
		
		NodVehicleMenuData[i].PTIconTexture = PTInfo.default.PTIconTexture; 
		NodVehicleMenuData[i].title = PTInfo.default.title;
		NodVehicleMenuData[i].cost = PTInfo.default.cost;
		NodVehicleMenuData[i].iconID = PTInfo.default.iconID;
		NodVehicleMenuData[i].bAircraft = PTInfo.default.bAircraft;
		NodVehicleMenuData[i].desc = StripHTMLTags(PTInfo.default.desc);
	}
	
	//INFANTRY - GDI
	for(i=0; i<rxPurchaseSystem.GDIInfantryClasses.Length; i++)
	{
		FamInfo = rxPurchaseSystem.GDIInfantryClasses[i];
		if(FamInfo == none)
		{
			if(i<=4)
			{	
				GDIMainMenuData[i].bEnable = false;
			}
			else
			{
				GDIClassMenuData[i-5].bEnable = false;
			}
			continue; 
		}
		else
		{
			if(i<=4)
			{	
				GDIMainMenuData[i].bEnable = true;
			}
			else
			{
				GDIClassMenuData[i-5].bEnable = true;
			}
		}
	
		if(i<=4)
		{
			GDIMainMenuData[i].PTIconTexture = FamInfo.static.Icon(); 
			GDIMainMenuData[i].title = FamInfo.static.Title();
			GDIMainMenuData[i].cost = FamInfo.static.StrCost();
			GDIMainMenuData[i].desc = FamInfo.static.Description();
			GDIMainMenuData[i].damage = FamInfo.static.DamageOutOfSix();
			GDIMainMenuData[i].range = FamInfo.static.RangeOutOfSix();
			GDIMainMenuData[i].rateOfFire = FamInfo.static.RateOfFireOutOfSix();
			GDIMainMenuData[i].magCap = FamInfo.static.MagazineCapacityOutOfSize();
		}
		else
		{
			GDIClassMenuData[i-5].PTIconTexture = FamInfo.static.Icon(); 
			GDIClassMenuData[i-5].title = FamInfo.static.Title();
			GDIClassMenuData[i-5].cost = FamInfo.static.StrCost();
			GDIClassMenuData[i-5].desc = FamInfo.static.Description();
			GDIClassMenuData[i-5].damage = FamInfo.static.DamageOutOfSix();
			GDIClassMenuData[i-5].range = FamInfo.static.RangeOutOfSix();
			GDIClassMenuData[i-5].rateOfFire = FamInfo.static.RateOfFireOutOfSix();
			GDIClassMenuData[i-5].magCap = FamInfo.static.MagazineCapacityOutOfSize();
		}
	}
	
	//INFANTRY - NOD
	for(i=0; i<rxPurchaseSystem.NodInfantryClasses.Length; i++)
	{
		FamInfo = rxPurchaseSystem.NodInfantryClasses[i];
		if(FamInfo == none)
		{
			if(i<=4)
			{	
				NodMainMenuData[i].bEnable = false;
			}
			else
			{
				NodClassMenuData[i-5].bEnable = false;
			}
			continue; 
		}
		else
		{
			if(i<=4)
			{	
				NodMainMenuData[i].bEnable = true;
			}
			else
			{
				NodClassMenuData[i-5].bEnable = true;
			}
		}
		
		if(i<=4)
		{
			NodMainMenuData[i].PTIconTexture = FamInfo.static.Icon(); 
			NodMainMenuData[i].title = FamInfo.static.Title();
			NodMainMenuData[i].cost = FamInfo.static.StrCost();
			NodMainMenuData[i].desc = FamInfo.static.Description();
			NodMainMenuData[i].damage = FamInfo.static.DamageOutOfSix();
			NodMainMenuData[i].range = FamInfo.static.RangeOutOfSix();
			NodMainMenuData[i].rateOfFire = FamInfo.static.RateOfFireOutOfSix();
			NodMainMenuData[i].magCap = FamInfo.static.MagazineCapacityOutOfSize();
		}
		else
		{
			NodClassMenuData[i-5].PTIconTexture = FamInfo.static.Icon(); 
			NodClassMenuData[i-5].title = FamInfo.static.Title();
			NodClassMenuData[i-5].cost = FamInfo.static.StrCost();
			NodClassMenuData[i-5].desc = FamInfo.static.Description();
			NodClassMenuData[i-5].damage = FamInfo.static.DamageOutOfSix();
			NodClassMenuData[i-5].range = FamInfo.static.RangeOutOfSix();
			NodClassMenuData[i-5].rateOfFire = FamInfo.static.RateOfFireOutOfSix();
			NodClassMenuData[i-5].magCap = FamInfo.static.MagazineCapacityOutOfSize();
		}
	}

	//ITEMS - GDI
	for(i=0; i<rxPurchaseSystem.GDIItemClasses.Length; i++)
	{
		ItemInfo = rxPurchaseSystem.GDIItemClasses[i];
		if(ItemInfo == none)
		{
			GDIItemMenuData[i].bEnable = false;
			continue; 
		}
		else
			GDIItemMenuData[i].bEnable = true;
	
		GDIItemMenuData[i].PTIconTexture = ItemInfo.default.PTIconTexture; 
		GDIItemMenuData[i].title = ItemInfo.static.GetPurchaseTitle();
		GDIItemMenuData[i].cost = string(rxPurchaseSystem.GetItemPrices(0, i));
		//GDIItemMenuData[i].iconID = ItemInfo.default.iconID;
		GDIItemMenuData[i].desc = StripHTMLTags(ItemInfo.static.GetPurchaseDescription()); 
	}


	//ITEMS - NOD
	for(i=0; i<rxPurchaseSystem.NodItemClasses.Length; i++)
	{
		ItemInfo = rxPurchaseSystem.NodItemClasses[i];
		if(ItemInfo == none)
		{
			NodItemMenuData[i].bEnable = false;
			continue; 
		}
		else
			NodItemMenuData[i].bEnable = true;
		
		NodItemMenuData[i].PTIconTexture = ItemInfo.default.PTIconTexture; 
		NodItemMenuData[i].title = ItemInfo.static.GetPurchaseTitle();
		NodItemMenuData[i].cost = string(rxPurchaseSystem.GetItemPrices(1, i));
		//NodItemMenuData[i].iconID = ItemInfo.default.iconID;
		NodItemMenuData[i].desc = StripHTMLTags(ItemInfo.static.GetPurchaseDescription());
	}
}

//Utils
function string StripHTMLTags(string TextWithTags)
{
    local string Result;
    local int StartPos, EndPos;
    
    Result = TextWithTags;
    
    // Keep removing tags until there are none left
    while (true)
    {
        StartPos = InStr(Result, "<");
        if (StartPos == -1)
            break;
            
        EndPos = InStr(Result, ">");
        if (EndPos == -1)
            break;
            
        // Remove the tag
        Result = Left(Result, StartPos) $ Mid(Result, EndPos + 1);
    }
    
    return Result;
}

function DrawChatLog()
{
    local array<string> ChatLines;
    local string ChatLog, CleanMessage;
    local int i, StartIndex, MaxLines, ActualLinesUsed;
    local float BoxX, BoxY, BoxWidth, BoxHeight;
    local float CurrentY, LineHeight, TextWidth, TextHeight;
    local float TitleHeight, AvailableWidth;
    local Color BorderColor, BackgroundColor;
    local float OriginalClipX, OriginalClipY;
    local int MessageLineCount;
    local bool isTeamMessage;
    local int stringIndex;
    
    // Get chat log from HUD
    if(rxHUD == none)
        return;
    
    ChatLog = rxHUD.PublicChatMessageLog;
    
    // Define box dimensions (scaled)
    BoxX = ChatLogX * ResScaleY;
    BoxY = ChatLogY * ResScaleY;
    BoxWidth = ChatLogWidth * ResScaleY;
    BoxHeight = ChatLogHeight * ResScaleY;
    
    // Apply chat log fade in animation - slide from left
    if(chatLogFadeInPlaying)
    {
        BoxX -= (BoxWidth + (ChatLogX * ResScaleY)) * (1 - chatLogFadeAnimationProgress);
    }
    
    // Set colors
    BorderColor = TeamID == TEAM_GDI ? ColorYellow : ColorRed;
    BackgroundColor=BorderColor;
    BackgroundColor.A = ChatLogBackgroundAlpha;
    
    // Draw semi-transparent background
    Canvas.SetDrawColor(BackgroundColor.R, BackgroundColor.G, BackgroundColor.B, BackgroundColor.A);
    Canvas.SetPos(BoxX, BoxY);
    Canvas.DrawRect(BoxWidth, BoxHeight);
    
    // Draw border
    Canvas.SetDrawColor(BorderColor.R, BorderColor.G, BorderColor.B, 255);
    Canvas.SetPos(BoxX, BoxY);
    Canvas.DrawBox(BoxWidth, BoxHeight);
    
    // Setup font
    Canvas.Font = class'Engine'.Static.GetSmallFont();
    
    // Draw title at top
    Canvas.SetDrawColor(255, 255, 255, 255);
    TitleHeight = ChatLogTitleHeight * ResScaleY;
    Canvas.SetPos(BoxX + ChatLogPadding * ResScaleY, BoxY + (ChatLogPadding * 0.8) * ResScaleY);
    Canvas.DrawText("CHAT LOG", false, ChatLogTitleScale * ResScaleY, ChatLogTitleScale * ResScaleY);
    
    // Draw line under title
    Canvas.SetDrawColor(BorderColor.R, BorderColor.G, BorderColor.B, 200);
    Canvas.SetPos(BoxX + (ChatLogPadding * 0.5) * ResScaleY, BoxY + TitleHeight - (ChatLogPadding * 0.5) * ResScaleY);
    Canvas.DrawRect(BoxWidth - ChatLogPadding * ResScaleY, ChatLogBorderThickness);
    
    // Split chat log into individual lines
    ChatLines = SplitString(ChatLog, "\n", true);
    
    // Calculate line height for a single line
    Canvas.TextSize("A", TextWidth, LineHeight, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);
    LineHeight += ChatLogLineSpacing * ResScaleY;
    
    // Calculate available width for text (accounting for padding)
    AvailableWidth = BoxWidth - (ChatLogPadding * 2 * ResScaleY);
    
    // Calculate maximum lines that fit
    MaxLines = int((BoxHeight - TitleHeight - ChatLogPadding * ResScaleY) / LineHeight);
    
    // Calculate which messages to show by working backwards and counting actual lines
    ActualLinesUsed = 0;
    StartIndex = ChatLines.Length;
    
    // Work backwards to find where to start
    for(i = ChatLines.Length - 1; i >= 0; i--)
    {
        if(ChatLines[i] == "")
            continue;
            
        CleanMessage = StripHTMLTags(ChatLines[i]);
        
        // Calculate how many lines this message will take
        Canvas.TextSize(CleanMessage, TextWidth, TextHeight, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);
        MessageLineCount = Max(1, int(TextWidth / AvailableWidth) + 1);
        
        // Check if we have room
        if(ActualLinesUsed + MessageLineCount > MaxLines)
            break;
            
        ActualLinesUsed += MessageLineCount;
        StartIndex = i;
    }
    
    // Start position for text
    CurrentY = BoxY + TitleHeight + (ChatLogPadding * 0.5) * ResScaleY;
    
    // Store original clip region
    OriginalClipX = Canvas.SizeX;
    OriginalClipY = Canvas.sizeY;
    
    // Set clip region to restrict text to the chat box area (leaving padding)
    Canvas.SetOrigin(BoxX + ChatLogPadding * ResScaleY, CurrentY);
    Canvas.SetClip(BoxWidth - (ChatLogPadding * 2 * ResScaleY), BoxHeight - TitleHeight - (ChatLogPadding * ResScaleY));
    
    // Draw messages
    Canvas.SetDrawColor(255, 255, 255, 255);
    if(chatLogFadeInPlaying)
    {
        // Restore original clip region and origin before returning
        Canvas.SetOrigin(0, 0);
        Canvas.SetClip(OriginalClipX, OriginalClipY);
        return;
    }

    for(i = StartIndex; i < ChatLines.Length; i++)
    {
        if(ChatLines[i] == "")
            continue;
        
        `log(ChatLines[i]);
        if(Right(ChatLines[i], 1) == ">")
        {
            isTeamMessage=true;
        }
        else
        {
            isTeamMessage=false;
        }
        // Strip HTML tags
        CleanMessage = StripHTMLTags(ChatLines[i]);
        
        // Calculate how many lines this message will take
        Canvas.TextSize(CleanMessage, TextWidth, TextHeight, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);
        MessageLineCount = Max(1, int(TextWidth / AvailableWidth) + 1);
        
        // Check bounds
        if(CurrentY + (LineHeight * MessageLineCount) > BoxY + BoxHeight - (ChatLogPadding * 0.5) * ResScaleY)
            break;
        

        if(isTeamMessage==true)
        {
            if (InStr(ChatLines[i], "#FF0000") != -1)
            {
                Canvas.SetDrawColor(255,0,0);
            }else if(InStr(ChatLines[i], "#FFC600") != -1)
            {
                Canvas.SetDrawColor(255,198,0);
            }else
            {
                Canvas.SetDrawColor(255,255,255);
            }

            // Draw message (position is now relative to origin)
            Canvas.SetPos(0, (CurrentY - (BoxY + TitleHeight + (ChatLogPadding * 0.5) * ResScaleY)));
            Canvas.DrawText(CleanMessage, false, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);
        }else
        {
            stringIndex = InStr(CleanMessage, ":");

            if (stringIndex != -1)
            {
                Canvas.SetPos(0, (CurrentY - (BoxY + TitleHeight + (ChatLogPadding * 0.5) * ResScaleY)));

                if (InStr(ChatLines[i], "#FF0000") != -1)
                {
                    Canvas.SetDrawColor(255,0,0);
                }else if(InStr(ChatLines[i], "#FFC600") != -1)
                {
                    Canvas.SetDrawColor(255,198,0);
                }

                Canvas.DrawText(Left(CleanMessage, stringIndex), false, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);

                Canvas.SetDrawColor(255,255,255);

                Canvas.DrawText(Mid(CleanMessage, stringIndex + 1), false, ChatLogTextScale * ResScaleY, ChatLogTextScale * ResScaleY);
            }
            else
            {
                `log("Failed to parse "$CleanMessage);
            }
        }


        // Move to next line(s) - account for wrapped lines
        CurrentY += LineHeight * MessageLineCount;
    }
    
    // Restore original clip region and origin
    Canvas.SetOrigin(0, 0);
    Canvas.SetClip(OriginalClipX, OriginalClipY);
}

function RotateDummyPawn (int NewYawRotation)
{
	local rotator rot;
	if (DummyPawn == none) {
		return;
	}
	if (NewYawRotation > 65536 ) {
		NewYawRotation = NewYawRotation - 65536;
	} else if (NewYawRotation < - 65536) {
		NewYawRotation = NewYawRotation + 65536;
	}
	rot = DummyPawn.Rotation;
	rot.Yaw = NewYawRotation;
	DummyPawn.SetRotation(rot);
}

function UpdateDummyLookAt()
{
	local float OffsetX;

	OffsetX = MousePosition.X - (RenXHud.SizeX / 5) - (RenXHud.SizeX / 2);

	DummyPawn.RelaxedAimNode.Aim.X = FMin(-1 * OffsetX / RenXHud.SizeX , 0.5);
	DummyPawn.RelaxedAimNode.Aim.Y = (((-1 * MousePosition.Y) / RenXHud.SizeY) + 0.5) / 2;

}

DefaultProperties
{

	//Offsets
	TabsBasePositionOffsetX=170
	TabsBasePositionOffsetY=-400

	TabXSpacing=340
	TabYSpacing=171

	VehicleTabXSpacing=340
	VehicleTabYSpacing=230

	overdriveOpacity=255

	ExitButtonPositionOffsetX=-593
    ExitButtonPositionOffsetY=456
    
    BackButtonPositionOffsetX=-387
    BackButtonPositionOffsetY=456
    
    CenterButtonPositionOffsetX=-16
    CenterButtonPositionOffsetY=456
    
    CreditsButtonPositionOffsetX=353
    CreditsButtonPositionOffsetY=456
    
    PurchaseButtonPositionOffsetX=560
    PurchaseButtonPositionOffsetY=456

	VehicleTabsBasePositionOffsetX=-510
	VehicleTabsBasePositionOffsetY=-408

	vehiclesAnimationPaddingY=2000
	TabOffscreenPaddingX=500

	//Data
	GDIMainMenuData(0) 				= (BlockType=EPBT_CLASS, id=0,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Autorifle',  iconID=27, hotkey="1", title="SOLDIER",	    desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=1,range=3,rateOfFire=5,magCap=4)
	GDIMainMenuData(1) 				= (BlockType=EPBT_CLASS, id=1,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Shotgun', iconID=52, hotkey="2", title="SHOTGUNNER",  desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=3,range=1,rateOfFire=2,magCap=2)
	GDIMainMenuData(2) 				= (BlockType=EPBT_CLASS, id=2,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_GrenadeLauncher', iconID=34, hotkey="3", title="GRENADIER",   desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Armour\n+Anti-Building",	cost="FREE", type=2, damage=3,range=4,rateOfFire=2,magCap=2)
	GDIMainMenuData(3) 				= (BlockType=EPBT_CLASS, id=3,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MarksmanRifle', iconID=41, hotkey="4", title="MARKSMAN",	desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",			cost="FREE", type=2, damage=3,range=5,rateOfFire=3,magCap=2)
	GDIMainMenuData(4) 				= (BlockType=EPBT_CLASS, id=4,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="5", title="ENGINEER",	desc="Armour: Flak\nSpeed: 95\nSide: Silenced Pistol\nRemote C4\n+Anti-Building\n+Repair/Support",	cost="FREE", type=2, damage=3,range=1,rateOfFire=6,magCap=6)
	GDIMainMenuData(5) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Refill', iconID=05, hotkey="R", title="REFILL",	    desc="\nRefill Health\nRefill Armour\nRefill Ammo",										cost="FREE", type=1)
	GDIMainMenuData(6) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Characters', iconID=02, hotkey="C", title="CHARACTERS",  desc="",																								cost="MENU", type=1)
	GDIMainMenuData(7) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Vehicles_GDI', iconID=25, hotkey="V", title="VEHICLES",	desc="",																								cost="MENU", type=1)
	GDIMainMenuData(8) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_ItemsGDI', iconID=03, hotkey="Q", title="ITEM",		desc="\n\nSuperweapons\nEquipment\nDeployables",														cost="MENU", type=1)

	GDIClassMenuData(0) 			= (BlockType=EPBT_CLASS, id=5,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Chaingun', iconID=28, hotkey="1", title="OFFICER"		 ,desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\nSmoke Grenade\n+Anti-Infantry",	cost="175", type=2,damage=1,range=3,rateOfFire=6,magCap=6)
	GDIClassMenuData(1) 			= (BlockType=EPBT_CLASS, id=6,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MissileLauncher', iconID=42, hotkey="2", title="ROCKET SOLDIER",desc="Armour: Flak\nSpeed: 95\nSide: Machine Pistol\nAnti-Tank Mines\n+Anti-Armour\n+Anti-Aircraft", cost="225", type=2,damage=4,range=5,rateOfFire=1,magCap=1)
	GDIClassMenuData(2) 			= (BlockType=EPBT_CLASS, id=7,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FlakCannon', iconID=31, hotkey="3", title="MCFARLAND"	 ,desc="Armour: Kevlar\nSpeed: 105\nSide: Silenced Pistol\nFrag Grenades\n+Anti-Infantry",						cost="150", type=2,damage=3,range=1,rateOfFire=3,magCap=3)
	GDIClassMenuData(3) 			= (BlockType=EPBT_CLASS, id=8,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle', iconID=54, hotkey="4", title="DEADEYE"		 ,desc="Armour: Light\nSpeed: 90\nSide: Heavy Pistol\nSmoke Grenade\n+Anti-Infantry",					cost="500", type=2,damage=4,range=6,rateOfFire=1,magCap=2)
	GDIClassMenuData(4) 			= (BlockType=EPBT_CLASS, id=9,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RocketLauncher', iconID=51, hotkey="5", title="GUNNER"		 ,desc="Armour: Flak\nSpeed: 95\nSide: Carbine\nEMP Grenade\nAT Mines\n+Anti-Armour\n+Anti-Structure",					cost="400", type=2,damage=4,range=5,rateOfFire=3,magCap=2)
	GDIClassMenuData(5) 			= (BlockType=EPBT_CLASS, id=10, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TacticalRifle', iconID=55, hotkey="6", title="PATCH"		 ,desc="Armour: Kevlar\nSpeed: 112.5\nSide: Heavy Pistol\nFrag Grenades\n+Anti-Infantry",						cost="450", type=2,damage=3,range=4,rateOfFire=4,magCap=3)
	GDIClassMenuData(6) 			= (BlockType=EPBT_CLASS, id=11, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle', iconID=48, hotkey="7", title="HAVOC"		 ,desc="Armour: Light\nSpeed: 90\nSide: Carbine\nSmoke Grenade\n+Anti-Infantry",					cost="1000",type=2,damage=5,range=6,rateOfFire=2,magCap=2)
	GDIClassMenuData(7) 			= (BlockType=EPBT_CLASS, id=12, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_PIC', iconID=44, hotkey="8", title="SYDNEY"		 ,desc="Armour: Flak\nSpeed: 100\nSide: Tiberium Flechette Rifle\nEMP Grenade\nAnti-Tank Mines\n+Anti-Armour",					cost="1000",type=2,damage=6,range=4,rateOfFire=1,magCap=2)
	GDIClassMenuData(8) 			= (BlockType=EPBT_CLASS, id=13, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_VoltAutoRifle', iconID=59, hotkey="9", title="MOBIUS"		 ,desc="Armour: Kevlar\nSpeed: 100\nSide: Heavy Pistol\n+Anti-Everything",					cost="1000",type=2,damage=3,range=3,rateOfFire=6,magCap=4)
	GDIClassMenuData(9) 			= (BlockType=EPBT_CLASS, id=14, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="0", title="HOTWIRE"		 ,desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nRemote C4\nProximity Mines\n+Anti-Building\n+Repair/Support",	cost="350", type=2,damage=6,range=1,rateOfFire=6,magCap=6)

	GDIItemMenuData(0) 				= (BlockType=EPBT_ITEM, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_IonCannonBeacon', iconID=70, hotkey="1", title="ION CANNON BEACON", desc="Pros:\n-Instant Building Destruction\nCons:\n-60 Seconds for impact\n-USES ITEM SLOT", 	cost="1000", type=1)
	GDIItemMenuData(1) 				= (BlockType=EPBT_ITEM, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Airstrike_A10', iconID=62, hotkey="2", title="A-10 AIRSTRIKE",	desc="Pros:\n-5 seconds to impact\n-Quick bombardment\n-Anti-Infrantry/Vehicle\nCons:\n-Weak Vs. Buildings\n-USES ITEM SLOT", 												cost="800",  type=1)
	GDIItemMenuData(2) 				= (BlockType=EPBT_ITEM, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="3", title="REPAIR TOOL",desc="Pros:\n-Repairs Units/Buildings\n-Disarms Mines\n\nCons:\n-Must Recharge\n-USES ITEM SLOT  "      /*desc="Pros:\n-Repairs Units/Buildings\n-Disarms Mines\n\nCons:\n-Must Recharge\n-USES ITEM SLOT  "*/, cost="250")
    GDIItemMenuData(3) 				= (BlockType=EPBT_ITEM, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_AmmoKit', iconID=64, hotkey="4", title="AMMUNITION KIT",	desc="<font size='8'>Pros:\n-Rearms near by infrantry\n-30 seconds before depletion\n\nCons:\n-Rearms near by enemies as well\n-Cannot refill</font>", 								cost="150",  type=1 , bEnable = false)
	GDIItemMenuData(4) 				= (BlockType=EPBT_ITEM, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MechanicalKit', iconID=65, hotkey="5", title="MECHANICAL KIT",	desc="<font size='8'>Pros:\n-Repairs near by vehicles\n-30 seconds before depletion\n\nCons:\n-Repairs near by enemies as well\n-Cannot refill</font>", 							cost="150",  type=1 , bEnable = false)
	GDIItemMenuData(5) 				= (BlockType=EPBT_ITEM, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MotionSensor', iconID=67, hotkey="6", title="MOTION SENSOR",	 	desc="<font size='8'>Pros:\n-Relays enemy position in a radius\n-Detects mines and beacons\n\nCons:\n-Emits an audible sound\n-Cannot refill</font>", 								cost="200",  type=1 , bEnable = false)
	GDIItemMenuData(6) 				= (BlockType=EPBT_ITEM, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_MG', iconID=68, hotkey="7", title="MG SENTRY",	 	 	desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Infrantry\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300",  type=1 , bEnable = false)
	GDIItemMenuData(7) 				= (BlockType=EPBT_ITEM, id=7, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_AT', iconID=69, hotkey="8", title="AT SENTRY",	 	 	desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Vehicle\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 											cost="300",  type=1 , bEnable = false)



	GDIWeaponMenuData(0) 			= (BlockType=EPBT_WEAPON, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_HeavyPistol', iconID=36, hotkey="1", title="HEAVY PISTOL",	 		  desc="Good Vs:\n-Infantry\n-Light Armour Vehicles\n\nWeak Vs:\n-Buildings\n-Light Armour Vehicles",									 cost="100", type=2, damage=4,range=2,rateOfFire=3,magCap=2)
	GDIWeaponMenuData(1) 			= (BlockType=EPBT_WEAPON, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Carbine', iconID=72, hotkey="2", title="CARBINE",	 			      desc="Good Vs:\n-Infantry\n-Light Armour\n\nWeak Vs:\n-Heavy Armour\n-Buildings",														 cost="250", type=2, damage=3,range=3,rateOfFire=4,magCap=2)
	GDIWeaponMenuData(2) 			= (BlockType=EPBT_WEAPON, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibFlechetteRifle', iconID=57, hotkey="3", title="TIBERIUM FLECHETTE RIFLE",  desc="[Requires Silo] \nGood Vs: \n-Infrantry\n-Light Armour\nWeak Vs:\n-Heavy Armour\n-Buildings",				 cost="400", type=2, damage=2,range=3,rateOfFire=5,magCap=3, bSilo = true)
	GDIWeaponMenuData(3) 			= (BlockType=EPBT_WEAPON, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=56, hotkey="4", title="TIBERIUM AUTO-RIFLE",		  desc="[Requires Silo] \nGood Vs: \n-Infrantry\n-Light Armour\nWeak Vs:\n-Heavy Armour\n-Buildings",				 cost="400", type=2, damage=4,range=3,rateOfFire=2,magCap=3, bSilo = true)
	GDIWeaponMenuData(4) 			= (BlockType=EPBT_WEAPON, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_EMPGrenade', iconID=30, hotkey="5", title="EMP GRENADE",	 			  desc="\nPros:\n-Disables vehicles\n-Disarm mines\n\nCons:\n-Weapons remain active", 					 		 cost="300", type=1)
	GDIWeaponMenuData(5) 			= (BlockType=EPBT_WEAPON, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ATMine', iconID=26, hotkey="6", title="ANTI-TANK MINE",	 	 	  desc="\nPros:\n-Heavy vehicle damage\n\nCons:\n-Can be destroyed\n-Limit 2 per person",							 cost="250", type=1)
	GDIWeaponMenuData(6) 			= (BlockType=EPBT_WEAPON, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SmokeGrenade', iconID=74, hotkey="7", title="SMOKE GRENADE",	 	      desc="\nPros:\n-Reduces Visibility\n-Disables Target Info\n\nCons:\n-Weapons remain active", 					 cost="100", type=1)

	GDIVehicleMenuData(0) 			= (BlockType=EPBT_VEHICLE, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Humvee', iconID=9,  hotkey="1",title="HUMVEE",								desc="-.50 Calibre Machine Gun\n-Light Armour\n-Fast Attack Scout\n-Driver + Passenger",				cost="350")
	GDIVehicleMenuData(1) 			= (BlockType=EPBT_VEHICLE, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_APC', iconID=7,  hotkey="2",title="ARMOURED\n PERSONNEL CARRIER",			desc="-M134 Minigun\n-Heavy Armour\n-Troop Transport\n-Driver + 4 Passengers",						cost="500")
	GDIVehicleMenuData(2) 			= (BlockType=EPBT_VEHICLE, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MRLS', iconID=12, hotkey="3",title="MOBILE ROCKET LAUNCHER SYSTEM",		desc="-M269 Missiles\n-Light Armour\n-Long Range Ballistics\n-Driver + Passenger",					cost="450")
	GDIVehicleMenuData(3) 			= (BlockType=EPBT_VEHICLE, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MediumTank', iconID=11, hotkey="4",title="MEDIUM TANK",							desc="-105mm Cannon\n-Heavy Armour\n-Main Battle Tank\n-Driver + Passenger",							cost="800")
	GDIVehicleMenuData(4) 			= (BlockType=EPBT_VEHICLE, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_MammothTank', iconID=10, hotkey="5",title="MAMMOTH TANK",						desc="-2x 120mm Cannons\n-4x Tusk Missiles\n-Heavy Armour\n-Heavy Battle Tank\n-Driver + Passenger",	cost="1500")
	GDIVehicleMenuData(5) 			= (BlockType=EPBT_VEHICLE, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_TransportHelicopter', iconID=24, hotkey="6",title="TRANSPORT HELICOPTER",				desc="-2x Gatling Guns\n-Light Armour\n-Troop Transport\n-Pilot + 4 Passengers",					cost="700", bAircraft = true)
	GDIVehicleMenuData(6) 			= (BlockType=EPBT_VEHICLE, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Orca', iconID=13, hotkey="7",title="ORCA FIGHTER",						desc="-Hellfire Missiles\n-.50 Calibre Machine Gun\n-Light Armour\n-Attack VTOL\n-Pilot and Passenger",		cost="900", bAircraft = true)
	GDIVehicleMenuData(7) 			= (BlockType=EPBT_VEHICLE, id=7, hotkey="8") //Blank Space just to even out with Nod
	GDIVehicleMenuData(8) 			= (BlockType=EPBT_VEHICLE, id=8, hotkey="9") //Blank Space just to even out with Nod 
	GDIVehicleMenuData(9) 			= (BlockType=EPBT_VEHICLE, id=9, hotkey="0") //Blank Space just to even out with Nod 


	
	NodMainMenuData(0) 				= (BlockType=EPBT_CLASS, id=0,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Autorifle', iconID=27, hotkey="1", title="SOLDIER",	 	 desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=1, range=3, rateOfFire=5, magCap=4 )
	NodMainMenuData(1) 				= (BlockType=EPBT_CLASS, id=1,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Shotgun', iconID=52, hotkey="2", title="SHOTGUNNER",	 desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",	cost="FREE", type=2, damage=3, range=1, rateOfFire=2, magCap=2 )
	NodMainMenuData(2) 				= (BlockType=EPBT_CLASS, id=2,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FlameThrower', iconID=32, hotkey="3", title="FLAMETHROWER", desc="Armour: Flak\nSpeed: 105\nSide: Silenced Pistol\n+Anti-Everything",						cost="FREE", type=2, damage=2, range=1, rateOfFire=4, magCap=4 )
	NodMainMenuData(3) 				= (BlockType=EPBT_CLASS, id=3,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MarksmanRifle', iconID=41, hotkey="4", title="MARKSMAN",	 desc="Armour: Kevlar\nSpeed: 100\nSide: Silenced Pistol\n+Anti-Infantry",			cost="FREE", type=2, damage=3, range=5, rateOfFire=3, magCap=2 )
	NodMainMenuData(4) 				= (BlockType=EPBT_CLASS, id=4,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="5", title="ENGINEER",	 desc="Armour: Flak\nSpeed: 95\nSide: Silenced Pistol\nRemote C4\n+Anti-Building\n+Repair/Support",	cost="FREE", type=2, damage=3, range=1, rateOfFire=6, magCap=6 )
	NodMainMenuData(5) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Refill', iconID=05, hotkey="R", title="REFILL",	 	 desc="\nRefill Health\nRefill Armour\nRefill Ammo",									cost="MENU", type=1 )
	NodMainMenuData(6) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Characters', iconID=02, hotkey="C", title="CHARACTERS",	 desc="",																								cost="MENU", type=1 )
	NodMainMenuData(7) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Vehicles_Nod', iconID=61, hotkey="V", title="VEHICLES",	 desc="",																								cost="MENU", type=1 )
	NodMainMenuData(8) 				= (BlockType=EPBT_MENU,  id=-1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_ItemsNod', iconID=04, hotkey="Q", title="ITEM",		 desc="\n\nSuperweapons\nEquipment\nDeployables",														cost="MENU", type=1 )

	NodClassMenuData(0)				= (BlockType=EPBT_CLASS, id=5,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Chaingun', iconID=28, hotkey="1", title="OFFICER",				desc="Armour: Kevlar\nSpeed: 110\nSide: Silenced Pistol\nSmoke Grenade\n+Anti-Infantry",	cost="175",  type=2, damage=1, range=3, rateOfFire=6, magCap=6)
	NodClassMenuData(1)				= (BlockType=EPBT_CLASS, id=6,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MissileLauncher', iconID=42, hotkey="2", title="ROCKET SOLDIER",		desc="Armour: Flak\nSpeed: 105\nSide: Machine Pistol\nAnti-Tank Mines\n+Anti-Armour\n+Anti-Aircraft",						cost="225",  type=2, damage=4, range=5, rateOfFire=1, magCap=1)
	NodClassMenuData(2)				= (BlockType=EPBT_CLASS, id=7,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ChemicalThrower', iconID=29, hotkey="3", title="CHEMICAL TROOPER",	desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nFrag Grenades\n+Anti-Everything",						cost="150",  type=2, damage=3, range=1, rateOfFire=4, magCap=4)
	NodClassMenuData(3)				= (BlockType=EPBT_CLASS, id=8,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle', iconID=54, hotkey="4", title="BLACK HAND SNIPER",	desc="Armour: Light\nSpeed: 90\nSide: Heavy Pistol\nSmoke Grenade\n+Anti-Infantry",						cost="500",  type=2, damage=4, range=6, rateOfFire=1, magCap=2)
	NodClassMenuData(4)				= (BlockType=EPBT_CLASS, id=9,  PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserRifle', iconID=39, hotkey="5", title="STEALTH BLACK HAND",	desc="Armour: Lazarus\nSpeed: 110\nSide: S. M. Pistol\nActive Camouflage\n+Anti-Everything",						cost="400",  type=2, damage=3, range=4, rateOfFire=4, magCap=3)
	NodClassMenuData(5)				= (BlockType=EPBT_CLASS, id=10, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserChaingun', iconID=38, hotkey="6", title="LASER CHAINGUNNER",	desc="Armour: Flak\nSpeed: 85\nEMP Grenade\nAnti-Tank Mines\n+Anti-Everything\n+Heavy Infantry",						cost="450",  type=2, damage=3, range=3, rateOfFire=5, magCap=5)
	NodClassMenuData(6)				= (BlockType=EPBT_CLASS, id=11, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle', iconID=48, hotkey="7", title="SAKURA",				desc="Armour: Light\nSpeed: 90\nSide: S. Carbine\nSmoke Grenade\n+Anti-Infantry",						cost="1000", type=2, damage=5, range=6, rateOfFire=2, magCap=2)
	NodClassMenuData(7)				= (BlockType=EPBT_CLASS, id=12, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Railgun', iconID=47, hotkey="8", title="RAVESHAW",			desc="Armour: Flak\nSpeed: 100\nSide: Tiberium Flechette Rifle\nEMP Grenade\nAnti-Tank Mines\n+Anti-Armour",						cost="1000", type=2, damage=6, range=4, rateOfFire=1, magCap=2)
	NodClassMenuData(8)				= (BlockType=EPBT_CLASS, id=13, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=59, hotkey="9", title="MENDOZA",				desc="Armour: Kevlar\nSpeed: 110\nSide: Heavy Pistol\n+Anti-Everything",						cost="1000", type=2, damage=3, range=3, rateOfFire=6, magCap=4)
	NodClassMenuData(9)				= (BlockType=EPBT_CLASS, id=14, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun', iconID=50, hotkey="0", title="TECHNICIAN",			desc="Armour: Flak\nSpeed: 100\nSide: Silenced Pistol\nRemote C4\nProximity Mines\n+Anti-Building\n+Repair/Support",	cost="350",  type=2, damage=6, range=1, rateOfFire=6, magCap=6)

	NodItemMenuData(0)				= (BlockType=EPBT_ITEM, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_NukeBeacon', iconID=71, hotkey="1", title="NUKE STRIKE BEACON", desc="Pros:\n-Instant Building Destruction\nCons:\n-60 Seconds for impact\n-USES ITEM SLOT", cost="1000", type=1)
	NodItemMenuData(1)				= (BlockType=EPBT_ITEM, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Airstrike_AC130', iconID=63, hotkey="2", title="AC-130 AIRSTRIKE",	 desc="Pros:\n-5 seconds to impact\n-Quick bombardment\n-Anti-Infrantry/Vehicle\nCons:\n-Weak Vs. Buildings\n-USES ITEM SLOT", 												cost="800" , type=1)
	NodItemMenuData(2)				= (BlockType=EPBT_ITEM, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="3", title="REPAIR TOOL",      desc="Pros:\n-Repairs Units/Buildings\n-Disarms Mines\n\nCons:\n-Must Recharge\n-USES ITEM SLOT ", cost="200")
    NodItemMenuData(3)				= (BlockType=EPBT_ITEM, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_AmmoKit', iconID=64, hotkey="4", title="AMMUNITION KIT",	 desc="<font size='8'>Pros:\n-Rearms near by infrantry\n-30 seconds before depletion\n\nCons:\n-Rearms near by enemies as well\n-Cannot refill</font>", 							cost="150" , type=1, bEnable = false)
	NodItemMenuData(4)				= (BlockType=EPBT_ITEM, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MechanicalKit', iconID=65, hotkey="5", title="MECHANICAL KIT",	 desc="<font size='8'>Pros:\n-Repairs near by vehicles\n-30 seconds before depletion\n\nCons:\n-Repairs near by enemies as well\n-Cannot refill</font>", 							cost="150" , type=1, bEnable = false)
	NodItemMenuData(5)				= (BlockType=EPBT_ITEM, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_MotionSensor', iconID=67, hotkey="6", title="MOTION SENSOR",	 	 desc="<font size='8'>Pros:\n-Relays enemy position in a radius\n-Detects mines and beacons\n\nCons:\n-Emits an audible sound\n-Cannot refill</font>", 								cost="200" , type=1, bEnable = false)
	NodItemMenuData(6)				= (BlockType=EPBT_ITEM, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_MG', iconID=68, hotkey="7", title="MG SENTRY",	 		 desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Infrantry\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300" , type=1, bEnable = false)
	NodItemMenuData(7)				= (BlockType=EPBT_ITEM, id=7, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Item_Sentry_AT', iconID=69, hotkey="8", title="AT SENTRY",	 		 desc="<font size='8'>Requires Armory\n\n-Automated Sentry Turret\n-Anti-Vehicle\n-Limited Ammo\n-Can be picked up\n-Cannot refill</font>", 										cost="300" , type=1, bEnable = false)

	NodWeaponMenuData(0)			= (BlockType=EPBT_WEAPON, id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_HeavyPistol', iconID=36, hotkey="1", title="HEAVY PISTOL",	 		  desc="Good Vs:\n-Infrantry\n-Light Armour Vehicles\n\nWeak Vs:\n-Buildings\n-Light Armour Vehicles", 									 cost="100", type=2, damage=4,range=2,rateOfFire=3,magCap=2)
	NodWeaponMenuData(1)			= (BlockType=EPBT_WEAPON, id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Carbine', iconID=72, hotkey="2", title="CARBINE",	 			      desc="Good Vs:\n-Infantry\n-Light Armour\n\nWeak Vs:\n-Heavy Armour\n-Buildings",	 													 cost="250", type=2, damage=3,range=3,rateOfFire=4,magCap=2)
	NodWeaponMenuData(2)			= (BlockType=EPBT_WEAPON, id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibFlechetteRifle', iconID=57, hotkey="3", title="TIBERIUM FLECHETTE RIFLE",  desc="[Requires Silo] \nGood Vs: \n-Infrantry\n-Light Armour\nWeak Vs:\n-Heavy Armour\n-Buildings",				 cost="400", type=2, damage=2,range=3,rateOfFire=5,magCap=3, bSilo = true)
	NodWeaponMenuData(3)			= (BlockType=EPBT_WEAPON, id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=56, hotkey="4", title="TIBERIUM AUTO-RIFLE",	 	  desc="[Requires Silo] \nGood Vs: \n-Infrantry\n-Light Armour\nWeak Vs:\n-Heavy Armour\n-Buildings",				 cost="400", type=2, damage=4,range=3,rateOfFire=2,magCap=3, bSilo = true)
	NodWeaponMenuData(4)			= (BlockType=EPBT_WEAPON, id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_EMPGrenade', iconID=30, hotkey="5", title="EMP GRENADE",	 			  desc="\nPros:\n-Disables vehicles\n-Disarm mines\n\nCons:\n-Weapons remain active", 					 		 cost="300", type=1)
	NodWeaponMenuData(5)			= (BlockType=EPBT_WEAPON, id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ATMine', iconID=26, hotkey="6", title="ANTI-TANK MINE",	 		  desc="\nPros:\n-Heavy vehicle damage\n\nCons:\n-Can be destroyed\n-Limit 2 per person", 						 cost="250", type=1)
	NodWeaponMenuData(6) 			= (BlockType=EPBT_WEAPON, id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SmokeGrenade', iconID=74, hotkey="7", title="SMOKE GRENADE",	 	      desc="\nPros:\n-Reduces Visibility\n-Disables Target Info\n\nCons:\n-Weapons remain active", 					 cost="100", type=1)


	NodVehicleMenuData(0)			= (BlockType=EPBT_VEHICLE, id=0, hotkey="1")
	NodVehicleMenuData(1)			= (BlockType=EPBT_VEHICLE, id=1, hotkey="2")
	NodVehicleMenuData(2)			= (BlockType=EPBT_VEHICLE, id=2, hotkey="3")
	NodVehicleMenuData(3)			= (BlockType=EPBT_VEHICLE, id=3, hotkey="4")
	NodVehicleMenuData(4)			= (BlockType=EPBT_VEHICLE, id=4, hotkey="5")
	NodVehicleMenuData(5)			= (BlockType=EPBT_VEHICLE, id=5, hotkey="6")
	NodVehicleMenuData(6)			= (BlockType=EPBT_VEHICLE, id=6, hotkey="7")
	NodVehicleMenuData(7)			= (BlockType=EPBT_VEHICLE, id=7, hotkey="8", bEnable = false)
	NodVehicleMenuData(8)			= (BlockType=EPBT_VEHICLE, id=8, hotkey="9", bEnable = false)
	NodVehicleMenuData(9)			= (BlockType=EPBT_VEHICLE, id=9, hotkey="0", bEnable = false)


	GDIEquipmentSideArmData(0) 		= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Pistol', iconID=45, hotkey="[F1]", title="Silenced Pistol",  desc="Sidearm", 	WeaponClass = class'Rx_Weapon_Pistol',      bFree=true);
	GDIEquipmentSideArmData(1) 		= (id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MachinePistol', iconID=40, hotkey="[F1]", title="Machine Pistol",   desc="Sidearm", 	WeaponClass = class'Rx_Weapon_SMG_GDI',     bFree=true);
	GDIEquipmentSideArmData(2) 		= (id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="[F1]", title="Repair Tool",      desc="Sidearm", 	WeaponClass = class'Rx_Weapon_RepairTool',  bFree=true, bEnable=false);
	GDIEquipmentSideArmData(3) 		= (id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_HeavyPistol', iconID=36, hotkey="[F1]", title="Heavy Pistol",     desc="Sidearm", 	WeaponClass = class'Rx_Weapon_HeavyPistol');
	GDIEquipmentSideArmData(4) 		= (id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Carbine', iconID=72, hotkey="[F1]", title="Carbine",          desc="Sidearm", 	WeaponClass = class'Rx_Weapon_Carbine');
	GDIEquipmentSideArmData(5) 		= (id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibFlechetteRifle', iconID=57, hotkey="[F1]", title="Flechette Rifle",  desc="Sidearm", 	WeaponClass = class'Rx_Weapon_TiberiumFlechetteRifle');
	GDIEquipmentSideArmData(6) 		= (id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=56, hotkey="[F1]", title="Auto-Rifle",       desc="Sidearm", 	WeaponClass = class'Rx_Weapon_TiberiumAutoRifle');

	GDIEquipmentExplosiveData(0) 	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TimedC4', iconID=58, hotkey="[F2]", title="Timed C4", 		 desc="Explosives", WeaponClass = class'Rx_Weapon_TimedC4',     bFree=true);
	GDIEquipmentExplosiveData(1) 	= (id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FragGrenade', iconID=33, hotkey="[F2]", title="Grenades", 		 desc="Explosives", WeaponClass = class'Rx_Weapon_Grenade',     bFree=true);
	GDIEquipmentExplosiveData(2) 	= (id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SmokeGrenade', iconID=74, hotkey="[F2]", title="Smoke Grenade", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_SmokeGrenade');
	GDIEquipmentExplosiveData(3) 	= (id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_EMPGrenade', iconID=30, hotkey="[F2]", title="EMP Grenade", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_EMPGrenade');
	GDIEquipmentExplosiveData(4) 	= (id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ATMine', iconID=26, hotkey="[F2]", title="Anti-Tank Mine", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_ATMine');
	GDIEquipmentExplosiveData(5) 	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ProxyC4', iconID=46, hotkey="[F2]", title="Proximity C4", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_ProxyC4');
	GDIEquipmentExplosiveData(6) 	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RemoteC4', iconID=49, hotkey="[F2]", title="Remote C4", 	     desc="Explosives", WeaponClass = class'Rx_Weapon_RemoteC4');

	NodEquipmentSideArmData(0) 		= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Pistol', iconID=45, hotkey="[F1]", title="Silenced Pistol",  desc="Sidearm", 	WeaponClass = class'Rx_Weapon_Pistol',      bFree=true);
	NodEquipmentSideArmData(1) 		= (id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MachinePistol', iconID=40, hotkey="[F1]", title="Machine Pistol",   desc="Sidearm", 	WeaponClass = class'Rx_Weapon_SMG_Nod',     bFree=true);
	NodEquipmentSideArmData(2) 		= (id=2, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairTool', iconID=73, hotkey="[F1]", title="Repair Tool",      desc="Sidearm", 	WeaponClass = class'Rx_Weapon_RepairTool',  bFree=true, bEnable=false);
	NodEquipmentSideArmData(3) 		= (id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_HeavyPistol', iconID=36, hotkey="[F1]", title="Heavy Pistol",     desc="Sidearm", 	WeaponClass = class'Rx_Weapon_HeavyPistol');
	NodEquipmentSideArmData(4) 		= (id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Carbine', iconID=72, hotkey="[F1]", title="Carbine",          desc="Sidearm", 	WeaponClass = class'Rx_Weapon_Carbine');
	NodEquipmentSideArmData(5) 		= (id=5, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibFlechetteRifle', iconID=57, hotkey="[F1]", title="Flechette Rifle",  desc="Sidearm", 	WeaponClass = class'Rx_Weapon_TiberiumFlechetteRifle');
	NodEquipmentSideArmData(6) 		= (id=6, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibAutoRifle', iconID=56, hotkey="[F1]", title="Auto-Rifle",       desc="Sidearm", 	WeaponClass = class'Rx_Weapon_TiberiumAutoRifle');

	NodEquipmentExplosiveData(0)	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TimedC4', iconID=58, hotkey="[F2]", title="Timed C4", 		 desc="Explosives", WeaponClass = class'Rx_Weapon_TimedC4',      bFree=true);
	NodEquipmentExplosiveData(1) 	= (id=1, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FragGrenade', iconID=33, hotkey="[F2]", title="Grenades", 		 desc="Explosives", WeaponClass = class'Rx_Weapon_Grenade',      bFree=true);
	NodEquipmentExplosiveData(2) 	= (id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SmokeGrenade', iconID=74, hotkey="[F2]", title="Smoke Grenade", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_SmokeGrenade');
	NodEquipmentExplosiveData(3) 	= (id=3, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_EMPGrenade', iconID=30, hotkey="[F2]", title="EMP Grenade", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_EMPGrenade');
	NodEquipmentExplosiveData(4) 	= (id=4, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ATMine', iconID=26, hotkey="[F2]", title="Anti-Tank Mine", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_ATMine');
	NodEquipmentExplosiveData(5) 	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ProxyC4', iconID=46, hotkey="[F2]", title="Proximity C4", 	 desc="Explosives", WeaponClass = class'Rx_Weapon_ProxyC4');
	NodEquipmentExplosiveData(6) 	= (id=0, PTIconTexture=Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RemoteC4', iconID=49, hotkey="[F2]", title="Remote C4", 	     desc="Explosives", WeaponClass = class'Rx_Weapon_RemoteC4');
	
	PurchaseSound = SoundCue'RenXPurchaseMenu.Sounds.RenXPTSoundPurchase'



	//Animation
	menuFadeInTotalTime=0.3
	menuFadeOutTotalTime=0.3

	firstDrawerFadeInTotalTime=0.3
	firstDrawerFadeOutTotalTime=0.3

	secondDrawerFadeInTotalTime=0.3
	secondDrawerFadeOutTotalTime=0.3


	currentlySelectedButtonIndex=-1

	bottomBarPadding=200

	// Chat Log Configuration
    ChatLogX=10
    ChatLogY=100
    ChatLogWidth=250
    ChatLogHeight=650
    ChatLogPadding=10
    ChatLogTitleScale=1
    ChatLogTextScale=1
    ChatLogLineSpacing=10
    ChatLogTitleHeight=35
    ChatLogBorderThickness=2
    ChatLogBackgroundAlpha=20

	chatLogFadeInTotalTime=0.3

	RotationIncrement 				= 1000
}