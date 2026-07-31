class TS_FamilyInfo_GDI_Engineer extends TS_FamilyInfo_GDI;

static function bool IsEngi()
{
	return true;
}

DefaultProperties
{
	FamilyID="GDI"
	Faction="GDI"

	bHighTier = false
	RequiredFactoryLevel = 0

	//DamagePointsMultiplier  = 0.025f
	HealPointsMultiplier    = 0.016667f
	PointsForKill           = 12.25f //25
	MaxHealth               = 100
	MaxArmor               	= 200
	Armor_Type 				= A_NONE
	SpeedMultiplier			= 1.0
	BasePurchaseCost		= 0

	bAutoHealsInVeh=true
	AutoHealAmount[0]=1

	CharacterMesh=SkeletalMesh'ts_ch_gdi_soldier.Mesh.SK_CH_GDI_EngineerCombat'
	
	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_GDI_Engineer"
	ArmSkinPackageName="TS_CH_Arms"

	InvManagerClass = class'TS_InventoryManager_GDI_Engineer'

	PawnVoiceClass=class'TS_Pawn_VoiceClass_GDI_Engineer'


	/*****************/
	/* Purchase Icon */
	/*****************/

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_Shotgun'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RepairGun'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Wrench'
	PT_EquipIcon(3)=None

	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Engineer"
}