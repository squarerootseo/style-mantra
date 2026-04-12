$content = [System.IO.File]::ReadAllText("e:\antigravity\style-mantra\src\pages\our-course.astro")
$lines = $content.Split("`n")
Write-Host "Total lines: $($lines.Count)"
Write-Host "Line 175 length: $($lines[174].Length)"
if ($lines[174].Length -ge 289) {
    $start = [Math]::Max(0, 280)
    $len = [Math]::Min(40, $lines[174].Length - $start)
    Write-Host "Chars around 289: [$($lines[174].Substring($start, $len))]"
}
