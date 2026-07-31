class TS_FamilyInfo_Loadout_EXP_GDI_Assault_HealingTool extends TS_FamilyInfo_Loadout_EXP_GDI_Assault;

DefaultProperties
{

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier_1P'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Weap_HealingTool'

	

	ExtraWeapons[0] = class'TS_Weapon_HealingTool_New'
}