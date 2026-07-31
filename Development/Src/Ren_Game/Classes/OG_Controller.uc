class OG_Controller extends Rx_Controller;

// Hook into this function for 180 since it already has the binding, and we don't need abilities in classic mode
exec function ToggleAbility(optional bool bReleased = false)
{
	// only activate when press, not on release.
	if (bReleased) return;

	TurnAroundClient();
}

// turn around on client, we have authority of rotation
function TurnAroundClient()
{
	local rotator CurrentRot;

	CurrentRot = self.Rotation;

	CurrentRot.Yaw += 32768;

	SetRotation(CurrentRot);
}

exec function FreeView(bool bEnabled)
{
	// not usable in first person
	if (bEnabled && UsingFirstPersonCamera())
		return;

	bIsFreeView = bEnabled;

	// fix rotation if in FreeView to current rotation
	if(bEnabled)
		FreeAimRot = Rotation;
}

// Disable sprint in vehs
state PlayerDriving
{
	exec function StartSprint()
	{}
}

// Remove VP msgs
unreliable client function ClientSendFeelGoodMessage(coerce string VPString, optional string MessageSuffix){}

// Remove Z menu
exec function OpenTauntMenu(){}

// Remove spotting
exec function Spotting(){}
exec function ReportSpotted(){}

DefaultProperties
{
	RefillCooldownTime = 0
	PTMenuClass = class'OG_GFxPurchaseMenu'
}