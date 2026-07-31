/*********************************************************
*
* File: Rx_CharInfo_Singleplayer.uc
* Author: Totem Arts Team
* Project: Totem Arts UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile: 
*
*********************************************************
*  
*********************************************************/
class Rx_BotCharInfo extends UTCharInfo;

DefaultProperties
{
	Families.Empty
	Families.Add(class'Rx_FamilyInfo_GDI_Soldier')
	Families.Add(class'Rx_FamilyInfo_Nod_Soldier')
}
