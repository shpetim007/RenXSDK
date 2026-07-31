class Rx_MysteryWeapon extends Actor;

var() SkeletalMeshComponent Mesh;
var array<class<Rx_Weapon> > Weapons;
var repnotify class<Rx_Weapon> CurrentWep;

var float TimeLeft;
var float BaseTime; //reduce this to make animation faster

replication
{
    if (bNetDirty)
        CurrentWep;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'CurrentWep')
    {
        // Update mesh on client when weapon changes
        if (CurrentWep != None)
        {
            Mesh.SetSkeletalMesh(SkeletalMeshComponent(CurrentWep.default.Mesh).SkeletalMesh);
        }
    }
}

simulated function Tick(float DeltaTime)
{
	if (TimeLeft > 0)
	{
		TimeLeft -= DeltaTime;

		TimeLeft = FMax(0, TimeLeft);
	}
}

simulated function BeginAnimation(float AnimDuration)
{
	TimeLeft = AnimDuration;
	PickWeapon();
	SetTimer(AnimDuration, false, nameof(StopAnimation));
}

simulated function StopAnimation()
{
	ClearTimer(nameof(PickWeapon));
	TimeLeft = 0;
}

simulated function PickWeapon()
{
	local class<Rx_Weapon> NewWep;

	NewWep = Weapons[Rand(Weapons.length)];

	while (CurrentWep == NewWep)
	{
		NewWep = Weapons[Rand(Weapons.length)];
	}

	Mesh.SetSkeletalMesh(SkeletalMeshComponent(NewWep.default.Mesh).SkeletalMesh);

	CurrentWep = NewWep;
    bNetDirty = true;  

	SetTimer(BaseTime/TimeLeft, true, nameof(PickWeapon));
}

DefaultProperties
{
	BaseTime = 1.0

	Begin Object Class=SkeletalMeshComponent Name=Wep
		CastShadow                   = True
		AlwaysLoadOnClient           = True
		AlwaysLoadOnServer           = True
		bUsePrecomputedShadows       = False
		CollideActors                = false
		BlockActors                  = false
		BlockRigidBody               = false
		BlockZeroExtent              = false
		BlockNonZeroExtent           = false
		bCastDynamicShadow           = True
		bAcceptsDynamicLights        = True
		bAcceptsLights               = True
		bAcceptsDecalsDuringGameplay = True
		bAcceptsDecals               = True
		SkeletalMesh=SkeletalMesh'RX_WP_VoltAutoRifle.Mesh.SK_VoltAutoRifle_1P'
		LightingChannels             = (Static=true,BSP=true,Dynamic=false,bInitialized=True)
		Rotation = (Pitch=0,Yaw=16384,Roll=0)
	End Object
	Mesh = Wep
	CollisionComponent = Wep
	Components.Add(Wep)

	bHidden=true

	Weapons.Add(class'Rx_Weapon_IonCannonBeacon')
	Weapons.Add(class'Rx_Weapon_Airstrike_GDI')
	Weapons.Add(class'Rx_Weapon_RepairTool')
	Weapons.Add(class'Rx_Weapon_AutoRifle')
	Weapons.Add(class'Rx_Weapon_RamjetRifle')
	Weapons.Add(class'Rx_Weapon_RocketLauncher')
	Weapons.Add(class'Rx_Weapon_MissileLauncher')
	Weapons.Add(class'Rx_Weapon_Pistol')

    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    bReplicateMovement=true  
    bNetInitialRotation=true
}