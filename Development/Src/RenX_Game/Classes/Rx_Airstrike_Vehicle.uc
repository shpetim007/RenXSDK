/** one1: Base class for all airstrike vehicles. */
class Rx_Airstrike_Vehicle extends Actor
	abstract
	implements(RxIfc_RadarMarker);

var private SkeletalMeshComponent Mesh;
var const Texture MinimapIconTexture;

/** How much random spread should be applied to each projectile. */
var float ProjectileDirectionSpreadMulti;

/** Approaching sound used by Rx_Airstrike actor. */
var SoundCue ApproachingSound;

struct EventDef
{
	var float Time;
	var delegate<EventFunc> Call;
};

var private array<EventDef> Events;
var repnotify private float CurrentTime;
var private bool bGotCurrentTime;

var byte TeamNum;

var repnotify int EventNum;
var int ClientEventNum;

replication
{
	if (bNetInitial)
		CurrentTime;
	if (bNetDirty)
		EventNum, TeamNum;
}

delegate EventFunc();

simulated function byte GetRadarVisibility()
{
	return 1;
} 
simulated function Texture GetMinimapIconTexture()
{
	return MinimapIconTexture;
}

simulated function vector GetRadarActorLocation()
{
	return Location;
}
simulated function rotator GetRadarActorRotation()
{
	return rot(0.0,0.0,0.0);
}

simulated function bool ForceVisible()
{
	return false;
}

//0:Infantry 1: Vehicle 2:Miscellaneous  
simulated function int GetRadarIconType()
{
	return 1;
}

simulated function bool GetUseSquadMarker(byte TeamByte, byte SquadByte)
{
	return false;
}

simulated event PostBeginPlay()
{
	//`log("airstrike begins: " $ self);

	super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		if(Owner != None)
			TeamNum = Owner.GetTeamNum();
		bForceNetUpdate = true;
	}

	if(CurrentTime < 0)
		SetTimer(CurrentTime * -1, false, 'PlayMyAnim');

	else
		PlayMyAnim();

	InitialSetup();

	Events.Sort(EventSort);
}

simulated function int EventSort(EventDef A, EventDef B)
{
	if(A.Time > B.Time)
		return -1;

	return 0;
}

simulated function PlayMyAnim()
{
	Mesh.Animations.PlayAnim(false, 1.f, 0.0);
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'CurrentTime')
	{
		if (!bGotCurrentTime)
		{
			bGotCurrentTime = true;
			if(CurrentTime >= 0.0)
				Mesh.Animations.PlayAnim(false, 1.f, CurrentTime);
			else
				SetTimer(CurrentTime * -1, false, 'PlayMyAnim');
		}
	}
	else if (VarName == 'EventNum')
	{
		while (ClientEventNum < EventNum)
		{
			ClientEventNum++;
			CallDelegate(Events[ClientEventNum].Call);
		}
	}


	else super.ReplicatedEvent(VarName);
}

/**
 * Create event function. Function is added only if time hasn't elapsed yet.
 *
 * @param Time      At what time to call the function
 * @param Func		Function to call.
 */
simulated function CreateEvent(float time, delegate<EventFunc> func)
{
	local EventDef e;

	if (time < CurrentTime) 
	{
		if (time != 0.f || CurrentTime > 0.1f)
			return; // skip, time has passed over already
	}

	e.Time = time;
	e.Call = func;

	Events.AddItem(e);
}

simulated event Tick(float DeltaTime)
{
	local int i, j;
//	local array<EventDef> RemoveList;

	super.Tick(DeltaTime);

	if(WorldInfo.NetMode != NM_Client && (Owner == None || Owner.GetTeamNum() != TeamNum))
	{
		RelegateOwner();
	}

	if(EventNum >= Events.Length - 1)
		return;

	j = EventNum;

	if (Role == ROLE_Authority)
	{
		CurrentTime += DeltaTime;
		bForceNetUpdate = true;

		for (i = (EventNum + 1); i < Events.Length; i++)
		{
			if (CurrentTime >= Events[i].Time)
			{
				CallDelegate(Events[i].Call);
				j = i;
			}
		}

		if(j > EventNum)
			EventNum = j;
	}

	if(Role == ROLE_Authority && Lifespan <= 0 && EventNum >= Events.Length - 1)
	{
		Lifespan = 15.f; // schedule its' destruction because it's no longer necessary
	}

}

simulated function byte GetTeamNum()
{
	return Owner != None ? Owner.GetTeamNum() : TeamNum;
}

function RelegateOwner()
{
	local PlayerReplicationInfo PRI ; 

	foreach WorldInfo.GRI.PRIArray(PRI)
	{
		if(PRI.Owner != None && PRI.Owner.GetTeamNum() == TeamNum)
		{
			SetOwner(PRI.Owner); // randomly select a new player to give credit to
			return;
		}
	}

	Destroy(); // just delete the airstrike if no owner is found
}

private simulated final function CallDelegate(delegate<EventFunc> c)
{
	c();
}

simulated event OnAnimPlay(AnimNodeSequence SeqNode)
{
	//`log("anim started");
}


/**
 * This function is called after CurrentTime is 
 * determined. In SP, server and listenserver this happens
 * immediatelly, otherwise after first CurrentTime is received
 * from server. 
 * 
 * Override this to perform initial setup (create events).
 */
simulated function InitialSetup()
{
//	Mesh.Animations.PlayAnim(false, 1.f, CurrentTime);
}


/**
 * Attach audio playback to socket and plays it.
 *
 * @param cue       Sound Cue to play.
 * @param socket    Socket name to attach to.
 * @param add       True to add component to specified array.
 * @param sessionc  Array to add to.
 * 
 * @return AudioComponent that was created and attached to socket.
 */
simulated function AudioComponent AttachAudio(
	SoundCue cue, 
	name socket, 
	optional bool add = false,
	optional array<ActorComponent> sessionc)
{
	local AudioComponent ac;

	if (WorldInfo.NetMode == NM_DedicatedServer)
		return none; // do not proceed if we are dedicated server

	ac = CreateAudioComponent(cue, false, true, true, , false);
	if(cue == SoundCue'RX_VH_A-10.Sounds.SC_A-10_Airstrike_Gun')
		ac.VolumeMultiplier = 0.2;
	if(cue == SoundCue'RX_VH_A-10.Sounds.SC_A-10_FlyOver')
		ac.VolumeMultiplier = 0.6;
	if (ac != none)
	{
		AttachComponent(ac);
		Mesh.AttachComponentToSocket(ac, socket);
		ac.Play();

		if (add) sessionc.AddItem(ac);
	}

	return ac;
}

/**
 * Attach particle effect to socket.
 *
 * @param particle      Particle effect to attach.
 * @param socket        Socket name to attach to.
 * @param add           True to add component to specified array.
 * @param sessionc      Array to add to.
 * 
 * @return ParticleSystemComponent that was created and attached to socket.
 */
simulated function ParticleSystemComponent AttachParticleEffect(
	ParticleSystem particle, 
	name socket,
	optional bool add = false,
	optional array<ActorComponent> sessionc)
{
	local ParticleSystemComponent psc;

	if (WorldInfo.NetMode == NM_DedicatedServer)
		return none; // do not proceed if we are dedicated server

	psc = new(self) class'ParticleSystemComponent';
	psc.bAutoActivate = true;
	psc.SetTemplate(particle);
	AttachComponent(psc);
	Mesh.AttachComponentToSocket(psc, socket);

	if (add) sessionc.AddItem(psc);

	return psc;
}

/**
 * Spawn projectile with specified class at socket location and initiates it towards tsocket location.
 *
 * @param projclass     Projectile class to create.
 * @param socket        Socket name where to create projectile at.
 * @param tsocket       Socket name towards where projectile should be directed.
 * 
 * @return Projectile actor that was spawned.
 * 
 * @note This function is executed on Authority peer only.
 */
function Rx_Projectile InitiateProjectile(
	class<Rx_Projectile> projclass, 
	name socket, 
	name tsocket)
{
	local Rx_Projectile proj;
	local vector spawnloc, tloc;
	local rotator spawnrot, trot;

	if (!Mesh.GetSocketWorldLocationAndRotation(socket, spawnloc, spawnrot, 0)) 
		return none;

	if (!Mesh.GetSocketWorldLocationAndRotation(tsocket, tloc, trot, 0)) 
		return none;

	proj = Spawn(projclass, self, , spawnloc, spawnrot);
	if(Controller(Owner) != None)
	{
		proj.Instigator = Controller(Owner).Pawn;
		proj.InstigatorController = Controller(Owner);
	}

	// apply spread
	if (ProjectileDirectionSpreadMulti != 0.f)
	{
		tloc.X += FGetSpread();
		tloc.Y += FGetSpread();
		tloc.Z += FGetSpread();
	}

	proj.Init(Normal(tloc - spawnloc));
	
	return proj;
}

simulated function float FGetSpread()
{
	return (2.f * FRand() - 1.0f) * ProjectileDirectionSpreadMulti;
}

/**
 * Detach and remove all components provided in array.
 *
 * @param sc            Array of components to detach and remove.
 */
simulated function RemoveComponents(array<ActorComponent> sc)
{
	local int i;

	for (i = 0; i < sc.Length; i++)
	{
		Mesh.DetachComponent(sc[i]);
		DetachComponent(sc[i]);
	}
}


DefaultProperties
{
	/** Simulated proxy, so players can execute simulated functions to
	 *  spawn visual and sound effects. */
	RemoteRole=ROLE_SimulatedProxy

	Begin Object Class=SkeletalMeshComponent Name=WSkeletalMesh
		AlwaysLoadOnServer=true
		CastShadow=true
		AlwaysLoadOnClient=true
		BlockActors=true
		CollideActors=true
		bUpdateSkelWhenNotRendered=true
		bCastDynamicShadow=true
	End Object
	Mesh=WSkeletalMesh
	Components.Add(WSkeletalMesh)

	CurrentTime=-1.f

	NetPriority=+00001.500000
	bAlwaysRelevant=true

	TeamNum = 255

	EventNum = -1
	ClientEventNum = -1
}
