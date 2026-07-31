class Rx_Defence_Emplacement extends Rx_Vehicle
	abstract;

var bool bWasNeutral;

function bool DriverEnter(Pawn P)
{
	local bool bNeutral,bResult;

	bNeutral = GetTeamNum() == 255;
	bResult = super.DriverEnter(P);

	if(bResult && bNeutral)
	{
		bWasNeutral = true;
	}

	return bResult;
}

event bool DriverLeave(bool bForceLeave)
{
    local bool ret;
    
    if(ret && Controller != None && Rx_Bot(Controller) != None) {
        Rx_Bot(Controller).LeftVehicle();  
    }
    ret = super(UTVehicle).DriverLeave(bForceLeave);
    if(ret && bWasNeutral)
    {
   		if(buyerPri == none) 
   		{
			SetNeutralIfNoOccupants();
		}
	}
    return ret;
}

// Rx_Defence_Emplacement don't count towards CapturePoints, no need to notify.
function NotifyCaptuePointsOfDied(byte FromTeam);
function NotifyCaptuePointsOfTeamChange();

simulated function bool CanEnterVehicle(Pawn P)
{
	if(P.GetTeamNum() != getTeamNum() && GetTeamNum() != 255)
		return false;
	return super.CanEnterVehicle(P);	
}

DefaultProperties
{
	bBindable=false
	
	/*Veterancy */
	VRank=0
	
	bCanBePromoted = false  
}
