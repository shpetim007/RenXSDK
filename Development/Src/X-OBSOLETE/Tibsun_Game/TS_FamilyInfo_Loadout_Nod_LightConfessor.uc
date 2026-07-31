class TS_FamilyInfo_Loadout_Nod_LightConfessor extends TS_FamilyInfo_Loadout_Nod_Light;

DefaultProperties
{
	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Confessor'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Confessor_1P'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Confessor"

	//MaxHealth               = 150
	//MaxArmor               	= 200	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Confessor'



	PassiveAbilities(1) = class'TS_PassiveAbility_Nod_Confessor_Buff' //Ability linked to 'X'	

	//ExtraWeapons[0] = class'TS_Weapon_MedicTool'
}