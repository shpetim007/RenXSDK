/*********************************************************
*
* File: Rx_Vehicle_Chinook_Weapon_Nod_Right.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_Chinook_Weapon_Nod_Right extends Rx_Vehicle_Chinook_Weapon_Right;

DefaultProperties
{
    // gun config
    InstantHitDamageTypes(0)=class'Rx_DmgType_Chinook_GDI'
	InstantHitDamageTypes(1)=class'Rx_DmgType_Chinook_GDI'
	VehicleClass=Class'RenX_Game.Rx_Vehicle_Chinook_Nod'
	BeamTemplates[0]=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Large'
}
