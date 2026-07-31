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

class Rx_Pawn_VoiceClass_Nod_Soldier extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_CoverMe'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_Coward'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_WeServeTheBH'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_ThisShouldBeEasy'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_Surrender'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_StopDaydreaming'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_DooBieDooBieDoo'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_OnlyOneAttacking'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Taunt_SpotYourTargets'

TauntLines(0)="Cover me!";
TauntLines(1)="Come out, coward!";
TauntLines(2)="We serve the Brotherhood";
TauntLines(3)="This should be easy.";
TauntLines(4)="Surrender!";
TauntLines(5)="Stop daydreaming";
TauntLines(6)="Doo Bie Doo Bie Doo";
TauntLines(7)="Am I the only one attacking?";
TauntLines(8)="Spot your targets";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_TargetElim'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_NextOne'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_NapTime'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_SaveAmmo'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_ThatGotEm'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_OwnYou'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_ForTheBH1'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_GotEm'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Taunts_NodSoldier_GottaBeTougher'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_TimeForNap'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Solder_Kill_MessyWay'
//KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Solder_Kill_Eliminated'



//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_BonusKill'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_SaveAmmo'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_TargetDestroyed'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_ForTheBH1'


//Death Sounds - todo add more
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Death_Die1'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_oog'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'

//Take Damage sounds
TakeDamageSounds(0)= SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Uhg2'//SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_LookOut'
TakeDamageSounds(1)= SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_oog'  //SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_IGotTrouble'


TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_IllTakeThisOne'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_ImOnIt'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_ISeeSomeone'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_Target'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Hit_UhOh'
TakeDamageTauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Solder_Hit_Incoming'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VKill_TargetDestroyed'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.NodSoldier_Assist_Talent'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Kill_PieceOfCake'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.nod_soldier_assist_OurBest'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.nod_soldier_assist_PrettyGood'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Assist_WayTooMuchAction'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_Assist_NotTheLastOfThem'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VehicleAcquired_AllTheFun'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VehicleAcquired_Equipment'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.nod_taunts_officerandsoldier.Nod_Soldier_VehicleAcquired_TakeThisOne'

PersonalVolumeModifier=0.40
}





