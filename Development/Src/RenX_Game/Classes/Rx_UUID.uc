class Rx_UUID extends Object
abstract;

var const string HexChars[16];
var const array<byte> DashIdxs;
var const string FourthBlockFirstChars[4];

// Generates a UUIDv4
static function string GenerateUUID()
{
	local string NewUUID;
	local int i;
	
	for (i = 0; i < 36; i++)
	{
		// UUIDv4 always has a 4 in this position
		if (i == 15)
		{
			NewUUID $= "4";
			continue;
		}
		else if (i == 19)
		{
			NewUUID $= "9";
		}

		// Add dashes in correct positions
		if (default.DashIdxs.Find(i) != INDEX_NONE)
		{
			NewUUID $= "-";
			continue;
		}

		// Add a character from the list
		NewUUID $= default.HexChars[Rand(16)];
	}

	return NewUUID;
}

DefaultProperties
{
	HexChars(0)="0"
	HexChars(1)="1"
	HexChars(2)="2"
	HexChars(3)="3"
	HexChars(4)="4"
	HexChars(5)="5"
	HexChars(6)="6"
	HexChars(7)="7"
	HexChars(8)="8"
	HexChars(9)="9"
	HexChars(10)="a"
	HexChars(11)="b"
	HexChars(12)="c"
	HexChars(13)="d"
	HexChars(14)="e"
	HexChars(15)="f"

	DashIdxs(0)=9
	DashIdxs(1)=14
	DashIdxs(2)=19
	DashIdxs(3)=24
}