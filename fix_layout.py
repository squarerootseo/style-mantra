import re

html = open('src/pages/our-course.astro').read()

inclusions = [
    {
        "id": "06b11a3",
        "title": "Printed guide book and pre designed templates",
        "img": "/images/1-1.jpg"
    },
    {
        "id": "566b549",
        "title": "Basic makeup kit",
        "img": "/images/2-1.jpg"
    },
    {
        "id": "98e6c04",
        "title": "Stationary",
        "img": "/images/3-1.jpg"
    },
    {
        "id": "f17d442",
        "title": "Skin tone guide",
        "img": "/images/4-1.jpg"
    },
    {
        "id": "645aaa4",
        "title": "List of resources to level up",
        "img": "/images/5.jpg"
    }
]

# 1. Revert Inclusions to original icon-boxes
for inc in inclusions:
    col_str = f'data-id="{inc["id"]}"'
    col_start = html.find(col_str)
    wrap_start = html.find('<div class="sm-module-card">', col_start)
    wrap_end = html.find('</div>\n    </div>', wrap_start) + len('</div>\n    </div>')
    
    # Original elementor icon box HTML structure
    original_html = f'''<div class="elementor-widget-wrap elementor-element-populated">
					<div class="elementor-background-overlay"></div>
						<div class="elementor-element elementor-element-fake{inc['id']} elementor-widget elementor-widget-spacer" data-id="fake{inc['id']}" data-element_type="widget" data-widget_type="spacer.default">
				<div class="elementor-widget-container">
							<div class="elementor-spacer">
			<div class="elementor-spacer-inner"></div>
		</div>
						</div>
				</div>
				<div class="elementor-element elementor-element-icon{inc['id']} elementor-widget elementor-widget-icon-box" data-id="icon{inc['id']}" data-element_type="widget" data-widget_type="icon-box.default">
				<div class="elementor-widget-container">
							<div class="elementor-icon-box-wrapper">
						<div class="elementor-icon-box-content">
									<h3 class="elementor-icon-box-title">
						<a href="/our-course#">
							{inc['title']}						</a>
					</h3>
			</div>
		</div>
				</div>
				</div>
					</div>'''
    
    html = html[:wrap_start] + original_html + html[wrap_end:]

# 2. ALSO, we need to add the background image to the widget wrap!
# Wait, in the original, the background was on the `elementor-widget-wrap` or `elementor-background-overlay` in CSS.
# I will just add an inline style to the `elementor-widget-wrap` to restore the image!
for inc in inclusions:
    col_str = f'data-id="{inc["id"]}"'
    col_start = html.find(col_str)
    wrap_start = html.find('<div class="elementor-widget-wrap', col_start)
    
    # Add inline style
    style_insert = f' style="background-image: url(\'{inc["img"]}\'); background-size: cover; background-position: center;"'
    html = html[:wrap_start+33] + style_insert + html[wrap_start+33:]

# 3. Add the missing structural tags between 645aaa4 and 4267a82
search_str = '</div><div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-4267a82"'
missing_tags = '''</div>
						</div>
				</section>
					</div>
		</div>
					</div>
		</section>
				<section class="elementor-section elementor-top-section elementor-element elementor-element-a1b2c3d elementor-section-boxed elementor-section-height-default elementor-section-height-default" data-id="a1b2c3d" data-element_type="section" data-settings="{&quot;jet_parallax_layout_list&quot;:[]}">
						<div class="elementor-container elementor-column-gap-default">
					<div class="elementor-column elementor-col-100 elementor-top-column elementor-element elementor-element-4267a82"'''

html = html.replace(search_str, missing_tags)

with open('src/pages/our-course.astro', 'w') as f:
    f.write(html)

print("Fixed!")
