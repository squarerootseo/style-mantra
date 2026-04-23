const fs = require('fs');

let html = fs.readFileSync('src/pages/index.astro', 'utf8');

// Ensure the icon box wrapper takes full width
html = html.replace('.sm-careers-marquee .elementor-widget-icon-box .elementor-icon-box-wrapper {', '.sm-careers-marquee .elementor-widget-icon-box .elementor-icon-box-wrapper {\n      width: 100% !important;');

html = html.replace('.sm-careers-marquee .elementor-icon-box-content {', '.sm-careers-marquee .elementor-icon-box-content {\n      width: 100% !important;\n      text-align: center !important;');

html = html.replace('.sm-careers-marquee .elementor-icon-box-title {', '.sm-careers-marquee .elementor-icon-box-title {\n      width: 100% !important;\n      text-align: center !important;');

fs.writeFileSync('src/pages/index.astro', html);
console.log('Fixed CSS alignment in index.astro');
