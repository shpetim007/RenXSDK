class OG_FamilyInfo_Nod_Raveshaw extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Raveshaw"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.157142f
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 43.75f //Gives 60 points in total. 
	MaxHealth               = 100
	MaxArmor               	= 200
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//1.0 //1.05
	Role 					= ROLE_Defense


	CharacterMesh=SkeletalMesh'RX_CH_Nod_Raveshaw.Mesh.SK_CH_Raveshaw'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Raveshaw'
	
	DefaultMeshScale=1.05
	BaseTranslationOffset=8.0
	
	CameraHeightModifier = -1.5
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost		= 1000
	bHighTier				= true
	PT_Damage			= 6
	PT_Range			= 4
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Railgun'
	/*---------------*/
	
	InvManagerClass = class'OG_InventoryManager_Nod_Raveshaw' 
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - PIC"
}
