class Rx_SeqAct_ReviveBuilding extends SequenceAction;

var Rx_Building Build;

event Activated()
{
	local SeqVar_Object ObjVar;
	
	foreach LinkedVariables(class'SeqVar_Object', ObjVar, "ModifiedActor")
	{
		Build = Rx_Building(ObjVar.GetObjectValue());
		if (Rx_Building_Team_Internals(Build.BuildingInternals) != None)
		{			
			Rx_Building_Team_Internals(Build.BuildingInternals).RestoreMe();
		}
	}
}

defaultproperties
{
   ObjName="Revive Building"
   ObjCategory="Ren X"
   Variablelinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="ModifiedActor",PropertyName=ModifiedActor)
   bCallHandler=false
}