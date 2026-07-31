class Rx_AreaVolume extends Volume abstract;

// Used for identifing multiple play areas that should act together.
var() const int DamageWait;
var float fWaitToWarn;
var Soundcue PlayerWarnSound;

var() const int AssignedSize;

var bool bActive;

replication
{
	if (bNetDirty && Role == ROLE_Authority)
		bActive, AssignedSize;
}

event UnTouch(Actor Other)
{
	`Log("Area Volume: UnTouch"@`ShowVar(Other),,'DevScript');
	Process(Other, true);
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	`Log("Area Volume: Touch"@`ShowVar(Other),, 'DevScript');
	Process(Other, false, OtherComp, HitLocation, HitNormal) ;
}

function Process(Actor Other, bool leaving, optional PrimitiveComponent OtherComp, optional vector HitLocation, optional vector HitNormal)
{
	local array<Controller> controllers;
	local Controller PC;
	local bool outOfArea;
	
	//local PostProcessChain ppc;
	//local UberPostProcessEffect uppe;
	//local PostProcessEffect ppe;
	//local int i;

	 // we are ghost cheat flying, ignore
	if(pawn(other) != none && playercontroller(pawn(other).Controller) != none && playercontroller(pawn(other).Controller).bCheatFlying == true)
		return;

	outOfArea = true;
	
	if(Pawn(Other) != None && !leaving && IsAcceptableAreaVolume(Self,Pawn(Other)))
		outOfArea = false;


//	if(leaving)
//		outOfArea = true;

	controllers = BuildControllersList(Other);
	if(controllers.Length == 0) // no applicable controllers found.
		return;

	if (IsInValidAreaVolume(controllers[0].Pawn)) {
		outOfArea = false;
	}
	
	foreach controllers(PC)
	{
		if(outOfArea)
		{
			OutOfAreaActions(Other, PC);
		}
		else // not out of bounds
		{
			InAreaActions(Other, PC);
		}
	}
}

/**
 * Builds a list of relevant controllers attached to the actor.
 */
function array<Controller> BuildControllersList(Actor Other, optional PrimitiveComponent OtherComp, optional vector HitLocation, optional vector HitNormal)
{
	local array<Controller> controllers;
	local int index;

	if (UDKVehicle(Other) != None) // A vehicle - Add all occupants
	{
		for (index = 0; index != UDKVehicle(Other).Seats.Length; ++index)
			if (UDKVehicle(Other).Seats[index].SeatPawn != none && UDKVehicle(Other).Seats[index].SeatPawn.Controller != None && Rx_Controller(UDKVehicle(Other).Seats[index].SeatPawn.Controller) != None)
				controllers.AddItem(Rx_Controller(UDKVehicle(Other).Seats[index].SeatPawn.Controller));
	}
	else if(pawn(Other) != None && pawn(other).DrivenVehicle != none)
	{
		touch(pawn(other).DrivenVehicle,OtherComp, HitLocation, HitNormal);
	}
	else if (pawn(Other) != None && pawn(Other).Controller != None)
		controllers.AddItem((Pawn(Other).Controller));
	else if(pawn(other.Owner) != none && pawn(other.Owner).Controller != none)
		controllers.AddItem(pawn(other.Owner).Controller);
	else
		`Logd("Actor is not a vehicle, and doesnt have a controller, meaning not a human or bot, so ignoring",, 'DevScript');

	return controllers;
}

function OutOfAreaActions(Actor Other, Controller PC);

function InAreaActions(Actor Other, Controller PC);

//TODO Bots
function AreaWarningEffects(Bool enable, Controller PC)
{
	`Logd("Area Volume: AreaWarningEffects"@`ShowVar(enable),, 'DevScript');
	if(Rx_Controller(PC) != None)
		Rx_Controller(PC).SetOOB(enable, DamageWait, fWaitToWarn);
}

function bool IsAcceptableAreaVolume(Rx_AreaVolume V, Pawn P)
{
	return bActive;
}

/**
 * This function is structured to handle situations with overlapping volumes, if 2 or more volumes overlap, and an actor is walking from out of one and into another.
*/
function bool IsInValidAreaVolume(Pawn P)
{
	local Rx_AreaVolume V;

	foreach P.CollidingActors( class'Rx_AreaVolume', V , 200.f,P.Location,true)
	{
		if (V.Encompasses(P) && V.IsAcceptableAreaVolume(V, P))
		{
			return true;
		}
	}

	return false;
}

DefaultProperties
{
	//how long before PlayerWarnSound is played and damage countdown starts.
	fWaitToWarn				= 1.0f 
	
	//sounds
	PlayerWarnSound			= SoundCue'RX_Dialogue.Generic.S_BackToObjective_Cue'
	
	//the damage countdown. How long to give the player/actor before applying damage.
	DamageWait				= 10
	
	//internal
	bPawnsOnly 			    = true

	bActive = true
}
