# Download ALL missing font files from Hostinger to local /public/fonts/
# This is the PERMANENT fix - no more broken CDN links

$baseUrl = "https://lime-nightingale-910035.hostingersite.com"
$fontsDir = "e:\antigravity\style-mantra\public\fonts"
$cssDir = "e:\antigravity\style-mantra\public\css"

if (-not (Test-Path $fontsDir)) { New-Item -ItemType Directory -Path $fontsDir | Out-Null }

Write-Host "=== Step 1: Fetch CSS files and extract all font-face src URLs ==="

$cssFiles = Get-ChildItem "$cssDir\*.css"
$fontUrls = @{}

foreach ($cssFile in $cssFiles) {
    $content = [System.IO.File]::ReadAllText($cssFile.FullName, [System.Text.Encoding]::UTF8)
    # Find all url() references in @font-face blocks that point to wp-content or /fonts/
    $matches = [regex]::Matches($content, "url\(['""]?(https?://[^'"")\s]+\.(?:woff2?|ttf|eot|otf))['""]?\)", "IgnoreCase")
    foreach ($m in $matches) {
        $u = $m.Groups[1].Value -replace '\?.*$', ''
        $fname = Split-Path $u -Leaf
        if (-not $fontUrls.ContainsKey($fname)) {
            $fontUrls[$fname] = $u
        }
    }
    # Also find relative /fonts/ references 
    $matches2 = [regex]::Matches($content, "url\(['""]?(/(?:fonts|css)/[^'"")\s]+\.(?:woff2?|ttf|eot|otf))['""]?\)", "IgnoreCase")
    foreach ($m in $matches2) {
        $path = $m.Groups[1].Value -replace '\?.*$', ''
        $fname = Split-Path $path -Leaf
        # Try to find from Hostinger
        $tryUrl = "$baseUrl$path"
        if (-not $fontUrls.ContainsKey($fname)) {
            $fontUrls[$fname] = $tryUrl
        }
    }
}

Write-Host "Found $($fontUrls.Count) unique font files referenced in CSS."
foreach ($kv in $fontUrls.GetEnumerator()) {
    Write-Host "  - $($kv.Key) from $($kv.Value)"
}

Write-Host ""
Write-Host "=== Step 2: Download each font file ==="

foreach ($kv in $fontUrls.GetEnumerator()) {
    $dest = Join-Path $fontsDir $kv.Key
    if (Test-Path $dest) {
        Write-Host "  SKIP (exists): $($kv.Key)"
        continue
    }
    Write-Host "  Downloading: $($kv.Key)"
    try {
        Invoke-WebRequest -Uri $kv.Value -OutFile $dest -UseBasicParsing -ErrorAction Stop
        $size = (Get-Item $dest).Length
        Write-Host "    -> SUCCESS ($size bytes)"
    } catch {
        Write-Host "    -> FAILED from original URL, trying Hostinger fallback..."
        $hostUrl = "$baseUrl/wp-content/uploads/fonts/$($kv.Key)"
        try {
            Invoke-WebRequest -Uri $hostUrl -OutFile $dest -UseBasicParsing -ErrorAction Stop
            $size = (Get-Item $dest).Length
            Write-Host "    -> SUCCESS from Hostinger ($size bytes)"
        } catch {
            Write-Host "    -> BOTH FAILED: $_"
        }
    }
}

Write-Host ""
Write-Host "=== Step 3: Update CSS files to point to /fonts/ ==="

foreach ($cssFile in $cssFiles) {
    $content = [System.IO.File]::ReadAllText($cssFile.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace all external font URLs to local /fonts/
    $newContent = [regex]::Replace($content, "url\(['""]?https?://[^'"")\s]+/([^/'"")\s]+\.(?:woff2?|ttf|eot|otf))(\?[^'"")\s]*)?\s*['""]?\)", {
        param($m)
        $fname = $m.Groups[1].Value
        "url('/fonts/$fname')"
    })
    
    # Also fix relative /css/ font references to /fonts/
    $newContent = [regex]::Replace($newContent, "url\(['""]?/css/([^'"")\s]+\.(?:woff2?|ttf|eot|otf))(\?[^'"")\s]*)?\s*['""]?\)", {
        param($m)
        $fname = $m.Groups[1].Value
        "url('/fonts/$fname')"
    })
    
    if ($newContent -ne $content) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($cssFile.FullName, $newContent, $utf8NoBom)
        Write-Host "  Updated: $($cssFile.Name)"
    }
}

Write-Host ""
Write-Host "=== DONE: Permanent font fix complete! ==="
Write-Host "Fonts downloaded to: $fontsDir"
Get-ChildItem $fontsDir | Select-Object Name, @{N='Size';E={"{0:N0} bytes" -f $_.Length}}
