class Rx_HelipadPurchaseSystem extends Rx_PurchaseSystem
notplaceable;

var array<Rx_Building_Helipad_GDI> GDIHelipad;
var array<Rx_Building_Helipad_Nod> NodHelipad;

simulated event PostBeginPlay()
{
	local Rx_Building building;

	ForEach AllActors(class'Rx_Building',building)
	{
		if ( ClassIsChildOf(building.Class,  class'Rx_Building_PowerPlant') )
		{
			if(Building.GetTeamNum() == 0)
				GDIPowerPlants.AddItem(Rx_Building_PowerPlant(building));
			else if (Building.GetTeamNum() == 1)
				NodPowerPlants.AddItem(Rx_Building_PowerPlant(building));
		}
		else if (RxIfc_FactoryVehicle(building) != None)
		{
			if(building.GetTeamNum() == 0)
			{
				if(Rx_Building_Helipad_GDI(building) != None)
					GDIHelipad.AddItem(Rx_Building_Helipad_GDI(building));
				else
					WeaponsFactory.AddItem(RxIfc_FactoryVehicle(building));
			}
			else if(building.GetTeamNum() == 1)
			{
				if(Rx_Building_Helipad_Nod(building) != None)
					NodHelipad.AddItem(Rx_Building_Helipad_Nod(building));
				else
					AirStrip.AddItem(RxIfc_FactoryVehicle(building));
			}
		}
		else if (RxIfc_FactoryInfantry(building) != None)
		{
			if(building.GetTeamNum() == 0)
				Barracks.AddItem(RxIfc_FactoryInfantry(building));
			else if(building.GetTeamNum() == 1)
				HandOfNod.AddItem(RxIfc_FactoryInfantry(building));
		}
		else if (building.isA('Rx_Building_Silo'))
		{
			Silos.AddItem(building.BuildingInternals);
		}
	}
	//Check if there are map specific vehicles/infantry
	UpdateMapSpecificVehicleClasses(); 
	UpdateMapSpecificInfantryClasses();
}

simulated function string GetFactoryDescription(byte teamID, string menuName, Rx_Controller rxPC) 
{
	local string factoryName, factoryName2;
	local string factoryStatus, factoryStatus2;
	local string outputText;
	local int AirdropTime;
	
	if (menuName == "VEHICLES") {
		if (teamID == TEAM_GDI) {
			factoryName = WeaponsFactory.Length > 0 ? Caps(Actor(WeaponsFactory[0]).GetHumanReadableName()) : "WEAPONS FACTORY";
			factoryName2 = "HELIPAD";
		} else if (teamID == TEAM_NOD) {
			factoryName = AirStrip.Length > 0 ? Caps(Actor(AirStrip[0]).GetHumanReadableName()) : "AIRSTRIP";
			factoryName2 = "HELIPAD";
		}
		if (AreVehiclesDisabled(teamID, rxPC)) {
			if (Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
				factoryStatus = "STATUS: FULL"; 
			else if (default.AirdropCooldownTime < 0)
				factoryStatus = "STATUS: DESTROYED";
			else
			{
				AirdropTime = default.AirdropCooldownTime - (WorldInfo.TimeSeconds - Rx_PRi(rxPC.PlayerreplicationInfo).LastAirdropTime);
				factoryStatus = "STATUS: AIRDROP PENDING("$AirdropTime$")";
			}
		} else {
			if(!AirdropAvailable(rxPC.PlayerreplicationInfo))
				factoryStatus = "STATUS: ACTIVE";
			else	
				factoryStatus = "STATUS: AIRDROP READY";
		}

		if (!AreAirVehiclesDisabled(rxPC.GetTeamNum()) && !Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
			factoryStatus2 = "STATUS: ACTIVE";
		else if (AreAirVehiclesDisabled(rxPC.GetTeamNum()) && !Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
			factoryStatus2 = "STATUS: DESTROYED";
		else
			factoryStatus2 = "STATUS: FULL";

		outputText = "<font size='9'>" $factoryName $"</font>"
		$ "\n<font size='11'><b>" $factoryStatus $"</b></font>"
		$ "\n<font size='9'>" $factoryName2 $"</font>"
		$ "\n<font size='11'><b>" $factoryStatus2 $"</b></font>"; 
		
	} else if (menuName == "CHARACTERS") {
		if (teamID == TEAM_GDI) {
			factoryName = Barracks.Length > 0 ? Caps(Actor(Barracks[0]).GetHumanReadableName()) : "BARRACKS";
		} else if (teamID == TEAM_NOD) {
			factoryName = HandOfNod.Length > 0 ? Caps(Actor(HandOfNod[0]).GetHumanReadableName()) : "HAND OF NOD";
		}
		
		factoryStatus = "STATUS: " $ AreHighTierPayClassesDisabled(teamID) ? "LIMITED" : "ACTIVE";
		outputText = "<font size='9'>" $factoryName $"</font>"
		$ "\n<font size='11'><b>" $factoryStatus $"</b></font>" 		
		$ "\n<font size='10'>Advanced Characters" 
		$ "\nAdvanced Weapons</font>";
	} else if (menuName == "REFILL") {
		factoryStatus = rxPC.RefillCooldown() > 0 ? "Available in<font size='12'><b>"@rxPC.RefillCooldown()@"</font>" : "AVAILABLE";
		outputText = "<font size='9'>" $factoryName $"</font>"
		$ "\n<font size='11'><b>" $factoryStatus $"</b></font>" 		
		$ "\n<font size='9'>Refill Health" 
		$ "\nRefill Armour"
		$ "\nRefill Ammo"
		$ "\nRefill Stamina</font>";
	}
	return outputText;
}

simulated function string GetFactoryDescriptionCanvas(byte teamID, string menuName, Rx_Controller rxPC, int line) 
{
	local string factoryName, factoryName2;
	local string factoryStatus, factoryStatus2;
	local string factorySubtext;
	local int AirdropTime;
	
	if (menuName == "VEHICLES") {
		// First factory (WeaponsFactory/AirStrip)
		if (teamID == TEAM_GDI) {
			factoryName = WeaponsFactory.Length > 0 ? Caps(Actor(WeaponsFactory[0]).GetHumanReadableName()) : "WEAPONS FACTORY";
		} else if (teamID == TEAM_NOD) {
			factoryName = AirStrip.Length > 0 ? Caps(Actor(AirStrip[0]).GetHumanReadableName()) : "AIRSTRIP";
		}
		
		if (AreVehiclesDisabled(teamID, rxPC)) {
			if (Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
				factoryStatus = "STATUS: FULL"; 
			else if (default.AirdropCooldownTime < 0)
				factoryStatus = "STATUS: DESTROYED";
			else
			{
				AirdropTime = default.AirdropCooldownTime - (WorldInfo.TimeSeconds - Rx_PRi(rxPC.PlayerreplicationInfo).LastAirdropTime);
				factoryStatus = "STATUS: AIRDROP PENDING("$AirdropTime$")";
			}
		} else {
			if(!AirdropAvailable(rxPC.PlayerreplicationInfo))
				factoryStatus = "STATUS: ACTIVE";
			else	
				factoryStatus = "STATUS: AIRDROP READY";
		}

		// Second factory (Helipad)
		factoryName2 = "HELIPAD";
		
		if (!AreAirVehiclesDisabled(rxPC.GetTeamNum()) && !Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
			factoryStatus2 = "STATUS: ACTIVE";
		else if (AreAirVehiclesDisabled(rxPC.GetTeamNum()) && !Rx_TeamInfo(WorldInfo.GRI.Teams[teamID]).IsAtVehicleLimit())
			factoryStatus2 = "STATUS: DESTROYED";
		else
			factoryStatus2 = "STATUS: FULL";
		switch(line)
		{
			case 0:
				return factoryName;
			case 1:
				return factoryStatus;
			case 2:
				return factorySubtext;
			case 3: 
				return factoryName2;
			case 4:
				return factoryStatus2;
			default: break;
		}
		
	} else if (menuName == "CHARACTERS") {
		if (teamID == TEAM_GDI) {
			factoryName = Barracks.Length > 0 ? Caps(Actor(Barracks[0]).GetHumanReadableName()) : "BARRACKS";
		} else if (teamID == TEAM_NOD) {
			factoryName = HandOfNod.Length > 0 ? Caps(Actor(HandOfNod[0]).GetHumanReadableName()) : "HAND OF NOD";
		}
		
		factoryStatus = "STATUS: " $ AreHighTierPayClassesDisabled(teamID) ? "LIMITED" : "ACTIVE";
		factorySubtext = "\nAdvanced Characters\nAdvanced Weapons";
		
		switch(line)
		{
			case 0:
				return factoryName;
			case 1:
				return factoryStatus;
			case 2:
				return factorySubtext;
			default: break;
		}
		
	} else if (menuName == "REFILL") {
		factoryStatus = rxPC.RefillCooldown() > 0 ? "Available in "@rxPC.RefillCooldown()@"" : "AVAILABLE";
		factorySubtext = "\nRefill Health\nRefill Armour\nRefill Ammo\nRefill Stamina";
		
		switch(line)
		{
			case 0:
				return factoryName;
			case 1:
				return factoryStatus;
			case 2:
				return factorySubtext;
			default: break;
		}
	}

	return "";
}

simulated function bool AreTeamHelipadsDestroyed(byte teamID)
{
	local int i;

	if(teamID == TEAM_GDI && GDIHelipad.Length > 0)
	{
		for(i=0; i < GDIHelipad.Length; i++)
		{
			if(!GDIHelipad[i].IsDestroyed())
				return false;
		}
		return true;
	}
	else if(teamID == TEAM_NOD && NodHelipad.Length > 0)
	{
		for(i=0; i < NodHelipad.Length; i++)
		{
			if(!NodHelipad[i].IsDestroyed())
				return false;
		}
		return true;
	}
	else
		return true;	
}

simulated function bool AreAirVehiclesDisabled(byte team)
{
	return AreTeamHelipadsDestroyed(team);
}

simulated function bool AreVehiclesDisabled(byte teamID, Controller rxPC)
{
	if (!AreTeamHelipadsDestroyed(teamID))
		return false;

	return Super.AreVehiclesDisabled(teamID, rxPC);
}

simulated function int GetVehiclePrices(byte teamID, int VehicleID, bool bViaAirdrop)
{
	local float Multiplier;

	Multiplier = 1.0;
	
	if (AreTeamPowerPlantsDestroyed(teamID))
		Multiplier = 1.5;
	
	if (bViaAirdrop && !GetVehicleClass(teamID, vehicleID).default.bIsAircraft)
	{
		`log(GetVehicleClass(teamID, vehicleID)@"add 2.0 multi");
		Multiplier *= 2.0;
	}

	if (teamID == TEAM_GDI)
	{
		return int(GDIVehicleClasses[VehicleID].default.cost) * Multiplier;
	} 
	else
	{
		return int(NodVehicleClasses[VehicleID].default.cost) * Multiplier;
	}
}