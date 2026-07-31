class Rx_Message_KismetTeamAnnouncement extends Rx_Message;

static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
								optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	UTPlayerController(P).PlayAnnouncement(default.Class,Switch,RelatedPRI_1,OptionalObject);		
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
	{
		local int KismetAnnouncementMessageTeam;
		KismetAnnouncementMessageTeam = Rx_SeqAct_PlayTeamAnnouncement(OptionalObject).KismetAnnouncementTeam;

		if ( PC.GetTeamNum() == KismetAnnouncementMessageTeam )
			return Rx_SeqAct_PlayTeamAnnouncement(OptionalObject).AnnouncementSound;
	}

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 1;
}

defaultproperties
{
	AnnouncementVolume=5.0
}
