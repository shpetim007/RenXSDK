class Rx_Attachment_LaserChristmasGun extends Rx_WeaponAttachment_Varying;

//var ParticleSystem BeamTemplate;
var class<UDKExplosionLight> ImpactLightClass;
var Array<ParticleSystem> BeamTemplates;
var Array<ParticleSystem> MuzzleFlashTemplates;

var int CurrentPath, ShotNumber;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
    
    BeamTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_Beam');
    BeamTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserRifle_Beam_Blue');
    BeamTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_Beam_Orange');
    BeamTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_Beam_Green');
    BeamTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_Beam_Yellow');

    MuzzleFlashTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P');
    MuzzleFlashTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P_Blue');
    MuzzleFlashTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P_Orange');
    MuzzleFlashTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P_Green');
    MuzzleFlashTemplates.AddItem(ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P_Yellow');
}

simulated function SpawnBeam(vector Start, vector End, bool bFirstPerson)
{
    local ParticleSystemComponent E;
    local actor HitActor;
    local vector HitNormal, HitLocation;

    if ( End == Vect(0,0,0) )
    {
        if ( !bFirstPerson || (Instigator.Controller == None) )
        {
            return;
        }
        // guess using current viewrotation;
        End = Start + vector(Instigator.Controller.Rotation) * WeaponClass.default.WeaponRange;
        HitActor = Instigator.Trace(HitLocation, HitNormal, End, Start, TRUE, vect(0,0,0),, TRACEFLAG_Bullet);
        if ( HitActor != None )
        {
            End = HitLocation;
        }
    }
    
    E = WorldInfo.MyEmitterPool.SpawnEmitter(BeamTemplates[ShotNumber], Start);
    E.SetVectorParameter('BeamEnd', End);
	/** one1: changed foreground rendering to world rendering for beam */
    //if (bFirstPerson && !class'Engine'.static.IsSplitScreen())
    //{
    //    E.SetDepthPriorityGroup(SDPG_Foreground);
    //}
    //else
    //{
        E.SetDepthPriorityGroup(SDPG_World);
    //}
    MuzzleFlashPSCTemplate = MuzzleFlashTemplates[ShotNumber];
    MuzzleFlashPSCTemplate_Heroic = MuzzleFlashTemplates[ShotNumber];
    BeamTemplate_Heroic = BeamTemplates[ShotNumber];

    ShotNumber += 1;
    if(ShotNumber >= BeamTemplates.Length)
        ShotNumber = 0;
}

simulated function FirstPersonFireEffects(Weapon PawnWeapon, vector HitLocation)
{
    local vector EffectLocation;
    
    Mesh.PlayAnim('WeaponFireIdle', 0.3, true, false,,false);

    if (Instigator.FiringMode == 0 || Instigator.FiringMode == 3)
    {
        EffectLocation = UTWeapon(PawnWeapon).GetEffectLocation();
        SpawnBeam(EffectLocation, HitLocation, true);

        if (!WorldInfo.bDropDetail && Instigator.Controller != None && ImpactLightClass != None)
        {
            UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ImpactLightClass, HitLocation);
        }
    }
    
    Super.FirstPersonFireEffects(PawnWeapon, HitLocation);
}

simulated function ThirdPersonFireEffects(vector HitLocation)
{
    Mesh.PlayAnim('WeaponFireIdle', 0.3, true, false,,false);
	
    if ((Instigator.FiringMode == 0 || Instigator.FiringMode == 3))
    {
        SpawnBeam(GetEffectLocation(), HitLocation, false);
    }

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
        SkeletalMesh=SkeletalMesh'RX_WP_LaserChaingun.Meshes.SK_WP_LaserChaingun_3P'
		AnimSets(0)=AnimSet'RX_WP_ChainGun.Anims.AS_ChainGun_3P'
    End Object
    
    DefaultImpactEffect=(ParticleTemplate=ParticleSystem'RX_WP_LaserRifle.Effects.P_Laser_Impact',Sound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Impact')
    DefaultImpactEffect_Heroic=(ParticleTemplate=ParticleSystem'RX_WP_LaserRifle.Effects.P_Laser_Impact_Blue',Sound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Impact')

	DefaultAltImpactEffect=(ParticleTemplate=ParticleSystem'RX_WP_LaserRifle.Effects.P_Laser_Impact',Sound=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_Impact')

    BulletWhip=SoundCue'RX_WP_LaserRifle.Sounds.SC_LaserRifle_WizzBy'
    BeamTemplate=ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_Beam'

    ShotNumber = 0

    WeaponClass = class'Rx_Weapon_LaserChainGun'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
    ImpactLightClass=none
    MuzzleFlashDuration=2.5    
    
    AimProfileName = RocketLauncher
    WeaponAnimSet = AnimSet'RX_CH_Animations.Anims_Updated.AS_WeapProfile_RocketLauncher'
	
	BeamTemplate_Heroic	= ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserRifle_Beam_Blue'
	MuzzleFlashPSCTemplate_Heroic= ParticleSystem'RX_WP_LaserChaingun.Effects.P_LaserChainGun_MuzzleFlash_3P_Blue'
	MuzzleFlashLightClass_Heroic=class'Rx_Light_Blue_MuzzleFlash'
}
