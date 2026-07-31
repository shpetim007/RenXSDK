class TS_FamilyInfo_Loadout_GDI_LightAssault extends TS_FamilyInfo_Loadout_GDI_Light;

DefaultProperties
{
	MaxHealth 				= 110
	SprintSpeedMultiplier	= 0.075

//	PassiveAbilities(1) = class'TS_PassiveAbility_AmmoPack' //Ability linked to 'X'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Assault'



	ExtraWeapons[0] = class'TS_Weapon_SpawnBeacon'
	ExtraWeapons[1] = class'TS_WeaponAbility_AmmoPack'
}