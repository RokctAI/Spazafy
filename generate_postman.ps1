param(
    [string]$LibDir = "C:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib",
    [string]$OutFile = "Spazafy_Auto_Postman.json"
)


Write-Host "Scanning directory: $LibDir" -ForegroundColor Cyan

if (-Not (Test-Path $LibDir)) {
    Write-Host "Error: Directory '$LibDir' not found." -ForegroundColor Red
    # using return instead of exit to not break the powershell session if sourced
    return
}

$endpoints = @()

$files = Get-ChildItem -Path $LibDir -Recurse -Filter *.dart

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # Look for literal endpoints matching '/api/v1/method/paas.api.<module>.<action>'
    $urlPattern = "['""](/api/v1/method/paas\.api\.([^'""]+))['""]"
    $matches = [regex]::Matches($content, $urlPattern)

    foreach ($match in $matches) {
        $url = $match.Groups[1].Value
        $apiPath = $match.Groups[2].Value

        # Try to find the method by looking at the text before the URL
        $index = $match.Index
        $startSearch = [Math]::Max(0, $index - 200)
        $precedingText = $content.Substring($startSearch, $index - $startSearch)

        $method = "GET" # default
        if ($precedingText -match "client\.post") { $method = "POST" }
        elseif ($precedingText -match "client\.put") { $method = "PUT" }
        elseif ($precedingText -match "client\.delete") { $method = "DELETE" }
        elseif ($precedingText -match "client\.get") { $method = "GET" }

        # Try to find parameters (queryParameters or data) after the URL
        $postIndex = $index + $match.Length
        $endSearch = [Math]::Min($content.Length - $postIndex, 500)
        $followingText = $content.Substring($postIndex, $endSearch)

        # Extract everything up to the next semicolon or end of substring
        $callEndMatch = [regex]::Match($followingText, "(?s).*?;")
        if ($callEndMatch.Success) {
            $callText = $callEndMatch.Value
        } else {
            $callText = $followingText
        }

        $params = "{}"
        $paramMatch = [regex]::Match($callText, "(?s)(queryParameters|data)\s*:\s*(\{[^}]*\})")
        if ($paramMatch.Success) {
            $params = $paramMatch.Groups[2].Value
            $params = $params -replace "\s+", " "
        }

        # Determine module name (e.g., paas.api.user.user.login -> user)
        # The apiPath looks like 'user.user.login'
        $parts = $apiPath.Split('.')
        $module = "Uncategorized"
        $name = $apiPath
        if ($parts.Length -ge 1) {
            $module = $parts[0]
            # Make module name title case (e.g., driver_order -> Driver Order)
            $module = (Get-Culture).TextInfo.ToTitleCase($module.Replace("_", " "))
        }
        if ($parts.Length -ge 2) {
            $name = $parts[$parts.Length - 1]
            $name = (Get-Culture).TextInfo.ToTitleCase($name.Replace("_", " "))
        }

        $endpointObj = [PSCustomObject]@{
            Method = $method
            Url = $url
            Module = $module
            Name = $name
            Params = $params
            File = $file.Name
        }

        $endpoints += $endpointObj
    }
}

Write-Host "Found $($endpoints.Count) endpoints." -ForegroundColor Green


# Group endpoints by module
$groupedEndpoints = $endpoints | Group-Object -Property Module

$folders = @()

foreach ($group in $groupedEndpoints) {
    $folderItems = @()
    foreach ($ep in $group.Group) {

        # Prepare the request object for Postman
        $requestObj = @{
            method = $ep.Method
            header = @()
            url = @{
                raw = "{{baseUrl}}$($ep.Url)"
                host = @("{{baseUrl}}")
                path = $ep.Url.TrimStart("/").Split("/")
            }
        }

        # Add query parameters if it's a GET request and we extracted a map-like string
        # Very simple conversion: just put the literal string as a note or try to parse
        if ($ep.Method -eq "GET" -and $ep.Params -ne "{}") {
            $requestObj.description = "Extracted query parameters: $($ep.Params)"
        }

        # Add body if it's POST/PUT
        if (($ep.Method -eq "POST" -or $ep.Method -eq "PUT") -and $ep.Params -ne "{}") {
            $requestObj.body = @{
                mode = "raw"
                raw = $ep.Params
                options = @{
                    raw = @{
                        language = "json"
                    }
                }
            }
        }

        $itemObj = @{
            name = $ep.Name
            request = $requestObj
            response = @()
        }

        $folderItems += $itemObj
    }

    $folderObj = @{
        name = $group.Name
        item = $folderItems
    }

    $folders += $folderObj
}

# Construct the full Postman collection
$collection = @{
    info = @{
        name = "Spazafy Auto-Generated API Collection"
        description = "Automatically extracted API endpoints from Flutter source code."
        schema = "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    }
    item = $folders
    variable = @(
        @{
            key = "baseUrl"
            value = "https://your-frappe-backend.com"
            type = "string"
        }
    )
}

# Convert to JSON and save
$collection | ConvertTo-Json -Depth 10 | Out-File -FilePath $OutFile -Encoding UTF8

Write-Host "Successfully generated Postman collection at: $OutFile" -ForegroundColor Green
