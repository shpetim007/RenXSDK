class Rx_FamilyInfo_GDI_Grenadier extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.025f
	HealPointsMultiplier    = 0.005f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 125 //100
	Armor_Type 				= A_FLAK
	SpeedMultiplier			= 0.95 //0.95
	Role 					= ROLE_Offense

	CharacterMesh=SkeletalMesh'rx_ch_gdi_soldier.Mesh.SK_CH_GDI_Grenadier'

	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Grenadier'
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 0; //250;
	bHighTier			= false
	PT_Damage			= 4
	PT_Range			= 3
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_GrenadeLauncher'
	/*---------------*/

	/** one1: Added. */
	InvManagerClass = class'Rx_InventoryManager_GDI_Grenadier'
	

	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	PTString="Buy Char - BasicAT"

	UIString="Grenadier"
}
