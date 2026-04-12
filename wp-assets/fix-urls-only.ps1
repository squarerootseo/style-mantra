# URL-only replacement - NO is:inline, NO script/style modifications
# The original repo already had is:inline on script tags and proper style handling
$files = @(
    "e:\antigravity\style-mantra\src\pages\index.astro",
    "e:\antigravity\style-mantra\src\pages\our-course.astro"
)

foreach ($filePath in $files) {
    $f = Get-Item $filePath
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
    
    # Replace page links
    $content = $content -replace 'https?://stylemantra\.co\.in/home/?', '/'
    $content = $content -replace 'https?://stylemantra\.co\.in/about/?', '/about'
    $content = $content -replace 'https?://stylemantra\.co\.in/our-course/?', '/our-course'
    $content = $content -replace 'https?://stylemantra\.co\.in/contact/?', '/contact'
    $content = $content -replace 'https?://stylemantra\.co\.in/?(?=["''<\s])', '/'
    
    # Fix escaped URLs in JSON
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
    
    # Clean remaining WP URLs (not email)
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-admin/[^"''<>\s]*', ''
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s]*', ''
    
    # Fix inline JS configs
    $content = $content -replace 'https://stylemantra\.co\.in/\?jkit-ajax-request=jkit_elements', '/?jkit-ajax-request=jkit_elements'
    $content = $content -replace 'https://stylemantra\.co\.in/wp-json/', '/wp-json/'
    $content = $content -replace '"concatemoji":"https://stylemantra\.co\.in/wp-includes/js/wp-emoji-release\.min\.js\?ver=[^"]*"', '"concatemoji":"/js/wp-emoji-release.min.js"'
    $content = $content -replace '//# sourceURL=https://stylemantra\.co\.in/wp-includes/js/wp-emoji-loader\.min\.js', '//# sourceURL=/js/wp-emoji-loader.min.js'
    
    # Clean &quot; artifacts
    $content = $content -replace '&quot;', '"'
    
    # Fix broken HTML: 11/span> -> 11</span>
    $content = [regex]::Replace($content, '(\d+)/span>', '$1</span>')
    
    # Save preserving original encoding (UTF-8 without BOM)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in')).Count
    $emailOnly = ([regex]::Matches($content, 'info@stylemantra\.co\.in')).Count
    Write-Host "  Done! Remaining: $remaining ($emailOnly email)"
}

Write-Host "`n=== URL REPLACEMENT COMPLETE ==="
