class Rx_FamilyInfo_Nod_ChemicalTrooper extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	// TODO: TEMP DATA  Needs Adjustment
	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 7.5f	//20
	MaxHealth               = 100
	MaxArmor               	= 150
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0
	

	/*PT Block Info*/
	/*------------*/
	bHighTier			= false
	BasePurchaseCost	= 200 ;//250
	PT_Damage			= 4
	PT_Range			= 2
	PT_RateOfFire		= 4
	PT_MagazineCapacity = 3
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_ChemicalThrower'
	/*---------------*/
	
	
	CharacterMesh=SkeletalMesh'RX_CH_Nod_ChemicalTrooper.Mesh.SK_CH_Nod_ChemicalTrooper'
	
	ArmMeshPackageName="RX_CH_Nod_ChemicalTrooper"
	ArmMesh="RX_CH_Nod_ChemicalTrooper.Mesh.SK_Arms_Nod_ChemicalTrooper"
	ArmSkinPackageName="SK_Arms_Nod_ChemicalTrooper"

	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_ChemicalTrooper'
	
	//StartWeapons[0] = class'Rx_Weapon_ChemicalThrower'
	//StartWeapons[1] = class'Rx_Weapon_Pistol'
	//StartWeapons[2] = class'Rx_Weapon_TimedC4'
	//StartWeapons[3] = class'Rx_Weapon_Grenade'

	ImmuneTo[0] = class'Rx_DmgType_Tiberium'
	ImmuneTo[1] = class'Rx_DmgType_TiberiumBleed'
	ImmuneTo[2] = class'Rx_DmgType_ChemicalThrower'
	ImmuneTo[3]	= class'Rx_DmgType_Tiberium_Blue'
	ImmuneTo[4]	= class'Rx_DmgType_TiberiumAutoRifle'
	
	
	
	InvManagerClass = class'Rx_InventoryManager_Nod_ChemicalTrooper' 
	
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
	PTString="Buy Char - AdvShotgun"
	UIString="Chemical Warrior"
}
