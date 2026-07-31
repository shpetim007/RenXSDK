class TSR_Vehicle_Nod_AttackCycle_PTInfo extends Rx_Vehicle_PTInfo
; 

/*Base class to hold a vehicle's PT info*/

DefaultProperties
{
		PTIconTexture	=	Texture2D'RenXPurchaseMenu.T_Icon_Veh_Nod_AttackCycle'
		title	    	=	"ATTACK CYCLE"
		cost	    	=	"500"
		iconID			=	11
		bAircraft   	=   false
		desc			= 	"<font size='10'>-SWARM Rockets\n-Hydra-70 Rockets\n-Very Light Armour\n-Fast Harasser\n-Driver Only</font>"
		VehicleClass	= 	class'TSR_Vehicle_AttackCycle'
		
		GDIVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.ts_eva.sn_eva_unitready'
		NodVehicleAnnouncment = SoundNodeWave'RX_EVA_VoiceClips_Extra.Nod_EVA.S_TS_CABAL_UnitReady_AttackCycle'
}