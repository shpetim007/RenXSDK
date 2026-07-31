class GEN_DmgType_ToxinBleed  extends Rx_DmgType_TiberiumBleed;

DefaultProperties
{
	bCausesBleed=false
	
	DamageBodyMatColor=(R=0,G=0, B=50)
	DamageOverlayTime=0.3
	DeathOverlayTime=0.6
	bUseTearOffMomentum=false
	bCausedByWorld=false

	bUseDamageBasedDeathEffects=true

	PS_AttachToGib=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_BlueTibDamage'
	PS_AttachToBody=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_BlueTibDamage'

	IconTextureName="DeathIcon_Scorpion"
	IconTexture=Texture2D'Gen_VH_ScorpionTank.Textures.DeathIcon_Scorpion'
}
