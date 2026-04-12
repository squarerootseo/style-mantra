# Replace the problematic inline <style> with :is() with an external link
$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace the inline style block with the :is() CSS with a link to external file
    $pattern = '<style id="wp-img-auto-sizes-contain-inline-css" type="text/css">\r?\nimg:is\([^<]+\)\{contain-intrinsic-size:3000px 1500px\}\r?\n/\*# sourceURL=wp-img-auto-sizes-contain-inline-css \*/\r?\n</style>'
    $replacement = '<link rel="stylesheet" href="/css/wp-img-auto-sizes.css" type="text/css">'
    
    $newContent = [regex]::Replace($content, $pattern, $replacement)
    
    if ($newContent -ne $content) {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($f.FullName, $newContent, $utf8NoBom)
        Write-Host "  Replaced inline style with external link"
    } else {
        Write-Host "  Pattern not found, skipping"
    }
}

Write-Host "`nDone"
