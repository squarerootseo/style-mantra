$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = Get-Content $f.FullName -Raw

    # Fix: Add is:inline to all <script> tags that don't already have it
    # Astro processes script tags by default, but these are WP scripts that should be left as-is
    $content = $content -replace '<script([^>]*?)(?<!is:inline)>', '<script$1 is:inline>'
    
    # Remove references to wp-emoji-release.min.js which doesn't exist locally
    $content = $content -replace '<script[^>]*wp-emoji-release\.min\.js[^>]*>\s*</script>', ''
    
    # Fix broken HTML: 11/span> should be 11</span>
    $content = $content -replace '(\d+)/span>', '$1</span>'
    
    Set-Content $f.FullName -Value $content -NoNewline
    Write-Host "  Fixed script tags and HTML"
}

Write-Host "`n=== SCRIPT FIX COMPLETE ==="
