class TS_Upgrades_Reaper_Infusion extends TS_Upgrades_StatModifier;

function GivenTo( Pawn thisPawn, optional bool bDoNotActivate )
{
	if(TS_Pawn_Loadout_CyborgReaper(thisPawn) != None)
		TS_Pawn_Loadout_CyborgReaper(thisPawn).bInfused = true;

	super.GivenTo(thisPawn, bDoNotActivate);
}

defaultproperties
{
	ModWalkingSpeed = 100
	ModRunningSpeed = 200
	ModSprintSpeed = 400

	Price = 2000
}