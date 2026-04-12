$url = "https://lime-nightingale-910035.hostingersite.com/home/"
$imgDir = "e:\antigravity\style-mantra\public\images"
$cssDir = "e:\antigravity\style-mantra\public\css"

Write-Host "Fetching HTML from $url"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
$html = $response.Content

# Find all image/SVG URLs in HTML
$pattern = 'https?://[^"''\s]+\.(?:jpg|jpeg|png|webp|svg|gif)'
$matches = [regex]::Matches($html, $pattern, "IgnoreCase")

$missing = @()

foreach ($m in $matches) {
    if ($m.Value -match "lime-nightingale-910035\.hostingersite\.com") {
        $filename = Split-Path $m.Value -Leaf
        # Remove any ?ver= query param from filename if present
        $filename = $filename -replace '\?.*$', ''
        
        $localPath = Join-Path $imgDir $filename
        if (-not (Test-Path $localPath)) {
            $missing += [PSCustomObject]@{
                Url = $m.Value
                Filename = $filename
            }
        }
    }
}

$missing = $missing | Select-Object -Unique -Property Url, Filename

if ($missing.Count -eq 0) {
    Write-Host "No missing images found in HTML!"
} else {
    Write-Host "Found $($missing.Count) missing images in HTML:"
    foreach ($item in $missing) {
        Write-Host "Downloading: $($item.Filename) from $($item.Url)"
        $dest = Join-Path $imgDir $item.Filename
        try {
            Invoke-WebRequest -Uri $item.Url -OutFile $dest -UseBasicParsing
            Write-Host "  -> Success"
        } catch {
            Write-Host "  -> Failed: $_"
        }
    }
}

# Now let's fetch all Elementor CSS files linked on the page and search them too!
Write-Host "Searching CSS files for background images..."
$cssPattern = 'href="([^"]+post-\d+\.css\?[^"]*)"'
$cssMatches = [regex]::Matches($html, $cssPattern)

foreach ($cMatch in $cssMatches) {
    $cssUrl = $cMatch.Groups[1].Value
    # decode HTML entities if necessary
    $cssUrl = $cssUrl -replace '&#038;', '&'
    if (-not ($cssUrl -match '^http')) {
        Write-Host "Incomplete URL, skipping: $cssUrl"
        continue
    }
    
    Write-Host "Fetching CSS: $cssUrl"
    try {
        $cssCode = (Invoke-WebRequest -Uri $cssUrl -UseBasicParsing).Content
        $bgPattern = '(?:https?://)?lime-nightingale-910035\.hostingersite\.com[^"''\s\)]+\.(?:jpg|jpeg|png|webp|svg|gif)'
        $bgMatches = [regex]::Matches($cssCode, $bgPattern, "IgnoreCase")
        
        $missingBgs = @()
        foreach ($bgM in $bgMatches) {
            $bgUrl = $bgM.Value
            if (-not ($bgUrl -match '^http')) {
                $bgUrl = "https://" + $bgUrl
            }
            $filename = Split-Path $bgUrl -Leaf
            $filename = $filename -replace '\?.*$', ''
            
            $localPath = Join-Path $imgDir $filename
            if (-not (Test-Path $localPath)) {
                $missingBgs += [PSCustomObject]@{
                    Url = $bgUrl
                    Filename = $filename
                }
            }
        }
        
        $missingBgs = $missingBgs | Select-Object -Unique -Property Url, Filename
        if ($missingBgs.Count -gt 0) {
            Write-Host "Found $($missingBgs.Count) missing background images in CSS."
            foreach ($item in $missingBgs) {
                Write-Host "Downloading: $($item.Filename) from $($item.Url)"
                $dest = Join-Path $imgDir $item.Filename
                try {
                    Invoke-WebRequest -Uri $item.Url -OutFile $dest -UseBasicParsing
                    Write-Host "  -> Success"
                } catch {
                    Write-Host "  -> Failed: $_"
                }
            }
        }
    } catch {
        Write-Host "Failed to fetch CSS: $_"
    }
}
Write-Host "Image synchronization complete for Home page."
