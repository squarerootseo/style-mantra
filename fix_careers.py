import re

careers = [
    ("5504cd1", "/images/1-13.webp", "Become a Professional Fashion Stylist", "400"),
    ("0811d89", "/images/2-14.webp", "Become an Art Director", "500"),
    ("5d244a7", "/images/3-11.webp", "Become a Celebrity Stylist", "500"),
    ("cf5a678", "/images/4-9.webp", "Work in Advertising &amp; Brand Styling", "600"),
    ("2692c22", "/images/5-7.webp", "Work in Commercial Styling", "700"),
    
    ("c04ee69", "/images/6-6.webp", "Work in E-commerce Styling", "400"),
    ("6820976", "/images/7-3.webp", "Work in Editorial Fashion Styling", "500"),
    ("fb50b3b", "/images/8-3.webp", "Secure Paid Work as a Fashion Writer &amp; Fashion Blogger", "500"),
    ("7696bc1", "/images/9-3.webp", "Secure Projects in Runway Styling", "600"),
    ("021ab40", "/images/10.webp", "Secure Project in Shoot Production", "700")
]

sections = [
    ("2daef8a", careers[0:5]),
    ("a7803e5", careers[5:10])
]

html = open("src/pages/index.astro").read()

# First inner section start
start_idx = html.find('elementor-element-2daef8a')
start_idx = html.rfind('<section', 0, start_idx)

# After second inner section end
end_idx = html.find('elementor-element-ef30a33')
end_idx = html.rfind('<section', 0, end_idx)

prefix = html[:start_idx]

out = []
for sec_id, cards in sections:
    out.append(f'\t\t\t\t<section class="elementor-section elementor-inner-section elementor-element elementor-element-{sec_id} elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="{sec_id}" data-element_type="section" data-settings="{{&quot;jet_parallax_layout_list&quot;:[]}}">\n')
    out.append('\t\t\t\t\t\t<div class="elementor-container elementor-column-gap-default">\n')
    
    for item in cards:
        col_html = f'''\t\t\t\t\t<div class="elementor-column elementor-col-20 elementor-inner-column elementor-element elementor-element-{item[0]} " data-id="{item[0]}" data-element_type="column" data-settings="{{&quot;background_background&quot;:&quot;classic&quot;,&quot;animation&quot;:&quot;fadeIn&quot;,&quot;animation_delay&quot;:{item[3]}}}">
\t\t\t<div class="sm-module-card">
        <div class="sm-module-top">
            <h3>{item[2]}</h3>
        </div>
        <div class="sm-module-bottom" style="background-image: url('{item[1]}');"></div>
    </div>
</div>\n'''
        out.append(col_html)
    
    out.append('\t\t\t\t\t\t</div>\n\t\t\t\t</section>\n')

new_html = prefix + "".join(out) + html[end_idx:]
open("src/pages/index.astro", "w").write(new_html)
print("Complete!")
