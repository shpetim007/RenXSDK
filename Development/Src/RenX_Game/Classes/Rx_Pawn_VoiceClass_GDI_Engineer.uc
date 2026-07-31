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

class Rx_Pawn_VoiceClass_GDI_Engineer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts

TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_YesSir'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_CanItWait'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_Covered'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_GuardUp'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_IHeardSomething'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_NoProblem'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Taunt_SomeoneOutThere'

TauntLines(0)="Yes sir!";
TauntLines(1)="Can it wait?";
TauntLines(2)="I got you covered";
TauntLines(3)="Keep my guard up";
TauntLines(4)="I heard something";
TauntLines(5)="No problem";
TauntLines(6)="There's someone out there";


//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_BoundToBeMore'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_TakeThat'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_UhOh'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_Gotcha'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_SituationUnderControl'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_PaidEnough'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_Dead6'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Kill_IActuallyGotOne'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_BlewItUp'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_BringEmOn'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_IHaveyou'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_KeepBurning'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_PrettyGood'
DestroyVehicleSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Vkill_StandardIssue'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_01'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_07'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_27'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_20'


//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt4'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Grunt2'

// take Damage Taunts 
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Hit_ActivityArea'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Hit_Backup'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Hit_Incoming'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Hit_TakingFire'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Hit_There'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Bkill_StructureDown'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Assist_CleanUp'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Assist_GoodJob'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Assist_GotThatRight'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Assist_ThatsGoingToHurt'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_Assist_YouGuys'


VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_VAquired_LongTime'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_engineer.GDI_Engineer_VAquired_ThisShouldHelp'
}





