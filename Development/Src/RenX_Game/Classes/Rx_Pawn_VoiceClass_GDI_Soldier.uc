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

class Rx_Pawn_VoiceClass_GDI_Soldier extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts

TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Taunt_BlackHand'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Taunt_Scanning'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Taunt_GruntsLife'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Taunt_GotYouCovered'

TauntLines(0)="Black Hand";
TauntLines(1)="I'm scanning for targets";
TauntLines(2)="The grunt's life";
TauntLines(3)="I've got you covered, Sir!";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Taunts_GDISoldier_TargetWasted'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Taunts_GDISoldier_TargetDown'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Taunts_GDISoldier_WasteofAmmo'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_DirtyWork'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_QuarterStore'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_TakenCare'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_YouSeeThat'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Kill_RockRoll'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_VKill_ToomuchAmmo'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_TakenCare'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VKill_VehicleTarget'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VKill_Woohoo'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VKill_Smoke'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VKill_BrightenUp'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_03'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_01'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_12'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_25'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_26'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt4'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt5'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt2'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_Grunt6'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_HereTheyCome'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_HandleIt'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.GDI_Male.GDI_Soldier_Hit_Medic'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_Support'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_TakeThemDown'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_Target'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Kill_RockRoll'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Kill_Heh'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Assist_AnythingToHelp'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Assist_NotBad'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Assist_RushJob'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Assist_Bragging'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VehicleAcquired_LikeThis'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VehicleAcquired_RockAndRoll'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_VehicleAcquired_SundayDriver'
}





