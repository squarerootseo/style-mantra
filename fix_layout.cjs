const fs = require('fs');

let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// 1. Move the testimonial section.
// It starts with `<section class="elementor-section ... cff416e` and ends with `</section>` around line 1327.
// We can find the exact text block.
const testimonialStart = '<section class="elementor-section elementor-top-section elementor-element elementor-element-cff416e';
const testimonialEnd = '</section>\n\t\t\t\t<section class="elementor-section elementor-top-section elementor-element elementor-element-88f3ea2';

const startIdx = html.indexOf(testimonialStart);
const endIdx = html.indexOf(testimonialEnd) + '</section>'.length;

if (startIdx === -1 || html.indexOf(testimonialEnd) === -1) {
  console.log("Could not find Testimonial section bounds");
  process.exit(1);
}

const testimonialHtml = html.substring(startIdx, endIdx);

// Remove it from current position
html = html.substring(0, startIdx) + html.substring(endIdx);

// 2. Find where to insert it: After Investment (which ends with `</section>`) and before Form (which starts with `aaad6f5`)
const formStart = '<section class="elementor-section elementor-top-section elementor-element elementor-element-aaad6f5';
const insertIdx = html.indexOf(formStart);

if (insertIdx === -1) {
  console.log("Could not find Form section bounds");
  process.exit(1);
}

// Insert Testimonial right before Form
html = html.substring(0, insertIdx) + testimonialHtml + '\n' + html.substring(insertIdx);

// 3. Make Investment CSS subtle
html = html.replace(/background: #c92127; \/\* Solid Brand Color Red \*\//g, 'background: #fafafa; border-bottom: 1px solid #f1f1f1;');
html = html.replace(/color: #ffffff !important;/g, 'color: #c92127 !important;');
html = html.replace(/color: rgba\(255, 255, 255, 0.9\);/g, 'color: #555555;');
html = html.replace(/box-shadow: 0 10px 40px rgba\(0,0,0,0.08\);/g, 'box-shadow: 0 5px 25px rgba(0,0,0,0.04);');
html = html.replace(/font-weight: 600;/g, 'font-weight: 500;');

fs.writeFileSync('src/pages/our-course.astro', html);
console.log("Successfully reordered and styled");
