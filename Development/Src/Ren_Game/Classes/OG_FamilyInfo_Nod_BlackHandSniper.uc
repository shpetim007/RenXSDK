class OG_FamilyInfo_Nod_BlackHandSniper extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Black Hand Sniper"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.1f
	HealPointsMultiplier    = 0.02f
	PointsForKill           = 22.5 // 35
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_None
	SpeedMultiplier			= 1.0//0.9
	

	CharacterMesh=SkeletalMesh'RX_CH_Nod_BlackHandSniper.Mesh.SK_CH_BlackHandSniper'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_BlackHandSniper'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 500
	bHighTier			= true
	bIsSniper			= true
	PT_Damage			= 5
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_Nod_BlackHandSniper' 

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Sniper"
}
