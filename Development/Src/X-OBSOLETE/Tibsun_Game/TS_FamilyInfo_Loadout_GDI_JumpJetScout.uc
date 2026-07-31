class TS_FamilyInfo_Loadout_GDI_JumpJetScout extends TS_FamilyInfo_Loadout_GDI_JumpJet;

DefaultProperties
{
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Vertical' //Ability linked to 'Jump' 

	SpeedMultiplier			= 1.0
	SprintSpeedMultiplier	= 0.05	
	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Ranger'
}