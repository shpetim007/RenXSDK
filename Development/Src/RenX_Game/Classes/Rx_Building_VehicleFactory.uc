class Rx_Building_VehicleFactory extends Rx_Building
	implements(RxIfc_FactoryVehicle)
	abstract;

var bool bSpawnsC130;
var name VehicleSpawnSocket;

//Preview Hologram
var bool bDrawPreviewHologram; 
var SkeletalMeshComponent VehicleHologramMesh;
var array<MaterialInstanceConstant> HologramMICS;
var MaterialInterface HologramMI;
var repnotify class<Rx_Vehicle> NextVehicleClass;

var(VehicleSpawn) Actor AltSpawnActor;  //if this actor is not none, vehicles will spawn here instead, taking both location and rotation from it
var string strCurrentAction; 
var bool bAttachedHologram;


replication {
	if(ROLE == ROLE_Authority && bNetDirty || bNetInitial)
	NextVehicleClass, strCurrentAction; 
}

simulated event ReplicatedEvent(name VarName)
{
	if(VarName == 'NextVehicleClass')
	{
		SetHologramMesh(NextVehicleClass); 
	}
	else
		super.ReplicatedEvent(VarName); 
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(WorldInfo.Netmode != NM_Client) 
	{
		SetupVehicleManagerSpawnPoint();
	}
}

function SetupVehicleManagerSpawnPoint()
{
    local Vector loc;
    local Rotator rot;

	BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation(VehicleSpawnSocket, loc, rot);
	Rx_Game(WorldInfo.Game).GetVehicleManager().Set_NOD_ProductionPlace(loc, rot);
}

function bool SpawnsC130()
{
	return bSpawnsC130;
}

function GetVehicleSpawnPoint(out Vector Loc, out Rotator Rot)
{
	if(AltSpawnActor != None)
	{
		Loc = AltSpawnActor.Location;
		Rot = AltSpawnActor.Rotation;

		return;
	}

	BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation(VehicleSpawnSocket,Loc,Rot);
}

simulated function bool CanProduceThisVehicle(class<Rx_Vehicle> Veh)
{
	return true;
}

simulated function SetHologramMesh(class<Rx_Vehicle> NewVehicleClass)
{
	local int i;
	local MaterialInstanceConstant NewMIC;
	local LinearColor LC; 
	local vector HologramLoc;
	local rotator HologramRot; 

	if(WorldInfo.NetMode == NM_DedicatedServer)
	{
		NextVehicleClass = NewVehicleClass; //Replicate
		return;
	}
		
	if(NewVehicleClass == none)
	{
		VehicleHologramMesh.SetSkeletalMesh(none);
		HologramMICS.Length=0;
		return;
	}

	VehicleHologramMesh.SetSkeletalMesh(NewVehicleClass.default.Mesh.SkeletalMesh);

	if(WorldInfo.NetMode != NM_DedicatedServer && !bAttachedHologram)
	{
		BuildingInternals.BuildingSkeleton.GetSocketWorldLocationAndRotation(VehicleSpawnSocket,HologramLoc,HologramRot, 1) ;
		BuildingInternals.BuildingSkeleton.AttachComponentToSocket(VehicleHologramMesh, VehicleSpawnSocket);
		VehicleHologramMesh.SetRotation(HologramRot);
		bAttachedHologram = true; 
	}

	HologramMICS.Length=0;

	LC = MakeLinearColor(0,1.0,0.2,1);

	for(i=0;i<VehicleHologramMesh.GetNumElements(); i++)
	{
		//HologramMesh.SetMaterial(i, HologramMI);

		NewMIC = VehicleHologramMesh.CreateAndSetMaterialInstanceConstant(i);
		NewMIC.SetParent(HologramMI); 
		NewMIC.SetVectorParameterValue('WireColor', LC); 
		HologramMICS.AddItem(NewMIC);
	} 
}

simulated function bool GetUsesHolograms() {return bDrawPreviewHologram;}

simulated function string GetTargetedDescription(PlayerController PlayerPerspectiv) {
	if(PlayerPerspectiv.GetTeamNum() == GetTeamNum())
	{
		if(GetHealth() <= 0 && GetRevivalTime() > 0)
		{
			return "[REBUILDING]:" @ GetTimerString(GetRevivalTime());
		}
		else if(BuildingInternals.GetReviveIsAvailable())
			return "REVIVE AVAILABLE AT MCT";
		else if(!GetCanRepair())
			return "[REPAIRS DISABLED]"; 
		else if(BuildingInternals.DamageMultiplier > 1.0)
			return int(BuildingInternals.DamageMultiplier)$"x Damage";
		else if(strCurrentAction != "") 
			return strCurrentAction;
		else if(BuildingInternals.GetTimesRevived() > 0)
			return "[REBUILT]"; 
		else
			return ""; 
	}
	else
	{
		if(GetHealth() <= 0 && GetRevivalTime() > 0) {
			return "[REBUILDING]";
		}
		else if(!GetCanRepair())
			return "[REPAIRS DISABLED]";
		else if(BuildingInternals.DamageMultiplier > 1.0)
			return int(BuildingInternals.DamageMultiplier)$"x Damage";
		else if(BuildingInternals.GetTimesRevived() > 0)
			return "[REBUILT]"; 
		else
			return ""; 
	}
} 

function SetProductionString(string NewProductionString)
{
	strCurrentAction = NewProductionString; 
}

DefaultProperties
{
	bSpawnsC130 = false
	myBuildingType=BT_Veh

	VehicleSpawnSocket = Veh_Spawn

	SupportedEvents.Add(class'Rx_SeqEvent_FactoryEvent')

	IconTexture=Texture2D'RenxHud.T_BuildingIcon_Vehicle_Normal'
	HologramMI = MaterialInstanceConstant'RX_BU_WeaponsFactory.Effects.MI_VehicleHologram_Green'
}
