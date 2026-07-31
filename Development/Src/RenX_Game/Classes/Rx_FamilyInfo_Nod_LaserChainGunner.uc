class Rx_FamilyInfo_Nod_LaserChainGunner extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"
	
	// TODO: TEMP DATA  Needs Adjustment
	DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 30.0f	//45
	MaxHealth               = 100
	MaxArmor               	= 300//250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.9 //0.8 //0.75
	JumpMultiplier			= 0.8 //0.70 Just high enough to get off of the
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy' 
	
	CharacterMesh=SkeletalMesh'RX_CH_Nod_BlackHand_LCG.Mesh.SK_CH_LaserChainGunner_3P'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_BlackHandHeavy'
	
	ArmMeshPackageName="RX_CH_Nod_BlackHand_LCG"
	ArmMesh="RX_CH_Nod_BlackHand_LCG.Mesh.SK_CH_LaserChainGunner_1P"
	ArmSkinPackageName="RX_CH_Nod_BlackHand_LCG"

	DefaultMeshScale=1.15
	BaseTranslationOffset=14.0
	
	CameraHeightModifier = 3
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 450
	bHighTier			= true
	PT_Damage			= 3
	PT_Range			= 4
	PT_RateOfFire		= 6
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_LaserChaingun'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_Nod_LaserChainGunner' 

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
	VetRankInfo(8) = (VPReward = 9, HealthMod = 135, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 11, HealthMod = 175, SpeedMod = 0.075)

	/* End Veterancy */

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Heavy"
	UIString="Laser Chain Gunner"
}
