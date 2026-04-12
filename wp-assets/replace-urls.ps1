$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = Get-Content $f.FullName -Raw
    $original = $content

    # 1. Replace image URLs (wp-content/uploads) with local /images/ paths
    # Handle all size variants - map thumbnails to full-size local files
    # Pattern: https://stylemantra.co.in/wp-content/uploads/YYYY/MM/filename-WIDTHxHEIGHT.ext -> /images/filename.ext
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/\d{4}/\d{2}/([^"''<>\s\)]+?)(-\d+x\d+)?(\.(jpg|jpeg|png|gif|webp|svg|ico))', '/images/$1$3')

    # 2. Replace Elementor CSS URLs with inline (we downloaded them)
    # These will be embedded inline later, for now point to local
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')

    # 3. Replace Elementor Google Fonts CSS
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/google-fonts/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')

    # 4. Replace animate.css from ac_assets
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/uploads/ac_assets/uc_classic_carousel/animate\.css', '/css/animate.css'

    # 5. Replace Elementor plugin CSS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')

    # 6. Replace Elementor plugin JS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')

    # 7. Replace wp-includes JS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/js/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')

    # 8. Replace wp-includes CSS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')

    # 9. Replace internal page links (e.g. /home/ -> /, /about/ -> /about, etc.)
    $content = $content -replace 'https?://stylemantra\.co\.in/home/?', '/'
    $content = $content -replace 'https?://stylemantra\.co\.in/about/?', '/about'
    $content = $content -replace 'https?://stylemantra\.co\.in/our-course/?', '/our-course'
    $content = $content -replace 'https?://stylemantra\.co\.in/contact/?', '/contact'
    $content = $content -replace 'https?://stylemantra\.co\.in/?', '/'

    # 10. Clean up any &quot; artifacts after URLs
    $content = $content -replace '&quot;', '"'

    # Count changes
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in')).Count
    
    if ($content -ne $original) {
        Set-Content $f.FullName -Value $content -NoNewline
        Write-Host "  Updated! Remaining external refs: $remaining"
    } else {
        Write-Host "  No changes needed. Remaining external refs: $remaining"
    }
}

# Copy CSS files to public/css
Write-Host "`nCopying CSS files to public/css..."
New-Item -ItemType Directory -Path "e:\antigravity\style-mantra\public\css" -Force | Out-Null
Copy-Item "e:\antigravity\style-mantra\wp-assets\css\*" "e:\antigravity\style-mantra\public\css\" -Force

# Copy JS files to public/js
Write-Host "Copying JS files to public/js..."
New-Item -ItemType Directory -Path "e:\antigravity\style-mantra\public\js" -Force | Out-Null
Copy-Item "e:\antigravity\style-mantra\wp-assets\js\*" "e:\antigravity\style-mantra\public\js\" -Force

Write-Host "`n=== URL REPLACEMENT COMPLETE ==="
