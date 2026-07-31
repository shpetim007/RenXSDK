/*********************************************************
*
* File: Rx_Vehicle_Chinook_Weapon_GDI_Left.uc
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
class Rx_Vehicle_Chinook_Weapon_GDI_Left extends Rx_Vehicle_Chinook_Weapon_Left;

DefaultProperties
{
    // gun config
	InstantHitDamageTypes(0)=class'Rx_DmgType_Chinook_GDI'
	InstantHitDamageTypes(1)=class'Rx_DmgType_Chinook_GDI'
	VehicleClass=Class'RenX_Game.Rx_Vehicle_Chinook_GDI'
	
	BeamTemplates[0]=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer_GDI_Large'
}
