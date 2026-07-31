class OG_FamilyInfo_GDI_Patch extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Patch"
    	FamilyID="GDI"
    	Faction="GDI"

	// TODO: TEMP DATA  Needs Adjustment
	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 26.25f //40
	
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0//1.125 //1.175
	
	
    CharacterMesh=SkeletalMesh'rx_ch_gdi_patch.Mesh.SK_CH_Patch'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Patch'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 450
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 5
	PT_RateOfFire		= 4
	PT_MagazineCapacity = 3
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TibFlechetteRifle'
	/*---------------*/
	
	InvManagerClass = class'OG_InventoryManager_GDI_Patch'
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Patch"
}
