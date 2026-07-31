class Rx_FamilyInfo_GDI_Patch extends Rx_FamilyInfo_GDI;

DefaultProperties
{
    FamilyID="GDI"
    Faction="GDI"
	// TODO: TEMP DATA  Needs Adjustment
	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 26.25f //40
	
	MaxHealth               = 100
	MaxArmor               	= 175
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.10 //1.175
	
	
    CharacterMesh=SkeletalMesh'rx_ch_gdi_patch.Mesh.SK_CH_patch'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Patch'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 450
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 5
	PT_RateOfFire		= 4
	PT_MagazineCapacity = 3
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_TacticalRifle'
	/*---------------*/
	
	InvManagerClass = class'Rx_InventoryManager_GDI_Patch'
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 6, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 6, HealthMod = 5, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 6, HealthMod = 10, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 7, HealthMod = 25, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 7, HealthMod = 30, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 7, HealthMod = 40, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 9, HealthMod = 50, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 9, HealthMod = 60, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 9, HealthMod = 75, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 11, HealthMod = 100, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Patch"
	UIString="Patch"
}
