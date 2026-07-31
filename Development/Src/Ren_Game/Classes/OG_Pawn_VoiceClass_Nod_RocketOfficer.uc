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

class OG_Pawn_VoiceClass_Nod_RocketOfficer extends Rx_Pawn_VoiceClass
	abstract;

	
defaultproperties
{
//Taunts
TauntSounds(0)= None

TauntLines(0)= None

//Kill sounds
KillConfirmSounds(0)= None

//Destroy Vehicle Sounds
DestroyVehicleSounds(0)= None

//Death Sounds
DeathSounds(0)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_01'
DeathSounds(1)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_02'
DeathSounds(2)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_03'
DeathSounds(3)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_04'
DeathSounds(4)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_05'
DeathSounds(5)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_06'
DeathSounds(6)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_07'
DeathSounds(7)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_08'
DeathSounds(8)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_09'
DeathSounds(9)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_10'
DeathSounds(10)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_11'
DeathSounds(11)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_12'
DeathSounds(12)=SoundNodeWave'OG_CharacterSounds.Sounds.S_Death_Classic_13'

//Take Damage sounds
TakeDamageSounds(0)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_01'
TakeDamageSounds(1)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_02'
TakeDamageSounds(2)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_03'
TakeDamageSounds(3)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_04'
TakeDamageSounds(4)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_05'
TakeDamageSounds(5)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_06'
TakeDamageSounds(6)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_07'
TakeDamageSounds(7)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_08'
TakeDamageSounds(8)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_09'
TakeDamageSounds(9)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_10'
TakeDamageSounds(10)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_11'
TakeDamageSounds(11)=SoundNodeWave'OG_CharSnd_Generic.Nod_RocketOfficer.S_RocketOfficer_Nod_DamageTaken_12'


BuildingDestroyedSounds(0)= None
AssistSounds(0)= None


}





