class Rx_SeqEvent_Repaired extends SequenceEvent;

var(Heal) float HealThreshold;
var(Heal) float TeamNum;
var float HealMeter;
var(Heal) bool bResetHealOnToggle;

function HandleRepair(Actor InOriginator, Actor InInstigator, float HealAmount)
{
// local bool bAlreadyActivatedThisTick;

   if (bEnabled && InOriginator != None &&
      (!bPlayerOnly ||
       (InInstigator!= None && InInstigator.IsPlayerOwned())))
   {
      if(HealThreshold > 0)
         HealMeter += HealAmount;

      if(HealMeter >= HealThreshold || HealThreshold <= 0)
      {
//       bAlreadyActivatedThisTick = (bActive && ActivationTime ~= GetWorldInfo().TimeSeconds);
         if (CheckActivate(InOriginator,InInstigator,false))
         {
            if(HealThreshold > 0)
               HealMeter -= HealThreshold;
         }
      }
   } 
}

event Toggled()
{
   if (bResetHealOnToggle)
   {
      HealMeter = 0.f;
   }
   Super.Toggled();
}

defaultproperties
{
   ObjName="Repaired"
   ObjCategory="Renegade X General"

// There OutputLinks correspond to the TriggerEventClass function parameter. So if there should be more output links, it can be added at will

   OutputLinks[0]=(LinkDesc="Healed")

   bPlayerOnly=false
   MaxTriggerCount=0
   TeamNum = 255
}