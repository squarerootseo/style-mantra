$files = Get-ChildItem "e:\antigravity\style-mantra\src\pages\*.astro"
$style = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/v4-shims.min.css"><style is:inline>@import url("https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&display=swap");@font-face {font-family: "eicons";src: url("https://unpkg.com/elementor@3.21.6/assets/lib/eicons/fonts/eicons.woff2") format("woff2");font-weight: 400;font-style: normal;}@font-face {font-family: "jkiticon";src: url("https://raw.githubusercontent.com/jegtheme/jeg-elementor-kit/master/assets/fonts/jkiticon.woff") format("woff");}</style>'

foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if (-not $c.Contains('font-awesome/5.15.4')) {
        $c = $c -replace '</head>', "$style`n</head>"
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($f.FullName, $c, $utf8NoBom)
    }
}
Write-Host "Injected fallback fonts."
