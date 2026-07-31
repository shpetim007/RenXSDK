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

class Rx_Pawn_VoiceClass_Nod_Mendoza extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Paid'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_GetitOn'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_ShowMe'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_KillMeIfYouCan'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Number'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_taunt_Battleplan'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_RunCoward'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_BleedGDI'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_taunt_CatchSomeBullets'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_IveBeenWaiting'

TauntLines(0)="Not getting paid";
TauntLines(1)="Let's get it on!";
TauntLines(2)="Show me what you've got!";
TauntLines(3)="Kill me if you can!";
TauntLines(4)="I've got your number.";
TauntLines(5)="Do we have some sort of battleplan";
TauntLines(6)="Run Coward!";
TauntLines(7)="You're gonna bleed GDI";
TauntLines(8)="Catch some bullets for me";
TauntLines(9)="I've been waiting for you";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_YouTry'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_LetDown'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_LineEmUp'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_MyPleasure'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Maggot'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Fool'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_MissedVitals'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Training'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_IsthatAll'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Laugh'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_kill_Laugh2'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_kill_WantMore'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Wasted'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Workout'
KillConfirmSounds(14)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_YoureDed'



//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Easy'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_PaidExtra'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_Coward'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_FightLikeAMan'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_Waste'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_VKill_Smoking'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Death_1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Death_2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Death_3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Death_4'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Grunt1'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Grunt2'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Death_4'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_FightingTime'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Lesson'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_Infidel'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_BrintItOn'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_ComeOn'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_SoonEnough'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_FeelsGood'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_hit_ThatAll'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Hit_YouThink'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Kill_AllWorkedUp'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_BKill_LaughLong'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_Taunt_Sheep'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_assist_GotLucky'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_assist_LikeIToldYou'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_assist_Plenty'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_VehicleAcquired_SweetWheels'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_VehicleAcquired_RightOn'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_mendoza.Mendoza_VehicleAcquired_TimeForAction'
}





