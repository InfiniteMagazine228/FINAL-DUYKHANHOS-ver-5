from PIL import Image, ImageDraw, ImageFont
import os

img = Image.new("RGB", (800, 400), (10, 10, 10))
draw = ImageDraw.Draw(img)

font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
font = ImageFont.truetype(font_path, 60)

text = "DuyKhanhOS"
bbox = draw.textbbox((0, 0), text, font=font)
w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
x = (img.width - w) // 2
y = (img.height - h) // 2

for offset in range(8, 0, -2):
    draw.text((x-offset, y-offset), text, font=font, fill=(180, 0, 255))
    draw.text((x+offset, y+offset), text, font=font, fill=(180, 0, 255))

draw.text((x, y), text, font=font, fill=(255, 0, 255))

os.makedirs("output", exist_ok=True)
img.save("output/gui.png")
