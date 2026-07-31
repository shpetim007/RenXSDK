/*********************************************************
*
* File: Rx_Vehicle_Chinook_GDI.uc
* Author: Totem Arts Team
* Poject: Renegade-X UDK <www.totemarts.games>
*
* Desc:
*
*
* ConfigFile:
*
*********************************************************
*
*********************************************************/
class Rx_Vehicle_Chinook_GDI extends Rx_Vehicle_Chinook
    placeable;


	
defaultproperties
{

/***********/
/*Vehicle Veterancy Block*/
/***********/

//VP Reward : Base VP give on death
//HealthMod: +HP for this rank
//SprintSpeedMod = Base Sprint Speed multiplied by this
//TTFD = Turn Torque Factor (Keeps vehicles from turning too hard when their sprint speed increases)

//RECRUIT
VetRankInfo(0) = (VPReward = 6, HealthMod = 1.0, SprintspeedMod = 1.0) 
VetRankInfo(1) = (VPReward = 6, HealthMod = 1.02, SprintspeedMod = 1.0) 
VetRankInfo(2) = (VPReward = 6, HealthMod = 1.05, SprintspeedMod = 1.0) 

//VETERAN
VetRankInfo(3) = (VPReward = 8, HealthMod = 1.1, SprintspeedMod = 1.05) 
VetRankInfo(4) = (VPReward = 8, HealthMod = 1.15, SprintspeedMod = 1.05) 
VetRankInfo(5) = (VPReward = 8, HealthMod = 1.2, SprintspeedMod = 1.05) 

//ELITE
VetRankInfo(6) = (VPReward = 10, HealthMod = 1.3, SprintspeedMod = 1.10) 
VetRankInfo(7) = (VPReward = 10, HealthMod = 1.4, SprintspeedMod = 1.10) 
VetRankInfo(8) = (VPReward = 10, HealthMod = 1.5, SprintspeedMod = 1.10) 

//HEROIC
VetRankInfo(9) = (VPReward = 14, HealthMod = 1.6, SprintspeedMod = 1.15) 

/******************/
    
//========================================================\\
//*************** Vehicle Visual Properties **************\\
//========================================================\\

    Begin Object name=SVehicleMesh
        Materials(0)=MaterialInstanceConstant'RX_VH_Chinook.Materials.MI_VH_Chinook_GDI'
    End Object
	
	SkeletalMeshForPT=SkeletalMesh'RX_VH_Chinook.Mesh.SK_PTVH_Chinook_GDI'

//========================================================\\
//*********** Vehicle Seats & Weapon Properties **********\\
//========================================================\\

    Seats(0)={( GunClass=None,
                CameraTag=CamView3P,
                CameraBaseOffset=(X=0, Z=0),
                CameraOffset=-800, //-700,
				bSeatVisible=true,
                SeatBone=MT_F,
                SeatOffset=(X=-75,Y=-27,Z=-3),
                SeatRotation=(Pitch=0,Yaw=0),
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=None
                )}

    Seats(1)={( GunClass=class'Rx_Vehicle_Chinook_Weapon_GDI_Left',
				TurretVarPrefix="GunnerLeft",
                GunSocket=(Fire_Left),
                TurretControls=(TurretPitch_Left,TurretRotate_Left),
                bSeatVisible=false,
                GunPivotPoints=(CGL_Yaw),
                CameraTag=CGL_ViewSocket,
                CameraBaseOffset=(Z=10),
                CameraOffset=-20,
                CameraEyeHeight=0,
                ViewPitchMin=0,
                ViewPitchMax=0,
                MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
                )}

    Seats(2)={( GunClass=class'Rx_Vehicle_Chinook_Weapon_GDI_Right',
				TurretVarPrefix="GunnerRight",
                GunSocket=(Fire_Right),
                TurretControls=(TurretPitch_Right,TurretRotate_Right),
                bSeatVisible=false,
                GunPivotPoints=(CGR_Yaw),
                CameraTag=CGR_ViewSocket,
                CameraBaseOffset=(Z=10),
                CameraOffset=-20,
                CameraEyeHeight=0,
                ViewPitchMin=0,
                ViewPitchMax=0,
                MuzzleFlashLightClass=class'RenX_Game.Rx_Light_AutoRifle_MuzzleFlash'
                )}
				
	Seats(3)={( CameraTag=CamView3P,
				TurretVarPrefix="Passenger1",
                bSeatVisible=false,
                CameraBaseOffset=(X=0, Z=0),
                CameraOffset=-800, //-700,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=None
                )}
				
	Seats(4)={( CameraTag=CamView3P,
				TurretVarPrefix="Passenger2",
                bSeatVisible=false,
                CameraBaseOffset=(X=0, Z=0),
                CameraOffset=-800, //-700,
                SeatIconPos=(X=0.5,Y=0.33),
                MuzzleFlashLightClass=None
                )}
				
	DrivingAnim=H_M_Seat_Apache
      

//========================================================\\
//********* Vehicle Material & Effect Properties *********\\
//========================================================\\
    UIString="Chinook"
}
