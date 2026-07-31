/**Interface for anything with Veterancy**/

interface RxIfc_Veterancy;

function PromoteUnit(byte rank, optional bool bInitial) ;

simulated function CheckVRank(); //Update VRank if our state changed (IE infantry getting in and out of vehicles)

simulated function byte GetVRank();

simulated function float GetBuildingDamageModifier(optional byte FireModeTag); //Gets a multiplier for building damage from this thing (if any)