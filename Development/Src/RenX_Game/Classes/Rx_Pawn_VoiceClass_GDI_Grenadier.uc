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

class Rx_Pawn_VoiceClass_GDI_Grenadier extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_AreaSecure'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_Thirsty'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_WhatsGoingOn'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_HappyDoingThis'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_CakeWalk'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_RightBehind'

TauntLines(0)="Area secure"
TauntLines(1)="Thirsty?"
TauntLines(2)="What's going on?"
TauntLines(3)="Happy doing this"
TauntLines(4)="Cake walk"
TauntLines(5)="Right behind you, sir"

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_AddToList'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_ChanceToRest'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_CouldBeBetter'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_GotOne'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_IGotYouNow'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_NoOne'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_WarmsMyHeart'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_Yeehaw'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VKill_TargetDestroyed'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Taunt_DontPayMuch'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VKill_TargetDestroyed'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VKill_VehicleDestroyed'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VKill_CantThink'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_Yeehaw'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Death_2'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_01'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_02'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_03'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.Death_Death3'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_EnemySpotted'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_HereWeGo'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_Ouch'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_UnderFire'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_WatchIt'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Hurt_WeGotIncoming'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Kill_Yeehaw'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Assist_FirstRound'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Assist_KeepUp'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Assist_ThatsSomeSkill'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_Assist_TheQuicker'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VehicleAcquired_Needed'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_grenadier.Grenadier_VehicleAcquired_Pedal'
}





