class Rx_Building_Barracks_Internals extends Rx_Building_Team_Internals;

var StaticMeshComponent Blocker, Blocker2, Blocker3, Blocker4;

simulated function Init(Rx_Building Visuals, bool isDebug)
{
	super.Init(Visuals, isDebug);

	BuildingSkeleton.AttachComponentToSocket(Blocker, 'BlockingWall_L_01');
	BuildingSkeleton.AttachComponentToSocket(Blocker2, 'BlockingWall_L_02');
	BuildingSkeleton.AttachComponentToSocket(Blocker3, 'BlockingWall_R_01');
	BuildingSkeleton.AttachComponentToSocket(Blocker4, 'BlockingWall_R_02');

	if (Rx_Building_Barracks_Ramps(Visuals) != None)
	{
		BuildingSkeleton.DetachComponent(Blocker);
		Blocker = None;
		BuildingSkeleton.DetachComponent(Blocker2);
		Blocker2 = None;
		BuildingSkeleton.DetachComponent(Blocker3);
		Blocker3 = None;
		BuildingSkeleton.DetachComponent(Blocker4);
		Blocker4 = None;
	}
}

DefaultProperties
{
	TeamID = TEAM_GDI
	Begin Object Name=BuildingSkeletalMeshComponent
		SkeletalMesh            = SkeletalMesh'RX_BU_Barracks.Mesh.SK_BU_GDI_BAR'
		PhysicsAsset            = PhysicsAsset'RX_BU_Barracks.Mesh.SK_BU_GDI_BAR_Physics'
		bEnableClothSimulation  = True
		bClothAwakeOnStartup    = True
		ClothWind               = (X=-10.000000,Y=50.000000,Z=5.000000)
		bAutoFreezeClothWhenNotRendered=true
	End Object

	AttachmentClasses.Add(Rx_BuildingAttachment_Door_GDI)
	AttachmentClasses.Add(Rx_BuildingAttachment_BeaconPedestal)

	Begin Object Class=StaticMeshComponent Name=InfBlocker
		StaticMesh=StaticMesh'RX_Env_Fort.Mesh.S_HU_Walls_SM_Flat'
		Materials(0)=MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Concrete'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=true
		BlockRigidBody=true
		bDisableAllRigidBody=false
		RBChannel=RBCC_BlockingVolume
		Scale=1.0
	End Object
	Components.Add(InfBlocker)
	Blocker=InfBlocker

	Begin Object Class=StaticMeshComponent Name=InfBlocker2
		StaticMesh=StaticMesh'RX_Env_Fort.Mesh.S_HU_Walls_SM_Flat'
		Materials(0)=MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Concrete'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=true
		BlockRigidBody=true
		bDisableAllRigidBody=false
		RBChannel=RBCC_BlockingVolume
		Scale=1.0
	End Object
	Components.Add(InfBlocker2)
	Blocker2=InfBlocker2

	Begin Object Class=StaticMeshComponent Name=InfBlocker3
		StaticMesh=StaticMesh'RX_Env_Fort.Mesh.S_HU_Walls_SM_Flat'
		Materials(0)=MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Concrete'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=true
		BlockRigidBody=true
		bDisableAllRigidBody=false
		RBChannel=RBCC_BlockingVolume
		Scale=1.0
	End Object
	Components.Add(InfBlocker3)
	Blocker3=InfBlocker3

	Begin Object Class=StaticMeshComponent Name=InfBlocker4
		StaticMesh=StaticMesh'RX_Env_Fort.Mesh.S_HU_Walls_SM_Flat'
		Materials(0)=MaterialInstanceConstant'RenX_AssetBase.Null_Material.MI_Null_Concrete'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=true
		BlockRigidBody=true
		bDisableAllRigidBody=false
		RBChannel=RBCC_BlockingVolume
		Scale=1.0
	End Object
	Components.Add(InfBlocker4)
	Blocker4=InfBlocker4
	
	FriendlyBuildingSounds(BuildingDestroyed)           = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_Barracks_Destroyed'
	FriendlyBuildingSounds(BuildingUnderAttack)         = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_Barracks_UnderAttack'
	FriendlyBuildingSounds(BuildingRepaired)            = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_Barracks_Repaired'
	FriendlyBuildingSounds(BuildingDestructionImminent) = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_Barracks_DestructionImminent'
	EnemyBuildingSounds(BuildingDestroyed)              = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_Barracks_Destroyed'
	EnemyBuildingSounds(BuildingUnderAttack)            = SoundNodeWave'RX_EVA_VoiceClips.nod_eva.S_EVA_Nod_Barracks_UnderAttack'
}
