class TS_Attachment_ParticleIonCannon extends TS_WeaponAttachment;




var ParticleSystem BeamTemplate;
var class<UDKExplosionLight> ImpactLightClass;

var int CurrentPath;



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

    E = WorldInfo.MyEmitterPool.SpawnEmitter(BeamTemplate, Start);
    E.SetVectorParameter('BeamEnd', End);
    if (bFirstPerson && !class'Engine'.static.IsSplitScreen())
    {
        E.SetDepthPriorityGroup(SDPG_Foreground);
    }
    else
    {
        E.SetDepthPriorityGroup(SDPG_World);
    }
}

simulated function FirstPersonFireEffects(Weapon PawnWeapon, vector HitLocation)
{
    local vector EffectLocation;

    Super.FirstPersonFireEffects(PawnWeapon, HitLocation);

    if (Instigator.FiringMode == 0 || Instigator.FiringMode == 3)
    {
        EffectLocation = UTWeapon(PawnWeapon).GetEffectLocation();
        SpawnBeam(EffectLocation, HitLocation, true);

        if (ImpactLightClass != None && !WorldInfo.bDropDetail && Instigator.Controller != None)
        {
            UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ImpactLightClass, HitLocation);
        }
    }
}

simulated function ThirdPersonFireEffects(vector HitLocation)
{

    Super.ThirdPersonFireEffects(HitLocation);

    if ((Instigator.FiringMode == 0 || Instigator.FiringMode == 3))
    {
        SpawnBeam(GetEffectLocation(), HitLocation, false);
    }
}




DefaultProperties
{
    Begin Object Name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'TS_WP_ParticleCannon.Meshes.SK_ParticleCannon_3P'
        Scale=1.0
    End Object

    WeaponClass = class'TS_Weapon_ParticleIonCannon'
    MuzzleFlashSocket=MuzzleFlashSocket
    MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_PIC_MuzzleFlash_3P'
    MuzzleFlashLightClass=class'TS_Light_Bullet_GaussRifle'
    MuzzleFlashDuration=2.5    
    
    AimProfileName = RocketLauncher
    WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_RocketLauncher'



    DefaultImpactEffect=(ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')

    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')
    ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_ParticleCannon_Impact',Sound=SoundCue'TS_WP_IonRifle.Sounds.SC_IonRifle_Impact')

    
    BulletWhip=SoundCue'TS_WP_LaserRifle.Sounds.SC_LaserRifle_WizzBy'
    BeamTemplate=ParticleSystem'TS_WP_ParticleCannon.Effects.P_InstantHit_IonBeam_Large'
    ImpactLightClass = class'TS_Light_Bullet_GaussRifle'
}
