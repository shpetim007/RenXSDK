class OG_FamilyInfo_Nod_Mendoza extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Mendoza"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.157142f
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 53.75f //70 
	MaxHealth               = 100
	MaxArmor               	= 225
	//Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0//1.1 // +10%, +7.5%, +5%
	Role 					= ROLE_Offense

	CharacterMesh=SkeletalMesh'RX_CH_Nod_Mendoza.Mesh.SK_CH_Mendoza'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_Mendoza'
	
	DefaultMeshScale=1.1
	BaseTranslationOffset=14.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	PT_Damage			= 4
	PT_Range			= 2
	PT_RateOfFire		= 5
	PT_MagazineCapacity = 4
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_VoltAutoRifle'
	/*---------------*/
	
	InvManagerClass = class'OG_InventoryManager_Nod_Mendoza' 
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Destroyer"
}
