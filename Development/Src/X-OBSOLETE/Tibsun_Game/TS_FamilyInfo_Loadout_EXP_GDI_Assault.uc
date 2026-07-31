class TS_FamilyInfo_Loadout_EXP_GDI_Assault extends TS_FamilyInfo_Loadout_EXP_GDI;

DefaultProperties
{

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Assault'
	ClassIcon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Assault'



	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_PulseRifle', 					Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_TacticalRifle',				Cost = 150,		TechLevelRequirement = 1)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_DiscGrenade',		 			Cost = 200,		TechLevelRequirement = 1)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_LightMachineGun',				Cost = 500, 		TechLevelRequirement = 2)

	AvailablePersonas.Add(TS_Persona_GDI_LightInfantry_2)

	ExtraWeapons[1] = class'TS_Weapon_RemoteDetonator'


}