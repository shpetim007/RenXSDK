class Rx_Building_Hospital extends Rx_Building_Techbuilding
placeable;

simulated function String GetHumanReadableName()
{
	return "Hospital";
}

defaultproperties
{
	
	BuildingInternalsClass  = Rx_Building_Hospital_Internals

    Begin Object Name=Static_Exterior
        StaticMesh = StaticMesh'RX_BU_MedicalCentre.Mesh.SM_BU_Hospital_Exterior'
    End Object

    Begin Object Name=Static_Interior
        StaticMesh = StaticMesh'RX_BU_MedicalCentre.Mesh.SM_BU_Hospital_Interior'
    End Object

    Begin Object Name=Static_Interior_Complex
        StaticMesh = StaticMesh'RX_BU_MedicalCentre.Mesh.SM_BU_Hospital_Details'
    End Object

    Begin Object Class=StaticMeshComponent Name=SiloScreens
        CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = True
		CollideActors                   = True
		BlockActors                     = True
		BlockRigidBody                  = True
		BlockZeroExtent                 = True
		BlockNonZeroExtent              = True
		bCastDynamicShadow              = True
		bAcceptsLights                  = True
		bAcceptsDecalsDuringGameplay    = True
		bAcceptsDecals                  = True
		bAllowApproximateOcclusion      = True
		bUsePrecomputedShadows          = True
		bForceDirectLightMap            = True
		bAcceptsDynamicLights           = False
		LightingChannels                = (bInitialized=True,Static=True)
        StaticMesh                      = StaticMesh'RX_BU_MedicalCentre.Mesh.SM_BU_Hospital_MCT'
		Translation						= (Z=-150)
    End Object
	StaticMeshPieces.Add(SiloScreens)
	Components.Add(SiloScreens)

	IconTexture = Texture2D'RenxHud.T_Tech_MC'
}