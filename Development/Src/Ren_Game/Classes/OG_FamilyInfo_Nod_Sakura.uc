class OG_FamilyInfo_Nod_Sakura extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Sakura"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.142857f
	HealPointsMultiplier    = 0.028571f
	PointsForKill           = 40.0f //55 total points for kill
	MaxHealth               = 100
	MaxArmor               	= 200
	//Armor_Type 				= A_None
	SpeedMultiplier			= 1.0//0.9
	bFemale					= true; //halo2pac
	

	CharacterMesh=SkeletalMesh'RX_CH_Nod_Sakura.Mesh.SK_CH_Sakura'
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Sakura'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.01
	BaseTranslationOffset=7.0
	
	CameraHeightModifier = -2.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Female' 
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	bIsSniper			= true
	PT_Damage			= 6
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle'
	/*---------------*/

	InvManagerClass = class'OG_InventoryManager_Nod_Sakura' 

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Ramjet"
}
