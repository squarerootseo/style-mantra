const fs = require('fs');
let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// The original Essential Course Details section
const sourceStartStr = '<section class="elementor-section elementor-top-section elementor-element elementor-element-becb4f0';
const sourceStartIdx = html.indexOf(sourceStartStr);
const sourceEndStr = '</section>\n\t\t\t\t<section class="elementor-section elementor-top-section elementor-element elementor-element-1354722';
const sourceEndIdx = html.indexOf(sourceEndStr);

if(sourceStartIdx === -1 || sourceEndIdx === -1) {
    console.log("Could not find source section bounds");
    process.exit(1);
}

let sourceHtml = html.substring(sourceStartIdx, sourceEndIdx) + '</section>';

// Modify the sourceHtml to be the new pricing section
let newHtml = sourceHtml;

// Make IDs unique
newHtml = newHtml.replace(/becb4f0/g, 'smpricing2');
newHtml = newHtml.replace(/d7b33ce/g, 'smpricingleft');
newHtml = newHtml.replace(/37a828a/g, 'smpricingright');

// Text replacements
newHtml = newHtml.replace('Key information', 'Pricing & ROI');
newHtml = newHtml.replace('Essential Course Details at a Glance', 'Investment in Your Future');
newHtml = newHtml.replace('Get Started', 'Enroll Now');

newHtml = newHtml.replace('Weekly Modules', 'Course Fee');
newHtml = newHtml.replace('Structured lessons delivered weekly to ensure steady learning progress.', '<span style="font-size: 2rem; font-weight: 700; color: #222; font-family: \'Clash Display\', sans-serif;">₹59,990</span>');

newHtml = newHtml.replace('Pre-recorded Lectures', 'Flexible EMI');
newHtml = newHtml.replace('Access recorded sessions anytime for flexible and convenient learning.', 'Options available starting at <strong>₹4,999/month</strong>');

newHtml = newHtml.replace('Live Q&A Sessions', 'High ROI');
newHtml = newHtml.replace('Get expert answers in real-time through interactive live sessions.', 'Start your income journey right after certification.');

newHtml = newHtml.replace('Certification of Completion', 'Premium Rates');
newHtml = newHtml.replace('Earn an industry-recognized certificate to boost your career.', 'Freelance stylists and industry professionals command premium rates.');

// Add CSS for the right column image and styling for the section
const cssInjection = `
<style>
.elementor-element-smpricing2 {
    margin-top: 60px;
    margin-bottom: 60px;
}
.elementor-element-smpricingright {
    background-image: url("/images/fashion-designer-drawing-on-tablet-UQZZ8PB.jpg") !important;
    background-position: center center !important;
    background-size: cover !important;
    background-repeat: no-repeat !important;
    min-height: 500px;
}
</style>
`;
newHtml = cssInjection + '\n' + newHtml;

// Replace the old sm-pricing-section
const targetStartStr = '<section class="elementor-section elementor-top-section elementor-section-boxed elementor-section-height-default sm-pricing-section"';
const targetStartIdx = html.indexOf(targetStartStr);

const targetEndStr = '</section>\n\t\t\t\t<section class="elementor-section elementor-top-section elementor-element elementor-element-cff416e';
let targetEndIdx = html.indexOf(targetEndStr);

if(targetStartIdx === -1 || targetEndIdx === -1) {
    console.log("Could not find target section bounds");
    console.log("Start", targetStartIdx);
    console.log("End", targetEndIdx);
    process.exit(1);
}

// targetEndIdx currently points to the start of '</section>'. We want to include it.
targetEndIdx += '</section>'.length;

html = html.substring(0, targetStartIdx) + newHtml + html.substring(targetEndIdx);

fs.writeFileSync('src/pages/our-course.astro', html);
console.log("Pricing section successfully redesigned.");
