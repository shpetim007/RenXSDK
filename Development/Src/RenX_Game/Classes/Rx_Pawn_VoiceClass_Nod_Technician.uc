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

class Rx_Pawn_VoiceClass_Nod_Technician extends Rx_Pawn_VoiceClass
	abstract;
	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Taunt_NowhereToHide'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Hit_IllFight'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Taunt_Wrench'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Taunt_ByYourself'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_CandyBar'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_StayHere'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_WeCanTakeCareOfThis'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_LetsGetOutOfHere'

TauntLines(0)="There's no where to hide!";
TauntLines(1)="I'll fight you.";
TauntLines(2)="Where's my wrench?";
TauntLines(3)="You can't handle them?";
TauntLines(4)="Candy bar";
TauntLines(5)="Stay here until backup arrives";
TauntLines(6)="We can take care of this";
TauntLines(7)="Let's get out of here!";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_FieldTest'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_Whoops'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_Hurt'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_NoRest'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Nod_Officer_Sloppy'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_BackToWork'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_BigHeads'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_Easy'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_ExpectMore'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_SomethingBetter'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_FieldTest'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_Transfer'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_IHaveEm'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_NoRest'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_VKill_CombatBusiness'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_VKill_Wrong'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die1'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_oog'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_oog'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Hit_Help'

TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_ISeeSomeone'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_EnemySighted'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Run'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Incoming' 


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_BKill_BURN'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_BKill_OneBuilding'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Taunts_NodSoldier_ItsTheTW'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Assist_NiceOne'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_Kill_ExpectMore'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_ICantSeeEm'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_VehicleAcquired_SomethingUseful'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_technician.Technician_VehicleAcquisition_MoreOften'

PersonalVolumeModifier=0.60
}


