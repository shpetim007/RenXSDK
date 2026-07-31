class TS_FamilyInfo_Loadout_Nod_Cyborg extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 1

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 150.0f
	MaxHealth               = 250
	MaxArmor               	= 0
	Armor_Type 				= A_FLAK
	BasePurchaseCost		= 800
	FallspeedModifier 		= 2.0

	DefaultMeshScale=1.25
	BaseTranslationOffset=16.0
	
	CustomPawnClass=class'TS_Pawn_Loadout_Cyborg'

	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_Cyborg'
	
	CharacterMesh=SkeletalMesh'TS_CH_Nod_Cyborg.Mesh.SK_CH_Nod_Cyborg'
	FirstPersonMesh=SkeletalMesh'TS_CH_Nod_Cyborg.Mesh.SK_CH_Nod_Cyborg_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	bUncrushable = true

	bExplodeOnDeath = true
	ExplodeDamage = 100
	ExplodeRadius = 200
	ExplodeDmgType = class'TS_DmgType_InfantryExplosion'
	ExplodePSC = ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small'
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'TS_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'

	TiberiumHealRate = 20.f;

	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/

	PassiveAbilities(0) = none //class'TS_PassiveAbility_JumpJets_CyborgAgility'
	PassiveAbilities(1) = class'TS_PassiveAbility_CyborgSuperiority' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability usually reserved for being truly passive


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_Cyborg'


	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Cyborg"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_CyborgVulcanCannon', 						Cost = 0, 		TechLevelRequirement = 1)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_CyborgAutoCannon', 						Cost = 0,		TechLevelRequirement = 1)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_CyborgPlasmaCannon',	 					Cost = 0,		TechLevelRequirement = 1)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_CyborgEMPCannon', 						Cost = 0, 		TechLevelRequirement = 1)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_CyborgArmCannon', 				Cost = 0, 		TechLevelRequirement = 1)

	//UpgradesList(0) = class'TS_Upgrades_StatModifier_CyborgA'
	//UpgradesList(1) = class'TS_Upgrades_StatModifier_CyborgB'
	//UpgradesList(2) = class'TS_Upgrades_StatModifier_CyborgC'

	UpgradeFamily = class'TS_FamilyInfo_Loadout_Nod_Cyborg'
}
