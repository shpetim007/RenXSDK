class TS_FamilyInfo_GDI_IonTrooper extends TS_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = true
	RequiredFactoryLevel = 1

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 100
	MaxArmor               	= 350 //250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 1000
	bHasParachute = true
	FallspeedModifier = 1.0

	DefaultMeshScale=1.25
	BaseTranslationOffset=24.0
	CameraHeightModifier = 14.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	CharacterMesh=SkeletalMesh'TS_CH_ZoneTrooper.Mesh.SK_CH_MobiusSuit'
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Soldier"
	ArmSkinPackageName="TS_CH_Arms"
	
	InvManagerClass = class'TS_InventoryManager_GDI_IonTrooper'

	bUncrushable = true
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3] = class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'TS_DmgType_Tiberium_ChemicalMissile'

	
	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = class'TS_PassiveAbility_DamageResist' //Ability linked to 'X' by default  	
	PassiveAbilities(2) = class'TS_PassiveAbility_Grenade_Sonic' //Ability linked to 'G' by default 


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_ParticleIonCannon'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_HeavyPistol'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_ATMine'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Shielding'
	PT_EquipIcon(3)=None

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Ion Trooper"
}
