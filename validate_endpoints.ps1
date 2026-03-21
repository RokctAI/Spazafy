# validate_endpoints.ps1
# This script validates and optionally auto-fixes API endpoints used in the Spazafy Flutter app across 'paas' and 'rcore' backends.

param (
    [string]$BackendBase = "C:\Users\sinya\Desktop\RokctAI",
    [string]$AppRoot = "C:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy",
    [switch]$AutoFix = $false
)

$errorLog = Join-Path $AppRoot "endpoint_errors.log"
"API Endpoint Error Log - Generated $(Get-Date)" | Out-File $errorLog -Encoding utf8

$apps = @{
    "paas" = Join-Path $BackendBase "paas\paas"
    "rcore" = Join-Path $BackendBase "rcore\rcore"
}
$libPath = Join-Path $AppRoot "lib"

Write-Host "--- Multi-App API Endpoint Validation & Auto-Fix ---" -ForegroundColor Cyan
Write-Host "Backends: $($apps.Keys -join ', ')" -ForegroundColor Gray
Write-Host "Flutter: $AppRoot" -ForegroundColor Gray
if ($AutoFix) { Write-Host "AUTO-FIX ENABLED" -ForegroundColor Green }

# 1. Parse aliases from hooks.py for ALL apps
Write-Host "[1/3] Parsing aliases from hooks.py..." -ForegroundColor Yellow
$aliases = @{} # Alias -> RealPath
foreach ($appName in $apps.Keys) {
    $hooksPath = Join-Path $apps[$appName] "hooks.py"
    if (Test-Path $hooksPath) {
        $hooksContent = Get-Content $hooksPath
        $inWhitelisted = $false
        foreach ($line in $hooksContent) {
            if ($line -match "whitelisted_methods\s*=\s*\{") { $inWhitelisted = $true; continue }
            if ($inWhitelisted -and $line -match "\}") { $inWhitelisted = $false; break }
            if ($inWhitelisted -and $line -match '"([^"]+)":\s*"([^"]+)"') {
                $aliases[$Matches[1]] = $Matches[2]
            }
        }
    }
}
Write-Host "  Found $($aliases.Count) total aliases across all apps." -ForegroundColor Gray

# 2. Extract endpoints from Flutter lib
Write-Host "[2/3] Extracting endpoints from Flutter lib..." -ForegroundColor Yellow
$endpointsUsed = @{} # Path -> FilePaths (list)
Get-ChildItem -Path $libPath -Recurse -Filter *.dart | ForEach-Object {
    $file = $_
    $content = Get-Content $file.FullName
    foreach ($line in $content) {
        if ($line -match "/api/v1/method/([\w\.]+)") {
            $path = $Matches[1]
            if (-not $endpointsUsed.ContainsKey($path)) {
                $endpointsUsed[$path] = New-Object System.Collections.Generic.List[string]
            }
            if (-not $endpointsUsed[$path].Contains($file.FullName)) {
                $endpointsUsed[$path].Add($file.FullName)
            }
        }
    }
}
Write-Host "  Found $($endpointsUsed.Count) unique endpoints used in app." -ForegroundColor Gray

# 3. Validate and Auto-Fix
Write-Host "[3/3] Validating (and fixing) against backends..." -ForegroundColor Yellow
$errors = 0
$valid = 0
$fixedCount = 0

function Log-Error([string]$msg) {
    Write-Host "  [ERR] $msg" -ForegroundColor Red
    $msg | Out-File $errorLog -Append -Encoding utf8
}

foreach ($endpoint in $endpointsUsed.Keys) {
    # Resolve through aliases first
    $realPath = $endpoint
    if ($aliases.ContainsKey($endpoint)) {
        $realPath = $aliases[$endpoint]
    }

    $parts = $realPath.Split('.')
    $foundApp = $false
    $targetAppPath = ""
    $appPrefix = $parts[0]

    if ($apps.ContainsKey($appPrefix)) {
        $foundApp = $true
        $targetAppPath = $apps[$appPrefix]
    }

    if (-not $foundApp) {
        if ($realPath -eq "login" -or $realPath -eq "upload_file") { continue }
        # Write-Host "  [WARN] Unknown app prefix: $appPrefix (Endpoint: $endpoint)" -ForegroundColor Gray
        continue
    }

    # Helper: Check if a dot-path is valid in a specific app
    function Check-DotPath([string]$dotPath, [string]$appPath) {
        $parts = $dotPath.Split('.')
        $funcName = $parts[-1]
        $moduleParts = $parts[1..($parts.Length - 2)]
        
        # Try as file
        $relativeFilePath = ($moduleParts -join "\") + ".py"
        $fullPath = Join-Path $appPath $relativeFilePath
        if (-not (Test-Path $fullPath)) {
            $relativePkgPath = ($moduleParts -join "\") + "\__init__.py"
            $fullPath = Join-Path $appPath $relativePkgPath
        }

        if (Test-Path $fullPath) {
            $content = Get-Content $fullPath
            for ($i = 0; $i -lt $content.Count; $i++) {
                if ($content[$i] -match "def\s+$funcName\(") {
                    for ($j = [Math]::Max(0, $i-3); $j -lt $i; $j++) {
                        if ($content[$j] -match "@frappe\.whitelist") { return $true }
                    }
                }
            }
        }
        return $false
    }

    if (Check-DotPath $realPath $targetAppPath) {
        $valid++
        continue
    }

    # If broken, search for the function in ALL apps to find true home
    $funcName = $parts[-1]
    $foundLocations = @()
    foreach ($searchAppName in $apps.Keys) {
        $searchAppPath = $apps[$searchAppName]
        Get-ChildItem -Path $searchAppPath -Recurse -Filter *.py -Exclude "venv","node_modules" | ForEach-Object {
            $pyFile = $_
            $pyContent = Get-Content $pyFile.FullName
            for ($i = 0; $i -lt $pyContent.Count; $i++) {
                if ($pyContent[$i] -match "def\s+$funcName\(") {
                    for ($j = [Math]::Max(0, $i-3); $j -lt $i; $j++) {
                        if ($pyContent[$j] -match "@frappe\.whitelist") {
                            $relToApp = $pyFile.FullName.Substring($searchAppPath.Length + 1)
                            $dotPath = "$searchAppName." + $relToApp.Replace(".py", "").Replace("\", ".").Replace(".__init__", "") + "." + $funcName
                            $foundLocations += $dotPath
                            break
                        }
                    }
                }
            }
        }
    }

    if ($foundLocations.Length -eq 1) {
        $trueHome = $foundLocations[0]
        if ($AutoFix) {
            foreach ($flutterFile in $endpointsUsed[$endpoint]) {
                $content = [System.IO.File]::ReadAllText($flutterFile)
                $pattern = [regex]::Escape("/api/v1/method/$endpoint")
                $content = [regex]::Replace($content, $pattern, "/api/v1/method/$trueHome")
                [System.IO.File]::WriteAllText($flutterFile, $content)
            }
            Write-Host "  [FIXED] $endpoint -> $trueHome" -ForegroundColor Green
            $fixedCount++
        } else {
            Log-Error "Mismatch: $endpoint found at $trueHome. Use -AutoFix to standardize."
            $errors++
        }
    } elseif ($foundLocations.Length -gt 1) {
        Log-Error "Ambiguous: $funcName found in multiple modules ($($foundLocations -join ', '))."
        $errors++
    } else {
        Log-Error "Not Found: Function '$funcName' not found or whitelisted in any app (Endpoint: $endpoint)."
        $errors++
    }
}

Write-Host ""
if ($errors -eq 0) {
    Write-Host "Success! $valid already correct, $fixedCount fixed. See $errorLog for details." -ForegroundColor Green
} else {
    Write-Host "Finished with $errors unresolved issues. $fixedCount fixed. Check $errorLog." -ForegroundColor Yellow
}
