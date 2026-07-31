class Rx_Airstrike_AC130 extends Rx_Airstrike_Vehicle;

simulated function InitialSetup()
{
	super.InitialSetup();

	CreateEvent(0.f, s0);

	// salvo 1
	CreateEvent(5.25f, heavycannon);
	CreateEvent(5.5f, cannon);
	CreateEvent(5.75f, cannon);
	CreateEvent(6.0f, cannon);
	CreateEvent(6.5f, cannon);

	// salvo 2
	CreateEvent(7.5f, heavycannon);

	CreateEvent(7.75f, cannon);
	CreateEvent(8.25f, cannon);
	CreateEvent(8.5f, cannon);
	CreateEvent(8.75f, cannon);

	// salvo 3

	CreateEvent(9.75f, heavycannon);
	CreateEvent(10.f, cannon);
	CreateEvent(10.5f, cannon);
	CreateEvent(11.0f, cannon);
	CreateEvent(12.f, cannon);

	CreateEvent(13.5f, heavycannon);
}

simulated function s0()
{
	AttachAudio(SoundCue'RX_VH_C-130.Sounds.SC_C-130_Airstrike', 'AC130_Base');
	AttachParticleEffect(ParticleSystem'RX_VH_C-130.Effects.P_AC-130_WingTip_Large', 'AC130_Base');
}

simulated function bothcannons()
{
	AttachAudio(SoundCue'RX_VH_C-130.Sounds.SC_AutoCannon_Fire', 'AutoCannonSocket');
	AttachParticleEffect(ParticleSystem'RX_VH_C-130.Effects.P_MuzzleFlash_AutoCannon', 'AutoCannonSocket');
	InitiateProjectile(class'RenX_Game.Rx_Vehicle_AC130_AutoCannon', 'AutoCannonSocket', 'HitLocation');
	InitiateProjectile(class'RenX_Game.Rx_Vehicle_AC130_HeavyCannon', 'HeavyCannonSocket', 'HitLocation');
}

simulated function cannon()
{
	AttachAudio(SoundCue'RX_VH_C-130.Sounds.SC_AutoCannon_Fire', 'AutoCannonSocket');
	AttachParticleEffect(ParticleSystem'RX_VH_C-130.Effects.P_MuzzleFlash_AutoCannon', 'AutoCannonSocket');
	InitiateProjectile(class'RenX_Game.Rx_Vehicle_AC130_AutoCannon', 'AutoCannonSocket', 'HitLocation');
}

simulated function heavycannon()
{
	AttachAudio(SoundCue'RX_VH_C-130.Sounds.SC_HeavyCannon_Fire', 'HeavyCannonSocket');
	AttachParticleEffect(ParticleSystem'RX_VH_C-130.Effects.P_MuzzleFlash_HeavyCannon', 'HeavyCannonSocket');
	InitiateProjectile(class'RenX_Game.Rx_Vehicle_AC130_HeavyCannon', 'HeavyCannonSocket', 'HitLocation');
}

DefaultProperties
{
	Begin Object Name=WSkeletalMesh
		SkeletalMesh=SkeletalMesh'RX_VH_C-130.Mesh.SK_VH_AC-130_Airstrike'
		PhysicsAsset=PhysicsAsset'RX_VH_C-130.Mesh.SK_VH_AC-130_Airstrike_Physics'
		AnimSets(0)=AnimSet'RX_VH_C-130.Anim.AS_AC130_Airstrike'
		AnimTreeTemplate=AnimTree'RX_VH_C-130.Anim.AT_AC130_Airstrike'
	End Object

	LifeSpan=25.f

	ProjectileDirectionSpreadMulti=500.f
	ApproachingSound=SoundCue'RX_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_AirStrikeEnRoute_Cue'

	TeamNum = 1
	MinimapIconTexture=Texture2D'RenxHUD.T_Airstrike_AC130'
}
