$imgDir = "e:\antigravity\style-mantra\public\images"
Copy-Item (Join-Path $imgDir "1-13.webp") (Join-Path $imgDir "1-12.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "2-14.webp") (Join-Path $imgDir "2-12.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "3-11.webp") (Join-Path $imgDir "3-10.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "4-9.webp") (Join-Path $imgDir "4-8.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "5-7.webp") (Join-Path $imgDir "5-6.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "6-6.webp") (Join-Path $imgDir "6-5.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "7-3.webp") (Join-Path $imgDir "7-2.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "8-3.webp") (Join-Path $imgDir "8-2.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "9-3.webp") (Join-Path $imgDir "9-2.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "fashion-designer-drawing-on-tablet-UQZZ8PB.jpg") (Join-Path $imgDir "fashion-designer-working-on-a-digital-tablet-NQJTY7M.jpg") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "young-woman-as-3d-designer-at-home-office-workplac-2DTUHAC.jpg") (Join-Path $imgDir "young-female-designer-in-a-boutique-SJLMTJX.jpg") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "cloth-hanging-on-the-rack-6R2PFSR.jpg") (Join-Path $imgDir "client-trying-a-couture-coat-SFWM45N.jpg") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "Book-1.jpg") (Join-Path $imgDir "Style-mantra-home-page-modules.webp") -ErrorAction SilentlyContinue
Copy-Item (Join-Path $imgDir "Untitled-design-22.png") (Join-Path $imgDir "shadowbg4.jpg") -ErrorAction SilentlyContinue
Write-Host "Copied missing fallbacks."
