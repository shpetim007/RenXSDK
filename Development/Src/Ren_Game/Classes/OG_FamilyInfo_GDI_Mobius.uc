class OG_FamilyInfo_GDI_Mobius extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Mobius"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 52.5f //70
	MaxHealth               = 250
	MaxArmor               	= 100
	//Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0//1.0
	Role = ROLE_Offense

	

	CharacterMesh=SkeletalMesh'rx_ch_gdi_mobius.Mesh.SK_CH_Mobius_New'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Mobius'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 2
	PT_RateOfFire		= 6
	PT_MagazineCapacity = 5
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_VoltAutoRifle'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_GDI_Mobius'
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Destroyer"
}
