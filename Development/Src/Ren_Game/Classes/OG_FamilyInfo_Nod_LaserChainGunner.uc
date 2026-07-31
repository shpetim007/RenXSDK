class OG_FamilyInfo_Nod_LaserChainGunner extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Laser Chain Gunner"
	FamilyID="Nod"
	Faction="Nod"
	
	// TODO: TEMP DATA  Needs Adjustment
	DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 30.0f	//45
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.85 //0.8 //0.75
	
	CharacterMesh=SkeletalMesh'RX_CH_Nod_BlackHand_LCG.Mesh.SK_CH_LaserChainGunner_3P'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_LaserChainGunner'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.15
	BaseTranslationOffset=14.0
	
	CameraHeightModifier = 3
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 450
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 4
	PT_RateOfFire		= 6
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserChaingun'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_Nod_LaserChainGunner' 
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Heavy"
}
