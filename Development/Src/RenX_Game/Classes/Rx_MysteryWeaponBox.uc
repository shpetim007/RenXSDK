class Rx_MysteryWeaponBox extends Actor
implements (Rx_ObjectTooltipInterface)
implements(RxIfc_Targetable)
implements(RxIfc_TargetedDescription)
implements(Rx_HackableInterface)
placeable;

var() StaticMeshComponent Mesh;

var const array<class<Rx_Weapon> > Weapons;
var() float WeaponAlpha;
var() vector WeaponLocation, DesiredLocation;
var bool AnimPlaying;

var() float InterpSpeed;

var Rx_MysteryWeapon Weapon;

var() const editconst DynamicLightEnvironmentComponent LightEnvironment;

var string Tooltip;

var repnotify bool bActive;
var() repnotify bool bEnabled;
var repnotify bool bInUse;

var float MaxUseDistance;

var int Cost;

var Rx_Controller CurrentUser;

var() int UseCountMin <UIMin=0 | UIMax=999>;
var() int UseCountMax <UIMin=0 | UIMax=999>;

var() class<Rx_MysteryWeapon> MysWeaponClass;

var int UsesLeft;

replication
{
	if (bNetDirty || bNetInitial)
		bActive, Weapon, CurrentUser, UsesLeft, bEnabled, MysWeaponClass,AnimPlaying,bInUse;
}

simulated function ReplicatedEvent(name VarName)
{
    if (VarName == 'bInUse')
    {
        if (bInUse) 
        {
            StartWeaponAnimClient();
        }
        else 
            Reset();
    }
    else if (VarName == 'bEnabled')
    {
        SetBoxClientEnabled(bEnabled);
    }
}

function EnableBox()
{
	GenerateUseCount();
	bEnabled = true;
}

simulated function SetBoxClientEnabled(bool InEnabled)
{
	SetCollision(InEnabled, InEnabled);
	Mesh.SetHidden(!InEnabled);
}

simulated function PostBeginPlay()
{
    if (Role == ROLE_Authority)
    {
        Weapon = Spawn(MysWeaponClass, self,,Location,Rotation,,true);
        Weapon.Mesh.SetLightEnvironment(LightEnvironment);
        GenerateUseCount();
    }
}

function GenerateUseCount()
{
	UsesLeft = Max(Rand(UseCountMax), UseCountMin);
}

simulated function hack(){};
reliable server function StartHackServer(Rx_Controller User){};

simulated function useMysteryBox()
{

}

reliable server function ServerUseMysterBox(Rx_Controller User)
{
	if (CurrentUser != None || Rx_PRI(User.PlayerReplicationInfo).GetCredits() < Cost || !bEnabled || UsesLeft < 1)
	{
		`log("Can't use "@CurrentUser@Rx_PRI(User.PlayerReplicationInfo).GetCredits() < Cost@!bEnabled@UsesLeft);
		 return;
	}

	CurrentUser = User;
	Rx_PRI(CurrentUser.PlayerReplicationInfo).RemoveCredits(Cost);
	StartWeaponAnim();
    bInUse=true;
}

simulated function stopHack();

simulated function bool IsInRange()
{
	local Rx_Controller controller;
    controller = Rx_Controller(GetALocalPlayerController());

    if (VSizeSq(Rx_Pawn(controller.Pawn).Location - self.Location) > Square(MaxUseDistance))
    {
        return false;
    }

    return true;
}

simulated function bool CanAfford()
{
	local Rx_Controller controller;
    controller = Rx_Controller(GetALocalPlayerController());

    return Rx_PRI(Controller.PlayerReplicationInfo).GetCredits() >= Cost;
}

simulated function Reset()
{
    `log("Reset called");
	Weapon.SetLocation(Location);
	Weapon.StopAnimation();
	WeaponLocation = Location;
	AnimPlaying = false;
	SetWeaponVisible(false);
	CurrentUser = None;

	bNetDirty = true;
	ForceNetRelevant();
}

simulated function StartWeaponAnim()
{
	SetWeaponVisible(true);
	Weapon.BeginAnimation(4.5);
	SetTimer(5.0, false, nameof(Finish));

	AnimPlaying = true;

	WeaponLocation = Location;
	DesiredLocation = Location + vect(0,0,50);

	bNetDirty = true;
	ForceNetRelevant();
}

simulated function StartWeaponAnimClient()
{
    if (Role == ROLE_Authority)
        return; // Server uses StartWeaponAnim() instead
    
    //Weapon.BeginAnimation(4.5);
    AnimPlaying = true;
    WeaponLocation = Location;
    DesiredLocation = Location + vect(0,0,50);
    SetWeaponVisible(true);
}


function GiveRefund()
{
	Rx_PRI(CurrentUser.PlayerReplicationInfo).AddCredits(Cost);
}

function Finish()
{
	local Rx_InventoryManager InvManager;
	local Rx_Weapon NewWeap;
	local class<Rx_Weapon> WeaponClass;
	WeaponClass = Weapon.CurrentWep;

	InvManager = Rx_InventoryManager(CurrentUser.Pawn.InvManager);

	if (InvManager != None)
	{
		InvManager.PrimaryWeapons.AddItem(WeaponClass);

		NewWeap = Rx_Weapon(InvManager.CreateInventory(WeaponClass, false));
        NewWeap.bIsCrateWeapon = true;
        NewWeap.bCanGetAmmo = false;
        InvManager.SetCurrentWeapon(NewWeap);

        InvManager.PromoteAllWeapons(Rx_PRI(CurrentUser.PlayerReplicationInfo).VRank);

        CurrentUser.CTextMessage("The mystery box has awarded you a"@NewWeap.GetDisplayName());
      	UsesLeft--;
	}
	else
	{
		// currently dead or something
		GiveRefund();
	}
	
	Reset();
    
	if (UsesLeft < 1)
	{
		bActive = false;
	}
    bInUse=false;
}

simulated function Tick(float DeltaTime)
{
	local vector NewLoc;

	super.Tick(DeltaTime);

	if (AnimPlaying)
	{
		NewLoc = VInterpTo(WeaponLocation, DesiredLocation, DeltaTime, InterpSpeed);
		Weapon.SetLocation(NewLoc);
		WeaponLocation = NewLoc;

        if(Weapon.bHidden)
        {
            `log("Unhide weapon");
            Weapon.SetHidden(false);
        }
	}
}

simulated function SetWeaponVisible(bool NewBool)
{
	Weapon.SetHidden(!NewBool);
}

//
simulated function String GetHumanReadableName()
{
	return "Mystery Weapon Crate";
}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return 0;} //Return the current health of this target
simulated function int GetTargetHealthMax() {return 0;} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return 0;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return 0;} // Get the current Armour of the target 
simulated function bool GetHasResistance() {return false;} //If this unit has any kind of resistance

/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return 0;}
simulated function float GetTargetArmourPct() {return 0;}
simulated function float GetTargetMaxHealthPct() {return 1.0f;} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return false;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return false;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return true;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return IsInRange();} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return GetCurrentlyInteractable((PlayerController(PC)));} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return false;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return true;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return false;} //Does our target box 'stick' even after we're untargeted for awhile 

//Spotting
simulated function bool IsSpottable() {return false;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return GetHumanReadableName();} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "Receive a random reward for" @ Cost @ "credits";} //Get the text for our interaction 
simulated function string GetTargetedDescription(PlayerController PlayerPerspectiv) {return "targeted description";} //Get any special description we might have when targeted 

simulated function string GetTooltip(Rx_Controller PC)
{
  // if (bActive && class'Rx_Utils'.static.OrientationToB(self, PC.Pawn) > 0.1)
   //   return Repl(tooltip, "{GBA_USE}", Caps(UDKPlayerInput(PC.PlayerInput).GetUDKBindNameFromCommand("GBA_Use")), true);
   return "";
}

simulated function bool IsTouchingOnly()
{
   return false;
}

simulated function bool IsBasicOnly()
{
   return false;
}

simulated function SetTargeted(bool bTargeted)//Function to say what to do when you're targeted client-side 
{}

DefaultProperties
{
	tooltip = "Press <font color='#ff0000' size='20'>[ {GBA_USE} ]</font> to open the box." 
	//'

	MysWeaponClass = class'Rx_MysteryWeapon'

	bActive = true
    bInUse = false
	MaxUseDistance = 200
	Cost = 1

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
		bCastShadows=false
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=Crate
		CastShadow                   = True
		AlwaysLoadOnClient           = True
		AlwaysLoadOnServer           = True
		bUsePrecomputedShadows       = False
		CollideActors                = True
		BlockActors                  = True
		BlockRigidBody               = True
		BlockZeroExtent              = True
		BlockNonZeroExtent           = True
		bCastDynamicShadow           = True
		bAcceptsDynamicLights        = True
		bAcceptsLights               = True
		bAcceptsDecalsDuringGameplay = True
		bAcceptsDecals               = True
		StaticMesh=StaticMesh'RX_Deco_BuildingAssets.StaticMeshes.BuildingAssets_Crate_2_Open'
		LightingChannels                = (bInitialized=True,Static=True)
		Translation                  = (X = 20, Y = -35, Z = -10)
		LightEnvironment=MyLightEnvironment
	End Object
	Mesh = Crate
	CollisionComponent = Crate
	Components.Add(Crate)

	bCollideActors=true
 	bCollideWorld=true 
 	bCollideComplex=true
 	bBlockActors=true
 	bProjTarget=true 

 	bAlwaysRelevant=true
	bGameRelevant=true
	RemoteRole=ROLE_SimulatedProxy
	bPathColliding=true

 	InterpSpeed = 1

	bEnabled=true
	UseCountMax=999
}