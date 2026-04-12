$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = Get-Content $f.FullName -Raw

    # Add is:inline to all style tags that don't have it yet
    # Astro tries to process <style> tags, but these WP styles contain syntax esbuild can't parse
    $content = $content -replace '<style(?:\s+[^>]*?)?\s*>', {
        $match = $_.Value
        if ($match -notmatch 'is:inline') {
            $match -replace '<style', '<style is:inline'
        } else {
            $match
        }
    }

    Set-Content $f.FullName -Value $content -NoNewline
    Write-Host "  Added is:inline to style tags"
}

Write-Host "`n=== STYLE FIX COMPLETE ==="
