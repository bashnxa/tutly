# Validate that tests exist for modified files and all tests pass
# This script enforces TDD workflow

param(
    [Parameter(Mandatory=$false)]
    [string]$ChangedFiles = ""
)

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath

Write-Host "🔍 Starting TDD validation..." -ForegroundColor Cyan

# Function to check if a file has corresponding test
function Has-TestForFile {
    param([string]$filePath)

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
    $fileDir = [System.IO.Path]::GetDirectoryName($filePath)

    # Normalize paths
    $relativePath = $filePath.Replace($projectRoot, "").TrimStart("\", "/").Replace("\", "/")
    
    # Possible test file paths
    $testPaths = @(
        "test/$fileName" + "_test.dart",
        "test/$fileName" + ".test.dart",
        "test/unit/$fileName" + "_test.dart",
        "test/widget/$fileName" + "_test.dart",
        "test/integration/$fileName" + "_test.dart"
    )

    foreach ($testPath in $testPaths) {
        $fullTestPath = Join-Path $projectRoot $testPath.Replace("/", "\")
        if (Test-Path $fullTestPath) {
            return $true
        }
    }

    return $false
}

# Get modified files if not provided
if ([string]::IsNullOrEmpty($ChangedFiles)) {
    # Get staged files
    $stagedFiles = git diff --cached --name-only --diff-filter=ACM
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Not in a git repository or no staged files" -ForegroundColor Yellow
        exit 0
    }
    $filesToCheck = $stagedFiles
} else {
    $filesToCheck = $ChangedFiles -split ","
}

$libFiles = @()
foreach ($file in $filesToCheck) {
    if ($file -match '^lib/.*\.dart$' -and $file -notmatch '\.g\.dart$') {
        $libFiles += $file
    }
}

if ($libFiles.Count -eq 0) {
    Write-Host "✅ No Dart library files modified" -ForegroundColor Green
    exit 0
}

Write-Host "📁 Checking $($libFiles.Count) modified Dart file(s)..." -ForegroundColor Cyan

# Check each lib file has corresponding test
$filesWithoutTests = @()
foreach ($file in $libFiles) {
    $fullPath = Join-Path $projectRoot $file.Replace("/", "\")
    if (-not (Has-TestForFile -filePath $fullPath)) {
        $filesWithoutTests += $file
    }
}

if ($filesWithoutTests.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ TDD VIOLATION: The following files do not have tests:" -ForegroundColor Red
    foreach ($file in $filesWithoutTests) {
        Write-Host "   - $file" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "💡 Create tests before committing:" -ForegroundColor Yellow
    Write-Host "   test/<filename>_test.dart" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ All modified files have corresponding tests" -ForegroundColor Green

# Run all tests
Write-Host ""
Write-Host "🧪 Running Flutter tests..." -ForegroundColor Cyan

Set-Location $projectRoot
$testOutput = flutter test 2>&1
$testExitCode = $LASTEXITCODE

if ($testExitCode -ne 0) {
    Write-Host ""
    Write-Host "❌ TESTS FAILED" -ForegroundColor Red
    Write-Host $testOutput
    Write-Host ""
    Write-Host "💡 Fix failing tests before committing" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ All tests passed!" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 TDD validation successful!" -ForegroundColor Green

exit 0