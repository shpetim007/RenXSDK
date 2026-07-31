class OG_FamilyInfo_GDI_Havoc extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Havoc"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.142857f
	HealPointsMultiplier    = 0.028571f
	PointsForKill           = 40.0f //55
	MaxHealth               = 250
	MaxArmor               	= 100
	//Armor_Type 				= A_None
	SpeedMultiplier			= 1.0//0.9

	CharacterMesh=SkeletalMesh'RX_CH_GDI_Havoc.Mesh.SK_CH_Havoc'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Havoc'
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	bIsSniper			= true
	PT_Damage			= 6
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_GDI_Havoc'

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Ramjet"
}
