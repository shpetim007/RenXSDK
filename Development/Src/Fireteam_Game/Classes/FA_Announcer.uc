class FA_Announcer extends Object;

struct Message
{
	var string TypeName;
	var SoundCue Sound[2]; //0 == gdi, 1 == nod
	var int Cooldown;
};

var const array<Message> SoundList;

static function SoundCue GetSoundOfType(string TypeName, byte TeamNum)
{
	return default.SoundList.Find('TypeName', TypeName) != INDEX_NONE ? default.SoundList[default.SoundList.Find('TypeName', TypeName)].Sound[TeamNum] : None;
}

static function int GetCooldownOfType(string TypeName)
{
	return default.SoundList.Find('TypeName', TypeName) != INDEX_NONE ? default.SoundList[default.SoundList.Find('TypeName', TypeName)].Cooldown : INDEX_NONE;
}

DefaultProperties
{
	// Type list

	// ATTACKERS
	// ZoneCaptured
	// ObjectiveCaptured, ObjectiveDisarmed, ObjectiveArmed
	// HalfTickets, QuarterTickets, TenthTickets

	// BOTH
	// NewObjective

	// DEFENDERS
	// ZoneLost
	// ObjectiveLost, ObjectiveUnderAttack, ObjectiveRecovered
	// EnemyHalfTickets, EnemyQuarterTickets, EnemyTenthTickets

	// 0 = GDI, 1 = Nod

	// ATTACKERS
	SoundList(0) = (TypeName="ZoneCaptured", 		  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(1) = (TypeName="ObjectiveCaptured", 	  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(2) = (TypeName="ObjectiveDisarmed", 	  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(3) = (TypeName="ObjectiveArmed", 		  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(4) = (TypeName="HalfTickets",			  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(5) = (TypeName="QuarterTickets", 		  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(6) = (TypeName="TenthTickets", 		  Cooldown=0, Sound[0]=, Sound[1]=)

	// BOTH
	SoundList(7) = (TypeName="NewObjective", 		  Cooldown=0, Sound[0]=, Sound[1]=)

	// DEFENDERS
	SoundList(8) = (TypeName="ZoneLost", 			  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(9) = (TypeName="ObjectiveLost", 		  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(10) = (TypeName="ObjectiveUnderAttack", Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(11) = (TypeName="ObjectiveRecovered",   Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(12) = (TypeName="EnemyHalfTickets",     Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(13) = (TypeName="EnemyQuarterTickets",  Cooldown=0, Sound[0]=, Sound[1]=)
	SoundList(14) = (TypeName="EnemyTenthTickets",    Cooldown=0, Sound[0]=, Sound[1]=)
}