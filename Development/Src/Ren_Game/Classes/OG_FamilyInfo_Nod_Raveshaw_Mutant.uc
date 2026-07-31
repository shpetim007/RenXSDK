class OG_FamilyInfo_Nod_Raveshaw_Mutant extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Mutant Raveshaw"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.157142f
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 43.75f //Gives 60 points in total. 
	MaxHealth               = 100
	MaxArmor               	= 400
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.95
	

	CharacterMesh=SkeletalMesh'rx_ch_nod_raveshaw_mutant.Mesh.SK_CH_Raveshaw_Mutant'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Raveshaw_Mutant'
		SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost		= 1000
	bHighTier				= true
	PT_Damage			= 6
	PT_Range			= 4
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Railgun'
	/*---------------*/
	
	DefaultMeshScale=1.15
	BaseTranslationOffset=14.0
	
	CameraHeightModifier = 3.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	InvManagerClass = class'OG_InventoryManager_Nod_Raveshaw_Mutant' 
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3]	= class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4] = class'Rx_DmgType_TiberiumAutoRifle'
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Epic"
}
