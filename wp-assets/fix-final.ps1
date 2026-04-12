# Clean up remaining stylemantra.co.in refs in inline JS configs
$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Fix jkit_ajax_url
    $content = $content -replace 'https://stylemantra\.co\.in/\?jkit-ajax-request=jkit_elements', '/?jkit-ajax-request=jkit_elements'
    
    # Fix wp-json API URLs
    $content = $content -replace 'https://stylemantra\.co\.in/wp-json/', '/wp-json/'
    
    # Fix elementskit resturl
    $content = $content -replace "https://stylemantra\.co\.in/wp-json/", '/wp-json/'
    
    # Fix emoji source concatemoji URL  
    $content = $content -replace '"concatemoji":"https://stylemantra\.co\.in/wp-includes/js/wp-emoji-release\.min\.js\?ver=[^"]*"', '"concatemoji":"/js/wp-emoji-release.min.js"'
    
    # Fix sourceURL comment
    $content = $content -replace '//# sourceURL=https://stylemantra\.co\.in/wp-includes/js/wp-emoji-loader\.min\.js', '//# sourceURL=/js/wp-emoji-loader.min.js'
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in')).Count
    $emailOnly = ([regex]::Matches($content, 'info@stylemantra\.co\.in')).Count
    Write-Host "  Done! Remaining: $remaining ($emailOnly email)"
}

Write-Host "`n=== CLEANUP COMPLETE ==="
