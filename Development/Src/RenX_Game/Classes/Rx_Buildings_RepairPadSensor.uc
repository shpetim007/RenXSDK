class Rx_Buildings_RepairPadSensor extends Rx_BuildingAttachment;

var CylinderComponent           CollisionCylinder;

simulated function Init( Rx_Building_Internals inBuilding, optional name SocketName )
{
	SetOwner(inBuilding);
	OwnerBuilding = inBuilding;
	bAttachmentDebug = OwnerBuilding.bBuildingDebug;
	CollisionCylinder.SetCylinderSize(Rx_Building_RepairFacility_Internals(OwnerBuilding).GetSensorRadius(), Rx_Building_RepairFacility_Internals(OwnerBuilding).GetSensorHeight());
}

simulated event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if(UTVehicle(Other) != None)
		DoCollide(none);
}

simulated event UnTouch( Actor Other )
{	
	if(UTVehicle(Other) != None)
	{
		DoCollide(Other);
		Rx_Building_RepairFacility_Internals(OwnerBuilding).RemoveVehicleFromHealList(UTVehicle(Other));
	}
}

simulated function DoCollide(Actor ignoredActor) 
{
	local UTVehicle loopActor;

	if (Rx_Building_RepairFacility_Internals(OwnerBuilding) == none) 
	{
		return;
	}

	ForEach TouchingActors(class'UTVehicle', loopActor) {
		if (!Rx_Building_RepairFacility_Internals(OwnerBuilding).IsValidVehicle(loopActor) || loopActor == IgnoredActor) 
		{
			continue;
		}
		else if(loopActor != IgnoredActor)
		{
			Rx_Building_RepairFacility_Internals(OwnerBuilding).AddVehicleToHealList(loopActor);
		}
	}
}

DefaultProperties
{
	RemoteRole          = ROLE_SimulatedProxy
	CollisionType       = COLLIDE_TouchAllButWeapons
	bCollideActors      = True 

	Begin Object Class=CylinderComponent Name=CollisioncMP
		CollisionRadius     = 350.0f
		CollisionHeight     = 100.0f
		BlockNonZeroExtent  = True
		BlockZeroExtent     = false
		bDrawNonColliding   = True
		bDrawBoundingBox    = False
		BlockActors         = False
		CollideActors       = True
	End Object
	CollisionComponent = CollisionCmp
	CollisionCylinder  = CollisionCmp
	Components.Add(CollisionCmp)
	
	bAlwaysRelevant     	= True
	bOnlyDirtyReplication 	= True
	NetUpdateFrequency  	= 10
	
}
