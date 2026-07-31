class OG_Message_VehicleProduced extends Rx_Message_VehicleProduced;

 var SoundNodeWave	GDIUnitReadyAnnouncement, NodUnitReadyAnnouncement; 

/*
static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
								optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if(P.PlayerReplicationInfo == RelatedPRI_1)
		super.ClientReceive(P, Switch, RelatedPRI_1,RelatedPRI_2, OptionalObject);
}
*/

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	if ( PC.GetTeamNum() == TEAM_GDI )
	{
			return default.GDIUnitReadyAnnouncement;
	}
	else if ( PC.GetTeamNum() == TEAM_NOD )
	{
			return default.NodUnitReadyAnnouncement;
	}
	return none;
}

DefaultProperties
{	
	GDIUnitReadyAnnouncement = SoundNodeWave'OG_EVA_VoiceClips.gdi_eva.S_EVA_GDI_UnitReady'
	NodUnitReadyAnnouncement = SoundNodeWave'OG_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_UnitReady'
}
