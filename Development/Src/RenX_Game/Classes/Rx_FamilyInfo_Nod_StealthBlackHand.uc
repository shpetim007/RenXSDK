class Rx_FamilyInfo_Nod_StealthBlackHand extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.12667f
	HealPointsMultiplier    = 0.02533f
	PointsForKill           = 27.5f //40
	MaxHealth               = 100
	MaxArmor               	= 150
	Armor_Type 				= A_Lazarus
	SpeedMultiplier			= 1.10 // +10%, +7.5%, +5%
	Role 					= 	ROLE_Offense


	CharacterMesh=SkeletalMesh'RX_CH_Nod_SBH.Mesh.SK_CH_StealthBlackHand'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_SBH'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 400
	bHighTier			= true
	PT_Damage			= 4
	PT_Range			= 4
	PT_RateOfFire		= 4
	PT_MagazineCapacity = 3
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserRifle'
	/*---------------*/
	
	
	InvManagerClass = class'Rx_InventoryManager_Nod_StealthBlackHand' 
	
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
	
	bIsStealth = True
	PTString="Buy Char - SBH"
	UIString="Stealth Black Hand"
}
