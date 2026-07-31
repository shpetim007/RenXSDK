class FA_DestroyableObjective extends TS_DestroyableObstacle
implements(TSIfc_MissionObjective)
ClassGroup(FireteamAssault)
placeable;

struct ObjTargetInfo {
	var string ObjTargetStrFriendly; 
	var string ObjTargetStrEnemy;
};

var repnotify ObjTargetInfo ObjectiveInfo; //Target Info associated with us
var bool bDied;

var bool bPendingActive;

var(Objective) Texture2D IconTexture;
var bool bContested;
var float LastAttackedTime;

replication
{
	if (bNetDirty || bNetInitial)
		ObjectiveInfo, IconTexture, bContested;
}

simulated function ReplicatedEvent(name VarName)
{
	if (VarName == 'ObjectiveInfo')
	{
		//These both should change and replicate at the same time 
		if (ObjectiveInfo.ObjTargetStrFriendly == "")
		{
			RemoveAsRelevantObjective(); 
		}
		else 
		{
			AddAsRelevantObjective(); 
		}		
	}

	super.ReplicatedEvent(VarName);
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	if (GetHealth() <= 0)
	{
		bDied = true;
		NotifyObjectiveDied();
	}
	LastAttackedTime = WorldInfo.TimeSeconds;
	if(!bContested)
		bContested = true;
}

function Tick(float DeltaTime)
{
	if(bContested && WorldInfo.TimeSeconds - LastAttackedTime >= 6.f)
		bContested = false;

	super.Tick(DeltaTime);
}

simulated function vector GetObjectiveLocation()
{
	return Location;
}

function SetObjectiveInfo(int ObjectiveType, byte AttackingTeam)
{
	ObjectiveInfo.ObjTargetStrFriendly = "Defend" ; //NOTE: Could be localized
	ObjectiveInfo.ObjTargetStrEnemy = "Destroy";
}

//Reset info (Which should replicate something)
function ClearObjectiveInfo()
{
	ObjectiveInfo.ObjTargetStrFriendly = "" ; //NOTE: Could be localized
	ObjectiveInfo.ObjTargetStrEnemy = "";
}

//REQUIRED on client for client-side MissionManagers to keep track of targets (Should be called when Target is no longer a target)

//Adds as a relevant objective to our local MissionManager 
simulated function AddAsRelevantObjective()
{
	local TS_MissionManager TSMM;
	
	ForEach DynamicActors(class'TS_MissionManager', TSMM)
	{
		TSMM.AddRelevantActor(self);
        return;
	}

    if(TSMM == None)
        bPendingActive = true;
} 

simulated function bool ObjectivePendingActive()
{
	return bPendingActive;
}

//Remove as a relevant objective to our local MissionManager 
simulated function RemoveAsRelevantObjective()
{
	local TS_MissionManager TSMM;
	
	ForEach DynamicActors(class'TS_MissionManager', TSMM)
	{
		TSMM.RemoveRelevantActor(self);
	}
} 

/*Called by the HUD to identify both if there's any objective set, and which one it is depending on who's looking*/
simulated function string GetObjectiveInfo(byte LocalTeamNum)
{
	return "";
}

simulated function bool GetIsObjective()
{
	//If this is blank we aren't an objective
	return ObjectiveInfo.ObjTargetStrFriendly != "";  
}

//Mostly Inert
function NotifyObjectiveDied()
{
	if (GetIsObjective())
		TS_GRI(WorldInfo.GRI).MissionManager.ObjectiveDied(self);
}
function NotifyObjectivePickedUp(byte ByTeam, optional Controller ByWhom);
function NotifyObjectiveDeployed(byte ByTeam, optional Controller ByWhom); 
function NotifyObjectiveDropped(optional Controller ByWhom); 

simulated function Texture GetIconTexture()
{
	return IconTexture;
}

simulated function bool Contested()
{
	return bContested && GetHealth() > 0;
}

DefaultProperties
{
	bDied=false

	SupportedEvents.Add(class'TS_SeqEvent_ObjectiveComplete')
}