class TS_Attachment_XORailgun extends TS_Attachment_ScopedLaser;


DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_Railgun_3P'
        Scale=3.0
    End Object

    LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd

    WeaponClass = class'TS_Weapon_Railgun'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_Railgun_Light_MuzzleFlash'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
//    ImpactLightClass=none
    MuzzleFlashDuration=2.5    

    ShellEjectPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
    
    AimProfileName = Protosuit
    WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'
}
