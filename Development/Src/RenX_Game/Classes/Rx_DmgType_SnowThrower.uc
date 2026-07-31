class Rx_DmgType_SnowThrower extends Rx_DmgType_ChemicalThrower;

static function SpawnHitEffect(Pawn P, float Damage, vector Momentum, name BoneName, vector HitLocation)
{
	local Rx_Emit_SnowDmg BF;
	local UTPawn UTP;

	UTP = UTPawn(P);
	if (UTP != None && !UTP.bGibbed) 
	{
		BF = P.Spawn(class'Rx_Emit_SnowDmg',P,, P.Location, rotator(Momentum));
		BF.AttachTo(P, BoneName);
		BF.LifeSpan = GetHitEffectDuration(P, Damage);
	}
}

DefaultProperties
{
	HitColour = (R = 0.0, G = 0.0, B = 0.75, A = 1.0)
	BleedType=class'Rx_DmgType_SnowThrowerBleed'
	PS_AttachToBody=ParticleSystem'RX_WP_ChemicalThrower.Effects.P_SnowCloud_Poison'
	PS_AttachToGib=ParticleSystem'RX_WP_ChemicalThrower.Effects.P_SnowCloud_Poison'
}