class OG_FamilyInfo_GDI_Gunner extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CameraHeightModifier = 3

	CustomName = "Gunner"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.12667f
	HealPointsMultiplier    = 0.02533f
	PointsForKill           = 30.0f //45
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.95 //0.9
	

	CharacterMesh=SkeletalMesh'RX_CH_GDI_Gunner.Mesh.SK_CH_Gunner_NewRig'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Gunner'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.15
	BaseTranslationOffset=14.0
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 400
	bHighTier			= true
	PT_Damage			= 5
	PT_Range			= 6
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RocketLauncher'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_GDI_Gunner'
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Heavy"
}
