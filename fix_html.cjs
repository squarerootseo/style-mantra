const fs = require('fs');
let html = fs.readFileSync('src/pages/index.astro', 'utf8');
html = html.replace(/<<div class="elementor-column/g, '<div class="elementor-column');
fs.writeFileSync('src/pages/index.astro', html);
console.log("Fixed HTML syntax error!");
