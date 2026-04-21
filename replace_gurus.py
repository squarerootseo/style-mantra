import re

html = open('src/pages/our-course.astro').read()

gurus = [
    {
        "col_id": "cf7ebbc",
        "image": "/images/confident-female-fashion-designer-P6R6E6W.jpg",
        "name": "Lara Samuels",
        "role": "Designer"
    },
    {
        "col_id": "1dbdded",
        "image": "/images/young-woman-as-3d-designer-at-home-office-workplac-2DTUHAC.jpg",
        "name": "Jules Wandae",
        "role": "Designer"
    },
    {
        "col_id": "f04c0ef",
        "image": "/images/portrait-young-fashion-designer-man-working-in-stu-6ZF3RY5.jpg",
        "name": "Mark Houston",
        "role": "Designer"
    },
    {
        "col_id": "8d5c83e",
        "image": "/images/fashion-industry-black-woman-and-designer-portrai-7EDH4ES.jpg",
        "name": "Patricia Young",
        "role": "Designer"
    }
]

for guru in gurus:
    # Find the column
    col_str = f'data-id="{guru["col_id"]}"'
    col_start = html.find(col_str)
    if col_start == -1:
        print(f"Column {guru['col_id']} not found!")
        continue
    
    wrap_start = html.find('<div class="elementor-widget-wrap', col_start)
    if wrap_start == -1:
        print(f"Widget wrap not found for {guru['col_id']}")
        continue

    # Find the end of this div (the widget wrap)
    # Since we know the next column starts after it, or the section ends.
    # Actually, simpler: find the next '</div>\n\t\t</div>\n\t\t\t\t<div class="elementor-column' or '</div>\n\t\t</div>\n\t\t\t\t\t</div>\n\t\t</section>'
    # Let's write a quick balance function
    idx = wrap_start + 4
    depth = 1
    while depth > 0 and idx < len(html):
        next_div = html.find('<div', idx)
        next_end = html.find('</div>', idx)
        if next_div != -1 and next_div < next_end:
            depth += 1
            idx = next_div + 4
        else:
            depth -= 1
            idx = next_end + 6
            
    wrap_end = idx
    old_content = html[wrap_start:wrap_end]
    
    new_content = f'''<div class="sm-module-card">
        <div class="sm-module-top">
            <h3>{guru['name']}<br><span style="font-size: 16px; font-weight: 400;">{guru['role']}</span></h3>
        </div>
        <div class="sm-module-bottom" style="background-image: url('{guru['image']}');"></div>
    </div>'''
    
    html = html[:wrap_start] + new_content + html[wrap_end:]

with open('src/pages/our-course.astro', 'w') as f:
    f.write(html)
    
print("Replacements complete!")
