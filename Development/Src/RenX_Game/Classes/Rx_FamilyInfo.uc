/*********************************************************
*
* File: Rx_FamilyInfo.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_FamilyInfo extends UTFamilyInfo
	dependson(Rx_Pawn)
	implements(Rx_IPurchasable)
	abstract;

var localized string    CharacterName;
var const string CustomName;

/** one1: Made this obsolete. */
//var array<class>        StartWeapons;

enum CharacterRole
{
	ROLE_Offense,
	ROLE_Defense,
	ROLE_All
};

var array<class<Rx_PickUp> > PowerUpClasses;

var const float         DamagePointsMultiplier;
var const float 		SpeedMultiplier;
var const float			JumpMultiplier;
var const float         HealPointsMultiplier;
var const float         PointsForKill;
var const int           MaxHealth;
var const int           MaxArmor;
var ENUM_Armor 			Armor_Type;
var CharacterRole		Role;
var const bool			bFemale; //halo2pac
var bool				bIsStealth;
var bool				bIsSniper;
var const string		PTString;
var const string		UIString;

// Offset the 3rd person camera height for tall or short characters.
var const float         CameraHeightModifier;

// Array of damage types we're immune to
var array<class>        ImmuneTo;
// Array of damage types that heal us [You fools]
var array<class>        HealsIn;

/** one1: Inventory manager class for this familyinfo. */
var class<Rx_InventoryManager> InvManagerClass;

/*The voice used by an actual Pawn, as oppose to the controller*/
var const class<Rx_Pawn_VoiceClass> PawnVoiceClass;

/** Rx_IPurchasable */
var const bool bHighTier;
var const int BasePurchaseCost;
var const localized string PT_Title;
var const localized string PT_Description;
var const int PT_Damage;
var const int PT_Range;
var const int PT_RateOfFire;
var const int PT_MagazineCapacity;
var const Texture2D PT_Icon;

//Passive abilities of this class 
var class<Rx_PassiveAbility> PassiveAbilities[4] ; //Hold passive abilities 
var bool bHasParachute; //Generally yes
var float FallspeedModifier; //How much faster can we fall before taking fall damage (*X)

var const bool bAdvEngi;

/*Veterancy*/
struct VetInfo{
	var const float	VPReward; 
	var float HealthMod; //Health Increases for this unit as it ranks up (+X)
	var float SpeedMod; //Sprint speed increases for this unit as it ranks up. (*X)
};

var array<VetInfo> VetRankInfo; 

static function string GetName()
{
	return Len(default.CustomName) > 0 ? default.CustomName : default.CharacterName;
}

// Purchasing
static function Purchase(Rx_PRI Context) {
	local int RealCost;
	if (Available(Context) == PURCHASE_AVAILABLE) {
		// The class is purchasable
		RealCost = Cost(Context);
		if (FFloor(Context.GetCredits()) >= Cost(Context)) {
			// We have enough credits; purchase the class
			Context.RemoveCredits(RealCost);
			Context.SetChar(default.Class, Controller(Context.Owner).Pawn, RealCost == 0);
			
			// Log purchase
			`LogRxPubObject("GAME" `s "Purchase;" `s "character" `s Context.CharClassInfo.name `s "by" `s `PlayerLog(Context));
			
			// Reset Spy status
			Context.SetIsSpy(false);
		}
	}
}

static function int Cost(Rx_PRI Context) 
{
	if(Context == None) // most likely Scripted Bot
		return default.BasePurchaseCost;


	return `RxGameObject.PurchaseSystem.GetClassPrice(Context.Team.TeamIndex, default.Class);
}

static function EAvailability Available(Rx_PRI Context) 
{
	if (default.bHighTier) 
	{
		if(`RxGameObject.PurchaseSystem.AreHighTierPayClassesDisabled(Context.Team.TeamIndex))
			return PURCHASE_HIDDEN;

	}
	
	return PURCHASE_AVAILABLE;
}

// Block Data
static function string Title() {
	return default.PT_Title;
}

static function string Description() {
	return default.PT_Description;
}

static function Texture Icon() {
	return default.PT_Icon;
}

static function string StrCost() {
	return string(default.BasePurchaseCost);
}


// Metadata
static function int StatType() {
	return 2;
}

static function int DamageOutOfSix() {
	return default.PT_Damage;
}

static function int RangeOutOfSix() {
	return default.PT_Range;
}

static function int RateOfFireOutOfSix() {
	return default.PT_RateOfFire;
}

static function int MagazineCapacityOutOfSize() {
	return default.PT_MagazineCapacity;
}

static function bool IsStealthUnit()
{
	return default.bIsStealth;
}

static function string BotPTString()
{
	return default.PTString;
}

static function bool IsEngi()
{
	return false;
}

static function bool IsSniper()
{
	return default.bIsSniper;
}

/** END Rx_IPurchasable */

/** one1: Removed and modified to return only first weapon. This is used only
 *  for displaying weapon on character in menu. */
function static class<Rx_Weapon> GetPrimaryStartWeaponClass()
{
	return default.InvManagerClass.default.PrimaryWeapons[0];
}

function static MaterialInterface GetFirstPersonArmsMaterial(int TeamNum)
{
	return None;
}

function static float GetCameraHeightModifier()
{
	return default.CameraHeightModifier;
}

// See if we're immune to a specific damage type
function static bool IsImmuneTo(class<DamageType> damageType)
{
	local int i;

	for (i = 0; i < default.ImmuneTo.Length; i++)
	{
		if (default.ImmuneTo[i] == damageType)
			return true;
	}
	return false;

}



// See if we're immune to a specific damage type
function static bool IsHealingDmgType(class<DamageType> damageType)
{
	local int i;

	for (i = 0; i < default.HealsIn.Length; i++)
	{
		if (default.HealsIn[i] == damageType)
			return true;
	}
	return false;

}

function static bool CanPickupDeployedActor(class<Actor> Deployed)
{
	return false;
}

static function bool HasPassiveAbilities()
{
	local int i; 
	
	for(i=0;i<=2;i++)
	{
		if(default.PassiveAbilities[i] != none)
			return true; 
	}
	
	return false; 
}

DefaultProperties
{
	CameraHeightModifier = 0

	FamilyID="GDI"
	Faction="GDI" 

	CharacterMesh=SkeletalMesh'RX_CH_Animations.Mesh.SK_CH_PhysModel'

	ArmMeshPackageName="RX_CH_Arms"
	ArmMesh="RX_CH_Arms.Mesh.SK_Arms_GDI_Default"
	ArmSkinPackageName="RX_CH_Arms"
	
	// PhysAsset=PhysicsAsset'RX_CH_Animations.Mesh.SK_Character_HitReaction_Physics'
	PhysAsset=PhysicsAsset'RX_CH_Animations.Mesh.SK_CH_Physics'					// PhysicsAsset'RX_CH_Animations.Mesh.SK_Character_Ragdoll_Physics'
	AnimSets(0)=AnimSet'RX_CH_Animations.Anims.AS_WeapProfile_Unarmed'
	AnimSets(1)=AnimSet'RX_CH_Animations.Anims.AS_Character_Male_AimOffset'
	
	SoundGroupClass=class'RenX_Game.Rx_PawnSoundGroup' 
	VoiceClass=class'RenX_Game.Rx_Voice_GDI_Male' 
	PawnVoiceClass=class'Rx_Pawn_VoiceClass_GDI_Soldier'
	
	LeftFootBone=b_L_Ankle
	RightFootBone=b_R_Ankle
	TakeHitPhysicsFixedBones[0]=b_L_Ankle
	TakeHitPhysicsFixedBones[1]=b_R_Ankle

	RedArmMaterial=none
	BlueArmMaterial=none

	CharacterTeamHeadMaterials[0]=none
	CharacterTeamBodyMaterials[0]=none
	CharacterTeamHeadMaterials[1]=none
	CharacterTeamBodyMaterials[1]=none

	BaseMICParent=MaterialInstanceConstant'RenX_AssetBase.Characters.MI_CH_All'
	BioDeathMICParent=MaterialInstanceConstant'RenX_AssetBase.Characters.MI_CH_All_BioDeath'
	
	HeadShotEffect=ParticleSystem'RX_CH_Gibs.Effects.P_BloodExplode'

	HeadShotGoreSocketName="HeadShotGoreSocket"
	HeadShotNeckGoreAttachment=StaticMesh'RX_CH_Gore.S_CH_Head_Chunk3'	// StaticMesh'RX_CH_Gore.S_CH_Headshot_Gore'
	
	NeckStumpName="RX_CH_Gore.S_CH_Head_Chunk3"		// "RX_CH_Gore.S_CH_Headshot_Gore" 	// "SK_CH_IronG_Male_NeckStump01"
	
	BloodSplatterDecalMaterial=MaterialInstanceTimeVarying'T_FX.DecalMaterials.MITV_FX_OilDecal_Small01'

	GibExplosionTemplate=ParticleSystem'RX_CH_Gibs.Effects.P_BloodExplode'

	DeathMeshBreakableJoints=("b_L_Arm","b_R_Arm","b_L_UpperLeg","b_R_UpperLeg")

	HeadGib=(BoneName=b_Head,GibClass=class'Rx_Gib_HumanHead',bHighDetailOnly=false)

	Gibs[0]=(BoneName=b_L_ForeArm,GibClass=class'Rx_Gib_HumanArm',bHighDetailOnly=false)
 	Gibs[1]=(BoneName=b_R_ForeArm,GibClass=class'Rx_Gib_HumanArm',bHighDetailOnly=true)
 	Gibs[2]=(BoneName=b_L_LowerLeg,GibClass=class'Rx_Gib_HumanChunk',bHighDetailOnly=false)
 	Gibs[3]=(BoneName=b_R_LowerLeg,GibClass=class'Rx_Gib_HumanChunk',bHighDetailOnly=true)
 	Gibs[4]=(BoneName=b_Spine_1,GibClass=class'Rx_Gib_HumanTorso',bHighDetailOnly=false)
 	Gibs[5]=(BoneName=b_Spine_2,GibClass=class'Rx_Gib_HumanChunk',bHighDetailOnly=false)
 	Gibs[6]=(BoneName=b_Spine_3,GibClass=class'Rx_Gib_HumanBone',bHighDetailOnly=false)
 	Gibs[7]=(BoneName=b_L_UpperLeg,GibClass=class'Rx_Gib_HumanChunk',bHighDetailOnly=true)
 	Gibs[8]=(BoneName=b_R_UpperLeg,GibClass=class'Rx_Gib_HumanChunk',bHighDetailOnly=true)
	
	// default death mesh here
	DeathMeshSkelMesh=SkeletalMesh'RX_CH_Skeletons.Mesh.SK_CH_Skeleton_Human_Male'
	DeathMeshPhysAsset=PhysicsAsset'RX_CH_Skeletons.Mesh.SK_CH_Skeleton_Human_Male_Physics'
	SkeletonBurnOutMaterials=(MaterialInstanceTimeVarying'RX_CH_Skeletons.Materials.MITV_CH_Skeletons_Human_01_BO')
	
	DeathMeshNumMaterialsToSetResident=1
	
	BloodEmitterClass=class'Rx_Emit_HeadShotBloodSpray' // class'UTGame.UTEmit_BloodSpray'
	BloodEffects[0]=(Template=ParticleSystem'RX_CH_Gibs.Effects.P_BloodExplode',MinDistance=750.0)
	BloodEffects[1]=(Template=ParticleSystem'RX_CH_Gibs.Effects.P_BloodExplode',MinDistance=350.0)
	BloodEffects[2]=(Template=ParticleSystem'RX_CH_Gibs.Effects.P_BloodExplode',MinDistance=0.0)

	DefaultMeshScale=1.075
	DrivingDrawScale=1.0
	BaseTranslationOffset=14.0

	MaxHealth = 100
	MaxArmor  = 100
	Armor_Type = A_Kevlar
	Role = ROLE_All
	SpeedMultiplier=1.0
	JumpMultiplier=1.0
	FallspeedModifier = 1.0
	DamagePointsMultiplier=0.05 /*Stock, 1 point/credit per 20 damage. That puts a Rifle soldier at giving away 10 points total without a death bonus*/

	bHasParachute = true //True for basically every class
	
	/*Passive Abilities (3 max)*/
	PassiveAbilities(0) = none //Ability linked to 'Jump' 
	PassiveAbilities(1) = none //Ability linked to 'X' by default  	
	PassiveAbilities(2) = none //Ability linked to 'G' by default 	
	PassiveAbilities(3) = none //Ability linked stealth induced by MSG
	
	
	//PT Info block 
	BasePurchaseCost = 0
	bHighTier = false
	
	bFemale = false; //halo2pac

	/** one1: Default inventory manager class. */
	InvManagerClass=class'Rx_InventoryManager'
	
	/***********/
	/*Veterancy*/
	/***********/

	//VP Reward : Base VP give on death
	//HealthMod: +HP for this rank
	//SpeedMod = Base Sprint Speed multiplied by this

	//RECRUIT
	VetRankInfo(0) = (VPReward = 2, HealthMod = 0, SpeedMod = 0.0) 
	VetRankInfo(1) = (VPReward = 2, HealthMod = 5, SpeedMod = 0.0)
	VetRankInfo(2) = (VPReward = 2, HealthMod = 10, SpeedMod = 0.0)

	//VETERAN
	VetRankInfo(3) = (VPReward = 3, HealthMod = 25, SpeedMod = 0.025) 
	VetRankInfo(4) = (VPReward = 3, HealthMod = 30, SpeedMod = 0.025)
	VetRankInfo(5) = (VPReward = 3, HealthMod = 40, SpeedMod = 0.025)

	//ELITE
	VetRankInfo(6) = (VPReward = 4, HealthMod = 50, SpeedMod = 0.05)
	VetRankInfo(7) = (VPReward = 4, HealthMod = 60, SpeedMod = 0.05)
	VetRankInfo(8) = (VPReward = 4, HealthMod = 75, SpeedMod = 0.05)

	//HEROIC
	VetRankInfo(9) = (VPReward = 5, HealthMod = 100, SpeedMod = 0.1)
	
	/******************/

	bAdvEngi = false
	}
