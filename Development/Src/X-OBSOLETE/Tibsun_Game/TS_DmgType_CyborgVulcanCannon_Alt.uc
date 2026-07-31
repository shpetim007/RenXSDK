class TS_DmgType_CyborgVulcanCannon_Alt extends TS_DmgType_Bullet;

defaultproperties
{
    KillStatsName=KILLS_CYBORGVULCANCANNON
    DeathStatsName=DEATHS_CYBORGVULCANCANNON
    SuicideStatsName=SUICIDES_CYBORGVULCANCANNON

//  DamageWeaponClass=class'Rx_Weapon_LaserRifle'
    DamageWeaponFireMode=2
    NodeDamageScaling=0.5

    CustomTauntIndex=10
	
	
    lightArmorDmgScaling=0.1 //0.1875
	VehicleDamageScaling=0.05 //0.21875 //0.25 //0.1875
	AircraftDamageScaling=0.15 //This is only used by a damage type if the value is greater than 0, otherwise it treats an aircraft like Light armour
	BuildingDamageScaling=0.01
	MCTDamageScaling=5.0
	
	MineDamageScaling=2.0
	
	IconTextureName="T_WeaponIcon_CyborgVulcan"
	IconTexture=Texture2D'TSHUD.WeaponIcons.T_WeaponIcon_CyborgVulcan'
}