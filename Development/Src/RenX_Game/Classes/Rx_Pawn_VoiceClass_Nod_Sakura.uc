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

class Rx_Pawn_VoiceClass_Nod_Sakura extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Taunts_Sakura_Sloppy'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Taunts_Sakura_SkillsPiqued'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Taunt_NoNeedToBeAfraid'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Taunt_ItsSister'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_taunt_DontBeShy'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_taunt_TalkTooMuch'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_taunt_BetterToDo'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_taunt_hello'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Taunt_ComeOut'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Taunt_PlanOfAction'

TauntLines(0)="Looking sloppy today"
TauntLines(1)="Thought skills had peaked"
TauntLines(2)="I wont hurt you"
TauntLines(3)="It's sister, honey"
TauntLines(4)="Don't be shy"
TauntLines(5)="You talk too much"
TauntLines(6)="Don't you have anything better to do?"
TauntLines(7)="Hello"
TauntLines(8)="Come out"
TauntLines(9)="Plan of action"


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_DidThatHurt'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_GetAnyBetter'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_HandToSelf'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_RealMan'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_SayGoodNight'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_Shortlived'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_Tag'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Taunt_Gawking'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_WithKisses'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_CallAhead'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_AnotherDay'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_kill_Pressing'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_Ruined'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_PlayAnymore'


//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_FlatTire'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Taunts_Sakura_SkillsPiqued'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_Tag'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Kill_ThatsGood'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_01'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_10'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_08'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_12'
DeathSounds(4)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Death_11'


//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Female.S_Female_Grunt_02'

TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_Company'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_CryingOutloud'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_HereWeGo'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_TheresTrouble'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_Friends'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_Incoming'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_BKill_CleanYourRoom'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Hit_GetEm'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Taunts_Sakura_TheySuck'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.sakura_assist_OnARoll'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Taunts_Sakura_MuchFight'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Assist_BeSure'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Assist_TalkTooMuch'
AssistSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Assist_Brainwashing'
AssistSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Assist_GuardDown'
AssistSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_Assist_BackToBusiness'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_VehicleAcquired_LoveToDrive'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_sakura.Sakura_VehicleAcquired_Toys'
}





