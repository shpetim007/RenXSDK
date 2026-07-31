class Rx_FamilyInfo_GDI_Marksman extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.020f
	HealPointsMultiplier    = 0.004f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 100
	Armor_Type 				= A_None
	SpeedMultiplier			= 1
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'rx_ch_gdi_soldier.Mesh.SK_CH_GDI_Shotgunner'
	PawnVoiceClass=Class'Rx_Pawn_VoiceClass_GDI_Marksman'
	/*PT Block Info*/
	/*------------*/
	BasePurchaseCost	= 0
	bHighTier			= false
	PT_Damage			= 3
	PT_Range			= 6
	PT_RateOfFire		= 3
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_MarksmanRifle'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Marksman'

	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	PTString="Buy Char - Marksman"
	UIString="Marksman"
}
