import re

with open('public/css/post-24.css', 'r') as f:
    content = f.read()

replacements = {
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

for old, new in replacements.items():
    content = content.replace(f'/images/{old}', f'/images/{new}')

with open('public/css/post-24.css', 'w') as f:
    f.write(content)
