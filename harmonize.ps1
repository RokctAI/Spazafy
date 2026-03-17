param (
    [Parameter(Mandatory=$false)] [string]$PackageName = ""
)

# 1. Detect target package name (Priority: Parameter > Pubspec > Default)
$targetPackage = $PackageName
if (-not $targetPackage) {
    if (Test-Path "pubspec.yaml") {
        $pubContent = Get-Content "pubspec.yaml" -Raw
        if ($pubContent -match "name:\s*([a-zA-Z0-9_]+)") {
            $targetPackage = $Matches[1]
        }
    }
}
if (-not $targetPackage) { $targetPackage = "rokctapp" }

$libPath = (Resolve-Path "lib").Path
$logFile = (Join-Path (Get-Location) "broken_imports.log")
$brokenCount = 0
"--- HARMONIZER REPORT (Created: $(Get-Date)) ---`n" | Out-File -FilePath $logFile -Encoding utf8

Write-Host "Harmonizing imports for project: $targetPackage" -ForegroundColor Cyan

Get-ChildItem -Path "lib" -Recurse -Filter *.dart | ForEach-Object { 
    $file = $_
    $content = [System.IO.File]::ReadAllLines($file.FullName)
    $modified = $false
    $newLines = @()
    $currentDir = Split-Path $file.FullName -Parent

    for ($i = 0; $i -lt $content.Count; $i++) {
        $line = $content[$i]
        $newLine = $line
        
        # Skip commented out lines
        if ($newLine.Trim().StartsWith("//")) {
            $newLines += $newLine
            continue
        }

        # 1. Standalone Style. -> AppStyle. replacement
        if ($newLine -match '\bStyle\.') {
            $newLine = [regex]::Replace($newLine, '\bStyle\.', 'AppStyle.')
        }

        # 2. Handle Imports
        if ($newLine.Trim().StartsWith("import")) {
            if ($newLine -match "import\s+['""](.*\.dart)['""]") {
                $rawPath = $Matches[1]
                $targetAbsPath = $null
                $isPackageImport = $false

                if ($rawPath.StartsWith("package:$targetPackage/")) {
                    $isPackageImport = $true
                    $innerPath = $rawPath.Replace("package:$targetPackage/", "").Replace('/', [System.IO.Path]::DirectorySeparatorChar)
                    $targetAbsPath = Join-Path $libPath $innerPath
                } elseif ($rawPath.Contains("../")) {
                    try {
                        $targetAbsPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($currentDir, $rawPath))
                    } catch { }
                }

                if ($targetAbsPath) {
                    if (Test-Path $targetAbsPath) {
                        # If it's a relative path that exists, convert to package import
                        if (-not $isPackageImport -and $targetAbsPath.ToLower().StartsWith($libPath.ToLower())) {
                            $relativeToLib = $targetAbsPath.Substring($libPath.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar).Replace('\', '/')
                            $newLine = "import 'package:$targetPackage/$relativeToLib';"
                        }
                    } else {
                        $brokenCount++
                        $logEntry = "[$($file.FullName):$($i+1)] Missing: $rawPath"
                        $logEntry | Add-Content -Path $logFile
                        Write-Host "  [BROKEN] $logEntry" -ForegroundColor Red
                    }
                }
            }
        }

        if ($newLine -ne $line) { $modified = $true }
        $newLines += $newLine
    }

    if ($modified) {
        [System.IO.File]::WriteAllLines($file.FullName, $newLines)
        Write-Host "  Harmonized: $($file.Name)" -ForegroundColor Gray
    }
}

if ($brokenCount -eq 0) {
    if (Test-Path $logFile) { Remove-Item $logFile }
    Write-Host "`n✨ Harmonization complete for $($targetPackage). No broken paths." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Harmonization complete for $($targetPackage), but found $brokenCount broken paths. See $logFile" -ForegroundColor Yellow
}
