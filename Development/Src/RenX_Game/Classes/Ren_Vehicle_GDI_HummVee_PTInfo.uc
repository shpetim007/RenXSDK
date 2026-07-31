class Ren_Vehicle_GDI_HummVee_PTInfo extends Rx_Vehicle_PTInfo
; 

/*Base class to hold a vehicle's PT info*/

DefaultProperties
{
		PTIconTexture	=	Texture2D'RenXPurchaseMenu.T_Icon_Veh_GDI_Humvee'
		title	    	=	"HUMM-VEE"
		cost	    	=	"350"
		iconID			=	9
		bAircraft   	=   false
		desc			= 	"<font size='10'>-.50 Calibre Machine Gun\n-Light Armour\n-Fast Attack Scout\n-Driver + Passenger</font>"
		VehicleClass	= 	class'Ren_Vehicle_HummVee'
		PTString		=	"Buy Vehicle - Humm-Vee"
		
		GDIVehicleAnnouncment = SoundNodeWave'OG_EVA_VoiceClips.gdi_eva.S_EVA_GDI_UnitReady'
		NodVehicleAnnouncment = SoundNodeWave'OG_EVA_VoiceClips.Nod_EVA.S_EVA_Nod_UnitReady'
}