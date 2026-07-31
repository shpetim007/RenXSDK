class TS_StatModifierInfo_RepKitHeal extends Rx_StatModifierInfo; //Buffs/Debuffs/Special functions

/* Defensive Buff for Nod; Focuses slightly more on things that make their infantry tougher*/

DefaultProperties
{
	//Buff/Debuff modifiers//
	SpeedModifier 	= 0.0 //-0.10 //

	//Weapons
	DamageBoostMod 	= 0.0  //
	RateOfFireMod 	= 0.0 // 
	ReloadSpeedMod 	= 0.0 //

	//Survivablity
	DamageResistanceMod = 0.0 //0.10 //Justification: Super Man Tanks... that is all
	RegenerationMod 	= 5.0  // 10 ticks per second, so times it by 4 to get healing per second

	//Modifier stats
	Mod_Length = 5.0 //20.0
	ModificationName = "Repair-Kit Healing"
	DmgType = class'Rx_DmgType_RepairGun'
	
	EffectColor		= (R=0.5,G=0.5,B=1.0,A=1.0)
	EffectOpacity	= 0.025
	EffectInflation	= 0.25
	EffectPriority	= 7

	PawnMIC = None//MaterialInstanceConstant'RenX_AssetBase.Stealth.MI_PowerUp_Speed'
	
	bAffectInfantry = false	
	bAffectVehicles = true // basically inverted med kit
}