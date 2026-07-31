class Rx_SmokeScreen extends Rx_ParticleField;

var float BeginTargetBlockTime	;
var repnotify bool bTargetBlock	;	
var int TeamNum;

var float Vet_TimeModifier[10]; //+X seconds

replication
{
	if (bNetDirty)
		bTargetBlock;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bTargetBlock' && bTargetBlock)
	{
		EnableTargetBlock();
	}
	else
		super.ReplicatedEvent(VarName);
}

event PostBeginPlay()
{
	//Super call with init of lifespan. Lifespan done in InitSmokeScreen so VRank is properly applied 
	if (WorldInfo.NetMode == NM_DedicatedServer)
		bClientInitialised = true;  // So Dedicated doesn't try spawn Particle Effect.

	if(ROLE == ROLE_Authority)
		SetTimer(0.5, true, 'ObscurePawns');

	//Skip the usual setting of Lifespan and what not
	super(Actor).PostBeginPlay();
}



simulated function InitSmokeScreen(byte Rank, Pawn InstigatorPawn)
{
	LifeSpan+=Vet_TimeModifier[Rank]; 
	TeamNum = InstigatorPawn.GetTeamNum(); 
	SetTimer(LifeSpan-StopParticlesTime, false, 'StopParticles');
	++Rx_Game(WorldInfo.Game).SmokeScreenCount;
	SetTimer(BeginTargetBlockTime, false, 'EnableTargetBlock');
}

simulated event Tick( float DeltaTime )
{
	if (!bClientInitialised && bTargetBlock)
		EnableTargetBlock();

	super.Tick(DeltaTime);
}

simulated function EnableTargetBlock()
{
	if (WorldInfo.NetMode != NM_Client)
		bTargetBlock=true;

	CollisionComponent.SetActorCollision(true, false);
}

function ObscurePawns()
{
	local Rx_Pawn RXP; 

	foreach CollidingActors(class'Rx_Pawn', RXP, GetRadius(), location, true)
	{
		if(RXP.GetTeamNum() == TeamNum)
		{
			RXP.SetTargetable(false, 2.0); 
		}
	}
}

event Destroyed()
{
	if (WorldInfo.NetMode != NM_Client)
		--Rx_Game(WorldInfo.Game).SmokeScreenCount;
}

simulated function StopParticles()
{
	super.StopParticles();
}

simulated function float GetRadius() { return CylinderComponent(CollisionComponent).CollisionRadius ;}

DefaultProperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+480.0f
		CollisionHeight=+512.0f
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		CollideActors=false
	End Object

	ParticlesTemplate=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_SmokeScreen'

	// Gameplay variable settings
	BeginTargetBlockTime=1.0
	StopParticlesTime=2.0

	LifeSpan=11.0   // Time for SmokeScreen to exist. Target block length = Lifespan - BeginTargetBlockTime
	
	//+X seconds
	Vet_TimeModifier(0) = 0 
	Vet_TimeModifier(1) = 0 
	Vet_TimeModifier(2) = 0 
	Vet_TimeModifier(3) = 0 
	Vet_TimeModifier(4) = 0 
	Vet_TimeModifier(5) = 0 
	Vet_TimeModifier(6) = 0 
	Vet_TimeModifier(7) = 0 
	Vet_TimeModifier(8) = 0 
	Vet_TimeModifier(9) = 0 
}
