class TS_Attachment_CYReaper_ShredderCannon extends TS_Attachment_ScopedLaser;


DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgVulcanCannon.Mesh.SK_WP_CyborgVulcan_3P'
        AnimSets(0)=AnimSet'TS_WP_CyborgVulcanCannon.Anims.AS_CyborgVulcan_3P'
        scale=3.0
    End Object
	
	LaserBeamTemplate = ParticleSystem'TS_FX_Munitions.Particles.Beams.P_Sniper_Laser_Red'
    BeamSocket = MuzzleFlashSocket
    EndPointParamName=BeamEnd
    
    WeaponClass = class'TS_Weapon_CyborgMinigun'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_VH_Buggy_HD.Effects.P_MuzzleFlash_Cannon'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    MuzzleFlashDuration=0.1
   
	AimProfileName = CYReaper
    WeaponAnimSet = AnimSet'TS_CH_Nod_CyborgReaper.Anims.AS_CH_Nod_CyborgReaper'

    ShellEjectPSCTemplate=ParticleSystem'TS_WP_Railgun_Light.Effects.P_XORailHMG_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
}
