class TS_Attachment_XOVulcanCannon extends TS_WeaponAttachment_HitscanBeam;

simulated function ThirdPersonFireEffects(vector HitLocation)
{
    Mesh.PlayAnim('WeaponFireIdle', 0.3, true, false,,false);
    
    Super.ThirdPersonFireEffects(HitLocation);
}

simulated event StopThirdPersonFireEffects()
{
    Mesh.PlayAnim('WeaponFireStop', 1, false, true,,false);
    
    super.StopThirdPersonFireEffects();
}

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgVulcanCannon.Mesh.SK_WP_CyborgVulcan_3P'
        AnimSets(0)=AnimSet'TS_WP_CyborgVulcanCannon.Anims.AS_CyborgVulcan_3P'
        Materials(0)=MaterialInstanceConstant'TS_VH_Wolverine_HD.Materials.MI_Vulcan_1P'
        Scale=2.0
    End Object

    WeaponClass = class'TS_Weapon_XOVulcanCannon'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_CH_GDI_XOPowersuit.Effects.P_MuzzleFlash_MG'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    MuzzleFlashDuration=0.1

	AimProfileName = Protosuit
    WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'

    ShellEjectPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket

    BulletWhip=SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Standard'
    BeamTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_InstantHit_TracerHeavy_GDI'
    BeamTemplate_Nod=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_InstantHit_Tracer_Nod'
}
