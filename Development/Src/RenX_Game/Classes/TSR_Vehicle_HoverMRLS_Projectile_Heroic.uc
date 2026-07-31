/*********************************************************
*
* File: TSR_Vehicle_HoverMRLS_Projectile_Heroic.uc
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
class TSR_Vehicle_HoverMRLS_Projectile_Heroic extends TSR_Vehicle_HoverMRLS_Projectile;

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExplosion)
{
    Super.SetExplosionEffectParameters(ProjExplosion);

    ProjExplosion.SetScale(1.5f);
}

DefaultProperties
{
	DrawScale            = 1.40f

	ProjFlightTemplate=ParticleSystem'RX_FX_Munitions.Missile.P_Missile_Heroic' //ParticleSystem'TS_VH_HoverMRLS.Effects.P_Missiles'

}
