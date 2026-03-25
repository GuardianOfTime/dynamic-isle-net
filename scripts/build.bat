@echo off
REM Build DynamicIsleNet solver (Windows Command Prompt)
cd /d "%~dp0.."

echo Building solver...
g++ -std=c++17 -O2 -o solver.exe src\main.cpp
if errorlevel 1 exit /b 1

echo Build succeeded: solver.exe
exit /b 0
