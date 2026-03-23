$files = Get-ChildItem -Path lib -Filter *.dart -Recurse
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $changed = $false
    
    $replacements = @{
        "presentation/theme/customer/theme.dart"         = "presentation/theme/theme.dart"
        "presentation/theme/customer/app_style.dart"     = "presentation/theme/theme.dart"
        "presentation/theme/customer/app_assets.dart"    = "presentation/theme/app_assets.dart"
        "presentation/theme/manager/app_assets.dart"     = "presentation/theme/app_assets.dart"
        "presentation/theme/driver/app_assets.dart"      = "presentation/theme/app_assets.dart"
        "presentation/theme/manager/app_widget.dart"     = "presentation/theme/theme.dart"
        "presentation/theme/driver/app_widget.dart"      = "presentation/theme/theme.dart"
        "presentation/theme/manager/phoenix_widget.dart" = "presentation/theme/theme.dart"
        "presentation/components/customer/"              = "presentation/components/"
        # Relative versions
        "theme/customer/theme.dart"                      = "theme/theme.dart"
        "theme/customer/app_style.dart"                  = "theme/theme.dart"
        "theme/customer/app_assets.dart"                 = "theme/app_assets.dart"
        "theme/manager/app_assets.dart"                  = "theme/app_assets.dart"
        "theme/driver/app_assets.dart"                   = "theme/app_assets.dart"
        "theme/manager/app_widget.dart"                  = "theme/theme.dart"
        "theme/driver/app_widget.dart"                   = "theme/theme.dart"
        "theme/manager/phoenix_widget.dart"              = "theme/theme.dart"
        "components/customer/"                           = "components/"
    }

    foreach ($old in $replacements.Keys) {
        if ($content.Contains($old)) {
            $content = $content.Replace($old, $replacements[$old])
            $changed = $true
        }
    }

    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated $($file.FullName)"
    }
}
