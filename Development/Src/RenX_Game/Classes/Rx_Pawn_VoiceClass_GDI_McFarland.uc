/*********************************************************
*
* File: RxVoice.uc
* Author: Totem Arts Team
* Project: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/

class Rx_Pawn_VoiceClass_GDI_McFarland extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_GasMask'
TauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_FoxTeam'
TauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_ExplosiveHaggis'
TauntSounds(3)=SoundNodeWave'RX_Dialogue.Mission_04.McFarland.S_McFarland_CoveOverHere'
TauntSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_FireInTheHole'
TauntSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_Crab'
TauntSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_SniperPosition'
TauntSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_Rockets1'
TauntSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_FlyingCoffins'

TauntLines(0)="Gas mask";
TauntLines(1)="Fox team, move out!";
TauntLines(2)="Explosive Haggins";
TauntLines(3)="Come over here";
TauntLines(4)="Fire in the hole!";
TauntLines(5)="What do they reckon";
TauntLines(6)="Sniper position";
TauntLines(7)="Rockets soldiers";
TauntLines(8)="Flying coffins";

//Kill sounds
KillConfirmSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_DidntSeeThat'
KillConfirmSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_CleanUpDuty'
KillConfirmSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_RememberMe'
KillConfirmSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_GreatTrophy'
KillConfirmSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_BasicTraining'
KillConfirmSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_Roasted'
KillConfirmSounds(6)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_Sergeant'
KillConfirmSounds(7)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kane'
KillConfirmSounds(8)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_LandofNod'

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_GreatTrophy'
DestroyVehicleSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_Roasted'
DestroyVehicleSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_NuclearBomb'
DestroyVehicleSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_Brechin'
DestroyVehicleSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Vkill_5thTime'

//Assist Sounds
AssistSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Assist_NearlyScared'
AssistSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Taunt_Laugh'
AssistSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_SmashThoseNoddies'
AssistSounds(3)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Assist_Carnage'
AssistSounds(4)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Assist_GreatWork'
AssistSounds(5)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Assist_Wiskey'

//Death Sounds
DeathSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_01'
DeathSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_07'
DeathSounds(2)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_28'
DeathSounds(3)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Death_22'


//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_01'
TakeDamageSounds(1)=SoundNodeWave'RX_CharacterSounds.Male.S_Male_Grunt_02'
TakeDamageSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_male.GDISoldier_Hit_Hit4'

//Take Damage Taunts
TakeDamageTauntSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Incoming'
TakeDamageTauntSounds(1)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Hit_IveGotThisOne'
TakeDamageTauntSounds(2)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Hit_TakeCover'

BuildingDestroyedSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Vkill_5thTime'
VehicleAcquiredSounds(0)=SoundNodeWave'RX_CharSnd_Generic.gdi_mcfarland.McFarland_Kill_GreatTrophy'
}





