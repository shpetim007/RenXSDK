/**
Rx_Message_EVAKismet.uc
Author: Totem Arts Team / Mac

Message class used by Rx_SeqAct_PlayEVAAnnouncement.uc
*/

class Rx_Message_EVAKismet extends Rx_Message;

static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
								optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	UTPlayerController(P).PlayAnnouncement(default.Class,Switch,RelatedPRI_1,OptionalObject);
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    if(Rx_SeqAct_PlayEVAAnnouncement(OptionalObject) != None && PC.GetTeamNum() == Team_GDI)
        return Rx_SeqAct_PlayEVAAnnouncement(OptionalObject).GDIAnnouncementSound;
    else if (Rx_SeqAct_PlayEVAAnnouncement(OptionalObject) != None && PC.GetTeamNum() == Team_Nod)
        return Rx_SeqAct_PlayEVAAnnouncement(OptionalObject).NodAnnouncementSound;
    else
    	return none; 
}

static function SoundCue AnnouncementSoundCue(int MessageIndex, Object OptionalObject, PlayerController PC)
{
    if(Rx_SeqAct_PlayEVAAnnouncement(OptionalObject) != None && PC.GetTeamNum() == Team_GDI)
        return Rx_SeqAct_PlayEVAAnnouncement(OptionalObject).GDIAnnouncementSoundCue;
    else if (Rx_SeqAct_PlayEVAAnnouncement(OptionalObject) != None && PC.GetTeamNum() == Team_Nod)
        return Rx_SeqAct_PlayEVAAnnouncement(OptionalObject).NodAnnouncementSoundCue;
    else
    	return none; 
}

static function byte AnnouncementLevel(byte MessageIndex)
{
	return 1;
}

defaultproperties
{
	AnnouncementVolume=5.0
}
