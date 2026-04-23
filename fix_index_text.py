import re

with open('src/pages/index.astro', 'r') as f:
    content = f.read()

# The mapping from element ID to its correct title
mapping = {
    '5504cd1': 'Professional Fashion Stylist',
    '0811d89': 'Art Direction',
    '5d244a7': 'Celebrity Stylist',
    'cf5a678': 'Media and Brand Stylist',
    '2692c22': 'Commercial Stylist',
    'c04ee69': 'Editorial Stylist',
    '6820976': 'E-commerce Stylist',
    'fb50b3b': 'Fashion Blogger and Fashion Journalist',
    '7696bc1': 'Runway Stylist',
    '021ab40': 'Makeup Artist and Shoot projection'
}

for elem_id, title in mapping.items():
    # We look for the block starting with elementor-element-{elem_id} and replace the title inside it
    # Since they can appear twice (due to duplication), we use regex
    
    # Regex explanation:
    # Match the start of the column div with the specific ID
    # Match anything (lazy) up to the </a> tag inside <h3 class="elementor-icon-box-title">
    pattern = r'(elementor-element-' + elem_id + r'\b.*?(?:<h3 class="elementor-icon-box-title"[^>]*>\s*<a href="[^"]*"[^>]*>)\s*)([^<]*?)(\s*</a>)'
    
    def replacer(match):
        return match.group(1) + title + match.group(3)
        
    content = re.sub(pattern, replacer, content, flags=re.DOTALL)

with open('src/pages/index.astro', 'w') as f:
    f.write(content)

