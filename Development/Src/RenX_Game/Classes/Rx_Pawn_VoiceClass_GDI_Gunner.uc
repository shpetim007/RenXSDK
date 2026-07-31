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

class Rx_Pawn_VoiceClass_GDI_Gunner extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunts_NoAmmo'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_OneLiners'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_Relax'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_SnappyLines'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_Training'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_NodObilisk'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_GetReady'

TauntLines(0)="Don't have the ammunition"
TauntLines(1)="Enough with the one liners"
TauntLines(2)="I can never relax"
TauntLines(3)="You'll need snappy lines"
TauntLines(4)="4 week training"
TauntLines(5)="Nod Obelisk"
TauntLines(6)="Stay low, Get ready"

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Apologies'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Fleeing'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_NotThatFunny'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Sorted'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Toasty'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Plenty4All'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Doubt'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_kill_Painfull'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_ABitMuch'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_WarmsMeHeart'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_VKill_NoWonder'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_PlentyToBlast'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_GoodTimes'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_03'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_10'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_11'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_12'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Hit_ImHit'

//Take Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Hit_GoingDown'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Hit_HereWeGo'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Taunt_AllYouHave'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Hit_TakeSomeOfThis'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_hit_InMySights'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_hit_Steady'
TakeDamageTauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_hit_TroubleAbout'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_VKill_Destructive'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_Wonders'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Assist_NotBad'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_Kill_GoodEnough'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_assist_ExcellentWork'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_assist_SupportFire'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.gunner_assist_Together'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_VehicleAcquired_LeftSeated'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_gunner.Gunner_VehicleAcquired_Mine'

}















