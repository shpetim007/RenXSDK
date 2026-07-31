class Rx_Building_Hospital_Internals extends Rx_Building_TechBuilding_Internals
	notplaceable;

var int MaxHealthIncrease, RegenRate;
var private name IdleAnimName;
var repnotify bool PlayIdleAnim; 
  
  
`define GdiUnderAttackForGdiSound FriendlyBuildingSounds[BuildingUnderAttack]
`define GdiUnderAttackForNodSound FriendlyBuildingSounds[BuildingDestructionImminent]
`define NodUnderAttackForGdiSound EnemyBuildingSounds[BuildingUnderAttack]
`define NodUnderAttackForNodSound EnemyBuildingSounds[BuildingDestructionImminent]  
  
replication
{
	if (bNetDirty && Role == ROLE_Authority)
		PlayIdleAnim;
}

simulated event ReplicatedEvent( name VarName )
{
	if (VarName == 'PlayIdleAnim')
	{
		ToggleIdleAnimation();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

// Initialize the building and set the visual section of the building
simulated function Init(Rx_Building Visuals, bool isDebug )
{
	super.Init(Visuals, isDebug);
	if(WorldInfo.Netmode != NM_Client) {
		PlayIdleAnim = True;
		ToggleIdleAnimation();
	}
}

simulated function ToggleIdleAnimation()
{
	if(PlayIdleAnim)
	{
		BuildingSkeleton.PlayAnim(IdleAnimName,,True);
	}
	else
	{
		BuildingSkeleton.StopAnim();
	}
}

simulated function PostBeginPlay() 
{
	super.PostBeginPlay();
	if(ROLE == ROLE_Authority) {
		SetTimer(1.0,true,'HealOwningTeam');
	}
} 

function HealOwningTeam()
{
	local Rx_Pawn PawnToHeal; 
	
	if(GetTeamNum() == TEAM_UNOWNED) {
		return;
	}
	
	foreach AllActors(class'Rx_Pawn', PawnToHeal)
	{
		if(PawnToHeal.GetTeamNum() == GetTeamNum() && PawnToHeal.Health > 0) {
			PawnToHeal.regenerateHealth(RegenRate);
			PawnToHeal.SetMaxHealth(MaxHealthIncrease); 			
		}
	}
}

function IncreaseTeamMaxHealth()
{
	local Rx_Pawn PawnToIncrease ; 
	
	foreach AllActors(class'Rx_Pawn', PawnToIncrease)
	{
		if(PawnToIncrease.GetTeamNum() == GetTeamNum() && PawnToIncrease.Health > 0) {
			PawnToIncrease.SetMaxHealth(MaxHealthIncrease); 
		}
	}
	 
}

function ChangeTeamReplicate(TEAM ToTeam, optional bool bChangeFlag=false)
{
	super.ChangeTeamReplicate(ToTeam,bChangeFlag); 
	IncreaseTeamMaxHealth(); 
}

DefaultProperties
{
	Begin Object Name=BuildingSkeletalMeshComponent
		SkeletalMesh        		= SkeletalMesh'RX_BU_MedicalCentre.Mesh.SK_BU_Hospital'
		AnimSets(0)         		= AnimSet'RX_BU_MedicalCentre.Anims.AS_BU_Hospital'
		AnimTreeTemplate    		= AnimTree'RX_BU_MedicalCentre.Anims.AT_BU_Hospital'
		PhysicsAsset     			= PhysicsAsset'RX_BU_MedicalCentre.Mesh.SK_BU_Hospital_Physics'
		bEnableClothSimulation 	 	= True
		bClothAwakeOnStartup   	 	= True
		ClothWind              	 	= (X=100.000000,Y=100.000000,Z=20.000000)
		bAutoFreezeClothWhenNotRendered=true
	End Object

	
	`GdiUnderAttackForGdiSound = SoundNodeWave'RX_EVA_VoiceClips_Extra.gdi_eva.S_EVA_GDI_GDITech_UnderAttack'
	`GdiUnderAttackForNodSound = SoundNodeWave'RX_EVA_VoiceClips_Extra.Nod_EVA.S_EVA_Nod_GDITech_UnderAttack'

	`NodUnderAttackForGdiSound = SoundNodeWave'RX_EVA_VoiceClips_Extra.gdi_eva.S_EVA_GDI_NodTech_UnderAttack'
	`NodUnderAttackForNodSound = SoundNodeWave'RX_EVA_VoiceClips_Extra.Nod_EVA.S_EVA_Nod_NodTech_UnderAttack'
	
	TeamID          = 255
	
	MaxHealthIncrease = 150
	RegenRate = 2

	IdleAnimName    = "Turbine_Idle"

	AttachmentClasses.Add(Rx_BuildingAttachment_Door_GDI)
}
