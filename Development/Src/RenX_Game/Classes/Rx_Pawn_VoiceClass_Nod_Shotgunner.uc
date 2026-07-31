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

class Rx_Pawn_VoiceClass_Nod_Shotgunner extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Taunt_Move'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Taunt_PraiseKane'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Taunt_ToArmsBrothers'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Taunt_WeaponsReady'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_DIE'

TauntLines(0)="Move!";
TauntLines(1)="Praise Kane!";
TauntLines(2)="To arms brothers!";
TauntLines(3)="Weapons ready";
TauntLines(4)="Die!";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_Gotcha'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_PraiseKane'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_Scum'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_TooEasy'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_Vanquished'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_DieInfidel'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_GotEm'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_Laugh'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_LetMeHearYouCry'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_WantMore'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotgunner_Kill_TakeThat'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_VKill_InTheNameOFKane'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_VKill_InTheNameOFKane'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_VKill_TargetEliminated'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Kill_LetMeHearYouCry'


//Death Sounds - todo add more
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Death4'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Death5'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Grunt1'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Grunt2'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_taunts_officerandsoldier.Nod_Soldier_Hit_Grunt3'

//Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_WatchOut'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_DIE'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Attack'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_EnemySighted'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_EngagingGDI'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_ImHit'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Hit_Incoming'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Hit_TheyreHere'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_RightHere'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_InTheName'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Assist_AllTooEasy'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_InTheName'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Assist_Laugh'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Assist_HesFinished'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Shotgunner.Nod_Shotguner_Assist_GDIMaggot'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_InTheName'

PersonalVolumeModifier=0.40
}





