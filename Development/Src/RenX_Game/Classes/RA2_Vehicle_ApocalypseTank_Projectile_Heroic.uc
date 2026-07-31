/*********************************************************
*
* File: RA2_Vehicle_ApocalypseTank_Projectile_Heroic.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class RA2_Vehicle_ApocalypseTank_Projectile_Heroic extends RA2_Vehicle_ApocalypseTank_Projectile;


simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.75f);
}



DefaultProperties
{

	DrawScale = 1.25

	ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.shells.P_Shell_Heroic'
	
   
}
