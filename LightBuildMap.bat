
@echo off
set /p map="Enter Map: "

echo Using %map%
Binaries\Win64\UDK.exe editor %map% -AutomatedMapBuild CLDesc="Rebuilding %map%"
pause