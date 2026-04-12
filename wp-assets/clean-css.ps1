$files = Get-ChildItem "e:\antigravity\style-mantra\public\css\*.css"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace image URLs inside CSS
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/\d{4}/\d{2}/([^"''<>\s\)]+?)(-\d+x\d+)?(\.(jpg|jpeg|png|gif|webp|svg|ico))', '/images/$1$3')
    
    # Replace font URLs inside CSS (map them to /fonts/)
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/.+?/([^"''<>\s\)]+?)\.(woff2|woff|ttf|eot|svg)', '/fonts/$1.$2')
    
    # Rewrite original wp-content fallback just in case
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s\)]*', '')
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}
Write-Host "CSS URL replacements complete."
