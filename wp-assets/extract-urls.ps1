$files = Get-ChildItem "e:\antigravity\style-mantra\wp-assets\*.html"
$cssUrls = @()
$jsUrls = @()
$imgUrls = @()

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    
    # CSS files
    $cssMatches = [regex]::Matches($content, 'href="(https?://stylemantra\.co\.in[^"]*\.css[^"]*)"')
    foreach ($m in $cssMatches) { $cssUrls += $m.Groups[1].Value }
    
    # JS files
    $jsMatches = [regex]::Matches($content, 'src="(https?://stylemantra\.co\.in[^"]*\.js[^"]*)"')
    foreach ($m in $jsMatches) { $jsUrls += $m.Groups[1].Value }
    
    # Images from src attributes
    $imgMatches = [regex]::Matches($content, 'src="(https?://stylemantra\.co\.in/wp-content/uploads/[^"]+)"')
    foreach ($m in $imgMatches) { $imgUrls += $m.Groups[1].Value }
    
    # Images from data-src attributes (lazy loading)
    $dataSrcMatches = [regex]::Matches($content, 'data-src="(https?://stylemantra\.co\.in/wp-content/uploads/[^"]+)"')
    foreach ($m in $dataSrcMatches) { $imgUrls += $m.Groups[1].Value }
    
    # Background images in inline styles
    $bgMatches = [regex]::Matches($content, 'url\("?(https?://stylemantra\.co\.in/wp-content/uploads/[^")\s]+)"?\)')
    foreach ($m in $bgMatches) { $imgUrls += $m.Groups[1].Value }
    
    # srcset images
    $srcsetMatches = [regex]::Matches($content, '(https?://stylemantra\.co\.in/wp-content/uploads/[^\s"]+)')
    foreach ($m in $srcsetMatches) { $imgUrls += $m.Groups[1].Value }
}

Write-Host "=== CSS FILES ==="
$cssUrls | Sort-Object -Unique | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "=== JS FILES ==="
$jsUrls | Sort-Object -Unique | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "=== IMAGE FILES ==="
$imgUrls | Sort-Object -Unique | ForEach-Object { Write-Host $_ }
