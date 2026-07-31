class FA_SeqEvent_ZoneCaptured extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
    OutputLinks[0]=(LinkDesc="Zone 1")
    OutputLinks[1]=(LinkDesc="Zone 2")
    OutputLinks[2]=(LinkDesc="Zone 3")
    OutputLinks[3]=(LinkDesc="Zone 4")
    OutputLinks[4]=(LinkDesc="Zone 5")
    OutputLinks[5]=(LinkDesc="Zone 6")
    OutputLinks[6]=(LinkDesc="Zone 7")

	ObjName="Zone Captured"
    ObjCategory="Fireteam Assault"
	bPlayerOnly=false
	bClientSideOnly=false
	MaxTriggerCount=0
	ReTriggerDelay=0
}
