class Rx_Weapon_Rotary extends Rx_Weapon_Charged
abstract;

var bool bAllowRetainRotation;

simulated state WeaponFiring
{
	simulated function BeginState( Name PreviousStateName )
	{
		super.BeginState(PreviousStateName);
		if(PreviousStateName == 'WeaponCharging' && HasAmmo(0) && PendingFire(0))
		{
			SetCurrentFireMode(0);
			if(UTPawn(Instigator) != None)
				UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
				
			if(!bAllowRetainRotation)
				StopFire(1); // force stop FireMode 1. 
		}
	}

	simulated function RefireCheckTimer()
	{
		local UTPlayerController PC;
		// if switching to another weapon, abort firing and put down right away
		if( bWeaponPutDown )
		{
			PutDownWeapon();
			return;
		}

		if(!ShouldRefire())
			GotoState('Active');

		else if(PendingFire(0))
		{
			// trigger a view shake for the local player here, because effects are called every tick
			// but we don't want to shake that often
			PC = UTPlayerController(Instigator.Controller);
			if(PC != None && LocalPlayer(PC.Player) != None && CurrentFireMode < FireCameraAnim.length && FireCameraAnim[CurrentFireMode] != None)
			{
				PC.PlayCameraAnim(FireCameraAnim[CurrentFireMode], (GetZoomedState() > ZST_ZoomingOut) ? PC.GetFOVAngle() / PC.DefaultFOV : 1.0);
			}

			if (bIronsightActivated && !bPlayingADSFire)
				LoopADSFireAnims();
			else if (!bIronsightActivated && bPlayingADSFire)
				LoopFireAnims();

			FireAmmunition();
			return;
		}

	}

	simulated function StartFire(byte FireModeNum)
	{
		LastFireModeNum = FireModeNum;
		BeginFire(FireModeNum);
	}

	simulated function BeginFire( Byte FireModeNum )
	{
		super.BeginFire(FireModeNum);

		if(CurrentFireMode == 1)
		{
			if(FireModeNum == 0 && PendingFire(FireModeNum))
			{
				SetCurrentFireMode(0);
				if(UTPawn(Instigator) != None)
					UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
				
				if(!bAllowRetainRotation)
					StopFire(1); // force stop FireMode 1. 
			}
		}
		else
		{
			if(FireModeNum == 1 && PendingFire(FireModeNum))
			{
				SetCurrentFireMode(1);
				if(UTPawn(Instigator) != None)
					UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
				
				if(!bAllowRetainRotation)
					StopFire(0); // force stop FireMode 0. 
			}
		}
	}

	simulated function StopFire(byte FireModeNum)
	{
		super.StopFire(FireModeNum);
		
		if(FireModeNum == 0)
		{
			if(PendingFire(1))
			{
				SetCurrentFireMode(1);
				if(UTPawn(Instigator) != None)
					UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
				
				if(!bAllowRetainRotation)
					StopFire(0); // force stop FireMode 1. 
			}
		}
		else
		{
			if(PendingFire(0))
			{
				SetCurrentFireMode(0);
				if(UTPawn(Instigator) != None)
					UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
				
				if(!bAllowRetainRotation)
					StopFire(1); // force stop FireMode 1. 
			}
		}
	}
}

simulated function FireAmmunition()
{
	if(CurrentFireMode == 0)
		super.FireAmmunition();
}

/**
reliable server function ServerStopFire(byte FireModeNum)
{
	if(FireModeNum == 0)
	{
		if(PendingFire(1))
		{
			SetCurrentFireMode(1);
			if(UTPawn(Instigator) != None)
				UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
			
			if(!bAllowRetainRotation)
				ServerStopFire(0); // force stop FireMode 1. 
		}
		else
		{
			clearTimer(nameof(GoToWeaponFiring));
			if(GetStateName() != 'WeaponFiring')
				GotoState('Active');
		}
	}
	else
	{
		if(PendingFire(0))
		{
			SetCurrentFireMode(0);
			if(UTPawn(Instigator) != None)
				UTPawn(Instigator).SetWeaponAmbientSound(WeaponFireSnd[CurrentFireMode]);
			
			if(!bAllowRetainRotation)
				ServerStopFire(1); // force stop FireMode 1. 
		}
	}

	clearTimer(nameof(BeginBeginFire));
	super(Weapon).ServerStopFire(FireModeNum); 
}*/

simulated state Reloading
{
	function SetFlashLocation(vector HitLocation)
	{
		Super.SetFlashLocation(HitLocation);
		//Temporary hack... like... an enormous ha
		SetPendingFire(0);
		ReloadWeaponTimer(); 
		ClearTimer('GoToWeaponFiring');
		GoToWeaponFiring();
	}
}

function SetFlashLocation(vector HitLocation)
{
	Super.SetFlashLocation(HitLocation);
	//Temporary hack... like... an enormous hack till we rewrite rotary weapons. 
	if(GetStateName() != 'WeaponFiring')
	{
		//`log("SET FLASH LOCATION IN STATE:" @ GetStateName());  //@ "SENDING TO WEAPON FIRING" @ PendingFire(0) @ PendingFire(1));
		SetPendingFire(0);
		SetCurrentFireMode(0);
		bCharged = true; 
		ClearTimer('GoToWeaponFiring');
		GoToWeaponFiring();
	}
		
}


DefaultProperties
{
	bAllowRetainRotation = true
}