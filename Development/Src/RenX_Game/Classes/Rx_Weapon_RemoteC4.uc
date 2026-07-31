class Rx_Weapon_RemoteC4 extends Rx_Weapon_Deployable;

/** List of deployed actors for detonation purposes */
var array<Rx_Weapon_DeployedRemoteC4> Remotes;
var repnotify bool bDetonatedRemotes;
var bool bCanPlaceRemoteRightNow;

// AI
var int RemoteDetonationFailure;

replication
{
	if( bNetDirty && bNetOwner && Role == ROLE_Authority)
		bDetonatedRemotes, bCanPlaceRemoteRightNow;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'bDetonatedRemotes' )
	{
		if ( bDetonatedRemotes && AmmoCount == 0)
		{
			WeaponEmpty();
		}
	}
	else
		if(VarName == 'AmmoCount')
		{
			if(AmmoCount == MaxAmmoCount) 
			{
				bForceHidden = false;
				Mesh.SetHidden(false);
			}
			else
			if(AmmoCount == 0)
			{
				bForceHidden = true;
				Mesh.SetHidden(true);
			}
		}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}
	
simulated function PutDownWeapon()
{
	// Sometimes this timer doesn't clear as it should, and throwing out more c4 makes them auto-explode...
	ClearTimer(nameof(RetryDetonation));
	super.PutDownWeapon();
}

simulated function bool Deploy()
{
	if(super.Deploy()) 
	{
		if (Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo) != None)
			Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo).AddRemoteC4(DeployedActor);
	
		Remotes.AddItem(Rx_Weapon_DeployedRemoteC4(DeployedActor));
		if(WorldInfo.NetMode == NM_DedicatedServer)
			FinishDeploy(DeployedActor);
		return true;
	}
	
	return false;
}

reliable client function FinishDeploy(Actor inDeployedActor)
{
		if (Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo) != None)
			Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo).AddRemoteC4(inDeployedActor);
	
		Remotes.AddItem(Rx_Weapon_DeployedRemoteC4(inDeployedActor));
}

simulated function CustomFire()
{
	ClearTimer(nameof(RetryDetonation));
	if(CurrentFireMode == 0) {
		super.CustomFire();
		bCanPlaceRemoteRightNow=false;
		SetTimer(1.0,false,'SetCanPlaceRemoteAgain');
	}
}

function SetCanPlaceRemoteAgain() 
{
	bCanPlaceRemoteRightNow = true;
}

simulated function DetonateCharges()
{
	local Rx_Weapon_DeployedRemoteC4 D;

	if (bDebugWeapon)
	{
		`log("---"@self$"."$GetStateName()$".CustomFire()"@Role@Remotes.Length);
		ScriptTrace();
	}

	//if( Role == ROLE_Authority && Remotes.Length > 0)
	if( Remotes.Length > 0)
	{
		foreach Remotes(D)
		{
			if( D != None ) 
			{
				if(D.bDestroyed == false) 
				{
					if (bDebugWeapon)
						`log("Trying to explode c4, amount of active c4 is: " @ Remotes.Length);
					if(D.DoExplosion())
					{
						Remotes.RemoveItem(D);
						if (bDebugWeapon)
							`log("C4 exploded, new amount of active c4 is: " @ Remotes.Length);
					}
				}
			}
			else
				Remotes.RemoveItem(D);
		}
	
	}
	if(!HasAnyAmmo())
		bDetonatedRemotes = true;
	else if(Remotes.Length > 0 && !IsTimerActive(nameof(RetryDetonation)))
		SetTimer(0.1,true,nameof(RetryDetonation)); // Ensure they all explode!
}

simulated function RetryDetonation()
{
	if( Remotes.Length > 0)
		DetonateCharges();
	else
		ClearTimer(nameof(RetryDetonation));
}

simulated function ConsumeAmmo( byte FireModeNum ) {
	if(FireModeNum == 0) {
		super.ConsumeAmmo(FireModeNum);
	}
}

simulated function FireAmmunition()
{
	if(CurrentFireMode == 0 && !bCanPlaceRemoteRightNow) {
		return;
	} else {
		if(CurrentFireMode == 0 && Role == Role_Authority) {
			bDetonatedRemotes = false;
		}
		super.FireAmmunition();
	}
}

simulated function WeaponEmpty()
{
	if (bDebugWeapon) 
	{
		`log("---"@self$"."$GetStateName()$".WeaponEmpty()"@IsFiring()@Instigator@Instigator.IsLocallyControlled());
	}
	if(HasAnyAmmo()) 
	{
		if (Rx_Controller(Instigator.Controller).CurrentExplosiveWeapon == self.Class) 
			Rx_Controller(Instigator.Controller).CurrentExplosiveWeapon = none;
	} 
	else 
	{
		bForceHidden = true;
		Mesh.SetHidden(true);
	}
}

simulated function bool HasAnyAmmo() {
	return AmmoCount > 0 || Remotes.Length > 0;
}

simulated function bool HasAmmo( byte FireModeNum, optional int Amount ) {
	if(FireModeNum == 1) {
		return true;
	} else {
		return super.HasAmmo(FireModeNum,Amount);
	}
}

simulated function StartFire(byte FireModeNum)
{
	if(FireModeNum == 1)
	{
		ServerDetonateRemotes();
	}
	else	
		super.StartFire(FireModeNum);
}

reliable server function ServerDetonateRemotes()
{	
	if (bDebugWeapon)
		`log("Current amount of remotes deployed: " @ Remotes.Length,true);
	if(Remotes.Length > 0 && !IsTimerActive(nameof(RetryDetonation))) 
	{
		DetonateCharges();	
	}
	//bDetonatedRemotes = true;
	if(!HasAnyAmmo()) 
	{
		WeaponEmpty();
	}	
}

function byte BestMode()
{
	local Rx_Weapon_DeployedRemoteC4 D;

	if(Remotes.length <= 0)
		return 0;

	if(AmmoCount <= 0)
	{
		foreach Remotes(D)
		{
			if(VSizeSq(Instigator.Location - D.Location) <= 160000 && RemoteDetonationFailure < 3)
			{
				RemoteDetonationFailure++;
				return 0;
			}
		
		}
		return 1;
	}

	return 0;
}

simulated function string GetWeaponTips()
{

	if(Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo) != None)
		return "DEPLOYED COUNT: "$Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo).RemoteC4Number$"/4";

	return "";
}

simulated function string GetWeaponSecondaryTips()
{

	if(Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo) != None && Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo).RemoteC4Number >= 4)
		return ">>>>LIMIT REACHED<<<<";

	return "";
}

simulated function LinearColor GetTipsColor()
{
		if(Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo) != None && Rx_PRI(Pawn(Owner).Controller.PlayerReplicationInfo).RemoteC4Number < 4)
		return MakeLinearColor(0.0,1.0,0.0,1.0);

	return MakeLinearColor(1.0,1.0,0.0,1.0);
}

simulated function LinearColor GetSecondTipsColor()
{
	return MakeLinearColor(1.0,1.0,0.0,1.0);
}

DefaultProperties
{
	DeployedActorClass=class'Rx_Weapon_DeployedRemoteC4'
	bCanGetAmmo=false

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'RX_WP_RemoteC4.Mesh.SK_RemoteC4_1P'
		AnimSets(0)=AnimSet'RX_WP_RemoteC4.Anims.AS_RemoteC4_Weapon'
		Animations=MeshSequenceA
		FOV=50.0
		Scale=1.5
	End Object
	
	ArmsAnimSet = AnimSet'RX_WP_RemoteC4.Anims.AS_RemoteC4_Arms'

	AttachmentClass = class'Rx_Attachment_RemoteC4'
	
	PlayerViewOffset=(X=16.0,Y=0.0,Z=-3.0)
	FireOffset=(X=10,Y=0,Z=-10)
	
	//-------------- Recoil
	RecoilDelay = 0.07
	RecoilSpreadDecreaseDelay = 0.1
	MinRecoil = -100.0
	MaxRecoil = -50.0
	MaxTotalRecoil = 1000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 10.0
	RecoilDeclinePct = 0.5
	RecoilDeclineSpeed = 2.0
	RecoilSpread = 0.0
	MaxSpread = 0.0
	RecoilSpreadIncreasePerShot = 0.015
	RecoilSpreadDeclineSpeed = 0.25

	ShotCost(0)=1
	ShotCost(1)=0
	FireInterval(0)=0.5
	FireInterval(1)=0.5
	
	EquipTime=0.75
//	PutDownTime=0.5
	
	ReloadTime(0) = 0.5
    ReloadTime(1) = 0.5

	WeaponFireTypes(0)=EWFT_Custom
	WeaponFireTypes(1)=EWFT_Custom

    Spread(0)=0.0
	Spread(1)=0.0
	
	ClipSize = 1
	InitalNumClips = 2
	MaxClips = 2
	
	//AmmoCount=2
	//MaxAmmoCount=2
	
	ThirdPersonWeaponPutDownAnim="H_M_C4_PutDown"
	ThirdPersonWeaponEquipAnim="H_M_C4_Equip"

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadAnim3PName(0) = "H_M_C4_Equip"
	ReloadAnim3PName(1) = "H_M_C4_Equip"
	ReloadArmAnimName(0) = "weaponequip"
	ReloadArmAnimName(1) = "weaponequip"

	WeaponFireAnim[0]="WeaponFire"
    WeaponFireAnim[1]="WeaponAltFire"

	bCanPlaceRemoteRightNow=true

	WeaponFireSnd[0]=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Fire'
	WeaponFireSnd[1]=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Fire'

	WeaponPutDownSnd=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Equip'
	ReloadSound(0)=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Equip'
	ReloadSound(1)=SoundCue'RX_WP_TimedC4.Sounds.SC_TimedC4_Equip'

	PickupSound=SoundCue'RX_WP_Shotgun.Sounds.SC_Shotgun_Equip'
 
	MuzzleFlashSocket=MuzzleFlashSocket
	FireSocket=MuzzleFlashSocket

	CrosshairMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_AutoRifle'

	InventoryGroup=4
	GroupWeight=1
	InventoryMovieGroup=24

	WeaponIconTexture=Texture2D'RX_WP_RemoteC4.UI.T_WeaponIcon_RemoteC4'
	
	// AI Hints:
	//MaxDesireability=0.7
	MaxDesireability=0.9
	AIRating=+0.3
	CurrentRating=+0.3
	bFastRepeater=false
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=true
	bSniping=false
	bOkAgainstBuildings=true
	bOkAgainstVehicles=true

	/** one1: Added. */
	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_RemoteC4'
}
