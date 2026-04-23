const fs = require('fs');

let html = fs.readFileSync('src/pages/index.astro', 'utf8');

// Find the carousel wrapper
const startWrapper = '<div class="uc_classic_carousel" id="uc_card_carousel_elementor_ac37e38-wrapper">';
const endWrapper = '<!-- end Card Carousel -->';

const startIndex = html.indexOf(startWrapper);
const endIndex = html.indexOf(endWrapper, startIndex);

if (startIndex === -1 || endIndex === -1) {
  console.log("Could not find carousel wrapper");
  process.exit(1);
}

const carouselHtml = html.substring(startIndex, endIndex);

// Extract the 10 unique items.
// They are in <div id="uc_card_carousel_elementor_ac37e38_item1" ...> ... </div></div>
const items = [];
for (let i = 1; i <= 10; i++) {
  const itemStartId = `id="uc_card_carousel_elementor_ac37e38_item${i}"`;
  const itemStartIndex = carouselHtml.indexOf(itemStartId);
  if (itemStartIndex !== -1) {
    // Find the enclosing <div class="owl-item ...">
    const classIndex = carouselHtml.lastIndexOf('<div class="owl-item', itemStartIndex);
    const itemContentStart = carouselHtml.indexOf('<div class="ue-carousel-item">', itemStartIndex);
    
    // The item ends where the next owl-item begins, or the end of the wrapper
    let itemEndIndex = carouselHtml.indexOf('</div></div><div class="owl-item', itemContentStart);
    if (itemEndIndex === -1) {
       itemEndIndex = carouselHtml.indexOf('</div></div>        </div>', itemContentStart);
    }
    
    if (itemEndIndex !== -1 && itemContentStart !== -1) {
       // Extract just the inner ue-carousel-item
       let itemHtml = carouselHtml.substring(itemContentStart, itemEndIndex);
       items.push(`<div class="sm-course-item">${itemHtml}</div>`);
    }
  }
}

console.log(`Found ${items.length} items`);

if (items.length === 10) {
  const css = `
<style>
  .sm-course-marquee {
    width: 100%;
    overflow: hidden;
    position: relative;
    padding: 20px 0;
  }
  .sm-course-track {
    display: flex;
    width: max-content;
    animation: smCourseMarquee 25s linear infinite;
  }
  .sm-course-marquee:hover .sm-course-track {
    animation-play-state: paused;
  }
  .sm-course-item {
    width: 236px !important;
    min-width: 236px !important;
    margin-right: 30px;
    flex-shrink: 0;
  }
  @keyframes smCourseMarquee {
    0% { transform: translateX(0); }
    100% { transform: translateX(-50%); }
  }
</style>
`;
  
  const trackContent = items.join('\n') + '\n' + items.join('\n');
  
  const newHtml = `
${css}
<div class="sm-course-marquee">
  <div class="sm-course-track">
    ${trackContent}
  </div>
</div>
`;

  // Remove the old <style> block and the <link> for owl-carousel-css which are right before it
  // Actually, just replace everything from '<link id="owl-carousel-css"' to endWrapper
  const linkIndex = html.lastIndexOf('<link id="owl-carousel-css"', startIndex);
  if (linkIndex !== -1 && linkIndex > startIndex - 1000) {
      html = html.substring(0, linkIndex) + newHtml + html.substring(endIndex);
  } else {
      html = html.substring(0, startIndex) + newHtml + html.substring(endIndex);
  }
  
  fs.writeFileSync('src/pages/index.astro', html);
  console.log("Successfully updated carousel");
} else {
  console.log("Did not find 10 items, skipping replacement.");
}
