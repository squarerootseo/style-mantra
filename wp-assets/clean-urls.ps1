$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace image URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/\d{4}/\d{2}/([^"''<>\s\)]+?)(-\d+x\d+)?(\.(jpg|jpeg|png|gif|webp|svg|ico))', '/images/$1$3')
    
    # Replace CSS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/google-fonts/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/uploads/ac_assets/uc_classic_carousel/animate\.css', '/css/animate.css'
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')
    
    # Replace JS URLs
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/js/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')
    
    # Replace page links (navigation)
    $content = $content -replace 'https?://stylemantra\.co\.in/home/?', '/'
    $content = $content -replace 'https?://stylemantra\.co\.in/about/?', '/about'
    $content = $content -replace 'https?://stylemantra\.co\.in/our-course/?', '/our-course'
    $content = $content -replace 'https?://stylemantra\.co\.in/contact/?', '/contact'
    # Fallback to root if any generic domain links exist
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/?(?=["''<\s])', '/')
    
    # Fix escaped URLs in JSON payloads safely without breaking &quot;
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/home\\/', '\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/about\\/', '\\/about'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/our-course\\/', '\\/our-course'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/contact\\/', '\\/contact'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-admin\\/admin-ajax\.php', ''
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/plugins\\/elementor-pro\\/assets\\/', '\\/js\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/plugins\\/elementor\\/assets\\/', '\\/js\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/[^"\\]*', ''
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/', '\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in', ''
    
    # Clean remaining direct WP URLs (not emails, not escaped)
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-admin/[^"''<>\s]*', '')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s]*', '')
    
    # Fix inline JS configs safely
    $content = $content -replace 'https://stylemantra\.co\.in/\?jkit-ajax-request=jkit_elements', '/?jkit-ajax-request=jkit_elements'
    $content = $content -replace 'https://stylemantra\.co\.in/wp-json/', '/wp-json/'
    $content = $content -replace '"concatemoji":"https://stylemantra\.co\.in/wp-includes/js/wp-emoji-release\.min\.js\?ver=[^"]*"', '"concatemoji":"/js/wp-emoji-release.min.js"'
    $content = $content -replace '//# sourceURL=https://stylemantra\.co\.in/wp-includes/js/wp-emoji-loader\.min\.js', '//# sourceURL=/js/wp-emoji-loader.min.js'
    
    # Remove the elementor broken HTML `11/span>` artifact carefully
    $content = [regex]::Replace($content, '(\d+)/span>', '$1</span>')
    
    # Write back without BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in(?!/wp-includes/js)[^''"<>]*')).Count
    $emailOnly = ([regex]::Matches($content, 'info@stylemantra\.co\.in')).Count
    Write-Host "  Done! Remaining: $remaining ($emailOnly email)"
}

Write-Host "`n=== CLEAN URL REPLACEMENT COMPLETE ==="
