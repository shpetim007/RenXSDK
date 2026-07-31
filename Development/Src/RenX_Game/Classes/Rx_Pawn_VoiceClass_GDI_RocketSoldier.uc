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

class Rx_Pawn_VoiceClass_GDI_RocketSoldier extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)= SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Taunt_ShouldntDoThis'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDIBlackGuy_Kill_UnderControl'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Taunt_HowsYourDay'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Taunt_WheredTheyGo'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Taunt_ImBusy'

TauntLines(0)="I shouldn't be doing this!";
TauntLines(1)="Situation under control";
TauntLines(2)="How's your day?";
TauntLines(3)="Where'd they go?";
TauntLines(4)="I'm busy";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Kill_TargetEliminated'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Kill_SoEasy'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Taunt_BlackGuy_StayDown'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDIBlackGuy_Kill_TakeThatE'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Kill_BoundToBe'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Kill_GotOne'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Kill_GotYouNow'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Black_Guy_Kill_TargetDestroyed'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Kill_SoEasy'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Kill_Extinguisher'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Kill_GotOne'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_VKill_GotEm'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_06'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_09'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_10'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_11'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_14'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit4'
TakeDamageSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit5'

//Take damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDIBlackGuy_Hit_TakingFire'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Hit_GotIncoming'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Hit_ThereTheyAre'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_Hit_WatchOut'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDIBlackGuy_Kill_UnderControl'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_BlackGuy_Kill_SoEasy'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_RocketOfficer_VehicleAcquired_MyTurn'

}





