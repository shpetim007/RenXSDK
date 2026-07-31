class TS_DmgType_AutomaticShotgun_AT extends TS_DmgType_Bullet;

defaultproperties
{
    KillStatsName=KILLS_AUTOSHOTGUN
    DeathStatsName=DEATHS_AUTOSHOTGUN
    SuicideStatsName=SUICIDES_AUTOSHOTGUN

//    DamageWeaponClass=class'Rx_Weapon_Shotgun'
    DamageWeaponFireMode=2
    VehicleDamageScaling=0.15f
    NodeDamageScaling=0.5

    CustomTauntIndex=10
    lightArmorDmgScaling=0.25
    BuildingDamageScaling=0.25
	MCTDamageScaling=2.0 //150.0
	MineDamageScaling=2.0

	
	KDamageImpulse=6000
	KDeathUpKick=200

	IconTextureName="T_WeaponIcon_AutoShotgun"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_AutoShotgun'
}