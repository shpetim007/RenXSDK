class TS_FamilyInfo_Loadout_GDI_JumpJetCommando extends TS_FamilyInfo_Loadout_GDI_JumpJet;

static function bool GetCanHack(Actor A) {return TS_BuildingAttachment_MCT(A) != none;} //Assume we can't hack anything

static function FinalHackAction(Actor A){
	
	if(TS_BuildingAttachment_MCT(A) != none) {
		TS_BuildingAttachment_MCT(A).SetBuildingToDetonate(2.0);
	}
	
}

DefaultProperties
{
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Commando' 

	SpeedMultiplier			= 1.0
	SprintSpeedMultiplier	= 0.0		
	DodgeMultiplier 		= 1.0
	//CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Ranger'
}