# Extract CSS URLs (WordPress uses single quotes in link tags)
$files = Get-ChildItem "e:\antigravity\style-mantra\wp-assets\*.html"
$cssUrls = @()

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    # Match both single and double quoted href in stylesheet links
    $cssMatches = [regex]::Matches($content, "href='(https?://stylemantra\.co\.in[^']*\.css[^']*)'")
    foreach ($m in $cssMatches) { $cssUrls += $m.Groups[1].Value }
    $cssMatches2 = [regex]::Matches($content, 'href="(https?://stylemantra\.co\.in[^"]*\.css[^"]*)"')
    foreach ($m in $cssMatches2) { $cssUrls += $m.Groups[1].Value }
}

$cssUrls = $cssUrls | Sort-Object -Unique
Write-Host "Found $($cssUrls.Count) CSS files"
foreach ($url in $cssUrls) { Write-Host "  $url" }

# Download CSS files
$cssDir = "e:\antigravity\style-mantra\wp-assets\css"
foreach ($url in $cssUrls) {
    $cleanUrl = $url -replace "\?.*$", ""
    $fileName = [System.IO.Path]::GetFileName($cleanUrl)
    if (-not $fileName) { continue }
    $outPath = Join-Path $cssDir $fileName
    Write-Host "Downloading CSS: $fileName"
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  FAILED: $_"
    }
}

# Download Images (only full-size, skip thumbnails)
$imgUrls = @()
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    $imgMatches = [regex]::Matches($content, '(https?://stylemantra\.co\.in/wp-content/uploads/[^\s"''<>]+\.(jpg|jpeg|png|gif|webp|svg|ico))')
    foreach ($m in $imgMatches) { $imgUrls += $m.Groups[1].Value }
}
# Clean trailing quotes/brackets
$imgUrls = $imgUrls | ForEach-Object { $_ -replace "['\)\]]+$", "" } | Sort-Object -Unique

# Filter to only full-size images (skip WP thumbnails like -300x300, -768x768, etc.)
$fullSizeImgUrls = $imgUrls | Where-Object { $_ -notmatch '-\d+x\d+\.' }

Write-Host "`nFound $($fullSizeImgUrls.Count) full-size images (from $($imgUrls.Count) total)"

$imgDir = "e:\antigravity\style-mantra\wp-assets\images"
foreach ($url in $fullSizeImgUrls) {
    $cleanUrl = $url -replace "\?.*$", ""
    $fileName = [System.IO.Path]::GetFileName($cleanUrl)
    if (-not $fileName) { continue }
    $outPath = Join-Path $imgDir $fileName
    Write-Host "Downloading Image: $fileName"
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  FAILED: $_"
    }
}

# Download JS files
$jsUrls = @()
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    $jsMatches = [regex]::Matches($content, "src='(https?://stylemantra\.co\.in[^']*\.js[^']*)'")
    foreach ($m in $jsMatches) { $jsUrls += $m.Groups[1].Value }
    $jsMatches2 = [regex]::Matches($content, 'src="(https?://stylemantra\.co\.in[^"]*\.js[^"]*)"')
    foreach ($m in $jsMatches2) { $jsUrls += $m.Groups[1].Value }
}
$jsUrls = $jsUrls | Sort-Object -Unique
Write-Host "`nFound $($jsUrls.Count) JS files"

$jsDir = "e:\antigravity\style-mantra\wp-assets\js"
foreach ($url in $jsUrls) {
    $cleanUrl = $url -replace "\?.*$", ""
    $fileName = [System.IO.Path]::GetFileName($cleanUrl)
    if (-not $fileName) { continue }
    $outPath = Join-Path $jsDir $fileName
    Write-Host "Downloading JS: $fileName"
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  FAILED: $_"
    }
}

# Download Google Fonts CSS
$fontUrls = @()
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    $fontMatches = [regex]::Matches($content, "(https?://fonts\.googleapis\.com/[^\s'""<>]+)")
    foreach ($m in $fontMatches) { $fontUrls += $m.Groups[1].Value }
    # Also local font files from Elementor
    $localFontMatches = [regex]::Matches($content, "(https?://stylemantra\.co\.in[^\s'""<>]*fonts?[^\s'""<>]*\.(?:css|woff2?|ttf|eot|otf))")
    foreach ($m in $localFontMatches) { $fontUrls += $m.Groups[1].Value }
}
$fontUrls = $fontUrls | Sort-Object -Unique

$fontDir = "e:\antigravity\style-mantra\wp-assets\fonts"
Write-Host "`nFound $($fontUrls.Count) font files"
foreach ($url in $fontUrls) {
    $cleanUrl = $url -replace "\?.*$", ""
    $fileName = [System.IO.Path]::GetFileName($cleanUrl)
    if (-not $fileName -or $fileName.Length -lt 3) { $fileName = "font_" + [guid]::NewGuid().ToString().Substring(0,8) + ".css" }
    $outPath = Join-Path $fontDir $fileName
    Write-Host "Downloading Font: $fileName"
    try {
        Invoke-WebRequest -Uri $url -OutFile $outPath -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Host "  FAILED: $_"
    }
}

Write-Host "`n=== DOWNLOAD COMPLETE ==="
