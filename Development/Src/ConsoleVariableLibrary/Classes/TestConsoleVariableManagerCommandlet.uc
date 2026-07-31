class TestConsoleVariableManagerCommandlet extends Commandlet;

const DefaultFogDensity = -1.0F;
const DefaultFogStartDistance = -1.0F;

private final function LogConsoleVariable(
    const string VariableName, const out pointer VariablePointer)
{
    local ConsoleVariable ConsoleVariable;

    ConsoleVariable = class'ConsoleVariable'.static.ConstructFromPointer(
        VariablePointer);

    `Log("Name            : " $ VariableName);
    `Log("Value (Integer) : " $ ConsoleVariable.GetIntegerValue());
    `Log("Value (Float)   : " $ ConsoleVariable.GetFloatValue());
    `Log("Value (String)  : " $ ConsoleVariable.GetStringValue());
    `Log("Flags           : " $ ToHex(ConsoleVariable.GetFlags()) $ "h");
    `Log("Help            : " $ ConsoleVariable.GetHelpValue());
}

event int Main(string Arguments)
{
    local WorldInfo WorldInfo;
    local ConsoleVariable FogDensity, FogStartDistance;

    FogDensity = class'ConsoleVariableManager'.static.FindConsoleVariable(
        "FogDensity");

    FogDensity.SetFlags(
        FogDensity.GetFlags() | class'ConsoleVariable'.const.FLAG_ReadOnly);

    if(FogDensity.GetFloatValue() > DefaultFogDensity)
    {
        FogDensity.SetFloatValue(DefaultFogDensity);
    }

    FogStartDistance = class'ConsoleVariableManager'.static
        .FindConsoleVariable("FogStartDistance");

    FogStartDistance.SetFlags(
        FogStartDistance.GetFlags()
        | class'ConsoleVariable'.const.FLAG_ReadOnly);

    if(FogStartDistance.GetFloatValue() > DefaultFogStartDistance)
    {
        FogStartDistance.SetFloatValue(DefaultFogStartDistance);
    }

    WorldInfo = class'WorldInfo'.static.GetWorldInfo();

    WorldInfo.ConsoleCommand("FogDensity 0");
    WorldInfo.ConsoleCommand("FogStartDistance 99999");

    class'ConsoleVariableManager'.static.EnumerateConsoleVariables(
        LogConsoleVariable);

    class'ConsoleVariableManager'.static.EnumerateConsoleVariables(
        None);

    return 0;
}

defaultproperties
{
    LogToConsole = True;
}
