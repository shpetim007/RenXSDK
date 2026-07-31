class TS_FamilyInfo_GDI_ZoneTrooper extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 2

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 200
	MaxArmor               	= 400 //250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0 //0.9
	BasePurchaseCost		= 1500
	bHasParachute = false //You have jumpjets.. save yo'self, fooo!
	FallspeedModifier = 2.5 //Very resilient to fall damage 

	DefaultMeshScale=1.25
	BaseTranslationOffset=24.0
	CameraHeightModifier = 20.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	CharacterMesh=SkeletalMesh'TS_CH_ZoneTrooper.Mesh.SK_CH_GDI_ZoneTrooper'
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"
	
	InvManagerClass = class'TS_InventoryManager_GDI_ZoneTrooper'

	bUncrushable = true
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'
	
	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = class'TS_PassiveAbility_JumpJets_Tactical' //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_ShockwaveMortar' //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_Railgun'

	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_HeavyPistol'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_ATMine'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Javelin'
	PT_EquipIcon(3)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_JumpJets'

	
	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Zone Trooper"
}
