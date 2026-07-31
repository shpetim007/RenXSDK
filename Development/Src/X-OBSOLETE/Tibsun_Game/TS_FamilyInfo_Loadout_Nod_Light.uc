class TS_FamilyInfo_Loadout_Nod_Light extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

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

	CharacterMesh=SkeletalMesh'TS_CH_Nod_Soldier.Mesh.SK_CH_Nod_Soldier'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Soldier_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Custom'

	SoundGroupClass=class'TibSun_Game.TS_PawnSoundGroup_Nod_LightInfantry'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Assault'


	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Light Infantry"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_AssaultRifle',				Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_BattleRifle', 				Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_Shotgun',						Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_MarksmanRifle', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_RocketLauncher', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(5) = (MyWeapon=class'TS_Weapon_FlameThrower', 				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(6) = (MyWeapon=class'TS_Weapon_ToxinRifle',					Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(7) = (MyWeapon=class'TS_Weapon_LightMachineGun',				Cost = 0,		TechLevelRequirement = 0)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Pistol', 					Cost = 0, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_SMG', 						Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_Revolver', 					Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_GrenadeLauncher', 			Cost = 0,		TechLevelRequirement = 0)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_Grenade_Frag', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_Smoke', 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_Grenade_ATMines', 			Cost = 0,		TechLevelRequirement = 0)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_Grenade_Sensor',				Cost = 0,	 	TechLevelRequirement = 0)

}
