const fs = require('fs');

let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// Update width and add height to image
const styleInjection = `
  .sm-course-item {
    width: 275px !important;
    min-width: 275px !important;
    margin-right: 20px;
    border-radius: 8px;
    overflow: hidden;
  }
  .uc_classic_carousel_placeholder img {
    height: 320px; /* Increase height */
    object-fit: cover;
    width: 100%;
    display: block;
  }
  .uc_classic_carousel_content {
    background-color: #b71c1c; /* Solid Brand Red */
    color: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 15px;
    min-height: 100px; /* Center alignment */
    box-sizing: border-box;
  }
  .card_carousel_title {
    color: #ffffff !important;
    font-size: 18px !important;
    font-weight: 600;
    margin: 0;
    line-height: 1.4;
  }
  .uc_classic_carousel_border {
    display: none !important;
  }
`;

// Remove my previous injection if it exists so we don't duplicate
html = html.replace(/\.uc_classic_carousel_content \{[\s\S]*?\.uc_classic_carousel_border \{[\s\S]*?\}/, '');

// Re-inject
html = html.replace('.sm-course-marquee {', styleInjection + '\n  .sm-course-marquee {');

// Clean up width/margin from .sm-course-item in the existing css
html = html.replace(/width: 262\.5px !important;/g, '');
html = html.replace(/min-width: 262\.5px !important;/g, '');
html = html.replace(/width: 236px !important;/g, '');
html = html.replace(/min-width: 236px !important;/g, '');
// Wait, margin-right was 30px, I should replace it.
html = html.replace(/margin-right: 30px;/g, 'margin-right: 20px;');

fs.writeFileSync('src/pages/our-course.astro', html);
console.log('Updated our-course.astro layout.');
