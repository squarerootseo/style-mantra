const fs = require('fs');

function updateFile(file) {
  let html = fs.readFileSync(file, 'utf8');
  
  html = html.replace(/<p>Why Choose Us<\/p>/g, '<p>MEET THE TEAM</p>');
  html = html.replace(/<h2 class="elementor-heading-title elementor-size-default">What makes style mantra a perfect fit\?<\/h2>/g, 
    '<h2 class="elementor-heading-title elementor-size-default">The Stylists Behind Style Mantra</h2>\n\t\t\t\t\t<p style="margin-top: 15px; font-size: 16px; color: #555;">Learn from industry professionals who have styled Celebrities, real shoots, real brands and real people.</p>');

  fs.writeFileSync(file, html);
  console.log(`Updated ${file}`);
}

updateFile('src/pages/index.astro');
updateFile('src/pages/about.astro');
