class TS_BuildSpot_TeamBase_NEU_ConstructionYard extends TS_BuildSpot_TeamBase;



DefaultProperties
{
	Begin Object Name=Foundation
		StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Foundation_Unbuilt'
	End Object

	Begin Object Name=Visual
		StaticMesh = StaticMesh'TS_BU_ConstructionYard.Mesh.SM_BU_ConstructionYard_Exterior'
			Materials(0) = MaterialInstanceConstant'TS_Buildings_All.Materials.MI_BuildSlot_Editor_Blue'
			Materials(1) = MaterialInstanceConstant'TS_Buildings_All.Materials.MI_BuildSlot_Editor_Blue'
	End Object

	PreferredBuilding[0] = Class'tibsun_game.TS_Building_ConstructionYard_GDI_Internals'
	PreferredBuilding[1] = Class'tibsun_game.TS_Building_ConstructionYard_Nod_Internals'

	InitialBuilding[0] = Class'tibsun_game.TS_Building_ConstructionYard_GDI_Internals'
	InitialBuilding[1] = Class'tibsun_game.TS_Building_ConstructionYard_Nod_Internals'

}