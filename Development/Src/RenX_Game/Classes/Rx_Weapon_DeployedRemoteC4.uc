/**
 * Copyright 1998-2007 Epic Games, Inc. All Rights Reserved.
 */

class Rx_Weapon_DeployedRemoteC4 extends Rx_Weapon_DeployedC4;

var bool bDestroyed;

var Controller Planter;
var bool bIsRemoteC4;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ClearTimer('Explosion'); 
	SetTimer(C4ArmTime,false,nameof(ArmC4));
	if (InstigatorController != none) Planter = InstigatorController;
	if (Planter == none && Instigator.Controller != none) Planter = Instigator.Controller;
}

function Landed(vector HitNormal, Actor FloorActor)
{
	// continue checking throughout our lifetime
	if (Role >= ROLE_Authority)
		SetTimer(2.5, true, nameof(CheckBase));

	if (Pawn(FloorActor) != none && !GetCanStickToActor(Pawn(FloorActor)))
	{
		return; 
	}

   	ImpactedActor = FloorActor;
   	FloorNormal = HitNormal;
   	PlaySound(ImpactSound);
	super(Rx_Weapon_DeployedActor).Landed(HitNormal, FloorActor);
	SetTimer(1.0, true, 'KillCheck');
}

function KillCheck()
{
	if (Role == ROLE_Authority)
	{
		// Destroy when player dies
		if (Instigator == None || Instigator.Health <= 0)
			Destroy();
	}
}

simulated function Destroyed() 
{
	if (!bDestroyed) 
	{ 
		if (Role == ROLE_Authority && bUsesMineLimit)
			Rx_TeamInfo(Rx_Game(WorldInfo.Game).Teams[GetTeamNum()]).mineCount--;	
	
		if (bIsRemoteC4 && Role == ROLE_Authority && Rx_PRI(Planter.PlayerReplicationInfo) != None) 
			Rx_PRI(Planter.PlayerReplicationInfo).RemoveRemoteC4(self);	
		super.Destroyed();
		bDestroyed = true;
	}
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if ((Rx_Pawn(Base) !=none || Rx_Vehicle(base) !=none) && EventInstigator.GetTeamNum() != GetTeamNum() && (Base.GetTeamNum() == TeamNum || Base.GetTeamNum() == 255 ) )
	{
		super(Actor).TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);	

		if (DamageAmount <= 0 || HP <= 0 || bDisarmed )
		  return;

		HP -= DamageAmount*3.0; //Remotes should be fairly frail

		if (HP <= 0)
		{
			if (EventInstigator != InstigatorController) 
			{
				InstigatorController = EventInstigator; 
				TeamNum = InstigatorController.GetTeamNum();
			}
			Explosion();
		}
	}
	else
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);	
}

reliable server function bool CanPickup(Rx_Controller InController)
{
    return InController == Planter && HP == MaxHP && !bDisarmed && !bDestroyed && !bExplode && DistanceFrom(InController.Pawn) < PickupDistance && GetTeamNum() == InController.GetTeamNum();
}

simulated function bool CanPickupClient()
{
	local Rx_Pawn P;

	if (Planter == None) return false;

	P = Rx_Pawn(GetALocalPlayerController().Pawn);

    return P.Controller == Planter && HP == MaxHP && DistanceFrom(P) < PickupDistance && P.GetRxFamilyInfo().static.CanPickupDeployedActor(Class);
}

simulated function float DistanceFrom(Actor A)
{
	if (A != None)
		return VSize(Location - A.Location);
	return 9999999;
}

defaultproperties
{
	C4ArmTime=1.0f
    DeployableName="Remote C4"
    HP=200
    Damage=200
	DmgRadius=300
	DamageMomentum=8000.0
	bUsesMineLimit=false
	bIsRemoteC4=true
	ExplosionLightClass=Class'RenX_Game.Rx_Light_Tank_Explosion'
	ExplosionTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Small'
	ExplosionSound=SoundCue'RX_SoundEffects.Explosions.SC_Explosion_C4'
	ImpactSound=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Disarm'	
	ChargeDamageType=class'Rx_DmgType_RemoteC4'

	WeaponClass=class'Rx_Weapon_RemoteC4'
	PickupDistance=400
	
	ExplosionShake=CameraAnim'Envy_Effects.Camera_Shakes.C_VH_Death_Shake'
	InnerExplosionShakeRadius=100.0
	OuterExplosionShakeRadius=500.0		

	DisarmScoreReward = 30

	Begin Object Name=DeployableMesh
		SkeletalMesh=SkeletalMesh'RX_WP_RemoteC4.Mesh.WP_RemoteC4'
		PhysicsAsset=PhysicsAsset'RX_WP_RemoteC4.Mesh.WP_RemoteC4_Physics'
		Scale=1.0
	End Object
}