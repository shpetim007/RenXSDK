class TS_Attachment_XOIonCannon extends TS_Attachment_ScopedLaser;

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_3P'
		scale=3.0
    End Object

	
    WeaponClass = class'TS_Weapon_XOIonCannon'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_MuzzleFlash_XOIonCannon_3P'
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_VoltRifle_MuzzleFlash'
    MuzzleFlashDuration=2.5    
    
    AimProfileName = Protosuit
    WeaponAnimSet = AnimSet'TS_CH_GDI_XOPowersuit.Anims.AS_CH_GDI_XOPowersuit'

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Green'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
}
