class TS_FamilyInfo_Loadout_GDI_ZoneTrooper extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 1

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 75.0f
	MaxHealth               = 250
	MaxArmor               	= 0
	Armor_Type 				= A_FLAK
	BasePurchaseCost		= 800
	FallspeedModifier 		= 2.5

	DefaultMeshScale=1.25
	BaseTranslationOffset=16.0

	CustomPawnClass=class'TS_Pawn_Loadout_ZoneTrooper'
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	CharacterMesh=SkeletalMesh'TS_CH_GDI_ZoneTrooper.Mesh.SK_CH_ZoneTrooper'
	FirstPersonMesh=SkeletalMesh'TS_CH_GDI_ZoneTrooper.Mesh.SK_CH_ZoneTrooper_1P'
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	bUncrushable = true
	bHasParachute = false

	bExplodeOnDeath = true
	ExplodeDamage = 100
	ExplodeRadius = 200
	ExplodeDmgType = class'TS_DmgType_InfantryExplosion'
	ExplodePSC = ParticleSystem'TS_FX_Munitions.Particles.Explosions.P_Explosion_Small'
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'


	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Tactical' //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_ZoneTrooper'

	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Zone Trooper"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_ParticleIonCannon', 				Cost = 0, 		TechLevelRequirement = 1)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_MultiMissileLauncher',			Cost = 0, 		TechLevelRequirement = 1)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_Railgun', 						Cost = 0, 		TechLevelRequirement = 1)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_ShockwaveMortar', 				Cost = 0, 		TechLevelRequirement = 1)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_ZTMissile', 						Cost = 0,		TechLevelRequirement = 1)

	//UpgradesList(0) = class'TS_Upgrades_StatModifier_ZoneA'
	//UpgradesList(1) = class'TS_Upgrades_StatModifier_ZoneB'
	//UpgradesList(2) = class'TS_Upgrades_StatModifier_ZoneC'

	UpgradeFamily = class'TS_FamilyInfo_Loadout_GDI_ZoneTrooper'
}
