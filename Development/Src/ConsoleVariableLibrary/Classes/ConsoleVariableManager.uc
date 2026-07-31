class ConsoleVariableManager extends Object dllbind(ConsoleVariableLibrary);

struct EnumeratorDelegateReference
{
    var delegate<OnEnumerateConsoleVariable> Value;
};

var private const ConsoleVariableManager DefaultObject;

private delegate OnEnumerateConsoleVariable(
    const string VariableName, const out pointer VariablePointer);

private final dllimport function bool FindConsoleVariableInternal(
    const string VariableName,
    const coerce int CaseSensitive,
    out pointer Result);

private final dllimport function EnumerateConsoleVariablesInternal(
    out EnumeratorDelegateReference EnumeratorDelegate,
    const string Pattern);

static final function ConsoleVariable FindConsoleVariable(
    const string VariableName,
    const optional bool bCaseSensitive = True)
{
    local pointer Result;

    if(default.DefaultObject.FindConsoleVariableInternal(
        VariableName, bCaseSensitive, Result))
    {
        return class'ConsoleVariable'.static.ConstructFromPointer(Result);
    }

    return None;
}

static final function EnumerateConsoleVariables(
    delegate<OnEnumerateConsoleVariable> Enumerator,
    const optional string Pattern)
{
    local EnumeratorDelegateReference EnumeratorDelegate;

    if(Enumerator != None)
    {
        EnumeratorDelegate.Value = Enumerator;

        default.DefaultObject.EnumerateConsoleVariablesInternal(
            EnumeratorDelegate, Pattern);
    }
}

defaultproperties
{
    DefaultObject = ConsoleVariableLibrary.Default__ConsoleVariableManager;
}
