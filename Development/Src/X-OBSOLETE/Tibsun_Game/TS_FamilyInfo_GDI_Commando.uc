class TS_FamilyInfo_GDI_Commando extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 2

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 150
	MaxArmor               	= 250 //250
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.1 //0.9
	BasePurchaseCost		= 1200
	FallspeedModifier		= 2.0
	bHasParachute = false //You have jumpjets.. save yo'self, fooo! 
	
	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_Ranger'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"
	
	InvManagerClass = class'TS_InventoryManager_GDI_Commando'
	
	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Commando' //Ability linked to 'Jump' 
	PassiveAbilities(1) =  class'TS_PassiveAbility_Commando' //Ability linked to 'X' by default  	
	PassiveAbilities(2) =  class'TS_PassiveAbility_BlastCharge' //Ability linked to 'G' by default (Temporary till blast charge is made a passive) 


	/*****************/
	/* Purchase Icon */
	/*****************/

	// Loadout 1 - Commando

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_IonRifle'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_SMGs'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RemoteC4'
	PT_EquipIcon(2)=None //Needs Jamming Icon
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_JumpJets'

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Commando"
}