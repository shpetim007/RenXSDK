class FA_MapObjective_LoadoutPallet extends TS_MapObjective_LoadoutPallet;

DefaultProperties
{

	
	ActorName = "Supply Pallet" 
	
	
	Begin Object Name=ObstacleMesh
		StaticMesh						= StaticMesh'TS_Prop_Crate.Mesh.SM_Crate'
	End Object
		
	Begin Object Name=CollisionCylinder
		CollisionRadius     = 350.0f
		CollisionHeight     = 200.0f
		BlockNonZeroExtent  = True
		BlockZeroExtent     = false
		bDrawNonColliding   = True
		bDrawBoundingBox    = False
		BlockActors         = False
		CollideActors       = True
	End Object

}