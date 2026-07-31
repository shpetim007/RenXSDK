class Rx_Building_Refinery_Internals extends Rx_Building_Team_Internals;

var private name IdleAnimName;
var repnotify bool PlayIdleAnim;

replication
{
	if (bNetDirty && Role == ROLE_Authority)
		PlayIdleAnim;
}

simulated event ReplicatedEvent( name VarName )
{
	if (VarName == 'PlayIdleAnim')
	{
		ToggleIdleAnimation();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function Init(Rx_Building Visuals, bool isDebug )
{
	super.Init(Visuals, isDebug);
	if(WorldInfo.Netmode != NM_Client) {
		PlayIdleAnim = True;
		ToggleIdleAnimation();
	}
}

simulated function ToggleIdleAnimation()
{
	if(PlayIdleAnim)
	{
		BuildingSkeleton.PlayAnim(IdleAnimName,,True);
	}
	else
	{
		BuildingSkeleton.StopAnim();
	}
}

simulated function PlayDestructionAnimation() 
{
    PlayIdleAnim = False;
    ToggleIdleAnimation();

    Super.PlayDestructionAnimation();
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser) 
{
	local bool bRefDestroyed;
	
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);

	if(GetHealth() <= 0) 
	{
		bRefDestroyed = Rx_Game(WorldInfo.Game).AreTeamRefineriesDestroyed(GetTeamNum());

		if(bRefDestroyed)
		{
			if(GetTeamNum() == TEAM_GDI) 
				Rx_Game(WorldInfo.Game).GetVehicleManager().SetGDIRefDestroyed(true);
			else 
				Rx_Game(WorldInfo.Game).GetVehicleManager().SetNodRefDestroyed(true);
		}
	}
}

function HarvesterAirdropTimer()
{
	RxIfc_Refinery(BuildingVisuals).RequestHarvester();
}

reliable server function RestoreMe(optional PlayerReplicationInfo Restorer)
{
	local class<Rx_Vehicle> harvesterClass;
	local Rx_VehicleManager vehicleManager;

	if (bDestroyed)
	{
		vehicleManager = Rx_Building_Refinery(BuildingVisuals).VM;
		switch (GetTeamNum())
		{
			case TEAM_GDI:
				Rx_Game(WorldInfo.Game).GetVehicleManager().bGDIRefDestroyed = false;
				harvesterClass = vehicleManager.GDIHarvesterClass;
			break;
	
			case TEAM_NOD:
				Rx_Game(WorldInfo.Game).GetVehicleManager().bNodRefDestroyed = false;
				harvesterClass = vehicleManager.NodHarvesterClass;
			break;
		}
	
		//RxIfc_Refinery(BuildingVisuals).RequestHarvester();	
	
		super.RestoreMe(Restorer);

		PlayIdleAnim = true;
		ToggleIdleAnimation();

		// Only request a harvester if there isn't one in the queue already
		if (!vehicleManager.CheckIsInQueue(TeamID, harvesterClass))
		{
			RxIfc_Refinery(BuildingVisuals).RequestHarvester();	
		}
	}
}

DefaultProperties
{
	Begin Object Name=BuildingSkeletalMeshComponent
        SkeletalMesh = SkeletalMesh'RX_BU_Refinery.Mesh.SK_BU_Refinery'
        PhysicsAsset = PhysicsAsset'RX_BU_Refinery.Mesh.SK_BU_Refinery_Physics'
        AnimSets(0)  = AnimSet'RX_BU_Refinery.Anims.AS_BU_Refinery'
    End Object
    
    IdleAnimName    = "PumpIdle"

	AttachmentClasses.Add(Rx_BuildingAttachment_RefGarageDoor)
	AttachmentClasses.Add(Rx_BuildingAttachment_RefDockingStation)
}
