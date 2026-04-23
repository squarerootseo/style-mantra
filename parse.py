from bs4 import BeautifulSoup

html = open("src/pages/index.astro").read()
soup = BeautifulSoup(html, "html.parser")

sec1 = soup.find(attrs={"data-id": "2daef8a"})
sec2 = soup.find(attrs={"data-id": "a7803e5"})

cols1 = sec1.find_all(class_="elementor-column")
cols2 = sec2.find_all(class_="elementor-column")

print(f"Found {len(cols1)} cols in sec1")
print(f"Found {len(cols2)} cols in sec2")

