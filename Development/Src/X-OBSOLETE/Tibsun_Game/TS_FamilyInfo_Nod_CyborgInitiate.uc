class TS_FamilyInfo_Nod_CyborgInitiate extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 1

	
	// TODO: TEMP DATA  Needs Adjustment
	DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 30.0f	//45
	MaxHealth               = 200
	MaxArmor               	= 250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0 //0.75
	SprintSpeedMultiplier	= 0.3
	JumpMultiplier			= 1.25//2.0 //0.70 Just high enough to get off of the
	FallspeedModifier		= 2.0
	BasePurchaseCost		= 750
	
	DefaultMeshScale=1.3
	BaseTranslationOffset=24.0
	CameraHeightModifier = 10.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_Cyborg'
	
	CharacterMesh=SkeletalMesh'TS_CH_Nod_Cyborg.Mesh.SK_CH_Nod_Cyborg'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Nod_CyborgInitiate' 

	bUncrushable = true
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'TS_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'

	TiberiumHealRate = 10.f;


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/

	PassiveAbilities(0) = none
	PassiveAbilities(1) = class'TS_PassiveAbility_CyborgSuperiority' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_Grenade_CyborgArmCannon' //Ability usually reserved for being truly passive
	

	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_CyborgVulcan'

	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RemoteC4'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_FragGrenade'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SuperHuman'
	PT_EquipIcon(3)=none //Needs uncrushable icon


	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Cyborg Initiate"
}
