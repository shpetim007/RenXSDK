class Rx_Vehicle_APC_Weapon extends Rx_Vehicle_Weapon_Reloadable
abstract;

var float CurrentSpreadReduction;
var const float SpreadReducPerShot;
var float ReducedSpread[2];

/**
 * Adds any fire spread offset to the passed in rotator
 * @param Aim the base aim direction
 * @return the adjusted aim direction
 */
simulated function rotator AddSpread(rotator BaseAim)
{
	local vector X, Y, Z;
	local float CurrentSpread, RandY, RandZ;

	CurrentSpread = Lerp(Spread[CurrentFireMode], ReducedSpread[CurrentFireMode], CurrentSpreadReduction);
	if (CurrentSpread == 0)
	{
		return BaseAim;
	}
	else
	{
		// Add in any spread.
		GetAxes(BaseAim, X, Y, Z);
		RandY = FRand() - 0.5;
		RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
		return rotator(X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z);
	}
}

simulated function IncrementSpreadReduction()
{
	// Increment and cap to 1
	CurrentSpreadReduction = FMin(SpreadReducPerShot + CurrentSpreadReduction, 1);
}

simulated function ConsumeAmmo( byte FireModeNum )
{
	super.ConsumeAmmo(FireModeNum);

	IncrementSpreadReduction();
	SetTimer(0.1, false, nameof(ResetSpreadReduction));
}

simulated function ResetSpreadReduction()
{
	CurrentSpreadReduction = 0;
}

DefaultProperties
{
	SpreadReducPerShot=0.02
 	ReducedSpread(0)=0.008
    ReducedSpread(1)=0.008
}