class Rx_C4DisarmVolume extends PhysicsVolume
placeable;

simulated event PostBeginPlay()
{
	SetTimer(1.0, true, nameof(CheckC4));
}

function CheckC4()
{
	local Rx_Weapon_DeployedC4 C4;

	ForEach DynamicActors(class'Rx_Weapon_DeployedC4', C4)
	{
		if (!self.EncompassesPoint(C4.Location)) continue;

		`log(C4@"disarmed in volume from"@C4.InstigatorController.GetHumanReadableName());

		C4.ImmediateDisarm();
	}
}

defaultproperties
{
	bEntryPain				= false
	
	//if you change this the super's timer will run
	// WE DO NOT WANT THAT TO HAPPEN.
	bPainCausing			= false
	
	bAIShouldIgnorePain		= false
	DamagePerSec			= 10 // FIXME::
	PainInterval			= 0.5f // FIXME::
	bDestructive			= false

	bWorldGeometry=true
	bCollideActors=false
	bBlockActors=false
	bMovable=false
	bStatic=false
	bNoDelete = true
}