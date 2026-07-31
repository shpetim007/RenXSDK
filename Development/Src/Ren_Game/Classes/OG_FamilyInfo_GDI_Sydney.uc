class OG_FamilyInfo_GDI_Sydney extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Sydney"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 150
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//1.0 //0.9
	bFemale					= true; //halo2pac
	Role 					= ROLE_Defense

	

	CharacterMesh=SkeletalMesh'rx_ch_gdi_sydney.Mesh.SK_CH_Sydney_Green'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Sydney'
	
	DefaultMeshScale=1.01
	BaseTranslationOffset=7.0
	
	CameraHeightModifier = -2.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Female' 

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 150
	bHighTier			= true
	PT_Damage			= 5
	PT_Range			= 3
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RX_WP_TiberiumAutoRifle.UI.T_WeaponIcon_TiberiumAutoRifle'
	/*---------------*/
	
	InvManagerClass = class'OG_InventoryManager_GDI_Sydney'
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');

	PTString="Buy Char - PIC"
}
