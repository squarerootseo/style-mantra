# Complete URL replacement + Astro compatibility fix
# Run this ONCE on the clean git checkout

$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # ===== STEP 1: Replace image URLs =====
    # Full-size and thumbnail variants -> /images/filename.ext
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/\d{4}/\d{2}/([^"''<>\s\)]+?)(-\d+x\d+)?(\.(jpg|jpeg|png|gif|webp|svg|ico))', '/images/$1$3')
    
    # ===== STEP 2: Replace CSS URLs =====
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/elementor/google-fonts/css/([^"''<>\s]+?)(\?[^"''<>\s]*)?', '/css/$1')
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/uploads/ac_assets/uc_classic_carousel/animate\.css', '/css/animate.css'
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')
    
    # ===== STEP 3: Replace JS URLs =====
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/plugins/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/js/[^"''<>\s]*?/([^/"''<>\s]+\.js)(\?[^"''<>\s]*)?', '/js/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-includes/[^"''<>\s]*?/([^/"''<>\s]+\.css)(\?[^"''<>\s]*)?', '/css/$1')
    
    # ===== STEP 4: Replace page links =====
    $content = $content -replace 'https?://stylemantra\.co\.in/home/?', '/'
    $content = $content -replace 'https?://stylemantra\.co\.in/about/?', '/about'
    $content = $content -replace 'https?://stylemantra\.co\.in/our-course/?', '/our-course'
    $content = $content -replace 'https?://stylemantra\.co\.in/contact/?', '/contact'
    $content = $content -replace 'https?://stylemantra\.co\.in/?(?=["''<\s])', '/'
    
    # ===== STEP 5: Fix escaped URLs in JSON =====
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
    
    # Clean up remaining
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-admin/[^"''<>\s]*', ''
    $content = $content -replace 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s]*', ''
    
    # Clean &quot; artifacts
    $content = $content -replace '&quot;', '"'
    
    # ===== STEP 6: Add is:inline to ALL <script> tags =====
    # Astro processes script tags by default; WP scripts need is:inline
    $content = [regex]::Replace($content, '<script\b(?![^>]*is:inline)([^>]*)>', '<script$1 is:inline>')
    
    # ===== STEP 7: Add is:inline to ALL <style> tags that have id or type =====
    # These are WP-generated styles that esbuild can't parse (e.g. CSS :is() function)
    $content = [regex]::Replace($content, '<style\b(?![^>]*is:inline)([^>]*)>', '<style$1 is:inline>')
    
    # ===== STEP 8: Remove wp-emoji-release script reference =====
    $content = [regex]::Replace($content, '<script[^>]*wp-emoji-release\.min\.js[^>]*>\s*</script>', '')
    
    # ===== STEP 9: Fix broken HTML =====
    # 11/span> -> 11</span>
    $content = [regex]::Replace($content, '(\d+)/span>', '$1</span>')
    
    # Save with UTF-8 encoding (no BOM)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    
    $remaining = ([regex]::Matches($content, 'stylemantra\.co\.in')).Count
    $emailOnly = ([regex]::Matches($content, 'info@stylemantra\.co\.in')).Count
    Write-Host "  Done! Remaining refs: $remaining ($emailOnly email)"
}

Write-Host "`n=== ALL FIXES APPLIED ==="
