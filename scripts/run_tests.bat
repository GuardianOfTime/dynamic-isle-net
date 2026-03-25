@echo off
REM Build and run all test cases (Windows Command Prompt)
setlocal enabledelayedexpansion
cd /d "%~dp0.."

echo Building solver...
g++ -std=c++17 -O2 -o solver.exe src\main.cpp
if errorlevel 1 exit /b 1

set failed=0
for %%f in (testcases\input*.txt) do (
  set "infile=%%f"
  set "base=%%~nf"
  REM base is e.g. input1 -> we need output1.txt (strip "input" prefix)
  set "num=!base:~5!"
  set "outfile=testcases\output!num!.txt"
  if exist "!outfile!" (
    set "name=%%~nxf"
    < "%%f" solver.exe > _got.txt 2>nul
    fc /b _got.txt "!outfile!" >nul 2>&1
    if errorlevel 1 (
      echo Testing !name! ... FAIL
      set /a failed+=1
    ) else (
      echo Testing !name! ... OK
    )
  )
)

if %failed% equ 0 (
  echo All tests passed.
  exit /b 0
) else (
  echo %failed% test^(s^) failed.
  exit /b 1
)
