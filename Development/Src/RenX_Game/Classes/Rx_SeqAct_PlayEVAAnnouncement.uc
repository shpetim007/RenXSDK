/**
Rx_SeqAct_PlayEVAAnnouncement.uc
Author: Totem Arts Team / Mac

Kismet action for playing a specific annoucement per team.
Uses class Rx_Message_KismetTeamAnnouncement to queue and target announcement to team.

*/

class Rx_SeqAct_PlayEVAAnnouncement extends SequenceAction
	PerObjectLocalized;

/** SoundCue to Play for GDI (Overrides SoundWave) */
var() SoundCue GDIAnnouncementSoundCue;
/** SoundCue to Play for Nod (Overrides SoundWave)*/
var() SoundCue NodAnnouncementSoundCue;
/** SoundWave to Play for GDI */
var() SoundNodeWave GDIAnnouncementSound;
/** SoundWave to Play for Nod */
var() SoundNodeWave NodAnnouncementSound;

/** Target player (Pawn, Controller, or PRI). If None, broadcasts to all players. */
var Actor Target;

event Activated()
{
	local WorldInfo WI;
	local SeqVar_Object ObjVar;
	local Rx_Controller TargetPC;
	local bool bTargetAll;

	WI = GetWorldInfo();

	// Check for specific targets from variable link
	bTargetAll = true;
	foreach LinkedVariables(class'SeqVar_Object', ObjVar, "Target")
	{
		Target = Actor(ObjVar.GetObjectValue());
		if (Target != None)
		{
			bTargetAll = false;
			TargetPC = ResolveToController(Target);
			if (TargetPC != None)
			{
				// Send only to the targeted player
				TargetPC.ReceiveLocalizedMessage(class'Rx_Message_EVAKismet', 0, None, None, self);
			}
		}
	}

	// If no specific targets, broadcast to all players (original behavior)
	if (bTargetAll)
	{
		WI.BroadcastLocalizedMessage(class'Rx_Message_EVAKismet', 0, None, None, self);
	}
}

/** Converts a Pawn, Controller, or PlayerReplicationInfo to an Rx_Controller. */
function Rx_Controller ResolveToController(Actor TargetActor)
{
	if (Rx_Controller(TargetActor) != None)
	{
		return Rx_Controller(TargetActor);
	}
	else if (Pawn(TargetActor) != None && Pawn(TargetActor).Controller != None)
	{
		return Rx_Controller(Pawn(TargetActor).Controller);
	}
	else if (PlayerReplicationInfo(TargetActor) != None)
	{
		return Rx_Controller(PlayerReplicationInfo(TargetActor).Owner);
	}
	return None;
}

defaultproperties
{
	bCallHandler=false
	ObjName="Play EVA Announcement"
	ObjCategory="Ren X"
	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Optional Target", PropertyName=Target, bWriteable=false)
}
