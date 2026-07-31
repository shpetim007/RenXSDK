class TSR_Vehicle_GDI_Titan_PTInfo extends Rx_Vehicle_PTInfo
; 

/*Base class to hold a vehicle's PT info*/

DefaultProperties
{
		PTIconTexture	=	Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Titan'
		title	    	=	"TITAN"
		cost	    	=	"1000"
		iconID			=	11
		bAircraft   	=   false
		desc			= 	"<font size='10'>-120mm Cannon\n-Heavy Armour\n-Main Battle Mech\n-Driver + Passenger</font>"
		VehicleClass	= 	class'TSR_Vehicle_Titan'
		
		GDIVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.gdi_eva.S_TS_EVA_UnitReady_Titan'
		NodVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.ts_eva.sn_cabal_unitready'


		
}