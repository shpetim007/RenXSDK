class Rx_StatModifierInfo_ColdDebuff extends Rx_StatModifierInfo; //Buffs/Debuffs/Special functions

/*Defence for Geeds*/

DefaultProperties
{
	//Buff/Debuff modifiers//
	SpeedModifier 	= -0.015 //*X

	//Weapons
	DamageBoostMod 	= 0.0  //*X
	RateOfFireMod 	= -0.015 //*X 
	ReloadSpeedMod 	= -0.015 //*X

	//Survivablity
	DamageResistanceMod = 0.0 //Corrode 
	RegenerationMod 	= 0.0  //+X

	//Modifier stats
	Mod_Length = 3.0
	ModificationName = "Freezing"
	bEffectStackable = true

	EffectColor		= (R=0.025,G=0.025,B=0.025,A=1.0)
	EffectOpacity	= 0.10
	EffectInflation	= 0.25
	EffectPriority	= 8

	PawnMIC = MaterialInstanceConstant'RenX_AssetBase.Stealth.MI_PowerUp_DamageResistance'
}