class TSR_Vehicle_Nod_TickTank_PTInfo extends Rx_Vehicle_PTInfo
; 

/*Base class to hold a vehicle's PT info*/

DefaultProperties
{
		PTIconTexture	=	Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_TickTank'
		title	    	=	"TICK TANK"
		cost	    	=	"900"
		iconID			=	22
		bAircraft   	=   false
		desc			= 	"<font size='10'>\n-75mm Cannon\n-Heavy Armour\n-Main Battle Tank\n-Driver + Passenger</font>"
		VehicleClass	= 	class'TSR_Vehicle_TickTank'
		
		GDIVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.ts_eva.sn_eva_unitready'
		NodVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.Nod_EVA.S_TS_CABAL_UnitReady_TickTank'
}