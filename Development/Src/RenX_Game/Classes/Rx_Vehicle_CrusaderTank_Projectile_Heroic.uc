/*********************************************************
*
* File: Rx_Vehicle_CrusaderTank_Projectile_Heroic.uc
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
class Rx_Vehicle_CrusaderTank_Projectile_Heroic extends Rx_Vehicle_CrusaderTank_Projectile;


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.5f);
}



DefaultProperties
{
	
	ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.shells.P_Shell_Heroic'
}
