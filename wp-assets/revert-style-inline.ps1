# Remove is:inline from <style> tags - it was incorrectly added
# Astro handles CSS :is() fine without is:inline. Adding is:inline 
# causes esbuild to try to parse it, which fails on :is()
$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Remove is:inline from style tags (keep it on script tags)
    $content = [regex]::Replace($content, '(<style\b[^>]*?)\s+is:inline', '$1')
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    Write-Host "  Removed is:inline from style tags"
}

Write-Host "`nDone"
