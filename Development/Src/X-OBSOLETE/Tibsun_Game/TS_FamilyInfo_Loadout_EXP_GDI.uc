class TS_FamilyInfo_Loadout_EXP_GDI extends TS_FamilyInfo_Loadout_CQ_GDI;

DefaultProperties
{

	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Light Infantry"

	PrimaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_BattleRifle', 				Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(5) = (MyWeapon=class'TS_Weapon_SMG',							Cost = 100,		TechLevelRequirement = 0)
	PrimaryWeaponsList(6) = (MyWeapon=class'TS_Weapon_Shotgun', 					Cost = 200,		TechLevelRequirement = 1)
	PrimaryWeaponsList(7) = (MyWeapon=class'TS_Weapon_MarksmanRifle', 				Cost = 300,		TechLevelRequirement = 2)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Pistol', 					Cost = 0, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_Pistol_Silenced', 			Cost = 25, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_HeavyPistol',				Cost = 50,		TechLevelRequirement = 1)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_HeavyPistol_Supressed',		Cost = 75,		TechLevelRequirement = 1)
	SecondaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_PDW',						Cost = 150,		TechLevelRequirement = 1)
	SecondaryWeaponsList(5) = (MyWeapon=class'TS_Weapon_PDW_Supressed',				Cost = 125,		TechLevelRequirement = 1)
	SecondaryWeaponsList(6) = (MyWeapon=class'TS_Weapon_Revolver', 					Cost = 200,		TechLevelRequirement = 2)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_Grenade_Frag', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_Smoke', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_Grenade_Sensor',				Cost = 0,	 	TechLevelRequirement = 0)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_Grenade_EMP', 				Cost = 100,		TechLevelRequirement = 1)
	ItemsList(4) = (MyAbility=class'TS_PassiveAbility_Grenade_Napalm',	 			Cost = 150, 		TechLevelRequirement = 1)

}

