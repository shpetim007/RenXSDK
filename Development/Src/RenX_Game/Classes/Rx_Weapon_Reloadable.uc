class Rx_Weapon_Reloadable extends Rx_Weapon
	abstract;

var() int ClipSize;
var() int InitalNumClips;
var() int MaxClips;
var() int ClientAmmoCount;

var  int CurrentAmmoInClip; //repnotify
var int CurrentAmmoInClipClientside; // localy have a copy of ammo to update immediatly, so independant of lag 
var repnotify bool CurrentlyReloading;
var repnotify bool CurrentlyBoltReloading;

var bool bShowReloadTip;

/**
 * For reload time and Reload Anim name's 
 * 
 *  0 = Primary Fire - No Ammo in the clip
 *  1 = Secondary Fire - No Ammo in the clip
 *  2 = Primary Fire - 1 or more rounds left in the clip
 *  3 = Secondary Fire - 1 or more rounds left in the clip
 */
var() float ReloadTime[4];
var() name ReloadAnimName[4];
var() name ReloadAnim3PName[4];
var() name ReloadArmAnimName[4];
var() SoundCue ReloadSound[4];

//Partial Reload System
var() bool bReloadWhenEmpty;
var bool bUsePartialReload; //Does this make use of a partial reloading system? 
var bool bLoseAmmoOnMagDrop; //When the animation drops the old magazine [Assumed on the 1st notification], do we lose that ammo and have to finish reloading?   
var byte ReloadParts; //Number of parts there are to the reload. Usually 3 (Taking out the magazine. Replacing the Magazine. Charging the weapon)
var byte CurrentReloadPart; 
var array<float> ReloadPointTimes; // Times (of the animation played at 1.0 speed) of the various partial reload states.  //Handled in code through animation notifies
var float	BaseReloadAnimTime; //Pulled from our reload animation. It's the standard length of the animation played at 1x 


var bool	bCanReloadWhileSprinting; //Generally yes for Ren-X. Changeable in mutators if you want 
var bool	bCanReloadWhileFullClip; //Generally yes for Ren-X. Kinda dumb, put that's what community wants I guess - Handepsilon

var bool PerBulletReload;
var int CurrentReloadState;
var float BotDamagePercentage;

var bool bExitADSWhileReloading;

/**
 * For bolt-action reload time and Bolt Reload Anim name's 
 * 
 *  0 = Primary Fire - No Ammo in the clip
 *  1 = Secondary Fire - No Ammo in the clip
 *  2 = Primary Fire - 1 or more rounds left in the clip
 *  3 = Secondary Fire - 1 or more rounds left in the clip
 */
var() name BoltReloadAnimName[2];
var() name BoltReloadAnim3PName[2];
var() name BoltReloadArmAnimName[2];
var() SoundCue BoltReloadSound[2];
var() float BoltReloadTime[2];

// What percentage of the refire time to start the bolt reload. 1 = directly after, 0.5 = half way, 2 = twice the length
var() float RefireBoltReloadInterrupt[2];

var bool BoltActionReload;
var bool bUnzoomDuringBoltActionReloading;

//info for reload animation timing
var float reloadBeginTime;
var float currentReloadTime;

//Used to tell when a refill has occured and stops certain minor tasks from happening until Server and client are synced afterward 
var repnotify bool RefillStateFlag; 

//Veterancy
var bool bRefillonPromotion; 
var int Ammo_Increment; //1 by default. This is used by ammo boxes and veterancy to multiply how many extra clips are given to a weapon on promotion or picking up ammo

var bool bOverrideFireIntervalForReload; //If FALSE then this will wait until the length of fire interval to reload after firing the last shot in the clip
var bool bLimitAmmoForScripted;

// This bool is used to let you reload at almost any time, but just not right when the gun is firing.
// Previous method required you to leave the WeaponFiring state, which just took too long...
var bool bCanReload;

var byte LastFireModeNum;

//returns partial bot damage
simulated function float GetBotDamagePercentage()
{
	return BotDamagePercentage;
}

/**replication
{
	if( bNetDirty && bNetOwner && Role == ROLE_Authority)
		CurrentAmmoInClip, CurrentlyReloading, CurrentlyBoltReloading, CurrentReloadState;
}
*/

replication
{
	//Need only to have info to play animations
	if( bNetDirty && (!bNetOwner || !bUseClientAmmo) && Role == ROLE_Authority)
		CurrentlyReloading, CurrentlyBoltReloading, CurrentReloadState;
	
	if( bNetDirty && bNetOwner && Role == ROLE_Authority)
		RefillStateFlag;
	
	if(!bUseClientAmmo && bNetDirty && bNetOwner && Role == ROLE_Authority)
		CurrentAmmoInClip; 
}

simulated event PreBeginPlay()
{
	SetWeaponFOV();
	//Get our reloading partials 
	if(bUsePartialReload)
		BuildPartialReloadFromAnimation(); 
	
	if(Instigator != none && RxIfc_Veterancy(Instigator.PlayerReplicationInfo) != none)
	{
		ClipSize=default.ClipSize+default.VetRankInfo[VRank].ClipSizeMod;
	}

	AmmoCount = ClipSize * InitalNumClips ;
	ClientAmmoCount = ClipSize * InitalNumClips;
	MaxAmmoCount = ClipSize * MaxClips;
	CurrentAmmoInClip = ClipSize;
	CurrentAmmoInClipClientside = ClipSize;
	bForceNetUpdate = true;
	super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if(SkeletalMeshComponent(Mesh) != None && AnimNodeSequence(SkeletalMeshComponent(Mesh).Animations) != None)
		AnimNodeSequence(SkeletalMeshComponent(Mesh).Animations).bCauseActorAnimEnd = true;
}

simulated event ReplicatedEvent(name VarName)
{
	if ( VarName == 'CurrentlyReloading' ) 
	{
		if(CurrentlyReloading == false) 
		{
			CurrentAmmoInClipClientside = ClipSize;
			PostReloadUpdate();	
			
			//if( (PendingFire(0) && CurrentFireMode == 0) || (PendingFire(1) && CurrentFireMode == 1) ) 
			if( (ClientPendingFire[0] && CurrentFireMode == 0) || (ClientPendingFire[1] && CurrentFireMode == 1) ) 
			{
				RestartWeaponFiringAfterReload();	
			} 
			//else if(!IsInState('WeaponPuttingDown') && !IsInState('Inactive') && !IsInState('Active') && !IsInState('WeaponEquipping')) 
			else
			if(IsInState('Reloading'))
			{
				//`log("Call Active from CR Replication" @ GetStateName() ); 
				GotoState('Active');
			}	
		} 
		else 
		{
			if(bIronsightActivated && UTPlayerController(Instigator.Controller) != None && bExitADSWhileReloading)
			{
				EndZoom(UTPlayerController(Instigator.Controller));
			}
			reloadBeginTime = WorldInfo.TimeSeconds;
			currentReloadTime = ReloadTime[CurrentFireMode]*GetReloadSpeedModifier() ;		
			PlayWeaponReloadAnim();
		}	
    }
	else if ( VarName == 'CurrentlyBoltReloading' ) 
	{
		if(CurrentlyBoltReloading == false) 
		{
			PostReloadUpdate();		
			/** EDIT: Bolt Action weapons ignore pending fire outside of not being able to shoot 
			if( PendingFire(0) || PendingFire(1) ) 
			{
				GotoState('WeaponFiring');	
			} 
			else*/
			if( (ClientPendingFire[0] && CurrentFireMode == 0) || (ClientPendingFire[1] && CurrentFireMode == 1) ) 
			{
				RestartWeaponFiringAfterReload();	
			} 
			//if(!IsInState('WeaponPuttingDown'))  
			if(IsInState('BoltActionReloading'))
			{
				//`log("Call Active from BoltReload Replication" @ GetStateName() ); 
				GotoState('Active');
			}	
		} 
		else 
		{
			if(bIronsightActivated && bUnzoomDuringBoltActionReloading && UTPlayerController(Instigator.Controller) != None)
			{
				EndZoom(UTPlayerController(Instigator.Controller));
			}
			SetTimer(GetFireInterval(CurrentFireMode) * GetROFModifier() * (default.RefireBoltReloadInterrupt[CurrentFireMode]),false,'PlayWeaponBoltReloadAnim');
			reloadBeginTime = WorldInfo.TimeSeconds;
			currentReloadTime = BoltReloadTime[CurrentFireMode];		
		}	
    }
	else if ( VarName == 'RefillStateFlag' ) 
	{
		if(RefillStateFlag) ServerConfirmRefill(); //Got it
	}
	else 
	if (VarName == 'CurrentAmmoInClip')
	{
		/*if(CurrentAmmoInClip < ClipSize)
		{}*/
		
		CurrentAmmoInClipClientside = CurrentAmmoInClip;	
		
		UpdateAmmoCounter();
		if(PerBulletReload && CurrentlyReloading)
		{
			PlayWeaponReloadAnim();		
		}
	}

    else 
    {
    	super.ReplicatedEvent(VarName);
    } 
}

simulated function RestartWeaponFiringAfterReload()
{
	if(IsInState('WeaponEquipping')) 
		return; 
	
	GotoState('Active');	

	if(Rx_Pawn(Owner).DrivenVehicle != None)
	{
		ClientPendingFire[0] = false; 
		ClientPendingFire[1] = false; 
		ClearPendingFire(0); 
		ClearPendingFire(1);
		return;
	}
	
	StartFire(CurrentFireMode); 
	ServerStartFire(CurrentFireMode);
}

simulated function UpdateAmmoCounter(); // Needs overloaded if you need to update on weapon counteres

simulated function PerformRefill()
{
	local bool bDoBoltAction;

	if (bIsCrateWeapon)
		return;

	if(IsInState('Active') && BoltActionReload && !HasAnyAmmoOfType(0))
		bDoBoltAction = true;


	AmmoCount = MaxAmmoCount;
	CurrentAmmoInClip = ClipSize;
	ClientRefill(VRank); 

	if(bDoBoltAction)
		GoToState('BoltActionReloading');
}

reliable client function ClientRefill(optional byte AtVRank) 
{
	local bool bDoBoltAction;
	//`log("Client VRank:" @ VRank @ AtVRank);

	if(AtVRank < VRank)
		return; 

	if(IsInState('Active') && WorldInfo.NetMode == NM_Client && BoltActionReload && !HasAnyAmmoOfType(0))
		bDoBoltAction = true;

	//Refill came in before VRank replicated
	if(AtVRank > VRank) 
	{
		VRank = AtVRank;
		ReplicateVRank();
	}
		

	ClientAmmoCount = MaxAmmoCount ; 
	CurrentAmmoInClip = ClipSize;
	CurrentAmmoInClipClientside = ClipSize;
	

	if(bDoBoltAction)
		GoToState('BoltActionReloading');

	ServerConfirmClientRefill(AtVRank, VRank); 
}

simulated function RestartReloading(float RestartDelay) 
{
	StopWeaponAnimation();
	Rx_Pawn(Owner).TopHalfAnimSlot.StopCustomAnim(0.15);	
	
	if(PerBulletReload)
	{
		ClearTimer('PerBulletReloadWeaponTimer');
	} 
	else
	{
		ClearTimer('ReloadWeaponTimer');
	}
	SetTimer( RestartDelay, false, 'RestartReloadingTimer');
	CurrentlyReloading = false; 
}

simulated function RestartReloadingTimer()
{
	if( CurrentlyBoltReloading && HasAmmo(CurrentFireMode) )
		GotoState('BoltActionReloading',, true);
	else
		GotoState('Reloading',, true);
}

simulated function RefireBlockTimer()
{
	// This function stops you rapid firing shotguns with reload. It exists just for a timer...
	if(PerBulletReload)
		bCanReload = true;
}

simulated state WeaponEquipping
{
	simulated function StartFire(byte FireModeNum)
	{
		LastFireModeNum = FireModeNum;
		SetPendingFire(FireModeNum);
	}
}

simulated state Reloading
{
	simulated function BeginState( name PreviousState )
	{
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".BeginState("$PreviousState$")");
		}
		//Possibly unnecessary. Needs playtest, but also nothing uses this yet 
		if(bUsePartialReload)
			BuildPartialReloadFromAnimation();
		
		if(WorldInfo.Netmode == NM_Client && bUseClientAmmo) 
			NotifyServerOfReload(ClientAmmoCount); //Add audit info
			
		if (PerBulletReload)
		{
			CurrentReloadState = 2;
			SetTimer( ReloadTime[CurrentReloadState]*GetReloadSpeedModifier(), false, 'PerBulletReloadWeaponTimer');
		}
		else if(bUsePartialReload)
		{
			reloadBeginTime = WorldInfo.TimeSeconds;
			currentReloadTime = ReloadTime[CurrentFireMode]*GetReloadSpeedModifier();
			
			if(CurrentReloadPart != 0 && CurrentReloadPart <= ReloadParts)
			{
				if(CurrentAmmoInClip > 0)
					SetTimer(ReloadPointTimes[ReloadParts]*GetReloadSpeedModifier() - (ReloadPointTimes[CurrentReloadPart]*((ReloadTime[CurrentFireMode]*GetReloadSpeedModifier())/ReloadTime[CurrentFireMode])), false, 'ReloadWeaponTimer');
				else
					SetTimer(ReloadTime[CurrentFireMode]*GetReloadSpeedModifier() - (ReloadPointTimes[CurrentReloadPart]*((ReloadTime[CurrentFireMode]*GetReloadSpeedModifier())/ReloadTime[CurrentFireMode])), false, 'ReloadWeaponTimer');
			}
			else if(CurrentReloadPart > ReloadParts)
			{
				ReloadWeaponTimer() ; //Finished, just call it reloaded. 
			}
			else
				SetTimer(ReloadTime[CurrentFireMode]*GetReloadSpeedModifier(), false, 'ReloadWeaponTimer');
			
			//ClearPendingFire(0);
			//ClearPendingFire(1);			
		}
		else
		{
			reloadBeginTime = WorldInfo.TimeSeconds;
			currentReloadTime = ReloadTime[CurrentFireMode]*GetReloadSpeedModifier();
			SetTimer(ReloadTime[CurrentFireMode]*GetReloadSpeedModifier(), false, 'ReloadWeaponTimer');

			//ClearPendingFire(0);
			//ClearPendingFire(1);
		}

		if((bIronsightActivated || GetZoomedState() == ZST_Zoomed) && bExitADSWhileReloading)
		{
			if(WorldInfo.Netmode != NM_DedicatedServer)
			{
				if(UTPlayerController(Instigator.Controller) != None)
				{
					EndZoom(UTPlayerController(Instigator.Controller));
				}
			}
		} 
		CurrentlyReloading = true;
		Rx_Pawn(Owner).SetHandIKEnabled(false);
		PlayWeaponReloadAnim();
	}

	simulated function StartFire(byte FireModeNum)
	{
		LastFireModeNum = FireModeNum;
		if(PerBulletReload && CurrentAmmoInClip > 0 && !IsTimerActive('RefireBlockTimer') )
		{
			CurrentlyReloading = false;
			BeginBeginFire();
		}
		//SetPendingFire(FireModeNum);
		if(!PerBulletReload)
			SetTimer( GetRemainingTimeForTimer('ReloadWeaponTimer'), false, nameof(BeginBeginFire));
	}

	simulated function EndState( name NextState )
	{
		local Rx_Pawn RxP; 
		
		RxP = Rx_Pawn(Owner);
		
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".EndState("$NextState$")");
		}
		
		if((bIronsightActivated || GetZoomedState() != ZST_NotZoomed) && bExitADSWhileReloading) //If for some odd reason we didn't unzoom, zoom out
		{
			//Kill LOG
			//`log(GetZoomedState() != ZST_NotZoomed ); 
			if(WorldInfo.Netmode != NM_DedicatedServer)
			{
				if(UTPlayerController(Instigator.Controller) != None)
				{
					UTPlayerController(Instigator.Controller).EndZoom();
				}
			}
		} 
		
		CurrentlyReloading = false;
			//CurrentlyBoltReloading = false; // if we're just switching weapons, don't suddenly take off the bolt reload. 
		RxP.ReloadAnim = '';
		
		//Resume sprint animations correctly
//		if(RxP.bSprinting)
//		{
//			RxP.BeginSprintAnims();
//		}
			
		RxP.SetHandIKEnabled(true);
		
		ClearTimer('PerBulletReloadWeaponTimer');
		ClearTimer('ReloadWeaponTimer');
	}

	simulated function PerBulletReloadWeaponTimer()
	{
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".PerBulletReloadWeaponTimer()");
		}
		if (CurrentReloadState == 0) // Weapon is lowered
		{
			if(PendingFire(0) || PendingFire(1) )  
			{
				CurrentlyReloading = false;
				GoToState('WeaponFiring');
				return;
			}
			else
			{
				CurrentlyReloading = false;
				GoToState('Active');
				return;
			}
		}
		else if (CurrentReloadState == 1) // Weapon currently reloading
		{
			if (CurrentAmmoInClip < ClipSize && AmmoCount > CurrentAmmoInClip)
			{
				CurrentAmmoInClip++;
				if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) CurrentAmmoInClipClientSide++;
				if (bHasInfiniteAmmo)
				{
					AmmoCount++;
					ClientAmmoCount++; 
				}
				PostReloadUpdate();
			}
			// If the player wants to shoot and has at least one bullet loaded, OR ammo is full, OR all ammo is already reloaded
			if(((PendingFire(0) || PendingFire(1)) && CurrentAmmoInClip > 0) || CurrentAmmoInClip == ClipSize || CurrentAmmoInClip >= AmmoCount) 
			{
				CurrentlyBoltReloading = false; 
				CurrentReloadState = 0;
			}
		}
		else // Weapon is raised
		{
			CurrentReloadState = 1;
		}

		PlayWeaponReloadAnim();
		SetTimer( ReloadTime[CurrentReloadState]*GetReloadSpeedModifier(), false, 'PerBulletReloadWeaponTimer');
	}
	simulated function ReloadWeaponTimer()
	{
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".ReloadWeapon()");
		}

		if (bHasInfiniteAmmo || (Rx_Pawn_Scripted(Owner) != None && !bLimitAmmoForScripted)) 
		{
			AmmoCount = MaxAmmoCount;
			CurrentAmmoInClip = ClipSize ; // default.ClipSize;
			if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) 
			{
				CurrentAmmoInClipClientSide = ClipSize;
				ClientAmmoCount = MaxAmmoCount ; 
			}
		}
		else if( AmmoCount >= ClipSize)  //default.ClipSize )
		{
			if(bLoseAmmoOnMagDrop && CurrentAmmoInClip > 0) // There's a round already in the chamber, so a new full magazine will bring us up to mag size + 1
			{
				CurrentAmmoInClip = ClipSize + 1;
				if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) CurrentAmmoInClipClientSide = ClipSize + 1;
			}
			else
			{
				CurrentAmmoInClip = ClipSize ; //default.ClipSize;
				if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) CurrentAmmoInClipClientSide = ClipSize;
			}
		}
		else
		{
			CurrentAmmoInClip = AmmoCount;
			if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) CurrentAmmoInClipClientSide = AmmoCount;
		}

		CurrentlyReloading = false;
		CurrentlyBoltReloading=false; 
		PostReloadUpdate();
		CurrentReloadPart = 0; //Done reloading 

		if(WorldInfo.NetMode == NM_DedicatedServer && ((PendingFire(0) && CurrentFireMode == 0) || (PendingFire(1) && CurrentFireMode == 1)))
		{
			GotoState('Active');
			BeginFire(CurrentFireMode);
		} 
		else 
		if(bUseClientAmmo && (ClientPendingFire[0] && CurrentFireMode == 0) || (ClientPendingFire[1] && CurrentFireMode == 1))
		{
			RestartWeaponFiringAfterReload();	
		}
		else
		{
			GotoState('Active');
		}
	}

	simulated function bool bReadyToFire()
	{
		return PerBulletReload && AmmoCount != 0;
	}

	// Undo reload
	simulated function PutDownWeapon() 
	{
		ClearTimer('ReloadWeaponTimer');
		ClearTimer('PerBulletReloadWeaponTimer');
		CurrentlyReloading = false;
//		CurrentlyBoltReloading=false; 
		//Finished the last reload... Let the weapon just be reloaded
		if(CurrentReloadPart > ReloadParts)
		{
			ReloadWeaponTimer();
		}			
		super.PutDownWeapon();
	}
	
	//Handle our infantry just having started to sprint 
	simulated function OnActionStart()
	{
		if(bCanReloadWhileSprinting){
			super.OnActionStart();
			return; 
		}
		
		//Can't reload this weapon whilst sprinting. 
		ClearTimer('ReloadWeaponTimer');
		ClearTimer('PerBulletReloadWeaponTimer');
		CurrentlyReloading = false;
		
		//Kill off the reload animation on the owning pawn  
		Rx_Pawn(Owner).TopHalfAnimSlot.StopCustomAnim(0.15);
		//Finished the last reload... Let the weapon just be reloaded
		if(CurrentReloadPart > ReloadParts)
		{
			ReloadWeaponTimer();
		}
		
		global.OnActionStart();
		GoToState('Active');
	}
	
	simulated event bool IsFiring()
	{
		return CurrentlyReloading || CurrentlyBoltReloading;//true;
	}
	
	simulated function Activate(); //Ignore calls to activate while reloading (So no random arms appear behind us)
}

simulated function GoToWeaponFiring()
{
	//`log("Going to weaponFiring state",true);
	gotostate('WeaponFiring');
}

// This will get called after reloading is complete
// in case any weapons need to update displays and such
simulated function PostReloadUpdate();

simulated state Active
{
	simulated function BeginState(Name PrevStateName)
	{
		bCanReload = true;

		if (bCanReloadWhileSprinting || !Rx_Pawn(Owner).bSprinting)
			if( BoltActionReload && !CurrentlyReloading && CurrentlyBoltReloading && HasAmmo(CurrentFireMode) )
				GoToState('BoltActionReloading');

		if(GetWeaponCanReload())
		{
			if(bReloadWhenEmpty && !HasAmmo(CurrentFireMode) && HasAnyAmmoOfType(CurrentFireMode) )
				GoToState('Reloading');
		}
		
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".BeginState("$PrevStateName$")");
		}
		super.BeginState(PrevStateName);
	}

	simulated function EndState( Name NextStateName )
	{
		super.EndState(NextStateName);
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".EndState("$NextStateName$")");
		}
	}

	simulated function bool bReadyToFire()
	{
		return  !IsTimerActive('RefireCheckTimer') && ( !CurrentlyReloading && !CurrentlyBoltReloading) && !bRecoveringFromAction;
	}

	
	
}

simulated function ConsumeAmmo( byte FireModeNum )
{
	CurrentAmmoInClip = fmax(0,CurrentAmmoInClip-ShotCost[FireModeNum]);
	
	if(bUseClientAmmo && WorldInfo.Netmode == NM_Client) 
		ClientAmmoCount =  fmax(0,ClientAmmoCount-ShotCost[FireModeNum]);
	
	super.ConsumeAmmo( FireModeNum );
}

// If this gun has any ammo in current clip it will return true.
simulated function bool HasAmmo( byte FireModeNum, optional int Amount )
{
	/**if( Amount==0 )
	{
		if (CurrentAmmoInClip < ShotCost[FireModeNum]) // || CurrentAmmoInClipClientside < ShotCost[FireModeNum])
			return false;
		else
			return true;
	}
	else*/
	
		if (CurrentAmmoInClip < 1 || CurrentAmmoInClipClientside < 1)
			return false;
		else
			return true;
	
}

// If this gun has any ammo at all it returns true.
simulated function bool HasAnyAmmoOfType( byte FireModeNum )
{
	if(bUseClientAmmo && WorldInfo.NetMode == NM_Client && ClientAmmoCount <= 0)  return false; 
	else
	if( AmmoCount <= 0 ) //(AmmoCount <= 0 )
	{
		return false;
	}
	return true;
}

simulated function PlayWeaponReloadAnim()
{
	local Rx_Pawn OwnerPawn; 
	
	OwnerPawn = Rx_Pawn(Owner); 
	
	if (PerBulletReload)
	{
		PlayWeaponAnimation( ReloadAnimName[CurrentReloadState], ReloadTime[CurrentReloadState]*GetReloadSpeedModifier() );
		PlayArmAnimation( ReloadArmAnimName[CurrentReloadState], ReloadTime[CurrentReloadState]*GetReloadSpeedModifier() );
		if(OwnerPawn != None)
		{
			OwnerPawn.ReloadAnim = ReloadAnim3PName[CurrentReloadState];
			OwnerPawn.TopHalfAnimSlot.PlayCustomAnimByDuration(OwnerPawn.ReloadAnim,ReloadTime[CurrentReloadState]*GetReloadSpeedModifier(),0.1f,0.1f,false,true);
		}
		Instigator.PlaySound( ReloadSound[CurrentReloadState] ,,true);
	}
	else
	{
		if( CurrentFireMode == 0 ) 
		{
			// Primary Fire with no ammo in clip reload animations and sounds
			if( CurrentAmmoInClip == 0 || ReloadAnimName[2] == '' )
			{
				PlayWeaponAnimation( ReloadAnimName[0], ReloadTime[0]*GetReloadSpeedModifier() );
				PlayArmAnimation( ReloadArmAnimName[0], ReloadTime[0]*GetReloadSpeedModifier() );
				if(OwnerPawn != None) {
					OwnerPawn.ReloadAnim = ReloadAnim3PName[0];
					if(bUsePartialReload)
					{
						if(CurrentAmmoInClip > 0)
							OwnerPawn.TopHalfAnimSlot.PlayCustomAnim(OwnerPawn.ReloadAnim, BaseReloadAnimTime/(ReloadTime[0]*GetReloadSpeedModifier()),0.1f,0.1f,false,false, ReloadPointTimes[CurrentReloadPart],ReloadPointTimes[ReloadParts]);
						else
							OwnerPawn.TopHalfAnimSlot.PlayCustomAnim(OwnerPawn.ReloadAnim, BaseReloadAnimTime/(ReloadTime[0]*GetReloadSpeedModifier()),0.1f,0.1f,false,false, ReloadPointTimes[CurrentReloadPart]);
						//`log("Reload Speed:" @ BaseReloadAnimTime/(ReloadTime[0]*GetReloadSpeedModifier()));
					}
					else
						OwnerPawn.TopHalfAnimSlot.PlayCustomAnimByDuration(OwnerPawn.ReloadAnim,ReloadTime[0]*GetReloadSpeedModifier(),0.1f,0.1f,false,false);

				}
				Instigator.PlaySound( ReloadSound[0]  ,,true);
			}
			// Primary Fire with 1 ore more rounds the the clip reload anims and sounds
			else
			{
				PlayWeaponAnimation( ReloadAnimName[2], ReloadTime[2]*GetReloadSpeedModifier() );
				PlayArmAnimation( ReloadArmAnimName[2], ReloadTime[2]*GetReloadSpeedModifier() );
				if(OwnerPawn != None) {
					OwnerPawn.ReloadAnim = ReloadAnim3PName[0];
					OwnerPawn.TopHalfAnimSlot.PlayCustomAnimByDuration(OwnerPawn.ReloadAnim,ReloadTime[0]*GetReloadSpeedModifier(),0.1f,0.1f,false,false);
				}
				Instigator.PlaySound( ReloadSound[2] ,,true);
			}
		}
		else
		{
			// Secondary Fire with no ammo in clip reload animations and sounds
			if( CurrentAmmoInClip == 0 || ReloadAnimName[3] == '' )
			{
				PlayWeaponAnimation( ReloadAnimName[1], ReloadTime[1]*GetReloadSpeedModifier() );
				PlayArmAnimation( ReloadArmAnimName[1], ReloadTime[1]*GetReloadSpeedModifier() );
				if(OwnerPawn != None) {
					OwnerPawn.ReloadAnim = ReloadAnim3PName[1];
					OwnerPawn.TopHalfAnimSlot.PlayCustomAnimByDuration(OwnerPawn.ReloadAnim,ReloadTime[1]*GetReloadSpeedModifier(),0.1f,0.1f,false,false);
				}
				Instigator.PlaySound( ReloadSound[1] ,,true);
			}
			// Secondary Fire with 1 ore more rounds the the clip reload anims and sounds
			else
			{
				PlayWeaponAnimation( ReloadAnimName[3], ReloadTime[3]*GetReloadSpeedModifier() );
				PlayArmAnimation( ReloadArmAnimName[3], ReloadTime[3]*GetReloadSpeedModifier() );
				if(OwnerPawn != None) {
					OwnerPawn.ReloadAnim = ReloadAnim3PName[3];
					//Rx_Pawn(Owner).TopHalfAnimSlot.PlayCustomAnim( Rx_Pawn(Owner).ReloadAnim, 1.0, 0.1, 0.1, false, true );
					OwnerPawn.TopHalfAnimSlot.PlayCustomAnimByDuration(OwnerPawn.ReloadAnim,ReloadTime[3]*GetReloadSpeedModifier(),0.1f,0.1f,false,false);
				}
				Instigator.PlaySound( ReloadSound[3] ,,true);
			}
		}
	}
}

//Special version of PlayWeaponAnimation to allow for partial reloads//
simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local AnimNodeSequence WeapNode;
	local AnimTree Tree;
	
	//AimingWeaponClass call// 
	
	if(Sequence == WeaponIdleAnims[0] && Rx_Pawn(Instigator).bSprinting)
		return;
	bPlayingIdleAnim = false;
	//Super.PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
	
	//Modified call from UTWeapon//
	if (Mesh == None || Mesh.bAttached == false)
	{
		return;
		//Super.PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
	}
	
	//Modified super call from Weapon.uc//
	
	// do not play on a dedicated server
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( SkelMesh == None )
	{
		SkelMesh = SkeletalMeshComponent(Mesh);
	}

	// Check we have access to mesh and animations
	if( SkelMesh == None || GetWeaponAnimNodeSeq() == None )
	{
		return;
	}

	//function PlayAnim(name AnimName, optional float Duration, optional bool bLoop, optional bool bRestartIfAlreadyPlaying = true, optional float StartTime=0.0f, optional bool bPlayBackwards=false)
	
	if(fDesiredDuration > 0.0)
	{
		// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		if(Sequence == ReloadAnimName[0] && bUsePartialReload) 
		{
			SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop,,ReloadPointTimes[CurrentReloadPart]);
		}
		else
			SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);			
	}
	else
	{
		//Try getting an animtree first
		Tree = AnimTree(SkelMesh.Animations);
		if (Tree != None)
		{
			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
		}
		else
		{
			WeapNode = AnimNodeSequence(SkelMesh.Animations);
		}

		WeapNode.SetAnim(Sequence);
		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
	if(!bLoop)
		SetTimer(fDesiredDuration,false,nameof(OnAnimEnd));
	else
		ClearTimer(nameof(OnAnimEnd));
}

//////////

//Special variant for playing arm animations that need to be partial//
simulated function PlayArmAnimation( Name Sequence, float fDesiredDuration, optional bool OffHand, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local Rx_Pawn UTP;
	local SkeletalMeshComponent ArmMeshComp, ArmOverlayComp;
	local AnimNodeSequence WeapNode, ArmOverlayNode;

	// do not play on a dedicated server or if they aren't being seen
	if( WorldInfo.NetMode == NM_DedicatedServer || Instigator == None || !Instigator.IsFirstPerson())
	{
		return;
	}
	
	if(Sequence == ArmIdleAnims[0] && Rx_Pawn(Instigator).bSprinting)
		return;
	
	UTP = Rx_Pawn(Instigator);
	if(UTP == none)
	{
		return;
	}
	if(UTP.bArmsAttached)
	{
		// Choose the right arm
		if(!OffHand)
		{
			ArmMeshComp = UTP.ArmsMesh[0];
			ArmOverlayComp =  UTP.ArmsOverlayMesh[0];
		}
		else
		{
			ArmMeshComp = UTP.ArmsMesh[1];
			ArmOverlayComp =  UTP.ArmsOverlayMesh[1];
		}

		// Check we have access to mesh and animations
		if( ArmMeshComp == None || ArmsAnimSet == none || GetArmAnimNodeSeq() == None )
		{
			return;
		}

		// If we are not specifying a duration, use the default play rate.
		if(fDesiredDuration > 0.0)
		{
			
			// @todo - this should call GetWeaponAnimNodeSeq, move 'duration' code into AnimNodeSequence and use that.
		if(Sequence == ReloadAnimName[0] && bUsePartialReload) 
		{
			ArmMeshComp.PlayAnim(Sequence, fDesiredDuration, bLoop,,ReloadPointTimes[CurrentReloadPart]);
			ArmOverlayComp.PlayAnim(Sequence, fDesiredDuration, bLoop,,ReloadPointTimes[CurrentReloadPart]);
		}
		else
			ArmMeshComp.PlayAnim(Sequence, fDesiredDuration, bLoop);
			ArmOverlayComp.PlayAnim(Sequence, fDesiredDuration, bLoop);
		}
		else
		{
			WeapNode = AnimNodeSequence(ArmMeshComp.Animations);
			ArmOverlayNode = AnimNodeSequence(ArmOverlayComp.Animations);
			WeapNode.SetAnim(Sequence);
			ArmOverlayNode.SetAnim(Sequence);
			WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
			ArmOverlayNode.PlayAnim(bLoop, DefaultAnimSpeed);
		}
	}
}

simulated function ReloadWeapon()
{
	local Rx_Controller controller;
	
	if (Rx_Pawn(Owner) != none)
	{
		controller = Rx_Controller(Rx_Pawn(Owner).Controller);
		
		if(GetWeaponCanReload() && controller != none && controller.DoubleClickDir != controller.eDoubleClickDir.DCLICK_Active)
		{
			ClearTimer('RefireCheckTimer');
			ClearTimer(nameof(BeginBeginFire));
			GotoState('Reloading');
		}
	}
}

simulated function bool GetWeaponCanReload()
{
	if (!bCanReloadWhileSprinting && Rx_Pawn(Owner).bSprinting) 
		return false;

	// If the weapon uses partial reload and does not have magazine + 1 in the chamber, allow a reload - or
	// If the weapon has less than a full magazine and has spare ammo, allow a reload - or if bCanReloadWhileFullClip is enabled (renx)
	// assuming we are not currently reloading, and we in fact can reload this weapon.
	if((CurrentAmmoInClip < (ClipSize + 1) && ( (CurrentAmmoInClip < (AmmoCount + 1)) || CurrentAmmoInClip < AmmoCount) ) && bUsePartialReload && !CurrentlyReloading && bCanReload)
		return true;
	return ((CurrentAmmoInClip < ClipSize && CurrentAmmoInClip < AmmoCount) || bCanReloadWhileFullClip) && !CurrentlyReloading && bCanReload; 
}

simulated function int GetUseableAmmo()
{
	return CurrentAmmoInClip;
}

simulated function int GetMaxAmmoInClip()
{
	return ClipSize;//default.ClipSize;
}

simulated function int GetReserveAmmo()
{
	
	if(bUseClientAmmo && WorldInfo.NetMode == NM_Client) return ClientAmmoCount - CurrentAmmoInClip ;  
	else
	return AmmoCount - CurrentAmmoInClip;

}

simulated function bool IsReloading()
{
	return CurrentlyReloading;
}
simulated function bool IsBoltActionReloading()
{
	return CurrentlyBoltReloading;
}

// Custom Weapon Firing state to handle reloading
simulated state WeaponFiring
{
	simulated event BeginState( Name PreviousState )
	{
		if(GetWeaponCanReload())
		{
			if(bReloadWhenEmpty && CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) )
				GoToState('Reloading');
		}
		if(PerBulletReload)
			bCanReload = false;
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".BeginState("$PreviousState$")");
		}
		super.BeginState(PreviousState);
	}
	
	simulated event EndState( Name NextState )
	{
		if(!PerBulletReload)
			bCanReload = true;
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".EndState("$NextState$")");
		}
		
		ClearTimer( nameof(BoltActionReloadTimer) );
		super.EndState(NextState);
	}

	reliable server function ServerStartFire(byte FireModeNum)
	{
		if(bAutoFire)
		{
			super.ServerStartFire(FireModeNum);
			return;
		}
		if(BoltActionReload)
		{
			if(GetRemainingTimeForTimer('RefireCheckTimer') != -1.f)
				SetTimer(GetRemainingTimeForTimer('RefireCheckTimer')+BoltReloadTime[FireModeNum], false, nameof(BeginBeginFire));
		}
		else
		{
			if(GetRemainingTimeForTimer('RefireCheckTimer') != -1.f)
				SetTimer(GetRemainingTimeForTimer('RefireCheckTimer'), false, nameof(BeginBeginFire));
		}
	}

	// If StartFire wasnt here itd just ignore the request to shoot
	simulated function StartFire(byte FireModeNum)
	{
		if(bReloadWhenEmpty && CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) )
		{
			GotoState('Reloading');
			return;
		}
		LastFireModeNum = FireModeNum;
		SetPendingFire(FireModeNum);
		// Are we already firing a burst?
		if(bIsInBurstFire)
			return;

		if(bAutoFire)
		{
			super.StartFire(FireModeNum);
			return;
		}

		
		// First we check if RefireCheckTimer is running, if it is we use the remaining time to directly call the fire function again.
		if(BoltActionReload)
		{
			if(GetRemainingTimeForTimer('RefireCheckTimer') != -1.f)
				SetTimer(GetRemainingTimeForTimer('RefireCheckTimer')+BoltReloadTime[FireModeNum], false, nameof(BeginBeginFire));
		}
		else
		{
			if(GetRemainingTimeForTimer('RefireCheckTimer') != -1.f)
				SetTimer(GetRemainingTimeForTimer('RefireCheckTimer'), false, nameof(BeginBeginFire));
		}
	}

	/**
	 * We override BeginFire() so that we can check for zooming and/or empty weapons
	 */
	simulated function BeginFire( Byte FireModeNum )
	{
		bCanReload = false;
		if ( CheckZoom(FireModeNum) )
		{
			return;
		}

		Global.BeginFire(FireModeNum);

		// No Ammo, then do a quick exit.
		if( !HasAnyAmmoOfType(FireModeNum) )
		{
			WeaponEmpty();
			return;
		}
		if(!PerBulletReload)
			bCanReload = true;
	}

	simulated function TimeWeaponFiring( byte FireModeNum )
	{
		// This timer and associated function stop you rapid firing shotguns with reload
		SetTimer(GetFireInterval(FireModeNum), false, 'RefireBlockTimer');
		if( BoltActionReload && !IsTimerActive('BoltActionReloadTimer') )
		{
			CurrentlyBoltReloading = true;
			SetTimer( GetFireInterval(FireModeNum) * GetROFModifier() * RefireBoltReloadInterrupt[FireModeNum] , false, nameof(BoltActionReloadTimer) );
		}
		else 
		{
			if(CurrentAmmoInClip <= 0 && bOverrideFireIntervalForReload && GetFireInterval(FireModeNum) >= 0.5)
			{
				if( !IsTimerActive('RefireCheckTimer') )
				{
					SetTimer( 0.5*GetROFModifier(), true, nameof(RefireCheckTimer) );
					//SetTimer( GetFireInterval(FireModeNum), true, nameof(RefireCheckTimer) );
				}
			} 
			Global.TimeWeaponFiring(FireModeNum);
		}
	}

	/**
	 * Timer event, call is set up in Weapon::TimeWeaponFiring().
	 * The weapon is given a chance to evaluate if another shot should be fired.
	 * This event defines the weapon's rate of fire.
	 */
	simulated function RefireCheckTimer()
	{
		//`log("RefireCheck" @ bWeaponPutDown @ ShouldRefire());
		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			PutDownWeapon();
			return;
		}


		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			FireAmmunition();
			return;
		}
		
		if(bReloadWhenEmpty && CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) )
		{
			
			GotoState('Reloading');
			return;
		}

		// Otherwise we're done firing
		HandleFinishedFiring();
	}
	
	
	simulated function bool bReadyToFire()
	{
		
		if(!bAutoFire) 
			return  !IsTimerActive('RefireCheckTimer');
		else
			return true; 
	}
}

simulated function BeginBeginFire()
{
	ServerStartFire(LastFireModeNum);
	if(WorldInfo.NetMode == NM_Client) // so that we don't trigger the function twice in standalone or listen server
		BeginFire(LastFireModeNum);
}

reliable server function ServerStopFire(byte FireModeNum)
{
	clearTimer(nameof(GoToWeaponFiring));
	clearTimer(nameof(BeginBeginFire));
	super.ServerStopFire(FireModeNum); 
}

simulated function StopFire(byte FireModeNum)
{
	clearTimer(nameof(GoToWeaponFiring));
	clearTimer(nameof(BeginBeginFire));
	super.StopFire(FireModeNum); 
}

simulated function BoltActionReloadTimer()
{
	if (bDebugWeapon)
	{
		//`log("BoltActionReloadTimer");
	}
	
	//Once Bolt Action reloading is instated, disallow holding down the fire button. 
	/**ClientPendingFire[0] = false; 
	ClientPendingFire[1] = false; 
	ClearPendingFire(0); 
	ClearPendingFire(1);*/  
	
	if(!BoltActionReload)
		return;
	if( HasAmmo(CurrentFireMode) )
		GotoState('BoltActionReloading');
	else 
		RefireCheckTimer();
}

simulated state BoltActionReloading
{
	simulated function BeginState( name PreviousState )
	{
		if(GetWeaponCanReload())
		{
			if(bReloadWhenEmpty && CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) )
				GoToState('Reloading');
		}
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".BeginState("$PreviousState$")");
		}
		
		  if(WorldInfo.NetMode == NM_StandAlone || WorldInfo.NetMode == NM_Client)
        {
        	PlayWeaponBoltReloadAnim();
//        	PlaySound( BoltReloadSound[CurrentFireMode], false,true);
        }
		
		reloadBeginTime = WorldInfo.TimeSeconds;
		currentReloadTime = BoltReloadTime[CurrentFireMode];
		SetTimer( BoltReloadTime[CurrentFireMode], false, 'ReloadWeaponTimer');
	
		
		if(bIronsightActivated && bUnzoomDuringBoltActionReloading)
		{
			if(WorldInfo.Netmode != NM_DedicatedServer)
			{
				if(UTPlayerController(Instigator.Controller) != None)
				{
					EndZoom(UTPlayerController(Instigator.Controller));
				}
			}
		} 
		CurrentlyBoltReloading = true;
		
		
	}

	 simulated function EndState( name NextState )
	{
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".EndState("$NextState$")");
		}
		Rx_Pawn(Owner).SetHandIKEnabled(true);
		Rx_Pawn(Owner).BoltReloadAnim = '';
		ClearTimer('ReloadWeaponTimer');
	}

	simulated function StartFire(byte FireModeNum)
	{
		LastFireModeNum = FireModeNum;
		if(PerBulletReload && CurrentAmmoInClip > 0 && !IsTimerActive('RefireBlockTimer') )
		{
			CurrentlyReloading = false;
			BeginBeginFire();
		}
		//SetPendingFire(FireModeNum);
		if(!PerBulletReload)
			SetTimer( GetRemainingTimeForTimer('ReloadWeaponTimer'), false, nameof(BeginBeginFire));
	}

	simulated function ReloadWeaponTimer()
	{
		if (bDebugWeapon)
		{
			`log("---"@self$"."$GetStateName()$".ReloadWeapon()");
		}

		CurrentlyBoltReloading = false;
		ClearTimer( nameof(BoltActionReloadTimer) );
		PostReloadUpdate();

		if(WorldInfo.NetMode == NM_DedicatedServer && ((PendingFire(0) && CurrentFireMode == 0) || (PendingFire(1) && CurrentFireMode == 1)))
		{
			GotoState('Active');
			BeginFire(CurrentFireMode);
		} 
		else
		if( bUseClientAmmo && ((ClientPendingFire[0] && CurrentFireMode == 0) || (ClientPendingFire[1] && CurrentFireMode == 1))) 
		{
			RestartWeaponFiringAfterReload(); 
		}
		else
		{
			GotoState('Active');
		}
	}

	simulated function bool bReadyToFire()
	{
		return false ; //return true;
	}
	
	simulated function BeginFire( Byte FireModeNum )
	{
		/**if ( FireModeNum == 0 )
		{
			return;
		}*/
		global.BeginFire(FireModeNum);
	}	

	// Undo reload
	simulated function PutDownWeapon() 
	{
		ClearTimer('ReloadWeaponTimer');
		super.PutDownWeapon();
	}
	
	simulated function OnActionStart()
	{
		if(bCanReloadWhileSprinting){
			super.OnActionStart();
			return; 
		}
		
		//Can't reload this weapon whilst sprinting. 
		ClearTimer('ReloadWeaponTimer');
				//Kill off the reload animation on the owning pawn  
		Rx_Pawn(Owner).TopHalfAnimSlot.StopCustomAnim(0.15);
		//Finished the last reload... Let the weapon just be reloaded		
		global.OnActionStart();
		GoToState('Active');
	}
	
	simulated event bool IsFiring()
	{
		return false;
	}
}

simulated function PlayWeaponBoltReloadAnim()
{
	if(BoltActionReload && HasAmmo(CurrentFireMode) && bZoomedFireMode[CurrentFireMode] == 0)
	{

		PlayWeaponAnimation( BoltReloadAnimName[CurrentFireMode], BoltReloadTime[CurrentFireMode] );
		PlayArmAnimation( BoltReloadArmAnimName[CurrentFireMode], BoltReloadTime[CurrentFireMode] );
		if(Rx_Pawn(Owner) != None) 
		{
			Rx_Pawn(Owner).BoltReloadAnim = BoltReloadAnim3PName[CurrentFireMode];
			Rx_Pawn(Owner).TopHalfAnimSlot.PlayCustomAnimByDuration(Rx_Pawn(Owner).BoltReloadAnim, BoltReloadTime[CurrentFireMode],0.1f,0.1f,false,true);
		}
		//PlaySound( BoltReloadSound[CurrentFireMode], false,true);
		Instigator.PlaySound( BoltReloadSound[CurrentFireMode] );
	}
}

simulated function ActiveRenderOverlays( HUD H )
{
   local PlayerController PC;
   PC = PlayerController(Instigator.Controller);
   
   if (bCanLock && bLockedOnTarget && (LockedTarget != None) && (Instigator != None) && WorldInfo.NetMode != NM_DedicatedServer) 
   {
      if ( ((LocalPlayer(PC.Player) == None) || !LocalPlayer(PC.Player).GetActorVisibility(LockedTarget))) 
      {
          DrawCrosshair(H);
          return;
      }
      else 
      {
         DrawLockedOn( H );
      }
   }
   else 
   {
   	  DrawCrosshair(H);
      bWasLocked = false;
   }
}

simulated function DrawHitIndicator(HUD H, float x, float y)
{
	local vector2d CrosshairSize;
	local float XResScale, MinDotScale;
	local LinearColor LC; 
	
	if(Rx_Hud(H).GetHitEffectAplha() <= 0.0) {
		return;
	}	
	
	LC=Rx_Hud(H).HitMarker_Color;
	
	XResScale = H.Canvas.SizeX/1920.0;
	MinDotScale = Fmax(XResScale, 0.73);
	
    CrosshairSize.Y = default.CrosshairHeight * MinDotScale;
    CrosshairSize.X = default.CrosshairWidth * MinDotScale;
    H.Canvas.SetPos(x, y);
	HitIndicatorCrosshairMIC2.SetVectorParameterValue('Reticle_Colour', LC);
    HitIndicatorCrosshairMIC2.SetScalarParameterValue('Reticle_Opacity', Rx_Hud(H).GetHitEffectAplha()/100.0);
    H.Canvas.DrawMaterialTile(HitIndicatorCrosshairMIC2,CrosshairSize.X, CrosshairSize.Y,0.0,0.0,1.0,1.0);
}

/**
 * Draw the Crosshairs
 * halo2pac - implemented code that changes crosshair color based on whats targeted.
 **/
simulated function DrawCrosshair( Hud HUD )
{
	local float x,y;
	local UTHUDBase H;
	local Pawn MyPawnOwner;
	local actor TargetActor;
	local int targetTeam;
	local LinearColor LC; //nBab
	local float XResScale, MinDotScale;

	local vector ScreenLoc; 

	local bool bTargetBehindUs;
	
	local float TweenPercentage;

	local Rotator LockOnRotation;
	local Vector LockPosNormal;
	local Vector LockPos[4];
	local int i;	
	
	if(PendingLockedTargetTime == 0.0)
		TweenPercentage = 0.f;
	else
	{
		TweenPercentage = 1.f - FClamp(((PendingLockedTargetTime - WorldInfo.TimeSeconds) / LockAcquireTime), 0.0, 1.0);

	}

	//set initial color based on settings (nBab)
	LC.A = 1.f;
	switch (Rx_HUD(Rx_Controller(Instigator.Controller).myHUD).SystemSettingsHandler.GetCrosshairColor())
	{
		//white
		case 0:
			LC.R = 1.f;
			LC.G = 1.f;
			LC.B = 1.f;
			break;
		//orange
		case 1:
			LC.R = 2.f;
			LC.G = 0.5f;
			LC.B = 0.f;
			break;
		//violet
		case 2:
			LC.R = 2.f;
			LC.G = 0.f;
			LC.B = 2.f;
			break;
		//blue
		case 3:
			LC.R = 0.f;
			LC.G = 0.f;
			LC.B = 2.f;
			break;
		//cyan
		case 4:
			LC.R = 0.f;
			LC.G = 2.f;
			LC.B = 2.f;
			break;	
	}	

	H = UTHUDBase(HUD);
	if ( H == None )
		return;
		
	XResScale = H.Canvas.SizeX/1920.0;
	MinDotScale = Fmax(XResScale, 0.73); //Under this, the dot will not render 

	if(bCrosshairOpacitySprintDodge && Rx_Pawn(Owner) != none && (Rx_Pawn(Owner).bSprinting || Rx_Pawn(Owner).bDodging))
    {
			CrosshairMIC2.SetScalarParameterValue('Reticle_Opacity', 0.0);
			CrosshairDotMIC2.SetScalarParameterValue('Reticle_Opacity', 1.0);
	}
	else
	{
			CrosshairMIC2.SetScalarParameterValue('Reticle_Opacity', 1.0);
			CrosshairDotMIC2.SetScalarParameterValue('Reticle_Opacity', 1.0);
	}

	CrosshairWidth = ((default.CrosshairWidth + RecoilSpread*RecoilSpreadCrosshairScaling)*ActionCrosshairModifier) * XResScale;	
	CrosshairHeight = ((default.CrosshairHeight + RecoilSpread*RecoilSpreadCrosshairScaling)*ActionCrosshairModifier) * XResScale;
		
	CrosshairLinesX = H.Canvas.ClipX * 0.5 - (CrosshairWidth * 0.5);
	CrosshairLinesY = H.Canvas.ClipY * 0.5 - (CrosshairHeight * 0.5);	
	
	MyPawnOwner = Pawn(Owner);
	
	//determines what we are looking at and what color we should use based on that.
	if (MyPawnOwner != None)
	{
		TargetActor = Rx_Hud(HUD).GetActorWeaponIsAimingAt();
		
		if(RxIfc_Targetable(TargetActor) != None)
		{
			targetTeam = TargetActor.GetTeamNum();
			
			if (targetTeam == 0 || targetTeam == 1) //has to be gdi or nod player
			{
				if (targetTeam != MyPawnOwner.GetTeamNum() && (bRevealSpies() || !RxIfc_Targetable(TargetActor).IsSpyTarget()))
				{
					if (!TargetActor.IsInState('Stealthed') && !TargetActor.IsInState('BeenShot'))
					{
						//enemy, go red, except if stealthed (else would be cheating ;] )
						//nBab
						LC.R = 10.f;
						LC.G = 0.f;
						LC.B = 0.f;
					}
				}
				else
				{
					//Friendly
					//nBab
					LC.R = 0.f;
					LC.G = 10.f;
					LC.B = 0.f;
				}
			}
		}
	}
	
	if (!HasAnyAmmo()) //no ammo, go yellow
	{
		//nBab
		LC.R = 10.f;
		LC.G = 8.f;
		LC.B = 0.f;
	}
	else
	{
		if (CurrentlyReloading || CurrentlyBoltReloading || (BoltActionReload && HasAmmo(CurrentFireMode) && IsTimerActive('BoltActionReloadTimer'))) //reloading, go yellow
		{
			//nBab
			LC.R = 10.f;
			LC.G = 8.f;
			LC.B = 0.f;
		}
	}

	//nBab
	CrosshairMIC2.SetVectorParameterValue('Reticle_Colour', LC);
	CrosshairDotMIC2.SetVectorParameterValue('Reticle_Colour', LC);
	if(ADSCrosshairMIC2 != None)
		ADSCrosshairMIC2.SetVectorParameterValue('Reticle_Colour', LC);
	
	H.Canvas.SetPos( CrosshairLinesX, CrosshairLinesY );
	if(bDisplayCrosshair) 
	{
		if(bIronsightActivated && ADSCrosshairMIC2 != None)
			H.Canvas.DrawMaterialTile(ADSCrosshairMIC2, CrosshairWidth, CrosshairHeight);
					
		else if(!bIronsightActivated || bDisplayCrosshairInIronsight || Rx_Controller(Rx_Pawn(Instigator).Controller).bBehindView)
			H.Canvas.DrawMaterialTile(CrosshairMIC2, CrosshairWidth, CrosshairHeight);

		if(PendingLockedTarget != none)
		{
			bTargetBehindUs = class'Rx_Utils'.static.OrientationOfLocAndRotToBLocation(Rx_Controller(Instigator.Controller).ViewTarget.Location,Instigator.Controller.Rotation,PendingLockedTarget.location) < -0.5;
				
			if(!bTargetBehindUs && TargetMIC2 != None)
			{
				LC.R = 1.f;
				LC.G = 10.f;
				LC.B = 1.f;
				CrosshairMIC2.SetVectorParameterValue('Reticle_Colour', LC);

				LC.G = 1.f;
				TargetMIC2.SetVectorParameterValue('Reticle_Colour', LC);
				ScreenLoc = PendingLockedTarget.GetTargetLocation(); 
				ScreenLoc = H.Canvas.Project(ScreenLoc);
				for(i=0;i<4;i++)
				{
					LockOnRotation.Pitch = 0.f;
					LockOnRotation.Roll = 0.f;
					LockOnRotation.Yaw = ((45.f + (90.f * i)) * DegToUnrRot) + (Lerp(-90.0 * DegToUnrRot, 0, TweenPercentage));
					LockPosNormal = Vector(LockOnRotation);


					LockPos[i].X = ScreenLoc.X + (-1 * LockOnSize/2) + (-0.72 * LockOnSize * LockPosNormal.X) + (-1 * (LockOnSize * (1.0 - TweenPercentage)) * LockPosNormal.X);
					LockPos[i].Y = ScreenLoc.Y + (-1 * LockOnSize/2) + (-0.72 * LockOnSize * LockPosNormal.Y) + (-1 * (LockOnSize * (1.0 - TweenPercentage)) * LockPosNormal.Y);

					LockOnRotation.Yaw -= (45.f * DegToUnrRot);

					H.Canvas.SetPos( LockPos[i].X, LockPos[i].Y );
					H.Canvas.DrawRotatedMaterialTile(TargetMIC2, LockOnRotation,LockOnSize, LockOnSize);	
				}				
			}
		}
				
	}

	CrosshairLinesX = H.Canvas.ClipX * 0.5 - (default.CrosshairWidth * 0.5 * MinDotScale);
	CrosshairLinesY = H.Canvas.ClipY * 0.5 - (default.CrosshairHeight * 0.5 * MinDotScale);
	GetCrosshairDotLoc(x, y, H);
	H.Canvas.SetPos( X, Y );
	if(bDisplayCrosshair) 
	{
		H.Canvas.DrawMaterialTile(CrosshairDotMIC2, default.CrosshairWidth*MinDotScale, default.CrosshairHeight*MinDotScale);
	}
	DrawHitIndicator(H,x,y);

	if(bDebugWeapon)
	{
		if(Rx_Pawn(MyPawnOwner).PassiveAbilities[0] != none) 
			H.Canvas.DrawText("JJ FUEL: " @ Rx_Pawn(MyPawnOwner).PassiveAbilities[0].CurrentCharges ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Reloading: " @ CurrentlyReloading ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("CurrentReloadState" @ CurrentReloadState,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Accuracy:" @ (Rx_Controller(MyPawnOwner.Controller).Acc_Hits/Rx_Controller(MyPawnOwner.Controller).Acc_Shots)*100.0 $ "%",true,1,1);
		Y+=20;
		H.Canvas.DrawText("PendingFire:" @ PendingFire(0),true,1,1);
		Y+=20;
		H.Canvas.DrawText("PendingAltFire:" @ PendingFire(1),true,1,1);
		Y+=20;
		H.Canvas.DrawText("ClientPendingFire:" @ ClientPendingFire[0],true,1,1);
		Y+=20;
		H.Canvas.DrawText("CurrentlyBoltReloading: " @ CurrentlyBoltReloading,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Has Ammo:" @ HasAmmo(0),true,1,1);
		Y+=20;
		H.Canvas.DrawText("State" @ GetStateName(),true,1,1);
		Y+=20;
		H.Canvas.DrawText("ZoomedState" @ GetZoomedState() ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Ironsight Activated" @ bIronsightActivated ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Pawn VEl:" @ Rx_Pawn(MyPawnOwner).Velocity ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Pawn Acc:" @ Rx_Pawn(MyPawnOwner).Acceleration ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Pawn Eyeheight:" @ Rx_Pawn(MyPawnOwner).Eyeheight ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Camera Old Z:" @ Rx_Pawn(MyPawnOwner).OldZ ,true,1,1);
		Y+=20;
		H.Canvas.DrawText("Pawn Mesh Translation Z:" @ Rx_Pawn(MyPawnOwner).Mesh.Translation.Z ,true,1,1);
		
		

	}
	
}


/**
 * Called when the weapon runs out of ammo during firing
 */
simulated function WeaponEmpty()
{
	if (bDebugWeapon) 
	{
		`log("---"@self$"."$GetStateName()$".WeaponEmpty()"@IsFiring()@Instigator@Instigator.IsLocallyControlled());
	}

	// If we were firing, stop
	if ( IsFiring() )
	{
		GotoState('Active');
	}

	
	if ( (Rx_Weapon_Deployable(self) != None || Rx_Weapon_Airstrike(Self) != None) && Instigator != none && Instigator.IsLocallyControlled() )
	{
		Instigator.InvManager.SwitchToBestWeapon( true );
	}
}

function PromoteUnit(byte rank, optional bool bInitial)
{
	super.PromoteUnit(rank);
	ClipSize=default.ClipSize+default.VetRankInfo[rank].ClipSizeMod; 
	//CurrentAmmoInClip  = default.ClipSize+default.VetRankInfo[rank].ClipSizeMod;
	MaxAmmoCount = (default.ClipSize+default.VetRankInfo[rank].ClipSizeMod) * MaxClips;
	//if(bRefillonPromotion) PerformRefill();
	if(bInitial)
	{
		PerformRefill();
	}	
}

reliable server function NotifyServerOfReload(int Count) //deviation integer
{
//local int DeviInt;
//`log("Thing and stuff: " @ UTPawn(Instigator).CurrentWeaponAttachment);
//Add log of difference
if(!bHasInfiniteAmmo) 
	{
	//DeviInt = AmmoCount - Count ; 
	//`log("---------Weapon" @ self @ "Reload with ammo deviation of " @ DeviInt @ "---------") ;
	if(AmmoCount > Count && !RefillStateFlag) AmmoCount = Count; //Server lost traffic somewhere. or there's a culprit I don't know about somewhere.
	}
	
	GoToState('Reloading');	

}

reliable server function ServerConfirmRefill()
{
	RefillStateFlag = false; //Refill is done, continue reload syncs 
}

reliable client function ClientUpdateAmmoCount(int Amount)
{
	ClientAmmoCount=Amount;
}

simulated function bool IgnoreAmmoPickup()
{
	return bHasInfiniteAmmo;
}

simulated function float GetReloadSpeedModifier()
{
	if(Rx_Controller(Instigator.Controller) != none) 
		return default.VetRankInfo[VRank].ReloadSpeedMod+Rx_Controller(Instigator.Controller).Misc_ReloadSpeedMod; 
	else
	if(Rx_Bot(Instigator.Controller) != none) 
		return default.VetRankInfo[VRank].ReloadSpeedMod+Rx_Bot(Instigator.Controller).Misc_ReloadSpeedMod; 
	else
		return 1.0; 
}

simulated function ReplicateVRank()
{
	//Psuedo promote client side 
	if(Rx_Weapon_RepairGun(self) == none)
	{
		ClipSize=default.ClipSize+default.VetRankInfo[VRank].ClipSizeMod; 
		//CurrentAmmoInClip  = default.VetRankInfo[VRank].ClipSizeMod;
		MaxAmmoCount = (default.ClipSize+default.VetRankInfo[VRank].ClipSizeMod) * MaxClips;
		if(bRefillonPromotion ) PerformRefill(); //don't refill deployables. 
	}
	super(Rx_Weapon).ReplicateVRank();
}

/////////////////////////////
//Partial Reload functions//
////////////////////////////

simulated function SetRestartReloadPoint(); //Null notification

simulated function TickPartialReload()
{
	if(bUsePartialReload)
	{
		if(bLoseAmmoOnMagDrop && CurrentReloadPart == 1)
		{
			if(CurrentAmmoInClip > 0)
			{
				ClientAmmoCount -= CurrentAmmoInClip-1;
				CurrentAmmoInClip = 1;
			}
		
			//if(bUseClientAmmo && WorldInfo.Netmode == NM_Client) 
			//	ClientAmmoCount =  0;
		}

		//if(CurrentReloadPart <= ReloadParts)
		CurrentReloadPart+=1;
		//else
			//CurrentReloadPart=0 ; 

		//`log(CurrentReloadPart); 
	}
}

simulated function BuildPartialReloadFromAnimation()
{
	local AnimSequence 	ReloadSeq, ReloadSeq3P;
	local int			i;
	local float			LastNotifyTime;	
	local string		NotificationStr;
	
	//Reset global variables
	LastNotifyTime = 0; 
	
	ReloadSeq = SkeletalMeshComponent(Mesh).FindAnimSequence(ReloadAnimName[0]);
	
	ReloadSeq3P = Rx_Pawn(Owner).Mesh.FindAnimSequence(ReloadAnim3PName[0]);
	
	//Update the global variable to tell us how many partial reload notifiers are in the reload animation
	ReloadParts = 0;
	//Reset reload times 
	ReloadPointTimes.Length = 0; 
	
	ReloadPointTimes.AddItem(0.0); //Always have 0 1st
	
	//BaseReloadAnimTime = ReloadSeq.SequenceLength; //Length of this animation at rate 1.0 
	
	BaseReloadAnimTime = ReloadSeq3P.SequenceLength;
	
	//`log(BaseReloadAnimTime); 

	
	for(i=0;i < ReloadSeq.Notifies.Length;i++)
	{
		NotificationStr = string(ReloadSeq.Notifies[i].Notify.name) ; 
		if(InStr(Caps(NotificationStr), "SCRIPT") != -1)
		{
			LastNotifyTime = ReloadSeq.Notifies[i].Time;
			ReloadPointTimes.AddItem(LastNotifyTime); 
			ReloadParts+=1; //Number of reloading parts
			//`log(ReloadSeq @ LastNotifyTime);
		}
	}
	if(ReloadParts == 0)
		bUsePartialReload = false; // Weapon does not have the proper notifications setup, so just go back to being a normal reload
}

simulated function RecoverFromActionTimer(){
	bRecoveringFromAction = false;
	
	if(bReloadWhenEmpty && CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) )
		{
			GotoState('Reloading');
			return;
		}
	
	//Start fire if we had the button held down 
	if((ClientPendingFire[0] && CurrentFireMode == 0) || (ClientPendingFire[1] && CurrentFireMode == 1))
	{
		StartFire(CurrentFireMode);  	
		ServerStartFire(CurrentFireMode);
	}
}

simulated function StartFire(byte FireModeNum)
{
	LastFireModeNum = FireModeNum;

	if(CurrentAmmoInClip <= 0 && HasAnyAmmoOfType(CurrentFireMode) && !IsInState('Reloading') && !IsInState('WeaponPuttingdown'))
	{
		GoToState('Reloading');
	}
		
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		if( Role < Role_Authority )
		{
			// if we're a client, synchronize server
			ServerStartFire(FireModeNum);
		}

		// Start fire locally
		BeginBeginFire();
	}
	return; 
	
	if( Instigator == None || !Instigator.bNoWeaponFiring )
	{
		
		//if(Rx_Weapon_Reloadable(self) !=none && Rx_Weapon_Reloadable(self).CurrentlyBoltReloading) return; //Don't accept Startfire commands when bolt reloading
		
		ClientPendingFire[FireModeNum]=true; 
		
		if(bReadyToFire() && !bRecoveringFromAction && (Role < Role_Authority || WorldInfo.NetMode == NM_StandAlone || WorldInfo.NetMode == NM_ListenServer))
		{
			// if we're a client, synchronize server
			//`log("Sending Fire Request"); 
			BeginBeginFire();
			return;
		}

		// Start fire locally
		//if(ROLE == Role_Authority) BeginFire(FireModeNum);
	}
}

simulated function bool DisallowSprintAnim()
{
	if(CurrentlyReloading || CurrentlyBoltReloading)
		return true;

	return false;
}

function SetWeaponFOV()
{
	if(Rx_Bot(Instigator.Controller) == none && Rx_Controller(Instigator.Controller) != none)
	{
		if(UDKSkeletalMeshComponent(Mesh) != None)
			UDKSkeletalMeshComponent(Mesh).setFov(Rx_Controller(Instigator.Controller).WeaponFOV);
		if(UDKSkeletalMeshComponent(OverlayMesh) != None)
			UDKSkeletalMeshComponent(OverlayMesh).setFov(Rx_Controller(Instigator.Controller).WeaponFOV);
	}
}

simulated function PlayWeaponEquip()
{
	SetWeaponFOV();
	super.PlayWeaponEquip();
}

DefaultProperties
{
	ReloadTime(0) = 1.0f
	ReloadTime(1) = 1.0f
	ReloadAnim3PName(0) = "H_M_Autorifle_Reload"
	ReloadAnim3PName(1) = "H_M_Autorifle_Reload"
	bDebugWeapon = false
	RefillStateFlag = false; 
	bUseClientAmmo = true ; 
	bOverrideFireIntervalForReload = true //Don't wait too long on weapons with long fire times 

	bShowReloadTip=true

	bExitADSWhileReloading = true
	
	BoltActionReload=false
	BoltReloadTime(0) = 1.0f
	BoltReloadTime(1) = 1.0f
	RefireBoltReloadInterrupt(0) = 0.25f
	RefireBoltReloadInterrupt(1) = 0.25f
	BoltReloadAnimName(0) = "WeaponBolt"
	BoltReloadAnimName(1) = "WeaponBolt"
	BoltReloadAnim3PName(0) = "H_M_BoltReload"
	BoltReloadAnim3PName(1) = "H_M_BoltReload"
	BoltReloadArmAnimName(0) = "WeaponBolt"
	BoltReloadArmAnimName(1) = "WeaponBolt"
	BoltReloadSound(0)=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Reload'
	BoltReloadSound(1)=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Reload'

	PerBulletReload = false;
	bCanReloadWhileSprinting = true 
	bCanReloadWhileFullClip = true
	
	bHasInfiniteAmmo = false;
	
	//Partial Reload System
	bUsePartialReload = false
	bLoseAmmoOnMagDrop = false	
	ReloadParts = 0
	CurrentReloadPart = 0

	/*-------------------------*/
	/* Weapon Veterancy Block */
	/*-------------------------*/

	//RECRUIT
	VetRankInfo(0)= (DamageModifier = 1.0, ROFModifier = 1.0, BuildingDamageMod = 1.0, InfantryDamageMod = 1.0, RangeModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(1)= (DamageModifier = 1.025, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(2)= (DamageModifier = 1.05, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)

	//Veterans
	VetRankInfo(3)= (DamageModifier = 1.10, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(4)= (DamageModifier = 1.125, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(5)= (DamageModifier = 1.15, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)

	//ELITE
	VetRankInfo(6)= (DamageModifier = 1.25, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(7)= (DamageModifier = 1.30, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)
	VetRankInfo(8)= (DamageModifier = 1.35, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)

	//HEROIC
	VetRankInfo(9)= (DamageModifier = 1.50, ROFModifier = 1.0, ClipSizeMod = 0, ReloadSpeedmod = 1.0)

	/*-------------------------*/
	/* End Veterancy		   */
	/*-------------------------*/

	bRefillonPromotion = false //(Only Refills on big promotions)True for most weapons
	Ammo_Increment = 1
	
	bReloadWhenEmpty = true
}
