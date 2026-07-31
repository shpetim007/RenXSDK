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

class Rx_Pawn_VoiceClass_Nod_ChemicalTrooper extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TooEasy'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Laugh'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TakeVitamins'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Taunt_ChemicalMixture'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_BKill_InTheName'

TauntLines(0)="All too easy!";
TauntLines(1)="Hahahahaha";
tauntLines(2)="Take your vitamins.";
tauntLines(3)="Chemixal mixture is set";
tauntLines(4)="In the name of Kane!";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_OneLess'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TakeThat'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Melted'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemSoldier_Kill_DeepBreath'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Gotcha'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Disentegrated'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Disolved'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_ForKane'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_ForTheBH'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Laugh2'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TargetEliminated'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_Kill_WantMore'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Laugh'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Gotcha'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Burn'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TargetEliminated'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_ForTheBH'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Death_DieHard2'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Death_DieHard'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Death_DieVeryHard'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Death_Die1'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_Death1'
DeathSounds(5)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_Death2'
DeathSounds(6)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_Death3'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_Grunt'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_Grunt2'

//Take Damage Taunts 
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_SprayEm'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_GotMe'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_Prepare'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_AttackBreh'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_HoldStill'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_Prep4Death'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_HaveyouNow'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_BattleCry'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_InfidelsHere'
TakeDamageTauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_RightHere'
TakeDamageTauntSounds(10)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_SprayThem'
TakeDamageTauntSounds(11)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_TheyreHere'
TakeDamageTauntSounds(12)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Hit_EnemySighted'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.Chemtrooper_BKill_InTheName'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_TooEasy'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_Laugh'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_Kill_OneLess'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_VehicleAcquired_ByKane'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.ChemTrooper.ChemTrooper_VehicleAcquired_Excellent'
}


