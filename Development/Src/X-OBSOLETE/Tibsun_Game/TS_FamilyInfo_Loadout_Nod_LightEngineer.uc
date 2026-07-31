class TS_FamilyInfo_Loadout_Nod_LightEngineer extends TS_FamilyInfo_Loadout_Nod_Light;

static function bool GetCanHack(Actor A) {return TS_BuildingAttachment_MCT(A) != none;}

static function FinalHackAction(Actor A){
	
	if(TS_BuildingAttachment_MCT(A) != none) {
		TS_BuildingAttachment_MCT(A).SetBuildingToDetonate(2.0);
	}
	
}

DefaultProperties
{
	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Engineer'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Engineer_1P'

//	PassiveAbilities(1) = class'TS_PassiveAbility_RepKit' //Ability linked to 'X'	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Engineer'


	InitialUpgrades(0) = class'TS_Upgrades_VehicleRepair'

	ExtraWeapons[0] = class'TS_Weapon_RepairUnit'
	ExtraWeapons[1] = class'TS_Weapon_Blueprint_Obstacle'
	ExtraWeapons[2] = class'TS_Weapon_Blueprint_Nod'
}