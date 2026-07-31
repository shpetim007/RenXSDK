class Rx_Game_Utils extends Object;

enum STANCE
{
	STANCE_NEUTRAL,
	STANCE_ENEMY,
	STANCE_FRIENDLY
};

var transient Rx_Game Game;

/**
 * Checks the teams of the passed in actors and returns the stance, either Friendly, Enemy, or Neutral.
 */
static function STANCE GetStance(Actor inActorA, Actor inActorB)
{
	// If One actor isn't on GDI or Nod, Team will be neutral.
	if ((inActorA.GetTeamNum() != TEAM_GDI && inActorA.GetTeamNum() != TEAM_NOD) ||
		(inActorB.GetTeamNum() != TEAM_GDI && inActorB.GetTeamNum() != TEAM_NOD)) 
	{
		return STANCE_NEUTRAL;
	} 
	else if (inActorA.GetTeamNum() == inActorB.GetTeamNum())
	{
		return STANCE_FRIENDLY;
	}
	else
	{
		return STANCE_ENEMY;
	}
}

simulated static function float GetEMPDuration(const Pawn Target, const vector HurtOriginLoc, const float MinDuration, const float MaxDuration, const float MinRange, const float MaxRange)
{
    local float DistanceBetween;
    local name FoundBoneName;
    local vector FoundBoneLoc;
    local float CalculatedDuration;

    // Get closest location of vehicle/infantry
    FoundBoneName = Target.Mesh.FindClosestBone(HurtOriginLoc, FoundBoneLoc);

    // No bone/location at all, something wen't horribly wrong
    if (FoundBoneName == '' || IsZero(FoundBoneLoc))
    {
        return 0.0f;
    }

    DistanceBetween = VSize(HurtOriginLoc - FoundBoneLoc);

    // Right next to us, max duration
    if (DistanceBetween < MinRange)
    {
        return MaxDuration;
    }
    // Out of our range, no effect
    else if (DistanceBetween > MaxRange)
    {
        return 0.0f;
    }

    // Calculate Lerp alpha, this is not our real value yet
    CalculatedDuration = (MaxRange - DistanceBetween) / MaxRange;

    // Finally, get our real value scaled between min and max
    CalculatedDuration = Lerp(MinDuration, MaxDuration, CalculatedDuration);

    return CalculatedDuration;
}

DefaultProperties
{
}
