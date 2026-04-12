$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Strip ?ver=... and &ver=... from CSS and JS files
    $content = [regex]::Replace($content, '\?ver=[^"''\s>]*', '')
    $content = [regex]::Replace($content, '&#038;ver=[^"''\s>]*', '')
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}
Write-Host "Done stripping version query strings."
