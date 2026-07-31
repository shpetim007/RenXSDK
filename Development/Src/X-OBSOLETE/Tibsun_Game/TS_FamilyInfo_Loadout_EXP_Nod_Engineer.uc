class TS_FamilyInfo_Loadout_EXP_Nod_Engineer extends TS_FamilyInfo_Loadout_EXP_Nod;

DefaultProperties
{

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Engineer'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Engineer_1P'


	InitialUpgrades(0) = class'TS_Upgrades_VehicleRepair'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Engineer'
	ClassIcon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Engineer'



	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Carbine', 					Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_AutomaticShotgun',			Cost = 350,		TechLevelRequirement = 1)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_ShotgunFrag',					Cost = 500, 		TechLevelRequirement = 2)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_GrenadeLauncher',			Cost = 0,		TechLevelRequirement = 0)

	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none
	PassiveAbilities(1) = class'TS_PassiveAbility_Cover' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability usually reserved for being truly passive

	ExtraWeapons[0] = class'TS_Weapon_RepairUnit'
	//ExtraWeapons[1] = class'TS_Weapon_Blueprint_Obstacle'

	AvailablePersonas.Add(TS_Persona_Nod_Engineer_1)

}
