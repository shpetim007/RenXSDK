/*********************************************************
*
* File: TSR_VehicleFactory_Wolverine.uc
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
class TSR_VehicleFactory_Wolverine extends UTVehicleFactory;

DefaultProperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'TS_VH_Wolverine.Mesh.SK_VH_Wolverine_Reborn'
		Translation=(X=-40.0,Y=0.0,Z=-70.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+120.0
		CollisionRadius=+200.0
		Translation=(X=0.0,Y=0.0,Z=-40.0)
	End Object

	VehicleClassPath="RenX_Game.TSR_Vehicle_Wolverine"
	DrawScale=1.0
}
