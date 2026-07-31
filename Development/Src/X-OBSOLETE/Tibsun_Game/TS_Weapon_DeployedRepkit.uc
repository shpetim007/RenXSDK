//
// Extended from medkit due to similarities in mechanic, except for vehicles instead.
//

class TS_Weapon_DeployedRepkit extends TS_Weapon_DeployedMedkit;

function SupplyTimer()
{
	local Rx_Vehicle V; 

	if(Supply <= 0)
		return;

	foreach CollidingActors(class'Rx_Vehicle',V,SupplyRadius)
	{
		if(V.GetTeamNum() != GetTeamNum() || V.Health >= V.HealthMax  ) 
			continue; 
		
		if(V.Controller != none) 
		{
			//actually HealVehicle, but since the application is similar, we use the same function
			HealInfantry(V.Controller); 
		}
	}	
}

simulated function CheckVis()
{
	local PlayerController C;

	C = GetALocalPlayerController();

	if (C == None || Rx_Vehicle(C.Pawn) == None || C.GetTeamNum() != GetTeamNum())
	{
		RadiusMesh.SetHidden(true);
		return;
	}

	RadiusMesh.SetScale(SupplyRadius*0.01);//Mesh is 200uu, so *0.01 is the equivelant of dividing by 100 (Half.. which would be the radius)
	RadiusMesh.SetHidden(false);
}

DefaultProperties
{
	DeployableName="Repair Kit"

	HealingStatModClass = class'TS_StatModifierInfo_RepKitHeal';
	
	SupplyRadius		= 900 // bigger radius because vehicles are big and takes space
}