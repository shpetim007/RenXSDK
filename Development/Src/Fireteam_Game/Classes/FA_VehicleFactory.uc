class FA_VehicleFactory extends UTVehicleFactory
placeable;

enum Team
{
	TEAM_GDI,
	TEAM_NOD,
	ALL
};

enum Zone
{
	ZONE_1,
	ZONE_2,
	ZONE_3,
	ZONE_4,
	ZONE_5,
	ZONE_6,
	ZONE_7
};

var(FireteamAssault) class<TS_Vehicle> SelectedVehicle;
var(FireteamAssault) SkeletalMeshComponent PreviewMesh;
var(FireteamAssault) Team TeamIndex;
var(FireteamAssault) Zone ZoneIndex;
var(FireteamAssault) const float RespawnTime;
var(FireteamAssault) const float InitialSpawnTime;
var(FireteamAssault) bool bAirdrop;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		CheckActive();
		SetTimer(5.0f, true, nameof(CheckActive));
	}

	if (TeamIndex == ALL)
		TeamNum = 255;
	else
	{
		bStartNeutral = false;
		TeamNum = TeamIndex;
	}

	VehicleClass = SelectedVehicle;
}

function CheckActive()
{
	local bool bTouching;
	local FA_Zone AZone;

	ForEach AllActors(class'FA_Zone', AZone)
	{
		if (AZone.ZoneIndex == self.ZoneIndex && AZone.ZoneIndex == FA_GRI(WorldInfo.GRI).GetCurrentZone() && AZone.EncompassesPoint(Location))
		{
			bTouching = true;
			break;
		}
	}

	if (bTouching && !IsInState('Active'))
		Activate(TeamIndex);

	if (!bTouching && IsInState('Active'))
		Deactivate();
}

function Deactivate()
{
	if (ChildVehicle != None && !Rx_Vehicle(ChildVehicle).bHasBeenDriven)
		ChildVehicle.Destroy();

	GotoState('');
}

state Active
{
	function VehicleDestroyed( UTVehicle V )
	{
		Global.VehicleDestroyed(V);
		RespawnProgress = RespawnTime;
	}

	event SpawnVehicle()
	{
		local bool bIsBlocked;
		local Rotator SpawnRot;
		local vector SpawnLoc;
		local FA_Airdrop Airdrop;
		local int ID;
		local array<class<Rx_Vehicle_PTInfo> > VehicleClasses;
		local class<Rx_Vehicle_PTInfo> PTInfo;
		local UTVehicle UTChildVehicle;
		local Pawn P;

		if (ChildVehicle != None && !ChildVehicle.bDeleteMe)
		{
			return;
		}

		CheckActive();

		if (!IsInState('Active')) return;

		// tell AI to avoid navigating through factories with a vehicle on top of them
		ExtraCost = FMax(ExtraCost,5000);

		foreach OverlappingActors(class'Pawn', P, class<UTVehicle>(VehicleClass).default.SpawnRadius)
		{
			bIsBlocked = true;
			`log(self@self.SelectedVehicle@"MY SPAWN IS BLOCKED BY"@P);
		}

		if (bIsBlocked)
		{
			SetTimer(1.0, false, 'SpawnVehicle'); //try again later
		}
		else
		{
			SpawnRot = GetSpawnRotation();
			SpawnLoc = Location + (vect(0,0,1)*SpawnZOffset);

			if (bAirdrop)
			{
				VehicleClasses = TeamIndex == 0 ? Rx_Game(WorldInfo.Game).PurchaseSystemClass.default.GDIVehicleClasses : Rx_Game(WorldInfo.Game).PurchaseSystemClass.default.NodVehicleClasses;
				ForEach VehicleClasses(PTInfo, ID)
				{
					if (PTInfo.default.VehicleClass == self.SelectedVehicle)
					{
						`log("Selected ID"@ID);
						break;
					}
					else
						ID = INDEX_NONE;
				}
				if (ID == INDEX_NONE)
				{
					`warn("some error with spawning :/");
					return;
				}
				Airdrop = Spawn(class'FA_Airdrop', , , SpawnLoc, SpawnRot, , false);
				Airdrop.SetVehicleFactory(self);
				Airdrop.initialize(None,None,ID,TeamIndex);
			}
			else
			{
				`log("Attempting to spawn");
				ChildVehicle = spawn(SelectedVehicle,,,SpawnLoc, SpawnRot);
				if (ChildVehicle == None)
					`log(self@self.SelectedVehicle@"MY SPAWN IS BLOCKED");
				UTChildVehicle = UTVehicle(ChildVehicle);
				UTChildVehicle.ParentFactory = Self;
				if (UTChildVehicle != None)
				{
					UTChildVehicle.SetTeamNum(TeamNum);
					UTChildVehicle.Mesh.WakeRigidBody();
	
					if (TS_Vehicle(UTChildVehicle) != None)
						TS_Vehicle(UTChildVehicle).LockedToTeam = TeamNum;
				}
			}

			if (Airdrop != None || UTChildVehicle != None)
			{
				// if gameplay hasn't started yet, we need to wait a bit for everything to be initialized
				if (WorldInfo.bStartup)
				{
					SetTimer(0.1, false, 'TriggerSpawnedEvent');
				}
				else
				{
					TriggerSpawnedEvent();
				}
			}
		}
	}

	function Activate(byte T)
	{
		TeamNum = T;
		if (ChildVehicle != None)
		{
			// if we have an unused vehicle available, just change its team
			if (UTVehicle(ChildVehicle).bTeamLocked)
			{
				UTVehicle(ChildVehicle).SetTeamNum(T);
			}
		}
		else
		{
			// force a new vehicle to be spawned
			RespawnProgress = 0.0;
			ClearTimer('SpawnVehicle');
			SpawnVehicle();
		}
	}

	function BeginState(name PreviousStateName)
	{
		if (UTGame(WorldInfo.Game).MatchIsInProgress())
		{
			RespawnProgress = InitialSpawnTime;
			if (RespawnProgress <= 0.0)
			{
				SpawnVehicle();
			}
		}
		else
		{
			RespawnProgress = 0.0;
			SpawnVehicle();
		}
	}

	function EndState(name NextStateName)
	{
		RespawnProgress = 0.0;
		ClearTimer('SpawnVehicle');
	}
}

DefaultProperties
{
	Begin Object Class=SkeletalMeshComponent Name=Preview
		CollideActors=false
		HiddenGame=true
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer=false
		bUpdateSkelWhenNotRendered=false
        LightEnvironment=MyLightEnvironment
        SkeletalMesh=SkeletalMesh'TS_VH_TickTank_HD.Mesh.SK_VH_TickTank'
    End Object
    PreviewMesh=Preview
    Components.Add(Preview);

    SelectedVehicle=class'TS_Vehicle_TickTank_HD'

    InitialSpawnTime=30.f
    RespawnTime=30.f

    bAirdrop=false
}