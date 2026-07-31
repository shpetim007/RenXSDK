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

class Rx_Pawn_VoiceClass_Nod_Marksman extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_Attack'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_Move'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_Room'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_LookForMovement'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_SomethingsWrong'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_WatchOut'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Taunt_WatchSnipers'


TauntLines(0)="Attack, brothers!";
TauntLines(1)="Move brother!";
TauntLines(2)="I need more room";
TauntLines(3)="Look for movement";
TauntLines(4)="Something's wrong";
TauntLines(5)="Watch out!";
TauntLines(6)="Watch for snipers";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_DieInfidel'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_ForKane'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_ForTheBH'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Gotcha'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Kane'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Laugh'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Laugh2'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Laugh3'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_OneLessGDI'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_PerfectShot'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_TakeThat'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Vkill_Burn'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Vkill_Hot'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Vkill_WantMore'


//Death Sounds - todo add more
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Death4'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Grunt'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Grunt_2'

//Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Die'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_EnemySighted'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_HoldStill'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_Infidels'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_InfidelsHere'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_OpenFire'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_RightHere'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_There'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_TheyreHere'
TakeDamageTauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Hit_UnderFire'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Kane'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Kane'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Assist_Annihilated'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Vkill_WantMore'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_TakeThat'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_Marksman.Nod_Marksman_Kill_Laugh2'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_marksman.Nod_Marksman_Assist_KillEm'

PersonalVolumeModifier=0.40
}

