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

class Rx_Pawn_VoiceClass_Nod_Flamethrower extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.Taunts_FlameThrower_Ashes2Ashes'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameThrower_Kill_FTBros'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_Die'
TauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.Flametrooper_Taunt_YouLikeItHot'
//TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Taunt_FlamesAreReady'

TauntLines(0)="Ashes to ashes!";
TauntLines(1)="For the Brotherhood!";
TauntLines(2)="Die!";
TauntLines(3)="You like it hot?";
//TauntLines(4)="Flames are ready";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameThrower_Kill_Roasted'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameThrower_Kill_FTBros'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.Flamethrower_Kill_BURN'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Hahaha'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_TargetElim'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Broiled'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_FriedThem'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Gotcha'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Hahaheh'
KillConfirmSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_InTheName'
KillConfirmSounds(10)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Toasted'
KillConfirmSounds(11)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_TooHot'
KillConfirmSounds(12)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_WantMore'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameThrower_Kill_FTBros'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Hahaha'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_TargetElim'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_InTheName'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_Gotcha'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Death1'
DeathSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Death2'
DeathSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Death3'
DeathSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Death4'
DeathSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Death5'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_Grunt1'
TakeDamageSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_Grunt2'

//Damage Taunt Sounds
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_ToArms'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_HoldStill'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_BurnThem'
TakeDamageTauntSounds(3)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_EngagingGDI'
TakeDamageTauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_Firewood'
TakeDamageTauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_InfidelsBurnThem'
TakeDamageTauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_RightHere'
TakeDamageTauntSounds(9)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_There'
TakeDamageTauntSounds(10)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Hit_YouThere'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.Taunts_FlameThrower_Ashes2Ashes'

AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_Kill_TooEasy'

VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_VehicleAcquired_MuchBetter'
VehicleAcquiredSounds(1)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_VehicleAcquired_NeededThis'
VehicleAcquiredSounds(2)=SoundNodeWave'RX_CharSnd_Generic.Nod_FlameTrooper.FlameTrooper_VehicleAcquired_NotAsHot'

PersonalVolumeModifier=0.40
}





