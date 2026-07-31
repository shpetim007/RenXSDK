class TS_FamilyInfo_Nod_BlackhandAssassin extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 2

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 100
	MaxArmor               	= 250 //250
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.1 //0.9
	BasePurchaseCost		= 1400
	FallspeedModifier		= 1.5

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_BlackHand'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_BlackHand"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Nod_BlackHandAssassin' 

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability Linked to jumpping
	PassiveAbilities(1) = class'TS_PassiveAbility_Stealth' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability that just passively does whatever it does [IE buffs/Passive movement abilities]

	
	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_RamjetRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RemoteC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Drone'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Stealth'

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Blackhand Assassin"
}
