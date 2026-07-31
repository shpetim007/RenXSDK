class Rx_FamilyInfo_Nod_Sakura extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.142857f
	HealPointsMultiplier    = 0.028571f
	PointsForKill           = 40.0f //55 total points for kill
	MaxHealth               = 100
	MaxArmor               	= 200
	Armor_Type 				= A_None
	SpeedMultiplier			= 0.95
	bFemale					= true; //halo2pac
	

	CharacterMesh=SkeletalMesh'RX_CH_Nod_Sakura.Mesh.SK_CH_Sakura'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Sakura'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	DefaultMeshScale=1.01
	BaseTranslationOffset=7.0
	
	CameraHeightModifier = -2.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Female' 
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 1000
	bHighTier			= true
	bIsSniper			= true
	PT_Damage			= 6
	PT_Range			= 6
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RamjetRifle'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_Nod_Sakura' 
	
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 10, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 10, HealthMod = 5, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 10, HealthMod = 10, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 11, HealthMod = 25, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 11, HealthMod = 30, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 11, HealthMod = 40, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 13, HealthMod = 50, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 13, HealthMod = 60, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 13, HealthMod = 75, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 16, HealthMod = 100, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');
	PTString="Buy Char - Ramjet"
	UIString="Sakura"
}
