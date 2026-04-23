const fs = require('fs');

let html = fs.readFileSync('src/pages/index.astro', 'utf8');

// Update titles
const replacements = {
  'Become a Professional Fashion Stylist': 'Professional Fashion Stylist',
  'Become an Art Director': 'Art Direction',
  'Become a Celebrity Stylist': 'Celebrity Stylist',
  'Work in Advertising &amp; Brand Styling': 'Media and Brand Stylist',
  'Work in Commercial Styling': 'Commercial Stylist',
  'Work in E-commerce Styling': 'E-commerce Stylist',
  'Work in Editorial Fashion Styling': 'Editorial Stylist',
  'Secure Paid Work as a Fashion Writer &amp; Fashion Blogger': 'Fashion Blogger and Fashion Journalist',
  'Secure Projects in Runway Styling': 'Runway Stylist',
  'Secure Project in Shoot Production': 'Makeup Artist and Shoot projection'
};

for (const [oldText, newText] of Object.entries(replacements)) {
  html = html.split(oldText).join(newText);
}

// Move red block to the bottom and increase size
html = html.replace(/min-height: 260px; \/\* Make cards slightly taller \*\//g, 'min-height: 420px; /* Make cards much taller */');
// The top: 0 for the red box -> bottom: 0
html = html.replace(/\/\* Red overlay block at top 40% \*\//g, '/* Red overlay block at bottom */');
html = html.replace(/top: 0;\n\s*left: 0;\n\s*width: 100%;\n\s*height: 40%;/g, 'bottom: 0;\n      left: 0;\n      width: 100%;\n      height: auto;\n      min-height: 100px;');
html = html.replace(/top: 0 !important;\n\s*left: 0 !important;\n\s*width: 100% !important;\n\s*height: 40% !important;/g, 'bottom: 0 !important;\n      left: 0 !important;\n      width: 100% !important;\n      height: auto !important;\n      min-height: 100px !important;');

// Set to exactly 4 cards wide. Assuming container is ~1140px and gaps are 20px.
html = html.replace(/width: 280px !important;/g, 'width: 275px !important;');
html = html.replace(/min-width: 280px !important;/g, 'min-width: 275px !important;');

fs.writeFileSync('src/pages/index.astro', html);
console.log('Updated index.astro');
