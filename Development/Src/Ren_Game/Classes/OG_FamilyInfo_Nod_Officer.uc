class OG_FamilyInfo_Nod_Officer extends OG_FamilyInfo_Nod;

DefaultProperties
{
	CustomName = "Officer"
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.036f
	HealPointsMultiplier    = 0.0072f
	PointsForKill           = 9.75 //20 points
	MaxHealth               = 150
	MaxArmor               	= 100
	//Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0//1.1
	Role 					= ROLE_Defense

	CharacterMesh=SkeletalMesh'rx_ch_nod_officer.Mesh.SK_CH_Officer_Nod'
	PawnVoiceClass=class'OG_Pawn_VoiceClass_Nod_Officer'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
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
	
	InvManagerClass = class'OG_InventoryManager_Nod_Officer' 
	
	PowerUpClasses.Add(class'Rx_Pickup_HealthMedium');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourMedium');
	PTString="Buy Char - Officer"
}
