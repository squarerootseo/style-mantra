const fs = require('fs');
let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// The error line looks like: min- margin-right: 20px;
// Actually I also replaced margin-right: 30px with margin-right: 20px
html = html.replace(/min- margin-right: 20px;/g, 'margin-right: 20px;');

fs.writeFileSync('src/pages/our-course.astro', html);
console.log('Fixed CSS error in our-course.astro');
