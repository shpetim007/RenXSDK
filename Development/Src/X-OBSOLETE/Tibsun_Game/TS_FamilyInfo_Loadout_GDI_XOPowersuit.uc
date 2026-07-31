class TS_FamilyInfo_Loadout_GDI_XOPowersuit extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 2

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 300.0f
	MaxHealth               = 400
	MaxArmor               	= 0
	Armor_Type 				= A_FLAK
	BasePurchaseCost		= 2000
	FallspeedModifier 		= 2000

	DefaultMeshScale=0.7
	BaseTranslationOffset=0.0

	CustomPawnClass=class'TS_Pawn_Loadout_XOPowerSuit'
	
	SoundGroupClass=class'TS_PawnSoundGroup_XOPowersuit' 
	
	CharacterMesh=SkeletalMesh'TS_CH_GDI_XOPowersuit.Mesh.SK_CH_XOPowersuit'
	FirstPersonMesh=SkeletalMesh'TS_CH_GDI_XOPowersuit.Mesh.SK_CH_XOPowersuit_1P'

	PhysAsset=PhysicsAsset'TS_CH_GDI_XOPowersuit.Mesh.SK_XOPowersuit_Physics'
	AnimSets(0)=AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'
	AnimSets(1)=none
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	bUncrushable = true
	bHasParachute = false

	bExplodeOnDeath = true
	ExplodeDamage = 300
	ExplodeRadius = 500
	ExplodeDmgType = class'TS_DmgType_InfantryExplosion'
	ExplodePSC = ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Medium'
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'


	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_XOPowersuit' //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_XOPowerSuit'

	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - X-O Powersuit"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_XORailHMG', 				Cost = 0, 		TechLevelRequirement = 2)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_XOAutoCannon', 			Cost = 250,		TechLevelRequirement = 2)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_XOTOWLauncher', 			Cost = 500,		TechLevelRequirement = 2)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_XOMAC', 					Cost = 1000,	TechLevelRequirement = 2)
	PrimaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_XOIonCannon', 			Cost = 3000, 	TechLevelRequirement = 2)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_XORailHMG', 			Cost = 0, 		TechLevelRequirement = 2)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_XOAutoCannon', 			Cost = 250,		TechLevelRequirement = 2)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_XOTOWLauncher', 		Cost = 500, 	TechLevelRequirement = 2)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_XOMAC', 				Cost = 1000, 	TechLevelRequirement = 2)
	SecondaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_XOIonCannon', 			Cost = 3000, 	TechLevelRequirement = 2)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_XOMortar', 				Cost = 0, 		TechLevelRequirement = 2)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_ShockwaveMortar', 		Cost = 0, 		TechLevelRequirement = 2)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_XOTuskMissile', 			Cost = 500, 	TechLevelRequirement = 2)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_XOSonicEmitter', 			Cost = 1000, 	TechLevelRequirement = 2)

	UpgradesList(0) = class'TS_Upgrades_XO_Nuclear';

	UpgradeFamily = class'TS_FamilyInfo_Loadout_GDI_XOPowersuit'

	bRedeployOnPurchase = true
}
