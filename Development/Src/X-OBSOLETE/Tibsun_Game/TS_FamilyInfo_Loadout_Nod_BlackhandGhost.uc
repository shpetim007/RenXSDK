class TS_FamilyInfo_Loadout_Nod_BlackhandGhost extends TS_FamilyInfo_Loadout_Nod_Blackhand;

DefaultProperties
{
	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Blackhand_Ghost'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_BlackHand"

	SpeedMultiplier			= 1.0
	SprintSpeedMultiplier	= 0.1
	DodgeMultiplier 		= 1.5

//	PassiveAbilities(0) = class'TS_PassiveAbility_Glider'
	PassiveAbilities(1) = class'TS_PassiveAbility_Stealth'	
}