class TS_FamilyInfo_Loadout_GDI_LightMedic extends TS_FamilyInfo_Loadout_GDI_Light;

DefaultProperties
{
	//MaxHealth               = 150
	//MaxArmor               	= 200	

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Medic'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Medic_1P'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Medic"

//	PassiveAbilities(1) = class'TS_PassiveAbility_MedKit' //Ability linked to 'X'	


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Medic'


	

	ExtraWeapons[0] = class'TS_Weapon_MedicTool'
	ExtraWeapons[1] = class'TS_WeaponAbility_MedKit'
}