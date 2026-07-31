class TS_FamilyInfo_GDI_LightInfantry extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = false
	RequiredFactoryLevel = 0

	//DamagePointsMultiplier  = 0.025f
	HealPointsMultiplier    = 0.005f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 200
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 0

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Soldier'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_GDI_LightInfantry'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_Grenade_Frag' //Ability linked to 'G' by default  


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_PulseRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Pistol'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_PulseCannon'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_FragGrenade'

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Light Infantry"
}
