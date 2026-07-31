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

class Rx_Pawn_VoiceClass_GDI_HotWire extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Taunts_PresentForYa'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Taunt_Backup'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Kill_FeelFree'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Hit_Support'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_taunt_KeepCool'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_taunt_MySkills'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_taunt_WithYou'

TauntLines(0)="I've got this for you";
TauntLines(1)="I'm going to need backup";
TauntLines(2)="Feel free to join in";
TauntLines(3)="Support is always good!";
TauntLines(4)="Keep cool";
TauntLines(5)="My skills are too valuable";
TauntLines(6)="I'm right with you";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Kill_TooEasy'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Kill_SayHi'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.HotWire_Kill_Toomuch'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.HotWire_Kill_Later'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_kill_HaveYouNow'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_kill_Rest'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Kill_Hotwire_KillCount'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Kill_Hotwire_ItsMySpecialty'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Taunt_2MuchNoise'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.HotWire_Kill_DontRun'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_VKill_Garbage'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_vkill_LastDay'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_ComeDownHere'
DestroyVehicleSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_BurnSlowly'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_04'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_05'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_01'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_03'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_03'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_hit_Grunt'

//Take Damage Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_hit_Activity'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_hit_HereTheyCome'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_hit_TheresOne'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_hit_Trouble'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Kill_PresentForYou'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Kill_BetterThings'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_assist_FeelsGood'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.hotwire_assist_SupportFire'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.HotWire_Kill_Toomuch'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_RightWithYou'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_Assist_HearAboutThat'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_VehicleAcquired_Equipment'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_hotwire.Hotwire_VehicleAcquired_Repossession'
}





