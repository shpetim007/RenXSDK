class TS_FamilyInfo_Loadout_Nod_CyborgReaper extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

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

	DefaultMeshScale=0.55
	BaseTranslationOffset=0.0

	CustomPawnClass=class'TS_Pawn_Loadout_CyborgReaper'
	
	SoundGroupClass=class'TS_PawnSoundGroup_CyborgReaper' 

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_Cyborg'
	
	CharacterMesh=SkeletalMesh'TS_CH_Nod_CyborgReaper.Mesh.SK_CH_Nod_CyborgReaper'
	FirstPersonMesh=SkeletalMesh'TS_CH_Nod_CyborgReaper.Mesh.SK_CH_Nod_CyborgReaper_1P'

	PhysAsset=PhysicsAsset'TS_CH_Nod_CyborgReaper.Mesh.SK_CH_Nod_CyborgReaper_Physics'
	AnimSets(0)=AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper'
	AnimSets(1)=AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper_AimOffset'
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
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

	TiberiumHealRate = 20.f;

	InvManagerClass = class'TS_InventoryManager_Custom'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_Nod_CyborgReaper'

	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Cyborg Reaper"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_CYReaper_ShredderCannon',			Cost = 0, 		TechLevelRequirement = 2)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_CYReaper_RocketPod', 				Cost = 250,		TechLevelRequirement = 2)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_CYReaper_TibCoreLauncher', 		Cost = 500,		TechLevelRequirement = 2)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_CYReaper_Obelisk', 				Cost = 1000,	TechLevelRequirement = 2)
	PrimaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_CYReaper_PlasmaCannon', 			Cost = 3000, 	TechLevelRequirement = 2)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_CYReaper_ShredderCannon', 		Cost = 0, 		TechLevelRequirement = 2)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_CYReaper_RocketPod', 			Cost = 250,		TechLevelRequirement = 2)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_CYReaper_TibCoreLauncher',	 	Cost = 500, 	TechLevelRequirement = 2)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_CYReaper_Obelisk',		 		Cost = 1000, 	TechLevelRequirement = 2)
	SecondaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_CYReaper_PlasmaCannon', 		Cost = 3000, 	TechLevelRequirement = 2)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_CYReaper_ClusterBomb', 			Cost = 0, 		TechLevelRequirement = 2)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_ShockwaveMortar', 				Cost = 0, 		TechLevelRequirement = 2)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_CYReaper_PlasmaBattery', 			Cost = 500, 	TechLevelRequirement = 2)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_CYReaper_NapalmInferno', 			Cost = 1000, 	TechLevelRequirement = 2)

	//UpgradesList(0) = class'TS_Upgrades_Reaper_Infusion'

	bRedeployOnPurchase = true

	UpgradeFamily = class'TS_FamilyInfo_Loadout_Nod_CyborgReaper'
}
