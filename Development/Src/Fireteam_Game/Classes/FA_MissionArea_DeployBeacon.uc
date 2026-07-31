class FA_MissionArea_DeployBeacon extends FA_MissionArea
placeable;

function SetObjectiveInfo(int ObjectiveType, byte AttackingTeam)
{
	ObjectiveInfo.ObjTargetStrFriendly = "Defend zone" ; //NOTE: Could be localized
	ObjectiveInfo.ObjTargetStrEnemy = "Deploy beacon";
	//SetTimer(0.5, true, 'CheckForTouchingActors');
}
