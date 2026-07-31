class Rx_Building_Defense extends Rx_Building
	abstract;

var() float Range_Multiplier;
var() bool bDisabled;
var vector SentinelLocation;

replication {
	if( bNetDirty && Role == ROLE_Authority )
		SentinelLocation;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if(WorldInfo.Game != None)
	{
		if(Rx_Building_GDI_Defense(Self) != None)
		{
			Rx_Game(WorldInfo.Game).AGT = Rx_Building_GDI_Defense(Self);
		}
		if(Rx_Building_Nod_Defense(Self) != None)
		{
			Rx_Game(WorldInfo.Game).Obelisk = Rx_Building_Nod_Defense(Self);
		}
	}
}
	
DefaultProperties
{
	myBuildingType=BT_Def
	Range_Multiplier = 1.0
	SupportedEvents.Add(class'Rx_SeqEvent_DefenseEvent')
			IconTexture=Texture2D'RenxHud.T_BuildingIcon_Defence_Normal'
}
