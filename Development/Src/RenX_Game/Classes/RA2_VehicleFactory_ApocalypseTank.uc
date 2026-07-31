/*********************************************************
*
* File: RA2_VehicleFactory_ApocalypseTank.uc
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
class RA2_VehicleFactory_ApocalypseTank extends UTVehicleFactory;

DefaultProperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'RA2_VH_ApocalypseTank.Meshes.RA2_VH_ApocalypseTank'
		Materials(2)=MaterialInstanceConstant'RA2_VH_ApocalypseTank.Materials.MI_VH_ApocalypseTank_RenX'
		Translation=(X=-40.0,Y=0.0,Z=-70.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+120.0
		CollisionRadius=+200.0
		Translation=(X=0.0,Y=0.0,Z=-40.0)
	End Object

	VehicleClassPath="RenX_Game.RA2_Vehicle_ApocalypseTank"
	DrawScale=1.0
}
