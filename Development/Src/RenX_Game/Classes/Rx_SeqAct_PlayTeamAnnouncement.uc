class Rx_SeqAct_PlayTeamAnnouncement extends SequenceAction
	PerObjectLocalized;

var() SoundNodeWave AnnouncementSound;
/** Which team should receive the announcement: GDI = 0 Nod = 1 */
var() int KismetAnnouncementTeam;

event Activated()
{
	local WorldInfo WI;

	WI = GetWorldInfo();

	WI.BroadcastLocalizedMessage(class'Rx_Message_KismetTeamAnnouncement', 0, None, None, self);
}

defaultproperties
{
	bCallHandler=false
	ObjName="Play Team Announcement"
	ObjCategory="Ren X"
	VariableLinks.Empty
}
