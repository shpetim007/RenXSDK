class FA_MissionArea extends TS_MissionArea
	ClassGroup(FireteamAssault)
	placeable;

var() string AreaName;
var() float CapturePeriod;
var float TimeUntilCaptured;
var float CachedTime;

replication
{
	if(bNetDirty)
		TimeUntilCaptured;
}

simulated function PostBeginPlay()
{
	local TS_MissionManager TSMM;

	super.PostBeginPlay();

	if(Role == ROLE_Authority)
	{
		TSMM = TS_Game(WorldInfo.Game).MissionManager;
		if(TSMM != None)
			InitCapturePoint(FA_GRI(WorldInfo.GRI).GetDefendingTeam().TeamIndex,AreaName,true,500);
   
//		CP = Spawn(CapturePointClass,self,,location,rotation,,true);
//		CylinderComponent(CP.CollisionComponent).SetCylinderSize(CheckRadius,384.0); //Set Capture size 
	}

	//SetTimer(0.5, true, 'CheckForTouchingActors');
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if(Role == ROLE_Authority && TimeUntilCaptured > 0.f && WorldInfo.GRI.ElapsedTime >= TimeUntilCaptured)
	{
		NotifyObjectiveDied();
	}
}

function NotifyCapturedBy(byte TeamIndex)
{
	super.NotifyCapturedBy(TeamIndex);

	if(TeamIndex == FA_GRI(WorldInfo.GRI).GetAttackingTeam().TeamIndex)
	{
		TimeUntilCaptured = WorldInfo.GRI.ElapsedTime + CapturePeriod;
	}
	else
	{
		TimeUntilCaptured = -1.0;
	}
}

simulated function string GetObjectiveInfo(byte LocalTeamNum)
{
	local string Ret;

	if(TimeUntilCaptured > 0.f)
	{
		Ret = "("$Round(TimeUntilCaptured - WorldInfo.GRI.ElapsedTime)$"s)";
	}

	return Ret;
}

function NotifyNeutralizedBy(byte TeamIndex, byte PreviousOwner)
{
	super.NotifyNeutralizedBy(TeamIndex, PreviousOwner);

	TimeUntilCaptured = -1.0;
}

function NotifyContested(bool bContested)
{
	if(TeamNum == FA_GRI(WorldInfo.GRI).GetAttackingTeam().TeamIndex)
	{
		if(bContested && TimeUntilCaptured > 0.0)
		{
			CachedTime = TimeUntilCaptured - WorldInfo.GRI.ElapsedTime;
			TimeUntilCaptured = -1.0;
		}

		else if(CachedTime > 0.0)
		{
			TimeUntilCaptured = WorldInfo.GRI.ElapsedTime + CachedTime;
			CachedTime = 0.0;
		}
	}
	if(bUnderAttack != bContested)
		bUnderAttack = bContested;
}

function NotifyObjectiveDied()
{
	if (GetIsObjective())
		TS_GRI(WorldInfo.GRI).MissionManager.ObjectiveDied(self);
}

simulated function string GetHumanReadableName()
{
	return "capture area";
}

defaultproperties
{
	CachedTime = 0.0
	TimeUntilCaptured = -1.0
	CapturePeriod = 30.f

	SupportedEvents.Add(class'TS_SeqEvent_ObjectiveComplete')
}