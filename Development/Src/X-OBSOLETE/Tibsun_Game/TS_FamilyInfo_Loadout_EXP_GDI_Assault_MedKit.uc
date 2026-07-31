class TS_FamilyInfo_Loadout_EXP_GDI_Assault_MedKit extends TS_FamilyInfo_Loadout_EXP_GDI_Assault;

DefaultProperties
{

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Medic'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Medic_1P'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Medic"
	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Weap_Medkit'

	

	ExtraWeapons[0] = class'TS_WeaponAbility_MedKit'
}