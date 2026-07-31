class Rx_FamilyInfo_GDI_Engineer extends Rx_FamilyInfo_GDI;

static function bool IsEngi()
{
	return true;
}

static function bool CanPickupDeployedActor(class<Actor> Deployed)
{
	return Deployed == class<Rx_Weapon_DeployedRemoteC4>(Deployed);
}

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.03f
	HealPointsMultiplier    = 0.006f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 100
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95

	/*PT Block Info*/
	/*------------*/
	bHighTier			= false
	PT_Damage			= 1
	PT_Range			= 2
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun'
	/*---------------*/
	
	CharacterMesh=SkeletalMesh'rx_ch_engineer.Mesh.SK_CH_Engineer_GDI'
	PawnVoiceClass=Class'Rx_Pawn_VoiceClass_GDI_Engineer'
	
	ArmMeshPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default" //"RX_CH_GDI_Havoc.Mesh.M_Havoc_Arms"
	ArmSkinPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	
	/*
	StartWeapons[0] = class'Rx_Weapon_RepairGun'
	StartWeapons[1] = class'Rx_Weapon_Pistol'
	StartWeapons[2] = class'Rx_Weapon_TimedC4'
	StartWeapons[3] = class'Rx_Weapon_RemoteC4'
	StartWeapons[4] = class'Rx_Weapon_Grenade'
	*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Engineer'

	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	
	Role = ROLE_Defense
	PTString="Buy Char - Engi"
	UIString="Engineer"
}
