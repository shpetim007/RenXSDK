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

class Rx_Pawn_VoiceClass_GDI_Mobius extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Taunts_Mobius_BetterUse'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_Distracted'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_OnlyMe'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_LeaveMEHere'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_TiredBones'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_CranialCap'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_Waitrighthere'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_ImReady'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_WelcomeWelcome'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Taunt_MoneyAndDamage'


TauntLines(0)="Fascinating";
TauntLines(1)="Let's move, shall we?";
TauntLines(2)="It's only me";
TauntLines(3)="Don't leave me here!";
TauntLines(4)="My tired bones are aching.";
TauntLines(5)="Cranial capacity";
TauntLines(6)="I'll just... wait right here.";
TauntLines(7)="I'm ready";
TauntLines(8)="Welcome welcome";
TauntLines(9)="Money and damage";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_GettingWorkedUp'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Intense'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_LetsDoIt'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Shaking'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_ItAppears'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Tryshooting'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Howmuchlonger'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Immoral'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_InjuredSomeone'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_OhApologies'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_TooExciting'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Destructive'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_VKill_Velocity'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_MarvelofScienceShort'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_GettingWorkedUp'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Atmosphere'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_07'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_09'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_16'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_15'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_27'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_BeenShot'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_Aggressive'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_LookOut'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_MuchMore'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_BitHostile'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_BKill_WrongBuilding'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_VKill_StructuralIntegrity'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_TooMuch'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Kill_Shaking'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Assist_FascinatingToWatch'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_Hit_Apologies'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_VehicleAcquired_BadDriver'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mobius.Mobius_VehicleAcquired_CanUseThis'
}





