/**
 * Rx_SeqActKismetJukeboxController.uc
 * Author: Totem Arts Team / Mac
 *
 * Kismet Action for controlling the Rx_Jukebox and playing custom tracks.
 * Broadcasts commands to clients via Rx_Message_JukeboxKismet.
 */
class Rx_SeqActKismetJukeboxController extends SequenceAction;

// Custom Track List
var() array<SoundCue> CustomTracks;

// Optional Fade out when Stop Music is activated
var() float FadeOutOnStop;
// Auto Start Rx Jukebox after custom track(s) have finished
var() bool bAutoStartJukeboxAfterCustom;
// Plays Full Custom Track List in order (ignores TrackIndex)
var() bool bPlayFullCustomTrackList;
// Loops Custom Track List until stopped or another Play event occurs
var() bool bLoopCustomTracks;
// Custom Track Number to play (Requires bPlayFullCustomTrackList to be false)
var() int TrackIndex;

// Target team when no specific player(s) are targeted (0=GDI, 1=Nod, 255=All Players)
var() byte TargetTeam;

// Target player(s) (Pawn, Controller, or PRI). If None, uses TargetTeam to filter.
var Actor Target;

event Activated()
{
    local SeqVar_Object ObjVar;
    local Rx_Controller TargetPC;
    local bool bTargetAll;
    local int MessageSwitch;

    // Determine message type based on input
    if (InputLinks[0].bHasImpulse)
    {
        MessageSwitch = 0; // Start Rx Jukebox
    }
    else if (InputLinks[1].bHasImpulse)
    {
        MessageSwitch = 1; // Stop all music
    }
    else if (InputLinks[2].bHasImpulse)
    {
        // Validate custom tracks before sending
        if (CustomTracks.Length == 0)
        {
            `warn("Rx_SeqActKismetJukeboxController: CustomTracks array is empty");
            OutputLinks[0].bHasImpulse = true;
            return;
        }
        MessageSwitch = bPlayFullCustomTrackList ? 3 : 2; // Play full playlist or specific track
    }
    else
    {
        OutputLinks[0].bHasImpulse = true;
        return;
    }

    // Get targets from variable link
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
                TargetPC.ReceiveLocalizedMessage(class'Rx_Message_JukeboxKismet', MessageSwitch, None, None, self);
            }
        }
    }

    // If no specific targets, use team-based or broadcast
    if (bTargetAll)
    {
        if (TargetTeam == 255)
        {
            // Broadcast to all players
            GetWorldInfo().BroadcastLocalizedMessage(class'Rx_Message_JukeboxKismet', MessageSwitch, None, None, self);
        }
        else
        {
            // Send to specific team only
            SendToTeam(MessageSwitch, TargetTeam);
        }
    }

    OutputLinks[0].bHasImpulse = true;
}

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

function SendToTeam(int MessageSwitch, byte Team)
{
    local Rx_Controller PC;

    foreach GetWorldInfo().AllControllers(class'Rx_Controller', PC)
    {
        if (PC.GetTeamNum() == Team)
        {
            PC.ReceiveLocalizedMessage(class'Rx_Message_JukeboxKismet', MessageSwitch, None, None, self);
        }
    }
}

defaultproperties
{
    ObjName="Jukebox Controller"
    ObjCategory="Ren X"

    // Input Actions
    InputLinks(0)=(LinkDesc="Play Rx Jukebox")
    InputLinks(1)=(LinkDesc="Stop Music")
    InputLinks(2)=(LinkDesc="Play Custom")

    // Output Results
    OutputLinks(0)=(LinkDesc="Out")

    // Variable Links
    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Optional Target", PropertyName=Target, bWriteable=false)

    // Configuration
    bCallHandler=false
    bAutoActivateOutputLinks=false

    // Default Values
    FadeOutOnStop=0.0
    bAutoStartJukeboxAfterCustom=false
    bPlayFullCustomTrackList=true
    bLoopCustomTracks=false
    TrackIndex=0
    TargetTeam=255
}
