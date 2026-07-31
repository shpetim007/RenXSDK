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

class Rx_Pawn_VoiceClass_Nod_Officer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Taunt_KillThemAll'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Taunt_WheredYouGo'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Taunt_BegForYourLife'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Taunt_HaveYouHeard'

TauntLines(0)="Kill them all.";
TauntLines(1)="Where'd you go?";
TauntLines(2)="Beg for your life";
TauntLines(3)="Have you heard brother?";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_Messy'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_Scum'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_HowMany'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_Firepower'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TargetEliminated2'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TargetDown'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_BodyBag'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_GoodEnemy'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_Pro'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_SaveAmmo'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TakingCare'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TooGood'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_GDISoldier'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VKill_SeeThat'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TargetEliminated2'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VKill_TakenCareOff'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VKill_TargetDestroyed'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VKill_SeeThat'


//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.Nod_Sniper_Death_1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die1'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_Die2'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg3'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_oog'

//Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_HereWeGo'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_Incoming'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_KillEveryLast'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_MyTarget'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_TheresOne'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_ThisOne'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Bkill_StructureIsDown'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.NodOfficer_Assist_WithoutYa'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Assist_GoodJob'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Assist_Talents'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Asssist_Enjoying'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VehicleAcquired_Equipment'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_VehicleAcquired_LetsRoll'
}





