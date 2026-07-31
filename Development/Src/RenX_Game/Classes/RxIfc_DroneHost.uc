interface RxIfc_DroneHost;

function bool GetHasDrone(); 

//0: Repair 
//1: Attack Stance
function BattleRole GetDroneStance(); 

//0: Repair 
//1: Attack Stance
function SetDroneStance(BattleRole NewStance);

function NotifyDroneDestroyed(); 