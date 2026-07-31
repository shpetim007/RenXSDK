class TS_FamilyInfo_Loadout_GDI_LightEngineer extends TS_FamilyInfo_Loadout_GDI_Light;

static function bool GetCanHack(Actor A) {return TS_BuildingAttachment_MCT(A) != none;} //Assume we can't hack anything

static function FinalHackAction(Actor A){
	
	if(TS_BuildingAttachment_MCT(A) != none) {
		TS_BuildingAttachment_MCT(A).SetBuildingToDetonate(2.0);
	}
	
}

DefaultProperties
{
	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_EngineerCombat'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_EngineerCombat_1p'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Engineer"

//	PassiveAbilities(1) = class'TS_PassiveAbility_RepKit' //Ability linked to 'X'	

	InitialUpgrades(0) = class'TS_Upgrades_VehicleRepair'

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Engineer'



	ExtraWeapons[0] = class'TS_Weapon_RepairUnit'
	ExtraWeapons[1] = class'TS_Weapon_Blueprint_Obstacle'
	ExtraWeapons[2] = class'TS_Weapon_Blueprint_GDI'
}