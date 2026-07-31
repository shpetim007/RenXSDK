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

class Rx_Pawn_VoiceClass_GDI_DeadEye extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_Incompetence'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_NotSatisfied'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_Shutit'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_StopTalking'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_HandsBloody'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_GuyBar'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.Deadeye_Hit_Victims'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_ComeNow'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_taunt_JustComeOut'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_taunt_DontIrritate'

TauntLines(0)="Where do they train?"
TauntLines(1)="That's it?"
TauntLines(2)="Care to shut it?"
TauntLines(3)="Stop talking"
TauntLines(4)="Time to get my hands"
TauntLines(5)="A guy walks into a bar"
TauntLines(6)="Not now"
TauntLines(7)="Come now"
TauntLines(8)="Just come out and get shot"
TauntLines(9)="Don't irritate me"

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Taunt_Opinion'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Stings'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Scum'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_TargetDown'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.Deadeye_Kill_NotAllIHave'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Memories'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_HopeForMore'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.Deadeye_Kill_FilthyCre'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.Deadeye_Kill_IsThatAll'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Justice'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_NextLife'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.Deadeye_Kill_RotThere'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_MoreFP'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_AllWorkedUp'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Easier'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_VKill_SomethingBigger'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_vkill_EverythingMeSelf'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_03'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_12'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_28'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_18'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_03'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit4'
TakeDamageSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit5'

//Take damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Hit_Inc'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_Hit_OneForYa'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_PresentForYa'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_Kill_Idiots'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_assist_AboutTime'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_assist_Finally'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_assist_LongEnough'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.deadeye_assist_Situation'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_VehicleAcquired_Scavenge'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_deadeye.DeadEye_VehicleAcquired_Seatbelts'
}





