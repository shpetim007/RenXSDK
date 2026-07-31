class TS_FamilyInfo_Loadout_EXP_GDI_Engineer extends TS_FamilyInfo_Loadout_EXP_GDI;

DefaultProperties
{
	RequiredFactoryLevel = 2

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_EngineerCombat'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_EngineerCombat_1p'
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Engineer"


	InitialUpgrades(0) = class'TS_Upgrades_VehicleRepair'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Engineer'
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

	AvailablePersonas.Add(TS_Persona_GDI_Engineer_1)

}
