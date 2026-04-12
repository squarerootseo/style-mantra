$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Clean up the escaped JSON paths!
    $content = [regex]::Replace($content, 'https?:\\/\\/stylemantra\.co\.in\\/wp-content\\/uploads\\/(?:\d{4}\\/\d{2}\\/)?([^"''\\]+\.(?:jpg|jpeg|png|webp|svg|gif|ico))', '\/images\/$1')
    
    # Also handle the unescaped ones that my previous script mucked up by dropping the dimension string
    # Actually wait! The previous script ALREADY mapped unescaped URLs to /images/, stripping the crop.
    
    # Look for any remaining untouched wp-content
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/uploads/(?:\d{4}/\d{2}/)?([^"''<>\s\)]+?\.(?:jpg|jpeg|png|webp|svg|gif|ico))', '/images/$1')
    $content = [regex]::Replace($content, 'https?://stylemantra\.co\.in/wp-content/[^"''<>\s]*', '')

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}
Write-Host "Fixed escaped JSON URLs in all pages!"
