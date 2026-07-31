class TS_FamilyInfo_Nod_BlackhandGhost extends TS_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bHighTier = true
	RequiredFactoryLevel = 2

	//DamagePointsMultiplier  = 0.025f
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 150
	MaxArmor               	= 250 //300 //250
	Armor_Type 				= A_Kevlar //
	SpeedMultiplier			= 1.1
	BasePurchaseCost		= 1200

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_BlackHand'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_BlackHand"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_Nod_BlackhandGhost' 

	PawnVoiceClass=class'TS_Pawn_VoiceClass_Nod_BlackHand'


	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability Linked to jumpping
	PassiveAbilities(1) = class'TS_PassiveAbility_Stealth' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_BlastCharge' //Ability that just passively does whatever it does [IE buffs/Passive movement abilities]


	
	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_LaserRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RemoteC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Stealth'
	PT_EquipIcon(3)=None

	
	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Blackhand Ghost"
}
