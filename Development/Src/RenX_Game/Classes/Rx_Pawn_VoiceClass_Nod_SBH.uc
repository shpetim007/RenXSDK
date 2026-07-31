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

class Rx_Pawn_VoiceClass_Nod_SBH extends Rx_Pawn_VoiceClass
	abstract;

	
	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Die'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Laugh'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_Brother'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_Activity'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_Covered'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_HardOnYourself'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_SafeWithMe'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_Silent'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_WithYou'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_LasersAreReady'

TauntLines(0)="Die!";
TauntLines(1)="Haha!";
TauntLines(2)="Brother";
TauntLines(3)="Activity";
TauntLines(4)="Covered";
TauntLines(5)="Hard on Yourself";
TauntLines(6)="Safe With Me";
TauntLines(7)="Silent";
TauntLines(8)="With You";
TauntLines(9)="Lasers are ready";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Die'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Infidel'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Laugh'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_TakeThat'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_AmIWrong'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_AllTooEasy'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_DidntEvenSee'	
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_DoesItBurn'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Gotcha'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_ItStings'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Kane'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_OneLessGDI'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_PerfectShot'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_ScorchedEm'
KillConfirmSounds(14)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Vaporized'
KillConfirmSounds(15)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Blight'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_FirePower'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_Maggot'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_GloryofNod'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Taunt_TakeEmOut'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_Gotcha'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Kill_AllTooEasy'
DestroyVehicleSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_VKill_Heheh'


//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death4'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death5'
DeathSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death6'
DeathSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death7'
DeathSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Death8'


//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Grunt1'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Grunt2'

TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Wha'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Wha2'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Fire'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Hey'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_ImHit'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Infidels'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Target'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_There'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_YoureDead'
TakeDamageTauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Hit_Vaporize'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_StructureKill_NoBetter'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_VKill_Shame'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Assist_Faith'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Assist_Proud'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Assist_Impressive'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_Assist_Share'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_VehicleAcquired_NotAQuiet'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_VehicleAcquired_Ask'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_SBH.SBH_VehicleAcquired_NewCalling'

}







