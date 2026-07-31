/*********************************************************
*
* File: RA2_Vehicle_TeslaTank_Weapon.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class RA2_Vehicle_TeslaTank_Weapon extends Rx_Vehicle_Weapon_Reloadable;

simulated function ProcessInstantHit( byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local bool bFixMomentum;
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	//We need all of this, as calling super doesn't account for veterancy.
	local int TotalDamage;
	
	
	//`log("Process Instant Hit");
	
	if(WorldInfo.NetMode != NM_DedicatedServer && TryHeadshot(FiringMode, Impact)) { // cause Headshotsphere detection is done clientside and then send as a ServerALHeadshotHit()
	//`log("Returned"); 	
	return;
	}

	if ( Impact.HitActor != None )
	{
		if ( Impact.HitActor.bWorldGeometry )
		{
			HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
			if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
			{
				NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
				if ( NewKActor != None )
				{
					Impact.HitActor = NewKActor;
				}
			}
		}
		if ( (Rx_Building(Impact.HitActor) != None || !Impact.HitActor.bStatic) && (Impact.HitActor != Instigator) )
		{
			if ( Impact.HitActor.Role == ROLE_Authority && Impact.HitActor.bProjTarget
				&& !WorldInfo.GRI.OnSameTeam(Instigator, Impact.HitActor)
				&& Impact.HitActor.Instigator != Instigator
				&& PhysicsVolume(Impact.HitActor) == None )
			{
				HitEnemy++;
				LastHitEnemyTime = WorldInfo.TimeSeconds;
			}
			if ( (UTPawn(Impact.HitActor) == None) && (InstantHitMomentum[FiringMode] == 0) )
			{
				InstantHitMomentum[FiringMode] = 1;
				bFixMomentum = true;
			}
			//Super(UDKWeapon).ProcessInstantHit(FiringMode, Impact, NumHits);
			
			//Copied from SUPER(Weapon) Adjusted to include Veterancy multipliers
			if (Impact.HitActor != None)
		{
		// default damage model is just hits * base damage
		NumHits = Max(NumHits, 1);
		TotalDamage = InstantHitDamage[CurrentFireMode] * GetDamageModifier() * NumHits;

		if ( Impact.HitActor.bWorldGeometry )
		{
			HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
			if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
			{
				NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
				if ( NewKActor != None )
				{
					Impact.HitActor = NewKActor;
				}
			}
		}
		Impact.HitActor.TakeDamage( TotalDamage, Instigator.Controller,
						Impact.HitLocation, InstantHitMomentum[FiringMode] * Impact.RayDir,
						InstantHitDamageTypes[FiringMode], Impact.HitInfo, self );
			
			if(ROLE == ROLE_Authority && RA2_Vehicle_TeslaTank(MyVehicle) != none)
				RA2_Vehicle_TeslaTank(MyVehicle).ProcessLightningChains(TotalDamage, InstantHitDamageTypes[FiringMode],Instigator.Controller, Impact.HitActor); 
		}
			
			
			if (bFixMomentum)
			{
				InstantHitMomentum[FiringMode] = 0;
			}
		}
	}

}

DefaultProperties
{
    InventoryGroup=14
    
    // reload config
    ClipSize(0) = 2
    InitalNumClips = 999
    MaxClips = 999
     
    ShotCost(0)=1
    ShotCost(1)=1

	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT

	VetRankInfo(0)= (DamageModifier = (1.0, 1.0), ROFModifier = (1.0,1.0), BuildingDamageMod = (1.0,1.0), InfantryDamageMod = (1.0,1.0), RangeModifier = (1.0,1.0), ClipSizeMod = (0, 0), ReloadSpeedmod = (1.0, 1.0))
	VetRankInfo(1)= (DamageModifier = (1.025,1.025), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.99, 0.99))
	VetRankInfo(2)= (DamageModifier = (1.05,1.05), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.975, 0.975))

	//Veterans
	VetRankInfo(3)= (DamageModifier = (1.10, 1.10) , ClipSizeMod = (0, 0), ReloadSpeedmod = (0.95, 0.95))
	VetRankInfo(4)= (DamageModifier = (1.125, 1.125), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.94, 0.94))
	VetRankInfo(5)= (DamageModifier = (1.15,1.15 ), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.925, 0.925))

	//ELITE
	VetRankInfo(6)= (DamageModifier = (1.25, 1.25), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.90, 0.90))
	VetRankInfo(7)= (DamageModifier = (1.30, 1.30), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.89, 0.89))
	VetRankInfo(8)= (DamageModifier = (1.35, 1.35), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.875, 0.875))

	//HEROIC
	VetRankInfo(9)= (DamageModifier = (1.50, 1.50), ClipSizeMod = (0, 0), ReloadSpeedmod = (0.85, 0.85))

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/  

    ReloadAnimName(0) = "weaponreload"
    ReloadAnimName(1) = "weaponreload"
    ReloadArmAnimName(0) = "weaponreload"
    ReloadArmAnimName(1) = "weaponreload"
     
    ReloadTime(0) = 2.5
	ReloadTime(1) = 2.0
	
	CrosshairWidth = 180 	// 256
	CrosshairHeight = 180 	// 256
     
    // gun config
    FireTriggerTags(0)="Fire01"
    FireTriggerTags(1)="Fire02"
	AltFireTriggerTags(0)="Fire01"
    VehicleClass=Class'RA2_Vehicle_TeslaTank'

    FireInterval(0)=1.0
	FireInterval(1)=5
    bFastRepeater=true

    Spread(0)=0.0
	
	RecoilImpulse = -0.01f
  
	WeaponFireSnd(0)     = SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_FireCue'
    WeaponFireTypes(0)   = EWFT_InstantHit
	WeaponFireSnd(1)     = SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_FireCue'
	WeaponFireTypes(1)	 = EWFT_None

	WeaponFireSounds_Heroic(0) = SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_FireCue_Heroic'
	WeaponFireSounds_Heroic(1) = SoundCue'RA2_VH_TeslaTank.Sounds.Teslatank_FireCue_Heroic'

    bRecommendSplashDamage=False
	
	WeaponRange(0)=4000.0
	// WeaponRange(1)=4000.0

	InstantHitDamage(0)=200
	InstantHitDamage(1)=0
	InstantHitDamageRadius(0)=50
	
	HeadShotDamageMult=2.5

	InstantHitDamageTypes(0)=class'RA2_DmgType_TeslaTank_Coil'
	InstantHitDamageTypes(1)=class'RA2_DmgType_TeslaTank_Coil'

	InstantHitMomentum(0)=10000
	
	bInstantHit=true
	
	BeamTemplates[0]=ParticleSystem'RA2_VH_TeslaTank.Effects.P_Lightning'
	BeamTemplates_Heroic[0] = ParticleSystem'RA2_VH_TeslaTank.Effects.P_Lightning_Heroic'
	
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')

	ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(17)=(MaterialType=YellowStone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(18)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
	ImpactEffects(19)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'APB_VH_SOV_TeslaTank.Effects.P_Impact',Sound=SoundCue'RX_WP_VoltAutoRifle.Sounds.SC_VoltBolt_Impact')
}
