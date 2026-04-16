$bytes = [System.IO.File]::ReadAllBytes('e:\antigravity\style-mantra\src\pages\index.astro')
$text = [System.Text.Encoding]::UTF8.GetString($bytes)

# Search for shadow-text, Style Mantra, jkit-heading
$patterns = @('shadow-text', 'Style Mantra', 'jkit-heading', 'ClashDisplay', 'Clash Display')

foreach ($pat in $patterns) {
    $idx = $text.IndexOf($pat)
    if ($idx -ge 0) {
        # Find the line number
        $before = $text.Substring(0, $idx)
        $lineNum = ($before.Split("`n")).Length
        $contextStart = [Math]::Max(0, $idx - 100)
        $contextEnd = [Math]::Min($text.Length, $idx + 100)
        Write-Host "FOUND '$pat' at character $idx (approx line $lineNum)"
        Write-Host "Context: $($text.Substring($contextStart, $contextEnd - $contextStart))"
        Write-Host ""
    } else {
        Write-Host "NOT FOUND: '$pat'"
    }
}
