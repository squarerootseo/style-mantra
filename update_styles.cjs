const fs = require('fs');

function updateFile(filePath) {
    if (!fs.existsSync(filePath)) {
        console.log(`File not found: ${filePath}`);
        return;
    }
    
    let html = fs.readFileSync(filePath, 'utf8');

    // Make the cards wider (4 visible at a time)
    // Currently: width: 236px !important; min-width: 236px !important; margin-right: 30px;
    html = html.replace(/width: 236px !important;/g, 'width: 262.5px !important;');
    html = html.replace(/min-width: 236px !important;/g, 'min-width: 262.5px !important;');

    // Update the styles for the red box and text alignment
    // We will inject new CSS into the <style> block that contains .sm-course-marquee
    const styleInjection = `
  .uc_classic_carousel_content {
    background-color: #b71c1c; /* Solid Brand Red */
    color: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 20px;
    min-height: 120px; /* Give it some height for vertical centering */
    box-sizing: border-box;
  }
  .card_carousel_title {
    color: #ffffff !important;
    font-size: 18px !important;
    font-weight: 600;
    margin: 0;
    line-height: 1.4;
  }
  .sm-course-item {
    border-radius: 8px; /* slight rounding? screenshot shows sharp or slight round */
    overflow: hidden;
  }
  /* Remove border if it exists */
  .uc_classic_carousel_border {
    display: none !important;
  }
`;
    // Insert into the existing <style> block
    if (html.includes('.sm-course-marquee {') && !html.includes('.uc_classic_carousel_content {')) {
        html = html.replace('.sm-course-marquee {', styleInjection + '\n  .sm-course-marquee {');
    }

    fs.writeFileSync(filePath, html);
    console.log(`Updated styles in ${filePath}`);
}

updateFile('src/pages/index.astro');
// Wait, the user said "Apply the same changes on the home page in the same career section."
// Does index.astro have this section? Let's check!
