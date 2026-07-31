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

class Rx_Pawn_VoiceClass_GDI_Havoc extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_Dialogue.Havoc.s_kill_havoc_present'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Taunt_CareerChange'
TauntSounds(2)=SoundNodeWave'RX_Dialogue.Mission_05.S_Havoc_HaveAllTheFun'
TauntSounds(3)=SoundNodeWave'RX_Dialogue.Mission_05.S_Havoc_MyToughestChallenge'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VKill_BlowinStuffUp'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_SeeWhatTheyWant'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_School'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_LoadofMe'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_taunt_MassDestruction'
TauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_taunt_WarToFight'

TauntLines(0)="Got a Present For Ya!";
TauntLines(1)="Time for a career change";
TauntLines(2)="All the fun";
TauntLines(3)="My toughest challenge";
TauntLines(4)="Don't get tired";
TauntLines(5)="Sounds like the enemy";
TauntLines(6)="Pay attention";
TauntLines(7)="Get a load of me";
TauntLines(8)="Time for mass";
TauntLines(9)="We got a war to fight";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Havoc.Wave.S_Havoc_Taunt_06'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Havoc.Wave.S_Havoc_TargetEliminated_01'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Havoc.Wave.S_Havoc_Taunt_07'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Taunt_Havoc_HomeAudience'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.GDI_Taunts_Havoc.Taunt_Havoc_ScoreOne'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Kill_Havoc_Woohoo'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Taunt_Havoc_RealTargets'
KillConfirmSounds(7)=SoundNodeWave'RX_Dialogue.Havoc.s_kill_havoc_keepemcoming'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_Hobby'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_TellFriends'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_Comedian'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_GetSome'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_BadIdea'
KillConfirmSounds(13)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_MissMe'
KillConfirmSounds(14)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_Record'
KillConfirmSounds(15)=SoundNodeWave'RX_Dialogue.Mission_06.S_6b_Havoc_HehHeh'
KillConfirmSounds(16)=SoundNodeWave'RX_Dialogue.Mission_05.S_Havoc_Hah'
KillConfirmSounds(17)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_BetterTarget'
KillConfirmSounds(18)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_DidntSpotThat'
KillConfirmSounds(19)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_DoBest'
KillConfirmSounds(20)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_DontThink'
KillConfirmSounds(21)=SoundNodeWave'RX_CharSnd_Generic.GDI_Taunts_Havoc.havoc_kill_FishInA'
KillConfirmSounds(22)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_Kill_GDIOne'
KillConfirmSounds(23)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_LoveTap'
KillConfirmSounds(24)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_NothingButSkill'
KillConfirmSounds(25)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_Overkill'
KillConfirmSounds(26)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_PAIN'
KillConfirmSounds(27)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_PatMyself'
KillConfirmSounds(28)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_SitDown'
KillConfirmSounds(29)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_Specialty'
KillConfirmSounds(30)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_StayDown'
KillConfirmSounds(31)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_Stupid'
KillConfirmSounds(32)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_TagYoureIt'
KillConfirmSounds(33)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_ToBeImpressed'
KillConfirmSounds(34)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_TooMuchFun'
KillConfirmSounds(35)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_kill_YoullFeelThat'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Kill_Havoc_Woohoo'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Kill_Havoc_LightemUp'
DestroyVehicleSounds(2)=SoundNodeWave'RX_Dialogue.Havoc.s_kill_havoc_lovethatsound'
DestroyVehicleSounds(3)=SoundNodeWave'RX_Dialogue.Mission_05.S_Havoc_NowThatsAFire'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VAssist_ChalkOne'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_LookEasy'
DestroyVehicleSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_vkill_CantBelieve'
DestroyVehicleSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_vkill_LotsOfStuff'
DestroyVehicleSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_VKill_Skill'
DestroyVehicleSounds(9)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_vkill_ThatsIt'
DestroyVehicleSounds(10)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_vkill_WaitingToDoThat'
DestroyVehicleSounds(11)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VKill_AirPollution'


//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Havoc.Havoc_Death_3'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Havoc.Havoc_Death_4'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Havoc.Havoc_Death_5'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Havoc.Havoc_Death_8'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Death_Oops'
DeathSounds(5)=SoundNodeWave'RX_CharSnd_Havoc.S_Havoc_Death_Locke1'
DeathSounds(6)=SoundNodeWave'RX_CharSnd_Havoc.S_Havoc_Death_Locke2'


//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Hit_ouh'
TakeDamageSounds(3)=SoundNodeWave'RX_CharSnd_Havoc.Wave.S_Havoc_UnderFire_01'
TakeDamageSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Hit_Havoc_Comeon'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Hit_huhuhk'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Hit_AllYouGot'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Hit_CutThatOut'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_Hit_GotCompany'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Hit_SpoilingMyMood'
	
BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VKill_RepairThat'
BuildingDestroyedSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VKill_DestroyedEnough'
BuildingDestroyedSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_SavingtheWorld'
BuildingDestroyedSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_GottaHurt'
BuildingDestroyedSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_bkill_InADaysWork'
BuildingDestroyedSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.havoc_bkill_TellKane'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Taunt_FairFight'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Kill_StayOff'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_NiceWork'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_AboutTime'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_Helpful'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_MoreGuns'
AssistSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_SoundsLike'
AssistSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_StickAround'
AssistSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_Assist_Thanks'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VehicleAcquired_AnotherTool'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VehicleAcquired_HandsAndFeet'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VehicleAcquired_MoreToys'
VehicleAcquiredSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_taunts_havoc.Havoc_VehicleAcquired_ScenicRoute'
VehicleAcquiredSounds(4)=SoundNodeWave'RX_CharSnd_Havoc.wave.S_Havoc_TimetoRocknRoll'

}





