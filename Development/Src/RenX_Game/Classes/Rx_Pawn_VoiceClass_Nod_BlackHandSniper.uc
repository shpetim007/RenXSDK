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

class Rx_Pawn_VoiceClass_Nod_BlackHandSniper extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_GDIAbominationLong'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_AtYourSide'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_MorningMass'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_Thinking'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_RadioForAssistance'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_IAssumeYouSeeTheTarget'

TauntLines(0)="GDI abomination";
TauntLines(1)="I'm at your side";
TauntLines(2)="Morning mass";
TauntLines(3)="Are you thinking what I'm thinking?";
TauntLines(4)="Radio for assistance";
TauntLines(5)="I assume you see the target";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_GDI'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_Incompetence'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_InfidelEliminated'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_NotWorthy'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_Stupid'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_TargetEliminated'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_Weaker'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_YourTime'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_EasyTimeLong'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_PraiseKane'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Kill_TargetEliminated'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_VKill_FieryWrath'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_BKill_Glorious'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.Nod_Sniper_Death_1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Death1'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Death2'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Death3'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Hit_Grunt2'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Hit_Hit1'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Hit_MyTarget'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Hit_TheresOne'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Hit_ThisTarget'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_StructureDown'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_BKill_Glorious'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_Taunt_AtYourSide'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_SuchAWayWithWords'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_LittleStamina'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_YouShowPromise'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_VehicleAcquired_FineMachine'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.NodSniper_VehicleAcquired_MyBrothers'
}


