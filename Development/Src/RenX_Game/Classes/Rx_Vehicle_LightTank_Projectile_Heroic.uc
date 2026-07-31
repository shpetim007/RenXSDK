/*********************************************************
*
* File: Rx_Vehicle_LightProjectile.uc
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
class Rx_Vehicle_LightTank_Projectile_Heroic extends Rx_Vehicle_LightTank_Projectile;


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.25f);
}


DefaultProperties
{
	AmbientSound=SoundCue'RX_SoundEffects.Cannons.SC_Cannon_FlyBy'

	ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.shells.P_Shell_Heroic'
	
	
	
}
