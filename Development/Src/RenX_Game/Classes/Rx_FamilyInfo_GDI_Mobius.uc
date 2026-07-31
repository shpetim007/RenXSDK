class Rx_FamilyInfo_GDI_Mobius extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 52.5f //70
	MaxHealth               = 100
	MaxArmor               	= 250 //250
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0
	Role = ROLE_Offense

	

	CharacterMesh=SkeletalMesh'rx_ch_gdi_mobius.Mesh.SK_CH_Mobius_New'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Mobius'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 2
	PT_RateOfFire		= 6
	PT_MagazineCapacity = 5
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_VoltAutoRifle'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Mobius'
	
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
	PTString="Buy Char - Destroyer"
	UIString="Mobius"
}
