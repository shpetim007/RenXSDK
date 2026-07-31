interface RxIfc_Harvester;

function RxIfc_Refinery GetRefinery();

function SetRefinery(RxIfc_Refinery NewRef);

function bool CanUnmanHarvy();

simulated function string GetFriendlyStateName();

function SetFriendlyStateName(string SetToString);

function AddTripNumber();

function harvInit();

function SetHarvestingAnim(bool bNewAnim);

function SetOpeningAnim(bool bNewAnim);

function SetClosingAnim(bool bNewAnim);

function SetTurningToDock(bool bNewTurn);

function bool IsTurningToDock();

function SetHasBlueTiberium(bool bNewTib);

simulated function bool HasBlueTiberium();