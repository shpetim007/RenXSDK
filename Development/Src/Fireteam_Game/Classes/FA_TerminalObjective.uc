class FA_TerminalObjective extends Actor
implements(TSIfc_MissionObjective)
implements(Rx_HackableInterface)
implements(RxIfc_Targetable)
implements(RxIfc_HasTooltip)
ClassGroup(FireteamAssault)
placeable;

struct ObjTargetInfo {
	var string ObjTargetStrFriendly; 
	var string ObjTargetStrEnemy;
};

/** The Mesh */
var(Terminal) StaticMeshComponent Mesh;

/** Component properties to replicate */
var repnotify vector ReplicatedMeshTranslation;
var repnotify rotator ReplicatedMeshRotation;
var repnotify vector ReplicatedMeshScale3D;
var repnotify StaticMesh ReplicatedMesh; 
var repnotify MaterialInterface ReplicatedMaterial0, ReplicatedMaterial1;
var(Terminal) const editconst DynamicLightEnvironmentComponent LightEnvironment;
var bool bCaptured;

// Gametime replicated
var repnotify ObjTargetInfo ObjectiveInfo; //Target Info associated with us
var(Terminal) repnotify byte OwningTeamNum;
var repnotify bool bHackInProgress;
var float HackProgress;
var FA_Controller Hacker;
var FA_Controller SuccessfulHacker;
var repnotify bool SuccessfullyHacked;

// Replication Helper
var bool bPendingActive;

// Do not change after spawn unless replication changed
var(Terminal) float HackTime;
var(Terminal) string DefenderStringTip, AttackerStringTip;
var(Terminal) float maxHackingDistance;

var(Terminal) int HackCaptureTime<ToolTip=How long the terminal needs to be hacked for the attacker to capture>;
var(Terminal) float HackCaptureCredits<ToolTip=Credits to give to successful capture hacker>;
var(Terminal) Texture2D IconTexture<Tooltip=Texture to be showed on HUD>;
var bool bBeenUsed;

var AudioComponent HackSound;
var AudioComponent AlarmSound;

var float LastHackTime;
var float AdditionalTime;

replication
{
	if (bNetDirty)
		bBeenUsed, ObjectiveInfo, OwningTeamNum, bHackInProgress, Hacker, SuccessfullyHacked, HackProgress;

	if (bNetInitial)
		HackTime, maxHackingDistance, DefenderStringTip, AttackerStringTip, HackCaptureTime, ReplicatedMesh, ReplicatedMeshTranslation, ReplicatedMeshRotation, ReplicatedMeshScale3D, ReplicatedMaterial0, ReplicatedMaterial1, IconTexture;
}

simulated function ReplicatedEvent(name VarName)
{
    if (VarName == 'ReplicatedMesh')
    { 
        Mesh.SetStaticMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedMeshTranslation')
    {
        Mesh.SetTranslation(ReplicatedMeshTranslation);
    }
    else if (VarName == 'ReplicatedMeshRotation')
    {
        Mesh.SetRotation(ReplicatedMeshRotation);
    }
    else if (VarName == 'ReplicatedMeshScale3D')
    {
        Mesh.SetScale3D(ReplicatedMeshScale3D / 100); // remove compensation for replication rounding
    }
    else if (VarName == 'ReplicatedMaterial0')
    {
        Mesh.SetMaterial(0, ReplicatedMaterial0);
    }
    else if (VarName == 'ReplicatedMaterial1')
    {
        Mesh.SetMaterial(1, ReplicatedMaterial1);
    }
	else if (VarName == 'ObjectiveInfo')
	{
		//These both should change and replicate at the same time 
		if (ObjectiveInfo.ObjTargetStrFriendly == "")
		{
			RemoveAsRelevantObjective(); 
		}
		else
		{
			AddAsRelevantObjective(); 
		}		
	}
    else if (VarName == 'SuccessfullyHacked')
    {
        LastHackTime = WorldInfo.RealTimeSeconds;
        ToggleAlarmSound();
        AdditionalTime = 0.0;
    }
    else if (VarName == 'bHackInProgress')
        GotoState(bHackInProgress ? 'BeingHacked' : '');

	super.ReplicatedEvent(VarName);
}

simulated function ActivateKismetForObjective()
{

}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    if (Mesh != none)
    {
        ReplicatedMesh = Mesh.StaticMesh;
        ReplicatedMeshRotation = Mesh.rotation;
        ReplicatedMeshTranslation = Mesh.Translation;
        ReplicatedMeshScale3D = DrawScale3D*100; //The editor usually uses the object's DrawScale as opposed to the scale on the Mesh
        ReplicatedMaterial0 = Mesh.Materials[0];
        if(mesh.Materials.Length == 2)
            ReplicatedMaterial1 = Mesh.Materials[1];
    
        //bForceStaticDecals = Mesh.bForceStaticDecals;
    }
}

function SetStaticMesh(StaticMesh NewMesh, optional vector NewTranslation, optional rotator NewRotation, optional vector NewScale3D)
{
    
    Mesh.SetStaticMesh(NewMesh);
    Mesh.SetTranslation(NewTranslation);
    Mesh.SetRotation(NewRotation);
    if (!IsZero(NewScale3D))
    {
        Mesh.SetScale3D(NewScale3D);
        ReplicatedMeshScale3D = NewScale3D * 100; // avoid rounding in replication code
    }
    ReplicatedMesh = NewMesh;
    ReplicatedMeshTranslation = NewTranslation;
    ReplicatedMeshRotation = NewRotation;
    ForceNetRelevant();
}

simulated function ToggleAlarmSound(optional bool bForceOff = false)
{
    if (WorldInfo.NetMode == NM_DedicatedServer) return;

    if (AlarmSound.IsPlaying() || bForceOff)
        AlarmSound.Stop();
    else if (!bForceOff && !AlarmSound.IsPlaying())
        AlarmSound.Play();
}

// Hacking
simulated function string GetTooltip(Rx_Controller PC)
{
    local string UseKey;
    local Rx_Pawn pawn;

    pawn = Rx_Pawn(PC.Pawn);

    if (!GetIsObjective()) return "";

    if (pawn == None || pawn.GetTeamNum() == self.ScriptGetTeamNum() || VSize(pawn.Location - self.Location) > maxHackingDistance)
        return "";
    
    UseKey = "<font color='#ff0000'>["$Caps(Rx_PlayerInput(PC.PlayerInput).GetUDKBindNameFromCommand("GBA_USE"))$"]</font>";
    return "Hold" @ UseKey @ "to hack this terminal";
}

simulated function bool TipsRequireTouch()
{
    return false;
}

simulated function bool IsBasicTips()
{
    return false;
}

function Hack()
{}

function Hacks(fa_controller controller)
{ 
    if (!GetIsObjective() || VSize(controller.Pawn.Location - self.Location) > maxHackingDistance || Hacker != None)
    {
        return;
    }

    if (controller.GetTeamNum() == ScriptGetTeamNum()) return;

    Hacker = controller;
    bHackInProgress = true;
    GotoState('BeingHacked');
}

function StopHack()
{
    HackProgress = 0.f;

    Hacker = None;

    bHackInProgress = false;

    GotoState('');
}

simulated state BeingHacked
{
    simulated function BeginState(name old)
    {
        if (WorldInfo.NetMode != NM_DedicatedServer)
            HackSound.Play();

        if(IsTimerActive(NameOf(FinalCapture)))
        {
            PauseTimer(true,NameOf(FinalCapture));
        }
    }

    simulated function string GetTooltip(Rx_Controller PC)
    {
        if (PC.GetTeamNum() != ScriptGetTeamNum())
            return "INSTALLING_SUPER_VIRUS::[" $ GetHackingProgressBar(1) $ "]";

        return "";
    }
    
    simulated function string GetHackingProgressBar(float timeLeft)
    {
        return HackProgress$"/"$HackTime;
    }

    event Tick(Float Delta)
    {
        AdditionalTime += Delta;

        if (hacker == none)
        {
            StopHack();
            return;
        }

        if (VSize(hacker.pawn.Location - self.Location) > maxHackingDistance || ScriptGetTeamNum() == hacker.GetTeamNum()) 
        {
            StopHack();
        } else {
            HackProgress += Delta;
            CheckHackSuccess();
        }
    }

    function CheckHackSuccess()
    {
        if (HackProgress >= HackTime)
        {
            HackSuccess();
            StopHack();
        }
    }

    simulated function EndState(name Next)
    {
        if (WorldInfo.NetMode != NM_DedicatedServer)
            HackSound.Stop();


        PauseTimer(false,NameOf(FinalCapture));  
    }
}

function HackSuccess()
{
    if (hacker == None) return;

    `log("Successfully hacked by"@hacker.GetTeamNum()@hacker.GetHumanReadableName());
    SuccessfullyHacked = !SuccessfullyHacked;

    SuccessfulHacker = Hacker;

    if (WorldInfo.NetMode != NM_DedicatedServer)
        ToggleAlarmSound();

    OwningTeamNum = hacker.GetTeamNum();
    NotifyObjectivePickedUp(OwningTeamNum);

    if(!FA_TeamInfo(Hacker.PlayerReplicationInfo.Team).IsDefender())
        SetTimer(HackCaptureTime, false, nameof(FinalCapture));
    else if(IsTimerActive(nameof(FinalCapture)))
    {
        AdditionalTime = 0.0;
        ClearTimer(nameof(FinalCapture));
    }

    // 0 = Started, 1 = Disarmed, 2 = Captured
    TriggerEventClass(Class'FA_SeqEvent_TerminalHack', Hacker, FA_TeamInfo(Hacker.PlayerReplicationInfo.Team).IsDefender() ? 1 : 0);
}

function FinalCapture()
{
    NotifyObjectiveDied();
}

// End Hacking

/*Start Mission Objective Interface*/
/*This should be agnostic enough to just copy-paste where needed*/
/*PAY ATTENTION to where some functions NEED to be called*/

/**
Reference from TS_MissionManager for ObjectiveType
enum AttackerObjective {
	//Pure Attack/Defend Objectives
	0 Obj_ATTACK,
	1 Obj_EXTRACT,
	2 Obj_CAPTURE,
	3 Obj_DEPLOY,
	4 Obj_SECURE
	5 Obj_NONE
};*/
function SetObjectiveInfo(int ObjectiveType, byte AttackingTeam)
{
	ObjectiveInfo.ObjTargetStrFriendly = "Protect" ; //NOTE: Could be localized
	ObjectiveInfo.ObjTargetStrEnemy = "Hack";

    bBeenUsed = true;
}

//Reset info (Which should replicate something)
function ClearObjectiveInfo()
{
	ObjectiveInfo.ObjTargetStrFriendly = "" ; //NOTE: Could be localized
	ObjectiveInfo.ObjTargetStrEnemy = "";
}

//Adds as a relevant objective to our local MissionManager 
simulated function AddAsRelevantObjective()
{
	local TS_MissionManager TSMM;
	
	ForEach DynamicActors(class'TS_MissionManager', TSMM)
	{
		TSMM.AddRelevantActor(self);
        return;
	}

    if(TSMM == None)
        bPendingActive = true;
} 

simulated function bool ObjectivePendingActive()
{
    return bPendingActive;
}

simulated function vector GetObjectiveLocation()
{
    return Location;
}

//Remove as a relevant objective to our local MissionManager 
simulated function RemoveAsRelevantObjective()
{
	local TS_MissionManager TSMM;

    if (SuccessfulHacker != None)
        Rx_PRI(SuccessfulHacker.PlayerReplicationInfo).AddCredits(HackCaptureCredits);

    ToggleAlarmSound(true);
	
	ForEach DynamicActors(class'TS_MissionManager', TSMM)
	{
		TSMM.RemoveRelevantActor(self);
	}
} 

/*Called by the HUD to identify both if there's any objective set, and which one it is depending on who's looking*/
simulated function string GetObjectiveInfo(byte LocalTeamNum)
{
    local string ShowTime;

    if (SuccessfullyHacked)
        ShowTime = string(LastHackTime + HackCaptureTime + AdditionalTime - WorldInfo.RealTimeSeconds);

    if (Float(ShowTime) <= 0)
        ShowTime = "";

	return ShowTime;
}

simulated function bool GetIsObjective()
{
	//If this is blank we aren't an objective
	return ObjectiveInfo.ObjTargetStrFriendly != "";  
}

function NotifyObjectiveDied()
{
	if (GetIsObjective())
		TS_GRI(WorldInfo.GRI).MissionManager.ObjectiveDied(self);
}

//Deployable-based missions 
function NotifyObjectivePickedUp(byte ByTeam, optional Controller ByWhom) //We can't be picked up (Or can we?)
{
    if (GetIsObjective())
        TS_GRI(WorldInfo.GRI).MissionManager.ObjectivePickedUp(self, self.GetTeamNum());
}
function NotifyObjectiveDropped(optional Controller ByWhom); 

function NotifyObjectiveDeployed(byte ByTeam, optional Controller ByWhom); 

simulated function Texture GetIconTexture()
{
    return IconTexture;
}

/*-------------------------------*/
/*End Mission Objective Interface*/
/*-------------------------------*/

simulated event byte ScriptGetTeamNum()
{
	return OwningTeamNum;
}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return 1;} //Return the current health of this target
simulated function int GetTargetHealthMax() {return 1;} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return 0;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return 0;} // Get the current Armour of the target 

// Veterancy
simulated function int GetVRank(){ return 0;}
/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return 1.0f;}
simulated function float GetTargetArmourPct() {return 1.0f;}
simulated function float GetTargetMaxHealthPct() {return 1.0f;} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return false;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return true;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return true;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return false;} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return GetIsObjective();} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return false;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return true;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return false;} //Does our target box 'stick' even after we're untargeted for awhile 
simulated function bool HasVeterancy() {return false;}

//Spotting
simulated function bool IsSpottable() {return true;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return "Access Terminal";} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "";} //Get the text for our interaction 
simulated function string GetTargetedDescription(PlayerController PlayerPerspective) {return "";} //Get any special description we might have when targeted 

//Actions
simulated function SetTargeted(bool bTargeted); //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/

simulated function bool Contested()
{
    return HackProgress > 0;
}

DefaultProperties
{
	OwningTeamNum = 255
	maxHackingDistance = 180
    HackProgress = 0
    HackTime = 5
    HackCaptureTime = 60
    SuccessfullyHacked=false
    HackCaptureCredits = 150

    SupportedEvents.Add(class'FA_SeqEvent_TerminalHack')

    Begin Object Class=AudioComponent Name=HackSoundComp
        SoundCue=SoundCue'FA_Sounds.Waves.SC_leet_hacker'
    End Object
    HackSound=HackSoundComp
    Components.Add(HackSoundComp)

    Begin Object Class=AudioComponent Name=AlarmComp
        SoundCue=SoundCue'RX_AmbientSounds.Buildings.SC_Building_Alarm_Large'
    End Object
    AlarmSound=AlarmComp
    Components.Add(AlarmComp)

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
    End Object
    LightEnvironment=MyLightEnvironment
    Components.Add(MyLightEnvironment)

    Begin Object Class=StaticMeshComponent Name=ObstacleMesh
            //HiddenGame=true
            StaticMesh                   = StaticMesh'rx_deco_terminal.Mesh.SM_BU_MCT_Visible'
            CastShadow                      = True
            CollideActors                   = True
            BlockActors                     = True
            BlockRigidBody                  = True
            BlockZeroExtent                 = True
            BlockNonZeroExtent              = True
            bCastDynamicShadow              = True
            bAcceptsLights                  = True
            bAcceptsDecalsDuringGameplay    = True
            bAcceptsDecals                  = True
            bAllowApproximateOcclusion      = True
            bUsePrecomputedShadows          = True
            bForceDirectLightMap            = True
            bAcceptsDynamicLights           = True
            ForcedLodModel                  = 1
            LightingChannels                = (bInitialized=True,Static=True)
            LightEnvironment=MyLightEnvironment
    End Object
    Mesh=ObstacleMesh
    Components.Add(ObstacleMesh)
      
    bCollideActors=true
    bCollideWorld=true 
    bCollideComplex=true
    bBlockActors=true
    bProjTarget=true 
    
    bAlwaysRelevant=true
    bGameRelevant=true
    RemoteRole=ROLE_SimulatedProxy
    bPathColliding=true
    bBeenUsed = false
    IconTexture = Texture2D'TS_HUD_Canvas.Graphics.T_Objective_Hack'

    SupportedEvents.Add(class'TS_SeqEvent_ObjectiveComplete')
}