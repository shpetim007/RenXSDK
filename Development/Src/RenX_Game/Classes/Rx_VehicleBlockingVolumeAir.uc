
class Rx_VehicleBlockingVolumeAir extends BlockingVolume
	placeable;

defaultproperties
{
	// BlockRigidBody must be set to true on the brush component AND the volume itself!
	// RBChannel of blocking volume will block all vehicles, so it too must be set to the channel you want to block
	Begin Object Name=BrushComponent0
		BlockRigidBody=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bDisableAllRigidBody=false
		RBChannel=RBCC_Untitled1
		RBCollideWithChannels=(Default=False,Nothing=False,Pawn=False,Vehicle=False,Water=False,GameplayPhysics=False,EffectPhysics=False,Untitled1=True,Untitled2=False,Untitled3=False,Untitled4=False,Cloth=False,FluidDrain=False,SoftBody=False,FracturedMeshPart=False,BlockingVolume=False,DeadPawn=False,Clothing=False,ClothingCollision=False)
	End Object

	bWorldGeometry=true
	bCollideActors=false
	bBlockActors=false
	bBlockCamera=false
	bMovable=false
	bStatic=true
	BlockRigidBody=true
}