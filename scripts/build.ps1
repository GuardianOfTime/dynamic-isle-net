# Build DynamicIsleNet solver
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $ProjectRoot
g++ -std=c++17 -O2 -o solver.exe src/main.cpp
if ($LASTEXITCODE -eq 0) { Write-Host "Build succeeded: solver.exe" -ForegroundColor Green }
