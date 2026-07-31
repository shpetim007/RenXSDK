class TS_Attachment_PulseCannon extends TS_WeaponAttachment;



DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_IonRifle.Mesh.SK_IonRifle_3P'
        Materials(0)=MaterialInstanceConstant'TS_WP_IonRifle.Materials.MI_PulseCannon'
    End Object

    WeaponClass = class'TS_Weapon_IonRifle'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_IonRifle.Effects.P_PulseCannon_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    MuzzleFlashDuration=2.5    
    
    AimProfileName = AutoRifle
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'
}
