class TS_FamilyInfo_Loadout_Nod_Blackhand extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = false
	RequiredFactoryLevel = 0

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 75.0f
	MaxHealth               = 100
	MaxArmor               	= 0
	Armor_Type 				= A_NONE //A_Kevlar
	SpeedMultiplier			= 1.05
	SprintSpeedMultiplier	= 0.1
	FallspeedModifier 		= 3.0
	BasePurchaseCost		= 0

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Blackhand_Ghost'
	FirstPersonMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Blackhand_Ghost_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_BlackHand"
	ArmSkinPackageName="TS_CH_Arms"

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'

	SoundGroupClass=class'TS_PawnSoundGroup_Nod'

	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability Linked to jumpping
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability that just passively does whatever it does [IE buffs/Passive movement abilities]


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_RamjetRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RemoteC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Drone'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Stealth'


	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Blackhand Infantry"

	//CustomPawnClass=class'TS_Pawn_Loadout_BlackHand'

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Minigun', 						Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_NapalmLauncher', 					Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_PlasmaRifle', 					Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_PortableObelisk',					Cost = 0,		TechLevelRequirement = 0)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Pistol_Silenced',				Cost = 0, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_RemoteDetonator', 				Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_TiberiumFlechetteRifle', 		Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_Revolver', 						Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_GrenadeLauncher', 				Cost = 0,		TechLevelRequirement = 0)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_Grenade_Frag',					Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_Smoke',	 				Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_Grenade_Sensor',					Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_ReconDrone_Nod',					Cost = 0,		TechLevelRequirement = 0)


	ExtraWeapons[0] = class'TS_Weapon_GrapplingHook'
	ExtraWeapons[1] = class'TS_Weapon_SWStrike_Switchable_Nod'

}
