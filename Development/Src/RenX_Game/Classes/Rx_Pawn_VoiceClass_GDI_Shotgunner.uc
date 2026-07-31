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

class Rx_Pawn_VoiceClass_GDI_Shotgunner extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts

TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_CoastIsClear'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_GoGoGo'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_KeepAnEyeOut'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_LetsRoll'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_LookingGood'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_MoveIt'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_StandingBy'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_UnderControl'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.GDI_Male.Taunts_GDISoldier_TERRORIST'

TauntLines(0)="Coast is clear";
TauntLines(1)="Go Go Go!";
TauntLines(2)="Keep an eye out";
TauntLines(3)="Let's roll!";
TauntLines(4)="Looking good here.";
TauntLines(5)="Move it!";
TauntLines(6)="Standing by";
TauntLines(7)="Situation is under control";
TauntLines(8)="Terrorist!";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_AnotherDown'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Kill_TakeThat'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_Alright'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_Haha'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_TargetEliminated'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_DidYouSee'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_Gotcha'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_GotEm'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_KeepEmComing'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_Payback'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_TakeThat'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_Payback'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_TargetEliminated'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Kill_AnotherDown'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_KeepEmComing'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_TakeThat'


//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Death4'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt4'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt5'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt2'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDI_Soldier_Hit_Grunt6'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_FoundThem'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_GotCompany'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_HereWeGo'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_There'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_ItsNod'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_TheyreComing'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Hit_Incoming'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Hit_ISeeSomeone'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Hit_Medic'
TakeDamageTauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Hit_NeedBackup'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_KeepEmComing'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Taunt_GoGoGo'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Assist_Yeah'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_KeepEmComing'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_shotgunner.GDI_Shotgunner_Kill_Payback'



}





