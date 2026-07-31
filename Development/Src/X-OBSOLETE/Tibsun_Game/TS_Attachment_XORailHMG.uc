class TS_Attachment_XORailHMG extends TS_Attachment_ScopedLaser;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_LightRailgun_3P'
		Scale=3.0
	End Object

	WeaponClass = class'TS_Weapon_MachineGun'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_XORailHMG_MuzzleFlash_3P'
	MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
	MuzzleFlashDuration=2.0

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
   
	AimProfileName = Protosuit
	WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'

	ShellEjectPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_XORailHMG_ShellCasing'
	ShellEjectDuration = 1.0
	ShellEjectSocket = ShellEjectSocket
}
