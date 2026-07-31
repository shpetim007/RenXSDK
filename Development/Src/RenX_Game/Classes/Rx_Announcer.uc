class Rx_Announcer extends UTAnnouncer;

function PlayAnnouncementNow(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
	local SoundNodeWave ASound;
	local bool bUsingVoiceCue;
	local bool bUsingCustomCue;
	local SoundCue CustomCue;

//	`log("TS_Announcer playing new announcement");

	ASound = InMessageClass.Static.AnnouncementSound(MessageIndex, OptionalObject, PlayerOwner);

	// Handepsilon's Note : This is going to be INCREDIBLY dirty, but as long as we cannot use interface for class-casting, then we'll have to resort into hardcoding the f out of this.
	//						I can't even make something like TS_LocalMessage or something because Rx_Game kinda seals the deal with its own hardcoding. If anyone wants to make that cleaner, you gotta start with that part.
	// Addendum : I've done it, except for VictoryMessage because they're soft-hardcoded into UTGame
	if(class<Rx_VictoryMessage>(InMessageClass) != None)
	{
		CustomCue = class<Rx_VictoryMessage>(InMessageClass).static.AnnouncementSoundCue(MessageIndex, OptionalObject, PlayerOwner);
	}
	else if(class<Rx_Message>(InMessageClass) != None)
	{
		CustomCue = class<Rx_Message>(InMessageClass).static.AnnouncementSoundCue(MessageIndex, OptionalObject, PlayerOwner);
	}

	if ( ASound != None || CustomCue != None)
	{

		if (CurrentAnnouncementComponent != none)
		{
			if (PlayerOwner != none)
			{
				PlayerOwner.DetachComponent(CurrentAnnouncementComponent);
			}
			CurrentAnnouncementComponent = none;
		}

		if(CustomCue != None)
		{
			CurrentAnnouncementComponent = PlayerOwner.CreateAudioComponent(CustomCue, false, false);			
			bUsingCustomCue = TRUE;
		}
		
		if(!bUsingCustomCue)
		{
			//@FIXME: part of playsound pool?
			// if we are a UTVoice when we want to use the special UTVoiceSoundCue which is in the correct SoundClass (i.e. effects)
			if ( ClassIsChildOf( InMessageClass, class'UTVoice' ) || ClassIsChildOf( InMessageClass, class'UTScriptedVoiceMessage' ) )
			{
				CurrentAnnouncementComponent = PlayerOwner.CreateAudioComponent(UTVoiceSoundCue, false, false);
				bUsingVoiceCue = TRUE;
			}
			else
			{
				CurrentAnnouncementComponent = PlayerOwner.CreateAudioComponent(AnnouncerSoundCue, false, false);
				bUsingVoiceCue = FALSE;
			}
		}

		// CurrentAnnouncementComponent will be none if -nosound option used
		if ( CurrentAnnouncementComponent != None )
		{
			if(!bUsingCustomCue)
				CurrentAnnouncementComponent.SetWaveParameter('Announcement', ASound);
			else if(CustomCue == None)
			{
				PlayNextAnnouncement();
				return;
			}

			if( bUsingVoiceCue )
			{
				UTVoiceSoundCue.Duration = ASound.Duration;
				UTVoiceSoundCue.VolumeMultiplier = InMessageClass.Default.AnnouncementVolume;
			}
			else if (!bUsingCustomCue)
			{
				AnnouncerSoundCue.Duration = ASound.Duration;
				AnnouncerSoundCue.VolumeMultiplier = InMessageClass.Default.AnnouncementVolume;
			}
			CurrentAnnouncementComponent.bAutoDestroy = true;
			CurrentAnnouncementComponent.bShouldRemainActiveIfDropped = true;
			CurrentAnnouncementComponent.bAllowSpatialization = false;
			CurrentAnnouncementComponent.bAlwaysPlay = TRUE;
			CurrentAnnouncementComponent.Play();
		}
		PlayingAnnouncementClass = InMessageClass;
		PlayingAnnouncementIndex = MessageIndex;

		// NOTE: Audio always plays back in real-time, so we'll scale our duration by the world's time dilation
		if(bUsingCustomCue)
			SetTimer(CustomCue.Duration * WorldInfo.TimeDilation + 0.05, false,'AnnouncementFinished');
		else
			SetTimer(ASound.Duration * WorldInfo.TimeDilation + 0.05, false,'AnnouncementFinished');

		if ( InMessageClass.default.bShowPortrait 
			&& (UTHUD(PlayerOwner.MyHUD) != None) 
			&& (UTPlayerReplicationInfo(PRI) != None) 
			&& (PRI != PlayerOwner.PlayerReplicationInfo) )
		{
			UTHUD(PlayerOwner.MyHUD).ShowPortrait(UTPlayerReplicationInfo(PRI), ASound.Duration+0.5, ClassIsChildOf(InMessageClass, class'UTScriptedVoiceMessage'));
		}
	}
	else
	{
		//`log("NO SOUND FOR "$InMessageClass@MessageIndex@OptionalObject@OptionalObject.name);
		PlayNextAnnouncement();
	}
}