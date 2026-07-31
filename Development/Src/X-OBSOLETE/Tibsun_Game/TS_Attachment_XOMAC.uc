class TS_Attachment_XOMAC extends TS_Attachment_ScopedLaser;

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_Railgun_3P'
        Scale=3.0
    End Object

	/*BeamTemplate=ParticleSystem'TS_WP_GaussRifle.Effects.P_InstantHit_GaussRifle'
    BeamTemplate_Heroic=ParticleSystem'TS_WP_GaussRifle.Effects.P_InstantHit_GaussRifle'*/

    LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
	
    WeaponClass = class'TS_Weapon_XOMAC'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun.Effects.P_MuzzleFlash_XOMAC_3P'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
    MuzzleFlashDuration=4

    ShellEjectPSCTemplate=ParticleSystem'TS_VH_Titan_HD.Effects.P_ShellCasing_Railgun'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
    
    AimProfileName = Protosuit
    WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'
}
