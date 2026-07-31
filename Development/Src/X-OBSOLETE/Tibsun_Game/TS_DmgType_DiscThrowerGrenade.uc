class TS_DmgType_DiscThrowerGrenade extends TS_DmgType_Explosive;

defaultproperties
{
    KillStatsName=KILLS_GRENADELAUNCHER
    DeathStatsName=DEATHS_GRENADELAUNCHER
    SuicideStatsName=SUICIDES_GRENADELAUNCHER

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 0.5     // Heavy Armour
    Inf_KevlarDamageScaling = 0.75   // Medium Armour
    Inf_LazarusDamageScaling = 1.0  // Unused
    Inf_NoArmourDamageScaling = 1.0 // Light Armour

    //DamageWeaponClass=class'Rx_Weapon_GrenadeLauncher'
    DamageWeaponFireMode=0

    VehicleDamageScaling=0.5
    NodeDamageScaling=1.0
    bThrowRagdoll=true
    CustomTauntIndex=7
    lightArmorDmgScaling=0.5
    BuildingDamageScaling=0.0125
	MCTDamageScaling=0.025
	MineDamageScaling=2.5
	
	
    AlwaysGibDamageThreshold=99
    bNeverGibs=false
	
	KDamageImpulse=10000
	KDeathUpKick=2000

	IconTextureName="T_WeaponIcon_NapalmLauncher"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_NapalmLauncher'
}