class TS_Attachment_RamjetRifle extends TS_Attachment_ScopedLaser;


DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'RX_WP_Ramjet.Mesh.SK_WP_Ramjet_3P'
        Materials(0)=MaterialInstanceConstant'RX_WP_Ramjet.Materials.MI_WP_Ramjet_Black'
        Materials(1)=MaterialInstanceConstant'RX_WP_Ramjet.Materials.MI_WP_Ramjet_Black_Lens'
        Scale=1.0
    End Object

    LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser'
    BeamSocket = MuzzleFlashSocket

    WeaponClass = class'TS_Weapon_RamjetRifle'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_Ramjet.Effects.P_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    MuzzleFlashDuration=0.1
    
    ShellEjectPSCTemplate=ParticleSystem'RX_WP_Ramjet.Effects.P_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
    
    AimProfileName = AutoRifle
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'

    EndPointParamName=BeamEnd
}
