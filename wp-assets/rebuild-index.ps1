$url = "https://lime-nightingale-910035.hostingersite.com/home/"
$targetFile = "e:\antigravity\style-mantra\src\pages\index.astro"

Write-Host "Fetching pristine HTML from $url"
$response = Invoke-WebRequest -Uri $url -UseBasicParsing
$html = $response.Content

# Clean URLs step by step, preserving EXACT filenames for images!

# 1. Map uploads to /images/
$html = [regex]::Replace($html, 'https?://[^"''\s]+/wp-content/uploads/(?:\d{4}/\d{2}/)?([^"''\s]+?\.(?:jpg|jpeg|png|webp|svg|gif|ico))', '/images/$1')

# 2. Map CSS files
$html = [regex]::Replace($html, 'https?://[^"''\s]+/wp-content/[^"''\s]+?/([^/"''\s]+\.css)(\?[^"''\s]*)?', '/css/$1')

# 3. Map JS files
$html = [regex]::Replace($html, 'https?://[^"''\s]+/wp-content/[^"''\s]+?/([^/"''\s]+\.js)(\?[^"''\s]*)?', '/js/$1')
$html = [regex]::Replace($html, 'https?://[^"''\s]+/wp-includes/[^"''\s]+?/([^/"''\s]+\.js)(\?[^"''\s]*)?', '/js/$1')

# 4. Map internal URLs
$html = [regex]::Replace($html, 'https?://lime-nightingale-910035\.hostingersite\.com/home/?', '/')
$html = [regex]::Replace($html, 'https?://lime-nightingale-910035\.hostingersite\.com/about/?', '/about')
$html = [regex]::Replace($html, 'https?://lime-nightingale-910035\.hostingersite\.com/our-course/?', '/our-course')
$html = [regex]::Replace($html, 'https?://lime-nightingale-910035\.hostingersite\.com/contact/?', '/contact')
$html = [regex]::Replace($html, 'https?://lime-nightingale-910035\.hostingersite\.com/?(?=["''<\s])', '/')

# 5. Remove version queries from remaining assets to bust cache
$html = [regex]::Replace($html, '\?ver=[^"''\s>]*', '')
$html = [regex]::Replace($html, '&#038;ver=[^"''\s>]*', '')

# 6. Add is:inline to all scripts with src
$html = [regex]::Replace($html, '<script([^>]*?)src=', '<script is:inline$1src=')

# 7. Add global fallback fonts to head
$style = '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/v4-shims.min.css"><style is:inline>@import url("https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600;700&display=swap");@font-face {font-family: "eicons";src: url("https://unpkg.com/elementor@3.21.6/assets/lib/eicons/fonts/eicons.woff2") format("woff2");font-weight: 400;font-style: normal;}@font-face {font-family: "jkiticon";src: url("https://raw.githubusercontent.com/jegtheme/jeg-elementor-kit/master/assets/fonts/jkiticon.woff") format("woff");}</style>'
$html = $html -replace '</head>', "$style`n</head>"

# Fix any unescaped spans that astro complains about
$html = [regex]::Replace($html, '(\d+)/span>', '$1</span>')

# Save the new index.astro
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($targetFile, $html, $utf8NoBom)

Write-Host "Rebuilt index.astro precisely with exact image paths!"
