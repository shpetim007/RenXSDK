class Rx_BuildingAttachment_LockableDoor extends Rx_BuildingAttachment_Door
    implements(RxIfc_HasTooltip)
    implements(Rx_HackableInterface)
    abstract;

var Rx_Buildings_DoorSensor DoorSensor;

var bool bLockable;
var float timeToHack;
var float hackDuration;
var float maxHackingDistance;

var float successHackTime;
var SoundCue HackingSound; 

/* SERVER MESSAGING */
simulated function ServerSetDoorHacked(bool hacked)
{
    if (hacked)
    {
        GotoState('Hacked');
    }
    else
    {
        GotoState('Locked');
    }
}

reliable server event HackReset() { }
/* END SERVER MESSAGING */

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	DoorSensor = Spawn(class'Rx_Buildings_DoorSensor', self, , Location, Rotation);

	if ( DoorSensor != none )
	{
		DoorSensor.RegisterDoor(self);
	}
}

/* BEGIN TOOLTIP */
simulated function Actor GetActualTarget() {
    return self;
}

simulated function bool TipsRequireTouch()
{
    return false;
}

simulated function bool IsBasicTips()
{
    return false;
}

simulated function bool UseDefaultBBox() {
    return true;
}
/* END TOOLTIP */

/* STATE LOGIC */
simulated function string GetTooltip(Rx_Controller PC) { return ""; }
simulated function hack() { }
simulated function stopHack() { }

auto simulated state InitializationState
{
    begin:
        if (bLockable)
        {
            GotoState('Locked');
        }
}

simulated state BuildingDead
{
    // empty out, treat it as its' super class
    Begin:
    if (Role == ROLE_Authority)
    {
        self.DoorSensor.DoCollide(none);
    }
}

simulated event Tick(Float Delta)
{
    super.Tick(Delta);

    if(Rx_Building_Team_Internals(OwnerBuilding) != None && Rx_Building_Team_Internals(OwnerBuilding).Health <= 0 && !IsInState('BuildingDead'))
    {
        GoToState('BuildingDead');
    }
}

simulated state Locked
{
    simulated function bool ShouldAllowActor(Actor actor) {
        if (actor == None) 
        {
            return false;
        }

        return super.ShouldAllowActor(actor) && (actor.GetTeamNum() == self.GetTeamNum() || RxIfc_Targetable(actor).IsSpyTarget());
    }

    simulated function string GetTooltip(Rx_Controller PC)
    {
        local Rx_Pawn pawn;

        pawn = Rx_Pawn(PC.Pawn);

        if (
            pawn == None 
            || pawn.GetTeamNum() == self.GetTeamNum() 
            || VSize(pawn.Location - self.Location) > maxHackingDistance
        ) {
            return "";
        }
        
        return Repl("Press [ {GBA_USE} ] to start HACKING", "{GBA_USE}", Caps(UDKPlayerInput(PC.PlayerInput).GetUDKBindNameFromCommand("GBA_Use")), true);
    }

    simulated function hack() { 
        local Rx_Controller controller;
        controller = Rx_Controller(GetALocalPlayerController());

        if (VSize(Rx_Pawn(controller.Pawn).Location - self.Location) > maxHackingDistance)
        {
            return;
        }

        successHackTime = WorldInfo.TimeSeconds + timeToHack;
        PlaySound(HackingSound); 
        GotoState('BeingHacked');
    }

    Begin:
        if (Role == ROLE_Authority)
        {
            self.DoorSensor.DoCollide(none);
        }
}

simulated state BeingHacked extends Locked
{
    simulated function string GetTooltip(Rx_Controller PC)
    {
        local int i;
	    local string FinalString; 
        local float timeLeft;
        local float percentageTimeLeft;

        timeLeft = successHackTime - WorldInfo.TimeSeconds;
        percentageTimeLeft = (timeLeft / timeToHack) * 100.0;
        for(i=1;i<11;i++){
	     FinalString $= (100 - percentageTimeLeft >= 10.0*i) ? "*" : ""$ Rand(10); 
	    }
        return FinalString; 
    }
    
    
    simulated function string GetHackingProgressBar(float timeLeft)
    {
        local string progressBar;
        local int i;
        local float percentageTimeLeft;

        percentageTimeLeft = (timeLeft / timeToHack) * 100.0;
        
        for (i = 0; i < 100 - percentageTimeLeft; i += 10) 
        {
            progressBar $= "#";
        }

        for (i = 0; i < percentageTimeLeft; i += 10)
        {
            progressBar $= "_";
        }

        return progressBar;
    }

    simulated event Tick(Float Delta) 
    {
        local Rx_Controller controller;
        controller = Rx_Controller(GetALocalPlayerController());

        if (IsPlayerNotLookingAtDoor(controller)
            || !controller.IsUsePressed()
            || VSize(Rx_Pawn(controller.Pawn).Location - self.Location) > maxHackingDistance) 
        {
            StopHack();
        } 
        else 
        {
            CheckHackSuccess();
        }
        Global.Tick(Delta);
    }

    simulated function bool IsPlayerNotLookingAtDoor(Rx_Controller controller) 
    {
        return Rx_HUD(controller.myHUD).ScreenCentreActor != self;
    }

    simulated function CheckHackSuccess()
    {
        if (successHackTime - WorldInfo.TimeSeconds < 0)
        {
            ServerSetDoorHacked(true);
            GotoState('HackedByPlayer');
        }
    }

    simulated function stopHack() { 
        GotoState('Locked');
    }
}

simulated state HackedByPlayer extends Locked
{
    simulated function notifyServerOfHack()
    {
        local RX_PRI playerReplicationInfo;
        playerReplicationInfo = RX_PRI(Rx_Controller(GetALocalPlayerController()).PlayerReplicationInfo);

        playerReplicationInfo.NotifyDoorAsHacked(self);
    }

    begin:
        notifyServerOfHack();
}

simulated state Hacked
{
    reliable server event HackReset() {
        ServerSetDoorHacked(false);
    }

    Begin:
        if (Role == ROLE_Authority)
        {
            self.DoorSensor.DoCollide(none);
            SetTimer(hackDuration, false, 'HackReset');
        }
}
/* END STATE LOGIC */

defaultproperties
{
    bLockable = false;
    timeToHack = 5.0;
    hackDuration = 60.0;
    maxHackingDistance = 180.0;
    HackingSound = none
}