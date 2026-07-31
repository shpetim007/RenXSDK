class TS_Attachment_SonicResonator extends TS_WeaponAttachment;

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_3P'
        //AnimSets(0)=AnimSet'RX_WP_ChainGun.Anims.AS_ChainGun_3P'
    End Object

    WeaponClass = class'TS_Weapon_SonicResonator'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_SonicResonator.Effects.P_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
    MuzzleFlashDuration=2.5    
    
    AimProfileName = RocketLauncher
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_RocketLauncher'
}

