class Rx_FamilyInfo_GDI_Gunner extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	CameraHeightModifier = 3

	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.12667f
	HealPointsMultiplier    = 0.02533f
	PointsForKill           = 30.0f //45
	MaxHealth               = 100
	MaxArmor               	= 200
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95 //0.9
	

	CharacterMesh=SkeletalMesh'RX_CH_GDI_Gunner.Mesh.SK_CH_Gunner_NewRig'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Gunner'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.15
	BaseTranslationOffset=14.0
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 400
	bHighTier			= true
	PT_Damage			= 5
	PT_Range			= 6
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RocketLauncher'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Gunner'
	

	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 6, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 6, HealthMod = 10, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 6, HealthMod = 25, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 7, HealthMod = 50, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 7, HealthMod = 60, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 7, HealthMod = 75, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 9, HealthMod = 100, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 9, HealthMod = 110, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 9, HealthMod = 125, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 11, HealthMod = 150, SpeedMod = 0.075)

	/* End Veterancy */

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Heavy"
	UIString="Gunner"
}
