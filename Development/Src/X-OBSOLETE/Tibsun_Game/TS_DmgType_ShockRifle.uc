class TS_DmgType_ShockRifle extends TS_DmgType_Electric;

defaultproperties
{
    KillStatsName=KILLS_TiberiumFlechetteRifle
    DeathStatsName=DEATHS_TiberiumFlechetteRifle
    SuicideStatsName=SUICIDES_TiberiumFlechetteRifle

    DamageWeaponFireMode=2
    VehicleDamageScaling=0.05
    NodeDamageScaling=0.5
    VehicleMomentumScaling=0.1

    CustomTauntIndex=10
    lightArmorDmgScaling=0.1
    BuildingDamageScaling=0.1
	MCTDamageScaling=1.0
    
	////Infantry Armour Types//////
	Inf_FLAKDamageScaling = 1.3     //FLAK infantry armour (Standard rule is splash damage does  30% less, while gun damage does 30% more)
	Inf_KevlarDamageScaling = 1.3	//Kevlar (General rule is 25% less damage from direct hits/bullets, but no penalties) - EDIT: 20%
	Inf_LazarusDamageScaling = 1.3  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
	
    bPiercesArmor=false
	
	BleedDamageFactor=0.2
	BleedCount=9
	
	KDamageImpulse=100
	KDeathUpKick=50
	
	DeathAnim=H_M_Death_CrotchShot
	DeathAnimRate=2.5
	bAnimateHipsForDeathAnim=FALSE
	MotorDecayTime=1.0

	IconTextureName="RenXHud_I112"
	IconTexture=Texture2D'RX_WP_TiberiumFlechetteRifle.UI.T_WeaponIcon_TiberiumFlechetteRifle'
	
}