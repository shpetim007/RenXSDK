class TS_FamilyInfo_GDI_Grenadier extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = false
	RequiredFactoryLevel = 0

	//DamagePointsMultiplier  = 0.044f
	HealPointsMultiplier    = 0.005f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 200
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 0
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_RocketInfantry"
	ArmSkinPackageName="TS_CH_Arms"

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_DiscThrower'

	InvManagerClass = class'TS_InventoryManager_GDI_Grenadier'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_EMPRocket' //Ability linked to 'G' by default 



	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_RocketLauncher'

	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=none
	PT_EquipIcon(3)=none

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Grenadier"
}