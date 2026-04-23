const fs = require('fs');

const pricingHtml = `
<section class="elementor-section elementor-top-section elementor-section-boxed elementor-section-height-default sm-pricing-section" style="margin-top: 60px; margin-bottom: 60px;">
    <style>
        .sm-pricing-section {
            padding: 40px 20px;
        }
        .sm-pricing-card {
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid #f1f1f1;
        }
        .sm-pricing-header {
            background: #c92127; /* Solid Brand Color Red */
            color: #ffffff;
            padding: 40px 20px;
        }
        .sm-pricing-header h2 {
            color: #ffffff !important;
            font-family: 'Jost', sans-serif;
            font-weight: 600;
            font-size: 2.2rem;
            margin-bottom: 10px;
        }
        .sm-pricing-header p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            margin: 0;
            font-family: 'Jost', sans-serif;
        }
        .sm-pricing-body {
            padding: 50px 30px;
            background: #ffffff;
        }
        .sm-price-amount {
            font-size: 4rem;
            font-weight: 700;
            color: #222222;
            font-family: 'Clash Display', sans-serif;
            margin-bottom: 5px;
            line-height: 1;
        }
        .sm-emi-text {
            font-size: 1.2rem;
            color: #666666;
            font-family: 'Jost', sans-serif;
            font-weight: 500;
            margin-bottom: 30px;
        }
        .sm-roi-box {
            background: #f9f9f9;
            border-radius: 12px;
            padding: 20px;
            margin-top: 30px;
            border: 1px solid #eeeeee;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .sm-roi-box h4 {
            color: #c92127;
            font-weight: 600;
            font-size: 1.3rem;
            margin-bottom: 10px;
            font-family: 'Jost', sans-serif;
        }
        .sm-roi-box p {
            color: #444444;
            font-size: 1rem;
            margin: 0;
            font-family: 'Jost', sans-serif;
        }
        @media (max-width: 768px) {
            .sm-price-amount { font-size: 3rem; }
            .sm-pricing-header h2 { font-size: 1.8rem; }
        }
    </style>
    <div class="elementor-container">
        <div class="sm-pricing-card animated fadeIn">
            <div class="sm-pricing-header">
                <h2>Investment in Your Future</h2>
                <p>Equip yourself with the skills to build a high-income career.</p>
            </div>
            <div class="sm-pricing-body">
                <div class="sm-price-amount">₹59,990</div>
                <div class="sm-emi-text">EMI options available starting at <strong>₹4,999/month</strong></div>
                
                <div class="sm-roi-box">
                    <h4>High Return on Investment</h4>
                    <p>Start your income journey right after certification. Freelance stylists and industry professionals command premium rates. Your skills pay for the course in just a few successful projects.</p>
                </div>
            </div>
        </div>
    </div>
</section>
`;

let html = fs.readFileSync('src/pages/our-course.astro', 'utf8');

// The section we want to inject BEFORE is:
// <section class="elementor-section elementor-top-section elementor-element elementor-element-aaad6f5
const targetStr = '<section class="elementor-section elementor-top-section elementor-element elementor-element-aaad6f5';
const index = html.indexOf(targetStr);

if (index !== -1) {
    html = html.substring(0, index) + pricingHtml + html.substring(index);
    fs.writeFileSync('src/pages/our-course.astro', html);
    console.log("Successfully injected pricing section.");
} else {
    console.log("Could not find the target section.");
}

