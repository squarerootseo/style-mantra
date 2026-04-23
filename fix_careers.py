import re

files = ['src/pages/index.astro', 'src/pages/our-course.astro']

careers = [
    ("Professional Fashion Stylist", "/images/career-1.png"),
    ("Art Direction", "/images/career-2.png"),
    ("Celebrity Stylist", "/images/career-3.png"),
    ("Media and Brand Stylist", "/images/career-4.png"),
    ("Commercial Stylist", "/images/career-5.png"),
    ("Editorial Stylist", "/images/career-6.png"),
    ("E-commerce Stylist", "/images/career-7.png"),
    ("Fashion Blogger and Fashion Journalist", "/images/career-8.jpeg"),
    ("Runway Stylist", "/images/career-9.jpeg"),
    ("Makeup Artist and Shoot projection", "/images/career-10.jpeg"),
]

# For index.astro, the text is inside <h3 class="elementor-icon-box-title"> ... </a>
# We don't need to change image URLs in index.astro because they are driven by post-24.css

# For our-course.astro, the images are <img src="..."> and text in <div class="card_carousel_title">...</div>

# Let's just manually fix them using string replacements based on the order, or write a careful regex.

with open('src/pages/our-course.astro', 'r') as f:
    content = f.read()

# The images to replace in our-course.astro:
img_replacements = {
    '1-13.webp': 'career-1.png',
    '2-14.webp': 'career-2.png',
    '3-11.webp': 'career-3.png',
    '4-9.webp': 'career-4.png',
    '5-7.webp': 'career-5.png',
    '6-6.webp': 'career-6.png',
    '7-3.webp': 'career-7.png',
    '8-3.webp': 'career-8.jpeg',
    '9-3.webp': 'career-9.jpeg',
    '10.webp': 'career-10.jpeg'
}

for old, new in img_replacements.items():
    content = content.replace(f'/images/{old}', f'/images/{new}')

with open('src/pages/our-course.astro', 'w') as f:
    f.write(content)

