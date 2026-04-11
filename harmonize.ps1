param (
    [Parameter(Mandatory = $false)] [string]$PackageName = ""
)

# ============================================================
# 1. Detect target package name — pubspec is source of truth
# ============================================================
$targetPackage = $PackageName
if (-not $targetPackage) {
    if (Test-Path "pubspec.yaml") {
        $pubContent = Get-Content "pubspec.yaml" -Raw
        if ($pubContent -match "(?m)^name:\s*([a-zA-Z0-9_]+)") {
            $targetPackage = $Matches[1]
        }
    }
}
if (-not $targetPackage) {
    Write-Host "ERROR: Could not determine package name. Ensure pubspec.yaml exists with a 'name:' field, or pass -PackageName explicitly." -ForegroundColor Red
    exit 1
}

Write-Host "Package: $targetPackage" -ForegroundColor Cyan

$libPath      = (Resolve-Path "lib").Path
$logFile      = (Join-Path (Get-Location) "broken_imports.log")
$brokenCount  = 0
$fixedCount   = 0
$skippedCount = 0
$normalizedCount = 0

"--- HARMONIZER REPORT (Created: $(Get-Date)) ---`n" | Out-File -FilePath $logFile -Encoding utf8
Write-Host "Harmonizing imports/exports for project: $targetPackage" -ForegroundColor Cyan

# ============================================================
# 2. Build filename -> [package paths] lookup map
# ============================================================
$dartFileMap = @{}
Get-ChildItem -Path "lib" -Recurse -Filter *.dart | ForEach-Object {
    $relativeToLib = $_.FullName.Substring($libPath.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar).Replace('\', '/')
    $packagePath   = "package:$targetPackage/$relativeToLib"
    $fileName      = $_.Name

    if (-not $dartFileMap.ContainsKey($fileName)) {
        $dartFileMap[$fileName] = [System.Collections.Generic.List[string]]::new()
    }
    $dartFileMap[$fileName].Add($packagePath)
}

# ============================================================
# 3. Compatibility check helpers
# ============================================================
function Get-ExportedIdentifiers {
    param([string]$filePath)

    $identifiers = [System.Collections.Generic.HashSet[string]]::new()
    if (-not (Test-Path $filePath)) { return $identifiers }

    $lines = [System.IO.File]::ReadAllLines($filePath)
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed.StartsWith("//") -or
            $trimmed.StartsWith("import") -or
            $trimmed.StartsWith("export") -or
            $trimmed.StartsWith("part")) { continue }

        $patterns = @(
            '^(?:abstract\s+|final\s+|sealed\s+|base\s+|interface\s+)?class\s+([A-Z][a-zA-Z0-9_]*)',
            '^enum\s+([A-Z][a-zA-Z0-9_]*)',
            '^mixin\s+([A-Z][a-zA-Z0-9_]*)',
            '^extension\s+([A-Za-z][a-zA-Z0-9_]*)\s+on',
            '^typedef\s+([A-Z][a-zA-Z0-9_]*)',
            '^const\s+(?:[A-Za-z_][a-zA-Z0-9_<>, ]*\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*=',
            '^final\s+(?:[A-Za-z_][a-zA-Z0-9_<>, ]*\s+)?([a-zA-Z_][a-zA-Z0-9_]*)\s*=',
            '^(?:[A-Za-z_][a-zA-Z0-9_<>?, ]*)\s+([a-z_][a-zA-Z0-9_]*)\s*\('
        )

        foreach ($pattern in $patterns) {
            if ($trimmed -match $pattern) {
                $null = $identifiers.Add($Matches[1])
                break
            }
        }
    }
    return $identifiers
}

function Get-UsedIdentifiers {
    param([string]$filePath)

    $identifiers = [System.Collections.Generic.HashSet[string]]::new()
    if (-not (Test-Path $filePath)) { return $identifiers }

    $lines = [System.IO.File]::ReadAllLines($filePath)
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed.StartsWith("//") -or
            $trimmed.StartsWith("import") -or
            $trimmed.StartsWith("export")) { continue }

        $matches = [regex]::Matches($trimmed, '\b([A-Z][a-zA-Z0-9_]*)\b')
        foreach ($m in $matches) {
            $null = $identifiers.Add($m.Groups[1].Value)
        }
    }
    return $identifiers
}

function Get-AbsPathFromPackagePath {
    param([string]$packagePath)
    $inner = $packagePath.Replace("package:$targetPackage/", "").Replace('/', [System.IO.Path]::DirectorySeparatorChar)
    return Join-Path $libPath $inner
}

# For exports: check the candidate has exportable identifiers (non-empty)
function Test-HasExportableContent {
    param([string]$candidateAbsPath)
    $exported = Get-ExportedIdentifiers -filePath $candidateAbsPath
    if ($exported.Count -gt 0) { return $true }
    # Also check if it has export directives itself (barrel file)
    $lines = [System.IO.File]::ReadAllLines($candidateAbsPath)
    foreach ($line in $lines) {
        if ($line.Trim().StartsWith("export")) { return $true }
    }
    return $false
}

# For imports: check the candidate exports something the importer actually uses
function Test-ImportCompatibility {
    param([string]$importerFile, [string]$candidateAbsPath)

    $exported = Get-ExportedIdentifiers -filePath $candidateAbsPath
    if ($exported.Count -eq 0) { return $null }  # unknown

    $used = Get-UsedIdentifiers -filePath $importerFile
    foreach ($id in $exported) {
        if ($used.Contains($id)) { return $true }
    }
    return $false
}

# For exports: check the candidate has content worth exporting
function Test-ExportCompatibility {
    param([string]$exporterFile, [string]$candidateAbsPath)

    $hasContent = Test-HasExportableContent -candidateAbsPath $candidateAbsPath
    if ($hasContent -eq $false) { return $null }  # unknown
    return $true
}

# ============================================================
# 4. Resolve a raw dart path to absolute path
# ============================================================
function Resolve-DartPath {
    param([string]$rawPath, [string]$currentDir)

    if ($rawPath.StartsWith("package:$targetPackage/")) {
        $inner = $rawPath.Replace("package:$targetPackage/", "").Replace('/', [System.IO.Path]::DirectorySeparatorChar)
        return Join-Path $libPath $inner
    }
    if ($rawPath.StartsWith("package:")) {
        # External package — leave it alone
        return $null
    }
    try {
        return [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($currentDir, $rawPath))
    } catch { return $null }
}

# ============================================================
# 5. Core: resolve broken path using compatibility check
# ============================================================
function Resolve-BrokenPath {
    param(
        [string]$rawPath,
        [string]$currentFile,
        [string]$lineRef,
        [string]$directiveType   # "import" or "export"
    )

    $brokenFileName = [System.IO.Path]::GetFileName($rawPath)

    if (-not $dartFileMap.ContainsKey($brokenFileName)) {
        $script:brokenCount++
        "$lineRef MISSING (not found anywhere in lib/): $rawPath" | Add-Content -Path $logFile
        Write-Host "  [MISSING] $lineRef - '$brokenFileName' not found in lib/" -ForegroundColor Red
        return $null
    }

    $candidates   = $dartFileMap[$brokenFileName]
    $compatible   = @()
    $unknown      = @()
    $incompatible = @()

    foreach ($candidate in $candidates) {
        $candidateAbs = Get-AbsPathFromPackagePath -packagePath $candidate

        if ($directiveType -eq "import") {
            $result = Test-ImportCompatibility -importerFile $currentFile -candidateAbsPath $candidateAbs
        } else {
            $result = Test-ExportCompatibility -exporterFile $currentFile -candidateAbsPath $candidateAbs
        }

        if ($result -eq $true)  { $compatible   += $candidate }
        elseif ($result -eq $null) { $unknown    += $candidate }
        else                    { $incompatible  += $candidate }
    }

    # ---- Decision tree ----

    # Exactly one compatible, no unknowns — best case
    if ($compatible.Count -eq 1 -and $unknown.Count -eq 0) {
        $script:fixedCount++
        "$lineRef FIXED (verified): '$rawPath' -> '$($compatible[0])'" | Add-Content -Path $logFile
        Write-Host "  [FIXED]  $(Split-Path $currentFile -Leaf) -> $($compatible[0])" -ForegroundColor Green
        return $compatible[0]
    }

    # Two or more compatible — ambiguous intent, do not fix
    if ($compatible.Count -ge 2) {
        $script:skippedCount++
        $entry = "$lineRef AMBIGUOUS ($($compatible.Count) compatible): '$rawPath'`n"
        foreach ($c in $compatible)   { $entry += "    [COMPATIBLE]   $c`n" }
        foreach ($c in $incompatible) { $entry += "    [INCOMPATIBLE] $c`n" }
        $entry | Add-Content -Path $logFile
        Write-Host "  [AMBIGUOUS] $(Split-Path $currentFile -Leaf) - $($compatible.Count) compatible candidates, manual fix needed" -ForegroundColor Yellow
        return $null
    }

    # One compatible plus some unknowns — fix but note the unknowns
    if ($compatible.Count -eq 1 -and $unknown.Count -ge 1) {
        $script:fixedCount++
        "$lineRef FIXED (1 compatible, $($unknown.Count) unverified ignored): '$rawPath' -> '$($compatible[0])'" | Add-Content -Path $logFile
        Write-Host "  [FIXED~] $(Split-Path $currentFile -Leaf) -> $($compatible[0]) ($($unknown.Count) unverified ignored)" -ForegroundColor DarkGreen
        return $compatible[0]
    }

    # No compatible, one unknown — fix with warning
    if ($compatible.Count -eq 0 -and $unknown.Count -eq 1) {
        $script:fixedCount++
        "$lineRef FIXED (unverified - candidate exports nothing parseable): '$rawPath' -> '$($unknown[0])'" | Add-Content -Path $logFile
        Write-Host "  [FIXED?] $(Split-Path $currentFile -Leaf) - unverified -> $($unknown[0])" -ForegroundColor DarkYellow
        return $unknown[0]
    }

    # No compatible, multiple unknowns — can't distinguish
    if ($compatible.Count -eq 0 -and $unknown.Count -ge 2) {
        $script:skippedCount++
        $entry = "$lineRef AMBIGUOUS (multiple unverifiable): '$rawPath'`n"
        foreach ($c in $unknown) { $entry += "    [UNVERIFIED] $c`n" }
        $entry | Add-Content -Path $logFile
        Write-Host "  [AMBIGUOUS] $(Split-Path $currentFile -Leaf) - multiple unverifiable candidates" -ForegroundColor Yellow
        return $null
    }

    # Candidates exist but none are compatible
    $script:brokenCount++
    $entry = "$lineRef NO COMPATIBLE MATCH: '$rawPath'`n"
    foreach ($c in $incompatible) { $entry += "    [INCOMPATIBLE] $c`n" }
    $entry | Add-Content -Path $logFile
    Write-Host "  [NO MATCH] $(Split-Path $currentFile -Leaf) - candidates found but none compatible" -ForegroundColor Red
    return $null
}

# ============================================================
# 6. Process a single import or export line
# ============================================================
function Convert-DartDirective {
    param(
        [string]$line,
        [string]$currentFile,
        [string]$currentDir,
        [string]$lineRef,
        [string]$directiveType   # "import" or "export"
    )

    if (-not ($line -match "(?:import|export)\s+['""]([^'""]+\.dart)['""]")) {
        return $line
    }

    $rawPath = $Matches[1]

    # Skip external packages (not ours)
    if ($rawPath.StartsWith("package:") -and -not $rawPath.StartsWith("package:$targetPackage/")) {
        return $line
    }

    # Skip dart: core imports
    if ($rawPath.StartsWith("dart:")) {
        return $line
    }

    $targetAbsPath   = Resolve-DartPath -rawPath $rawPath -currentDir $currentDir
    $isPackageImport = $rawPath.StartsWith("package:$targetPackage/")

    if ($null -eq $targetAbsPath) { return $line }

    if (Test-Path $targetAbsPath) {
        # File exists — normalize to full package path if not already
        if (-not $isPackageImport -and $targetAbsPath.ToLower().StartsWith($libPath.ToLower())) {
            $relativeToLib = $targetAbsPath.Substring($libPath.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar).Replace('\', '/')
            $newPath       = "package:$targetPackage/$relativeToLib"

            # Preserve any trailing show/hide/as clauses
            $suffix = ""
            if ($line -match "\.dart['""](.*)$") { $suffix = $Matches[1].TrimEnd(';') }

            $script:normalizedCount++
            return "${directiveType} '$newPath'$suffix;"
        }
        # Already a full package path — nothing to do
        return $line
    }
    else {
        # Broken path — run full resolution
        $resolved = Resolve-BrokenPath -rawPath $rawPath -currentFile $currentFile -lineRef $lineRef -directiveType $directiveType
        if ($null -ne $resolved) {
            $suffix = ""
            if ($line -match "\.dart['""](.*)$") { $suffix = $Matches[1].TrimEnd(';') }
            return "${directiveType} '$resolved'$suffix;"
        }
        return $line
    }
}

# ============================================================
# 7. Main processing loop
# ============================================================
Get-ChildItem -Path "lib" -Recurse -Filter *.dart | ForEach-Object {
    $file       = $_
    $content    = [System.IO.File]::ReadAllLines($file.FullName)
    $modified   = $false
    $newLines   = @()
    $currentDir = Split-Path $file.FullName -Parent

    for ($i = 0; $i -lt $content.Count; $i++) {
        $line    = $content[$i]
        $newLine = $line
        $lineRef = "[$($file.FullName):$($i+1)]"

        # Skip full-line comments
        if ($newLine.Trim().StartsWith("//")) {
            $newLines += $newLine
            continue
        }

        # Skip part / part of — leave them alone
        if ($newLine.Trim() -match "^part\s") {
            $newLines += $newLine
            continue
        }

        # Style. -> AppStyle.
        if ($newLine -match '\bStyle\.') {
            $newLine = [regex]::Replace($newLine, '\bStyle\.', 'AppStyle.')
        }

        # Process import lines
        if ($newLine.Trim().StartsWith("import")) {
            $newLine = Convert-DartDirective `
                -line $newLine `
                -currentFile $file.FullName `
                -currentDir $currentDir `
                -lineRef $lineRef `
                -directiveType "import"
        }

        # Process export lines
        elseif ($newLine.Trim().StartsWith("export")) {
            $newLine = Convert-DartDirective `
                -line $newLine `
                -currentFile $file.FullName `
                -currentDir $currentDir `
                -lineRef $lineRef `
                -directiveType "export"
        }

        if ($newLine -ne $line) { $modified = $true }
        $newLines += $newLine
    }

    if ($modified) {
        [System.IO.File]::WriteAllLines($file.FullName, $newLines)
        Write-Host "  Harmonized: $($file.Name)" -ForegroundColor Gray
    }
}

# ============================================================
# 8. Summary
# ============================================================
Write-Host ""
Write-Host "--- SUMMARY ---" -ForegroundColor Cyan
Write-Host "  Normalized : $normalizedCount (relative paths -> full package paths)" -ForegroundColor Gray
Write-Host "  Fixed      : $fixedCount (broken paths resolved)" -ForegroundColor Green
Write-Host "  Skipped    : $skippedCount (ambiguous - manual review needed)" -ForegroundColor Yellow
Write-Host "  Broken     : $brokenCount (no compatible match found)" -ForegroundColor Red

if ($brokenCount -eq 0 -and $skippedCount -eq 0) {
    if (Test-Path $logFile) { Remove-Item $logFile }
    Write-Host "`nHarmonization complete for '$targetPackage'. No unresolved issues." -ForegroundColor Green
}
else {
    Write-Host "`nSee $logFile for details." -ForegroundColor Yellow
}