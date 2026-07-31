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

class Rx_Pawn_VoiceClass_GDI_Patch extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Taunt_GettingTooOd'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_PresentForYou'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_DontResist'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Taunt_CallMe'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.patch_taunt_BitPassive'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.patch_taunt_YouHaveTo'

TauntLines(0)="Getting too old";
TauntLines(1)="Got a present for ya";
TauntLines(2)="Don't resist";
TauntLines(3)="Call me Patch.";
TauntLines(4)="Bit passive around here";
TauntLines(5)="You have to come out";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_NotThatBad'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_HereAllWeek'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_OldMemories'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_ProblemSolved'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Taunts_Apologies'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_ForGDI'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Taunts_Patch_WasteOfTime'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_Aim2Please'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_TooMuch'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_HaveYouNow'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_UnderControl'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_EnjoyWork'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_TooGood4'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_EnjoyWork'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_LoveThis'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_VKill_Exposions'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Vkill_PaintJob'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.patch_VKill_OldTimes'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.patch_vkill_HotSeat'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_12'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_17'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_18'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_22'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_23'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit4'
TakeDamageSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit5'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_YourMine'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_HaveTargets'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_HateGettingShot'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_HaveATarget'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_HaveThisOne'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_NotOver'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Hit_GotIncoming'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_VKill_Exposions'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_ProblemSolved'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_Kill_Excellent'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_assist_feelsGood'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_VehicleAcquired_Engines'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_patch.Patch_VehicleAcquired_Equipment'
}





