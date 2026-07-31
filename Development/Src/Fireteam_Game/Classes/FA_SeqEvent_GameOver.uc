class FA_SeqEvent_GameOver extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
    OutputLinks[0]=(LinkDesc="Attacker Victory")
    OutputLinks[1]=(LinkDesc="Defender Victory")

	ObjName="Game Over"
    ObjCategory="Fireteam Assault"
	bPlayerOnly=false
	bClientSideOnly=false
	MaxTriggerCount=1
	ReTriggerDelay=0
}
