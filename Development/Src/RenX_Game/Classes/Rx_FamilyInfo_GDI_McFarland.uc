class Rx_FamilyInfo_GDI_McFarland extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"
	// TODO: TEMP DATA  Needs Adjustment
	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 8.75f //20
	MaxHealth               = 100
	MaxArmor               	= 125
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.05
	

	CharacterMesh=SkeletalMesh'rx_ch_gdi_officer.Mesh.SK_CH_McFarland'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_McFarland'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.0
	BaseTranslationOffset=8.0
	
	CameraHeightModifier = -3.0
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 200; //250;
	bHighTier			= false
	PT_Damage			= 5
	PT_Range			= 2
	PT_RateOfFire		= 3
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_FlakCannon'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_GDI_McFarland'
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 4, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 4, HealthMod = 5, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 4, HealthMod = 10, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 5, HealthMod = 25, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 5, HealthMod = 30, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 5, HealthMod = 40, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 7, HealthMod = 50, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 7, HealthMod = 60, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 7, HealthMod = 75, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 10, HealthMod = 100, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - AdvShotgun"
	UIString="McFarland"
}
