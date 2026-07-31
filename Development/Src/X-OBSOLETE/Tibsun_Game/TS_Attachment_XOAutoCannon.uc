class TS_Attachment_XOAutoCannon extends TS_Attachment_ScopedLaser;

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_GaussRifle.Mesh.SK_GaussRifle_3P'
        Scale=3.0
    End Object

	/*BeamTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_InstantHit_GaussRifle'
    BeamTemplate_Heroic=ParticleSystem'TS_WP_GaussRifle.Effects.P_InstantHit_GaussRifle'*/

    LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
	
    WeaponClass = class'TS_Weapon_GaussRifle'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_XOGaussAutoCannon_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
    MuzzleFlashDuration=0.1

    ShellEjectPSCTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_XOGaussAutoCannon_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
    
    AimProfileName = Protosuit
    WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'
}
