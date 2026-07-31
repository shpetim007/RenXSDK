class Rx_Vehicle_GDI_HumveeTOW_PTInfo extends Rx_Vehicle_PTInfo
; 

/*Base class to hold a vehicle's PT info*/

DefaultProperties
{
		PTIconTexture	=	Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Humvee'
		title	    	=	"TOW HUMVEE"
		cost	    	=	"350"
		iconID			=	9
		bAircraft   	=   false
		desc			= 	"<font size='10'>-2x TOW Missiles\n-Very Light Armour\n-Fast Harasser\n-Driver Only</font>"
		VehicleClass	= 	class'Rx_Vehicle_HumveeTOW'
		PTString		=	"Buy Vehicle - TOW Humvee"
		
		GDIVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_UnitReady_Humvee'
		NodVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips.gdi_eva.S_EVA_GDI_UnitReady_Humvee'
}