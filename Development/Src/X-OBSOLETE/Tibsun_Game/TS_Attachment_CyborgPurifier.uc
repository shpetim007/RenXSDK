class TS_Attachment_CyborgPurifier extends TS_WeaponAttachment;


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
        SkeletalMesh=SkeletalMesh'TS_WP_CyborgPlasmaCannon.Mesh.SK_CyborgPlasmaCannon_3P'
        AnimSets(0)=AnimSet'TS_WP_CyborgVulcanCannon.Anims.AS_CyborgVulcan_3P'
    End Object

    WeaponClass = class'TS_Weapon_CyborgPurifier'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=none
    MuzzleFlashLightClass=class'RenX_Game.Rx_Light_VoltRifle_MuzzleFlash'
    MuzzleFlashDuration=2.5    

    AimProfileName = Cyborg
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Cyborg'
}
