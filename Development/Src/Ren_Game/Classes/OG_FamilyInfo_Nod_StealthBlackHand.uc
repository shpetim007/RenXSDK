class OG_FamilyInfo_Nod_StealthBlackHand extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Stealth Black Hand"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.12667f
	HealPointsMultiplier    = 0.02533f
	PointsForKill           = 27.5f //40
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_Lazarus
	SpeedMultiplier			= 1.0//1.1 // +10%, +7.5%, +5%
	Role 					= 	ROLE_Offense


	CharacterMesh=SkeletalMesh'RX_CH_Nod_SBH.Mesh.SK_CH_StealthBlackHand'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_StealthBlackHand'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 400
	bHighTier			= true
	PT_Damage			= 4
	PT_Range			= 4
	PT_RateOfFire		= 4
	PT_MagazineCapacity = 3
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserRifle'
	/*---------------*/
	
	
	InvManagerClass = class'OG_InventoryManager_Nod_StealthBlackHand' 

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	
	bIsStealth = True
	PTString="Buy Char - SBH"
}
