class Rx_FamilyInfo_Admin extends Rx_FamilyInfo;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.12667f
	HealPointsMultiplier    = 0f
	PointsForKill           = 0f //40
	MaxHealth               = 2000
	MaxArmor               	= 2000
	Armor_Type 				= A_Lazarus
	SpeedMultiplier			= 1.5 // +10%, +7.5%, +5%
	JumpMultiplier			= 3
	Role 					= 	ROLE_Offense

	bHasParachute = false

	CharacterMesh=SkeletalMesh'RX_CH_Nod_SBH.Mesh.SK_CH_StealthBlackHand'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_SBH'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 0
	bHighTier			= false
	PT_Damage			= 0
	PT_Range			= 0
	PT_RateOfFire		= 0
	PT_MagazineCapacity = 0
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserRifle'
	/*---------------*/
	
	
	InvManagerClass = class'Rx_InventoryManager_Admin' 

	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 0, HealthMod = 0, SpeedMod = 0) 
	VetRankInfo(1) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)
	VetRankInfo(2) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 0, HealthMod = 0, SpeedMod = 0) 
	VetRankInfo(4) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)
	VetRankInfo(5) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)

	//ELITE
	VetRankInfo(6) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)
	VetRankInfo(7) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)
	VetRankInfo(8) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)

	//HEROIC
	VetRankInfo(9) = (VPReward = 0, HealthMod = 0, SpeedMod = 0)
	
	/******************/
	
	bIsStealth = True
	PTString="Buy Char - Admin"
	UIString="Stealth Black Hand"
}
