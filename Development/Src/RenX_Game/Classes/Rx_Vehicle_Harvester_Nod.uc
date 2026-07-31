/*********************************************************
*
* File: Rx_Vehicle_Harvester_Nod.uc
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
class Rx_Vehicle_Harvester_Nod extends Rx_Vehicle_Harvester
    placeable;



DefaultProperties
{

//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\

	TeamNum = 1 

    Begin Object name=SVehicleMesh
        Materials(0)=MaterialInstanceConstant'RX_VH_Harvester.Materials.MI_VH_Harvester_Nod'
		AnimTreeTemplate=AnimTree'RX_VH_Harvester.Anims.AT_VH_Harvester_Nod'
    End Object
}
