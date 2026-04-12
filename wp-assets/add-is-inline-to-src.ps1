$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"

foreach ($f in $files) {
    Write-Host "Processing: $($f.Name)"
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    
    # Safely add is:inline to all script tags that have a src attribute pointing to our local JS files
    # We only target tags without is:inline already.
    $content = [regex]::Replace($content, '(?i)(<script[^>]*?src=["'']/js/.+?["''][^>]*?)(?<!is:inline)>', '$1 is:inline>')
    
    # Wait, the wp-emoji-release.min.js is also there, let's just make sure all <script src=...> get it.
    $content = [regex]::Replace($content, '(?i)(<script[^>]*?src=["''].+?["''][^>]*?)(?<!is:inline)>', '$1 is:inline>')
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}

Write-Host "Done adding is:inline to script blocks with src attributes."
