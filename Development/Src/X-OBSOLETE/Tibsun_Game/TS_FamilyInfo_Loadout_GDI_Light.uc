class TS_FamilyInfo_Loadout_GDI_Light extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	SoundGroupClass=class'TibSun_Game.TS_PawnSoundGroup_GDI_LightInfantry'

	bHighTier = false
	RequiredFactoryLevel = 0

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 50.0f
	MaxHealth               = 100
	MaxArmor               	= 0
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 0

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Custom'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Assault'

	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Light Infantry"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_PulseRifle', 					Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_BattleRifle', 				Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_Shotgun',						Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_MarksmanRifle', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_RocketLauncher', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(5) = (MyWeapon=class'TS_Weapon_AutomaticShotgun',			Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(6) = (MyWeapon=class'TS_Weapon_SniperRifle', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(7) = (MyWeapon=class'TS_Weapon_LightMachineGun',				Cost = 0,		TechLevelRequirement = 0)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Pistol', 					Cost = 0, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_SMG', 						Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_Revolver', 					Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_DiscGrenade',				Cost = 0,		TechLevelRequirement = 0)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_Grenade_Frag', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_Smoke', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_Grenade_ATMines', 			Cost = 0,		TechLevelRequirement = 0)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_Grenade_Sensor',				Cost = 0,	 	TechLevelRequirement = 0)

}
