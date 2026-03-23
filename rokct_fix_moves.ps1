# rokct_fix_moves.ps1 - V4
# Handles:
# 1. Native Git Renames (R status)
# 2. Manual Moves (Same name, different folder)
# 3. Manual Renames (Different name, same folder)

$packageName = "rokctapp"
Write-Host "Scanning Git status for moves and renames..." -ForegroundColor Cyan

$statusLines = git status --porcelain
if (-not $statusLines) {
    Write-Host "Git status is clean." -ForegroundColor Green
    exit
}

$moveMappings = @{}
$deletedPaths = @()
$newPaths = @()

# 1. Extract Info
foreach ($line in $statusLines) {
    if ($line -match "^R\s+(.*) -> (.*)$") {
        # Git Native Rename
        $old = $Matches[1].Trim().Trim('"')
        $new = $Matches[2].Trim().Trim('"')
        $oldImport = "package:$packageName/$($old.Replace('\','/').Replace('lib/',''))"
        $newImport = "package:$packageName/$($new.Replace('\','/').Replace('lib/',''))"
        $moveMappings[$oldImport] = $newImport
    }
    elseif ($line -match "^[ D]D\s+(.*)$") {
        $deletedPaths += $Matches[1].Trim().Trim('"')
    }
    elseif ($line -match "^(\?\?| A|A )\s+(.*)$") {
        $path = $Matches[2].Trim().Trim('"')
        if (Test-Path $path -PathType Container) {
            $files = Get-ChildItem -Path $path -Recurse -Filter *.dart
            foreach ($f in $files) { $newPaths += $f.FullName.Replace((Get-Location).Path, "").TrimStart('\') }
        }
        else {
            if ($path.EndsWith(".dart")) { $newPaths += $path }
        }
    }
}

# 2. Match by Basename (Moves)
foreach ($d in $deletedPaths) {
    $dName = Split-Path $d -Leaf
    $match = $newPaths | Where-Object { (Split-Path $_ -Leaf) -eq $dName }
    if ($match -and $match.Count -eq 1) {
        $oldImport = "package:$packageName/$($d.Replace('\','/').Replace('lib/',''))"
        $newImport = "package:$packageName/$($match.Replace('\','/').Replace('lib/',''))"
        if (-not $moveMappings.ContainsKey($oldImport)) {
            $moveMappings[$oldImport] = $newImport
            Write-Host "Detected Move: $dName" -ForegroundColor Green
        }
    }
}

# 3. Match by Directory (Renames)
foreach ($d in $deletedPaths) {
    # Skip if already mapped
    $oldImport = "package:$packageName/$($d.Replace('\','/').Replace('lib/',''))"
    if ($moveMappings.ContainsKey($oldImport)) { continue }

    $dDir = Split-Path $d -Parent
    $localDeletes = $deletedPaths | Where-Object { (Split-Path $_ -Parent) -eq $dDir }
    $localAdditions = $newPaths | Where-Object { (Split-Path $_ -Parent) -eq $dDir }

    # If exactly 1 del and 1 add in this folder, it's a rename
    $localAdditionsArr = @($localAdditions)
    if ($localDeletes.Count -eq 1 -and $localAdditionsArr.Count -eq 1) {
        $new = $localAdditionsArr[0]
        $newImport = "package:$packageName/$($new.ToString().Replace('\','/').Replace('lib/',''))"
        $moveMappings[$oldImport] = $newImport
        Write-Host "Detected Rename: $(Split-Path $d -Leaf) -> $(Split-Path $new -Leaf)" -ForegroundColor Green
    }
}

if ($moveMappings.Count -eq 0) {
    Write-Host "No renames detected." -ForegroundColor Yellow
    exit
}

# 4. Global Update
Write-Host "Updating project imports..." -ForegroundColor Yellow
$allDartFiles = Get-ChildItem -Path "lib" -Recurse -Filter *.dart
foreach ($targetFile in $allDartFiles) {
    $content = [System.IO.File]::ReadAllText($targetFile.FullName)
    $modified = $false
    foreach ($old in $moveMappings.Keys) {
        if ($content.Contains($old)) {
            $content = $content.Replace($old, $moveMappings[$old])
            $modified = $true
        }
    }
    if ($modified) {
        [System.IO.File]::WriteAllText($targetFile.FullName, $content)
        Write-Host "  Fixed: $($targetFile.FullName)" -ForegroundColor Gray
    }
}
Write-Host "Finished!" -ForegroundColor Green
