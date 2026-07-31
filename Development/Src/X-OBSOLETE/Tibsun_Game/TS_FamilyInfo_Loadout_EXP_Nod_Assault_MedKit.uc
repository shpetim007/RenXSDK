class TS_FamilyInfo_Loadout_EXP_Nod_Assault_MedKit extends TS_FamilyInfo_Loadout_EXP_Nod_Assault;

DefaultProperties
{

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Confessor'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Confessor_1P'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Confessor"
	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Weap_Medkit'

	

	ExtraWeapons[0] = class'TS_WeaponAbility_MedKit'
}