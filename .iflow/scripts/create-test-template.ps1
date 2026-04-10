# Create a test file template for a given source file
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceFile
)

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath

# Normalize source file path
$sourceFullPath = $SourceFile
if (-not [System.IO.Path]::IsPathRooted($sourceFullPath)) {
    $sourceFullPath = Join-Path $projectRoot $sourceFullPath
}

if (-not (Test-Path $sourceFullPath)) {
    Write-Host "❌ File not found: $sourceFullPath" -ForegroundColor Red
    exit 1
}

# Get file details
$fileName = [System.IO.Path]::GetFileNameWithoutExtension($sourceFullPath)
$relativePath = $sourceFullPath.Replace($projectRoot, "").TrimStart("\", "/").Replace("\", "/")

# Determine test type based on file location
$testType = "unit"
if ($relativePath -match 'lib/widgets/.*' -or $relativePath -match 'lib/ui/.*') {
    $testType = "widget"
} elseif ($relativePath -match 'lib/screens/.*' -or $relativePath -match 'lib/pages/.*') {
    $testType = "widget"
}

# Create test directory structure
$testDir = Join-Path $projectRoot "test\$testType"
if (-not (Test-Path $testDir)) {
    New-Item -ItemType Directory -Path $testDir -Force | Out-Null
}

# Test file path
$testFileName = "$fileName" + "_test.dart"
$testFilePath = Join-Path $testDir $testFileName

# Check if test already exists
if (Test-Path $testFilePath) {
    Write-Host "⚠️  Test file already exists: $testFilePath" -ForegroundColor Yellow
    exit 0
}

# Read source file to extract class/function names
$sourceContent = Get-Content $sourceFullPath -Raw
$classMatches = [regex]::Matches($sourceContent, 'class\s+(\w+)')
$functionMatches = [regex]::Matches($sourceContent, '(?:^|\s)(?:Future<\w+>\s+)?(\w+)\s*\([^)]*\)\s*(?:async\s*)?\{', [System.Text.RegularExpressions.RegexOptions]::Multiline)

$className = ""
if ($classMatches.Count -gt 0) {
    $className = $classMatches[0].Groups[1].Value
} else {
    $className = $fileName
}

# Generate test template
$template = @"
// Test for $fileName
// This file was auto-generated. Modify it as needed.

import 'package:flutter_test/flutter_test.dart';
import 'package:tutly/$($relativePath -replace '^lib/', '' -replace '\.dart$', '')';

void main() {
  group('$className', () {
    // Write your tests here
    // Example:
    /*
    test('should have correct initial state', () {
      // Arrange & Act & Assert
      expect(true, isTrue);
    });
    */

    test('placeholder test - replace with actual tests', () {
      // TODO: Implement actual tests for $className
      expect(true, isTrue, reason: 'Replace this with a real test');
    });
  });
}
"@

# Write test file
$template | Out-File -FilePath $testFilePath -Encoding UTF8

Write-Host "✅ Test file created: $testFilePath" -ForegroundColor Green
Write-Host "💡 Edit the test file to add your tests" -ForegroundColor Yellow

exit 0