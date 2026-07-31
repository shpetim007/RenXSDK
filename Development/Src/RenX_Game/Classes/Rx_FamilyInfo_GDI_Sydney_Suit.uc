class Rx_FamilyInfo_GDI_Sydney_Suit extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.157142f 
	HealPointsMultiplier    = 0.031428f
	PointsForKill           = 43.75f //Gives 60 points in total. 
	MaxHealth               = 100
	MaxArmor               	= 400 //250
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95 //0.9
	bFemale					= true; //halo2pac
	

	PhysAsset=PhysicsAsset'RX_CH_GDI_MobiusSuit.Mesh.SK_Suit_Physics'
	CharacterMesh=SkeletalMesh'RX_CH_GDI_MobiusSuit.Mesh.SK_CH_MobiusSuit_Sydney'	//SkeletalMesh'rx_ch_gdi_sydney.Mesh.SK_CH_Sydney'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Sydney'
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost		= 1000
	bHighTier				= true
	PT_Damage			= 6
	PT_Range			= 4
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 1
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_PIC'
	/*---------------*/
	
	DefaultMeshScale=1.1
	BaseTranslationOffset=12.0
	
	CameraHeightModifier = -3.5
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Heavy_Female' 

	InvManagerClass = class'Rx_InventoryManager_GDI_Sydney_Suit'
	
	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3]	= class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4]	= class'Rx_DmgType_TiberiumAutoRifle'
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 12, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 12, HealthMod = 25, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 12, HealthMod = 50, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 13, HealthMod = 75, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 13, HealthMod = 100, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 13, HealthMod = 125, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 15, HealthMod = 150, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 15, HealthMod = 175, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 15, HealthMod = 200, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 20, HealthMod = 225, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthLarge');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourHeavy');

	PTString="Buy Char - Epic"
	UIString="Armoured Sydney"
}
