/*********************************************************
*
* File: Rx_Vehicle_Harvester.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_HarvesterController_Mesh extends Rx_Vehicle_HarvesterController;

var transient Rx_Tib_NavigationPoint tibNode;
var transient Rx_Ref_NavigationPoint refNode;

var transient NavigationPoint BlockedNavPointBehindMe;
var transient vector refineryLoc,NavMoveTarget, vFinalDest, IntermediatePoint;
var transient rotator refineryRot;
var transient Rx_BuildingAttachment DockingStation;
var transient bool bTurnLeftToFaceRef, bIntermediateMoveError;
var transient int lastPathTime;
var transient float GoalDistance, Radius, SubGoalReachDist;

var transient array<vector> MovePointsList;

var transient vector LastMovePoint;
var transient int NumMovePointFails;
var int MaxMovePointFails;
var transient Vector FallbackDest;

/** is this AI on 'final approach' ( i.e. moving directly to it's end-goal destination )*/
var bool bFinalApproach;

/** TRUE when we are trying to get back on the mesh */
var bool bFallbackMoveToMesh;

/** storage of initial desired move location */
var transient vector InitialFinalDestination;

/** location of MoveToActor last time we did pathfinding */
var BasedPosition LastMoveTargetPathLocation;

//Commander variables for halting the harvester
var name StateWhenLastMoving; 
var Actor NavPointWhenHalted;
var bool bIgnoreBlockHarvNodes; 

var float harvestingStartTime;

//var Rx_BlockedForHarvesterPathnode	Nav;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	InitPlayerReplicationInfo();
}

event SetTeam(int inTeamIdx)
{
    TeamNum = inTeamIdx;
}


event bool GeneratePathToActor( Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	return class'Rx_NavUtils'.static.NavMeshFindPathToActor(pawn, Goal, WithinDistance, bAllowPartialPath);
}

event bool GeneratePathToLocation( Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath )
{
	return class'Rx_NavUtils'.static.NavMeshFindPathToLocation(pawn, Goal, WithinDistance, bAllowPartialPath);
}

function InitPlayerReplicationInfo()
{
	if(PlayerReplicationInfo != none)
	{
		CleanupPRI();
	}
	PlayerReplicationInfo = Spawn(class'Rx_DefencePRI', self);

	if (PlayerReplicationInfo != none) {
		PlayerReplicationInfo.SetPlayerName(Owner.GetHumanReadableName());
		PlayerReplicationInfo.SetPlayerTeam(WorldInfo.GRI.Teams[Owner.GetTeamNum()]);
	}
	SetTimer(0.05, false, 'CheckRadarVisibility'); 	
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess(inPawn, bVehicleTransition);
	SetRadarVisibility(RadarVisibility);
}


function StopMovement()
{
	local Vehicle V;

	if (Pawn.Physics != PHYS_Flying)
	{
		Pawn.Acceleration = vect(0,0,0);
	}
	V = Vehicle(Pawn);
	if (V != None)
	{
		V.Steering = 0;
		V.Throttle = 0;
		V.Rise = 0;
	}
}

function bool SetupMoveToGoal(Actor InGoal, float InGoalDistance)
{
	GoalDistance = InGoalDistance;
	ScriptedMoveTarget = InGoal;
	InitialFinalDestination = InGoal.GetDestination(self);
	return true;
}

function bool SetupMoveToPoint(Vector InPoint, float InGoalDistance)
{
	GoalDistance = InGoalDistance;
	ScriptedMoveTarget = none;
	InitialFinalDestination = InPoint;
	return true;	
}

auto state idle
{	
}

/*
 * Extends State ScriptedMove from Superclass AIController
 */
state ScriptedMove
{
	ignores SeePlayer, SeeMonster, HearNoise, NotifyHitWall;

	event PoppedState()
	{
		Super(ScriptedMove).PoppedState();

		ClearLatentAction( class'SeqAct_AIMoveToActor' );

		NavigationHandle.PathCache_Empty();

		if (Pawn != None)
		{
			//StopMovement();
			Pawn.ZeroMovementVariables();
			Pawn.DestinationOffset = 0.f;
		}
	}

	final function float GetMoveDestinationOffset()
	{
		// return a negative destination offset so we get closer to our points (yay)
		if( bFinalApproach )
		{
			return GoalDistance;
		}
		else
		{
			return (SubGoalReachDist-pawn.GetCollisionRadius());
		}
	}

	final function bool GetNextMove(out vector loc)
	{
		local float neededDist;

		`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"Getting Next Move location. I'm at:"@pawn.Location);

		neededDist = pawn.GetCollisionRadius() * 0.1f;
		`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@`showvar(neededDist));
		if(navigationhandle.GetNextMoveLocation(loc, SubGoalReachDist))
		{
			
			`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"Distance to returned location"@ VSize(loc-pawn.Location));

			`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"Returning getnextmovelocation result");
			
			drawdebugline(pawn.Location, loc, 0,255,0, true);
			drawdebugsphere(loc, 16, 20, 0,255,0, true);
			
			return true;
		}
		else
			return false;
	}

CheckMove:
	//debug
	`LogRx("(" $ Pawn.name $ ")"@GetPackageName()@GetFuncName()@"CHECKMOVE TAG");

	if( class'Rx_NavUtils'.static.HasReachedGoal(pawn, ScriptedMoveTarget, GoalDistance, bFinalApproach) )
	{
		Goto( 'ReachedGoal' );
	}

Begin:
	`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" BEGIN TAG"@GetStateName());

	drawdebugline(pawn.Location,  ScriptedMoveTarget.Location, 255,255,0, true);
	drawdebugsphere(ScriptedMoveTarget.Location, 16, 20, 255,255,0, true);

	SubGoalReachDist = pawn.GetCollisionRadius() * 2;

	bIntermediateMoveError = false;

	if( bFallbackMoveToMesh )
	{
		`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"Going into breadcrumb fallback state to get back onto navmesh CurLoc:"@Pawn.Location);
		GotoState('Fallback_Breadcrumbs');
	}
	if( !NavigationHandle.ComputeValidFinalDestination(InitialFinalDestination) )
		
	{
		`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"ABORTING! Final destination"@InitialFinalDestination@"is not reachable! (ComputeValidFinalDestination returned FALSE)");
		GotoState('DelayFailure');
	}
	else if( !NavigationHandle.SetFinalDestination(InitialFinalDestination) )
	{
		`LogRx("(" $ Pawn.name $ ")" @GetPackageName()@GetFuncName()@"ABORTING! Final destination"@InitialFinalDestination@"is not reachable! (SetFinalDestination returned FALSE)");
		GotoState('DelayFailure');
	}

	drawdebugline(pawn.Location, BP2Vect(NavigationHandle.FinalDestination), 255,0,0, true);
	drawdebugsphere(BP2Vect(NavigationHandle.FinalDestination), 16, 20, 255,0,0, true);

	navigationhandle.bDebugConstraintsAndGoalEvals = true;
	//navigationhandle.bUltraVerbosePathDebugging = true;
	//navigationhandle.bVisualPathDebugging = true;

	if( PointReachable(BP2Vect(NavigationHandle.FinalDestination)) )
	{
		`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" ScriptedMoveTarget is directly reachable");
		IntermediatePoint = BP2Vect(NavigationHandle.FinalDestination);
	}
	else
	{
		if( ScriptedMoveTarget != None )
		{
			// update final dest in case target moved
			if( !NavigationHandle.SetFinalDestination(ScriptedMoveTarget.GetDestination(self)) )
			{
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@"ABORTING! Final destination"@InitialFinalDestination@"is not reachable! (SetFinalDestination returned FALSE)");
				Goto('FailedMove');
			}
		}

		if( !GeneratePathToLocation( BP2Vect(NavigationHandle.FinalDestination),GoalDistance, false ) )
		{
			//debug
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Couldn't generate path to location"@BP2Vect(NavigationHandle.FinalDestination)@"from"@Pawn.Location);
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@`ShowVar(navigationhandle.LastPathError));

			`LogRx("Retrying with mega debug on");
			NavigationHandle.bDebugConstraintsAndGoalEvals = TRUE;
			//NavigationHandle.bUltraVerbosePathDebugging = TRUE;
			GeneratePathToLocation( BP2Vect(NavigationHandle.FinalDestination),GoalDistance, TRUE );
			Sleep(1.0f);
			Goto( 'FailedMove' );
		}

		//debug
		`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Generated path..." );
		`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Found path!" @ `showvar(BP2Vect(NavigationHandle.FinalDestination)), 'Move' );

		drawdebugline(pawn.Location, BP2Vect(NavigationHandle.FinalDestination), 255,0,255, true);
		drawdebugsphere(BP2Vect(navigationHandle.FinalDestination), 16, 20, 255,0,255, true);

		NavigationHandle.PrintPathCacheDebugText();
		navigationhandle.DrawPathCache(,True);

		IntermediatePoint = navigationhandle.GetFirstMoveLocation();

		/*if( !GetNextMove( IntermediatePoint) )		
		{
			//debug
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Generated path, but couldn't retrieve next move location?");

			Goto( 'FailedMove' );
		}*/

	}

	if( ScriptedMoveTarget != None )
	{
		Vect2BP(LastMoveTargetPathLocation, ScriptedMoveTarget.GetDestination(self));
	}

	while( TRUE )
	{
		if(bIntermediateMoveError)
			Goto('Begin');
		else
			`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Still moving to"@IntermediatePoint );

		bFinalApproach = VSizeSq(IntermediatePoint - BP2Vect(NavigationHandle.FinalDestination)) < 1.0;
		
		`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Calling MoveTo -- "@IntermediatePoint);
		// if on our final move to an Actor, send it in directly so we account for any movement it does
		if( (bFinalApproach) && ScriptedMoveTarget != None )
		{
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@"  - Final approach to" @ ScriptedMoveTarget $ ", using MoveToward()");
			Vect2BP(LastMoveTargetPathLocation, ScriptedMoveTarget.GetDestination(self));
			NavigationHandle.SetFinalDestination(ScriptedMoveTarget.GetDestination(self));
			//if(Scriptedmovetarget.bStatic)
				//MoveToDirectNonPathPos(ScriptedMoveTarget.Location, ScriptedFocus, GetMoveDestinationOffset(), false);
			//else
				MoveToward(ScriptedMoveTarget, ScriptedFocus, GetMoveDestinationOffset(), FALSE);
		}
		else if (bFinalApproach)
		{
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@"  - Final approach to" @ ScriptedMoveTarget $ ", using MoveToDirectNonPathPos()");
			MoveToDirectNonPathPos(ScriptedMoveTarget.GetDestination(self), ScriptedFocus, GetMoveDestinationOffset(), false);
		}
		else
		{
			// if we weren't given a focus, default to looking where we're going
			SetFocalPoint(IntermediatePoint);

			if(!navigationhandle.SuggestMovePreparation(IntermediatePoint, self)) //if true, the edge will handle the move for us.
			{
				drawdebugline(pawn.Location, IntermediatePoint, 127,255,0, true);
				drawdebugsphere(IntermediatePoint, 16, 20, 127,255,0, true);

				// use a negative offset so we get closer to our points!
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" MoveTo -- "@IntermediatePoint);
				//SanitiseNextPath(IntermediatePoint);
				MoveTo(IntermediatePoint, ScriptedFocus, GetMoveDestinationOffset());
			}
		}
		`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" MoveTo Finished -- "@IntermediatePoint);

// 				if( bReevaluatePath )
// 				{
// 					ReEvaluatePath();
// 				}

		if( class'Rx_NavUtils'.static.HasReachedGoal(pawn, ScriptedMoveTarget, GoalDistance, bFinalApproach) )
		{
			`LogRx( "( " $ Pawn.name $ " ) " @ GetPackageName()@GetFuncName()@ "HasReachedGoal() returned true");
			Goto( 'CheckMove' );
		}
		// if we are moving towards a moving target, repath every time we successfully reach the next node
		// as that Pawn's movement may cause the best path to change
		else if( ScriptedMoveTarget != None &&
			VSizeSq(ScriptedMoveTarget.Location - BP2Vect(LastMoveTargetPathLocation)) > 262144.0 )
		{
			Vect2BP(LastMoveTargetPathLocation, ScriptedMoveTarget.location);
			`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Repathing because target moved:" @ ScriptedMoveTarget);
			Goto('CheckMove');
		}
		else if( !GetNextMove(IntermediatePoint) )
		{
			`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@ " Couldn't get next move location" );
			if (!bFinalApproach && ((ScriptedMoveTarget != None) ? /*NavigationHandle.*/ActorReachable(ScriptedMoveTarget) : /*NavigationHandle.*/PointReachable(BP2Vect(NavigationHandle.FinalDestination))))
			{
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@ "Target is directly reachable; try direct move");
				IntermediatePoint =((ScriptedMoveTarget != None) ? ScriptedMoveTarget.location : BP2Vect(NavigationHandle.FinalDestination));
				Sleep(RandRange(0.1,0.175));
			}
			else
			{
				Sleep(0.1f);
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" GetNextMoveLocation returned false, and finaldest is not directly reachable");

				Goto('FailedMove');
			}
		}
		else
		{
			if(VSizeSq(IntermediatePoint-LastMovePoint) < Square(Pawn.GetCollisionRadius() * 0.1f) )
			{
				NumMovePointFails++;

				DrawDebugBox(Pawn.Location, vect(2,2,2) * NumMovePointFails, 255, 255, 255, true );
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" WARNING: Got same move location... something's wrong?!"@`showvar(LastMovePoint)@`showvar(IntermediatePoint)@"Delta"@VSize(LastMovePoint-IntermediatePoint)@"ChkDist"@(Pawn.GetCollisionRadius() * 0.1f));
				
			}
			else
			{
				NumMovePointFails=0;
			}
			LastMovePoint = IntermediatePoint;

			if(NumMovePointFails >= MaxMovePointFails && MaxMovePointFails >= 0)
			{
				`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" ERROR: Got same move location 5x in a row.. something's wrong! bailing from this move");
				GotoState('Fallback_Breadcrumbs','Begin');
			}
			else
			{
				//debug
				`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" NextMove"@IntermediatePoint@`showvar(NumMovePointFails) );
			}
		}
	}

	//debug
	`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Reached end of move loop??" );

	Goto( 'CheckMove' );	

FailedMove:

	`LogRx( "(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Failed move.  Now ZeroMovementVariables" );

	drawdebugline(pawn.Location, ScriptedMoveTarget.Location,255,0,0,true);
	drawdebugline(pawn.Location, BP2Vect(NavigationHandle.FinalDestination),0,0,255,true);

	/**bResult = NavigationHandle.ActorReachable(ScriptedMoveTarget);
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" NavigationHandle.ActorReachable says:" @ bResult,true,'DevPath');
	bResult = NavigationHandle.PointReachable(BP2Vect(NavigationHandle.FinalDestination));
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" NavigationHandle.PointReachable says:" @ bResult,true,'DevPath');
	bResult = NavigationHandle.LineCheck(Pawn.Location, BP2Vect(NavigationHandle.FinalDestination), pawn.GetCollisionExtent());
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" NavigationHandle.LineCheck says:" @ bResult,true,'DevPath');
	bResult = class'navigationhandle'.static.ObstacleLineCheck(Pawn.Location,BP2Vect(NavigationHandle.FinalDestination), pawn.GetCollisionExtent());
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" class'navigationhandle'.static.ObstacleLineCheck says:" @ bResult,true,'DevPath');
	bResult = FastTrace(BP2Vect(NavigationHandle.FinalDestination));
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Controller.FastTrace says:" @ bResult,true,'DevPath');
	bResult = PointReachable(BP2Vect(NavigationHandle.FinalDestination));
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Controller.PointReachable says:" @ bResult,true,'DevPath');
	bResult = ActorReachable(ScriptedMoveTarget);
	`log("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Controller.ActorReachable says:" @ bResult,true,'DevPath');*/

	MoveTo(Pawn.Location);
	Pawn.ZeroMovementVariables();
	GotoState('DelayFailure');

ReachedGoal:
	//debug
	`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" Reached move point:"@BP2Vect(NavigationHandle.FinalDestination)@VSize(Pawn.Location-BP2Vect(NavigationHandle.FinalDestination)));

	navigationhandle.ClearConstraints();
	navigationhandle.PathCache_Empty();

	Popstate();
}

function bool ShouldUpdateBreadCrumbs()
{
	return true;
}

/**
 * Called by APawn::moveToward when the point is unreachable
 * due to obstruction or height differences.
 */
event MoveUnreachable(vector AttemptedDest, Actor AttemptedTarget)
{
	`log("=== Rx_Vehicle_HarvesterController: Point"@AttemptedDest@AttemptedTarget@"unreachable ===");
}

/** called when a ReachSpec the AI wants to use is blocked by a dynamic obstruction
 * gives the AI an opportunity to do something to get rid of it instead of trying to find another path
 * @note MoveTarget is the actor the AI wants to move toward, CurrentPath the ReachSpec it wants to use
 * @param BlockedBy the object blocking the path
 * @return true if the AI did something about the obstruction and should use the path anyway, false if the path
 * is unusable and the bot must find some other way to go
 */
event bool HandlePathObstruction(Actor BlockedBy){
	`LogRx("HarvesterController: Path Obstruction Event by:" @BlockedBy,,'DevAI');
	
	MoveTimer = -1.f; // kills latent moveto's
	GotoState('Fallback_Breadcrumbs');
	
	return false;
}

state DelayFailure
{
	function bool HandlePathObstruction(Actor BlockedBy);
	
Begin:
	Sleep( 0.5f );
	GotoState('Fallback_Breadcrumbs','Begin');

}

 /* this state will follow our breadcrumbs backward until we are back in the mesh, and then transition back to moving, or go to other fallback states
 * if we run out of breadcrumbs and are not yet back in the mesh
 */
state Fallback_Breadcrumbs
{

	function bool ShouldUpdateBreadCrumbs()
	{
		return false;
	}

	function bool HandlePathObstruction(Actor BlockedBy)
	{
		Pawn.SetLocation(IntermediatePoint);
		MoveTimer=-1;
		GotoState('Fallback_Breadcrumbs','Begin');
		return true;
	}

Begin:
`LogRx("trying to move back along breadcrumb path");
	if( NavigationHandle.GetNextBreadCrumb(IntermediatePoint) )
	{
		`LogRx("Moving to breadcrumb pos:"$IntermediatePoint);
// 		GameAIOwner.DrawDebugLine(Pawn.Location,IntermediatePoint,255,0,0,TRUE);
// 		GameAIOwner.DrawDebugLine(IntermediatePoint+vect(0,0,100),IntermediatePoint,255,0,0,TRUE);

		MoveToDirectNonPathPos(IntermediatePoint);

		if( !NavigationHandle.IsAnchorInescapable() )
		{
			GotoState('ScriptedMove');
		}
		Sleep(0.1);
		Goto('Begin');
	}
	else if( !NavigationHandle.IsAnchorInescapable())
	{
		GotoState('ScriptedMove','Begin');
	}
	else
	{
		GotoState('Fallback_FindNearbyMeshPoint');
	}

}

state Fallback_FindNearbyMeshPoint
{
	function bool FindAPointWhereICanMoveTo( out Vector out_FallbackDest, float Inradius, optional float minRadius=0, optional float entityRadius = 32, optional bool bDirectOnly=true, optional int MaxPoints=-1,optional float ValidHitBoxSize)
	{
		local Vector Retval;
		local array<vector> poses;
//		local int i;
		local vector extent;
		local vector validhitbox;

		Extent.X = entityRadius;
		Extent.Y = entityRadius;
		Extent.Z = entityRadius;

		validhitbox = vect(1,1,1) * ValidHitBoxSize;
		NavigationHandle.GetValidPositionsForBox(Pawn.Location,Inradius,Extent,bDirectOnly,poses,MaxPoints,minRadius,validhitbox);
// 		for(i=0;i<Poses.length;++i)
// 		{
// 			DrawDebugStar(poses[i],55.f,255,255,0,TRUE);
// 			if(i < poses.length-1 )
// 			{
// 				DrawDebugLine(poses[i],poses[i+1],255,255,0,TRUE);
// 			}
// 		}

		if( poses.length > 0)
		{
			Retval = Poses[Rand(Poses.Length)];

			// if for some reason we have a 0,0,0 vect that is never going to be correct
			if( VSizeSq(Retval) == 0.0f )
			{
				out_FallbackDest = vect(0,0,0);
				return FALSE;
			}

			`LogRx( `showvar(Retval) );
			out_FallbackDest = Retval;
			return TRUE;
		}

		out_FallbackDest = vect(0,0,0);
		return FALSE;
	}


	function bool ShouldUpdateBreadCrumbs()
	{
		return false;
	}

Begin:

	`LogRx( "Fallback! We now try MoveTo directly to a point that is avail to us" );

			
	if( !FindAPointWhereICanMoveTo( FallbackDest, 2048 ) )
	{
		pawn.Destroy();
	}
	else
	{
		MoveToDirectNonPathPos( FallbackDest );
		Sleep( 0.5f );

		if( bFallbackMoveToMesh )
		{
			GotoState('DelaySuccess');
		}
		else
		{
			GotoState('ScriptedMove','Begin');
		}
	}
}


state Harvesting
{
	ignores SeePlayer, SeeMonster, HearNoise;

	function bool ToggleHaltHarv(Rx_Controller InstigatingController, optional bool bForce) {
		SetQueuedStop(InstigatingController);
		return true;} 

	function finishHarvesting()
	{
		 if (bLogTripTimes)
		{
			`log(((TeamNum == 0)? "GDI" : "Nod") @ " harvester took " @ refinery.GetHarvesterHarvestTime() @ " to harvest from tiberium field.");
			tripTimer = 0;
		}
		if (tibNode != none)
			tibNode.bBlocked = false;
		harv_vehicle.SetHarvestingAnim(false);  
		GotoState('MovingToRaf');
	}

	function UpdateHarvestTime()
	{
		harv_vehicle.SetFriendlyStateName("Harvesting Tiberium: " @ Round( ( (WorldInfo.TimeSeconds - harvestingStartTime) / refinery.GetHarvesterHarvestTime() ) * 100) @ " / 100%");
	}


Begin:
	
	
	if (bLogTripTimes)
	{
		`LogRx(((TeamNum == 0)? "GDI" : "Nod") @ " harvester took " @ tripTimer @ " to reach tiberium field.");
		tripTimer = 0;
	}

	harv_vehicle.SetFriendlyStateName("Harvesting Tiberium");
	harv_vehicle.SetOpeningAnim(false);
	harv_vehicle.SetHarvestingAnim(true);
	if(WorldInfo.NetMode != NM_DedicatedServer)
		Pawn.Mesh.PlayAnim('Harvesting',,true);

	harvestingStartTime = WorldInfo.TimeSeconds;
	SetTimer(1,true,nameof(UpdateHarvestTime));
    SetTimer(refinery.GetHarvesterHarvestTime(),,'finishHarvesting');  
}

state MovingToTib
{
   ignores SeePlayer, HearNoise, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling;

	function BeginState(Name PreviousStateName)
	{
		`LogRx("Beginning move to tib.");
		harv_vehicle.SetFriendlyStateName("Moving to Tiberium");
		ClearTimer('destroyIfHarvSeemsToBeStuck');
		setTimer(480.0, false, 'destroyIfHarvSeemsToBeStuck');
		// get all the nav points first
		if(refNode == None) {
			refNode = GetRefNode();
		}
		if(tibNode == None) {
			tibNode = GetTibNode();
		}
		Enemy = None;
		Focus = None;

		SetupMoveToGoal(tibNode,0);
	}

Begin:
	
   SetTimer(1.0,true,'CheckDistToTib');	
	if (tibNode != none)
		tibNode.bBlocked = false;
	if (refNode != none)
		refNode.bBlocked = false;
   PushState('ScriptedMove');
   if(tibNode != none && Pawn.ReachedDestination(tibNode))
   {
        tibNode.bBlocked = true;
        WorldInfo.Game.NotifyNavigationChanged(tibNode);
        GotoState('Harvesting');
   }
   else
		`LogRx("(" $ Pawn.name $ ")" @ GetPackageName()@GetFuncName()@" ERROR:Scripted move returned, but ReachedDestination says false."@`ShowVar(tibNode)@pawn.Location@tibnode.Location@BP2Vect(pawn.Controller.NavigationHandle.FinalDestination));
}

function CheckDistToTib() {
	if(tibNode != none && VSizeSq(Pawn.location - tibNode.location) < 1000000.0) {
		harv_vehicle.SetClosingAnim(false);
		harv_vehicle.SetOpeningAnim(true);
		if(WorldInfo.NetMode != NM_DedicatedServer)
			Pawn.Mesh.PlayAnim('Opening');
		ClearTimer('CheckDistToTib');
	}	
}

state MovingToRaf
{
   ignores SeePlayer, HearNoise, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling;

	function BeginState(Name PreviousStateName)
	{
		`LogRx("Beginning move back to Raf.");
		if(WorldInfo.NetMode != NM_DedicatedServer)
			Pawn.Mesh.PlayAnim('Opening',,,,,true);
		harv_vehicle.SetClosingAnim(true);
		harv_vehicle.SetFriendlyStateName("Returning to Refinery");
		if(refNode == None) {
			refNode = GetRefNode();
		}
		if(tibNode == None) {
			tibNode = GetTibNode();
		}
		Enemy = None;
		Focus = None;
			
		SetupMoveToGoal(refNode,0);
	}

	function bool ToggleHaltHarv(Rx_Controller InstigatingController, optional bool bForce) {
		SetQueuedStop(InstigatingController);
		return true;} //Do not allow blocking whilst transitioning states
Begin:

   PushState('ScriptedMove');
   if(Pawn.ReachedDestination(refNode))
   {
	    
	  Rx_Building(refinery).BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation('RefNodeSocket', refineryLoc, refineryRot);      
	  if (refNode != none)
	  {
		refNode.bBlocked = true;
		WorldInfo.Game.NotifyNavigationChanged(refNode);
	  }
      
	  foreach Rx_Building(refinery).BuildingInternals.BuildingAttachments(DockingStation) 
	  	if(DockingStation.isA('Rx_BuildingAttachment_RefDockingStation')) 
	  		break;  
      
	  if(class'Rx_Utils'.static.LeftRightOrientationOfAtoB(Actor(refinery), Pawn) < 0.0)
	  	bTurnLeftToFaceRef = true;
	  if(bTurnLeftToFaceRef)	      
      	Rx_Vehicle(harv_vehicle).Steering = 1.0;
      else	
      	Rx_Vehicle(harv_vehicle).Steering = -1.0;
  	  
  	  SetTimer(1.0,false,'CheckIfOrientedRight');
   }
}

simulated function GetRefinery()
{
	if(RxIfc_Harvester(Pawn) != None)
	{
		refinery = RxIfc_Harvester(Pawn).GetRefinery();
	}
}

function CheckIfOrientedRight()
{
	harv_vehicle.SetTurningToDock(true);
}

function Tick(float DeltaTime)
{
	local float orient, orient2;
	local Rx_BuildingAttachment ba;

	if( ShouldUpdateBreadCrumbs() )
	{
		NavigationHandle.UpdateBreadCrumbs(Pawn.Location);
	}

	NavigationHandle.DrawBreadCrumbs();

	if (refinery == none)
		GetRefinery();

	if (bLogTripTimes)
	{
		tripTimer += DeltaTime;
	}
	
	Super.Tick(DeltaTime);
	if(harv_vehicle != none && harv_vehicle.IsTurningToDock()) 
	{
		orient = class'Rx_Utils'.static.LeftRightOrientationOfAtoB(DockingStation,Pawn);
		orient2 = class'Rx_Utils'.static.OrientationToB(Pawn,DockingStation);
		
	 	if(orient2 <= 0 && ((bTurnLeftToFaceRef && orient >= 0.0) || (!bTurnLeftToFaceRef && orient <= 0.0))) 
	 	{
			harv_vehicle.SetTurningToDock(false);
			Rx_Vehicle(harv_vehicle).Steering = 0.0;
			Rx_Vehicle(harv_vehicle).Throttle = -1.0;
			
			foreach Rx_Building(refinery).BuildingInternals.BuildingAttachments(ba) 
				if(ba.isA('Rx_BuildingAttachment_RefDockingStation'))
			{
					Rx_BuildingAttachment_RefDockingStation(ba).Activate(true);
					break;
				}
			if (WorldInfo.NetMode != NM_DedicatedServer) 
			{
				Rx_BuildingAttachment_RefDockingStation(ba).Activate(true);
			}
			SetTimer(3.0,false,'StartUnload');
		}
	}
}

function StartUnload()
{
	Rx_Vehicle(harv_vehicle).Throttle = 0.0;
	harv_vehicle.SetFriendlyStateName("Unloading");

	if (refNode != none)
		refNode.bBlocked = false;
	refinery.HarvesterDocked(self);
	if(harv_vehicle != none)
		harv_vehicle.AddTripNumber();

	if (bLogTripTimes)
	{
		`LogRx(((TeamNum == 0)? "GDI" : "Nod")  @ " harvester took " @ tripTimer @ " to return to refinery.");
		tripTimer = 0;
	}
}

function GotoTib2()
{
	local Rx_BuildingAttachment ba;
	
	Rx_Vehicle(harv_vehicle).Throttle = 0.0;
	foreach Rx_Building(refinery).BuildingInternals.BuildingAttachments(ba) 
		if(ba.isA('Rx_BuildingAttachment_RefGarageDoor'))
			Rx_BuildingAttachment_RefGarageDoor(ba).Close();
		else if(ba.isA('Rx_BuildingAttachment_RefDockingStation'))
			Rx_BuildingAttachment_RefDockingStation(ba).Activate(false);			

	GotoState('MovingToTib');
}

function Rx_Tib_NavigationPoint GetTibNode()
{
   	local Rx_Tib_NavigationPoint Node,BestNode;
    local float BestDist, CurrentDist;

   	local Actor Ref;

   	Ref = Actor(Refinery);

   	foreach AllActors(class'Rx_Tib_NavigationPoint', Node)
   	{
     	if (Node.TeamNum != TeamNum && Node.TeamNum != 255)
      	{
  			continue;
        }
        if(BestNode == None)
        {
        	BestNode = Node;
        	BestDist = VSizeSq(Node.Location - Ref.Location);
        }
        else
        {
        	CurrentDist = VSizeSq(Node.Location - Ref.Location);
        	if(BestDist > CurrentDist)
        	{
        		BestDist = CurrentDist;
        		BestNode = Node;
        	}
        }
   	}
   	if(BestNode != None)
    	return BestNode;
   `LogRx ("Warning: no RenX_Tib_Nodes found! harvester won't work!!!!!");
   return none;
}

function destroyIfHarvSeemsToBeStuck() {
	Rx_Vehicle(harv_vehicle).BlowupVehicle();
}

function Rx_Ref_NavigationPoint GetRefNode()
{
    local Rx_Ref_NavigationPoint Node, BestNode;
    local Actor Ref;
    local float BestDist, CurrentDist;

    if(Refinery.GetRefNavPoint() != None)
   		return Refinery.GetRefNavPoint();

   	else
   		Ref = Actor(Refinery);

    foreach AllActors(class'Rx_Ref_NavigationPoint', Node)
    {
      	if (Node.TeamNum != TeamNum)
      	{
  			continue;
        }
        if(BestNode == None)
        {
        	BestNode = Node;
        	BestDist = VSizeSq(Node.Location - Ref.Location);
        }
        else
        {
        	CurrentDist = VSizeSq(Node.Location - Ref.Location);
        	if(BestDist > CurrentDist)
        	{
        		BestDist = CurrentDist;
        		BestNode = Node;
        	}
        }


    }
    if(BestNode != None)
    	return BestNode;
      		

   `Log ("Warning: no RenX_Tib_Nodes found! harvester won't work!!!!!");
   return none;
}

state HarvesterHalted
{
    
   ignores SeePlayer, HearNoise, NotifyPhysicsVolumeChange, NotifyHeadVolumeChange, Falling;

   event PoppedState()
	{
		if (Pawn != None)
		{
			harv_vehicle.SetFriendlyStateName("Stopped by Commander");
			StopMovement();
			//SetTimer(1.0,true,'CloseToHaltedWaypoint');
			//UpdateHaltedHarvWaypoint(true);
		}
	}
   
	function BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName); 
		
		//Save what we were doing so we can go back to it
		//StateWhenLastMoving = PreviousStateName;
		if(ScriptedMoveTarget == refNode || ScriptedMoveTarget == tibNode) NavPointWhenHalted = ScriptedMoveTarget; 
		
		ClearTimer('destroyIfHarvSeemsToBeStuck');//Don't blow yourself up if you're hanging out for awhile
		StopMovement(); //Stop momentarily
		
		//SetTimer(1.0,true,'TimerLogState');
		
		harv_vehicle.SetFriendlyStateName("Stopped by Commander");
		UpdateHaltedHarvWaypoint(false);
		
		//SetTimer(1.0,true,'CloseToHaltedWaypoint');
		//Inform the team
		Rx_Game(WorldInfo.Game).CTextBroadCast(GetTeamNum(),"Harvester Stopped",'LightBlue');
		
		bIgnoreBlockHarvNodes = true; //Ignore blocking path nodes for now			
	}
	
	
	function bool ToggleHaltHarv(Rx_Controller InstigatingController, optional bool bForce) 
	{
		if(!bForce && (InstigatingController != none && Rx_PRI(InstigatingController.PlayerReplicationInfo).bGetIsCommander() == false)) 
		{
			return false; //Failed
		}
		
		//if(StateWhenLastMoving !='') {}
			//`log("UnhaltHalt Harv"); 
			ScriptedMoveTarget=NavPointWhenHalted;
			Rx_Game(WorldInfo.Game).CTextBroadCast(GetTeamNum(),"Harvester Started",'LightBlue');
			bIgnoreBlockHarvNodes = false; 
			GotoState(StateWhenLastMoving);
			return true; 
		
	}
	
	
	function UpdateHaltedHarvWaypoint(bool bNeedsPush)
	{
		local Rx_CommanderWayPoint Halted_Waypoint; 
		
		Halted_Waypoint=GetHaltedWaypoint(); 
		
		//`log("Updated Harv Waypoint"); 
		
		if(Halted_Waypoint != none && VSizeSq(Halted_Waypoint.location-location) > 1000000) 
			{
				ScriptedMoveTarget = Halted_Waypoint;
				harv_vehicle.SetFriendlyStateName("Moving to stand by");
				PushState('ScriptedMove');
			}
			else
			if(Halted_Waypoint != none && VSizeSq(Halted_Waypoint.location-location) <= 1000000)
			{
				StopMovement(); 
				ClearTimer('CloseToHaltedWaypoint');
				harv_vehicle.SetFriendlyStateName("Stopped by Commander");
				//if(IsTimerActive('UpdateHaltedHarvWaypoint')) ClearTimer('UpdateHaltedHarvWaypoint'); 
			}
			else
			if(Halted_Waypoint == none) 
			{
				StopMovement();
				harv_vehicle.SetFriendlyStateName("Stopped by Commander");
				ClearTimer('CloseToHaltedWaypoint');				
			}
	}
	
	
	
}

function Rx_CommanderWayPoint GetHaltedWaypoint()
	{
		local Rx_CommanderWayPoint HW, Halted_Waypoint;
		
		foreach WorldInfo.AllActors(class'Rx_CommanderWayPoint', HW)
		{
			if(GetTeamNum() == 0 && HW.GetMetaTag() == "GDI_Harvester_Halt") 
			{
				Halted_Waypoint = HW;
				break; 
			}
			else
			if(GetTeamNum() == 1 && HW.GetMetaTag() == "Nod_Harvester_Halt") 
			{
				Halted_Waypoint = HW;
				break; 
			}
		}
		
		return Halted_Waypoint; 
	}
	
function TimerLogState()
{
	`log(GetStateName() @ IsTimerActive('CloseToHaltedWaypoint')); 
}

function CloseToHaltedWaypoint() 
{} 

function ReassignRefinery(RxIfc_Refinery Ref)
{
	Super.ReassignRefinery(Ref);

	if (Ref == None) return;

	if(ScriptedMoveTarget == refNode)
		ScriptedMoveTarget = Ref.GetRefNavPoint();

	refNode = Ref.GetRefNavPoint();
}

defaultproperties
{
	bAdjustFromWalls = true
	MaxMovePointFails=5
}
