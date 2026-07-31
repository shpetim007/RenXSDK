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

class Rx_Pawn_VoiceClass_GDI_Officer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts

TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_NodBuddies'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_PartyFavours'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_ReconTime'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_DontExpose'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_Yesterday'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_HowMany'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_KeepYourBootsOn'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_KeepYourCool'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Taunt_PinTheTail'


TauntLines(0)="Is that my Nod Buddies I hear?";
TauntLines(1)="I've got the party favours";
TauntLines(2)="It's recon time";
TauntLines(3)="Don't expose yourself too early";
TauntLines(4)="As bad as yesterday";
TauntLines(5)="How many of them are there?";
TauntLines(6)="I gotcha";
TauntLines(7)="Keep your cool";
TauntLines(8)="Pin the tail";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_AllTheShooting'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_HowMuchMore'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_DownForCount'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_GotchaThatTime'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_Jumped'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_LivingFeeling'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_OnlyOne'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_Tiberium'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_TooEasy'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_Twitch'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_WayTooMuch'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_Tiberium'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Kill_WayTooMuch'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_VKill_LoveThisPart'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_VKill_Toasty'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.GDI_Male.Taunts_GDISoldier_VehicleDestroyed'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Death4'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Death5'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Grunt1'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Grunt2'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Grunt5'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Backup'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Backup2'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_MedicalSupport'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_GotIncoming'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_HereTheyCome'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Support'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_Incoming'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Hit_IncomingNod'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_BKill_BuildingIsDone'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_DoItAgain'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_Firefight'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_SaveSome'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_Squad'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_Support'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_WithUs'
AssistSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_ByTheNumbers'
AssistSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_Assist_WellManage'

VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_VehicleAcquired_FloorIt'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_officer.GDI_Officer_VehicleAcquired_GrabIt'
}





