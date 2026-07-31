class TS_FamilyInfo_GDI_RiotTrooper extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 1

	//DamagePointsMultiplier  = 0.025f
	HealPointsMultiplier    = 0.005f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 250
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.075
	BasePurchaseCost		= 800

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_RiotTrooper'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_RocketInfantry"
	ArmSkinPackageName="TS_CH_Arms"
	
	InvManagerClass = class'TS_InventoryManager_GDI_RiotTrooper'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/

	PassiveAbilities(0) = none
	PassiveAbilities(1) = None //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_ReconDrone_GDI' //Ability usually reserved for being truly passive or 'G'
	

	/*****************/
	/* Purchase Icon */
	/*****************/

	// Loadout 1 - Riot Trooper

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_SniperRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_AmmoBox'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_ATMine'

	
	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Riot Trooper"
}