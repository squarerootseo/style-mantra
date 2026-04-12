# Fix the specific esbuild parsing issues
$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Change type="module" to type="text/javascript" for the emoji loader script
    # Astro processes type="module" scripts differently even with is:inline
    $content = $content -replace '<script type="module" is:inline>', '<script type="text/javascript" is:inline>'
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
    Write-Host "  Fixed module script"
}

Write-Host "`nDone"
