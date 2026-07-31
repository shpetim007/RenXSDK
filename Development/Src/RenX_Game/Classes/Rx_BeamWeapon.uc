/*********************************************************
*
* File: RxWeapon.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_BeamWeapon extends Rx_Weapon_Reloadable
	abstract; 

/** The Particle System Template for the Beam */
var particleSystem BeamTemplate[2];

/** Holds the Emitter for the Beam */
var ParticleSystemComponent BeamEmitter[2];

/** Where to attach the Beam */
var name BeamSockets[2];

/** The name of the EndPoint parameter */
var name EndPointParamName;

/** Animations to play before firing the beam */
var name	BeamPreFireAnim[2];
var name	BeamFireAnim[2];
var name	BeamPostFireAnim[2];

var ForceFeedbackWaveform	BeamWeaponFireWaveForm;
var vector CurrHitLocation;
var Actor PrevHitActor;

var float WeaponTick;

simulated function AddBeamEmitter()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (BeamEmitter[CurrentFireMode] == None)
		{
			if (BeamTemplate[CurrentFireMode] != None)
			{
				BeamEmitter[CurrentFireMode] = new(Outer) class'UTParticleSystemComponent';
				BeamEmitter[CurrentFireMode].SetDepthPriorityGroup(SDPG_Foreground);
				BeamEmitter[CurrentFireMode].SetTemplate(BeamTemplate[CurrentFireMode]);
				BeamEmitter[CurrentFireMode].SetHidden(true);
				BeamEmitter[CurrentFireMode].SetTickGroup( TG_PostUpdateWork );
				BeamEmitter[CurrentFireMode].bUpdateComponentInTick = true;
				BeamEmitter[CurrentFireMode].SetIgnoreOwnerHidden(TRUE);
				SkeletalMeshComponent(Mesh).AttachComponentToSocket( BeamEmitter[CurrentFireMode],BeamSockets[CurrentFireMode] );
			}
		}
		else
		{
			BeamEmitter[CurrentFireMode].ActivateSystem();
		}
	}
}

simulated function KillBeamEmitter()
{
	if (BeamEmitter[CurrentFireMode] != none)
	{
//		BeamEmitter[CurrentFireMode].SetHidden(true);
		BeamEmitter[CurrentFireMode].DeactivateSystem();
	}
}

simulated function SetBeamEmitterHidden(bool bHide)
{
	if (BeamEmitter[CurrentFireMode] != none)
		BeamEmitter[CurrentFireMode].SetHidden(bHide);
}

simulated function UpdateBeamEmitter(vector FlashLocation, vector HitNormal, actor HitActor)
{
	if (BeamEmitter[CurrentFireMode] != none)
	{
		SetBeamEmitterHidden( !UTPawn(Instigator).IsFirstPerson() );
		BeamEmitter[CurrentFireMode].SetVectorParameter(EndPointParamName,FlashLocation);
	}
}
/*
simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	// Martin P (JeepRubi): Fixes beam appearing when player exits a vehicle in 1st person.
	// There is most likely a better way of doing this.
	if (!IsInState('WeaponBeamFiring'))
	{
		 SetBeamEmitterHidden(true);
	}
}

*/
simulated function ProcessBeamHit(vector StartTrace, vector AimDir, out ImpactInfo TestImpact, float DeltaTime);

/**
 * This function looks at who/what the beam is touching and deals with it accordingly.  bInfoOnly
 * is true when this function is called from a Tick.  It causes the link portion to execute, but no
 * damage/health is dealt out.
 */

simulated function UpdateBeam(float DeltaTime)
{
	local Vector		StartTrace, EndTrace, AimDir;
	local ImpactInfo	RealImpact;
	local UTPlayerController PC;
	local float CurrentWeaponTick;

	// define range to use for CalcWeaponFire()
	PC = UTPlayerController(Pawn(Owner).Controller);
	
	if(PC == None || !PC.bBehindView) 
	{
		StartTrace	= Instigator.GetWeaponStartTraceLocation();
	} 
	else 
	{
		StartTrace	= InstantFireStartTrace();
	}
	AimDir = Vector(GetAdjustedAim( StartTrace ));
	EndTrace	= StartTrace + AimDir * GetTraceRange();
	
	//DrawDebugLine(StartTrace,EndTrace,0,0,255,true);
	// Trace a shot
	RealImpact = CalcWeaponFire( StartTrace, EndTrace );
	bUsingAimingHelp = false;

	if(PC != None && PC.bBehindView)
		RealImpact = CheckBeamAccuracy(RealImpact);
	
	if(Rx_Weapon_Repairgun(self) != None 
		&& Rx_Weapon_DeployedC4(RealImpact.HitActor) == None 
		&& Rx_Weapon_DeployedC4(PrevHitActor) != None)
	{
		//`log(VSize(RealImpact.HitLocation - PrevHitActor.Location));
		if(VSizeSq(RealImpact.HitLocation - PrevHitActor.Location) < 400)
		{
			RealImpact.HitActor = PrevHitActor;	
		}
	}	

	if(FireInterval[CurrentFireMode] > 0.0)
	{
		WeaponTick += DeltaTime;
		While (WeaponTick >= FireInterval[CurrentFireMode])
		{
			CurrentWeaponTick += FireInterval[CurrentFireMode];
			WeaponTick -= FireInterval[CurrentFireMode];
		}
	}
	else
	{
		CurrentWeaponTick = DeltaTime;
	}
	
	if(CurrentWeaponTick > 0.0)
	{
		if(RealImpact.HitActor != None)
		{
			CurrHitLocation = RealImpact.HitLocation;
			// Allow children to process the hit
			if(UsesClientSideHitDetection(CurrentFireMode) && WorldInfo.NetMode != NM_DedicatedServer)
				ProcessBeamHit(StartTrace, AimDir, RealImpact, CurrentWeaponTick);
			else if(!UsesClientSideHitDetection(CurrentFireMode) && ROLE == ROLE_AUTHORITY)
				ProcessBeamHit(StartTrace, AimDir, RealImpact, CurrentWeaponTick);
			UpdateBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, RealImpact.HitActor);
			PrevHitActor = RealImpact.HitActor;
			SetFlashLocation(RealImpact.HitLocation);
		}
		else 
		{
			CurrHitLocation = EndTrace;
			SetFlashLocation(EndTrace);
			UpdateBeamEmitter(EndTrace, vect(0,0,0), None);
		}
	}
}

simulated function ImpactInfo CheckBeamAccuracy(ImpactInfo OldImpactInfo, optional vector Extent)
{
	local ImpactInfo NewImpactInfo;
	local vector StartTrace;

	StartTrace = Instigator.GetWeaponStartTraceLocation();

	NewImpactInfo = CalcWeaponFire(StartTrace,OldImpactInfo.HitLocation,,Extent);

	if(NewImpactInfo.HitActor == None || (NewImpactInfo.HitActor == OldImpactInfo.HitActor && VSizeSq(NewImpactInfo.HitLocation - OldImpactInfo.HitLocation) <= 2500))
		return OldImpactInfo;

	return NewImpactInfo;
}

/*********************************************************************************************
 * State WeaponFiring
 * See UTWeapon.WeaponFiring
 *********************************************************************************************/

simulated state WeaponBeamFiring
{
	/** view shaking for the beam mode is handled in RefireCheckTimer() */
	simulated function ShakeView();

	/**
	 * In this weapon, RefireCheckTimer consumes ammo and deals out health/damage.  It's not
	 * concerned with the effects.  They are handled in the tick()
	 */
	simulated function RefireCheckTimer()
	{
		local UTPlayerController PC;

		// If weapon should keep on firing, then do not leave state and fire again.
		if( ShouldRefire() )
		{
			// trigger a view shake for the local player here, because effects are called every tick
			// but we don't want to shake that often
			PC = UTPlayerController(Instigator.Controller);
			if (PC != None && LocalPlayer(PC.Player) != None && CurrentFireMode < FireCameraAnim.length && FireCameraAnim[CurrentFireMode] != None)
			{
				PC.PlayCameraAnim(FireCameraAnim[CurrentFireMode], (GetZoomedState() > ZST_ZoomingOut) ? PC.GetFOVAngle() / PC.DefaultFOV : 1.0);
			}
			return;
		}

		// Otherwise we're done firing, so go back to active state.
		GotoState('Active');

		// if out of ammo, then call weapon empty notification
		if( !HasAnyAmmo() )
		{
			WeaponEmpty();
		}
	}


	/**
	 * When done firing, we have to make sure we unlink the weapon.
	 */
	simulated function EndFire(byte FireModeNum)
	{
		Global.EndFire(FireModeNum);

		if ( bWeaponPutDown )
		{
			// if switched to another weapon, put down right away
			GotoState('WeaponPuttingDown');
			return;
		}
		else
		{
			GotoState('Active');
		}
	}

	/**
	 * Update the beam and handle the effects
	 */
	simulated function Tick(float DeltaTime)
	{
		// Retrace everything and see if there is a new LinkedTo or if something has changed.
		UpdateBeam(DeltaTime);
	}

	simulated function PlayFireEffects( byte FireModeNum, optional vector HitLocation )
	{
		local UTPlayerController PC;

		// Start muzzle flash effect
		CauseMuzzleFlash();	 
		
		PC = UTPlayerController(Instigator.Controller);
	    if( PC != None && LocalPlayer(PC.Player) != None )
	    {
		    // only do rumble if we are a player controller
		   // PC.ClientPlayForceFeedbackWaveform( BeamWeaponFireWaveForm );
	    }	       
	    
		ShakeView();
	}

	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		if ((SeqNode == None || SeqNode.AnimSeqName != BeamFireAnim[CurrentFireMode]) && BeamFireAnim[CurrentFireMode] != '')
		{
			PlayWeaponAnimation(BeamFireAnim[CurrentFireMode],1.0,true);
		}
	}

	simulated function BeginState( Name PreviousStateName )
	{
		local UTPawn POwner;

		// Fire the first shot right away
		RefireCheckTimer();
		TimeWeaponFiring( CurrentFireMode );

		if (BeamPreFireAnim[CurrentFireMode] != '')
		{
			PlayWeaponAnimation( BeamPreFireAnim[CurrentFireMode], 1.0);
		}
		else if (BeamFireAnim[CurrentFireMode] != '')
		{
			PlayWeaponAnimation( BeamFireAnim[CurrentFireMode], 1.0,true);
		}

		if (ArmsAnimSet != None && CurrentFireMode < ArmFireAnim.Length && ArmFireAnim[CurrentFireMode] != '')
		{
			PlayArmAnimation( ArmFireAnim[CurrentFireMode], 1.0,,true);
		}

		POwner = UTPawn(Instigator);
		if (POwner != None)
		{
			AddBeamEmitter();
			POwner.SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
		}
	}


	/**
	 * When leaving the state, shut everything down
	 */
	simulated function EndState(Name NextStateName)
	{
		local UTPawn POwner;
		local UTPlayerController PC;

		POwner = UTPawn(Instigator);
		if (POwner != None)
		{
			POwner.SetWeaponAmbientSound(None);
		}

		ClearTimer('RefireCheckTimer');
		ClearFlashLocation();

		if (BeamPostFireAnim[CurrentFireMode] != '')
		{
			PlayWeaponAnimation( BeamPostFireAnim[CurrentFireMode], 1.0);
		}

		if (ArmIdleAnims.Length > CurrentFireMode && ArmsAnimSet != none)
		{
			PlayArmAnimation(ArmIdleAnims[CurrentFireMode], 0.0,, true);
		}

	    // Stop controller vibration
		PC = UTPlayerController(Instigator.Controller);
	    if( PC != None && LocalPlayer(PC.Player) != None )
	    {
		    // only do rumble if we are a player controller
		    PC.ClientStopForceFeedbackWaveform( BeamWeaponFireWaveForm );
	    }

		super.EndState(NextStateName);

		KillBeamEmitter();
	}

	simulated function bool IsFiring()
	{
		return true;
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = true;
		return false;
	}

}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super.DisplayDebug(Hud, out_YL, out_YPos);

	if (BeamEmitter[CurrentFireMode] != none)
	{
	    HUD.Canvas.SetPos(4,out_YPos);
	    HUD.Canvas.DrawText("Beam:"@BeamEmitter[CurrentFireMode]@BeamEmitter[CurrentFireMode].HiddenGame);
	    out_YPos+= out_YL;
	}
}

simulated function bool UsesClientSideHitDetection(byte FireMode)
{
	return false;
}

defaultproperties
{
}
