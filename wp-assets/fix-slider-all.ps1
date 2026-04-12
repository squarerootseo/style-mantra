$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $content = $content -replace '\\/2025\\/03\\/', '\/images\/'
    $content = $content -replace '\\/2025\\/04\\/', '\/images\/'
    $content = $content -replace '\\/elementor\\/thumbs\\/', '\/images\/'

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($f.FullName, $content, $utf8NoBom)
}
Write-Host "Fixed slider URLs in all astro pages"
