/*********************************************************
*
* File: TSR_Pawn_VoiceClass_GDI_LightInfantry.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/

class TSR_Pawn_VoiceClass_GDI_LightInfantry extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
TauntSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_StandingBy'
TauntSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_InfantryReporting'
TauntSounds(2)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_UnitReady'
TauntSounds(3)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_NoProblem'
TauntSounds(4)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_Yeah'
TauntSounds(5)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_LoundAndClear'
TauntSounds(6)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_MoveYourAss'
TauntSounds(7)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_WithRespect'

TauntLines(0)="Standing By";
TauntLines(1)="Infantry Reporting";
TauntLines(2)="Unit Ready";
TauntLines(3)="No Problem";
TauntLines(4)="Yeah?";
TauntLines(5)="Loud And Clear";
TauntLines(6)="Move Your ASS!";
TauntLines(7)="With All Due Respect";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_GoodAsDone'
KillConfirmSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_ImOnIt'
KillConfirmSounds(2)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_WithRespect'
KillConfirmSounds(3)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_CavelryHasArrived'
KillConfirmSounds(4)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_StandingBy'
KillConfirmSounds(5)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_TakePointSoldier'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_CavelryHasArrived'
DestroyVehicleSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_GoodAsDone'
DestroyVehicleSounds(2)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_LoundAndClear'
DestroyVehicleSounds(3)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_TakePointSoldier'
DestroyVehicleSounds(4)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_ReadyForAction'

//Death Sounds
DeathSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_01'
DeathSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_02'
DeathSounds(2)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_03'
DeathSounds(3)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_04'
DeathSounds(4)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_05'
DeathSounds(5)=SoundNodeWave'TS_Unit_VoiceClips.Generic.S_Death_Male_06'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_ImTakingHeavyFire'
TakeDamageSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_WhereAreReinforcements'
TakeDamageSounds(2)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_HereTheyCome'
TakeDamageSounds(3)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_Medic'
TakeDamageSounds(4)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_MoveMoveMove'
TakeDamageSounds(5)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_MoveIt'
TakeDamageSounds(6)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_TheyAreEverywhere'
TakeDamageSounds(7)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_RunForIt'
TakeDamageSounds(8)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_NeedMoreMen'
TakeDamageSounds(9)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_DontShoot'
TakeDamageSounds(10)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_SomethingsWrong'

BuildingDestroyedSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_TakePointSoldier'
AssistSounds(0)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_NoProblem'
AssistSounds(1)=SoundNodeWave'TS_Unit_VoiceClips.GDI.Soldier.S_GDI_Soldier_YouGotIt'


}





