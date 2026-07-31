class OG_FamilyInfo_GDI_Deadeye extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Deadeye"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.1f
    HealPointsMultiplier    = 0.02f
    PointsForKill           = 22.5f //30
	MaxHealth               = 200
	MaxArmor               	= 100
	//Armor_Type 				= A_None
	SpeedMultiplier			= 1.0//0.9

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
//	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_DeadEye'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*
	StartWeapons[0] = class'Rx_Weapon_SniperRifle_GDI'
	StartWeapons[1] = class'Rx_Weapon_Pistol'
	StartWeapons[2] = class'Rx_Weapon_TimedC4'
	StartWeapons[3] = class'Rx_Weapon_Grenade'
	*/

	InvManagerClass = class'OG_InventoryManager_GDI_Deadeye'

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');

	PTString="Buy Char - Sniper"
}
