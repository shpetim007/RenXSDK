class Rx_FamilyInfo_GDI_Sydney extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428
	PointsForKill           = 52.5f //70
	MaxHealth               = 100
	MaxArmor               	= 200//250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95 //0.9
	bFemale					= true; //halo2pac
	Role 					= ROLE_Defense

	

	CharacterMesh=SkeletalMesh'rx_ch_gdi_sydney.Mesh.SK_CH_Sydney'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Sydney'
	
	DefaultMeshScale=1.01
	BaseTranslationOffset=7.0
	
	CameraHeightModifier = -2.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Female' 

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	PT_Damage			= 5
	PT_Range			= 3
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_PIC'
	/*---------------*/
	
	InvManagerClass = class'Rx_InventoryManager_GDI_Sydney'
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 10, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 10, HealthMod = 10, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 10, HealthMod = 25, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 11, HealthMod = 50, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 11, HealthMod = 60, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 11, HealthMod = 75, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 13, HealthMod = 100, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 13, HealthMod = 110, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 13, HealthMod = 125, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 16, HealthMod = 150, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');

	PTString="Buy Char - PIC"
	UIString="Sydney"
}
