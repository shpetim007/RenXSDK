class TS_Attachment_SMG_Silenced extends TS_Attachment_SMG;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_SMG.Mesh.SK_WP_SMG_Silencer_3P'
	End Object

//	BeamTemplate=ParticleSystem'RX_FX_Munitions.Beams.P_InstantHit_Tracer'

	WeaponClass = class'TS_Weapon_SMG_Silenced'

	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_3P'
    MuzzleFlashPSCTemplate_Nod=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_3P'
}
