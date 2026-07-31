class TS_FamilyInfo_Nod_FlameTrooper extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

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
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_FlameTrooper"
	ArmSkinPackageName="TS_CH_Arms"

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_FlameTrooper'

	InvManagerClass = class'TS_InventoryManager_Nod_FlameTrooper'
	

	ImmuneTo[0] = class'TS_DmgType_Burn'
	ImmuneTo[1] = class'TS_DmgType_FireBleed'
	ImmuneTo[2] = class'TS_DmgType_DevilsTongue'
	ImmuneTo[3] = class'TS_DmgType_FlameThrower'
	ImmuneTo[4] = class'Rx_DmgType_Burn'
	ImmuneTo[5] = class'Rx_DmgType_FireBleed'

	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_Grenade_Napalm' //Ability linked to 'G' by default 



	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_Flamethrower'

	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Pistol'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=none
	PT_EquipIcon(3)=none

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Flame Trooper"
}
