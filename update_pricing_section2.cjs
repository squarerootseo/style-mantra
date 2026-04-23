const fs = require('fs');
let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// The original Essential Course Details section
const sourceStartStr = '<section class="elementor-section elementor-top-section elementor-element elementor-element-becb4f0';
const sourceStartIdx = html.indexOf(sourceStartStr);
const sourceEndStr = '</section>\n\t\t\t\t<section class="elementor-section elementor-top-section elementor-element elementor-element-1354722';
let sourceEndIdx = html.indexOf(sourceEndStr);

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
newHtml = newHtml.replace('Key information', '<span style="color:#c92127;font-weight:bold;letter-spacing:1px;font-size:0.9rem;">PRICING & ROI</span>');
newHtml = newHtml.replace('Essential Course Details at a Glance', 'Investment in Your Future');
newHtml = newHtml.replace('Get Started', 'ENROLL NOW');
// Button link goes to #contact maybe, but the original has href="/contact", that is fine.

newHtml = newHtml.replace('Weekly Modules', 'Course Fee');
newHtml = newHtml.replace('Structured lessons delivered weekly to ensure steady learning progress.', '<span style="font-size: 2.5rem; font-weight: 700; color: #222; font-family: \'Clash Display\', sans-serif;">₹59,990</span>');

newHtml = newHtml.replace('Pre-recorded Lectures', 'Flexible EMI');
newHtml = newHtml.replace('Access recorded sessions anytime for flexible and convenient learning.', 'Options available starting at <br><strong>₹4,999/month</strong>');

// Be careful with HTML encoding!
newHtml = newHtml.replace('Live Q&amp;A Sessions', 'High ROI');
newHtml = newHtml.replace('Get expert answers in real-time through interactive live sessions.', 'Start your income journey right after certification.');

newHtml = newHtml.replace('Certification of Completion', 'Premium Rates');
newHtml = newHtml.replace('Earn an industry-recognized certificate to boost your career.', 'Freelance stylists and industry professionals command premium rates.');

// The right column currently has class animated fadeIn and elementor-element-smpricingright
// We'll inject the CSS for the background image right before the section
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
    console.log("targetStartIdx:", targetStartIdx);
    console.log("targetEndIdx:", targetEndIdx);
    // fallback
    const nextSectionIdx = html.indexOf('<section class="elementor-section elementor-top-section elementor-element elementor-element-cff416e', targetStartIdx);
    
    if (nextSectionIdx !== -1) {
        const sectionClosingTag = '</section>';
        const beforeNextSection = html.substring(0, nextSectionIdx);
        targetEndIdx = beforeNextSection.lastIndexOf(sectionClosingTag);
        
        if (targetEndIdx !== -1) {
            targetEndIdx += sectionClosingTag.length;
        } else {
             process.exit(1);
        }
    } else {
        process.exit(1);
    }
} else {
    targetEndIdx += '</section>'.length;
}

html = html.substring(0, targetStartIdx) + newHtml + html.substring(targetEndIdx);

fs.writeFileSync('src/pages/our-course.astro', html);
console.log("Pricing section successfully redesigned.");
