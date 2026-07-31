class TS_Attachment_Railgun extends TS_WeaponAttachment;

var ParticleSystem AltBeamTemplate;
var ParticleSystemComponent ChargeComponent;

var int CurrentPath;

simulated function AttachTo(UTPawn OwnerPawn)
{
    if (OwnerPawn.Mesh != None)
    {
        if (Mesh != None && MuzzleFlashSocket != '')
        {
            Mesh.AttachComponentToSocket(ChargeComponent, MuzzleFlashSocket);
        }
    }
    Super.AttachTo(OwnerPawn);
}

simulated function StartCharging()
{
    ChargeComponent.ActivateSystem();
}

simulated event StopThirdPersonFireEffects()
{
    ChargeComponent.DeactivateSystem();
    ChargeComponent.KillParticlesForced();
    Super.StopThirdPersonFireEffects();
}

simulated function ThirdPersonFireEffects(vector HitLocation)
{
    Super.ThirdPersonFireEffects(HitLocation);

    ChargeComponent.DeactivateSystem();
    ChargeComponent.KillParticlesForced();
    FireModeUpdated(0,false); // force bio back to 'base' state
}

DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_Railgun_Light.Mesh.SK_WP_Railgun_3P'
        Scale=1.0
    End Object

    WeaponClass = class'TS_Weapon_Railgun'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_Railgun.Effects.P_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'TS_Light_Disruptor_MuzzleFlash'
//    ImpactLightClass=none
    MuzzleFlashDuration=2.5    

    ShellEjectPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_ShellCasing'
    ShellEjectDuration = 1.0
    ShellEjectSocket = ShellEjectSocket
    
    AimProfileName = AutoRifle
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'

    Begin Object Class=ParticleSystemComponent Name=AltChargeEffect
        Template=ParticleSystem'RX_WP_VoltAutoRifle.Effects.P_VoltBolt_Blue'
        Scale=0.25
        bAutoActivate=false
        SecondsBeforeInactive=1.0f
    End Object
    ChargeComponent = AltChargeEffect
}
