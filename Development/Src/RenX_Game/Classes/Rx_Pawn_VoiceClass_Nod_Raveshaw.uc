/*********************************************************
*
* File: RxVoice.uc
* Author: RenegadeX-Team
* Project: Renegade-X UDK <www.renegade-x.com>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/

class Rx_Pawn_VoiceClass_Nod_Raveshaw extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_DoMeAFavor'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_EasyTargets'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_TorchThem'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_NoSenseOfStyle'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_taunt_Aspirin'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_taunt_Elsewhere'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_KeepQuiet'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_Patience'

TauntLines(0)="Do me a favor";
TauntLines(1)="The infidels are easy targets.";
TauntLines(2)="Torch them.";
TauntLines(3)="No sense of style";
TauntLines(4)="Any aspirin?";
TauntLines(5)="Elsewhere";
TauntLines(6)="Keep quiet, brother";
TauntLines(7)="Patience brother";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_More'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_TheSmell'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_Unnecessary'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_WalkingInfront'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_AtrociousSight'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_SomethingOnYou'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_kill_Infidel'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_kill_Tiberium'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_kill_WalkInfront'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_TargetEliminated'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Taunt_WalkingInfront'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_EasyTarget'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_28'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_17'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_28'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_25'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_26'
DeathSounds(5)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_15'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Hit_oof'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Hit_Ag'

//Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_Fightme'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_SpottedMove'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_AssistMe'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Kill_KanePleased'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Hit_KillHim'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.raveshaw_assist_AbuseOfEgo'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.raveshaw_assist_More'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.raveshaw_assist_TheFaith'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_Assist_SelfPraise'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_VehicleAcquired_FirstTurn'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_raveshaw.Raveshaw_VehicleAcquired_Tool'
}





