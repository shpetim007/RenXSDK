class FA_PurchaseSystem extends TS_PurchaseSystem;

simulated function bool AreHighTierPayClassesDisabled( byte teamID )
{
	return false;
}

simulated function bool IsCloseToInfantryBuilding(Rx_Controller rxPC, Actor OrientedActor, class<TS_FamilyInfo> FamInfo)
{
	return true;
}

DefaultProperties
{
	GDIInfantryClasses.Empty
	GDIInfantryClasses[0]  = class'TS_FamilyInfoSet_CQ_GDI_Assault'
	GDIInfantryClasses[1]  = class'TS_FamilyInfoSet_CQ_GDI_Engineer'
	GDIInfantryClasses[2]  = class'TS_FamilyInfoSet_CQ_GDI_Recon'
	GDIInfantryClasses[3]  = class'TS_FamilyInfoSet_CQ_GDI_Heavy'
	
	NodInfantryClasses.Empty
	NodInfantryClasses[0]  = class'TS_FamilyInfoSet_CQ_Nod_Assault'
	NodInfantryClasses[1]  = class'TS_FamilyInfoSet_CQ_Nod_Engineer'
	NodInfantryClasses[2]  = class'TS_FamilyInfoSet_CQ_Nod_Recon'
	NodInfantryClasses[3]  = class'TS_FamilyInfoSet_CQ_Nod_Heavy'
}