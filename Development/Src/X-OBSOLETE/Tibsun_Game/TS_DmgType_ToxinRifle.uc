class TS_DmgType_ToxinRifle extends TS_DmgType_Tiberium;

defaultproperties
{
    KillStatsName=KILLS_TOXINRIFLE
    DeathStatsName=DEATHS_TOXINRIFLE
    SuicideStatsName=SUICIDES_TOXINRIFLE

    // DamageWeaponClass=class'RxWeapon_AutoRifle' // need to set this if we want to have weapon killicons
    DamageWeaponFireMode=2
    NodeDamageScaling=0.5
 
    CustomTauntIndex=10

	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 0.2     // Heavy Armour
	Inf_KevlarDamageScaling = 0.65	// Medium Armour
	Inf_LazarusDamageScaling = 1.0  // Unused
	Inf_NoArmourDamageScaling = 1.0 // Light Armour

	////Building and Misc Types//////
	BuildingDamageScaling=0.0
	MCTDamageScaling=10.0	
	MineDamageScaling=2.0

	////Vehicle Armour Types//////
	lightArmorDmgScaling=0.2
	VehicleDamageScaling=0.01
	AircraftDamageScaling=0.05
	
    bPiercesArmor=false

    BleedType=class'TS_DmgType_TiberiumBleed_Grenade'	
    
	BleedDamageFactor=0.033333
	BleedCount=5
	
	KDamageImpulse=100
	KDeathUpKick=50
	
	DeathAnim=H_M_Death_CrotchShot
	DeathAnimRate=2.5
	bAnimateHipsForDeathAnim=FALSE
	MotorDecayTime=1.0

	IconTextureName="T_WeaponIcon_SniperRifle"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_SniperRifle'
	
}