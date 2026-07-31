class TS_PassiveAbility_RepKit extends TS_PassiveAbility_Deployable; 

var() name WeaponThrowGrenadeAnimName;
var float DelayFireTime; 

simulated function PerformReleaseAction()
{
	local TS_Pawn TSP; 
	
	TSP = TS_Pawn(UsingPawn);
	
	if(TSP != None && TSP.bDodging == false)
	{
		TSP.TopHalfAnimSlot.PlayCustomAnim(WeaponThrowGrenadeAnimName, 0.54375/DelayFireTime, 0.25, 0.25, false, true);
		TSP.SetThrowingGrenade(true);
		SetTimer( DelayFireTime , true, 'DelayFire' );
	}
}

simulated function DelayFire()
{
	CustomFire();
	SubtractCharge();
	ClearTimer('DelayFire');
	if(TS_Pawn(UsingPawn) != none)
		TS_Pawn(UsingPawn).SetThrowingGrenade(false);
}

DefaultProperties
{
    /*Deployable Details*/
    DeployedActorClass = class'TS_Weapon_DeployedRepkit' 
    TossMag = 500 
    DeployCheckRadiusSq = 50
    DeployFailedSoundCue = none

    //Delay Fire stuff 
	WeaponThrowGrenadeAnimName = "H_M_Grenade_Toss"
	DelayFireTime = 0.5;

	/***************************************************/
	/***************RX_PassiveAbility Details******************/
	/***************************************************/
	bSingleCharge = true
	MaxCharges 		= 1 
	CurrentCharges 	= 1
	//RechargeTime 	=  5.0
	RechargeRate 	= 45.0 //Seconds between re-adding charges
	RechargeDelay   = 0.1 // Delay after firing before recharging occurs
	bAlwaysRecharge = false
	bFireWhileRecharging = false
		/*--------------*/
}

