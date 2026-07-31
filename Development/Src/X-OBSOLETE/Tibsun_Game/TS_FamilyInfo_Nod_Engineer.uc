class TS_FamilyInfo_Nod_Engineer extends TS_FamilyInfo_Nod;

static function bool IsEngi()
{
	return true;
}

DefaultProperties
{
	FamilyID="Nod"
	Faction="Nod"

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

	CharacterMesh=SkeletalMesh'ts_ch_nod_soldier.Mesh.SK_CH_Nod_Engineer'

	ArmMeshPackageName="TS_CH_Arms"
	ArmMesh="TS_CH_Arms.Mesh.SK_Arms_Nod_Soldier"
	ArmSkinPackageName="TS_CH_Arms"

	/** one1: Added. */
	InvManagerClass = class'TS_InventoryManager_Nod_Engineer'

	PawnVoiceClass=class'TS_Pawn_VoiceClass_GDI_Engineer'


	/*****************/
	/* Purchase Icon */
	/*****************/

	// Loadout 1 - Engineer

	PT_Icon = Texture2D'TSPurchaseMenu.Textures.Weapon.T_PT_Weap_Shotgun'
	
	PT_EquipIcon(0)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_RepairGun'
	PT_EquipIcon(1)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_TimedC4'
	PT_EquipIcon(2)=Texture2D'TSPurchaseMenu.Textures.Loadout.T_PT_Icon_Wrench'
	PT_EquipIcon(3)=None

	/***************************/
	/*Passive Abilities (3 max)*/
	/***************************/
	PassiveAbilities(0) = none //Ability Linked to jumpping
	PassiveAbilities(1) = none  // Nothing  	
	PassiveAbilities(2) = none


	/*********/
	/*AI*/
	/*********/
	PTString = "Buy Char - Engineer"
}
