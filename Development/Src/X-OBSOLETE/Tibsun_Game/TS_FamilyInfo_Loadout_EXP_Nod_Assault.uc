class TS_FamilyInfo_Loadout_EXP_Nod_Assault extends TS_FamilyInfo_Loadout_EXP_Nod;

DefaultProperties
{

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Assault'
	ClassIcon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Assault'



	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_AssaultRifle',				Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_TacticalRifle',				Cost = 150,		TechLevelRequirement = 1)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_FlameTHrower',	 			Cost = 200,		TechLevelRequirement = 1)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_ConfessorLMG',				Cost = 500, 	TechLevelRequirement = 2)

	AvailablePersonas.Add(TS_Persona_Nod_LightInfantry_2)

	ExtraWeapons[1] = class'TS_Weapon_RemoteDetonator'
}