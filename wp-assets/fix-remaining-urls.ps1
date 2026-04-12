$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = Get-Content $f.FullName -Raw

    # Fix escaped URLs in JSON (e.g. https:\/\/stylemantra.co.in\/home\/ -> \/)
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/home\\/', '\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/about\\/', '\\/about'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/our-course\\/', '\\/our-course'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/contact\\/', '\\/contact'
    
    # Fix remaining escaped URLs to stylemantra.co.in (wp-admin, wp-content etc in JSON)
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-admin\\/admin-ajax\.php', ''
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/plugins\\/elementor-pro\\/assets\\/', '\\/js\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/plugins\\/elementor\\/assets\\/', '\\/js\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/[^"]*', ''
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in\\/', '\\/'
    $content = $content -replace 'https?:\\/\\/stylemantra\.co\.in', ''

    # Fix any remaining non-escaped URLs (except email addresses)
    # Don't touch "info@stylemantra.co.in" - those are valid email refs
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-admin/[^"''<>\s]*', ''
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s]*', ''
    $content = $content -replace 'https?://stylemantra\.co\.in/?(?=["\s<''])', '/'

    Set-Content $f.FullName -Value $content -NoNewline
    
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in')).Count
    $emailOnly = ([regex]::Matches($content, 'info@stylemantra\.co\.in')).Count
    Write-Host "  Remaining: $remaining total ($emailOnly are email addresses)"
}

Write-Host "`n=== CLEANUP COMPLETE ==="
