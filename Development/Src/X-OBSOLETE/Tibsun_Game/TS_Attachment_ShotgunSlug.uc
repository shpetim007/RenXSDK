class TS_Attachment_ShotgunSlug extends TS_WeaponAttachment;


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



defaultproperties
{
	// Weapon SkeletalMesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'RX_WP_Shotgun.Mesh.WP_RenX_Shotgun_3P'
		Scale=1.0
	End Object
	
	WeaponClass=class'TS_Weapon_ShotgunSlug'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_3P'
	MuzzleFlashPSCTemplate_Nod=ParticleSystem'TS_WP_AutoRifle.Effects.P_MuzzleFlash_3P'
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'
//	ImpactLightClass=none
	MuzzleFlashDuration=3.3667
	
	ShellEjectPSCTemplate=ParticleSystem'TS_WP_AutoRifle.Effects.P_ShellCasing'
	ShellEjectDuration = 1.0
	ShellEjectSocket = ShellEjectSocket
	
//	AimProfileName = AutoRifle
//	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Autorifle'

	AimProfileName = Shotgun
	WeaponAnimSet = AnimSet'TS_CH_Animations.Anims.AS_WeapProfile_Shotgun'

	BulletWhip=SoundCue'TS_SoundEffects.Bullet_WhizBy.SC_BulletWhiz_Standard'
	BeamTemplate=ParticleSystem'TS_FX_Munitions.Particles.Tracers.P_InstantHit_Tracer_GDI'
}
