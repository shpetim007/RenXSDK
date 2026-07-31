class TS_Attachment_CYReaper_PlasmaCannon extends TS_Attachment_ScopedLaser;


DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgPlasmaCannon.Mesh.SK_CyborgPlasmaCannon_3P'
        scale=3.5
    End Object

    WeaponClass = class'TS_Weapon_CYReaper_PlasmaCannon'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_PlasmaCannon.Effects.P_MuzzleFlash'
    MuzzleFlashLightClass=class'TibSun_Game.TS_Light_PlasmaRifle_MuzzleFlash'
    MuzzleFlashDuration=2.5   

	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Red'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
	
	AimProfileName = CYReaper
    WeaponAnimSet = AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper'

}
