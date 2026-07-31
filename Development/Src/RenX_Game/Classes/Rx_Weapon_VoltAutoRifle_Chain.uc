class Rx_Weapon_VoltAutoRifle_Chain extends Rx_Weapon_VoltAutoRifle_GDI;

var const int MaxChains;

simulated function ProcessInstantHit( byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	super.ProcessInstantHit(FiringMode, Impact, NumHits);

	// didnt hit pawn so we dont care
	if (Impact.HitActor == None || Rx_Pawn(impact.HitActor) == None || Impact.HitActor.GetTeamNum() == Instigator.GetTeamNum()) return;

	ChainToEnemies(Pawn(Impact.HitActor));

	Rx_Pawn(Instigator).SimulateChainToEnemies(Pawn(Impact.HitActor));
	if (Rx_Pawn(Instigator).ChainInitialTarget == Pawn(Impact.HitActor))
	{
		Rx_Pawn(Instigator).ChainCount++;
	}
}

function ChainToEnemies(Pawn InitialPawn)
{
	local Pawn NearbyEnemy;
	local ImpactInfo impact;
	local float DmgMulti;
	local int i;
	local array<Pawn> ChainedActors;

	DmgMulti = 1;

	ChainedActors.AddItem(InitialPawn);

	for (i = 0; i < MaxChains; i++)
	{
		ForEach VisibleCollidingActors(class'Pawn', NearbyEnemy, 500, InitialPawn.Location)
		{
			if (NearbyEnemy.GetTeamNum() == Instigator.GetTeamNum() || ChainedActors.Find(NearbyEnemy) != INDEX_NONE || InitialPawn == NearbyEnemy || NearbyEnemy.Health <= 0)
				continue;
	
			DmgMulti *= 0.9;
	
			impact = CalcWeaponFire(InitialPawn.Location, NearbyEnemy.Location);

			if (Rx_Pawn(Instigator).CurrentWeaponAttachment != None)
				Rx_Attachment_VoltAutoRifle(Rx_Pawn(Instigator).CurrentWeaponAttachment).SpawnBeam(InitialPawn.Location, NearbyEnemy.Location, false);

			NearbyEnemy.TakeDamage( InstantHitDamage[0] * DmgMulti, Instigator.Controller,
							Impact.HitLocation, InstantHitMomentum[0] * Impact.RayDir,
							InstantHitDamageTypes[0], Impact.HitInfo, self );
	
			ChainedActors.AddItem(NearbyEnemy);
	
			InitialPawn = NearbyEnemy;
			break;
		}
	}
}

DefaultProperties
{
    AttachmentClass=class'Rx_Attachment_VoltAutoRifle_GDI'

    MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_VoltAutoRifle.Effects.P_VoltRifle_MuzzleFlash_1P_Blue'
	MuzzleFlashPSCTemplate_Heroic=ParticleSystem'RX_WP_VoltAutoRifle.Effects.P_VoltRifle_MuzzleFlash_1P_Blue'

	MaxChains = 10
}
