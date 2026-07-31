class OG_FamilyInfo_GDI_Officer extends OG_FamilyInfo_GDI;

DefaultProperties
{
	CustomName = "Officer"
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 7.5f //20
	MaxHealth               = 150
	MaxArmor               	= 100
	//Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0//1.0
	Role 					= ROLE_Offense

	CharacterMesh=SkeletalMesh'rx_ch_gdi_officer.Mesh.SK_CH_Officer_New'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_GDI_Officer'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost		= 175
	bHighTier				= false
	PT_Damage			= 2
	PT_Range			= 3
	PT_RateOfFire		= 6
	PT_MagazineCapacity = 6
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Chaingun'
	/*---------------*/
	
	InvManagerClass = class'OG_InventoryManager_GDI_Officer'

	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Officer"
}
