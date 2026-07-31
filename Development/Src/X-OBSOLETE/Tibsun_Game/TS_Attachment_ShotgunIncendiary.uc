class TS_Attachment_ShotgunIncendiary extends TS_WeaponAttachment;

defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'RX_WP_FlakCannon.Mesh.SK_FlakCannon_3P'
//		Translation=(Z=2)
//		Rotation=(Yaw=1000)
		Scale=1.0
	End Object
	
	WeaponClass=class'TS_Weapon_ShotgunIncendiary'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_3P'
	MuzzleFlashPSCTemplate_Nod=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_3P'
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
//	ImpactLightClass=none
	MuzzleFlashDuration=3.3667
	
	ShellEjectPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_ShellCasing'
	ShellEjectDuration = 1.0
	ShellEjectSocket = ShellEjectSocket


	AimProfileName = Shotgun
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Shotgun'

	BulletWhip=SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Standard'
	//BeamTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_InstantHit_Tracer_GDI'
}
