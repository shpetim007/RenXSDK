/**
 *
 * Copyright 1998-2014 Epic Games, Inc. All Rights Reserved.
 */


class Rx_SeqAct_GetPlayerCount extends SequenceAction;

var int PlayerCount;

event Activated()
{
	if (GetWorldInfo().Game == none || GetWorldInfo().NetMode == NM_Client)
	{
		ScriptLog("WARNING: No WorldInfo or Game / Or running on client"); 
	}
	else
	{
        PlayerCount = GetWorldInfo().Game.NumPlayers; 
    
	}
}

defaultproperties
{
	bCallHandler=false
	ObjCategory="Ren X"
	ObjName="Get Playercount"
	VariableLinks(0)=(MaxVars=1)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="PlayerCount",PropertyName=PlayerCount,MaxVars=1,bWriteable=true)
}