param (
    [Parameter(Mandatory = $false)] [string]$LegacyPackage = ""
)

# 1. Detect the actual target package name from pubspec.yaml
$targetPackage = "rokctapp"
$pubspecPackage = ""
if (Test-Path "pubspec.yaml") {
    $content = Get-Content "pubspec.yaml" -Raw
    if ($content -match "name:\s*([a-zA-Z0-9_]+)") {
        $pubspecPackage = $Matches[1]
    }
}

# 2. Build the replacement map
$replacements = @{
    'package:foodyman'       = "package:$targetPackage"
    'package:vendorfoodyman' = "package:$targetPackage"
    'package:driver'         = "package:$targetPackage"
}

# If the current pubspec name is NOT rokctapp, we want to replace it too
if ($pubspecPackage -and $pubspecPackage -ne $targetPackage) {
    $replacements["package:$pubspecPackage"] = "package:$targetPackage"
    Write-Host "Detected current package '$pubspecPackage', targeting migration to '$targetPackage'." -ForegroundColor Yellow
}

# If a specific legacy package was passed in manually, add it
if ($LegacyPackage) {
    $replacements["package:$LegacyPackage"] = "package:$targetPackage"
}

Write-Host "Standardizing project imports to: $targetPackage" -ForegroundColor Cyan

Get-ChildItem -Path "lib" -Recurse -Filter *.dart | ForEach-Object { 
    $file = $_
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $modified = $false

    foreach ($old in $replacements.Keys) {
        if ($content.Contains($old)) {
            $content = $content.Replace($old, $replacements[$old])
            $modified = $true
        }
    }

    if ($modified) {
        [System.IO.File]::WriteAllText($file.FullName, $content)
        Write-Host "  Updated legacy names: $($file.Name)" -ForegroundColor Gray
    }
}

# Execute Harmonize for Styles and Relative Paths
powershell -ExecutionPolicy Bypass -File .\harmonize.ps1 -PackageName $targetPackage

# Extension: Validate API Endpoints against Frappe Backend
$backendPath = "C:\Users\sinya\Desktop\RokctAI\paas"
if (Test-Path "$PSScriptRoot\validate_endpoints.ps1") {
    Write-Host "`n--- Validating & Auto-Fixing API Endpoints ---" -ForegroundColor Cyan
    powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\validate_endpoints.ps1" -BackendRoot $backendPath -AppRoot $PSScriptRoot -AutoFix
}
else {
    Write-Host "`n[WARN] validate_endpoints.ps1 not found, skipping API validation." -ForegroundColor Yellow
}

# Extension: Generate Postman Collection
if (Test-Path "$PSScriptRoot\generate_postman.ps1") {
    Write-Host "`n--- Generating Postman Collection ---" -ForegroundColor Cyan
    powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\generate_postman.ps1"
}
else {
    Write-Host "`n[WARN] generate_postman.ps1 not found, skipping Postman generation." -ForegroundColor Yellow
}
