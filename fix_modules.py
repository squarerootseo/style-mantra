import re

modules = [
    ("35d7fd07", "/images/fashion-designer-working-on-a-digital-tablet-NQJTY7M.jpg", "Introduction to Fashion Styling", "400"),
    ("3366171e", "/images/1-12.webp", "Elements and principles of styling", "500"),
    ("4bdb014", "/images/2-12.webp", "Understanding body shapes", "500"),
    ("40c02a84", "/images/4-8.webp", "Moodboarding and styling concepts", "600"),
    
    ("7951e42c", "/images/5-6.webp", "Color theory in fashion styling", "400"),
    ("4787a859", "/images/6-5.webp", "Wardrobe planning & capsule wardrobes", "500"),
    ("b530c78", "/images/Style-mantra-home-page-modules.webp", "Styling for Different Occasions", "500"),
    ("64b522e1", "/images/7-2.webp", "Personal branding and client styling", "600"),
    
    ("2d9ec4b", "/images/3-10.webp", "Fashion Photography", "400"),
    ("937085e", "/images/8-2.webp", "Basic makeup and grooming", "500"),
    ("f47eb37", "/images/2-12.webp", "Practical styling projects", "500"),
    ("3f8466a", "/images/9-2.webp", "Portfolio development and career growth", "500")
]

sections = [
    "77107ac5",
    "593ee4a7",
    "06941cf"
]

html = open("src/pages/index.astro").read()
start_idx = html.find('id="module"')
start_idx = html.rfind('<section', 0, start_idx)
end_idx = html.find('id="testimonial"')
end_idx = html.rfind('<section', 0, end_idx)

# Extract prefix of module section (the heading)
heading_end = html.find('elementor-element-77107ac5')
heading_end = html.rfind('<section', 0, heading_end)
prefix = html[start_idx:heading_end]

out = [prefix]
for i, sec in enumerate(sections):
    out.append(f'\t\t\t\t<section class="elementor-section elementor-inner-section elementor-element elementor-element-{sec} elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="{sec}" data-element_type="section" data-settings="{{&quot;jet_parallax_layout_list&quot;:[]}}">\n')
    out.append('\t\t\t\t\t\t<div class="elementor-container elementor-column-gap-default">\n')
    
    for j in range(4):
        item = modules[i*4 + j]
        col_html = f'''\t\t\t\t\t<div class="elementor-column elementor-col-25 elementor-inner-column elementor-element elementor-element-{item[0]} " data-id="{item[0]}" data-element_type="column" data-settings="{{&quot;background_background&quot;:&quot;classic&quot;,&quot;animation&quot;:&quot;fadeIn&quot;,&quot;animation_delay&quot;:{item[3]}}}">
\t\t\t<div class="sm-module-card">
        <div class="sm-module-top">
            <h3>{item[2]}</h3>
        </div>
        <div class="sm-module-bottom" style="background-image: url('{item[1]}');"></div>
    </div>
</div>\n'''
        out.append(col_html)
    
    out.append('\t\t\t\t\t\t</div>\n\t\t\t\t</section>\n')

out.append('\t\t\t\t\t</div>\n\t\t</div>\n\t\t\t\t\t\t</div>\n\t\t\t</section>\n')

new_html = html[:start_idx] + "".join(out) + html[end_idx:]
open("src/pages/index.astro", "w").write(new_html)
print("Complete!")
