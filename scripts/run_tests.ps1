# DynamicIsleNet - Build and run all test cases
$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Solver = Join-Path $ProjectRoot "solver.exe"
$Src = Join-Path $ProjectRoot "src\main.cpp"
$TestDir = Join-Path $ProjectRoot "testcases"

Set-Location $ProjectRoot

Write-Host "Building solver..." -ForegroundColor Cyan
& g++ -std=c++17 -O2 -o solver.exe src/main.cpp
if ($LASTEXITCODE -ne 0) { exit 1 }

$failed = 0
Get-ChildItem $TestDir -Filter "input*.txt" | ForEach-Object {
    $base = $_.BaseName -replace "^input", ""
    $outFile = "output$base.txt"
    $expected = Join-Path $TestDir $outFile
    if (-not (Test-Path $expected)) { return }
    $name = $_.Name
    Write-Host "Testing $name ... " -NoNewline
    $got = Get-Content $_.FullName | & $Solver
    $want = Get-Content $expected
    if (($got -join "`n") -eq ($want -join "`n")) {
        Write-Host "OK" -ForegroundColor Green
    } else {
        Write-Host "FAIL" -ForegroundColor Red
        $failed++
    }
}

if ($failed -eq 0) {
    Write-Host "All tests passed." -ForegroundColor Green
} else {
    Write-Host "$failed test(s) failed." -ForegroundColor Red
    exit 1
}
