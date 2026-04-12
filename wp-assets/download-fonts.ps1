$fontUrls = @(
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Bold.woff2",
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Extralight.woff2",
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Light.woff2",
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Medium.woff2",
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Regular.woff2",
    "https://stylemantra.co.in/wp-content/uploads/2025/03/ClashDisplay-Semibold.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zatbhpnqw73odd4iyl.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zatbhpnqw73ord4iyl.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zatbhpnqw73otd4g.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zutbhpnqw73oht4d4h.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zutbhpnqw73oht5d4htxm.woff2",
    "https://stylemantra.co.in/wp-content/uploads/elementor/google-fonts/fonts/jost-92zutbhpnqw73oht7j4htxm.woff2"
)

$destDir = "e:\antigravity\style-mantra\public\fonts"
if (-Not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Force -Path $destDir | Out-Null
}

foreach ($url in $fontUrls) {
    $filename = Split-Path $url -Leaf
    $destPath = Join-Path $destDir $filename
    Write-Host "Downloading $filename..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $destPath -ErrorAction Stop
        Write-Host "  Done"
    } catch {
        Write-Host "  Error: $_"
    }
}
Write-Host "Font download complete."
