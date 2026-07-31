class TS_FamilyInfo_Nod_ToxinTrooper extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 1

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 100
	MaxArmor               	= 250
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 800
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_ToxinTrooper"
	ArmSkinPackageName="TS_CH_Arms"

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_ToxinTrooper'

	InvManagerClass = class'TS_InventoryManager_Nod_ToxinTrooper' 

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'


	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/

	PassiveAbilities(0) = none
	PassiveAbilities(1) = none //class'TS_PassiveAbility_ToxinGrenade' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_ReconDrone_Nod' //Ability usually reserved for being truly passive


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_SniperRifle'

	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Flechette'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Toxin'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Injection'
	
	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Toxin Trooper"
}
