import re

html = open('src/pages/index.astro', 'r').read()

modules = [
    ("35d7fd07", "/images/fashion-designer-working-on-a-digital-tablet-NQJTY7M.jpg", "Introduction to Fashion Styling"),
    ("3366171e", "/images/1-12.webp", "Elements and principles of styling"),
    ("4bdb014", "/images/2-12.webp", "Understanding body shapes"),
    ("40c02a84", "/images/4-8.webp", "Moodboarding and styling concepts"),
    ("7951e42c", "/images/5-6.webp", "Color theory in fashion styling"),
    ("4787a859", "/images/6-5.webp", "Wardrobe planning & capsule wardrobes"),
    ("b530c78", "/images/Style-mantra-home-page-modules.webp", "Styling for Different Occasions"),
    ("64b522e1", "/images/7-2.webp", "Personal branding and client styling"),
    ("2d9ec4b", "/images/3-10.webp", "Fashion Photography"),
    ("937085e", "/images/8-2.webp", "Basic makeup and grooming"),
    ("f47eb37", "/images/2-12.webp", "Practical styling projects"),
    ("3f8466a", "/images/9-2.webp", "Portfolio development and career growth")
]

for col_id, img_url, title in modules:
    # Find the elementor-widget-wrap block corresponding to this col_id
    pattern = re.compile(rf'(<div class="elementor-column elementor-col-25 elementor-inner-column elementor-element elementor-element-{col_id}.*?>\s*)(<div class="elementor-widget-wrap elementor-element-populated">.*?</div>\s*</div>)', re.DOTALL)
    
    match = pattern.search(html)
    if not match:
        print(f"Failed to find {col_id}")
        continue
        
    start_tag = match.group(1)
    
    new_html = f"""{start_tag}<div class="sm-module-card">
        <div class="sm-module-top">
            <h3>{title}</h3>
        </div>
        <div class="sm-module-bottom" style="background-image: url('{img_url}');"></div>
    </div>
</div>"""

    html = html[:match.start()] + new_html + html[match.end():]

open('src/pages/index.astro', 'w').write(html)
print("Updated index.astro")
