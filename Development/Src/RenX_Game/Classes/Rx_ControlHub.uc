class Rx_ControlHub extends Object within Rx_Controller
config(EngineSettings);

var string EndpointURL;
var privatewrite array<string> AllClasses;
var Rx_Controller Controller;
var config string VersionUUID;

function Init()
{
	//local string Result, s, Pkgname;
	//local int i;
	//local array<string> Split;
//
	//Result = WorldInfo.ConsoleCommand("GETALL Class NetIndex", False);
    //ParseStringIntoArray(Result, AllClasses, ") Class ", False);
//
    //AllClasses.Remove(0, 1);
//
    //ForEach AllClasses(s, i)
    //{
    //    AllClasses[i] = Left(AllClasses[i], InStr(AllClasses[i], ".NetIndex ="));
    //    Split = SplitString(AllClasses[i],".");
    //    PkgName = Split[0];
    //    `log(PkgName);
    //}

    InitUUID();
}

function InitUUID()
{
	if (Len(VersionUUID) == 0)
		AssignUUID(class'Rx_UUID'.static.GenerateUUID());
}

function AssignUUID(string NewUUID)
{
	VersionUUID = NewUUID;
	SaveConfig();
}

function ReportClasses()
{
	local JsonObject Payload;
	local int i;
	local string LoadedClass;

	`log("Report classes activated");

	Payload = new class'JsonObject';

	ForEach AllClasses(LoadedClass, i)
	{
		Payload.SetStringValue(string(i), LoadedClass);
	}

	PostToAPI("ClassCheck", Payload);
}

function PostToAPI(string Type, JsonObject DataToSend)
{
	local HttpRequestInterface HTTPRequest;
	local string Payload;

	Payload = class'JsonObject'.static.EncodeJson(DataToSend);

	`log("Posting"@"Type:'"$Type$"'",,'Hub');

	HTTPRequest = class'HttpFactory'.static.CreateRequest();
	HTTPRequest.SetURL(EndpointURL);
	HTTPRequest.SetHeader("Content-Type", "application/json");
	HTTPRequest.SetVerb("POST");
	HTTPRequest.SetContentAsString(Payload);
	HTTPRequest.OnProcessRequestComplete = OnComplete;
	HTTPRequest.ProcessRequest();
}	

function OnComplete(HttpRequestInterface OriginalRequest, HttpResponseInterface InHttpResponse, bool bDidSucceed)
{
	if (!bDidSucceed)
	{
		`log("Post failed."@InHttpResponse.GetResponseCode(),,'Hub');
		return;
	}
}