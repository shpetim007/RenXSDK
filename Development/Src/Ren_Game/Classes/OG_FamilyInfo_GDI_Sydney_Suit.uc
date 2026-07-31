class OG_FamilyInfo_GDI_Sydney_Suit extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Prototype Assault Suit"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 52.5f //Gives 60 points in total. 
	MaxHealth               = 250
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.95 //0.9
	bFemale					= true; //halo2pac
	

	PhysAsset=PhysicsAsset'RX_CH_GDI_MobiusSuit.Mesh.SK_Suit_Physics'
	CharacterMesh=SkeletalMesh'RX_CH_GDI_MobiusSuit.Mesh.SK_CH_MobiusSuit_Sydney'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Sydney'
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost		= 1000
	bHighTier				= true
	PT_Damage			= 6
	PT_Range			= 4
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_PIC'
	/*---------------*/
	
	DefaultMeshScale=1.1
	BaseTranslationOffset=12.0
	
	CameraHeightModifier = -3.5
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy_Female' 

	InvManagerClass = class'OG_InventoryManager_GDI_Sydney_Suit'

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');

	PTString="Buy Char - Epic"
}
