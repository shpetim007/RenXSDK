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

class Rx_Pawn_VoiceClass_Nod_Engineer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Taunt_Laugh'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Taunt_ShowYourself'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Taunt_SomethingsWrong'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Taunt_WhatWasThat'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_PraiseKane'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Scum'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_engineer.Nod_Engineer_Taunt_LookOut'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_engineer.Nod_Engineer_Taunt_MoveIt'

TauntLines(0)="Laugh";
TauntLines(1)="Show yourself!";
TauntLines(2)="Something's wrong";
TauntLines(3)="What was that?";
TauntLines(4)="Praise Kane!";
TauntLines(5)="Scum!";
TauntLines(6)="Look out, brother!";
TauntLines(7)="Move it!";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Die'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_GotEm'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Laugh'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_OneLess'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Scum'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_StayDown'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_TakeThat'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Vanquished'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_NameOfKane'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_ForTheBH'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_PraiseKane'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_NameOfKane'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_ForTheBH'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_TargetEliminated'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_GotEm'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Laugh'


//Death Sounds - todo add more
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Death4'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Death5'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Grunt'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Grunt_2'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Kill_Die'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Hit_Brothers'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Hit_Incoming'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_engineer.Nod_Engineer_Hit_UnderFire'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Hit_LookOut'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Hit_YouThere'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Hit_RightHere'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Infidels'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_engineer.Nod_Engineer_Hit_HelpMe'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_NameOfKane'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_NameOfKane'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Assist_DieInfidel'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Vkill_NameOfKane'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Assist_GDIMaggot'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Assist_GetEm'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Engineer.Nod_Engineer_Assist_HesFinished'

PersonalVolumeModifier=0.40
}





