class ConsoleVariable extends Object dllbind(ConsoleVariableLibrary);

struct StringReference
{
    var string Value;
};

const FLAG_Cheat = 1;
const FLAG_Dirty = 2;
const FLAG_ReadOnly = 4;
const FLAG_Unregistered = 8;

var private pointer WrappedVariablePointer;

static final function ConsoleVariable ConstructFromPointer(
    pointer VariablePointer)
{
    local ConsoleVariable Result;

    Result = new class'ConsoleVariable';
    Result.WrappedVariablePointer = VariablePointer;

    return Result;
}

private final dllimport function SetIntegerValueInternal(
    const int Value, const out pointer VariablePointer);

private final dllimport function SetFloatValueInternal(
    const float Value, const out pointer VariablePointer);

private final dllimport function SetStringValueInternal(
    const string Value, const out pointer VariablePointer);

/*
private final dllimport function SetHelpValueInternal(
    const string Value, const out pointer VariablePointer);
*/

private final dllimport function SetFlagsInternal(
    const int Value, const out pointer VariablePointer);

private final dllimport function int GetIntegerValueInternal(
    const out pointer VariablePointer);

private final dllimport function float GetFloatValueInternal(
    const out pointer VariablePointer);

private final dllimport function GetStringValueInternal(
    out StringReference Result, const out pointer VariablePointer);

private final dllimport function string GetHelpValueInternal(
    const out pointer VariablePointer);

private final dllimport function int GetFlagsInternal(
    const out pointer VariablePointer);

final function SetIntegerValue(const int Value)
{
    SetIntegerValueInternal(Value, WrappedVariablePointer);
}

final function SetFloatValue(const float Value)
{
    SetFloatValueInternal(Value, WrappedVariablePointer);
}

final function SetStringValue(const string Value)
{
    SetStringValueInternal(Value, WrappedVariablePointer);
}

/*
final function SetHelpValue(const string Value)
{
    SetHelpValueInternal(Value, WrappedVariablePointer);
}
*/

final function SetFlags(const int Value)
{
    SetFlagsInternal(Value, WrappedVariablePointer);
}

final function int GetIntegerValue()
{
    return GetIntegerValueInternal(WrappedVariablePointer);
}

final function float GetFloatValue()
{
    return GetFloatValueInternal(WrappedVariablePointer);
}

final function string GetStringValue()
{
    local StringReference Result;
    GetStringValueInternal(Result, WrappedVariablePointer);
    return Result.Value;
}

final function string GetHelpValue()
{
    return GetHelpValueInternal(WrappedVariablePointer);
}

final function int GetFlags()
{
    return GetFlagsInternal(WrappedVariablePointer);
}

defaultproperties
{
}
