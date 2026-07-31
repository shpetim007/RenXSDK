/*********************************************************
*
* File: Rx_Vehicle_APC_Nod_Weapon.uc
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
class S_Vehicle_APC_Weapon extends Rx_Vehicle_APC_Nod_Weapon;

DefaultProperties
{
	BeamTemplates[0]=ParticleSystem'S_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Large'
	BeamTemplates_Heroic[0]= ParticleSystem'S_FX_Munitions.Beams.P_InstantHit_Tracer_Nod_Large_Heroic'
}
