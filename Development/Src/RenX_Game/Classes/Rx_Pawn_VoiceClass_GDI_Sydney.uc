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

class Rx_Pawn_VoiceClass_GDI_Sydney extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
	//Taunts
	TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Taunt_Hey'
	TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_NeedADrink'
	TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Taunt_HandleThis'
	TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Taunt_StandOverHere'
	TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_LookOut'
	TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Taunt_NotMuchTraining'
	TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_taunt_WatchMyBack'

	TauntLines(0)="Hey.";
	TauntLines(1)="I could sure use a drink.";
	TauntLines(2)="Think you can handle this?";
	TauntLines(3)="I'll just... stand over here.";
	TauntLines(4)="Look out!";
	TauntLines(5)="Don't have much training";
	TauntLines(6)="Watch my back";

	//Kill sounds
	KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_SeeYa'
	KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_HandsToSelf'
	KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_WonderWhy'
	KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Taunts_Sydney_WasteofAmmo'
	KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_GimmeAMinute'
	KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_CoastClear'
	KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_NowWhat'
	KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_WhatAmI'
	KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_kill_KindaFun'
	KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_kill_TakeThat'


	//Destroy Vehicle Sounds
	DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_WonderWhy'
	DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_YEAH'
	DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Taunts_Sydney_Gratifying'
	DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_NoYouDont'
	DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_HowOften'
	DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_vkill_FlameOn'
	DestroyVehicleSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_vkill_NotEnoughAmmo'

	//Death Sounds
	DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Death_1'
	DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Death_Death1'
	DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Death_2'
	DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Death_3'
	DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Death_4'

	//Take Damage sounds
	TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_Grunt2'
	TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_Grunt3'
	TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_Grunt1'
	
	//Take Damage Taunts
	TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_MedicWhenYouNeedOne'
	TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_ImHit'
	TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Hit_Ow'
	TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_HereWeGo'
	TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_Hey'
	TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_ItsNod'
	TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_hit_TheyreComing'
	

	BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Taunts_Sydney_Gratifying'

	AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_YEAH'
	AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_assist_NotTheLast'
	AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.sydney_assist_YouBoys'
	AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_Kill_WontHappenAgain'

	VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_VehicleAcquired_ComeInHandy'
	VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_sydney.Sydney_VehicleAcquired_ImDriving'
}





