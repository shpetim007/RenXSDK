/**
 * Rx_Message_JukeboxKismet.uc
 * Author: Totem Arts Team / Mac
 *
 * Message class for Rx_SeqActKismetJukeboxController to dispatch jukebox commands to clients in multiplayer.
 *
 * Message Switch values:
 * 0 = Start Rx Jukebox
 * 1 = Stop all music
 * 2 = Play specific custom track
 * 3 = Play full playlist
 */
class Rx_Message_JukeboxKismet extends Rx_Message;

static function ClientReceive(PlayerController P, optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject)
{
    local Rx_SeqActKismetJukeboxController Controller;
    local Rx_Controller RxPC;

    Controller = Rx_SeqActKismetJukeboxController(OptionalObject);
    RxPC = Rx_Controller(P);

    if (Controller == None || RxPC == None)
        return;

    switch (Switch)
    {
        case 0: // Start Rx Jukebox
            RxPC.KismetJukeboxPlayRxJukebox();
            break;
        case 1: // Stop all music
            RxPC.KismetJukeboxStopAllMusic(Controller.FadeOutOnStop);
            break;
        case 2: // Play specific custom track
            RxPC.KismetJukeboxPlayCustom(Controller, Controller.TrackIndex, false);
            break;
        case 3: // Play full playlist
            RxPC.KismetJukeboxPlayCustom(Controller, 0, true);
            break;
    }
}

defaultproperties
{
    bIsSpecial=true
    bBeep=false
}
