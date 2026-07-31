class Rx_DmgType_TeslaTank extends Rx_DmgType_Electric;

var ParticleSystem PS_AttachToGib;

var name BoneToAttach;
var ParticleSystem PS_AttachToBody;

static function DoCustomDamageEffects(UTPawn ThePawn, class<UTDamageType> TheDamageType, const out TraceHitInfo HitInfo, vector HitLocation)
{
	local Vector BoneLocation;

	if ( class'UTGame'.static.UseLowGore(ThePawn.WorldInfo) )
	{
		return;
	}
	CreateDeathSkeleton( ThePawn, TheDamageType, HitInfo, HitLocation );
	//CreateDeathGoreChunks( ThePawn, TheDamageType, HitInfo, HitLocation );

	// we just want to spawn the bloody core explosion and not the individual gibs
	if( ThePawn.GetFamilyInfo().default.GibExplosionTemplate != None && ThePawn.EffectIsRelevant(ThePawn.Location, false, 7000) )
	{
		ThePawn.WorldInfo.MyEmitterPool.SpawnEmitter(ThePawn.GetFamilyInfo().default.GibExplosionTemplate, ThePawn.Location, ThePawn.Rotation);
	}

	ThePawn.bGibbed=TRUE; // this makes it so you can't then switch to a "gibbing" weapon and get chunks

	BoneLocation = ThePawn.Mesh.GetBoneLocation( default.BoneToAttach );

	ThePawn.WorldInfo.MyEmitterPool.SpawnEmitter( default.PS_AttachToBody, BoneLocation, Rotator(vect(0,0,1)), ThePawn );
}


/** allows special effects when gibs are spawned via DoCustomDamageEffects() instead of the normal way */
simulated static function SpawnExtraGibEffects(UTGib TheGib)
{
	if ( (TheGib.WorldInfo.GetDetailMode() != DM_Low) && !TheGib.WorldInfo.bDropDetail && FRand() < 0.70f )
	{
		TheGib.PSC_GibEffect = new(TheGib) class'UTParticleSystemComponent';
		TheGib.PSC_GibEffect.SetTemplate(default.PS_AttachToGib);
		TheGib.AttachComponent(TheGib.PSC_GibEffect);
	}
}

defaultproperties
{
    KillStatsName=KILLS_VOLTAUTORIFLE
    DeathStatsName=DEATHS_VOLTAUTORIFLE
    SuicideStatsName=SUICIDES_VOLTAUTORIFLE

    DamageWeaponFireMode=2
    VehicleDamageScaling=1.0 //0.2857142857 //0.4
    NodeDamageScaling=1.0
    VehicleMomentumScaling=0.3

    CustomTauntIndex=10
    lightArmorDmgScaling=1.0 //0.2857142857 //0.4
    AircraftDamageScaling= 1.0 //0.4285714286 //0.6 //Low flying aircraft be damned. 
    BuildingDamageScaling= 1.0 //0.2857142857 //0.4
    MCTDamageScaling=3.0
    MineDamageScaling=1.0

    ////Infantry Armour Types//////
    Inf_FLAKDamageScaling = 1.0  //1.0     //FLAK infantry armour (Standard rule is splash damage does  50% less, while gun damage does 30% more)
    Inf_KevlarDamageScaling = 1.0 //1.0    //Kevlar (General rule is 15% less damage from direct hits/bullets, but no penalties) - EDIT: 20% - EDIT2 : Applied penalty to Kevlar infantry against splash damage, now that there's a NONE armour category
    Inf_LazarusDamageScaling = 1.15 //1.0  // Lazarus SBH armour, standard rule is +40% to Electrical damage but likely no other damage modifiers.
    Inf_NoArmourDamageScaling = 1.0 //Damage modifier for no armour
    
	BleedDamageFactor=0.1
	BleedCount=3
    
    PS_AttachToGib=ParticleSystem'RX_WP_VoltAutoRifle.Effects.P_Gib_Effect'
    DamageCameraAnim=CameraAnim'RX_FX_Munitions2.Camera_FX.C_WP_Link_Beam_Hit' //CameraAnim'Camera_FX.LinkGun.C_WP_Link_Beam_Hit'

    BoneToAttach="b_hip"
    PS_AttachToBody=ParticleSystem'RX_FX_Munitions.Beams.P_CharacterBurn_Electric'

    IconTextureName="T_DeathIcon_TeslaTank"
    IconTexture=Texture2D'APB_VH_SOV_TeslaTank.UI.T_DeathIcon_TeslaTank'
    
    bUnsourcedDamage=false
}