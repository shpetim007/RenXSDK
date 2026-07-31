/**
 * This class initializes the Epic Online Services
 * 
 * Written by Declan Hanley <declanjoehanley@gmail.com>
 */
 class Rx_EOSUDK extends Object;
var bool bisInit;
//Should be called once, after the game engine is loaded
function bool InitEOS()
{
   //initializes the EOS, then checks if it intialized without error
   /*if(`RxEngineObject.EOSUDKDLL.initPlatform())
   {
      bisInit = true;
      return true;
   }
   else
   {
      `log("InitEOS failed");
      bisInit = false;
      return false;
   }*/
}

function bool isInit()
{
   return bisInit;
}
    
//Shall be called when a client connects to a server so the anti-cheat can be engaged    
event OnConnectToServer()
{
   `log("EOS connect to server");
}