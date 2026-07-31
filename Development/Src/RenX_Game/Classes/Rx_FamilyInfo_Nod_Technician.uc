class Rx_FamilyInfo_Nod_Technician extends Rx_FamilyInfo_Nod;

static function bool IsEngi()
{
	return true;
}

static function bool CanPickupDeployedActor(class<Actor> Deployed)
{
	return true;
}

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	bAdvEngi = true

	//DamagePointsMultiplier  = 0.083333f
	HealPointsMultiplier    = 0.016667f
	PointsForKill           = 12.25f //Total 25
	MaxHealth               = 100
	MaxArmor               	= 125
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0 /*0.9 set back to 1.0 for the sake of some map design issues. Besides, they got nerfed where it hurt already. Right in the sidearm*/
	Role 					= ROLE_Defense
	/*PT Block Info*/
	/*------------*/
	bHighTier			= true
	BasePurchaseCost	= 350
	PT_Damage			= 1
	PT_Range			= 2
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun'
	
	/*---------------*/

	CharacterMesh=SkeletalMesh'RX_CH_Technician.Meshes.SK_CH_Technician'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Technician'
	
	
	ArmMeshPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default" //"RX_CH_GDI_Havoc.Mesh.M_Havoc_Arms"
	ArmSkinPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"

	InvManagerClass = class'Rx_InventoryManager_Nod_Technician' 
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 5, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 5, HealthMod = 5, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 5, HealthMod = 10, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 6, HealthMod = 25, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 6, HealthMod = 30, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 6, HealthMod = 40, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 8, HealthMod = 50, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 8, HealthMod = 60, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 8, HealthMod = 75, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 10, HealthMod = 100, SpeedMod = 0.075)
	
	/******************/

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	
	
	PTString="Buy Char - AdvEngi"
	UIString="Technician"
}
