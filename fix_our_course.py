import re

html_path = 'src/pages/our-course.astro'
css_path = 'public/css/post-218.css'

with open(html_path, 'r') as f:
    html = f.read()

with open(css_path, 'r') as f:
    css = f.read()

ids = ['4d065e3', 'e0c2869', '9254e52', '9aefc6c', '62c8b7a', '876d9dc', '4a073a7', '29ac2ce']

for cid in ids:
    # 1. Grab image
    match_img = re.search(r'\.elementor-element-' + cid + r':not.*?background-image:\s*url\(\"(.*?)\"\)', css)
    if not match_img:
        print(f"FAILED to find image for {cid}")
        continue
    img_url = match_img.group(1)

    # 2. Grab title
    pattern_title = r'elementor-element-' + cid + r'.*?elementor-icon-box-title">\s*<a[^>]*>\s*(.*?)\s*</a>'
    match_title = re.search(pattern_title, html, re.DOTALL)
    if not match_title:
        print(f"FAILED to find title for {cid}")
        continue
    title = match_title.group(1).strip()

    # 3. Build new inner content
    new_inner = f"""			<div class="sm-module-card">
        <div class="sm-module-top">
            <h3>{title}</h3>
        </div>
        <div class="sm-module-bottom" style="background-image: url('{img_url}');"></div>
    </div>"""

    # 4. Replace
    # Replace from `<div class="elementor-widget-wrap elementor-element-populated">` to the end of the button/spacer in the column
    # We find the column block bounds
    pattern_column = r'(<div class="elementor-column[^>]+data-id="' + cid + r'"[^>]*>)\s*<div class="elementor-widget-wrap elementor-element-populated">.*?(?=</div>\s*</div>\s*<div class="elementor-column|<div class="elementor-column)'
    
    # Actually, easier way: just regex the whole inner wrap
    pattern_to_replace = r'(<div class="elementor-column[^>]+data-id="' + cid + r'"[^>]*>)\s*<div class="elementor-widget-wrap elementor-element-populated">.*?	</div>\n\t\t</div>'
    
    # We can do this safely using multi-line replacements without DOTALL or with it carefully
    start_tag = f'elementor-element-{cid}'
    start_idx = html.find(start_tag)
    
    # We find where the column starts
    col_start = html.rfind('<div class="elementor-column ', 0, start_idx)
    inner_wrap_start = html.find('<div class="elementor-widget-wrap', col_start)
    
    # Find end of column
    if cid == '9aefc6c' or cid == '29ac2ce': 
        # last in row, ends with </div>\n\t\t\t\t\t</div>\n\t\t</section>
        # Just find the button closing div, it's easier.
        col_end = html.find('Get Started</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t</a>\n\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t</div>', start_idx)
        if col_end != -1:
            col_end += len('Get Started</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t</a>\n\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t</div>')
    else:
        col_end = html.find('Get Started</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t</a>\n\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t</div>', start_idx)
        if col_end != -1:
            col_end += len('Get Started</span>\n\t\t\t\t\t</span>\n\t\t\t\t\t</a>\n\t\t\t\t</div>\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t\t</div>\n\t\t</div>')

    # Construct complete replacement
    if col_end != -1 and col_start != -1:
        col_header = html[col_start:inner_wrap_start]
        # remove background class if any, to avoid conflicts? It's fine
        replacement = col_header + new_inner + "\n\t\t</div>"
        html = html[:col_start] + replacement + html[col_end:]
        print(f"SUCCESSfully replaced {cid}")
    else:
        print(f"FAILED to parse HTML bounds for {cid}")

with open('src/pages/our-course.astro.tmp', 'w') as f:
    f.write(html)
print("Saved to temp file")
