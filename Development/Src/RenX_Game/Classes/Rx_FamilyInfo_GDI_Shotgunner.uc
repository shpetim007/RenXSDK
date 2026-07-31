class Rx_FamilyInfo_GDI_Shotgunner extends Rx_FamilyInfo_GDI;

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	//DamagePointsMultiplier  = 0.020f
	HealPointsMultiplier    = 0.004f
	PointsForKill           = 5.0f
	
	MaxHealth               = 100
	MaxArmor               	= 100
	Armor_Type 				= A_Kevlar
	SpeedMultiplier			= 1.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'rx_ch_gdi_soldier.Mesh.SK_CH_GDI_Shotgunner'
	PawnVoiceClass=Class'Rx_Pawn_VoiceClass_GDI_Shotgunner'
	
	/*PT Block Info*/
	/*------------*/
	bHighTier			= false
	BasePurchaseCost	= 0 
	PT_Damage			= 5
	PT_Range			= 2
	PT_RateOfFire		= 2
	PT_MagazineCapacity = 2
	PT_Icon				= Texture2D'RenXPurchaseMenu.T_Icon_Weapon_Shotgun'
	/*---------------*/

	InvManagerClass = class'Rx_InventoryManager_GDI_Shotgunner'

	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	PTString="Buy Char - Shotgun"

	UIString="Shotgunner"
}
