class OG_FamilyInfo_GDI_RocketSoldier extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Rocket Officer"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.044f
	HealPointsMultiplier    = 0.0088f
	PointsForKill           = 8.5f //20
	
	MaxHealth               = 150
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.95
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'rx_ch_gdi_officer.Mesh.SK_CH_RocketSoldier'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_RocketSoldier'
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 225
	bHighTier			= false
	PT_Damage			= 4
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RocketLauncher'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_GDI_RocketSoldier'

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Rocket"
}
