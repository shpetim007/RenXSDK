class TS_FamilyInfo_Loadout_Nod_Chameleon extends TS_FamilyInfo_Nod;

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

	DefaultMeshScale=1.1
	DrivingDrawScale=1.0
	BaseTranslationOffset=14.0

	CharacterMesh=SkeletalMesh'TS_CH_Nod_Cyborg.Mesh.SK_CH_Nod_CyborgChameleon'
	FirstPersonMesh=SkeletalMesh'TS_CH_Nod_Cyborg.Mesh.SK_CH_Nod_CyborgChameleon_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_BlackHand"
	ArmSkinPackageName="TS_CH_Arms"

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'

	SoundGroupClass=class'TS_PawnSoundGroup_Nod'

	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability Linked to jumping
	PassiveAbilities(1) = class'TS_PassiveAbility_Stealth'	 //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability that just passively does whatever it does [IE buffs/Passive movement abilities]


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Chameleon'
	
	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Chameleon"

	//CustomPawnClass=class'TS_Pawn_Loadout_BlackHand'

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_CyborgMinigun',					Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_NapalmLauncher', 					Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_PortableBeamCannon',				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_CyborgPlasmaCannon',				Cost = 0,		TechLevelRequirement = 0)

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
