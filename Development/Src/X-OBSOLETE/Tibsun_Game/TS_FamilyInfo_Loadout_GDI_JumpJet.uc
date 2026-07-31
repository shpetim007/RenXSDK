class TS_FamilyInfo_Loadout_GDI_JumpJet extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = false
	RequiredFactoryLevel = 0

	DamagePointsMultiplier  = 0.0
	HealPointsMultiplier    = 0.25
	PointsForKill           = 75.0f
	MaxHealth               = 100
	MaxArmor               	= 0
	Armor_Type 				= A_NONE //A_Kevlar
	SpeedMultiplier			= 1.0
	SprintSpeedMultiplier	= 0.0
	FallspeedModifier 		= 3.0
	BasePurchaseCost		= 0
	bHasParachute = false

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_JumpJet'
	FirstPersonMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier_1P' //SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_JumpJet_1P'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Custom'

	SoundGroupClass=class'TS_PawnSoundGroup_GDI'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Commando' //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu_New.T_Icon_Class_GDI_Jumpjet'


	/***********/
	/* Loadout */
	/***********/
	PTString = "Buy Char - Jump Jet Infantry"

	PrimaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_JumpJetRifle', 					Cost = 0, 		TechLevelRequirement = 0)
	PrimaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_DiscLauncher', 					Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_ParticleIonCannon',				Cost = 0,		TechLevelRequirement = 0)
	PrimaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_GaussRifle', 						Cost = 0,		TechLevelRequirement = 0)

	SecondaryWeaponsList(0) = (MyWeapon=class'TS_Weapon_Pistol_Silenced',				Cost = 0, 		TechLevelRequirement = 0)
	SecondaryWeaponsList(1) = (MyWeapon=class'TS_Weapon_RemoteDetonator', 				Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(2) = (MyWeapon=class'TS_Weapon_SMG_Silenced', 					Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(3) = (MyWeapon=class'TS_Weapon_Revolver', 						Cost = 0,		TechLevelRequirement = 0)
	SecondaryWeaponsList(4) = (MyWeapon=class'TS_Weapon_DiscGrenade',					Cost = 0,		TechLevelRequirement = 0)

	ItemsList(0) = (MyAbility=class'TS_PassiveAbility_Grenade_Frag', 					Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(1) = (MyAbility=class'TS_PassiveAbility_Grenade_Smoke', 					Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(2) = (MyAbility=class'TS_PassiveAbility_Grenade_Sensor',					Cost = 0, 		TechLevelRequirement = 0)
	ItemsList(3) = (MyAbility=class'TS_PassiveAbility_ReconDrone_GDI',					Cost = 0,		TechLevelRequirement = 0)


	ExtraWeapons[0] = class'TS_Weapon_SWStrike_Switchable_GDI'

}
