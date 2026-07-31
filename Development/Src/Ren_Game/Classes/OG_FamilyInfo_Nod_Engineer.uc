class OG_FamilyInfo_Nod_Engineer extends OG_FamilyInfo_Nod;

static function bool IsEngi()
{
	return true;
}

DefaultProperties
{
	CustomName = "Engineer"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.03f
	HealPointsMultiplier    = 0.006f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 100
	//Armor_Type 				= A_FLAK
	SpeedMultiplier			= 1.0//0.95 //0.85

	/*PT Block Info*/
	/*------------*/
	bHighTier			= false
	PT_Damage			= 1
	PT_Range			= 2
	PT_RateOfFire		= 1
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_RepairGun'
	/*---------------*/
	
	CharacterMesh=SkeletalMesh'rx_ch_engineer.Mesh.SK_CH_Engineer_Nod'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_Soldier'
	
	ArmMeshPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default" //"RX_CH_GDI_Havoc.Mesh.M_Havoc_Arms"
	ArmSkinPackageName="RX_CH_Arms" //"RX_CH_GDI_Havoc"
	
	//StartWeapons[0] = class'Rx_Weapon_RepairGun'
	//StartWeapons[1] = class'Rx_Weapon_Pistol'
	//StartWeapons[2] = class'Rx_Weapon_TimedC4'
	//StartWeapons[3] = class'Rx_Weapon_RemoteC4'
	//StartWeapons[4] = class'Rx_Weapon_Grenade'

	InvManagerClass = class'OG_InventoryManager_Nod_Engineer' 
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	
	Role = ROLE_Defense
	PTString="Buy Char - Engi"
}
