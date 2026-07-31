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

class Rx_Pawn_VoiceClass_GDI_Marksman extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_BeingWatched'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_ReligiousWar'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_RightBehindYou'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_StayAlert'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_GotYouCovered'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_AnythingUnusual'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Taunt_SomethingWrong'

TauntLines(0)="Are we being watched?";
TauntLines(1)="Religious war";
TauntLines(2)="Right behind you";
TauntLines(3)="Stay alert!";
TauntLines(4)="Got you covered";
TauntLines(5)="Anything unusual?";
TauntLines(6)="Is something wrong?";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_PrettyGood'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_NodRecruiters'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_LifeForMe'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_DidYouSee'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_DidThatHurt'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_TooEasy'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_PrettyGood'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_DidYouSee'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_01'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_02'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_03'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt3'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt4'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt5'

//Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Hit_IGotThisOne'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Hit_OnTheMove'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Hit_ThisOneIsMine'


BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Kill_DidYouSee'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_Woohoo'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_Woohoo'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_Lucky'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_Thanks'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_ThatOne'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_marksman.GDI_Marksman_Assist_TooEasy'

}





