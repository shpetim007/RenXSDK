class Rx_FamilyInfo_Nod_Marksman extends Rx_FamilyInfo_Nod;

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

	//DamagePointsMultiplier  = 0.020f
	HealPointsMultiplier    = 0.004f
	PointsForKill           = 5.0f
	MaxHealth               = 100
	MaxArmor               	= 100
	Armor_Type 				= A_None
	SpeedMultiplier			= 1.0
	
	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_Nod_Default"
	ArmSkinPackageName="RX_CH_Arms"

	CharacterMesh=SkeletalMesh'RX_CH_Nod_Soldier.Mesh.SK_CH_Nod_Soldier_Black'
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_Nod_Marksman'
	
	//StartWeapons[0] = class'Rx_Weapon_MarksmanRifle_Nod'
	//StartWeapons[1] = class'Rx_Weapon_Pistol'
	//StartWeapons[2] = class'Rx_Weapon_TimedC4'
	//StartWeapons[3] = class'Rx_Weapon_Grenade'

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
	
	InvManagerClass = class'Rx_InventoryManager_Nod_Marksman' 

	PowerUpClasses.Add(class'Rx_Pickup_HealthSmall');
	PowerUpClasses.Add(class'Rx_Pickup_ArmourLight');
	PTString="Buy Char - Marksman"
	UIString="Marksman"
}
