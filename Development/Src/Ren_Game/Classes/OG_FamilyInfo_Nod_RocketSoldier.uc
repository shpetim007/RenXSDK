class OG_FamilyInfo_Nod_RocketSoldier extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Rocket Officer"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.044f
	HealPointsMultiplier    = 0.0088f
	PointsForKill           = 9.75f // Solid 20
	MaxHealth               = 150
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//1.05
	
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'rx_ch_nod_officer.Mesh.SK_CH_RocketOfficer_Nod'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_RocketOfficer'
	
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

	InvManagerClass = class'OG_InventoryManager_Nod_RocketSoldier' 

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Rocket"
}
