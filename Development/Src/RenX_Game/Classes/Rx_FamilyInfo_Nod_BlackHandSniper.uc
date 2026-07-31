class Rx_FamilyInfo_Nod_BlackHandSniper extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.1f
	HealPointsMultiplier    = 0.02f
	PointsForKill           = 22.5 // 35
	MaxHealth               = 100
	MaxArmor               	= 150
	Armor_Type 				= A_None
	SpeedMultiplier			= 0.95
	

	CharacterMesh=SkeletalMesh'RX_CH_Nod_BlackHandSniper.Mesh.SK_CH_BlackHandSniper'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_BlackHandSniper'
	
	ArmMeshPackageName="RX_CH_Nod_BlackHandSniper"
	ArmMesh="RX_CH_Nod_BlackHandSniper.Mesh.SK_CH_BlackHandSniper_1P"
	ArmSkinPackageName="RX_CH_Nod_BlackHandSniper"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 500
	bHighTier			= true
	bIsSniper			= true
	PT_Damage			= 5
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_Nod_BlackHandSniper' 
	
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
	PTString="Buy Char - Sniper"
	UIString="Black Hand Sniper"
}
