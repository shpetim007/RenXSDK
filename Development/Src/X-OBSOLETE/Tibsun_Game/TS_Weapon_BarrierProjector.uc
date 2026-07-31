class TS_Weapon_BarrierProjector extends TS_Weapon_Reloadable
implements(RxIfc_Blueprint);

// Build Status

var TS_BlueprintModel ActiveModel;
var vector BuildLoc, BuildNormal;
var Rotator BuildRot;
var Actor BuildBase;
var bool bValidPlacement;

// Build Rotation modifier

var rotator ExtraRotation;

// Build Constants

var() vector BuildOffset;
var() float BuildScale;
var() class<TS_BlueprintModel> ModelClass;
var() vector RotationMultiplier;
var() float BuildClearRadius;
var() float MinNormalZ, MaxNormalZ;

simulated state Active
{
	simulated function BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);

		// make sure this only gets executed on players ever
		if (WorldInfo.NetMode == NM_DedicatedServer ||
			(WorldInfo.NetMode == NM_ListenServer && !bNetOwner))
			return;

		if (ActiveModel == None)
		{
			ActiveModel = spawn(ModelClass,,,BuildLoc + BuildOffset,BuildRot);
			ActiveModel.BoundWeapon = RxIfc_Blueprint(Self);
			
			GetBlueprintLocation();

			SetupVisual();
		}
	}

	simulated event EndState( Name NextStateName )
	{
		super.EndState(NextStateName);

		if (ActiveModel != None)
		{
			ActiveModel.Destroy();
			ActiveModel = None;
		}

		if (WorldInfo.NetMode == NM_DedicatedServer ||
			(WorldInfo.NetMode == NM_ListenServer && !bNetOwner))
			return;

		ExtraRotation = rot(0,0,0);
	}

	simulated event Tick( float DeltaTime ) 
	{
		super.Tick(DeltaTime);
	
		// make sure this only gets executed on players ever
		if (WorldInfo.NetMode == NM_DedicatedServer ||
			(WorldInfo.NetMode == NM_ListenServer && !bNetOwner))
			return;

		GetBlueprintLocation();

		if (ActiveModel == None)
			return;

		if (ActiveModel.Location != GetBlueprintModelLocation())
			ActiveModel.SetLocation(GetBlueprintModelLocation());
		
		if (ActiveModel.Rotation != BuildRot)
			ActiveModel.SetRotation(BuildRot);
	}

	simulated function StartFire(byte FireModeNum)
	{
		if (Instigator == None || !Instigator.bNoWeaponFiring)
		{
			// make sure this only gets executed on players ever
			if (WorldInfo.NetMode == NM_DedicatedServer ||
				(WorldInfo.NetMode == NM_ListenServer && !bNetOwner))
				return;

			if (FireModeNum == 0)
			{

				if (!PlacementAllowed()) 
				{
					return; // if Can't place building here, do nothing
				}			
				DeployBlueprint(BuildLoc + BuildOffset,BuildRot);
			}

			else if (FireModeNum == 1)
			{
				AddRotation();

				SetupVisual();
				return;
			}
		}
	}
}

simulated function SetupVisual()
{
	ActiveModel.VisualSM.SetStaticMesh(class'TS_FirestormBarrier_Personnel'.default.StatMesh.StaticMesh);
	
	ActiveModel.SetDrawScale(BuildScale);
	ActiveModel.RevalidateMat();
}

simulated function GetBlueprintLocation()
{
	local Vector TempLoc, TempOri, TempDir;
	local Rotator TempRot;
	local vector HitLocation, HitNormal;


	Instigator.Controller.GetPlayerViewPoint(TempOri, TempRot); 
	TempDir = Vector(TempRot);
	TempLoc = TempOri + (TempDir * WeaponRange);

	BuildBase = Instigator.Trace(HitLocation,HitNormal, TempLoc, TempOri,,,, TRACEFLAG_Blocking);

	//if(BuildBase == None)
	//	BuildBase = Instigator.Trace(HitLocation,HitNormal, TempLoc - (Vect(0,0,1) * 1000), TempLoc,,,, TRACEFLAG_Blocking);

	BuildLoc = HitLocation;
	BuildNormal = HitNormal;

	BuildRot = GetBuildRotation();
	bValidPlacement = IsBuildCorrect();
}

simulated function bool IsBuildCorrect()
{
	return RadiusIsClear() && BuildLoc != vect(0,0,0);
}

simulated function bool RadiusIsClear()
{
	local Actor A;

	if(BuildClearRadius <= 0)
		return true;

	foreach VisibleCollidingActors( class'Actor', A, BuildClearRadius, BuildLoc + BuildOffset)
	{
		if(Pawn(A) != None || Rx_Weapon_DeployedActor(A) != None)
			return false;
	}

	return true;
}

simulated function AddRotation()
{

}

simulated function rotator GetBuildRotation()
{
	local Rotator MyRot;

	MyRot = rot(0.f,0.f,0.f);

	return MyRot;
}

reliable server function DeployBlueprint(vector DeployLoc, rotator DeployRot)
{
	local TS_FirestormBarrier_Personnel SpawnedBuilding;

	if(!IsBuildCorrect())
		return;

	SpawnedBuilding = Spawn(class'TS_FirestormBarrier_Personnel',Instigator,,DeployLoc,DeployRot,,true);

	if(Instigator.GetTeamNum() == 0)
		SpawnedBuilding.TeamIndex = TEAM_GDI;
	else if(Instigator.GetTeamNum() == 1)
		SpawnedBuilding.TeamIndex = TEAM_NOD;
	else
		SpawnedBuilding.TeamIndex = TEAM_UNOWNED;

	if (ActiveModel != None)
	{
		ActiveModel.Destroy();
		ActiveModel = None;
	}	

	Rx_InventoryManager(Instigator.InvManager).RemoveWeaponOfClass(self.Class);	
}

simulated function bool PlacementAllowed()
{
	return bValidPlacement;
}

simulated function Vector GetBlueprintModelLocation()
{
	return BuildLoc + BuildOffset;
}

DefaultProperties
{
	ActionToReadyTime = 0.15

	BuildOffset = (X = 0, Y = 0, Z = -25)

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	WeaponFireTypes(0)=EWFT_Custom
	WeaponFireTypes(1)=EWFT_Custom

	BuildScale=0.65f

	RotationMultiplier= (X=0,Y=0,Z=1)
	MinNormalZ = 0.8
	MaxNormalZ = 1

	ModelClass = class'TS_BlueprintModel_FirestormBarrier_Personnel'

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'TS_WP_RepairGun.Mesh.SK_WP_RepairTool_1P'
		AnimSets(0)=AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=75.0
	End Object
	
	ArmsAnimSet = AnimSet'TS_WP_Pistol.HD.Anims.AS_TS_Pistol_Arms'

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_RepairGun.Mesh.SK_WP_RepairTool_3P'
		Scale=1.0
	End Object
	
	PlayerViewOffset=(X=0.0,Y=2.0,Z=-1.0)
	
	LeftHandIK_Offset=(X=-3.511200,Y=-4.500000,Z=0.230000)
	LeftHandIK_Rotation=(Pitch=-3094,Yaw=0,Roll=2366)
	LeftHandIK_Relaxed_Offset=(X=0.0,Y=0.0,Z=0.0)
	RightHandIK_Offset=(X=2,Y=-2,Z=-5)
	RightHandIK_Relaxed_Offset=(X=0.0,Y=0.0,Z=0.0)
	RightHandIK_Relaxed_Rotation=(Pitch=0,Yaw=0,Roll=0)
	
	bUseHandIKWhenRelax=false	
	bOverrideLeftHandAnim=true
	LeftHandAnim=H_M_Hands_Closed

	AttachmentClass = class'TS_Attachment_RepairUnit'

	WeaponRange=1500 //350.0
	
	ShotCost(0)=1
	ClipSize = 1
	InitalNumClips = 1
	MaxClips = 1
	FireInterval(0)=+0.05
	FireInterval(1)=+0.05

	/****************************************/
    /* AI */
    /****************************************/ 
	bSplashJump = False
	bLockedAimWhileFiring = False
	bMeleeWeapon = False
	bRecommendSplashDamage = False
	bInstantHit = True
	bSniping = False 
	bFastRepeater = True	

    bOkAgainstBuildings = False
    bOkAgainstVehicles = False

	MaxDesireability=0.2
	AIRating=+0.1
	CurrentRating=+0.1
	AimError = 545

	WeaponFireSnd[0]=SoundCue'RX_WP_RepairGun.Sounds.SC_RepairTool_Fire'
	WeaponFireSnd[1]=None
	
	InventoryGroup=6
	InventoryMovieGroup=37

	WeaponIconTexture=Texture2D'RX_WP_RepairGun.UI.T_WeaponIcon_RepairTool'
	PTIconTexture=Texture2D'TSPurchaseMenu.Textures.Items.T_PT_Item_RepairUnit'

	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_RepairGun.Effects.P_RepairGun_MuzzleFlash_1P_Small'
	MuzzleFlashDuration=3.3667
	MuzzleFlashLightClass=class'Rx_Light_RepairBeam'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'TS_BackWeaponAttachment_RepairUnit'
	
	bUseClientAmmo = false
}