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

class Rx_Pawn_VoiceClass_Nod_RocketOfficer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_Eyes'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_Faith'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_WasntGood'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_GoodJob'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_HearThat'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_ImReady'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_Patience'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_Quiet'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_TiberiumsJustice'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.NodOfficer_Taunt_Munchies'

TauntLines(0)="Keep your eyes peeled!";
TauntLines(1)="Our faith keeps us strong!";
TauntLines(2)="That wasn't good.";
TauntLines(3)="Good job brothers!";
TauntLines(4)="That's the enemy";
TauntLines(5)="I'm ready brother";
TauntLines(6)="I must find patience";
TauntLines(7)="Quiet";
TauntLines(8)="Tiberium's justice";
TauntLines(9)="Anyone got any munchies?"

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_OneForKane'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_GloryofNod'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_AddTargetElim'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TargetEliminated'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Taunt_KillRating'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_ThisEasy'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_WasteOfAmmo'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_Allergic'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_BestGDI'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_EnjoyingThis'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_Target'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_Death'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_ForKane'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_SleepInfidel'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VKill_Fire'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Taunts_NodOfficer_BetterTargets'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_GloryofNod'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_TargetEliminated'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_OneForKane'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_EnjoyingThis'
DestroyVehicleSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_WasteOfAmmo'
DestroyVehicleSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VKill_Kick'
DestroyVehicleSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VKill_MyHand'
DestroyVehicleSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VKill_PraiseLeader'
DestroyVehicleSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VKill_TargetDestroyed'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_BHS.Nod_Sniper_Death_1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die1'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'

//Take Damage sounds
 TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'
 TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Grunt1'
 TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Grunt2'

//Damaged Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_Fireline'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Hit_GotInc'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Hit_EnemySighted'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Hit_HaveOne'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Hit_HereTheyCome'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Hit_MoreIncoming'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Hit_Target'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Kill_ForKane'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Kill_GloryofNod'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_Officer_Assist_NiceWork'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_DoYouHave'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_MyTarget'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_NotBad'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_Excessive'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_Reward'
AssistSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_Assist_Simple'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VehicleAcquired_HitTheRoad'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officer.Nod_RocketOfficer_VehicleAcquired_ThatHelps'
}





