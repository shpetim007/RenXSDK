
class Rx_Vehicle_MammothProjectile_Heroic extends Rx_Vehicle_MammothProjectile;


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
