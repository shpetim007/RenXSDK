class FA_SeqEvent_TerminalHack extends SequenceEvent;

defaultproperties
{
   ObjName="Objective Terminal Event"
   ObjCategory="Fireteam Assault"

   OutputLinks[0]=(LinkDesc="Hack Started")
   OutputLinks[1]=(LinkDesc="Hack Disarmed")
   OutputLinks[2]=(LinkDesc="Hack Finished")
   bPlayerOnly=false
   MaxTriggerCount=0
}