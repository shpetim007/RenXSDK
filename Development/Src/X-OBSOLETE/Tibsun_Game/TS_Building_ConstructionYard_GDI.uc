class TS_Building_ConstructionYard_GDI extends TS_Building_ConstructionYard
placeable;


DefaultProperties
{
	TeamID = TEAM_GDI

	TechTreeDesignation = "GAYARD"


	BuildingInternalsClass  = TS_Building_ConstructionYard_GDI_Internals

	Begin Object Name=Static_Exterior
		StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Exterior'
		MaxDrawDistance 				= 0.0
	End Object

	Begin Object Name=Static_Interior
		StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Interior'
	End Object

	Begin Object Name=PT_Screens
		StaticMesh = None
	End Object
	
	Begin Object Name=Static_Interior_Complex
        	StaticMesh=StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_MCV'
		MaxDrawDistance 				= 0.0
    End Object 

    Begin Object Class=StaticMeshComponent Name=Static_Catwalks
        StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Catwalks'
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
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
		bUsePrecomputedShadows          = False
		bForceDirectLightMap            = False
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 0
		LightingChannels                = (bInitialized=True,Static=False,Dynamic=True,Skybox=True)
		Translation						= (Z=-150)
		MaxDrawDistance 				= 8000.0
		LightEnvironment=MyLightEnvironment
    End Object
	StaticMeshPieces.Add( Static_Catwalks )
	Components.Add( Static_Catwalks )

    Begin Object Class=StaticMeshComponent Name=Static_Interior_Railing_01
        StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Interior_Railing_01'
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
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
		bUsePrecomputedShadows          = False
		bForceDirectLightMap            = False
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 0
		LightingChannels                = (bInitialized=True,Static=False,Dynamic=True,Skybox=True)
		Translation						= (Z=-150)
		MaxDrawDistance 				= 8000.0
		LightEnvironment=MyLightEnvironment
    End Object
	StaticMeshPieces.Add( Static_Interior_Railing_01 )
	Components.Add( Static_Interior_Railing_01 )

    Begin Object Class=StaticMeshComponent Name=Static_Interior_Railing_02
        StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Interior_Railing_02'
		CastShadow                      = True
		AlwaysLoadOnClient              = True
		AlwaysLoadOnServer              = false
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
		bUsePrecomputedShadows          = False
		bForceDirectLightMap            = False
		bAcceptsDynamicLights           = True
		ForcedLodModel 					= 0
		LightingChannels                = (bInitialized=True,Static=False,Dynamic=True,Skybox=True)
		Translation						= (Z=-150)
		MaxDrawDistance 				= 8000.0
		LightEnvironment=MyLightEnvironment
    End Object
	StaticMeshPieces.Add( Static_Interior_Railing_02 )
	Components.Add( Static_Interior_Railing_02 )

    FoundationMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Foundation_Constructed'
}