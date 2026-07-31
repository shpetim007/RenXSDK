class Rx_FamilyInfo_GDI_Deadeye extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.1f
    HealPointsMultiplier    = 0.02f
    PointsForKill           = 22.5f //30
	MaxHealth               = 100
	MaxArmor               	= 150
	Armor_Type 				= A_None
	SpeedMultiplier			= 1.0

	/*PT Block Info*/
	/*------------*/
	bHighTier			= true
	bIsSniper			= true
	BasePurchaseCost	= 500
	PT_Damage			= 5
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_SniperRifle'
	
	/*---------------*/
	
	CharacterMesh=SkeletalMesh'rx_ch_gdi_deadeye.Mesh.SK_CH_Deadeye'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_DeadEye'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*
	StartWeapons[0] = class'Rx_Weapon_SniperRifle_GDI'
	StartWeapons[1] = class'Rx_Weapon_Pistol'
	StartWeapons[2] = class'Rx_Weapon_TimedC4'
	StartWeapons[3] = class'Rx_Weapon_Grenade'
	*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Deadeye'

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
	UIString="Deadeye"
}
