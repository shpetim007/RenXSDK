class TS_Attachment_ToxinRifle extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_SniperRifle.Mesh.SK_WP_SniperRifle_Silenced_3P'
		Scale=1.0
	End Object

    LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

	WeaponClass = class'TS_Weapon_ToxinRifle'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_3P'
    MuzzleFlashPSCTemplate_Nod=ParticleSystem'TS_WP_TacticalRifle.Effects.P_MuzzleFlash_3P'
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=0.1
//	ImpactLightClass=none
	
	ShellEjectPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.P_ShellCasing'
	ShellEjectDuration = 1.0
	ShellEjectSocket = ShellEjectSocket
	
	AimProfileName = AutoRifle
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'
}
