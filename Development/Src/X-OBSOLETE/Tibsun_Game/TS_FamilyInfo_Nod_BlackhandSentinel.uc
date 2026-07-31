class TS_FamilyInfo_Nod_BlackhandSentinel extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 2
	
	// TODO: TEMP DATA  Needs Adjustment
	DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 30.0f	//45
	MaxHealth               = 100
	MaxArmor               	= 350
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0 //0.75
	JumpMultiplier			= 1.25//2.0 //0.70 Just high enough to get off of the
	FallspeedModifier		= 1.0
	BasePurchaseCost		= 1500
	

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_BlackHandSentinel'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Nod_BlackHandSentinel' 

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'

	bUncrushable = false

	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'

	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/

	PassiveAbilities(0) = none
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_EMPCannon' //Ability usually reserved for being truly passive


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_BeamCannon'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_HeavyPistol'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_EMPGrenade'
	PT_EquipIcon(3)=None

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Blackhand Sentinel"
}
