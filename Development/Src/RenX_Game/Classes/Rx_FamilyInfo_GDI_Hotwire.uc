class Rx_FamilyInfo_GDI_Hotwire extends Rx_FamilyInfo_GDI;

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
	FamilyID="GDI"
	Faction="GDI"

	bAdvEngi=true

	//DamagePointsMultiplier  = 0.083333f
	HealPointsMultiplier    = 0.016667f
	PointsForKill           = 12.25f //25
	MaxHealth               = 100
	MaxArmor               	= 125
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0
	bFemale					= true; //halo2pac
	
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

	CharacterMesh=SkeletalMesh'rx_ch_gdi_hotwire.Mesh.SK_CH_Hotwire_New'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_HotWire'
	
	ArmMeshPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default" //"RX_CH_GDI_Havoc.Mesh.M_Havoc_Arms"
	ArmSkinPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	
	DefaultMeshScale=1.01
	BaseTranslationOffset=7.0
	
	CameraHeightModifier = -2.0
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup_Female' 
	
	/*
	StartWeapons[0] = class'Rx_Weapon_RepairGunAdvanced'
	StartWeapons[1] = class'Rx_Weapon_Pistol'
	StartWeapons[2] = class'Rx_Weapon_TimedC4_Multiple'
	StartWeapons[3] = class'Rx_Weapon_RemoteC4'
	StartWeapons[4] = class'Rx_Weapon_ProxyC4'
	StartWeapons[5] = class'Rx_Weapon_Grenade'
	*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Hotwire'
	
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
	
	Role = ROLE_Defense
	PTString="Buy Char - AdvEngi"
	UIString="Hotwire"
}
