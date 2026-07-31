class TS_Attachment_MissileLauncher extends TS_Attachment_ScopedLaser;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'TS_WP_MissileLauncher.Mesh.SK_MissileLauncher_3P'
		//Translation=(Y=-3,Z=0)
		//Rotation=(Roll=-1000,Pitch=6000,Yaw=-1000)
		Scale=1.0
	End Object

	WeaponClass = class'TS_Weapon_MissileLauncher'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_MissileLauncher.Effects.P_MuzzleFlash'
	MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
	MuzzleFlashDuration=2.5
	
	AimProfileName = Autorifle
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'

	EndPointParamName=BeamEnd
	BeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser'
	BeamSocket = MuzzleFlashSocket
}
