class TS_Building_ConstructionYard extends TS_Building
abstract
implements(TSIfc_ProvidesPower)
implements(TSIfc_BuilderActor);

var(RenX_Buildings) float CreditsPerTick;

var(ConstructionYard) Actor CameraActor;

simulated function String GetHumanReadableName()
{
	return "Construction Yard";
}

function FinishUpgrade()
{
	TS_TeamInfo(TS_Game(WorldInfo.Game).Teams[GetTeamNum()]).TechLevel++;
	TS_Game(WorldInfo.Game).CTextBroadcast(GetTeamNum(),Caps("Tech Level"@(1 + TS_TeamInfo(TS_Game(WorldInfo.Game).Teams[GetTeamNum()]).TechLevel)@"is now available"),'Green',120, ,true);;
	super.FinishUpgrade();	
}

simulated function int GetUpgradeCost()
{
	return default.UpgradeCost + (default.UpgradeCost * GetBuildingLevel());
}

simulated function NotifyOutpostConstructed()
{
	super.NotifyOutpostConstructed();

	if(TS_Game(WorldInfo.Game) != None)
	{
		TS_Game(WorldInfo.Game).ConYards[GetTeamNum()] = self;
	}	
}

simulated function int GetPowerProvided()
{
	local int Mod;

	if(GetBuildingLevel() > 0)
		Mod = 5 * GetBuildingLevel();

	return PowerProvided + Mod;
}

simulated function bool GetUseBuildingArmour()
{
	return false;
}

simulated function int GetMaxArmor() 
{
	if(BuildingInternals != None)
		return BuildingInternals.GetMaxArmor(); 
	else 
		return 0;	
}
/*
simulated function bool IsAccessible(PlayerController PC)
{
	if(GetBuildingLevel() >= GetBuildingLevelMax())
		return false;

	return super.IsAccessible(PC);
}
*/

simulated function bool IsSellable(PlayerController PC)
{
	return false;
}

simulated function GetCameraLocation(out vector Loc, out rotator Rot)
{
	if(CameraActor == None && AssignedPoint != None)
		CameraActor = AssignedPoint.CameraActor;

	if(CameraActor != None)
	{
		Loc = CameraActor.Location;
		Rot = CameraActor.Rotation;
	}
	else
	{
		Loc = Location + Vect(0,0,10000);
		Rot = Rotation;
		Loc += 1750 * Vector(Rot + Rot(0,16339,0));
		Rot.Pitch = -16339;
	}
}

simulated function Actor GetAssociatedPoint()
{
	return AssignedPoint;
}

simulated function bool IsAccessible(TS_Controller C)
{
	return GetTeamNum() == C.GetTeamNum();
}
simulated function Array<TS_BuildSpot> GetBuildSpotList()
{
	return AssignedPoint.MySpots;
}

simulated function bool isConstructionYard()
{
	return true; 
}

DefaultProperties
{
	Health = 20000
	HealthMax = 20000

	UpgradeCost = 5000
	TechTreeDesignation = "ALLYARD"
	
	PowerConsumption = 0
	PowerProvided = 5
	MyBuildingType = BT_Tech
	CreditsPerTick=2
	bSellable = false;
	bSignificant = true
	
	IconTexture=Texture2D'RenxHud.T_BuildingIcon_RepairPad_Normal'
}