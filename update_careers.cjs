const fs = require('fs');
let html = fs.readFileSync('src/pages/index.astro', 'utf8');

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
  // Use split/join to replace all occurrences since replaceAll might not be available depending on Node version
  html = html.split(oldText).join(newText);
}

fs.writeFileSync('src/pages/index.astro', html);
console.log("Career options successfully updated.");
