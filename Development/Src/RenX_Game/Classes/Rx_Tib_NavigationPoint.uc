class Rx_Tib_NavigationPoint extends NavigationPoint
   placeable;

var() byte TeamNum;
var() float HarvestCreditAmount;
var() bool IsBlueTiberium;

simulated event byte ScriptGetTeamNum () 
{
   return TeamNum;
}

simulated function byte GetTeamNum() {
	return TeamNum;
}

defaultproperties
{
   Begin Object Name=Sprite
       Sprite=Texture2D'RenX_AssetBase.DeathIcons.T_DeathIcon_Tiberium'
   End Object
   Components.Add(Sprite)
   GoodSprite=Sprite

   HarvestCreditAmount = 350

   IsBlueTiberium = false
}
