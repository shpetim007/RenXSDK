class TS_FamilyInfo_Loadout_Nod_BlackhandAssassin extends TS_FamilyInfo_Loadout_Nod_Blackhand;

DefaultProperties
{
	SpeedMultiplier			= 1.0
	SprintSpeedMultiplier	= 0.05

//	PassiveAbilities(0) = class'TS_PassiveAbility_Glider'
	PassiveAbilities(1) = class'TS_PassiveAbility_Stealth'	

	//CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_FlameTrooper_Blackhand'	//SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_ToxinTrooper'
	//ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_ToxinTrooper"
}