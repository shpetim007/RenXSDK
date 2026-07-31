
class Ren_Vehicle_HummVee_Weapon extends Rx_Vehicle_Humvee_Weapon;

DefaultProperties
{
     
    ReloadSound(0)=SoundCue'Ren_VH_GDI_HummVee.Sounds.SC_Reload_Gun'
    ReloadSound(1)=SoundCue'Ren_VH_GDI_HummVee.Sounds.SC_Reload_Gun'
	
    VehicleClass=Class'Ren_Vehicle_HummVee'

	InstantHitDamageTypes(0)=class'Ren_DmgType_HummVee'
	InstantHitDamageTypes(1)=class'Ren_DmgType_HummVee'

	FireInterval(0)=0.125
    FireInterval(1)=0.125

}
