class FA_Airdrop extends TS_Airdrop;

var FA_VehicleFactory ParentFactory;

function SetVehicleFactory(FA_VehicleFactory NewFactory)
{
	ParentFactory = NewFactory;
}

simulated function DropVehicle()
{	
	local Vector SocketLocation;
	local Rotator SocketRotation;	
	
	Mesh.DetachComponent(VehicleMesh);
	SocketLocation = VehicleMesh.GetPosition();
	SocketRotation = VehicleMesh.GetRotation();
	
	if (WorldInfo.NetMode != NM_Client)
	{
		CarriedVehicle = Spawn(GetVehicleClass(),,, SocketLocation,SocketRotation,,true);	
		CarriedVehicle.DropToGround();	
		CarriedVehicle.Mesh.WakeRigidBody();
		TS_Vehicle(CarriedVehicle).LockedToTeam = ParentFactory.TeamNum;
		TS_Vehicle(CarriedVehicle).ParentFactory = self.ParentFactory;

		if(RxIfc_Harvester(CarriedVehicle) != None)
		{
			RxIfc_Harvester(CarriedVehicle).SetRefinery(RefineryBuyer);
			RefineryBuyer.NotifyHarvesterCreated();		
		}
		else
			Rx_Game(WorldInfo.Game).GetVehicleManager().InitVehicle(CarriedVehicle,TeamNum,Buyer,VehicleID,SocketLocation); 
	}
}