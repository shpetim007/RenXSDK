class Rx_FamilyInfo_Nod_RocketSoldier extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.044f
	HealPointsMultiplier    = 0.0088f
	PointsForKill           = 9.75f // Solid 20
	MaxHealth               = 100
	MaxArmor               	= 150
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95
	
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'rx_ch_nod_officer.Mesh.SK_CH_RocketOfficer_Nod'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_RocketOfficer'
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 225
	bHighTier			= false
	PT_Damage			= 4
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MissileLauncher'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_Nod_RocketSoldier' 
	
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
	PTString="Buy Char - Rocket"
	UIString="Rocket Soldier"
}
