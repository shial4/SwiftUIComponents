#!/usr/bin/env python3
"""Resize real catalogue captures and compose README galleries (requires Pillow)."""
import argparse
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps

BASE = Path(__file__).resolve().parent


def font(size, bold=False):
    name = 'Arial Bold.ttf' if bold else 'Arial.ttf'
    path = Path('/System/Library/Fonts/Supplemental') / name
    return ImageFont.truetype(str(path), size) if path.exists() else ImageFont.load_default(size=size)


def save(image, path):
    image.convert('RGB').save(path, optimize=True)


def muscle_crop(image):
    """Crop the actual vector preview, excluding navigation, controls and code."""
    image = image.convert('RGB')
    width, height = image.size
    region = image.crop((int(width * .08), int(height * .28), int(width * .92), int(height * .82)))
    mask = Image.new('L', region.size)
    pixels = mask.load()
    source = region.load()
    row_counts = []
    for y in range(region.height):
        count = 0
        for x in range(region.width):
            rgb = source[x, y]
            if max(rgb) - min(rgb) > 65:
                pixels[x, y] = 255
                count += 1
        row_counts.append(count)
    # Ignore separate colored picker text below the preview. Keep the largest
    # vertical cluster of actual colored vector pixels, including narrow gaps.
    clusters = []
    start = last = area = None
    for y, count in enumerate(row_counts):
        if count:
            if start is None or y - last > 20:
                if start is not None:
                    clusters.append((area, start, last + 1))
                start, area = y, 0
            area += count
            last = y
    if start is not None:
        clusters.append((area, start, last + 1))
    if not clusters:
        raise ValueError('No colored vector found in capture')
    _, top, bottom = max(clusters)
    mask = mask.crop((0, top, mask.width, bottom))
    bounds = mask.getbbox()
    if not bounds:
        raise ValueError('No colored vector found in capture')
    x1, y1, x2, y2 = bounds
    y1 += top
    y2 += top
    return region.crop((max(0, x1 - 20), max(0, y1 - 20), min(region.width, x2 + 20), min(region.height, y2 + 20)))


def gallery(entries, ios, android, output, title, columns=4, tile_width=280, tile_height=280):
    rows = (len(entries) + columns - 1) // columns
    canvas = Image.new('RGB', (columns * tile_width + 48, rows * tile_height + 100), '#f4f7fc')
    draw = ImageDraw.Draw(canvas)
    draw.text((24, 20), title, fill='#15243a', font=font(28, True))
    draw.text((24, 58), 'Real app captures. Each preview: iOS on the left, Android on the right.', fill='#526174', font=font(15))
    for index, entry in enumerate(entries):
        x = 24 + index % columns * tile_width
        y = 100 + index // columns * tile_height
        draw.rounded_rectangle((x + 4, y, x + tile_width - 8, y + tile_height - 12), radius=16, fill='white', outline='#dce4ef')
        label = entry['name'].removeprefix('Muscle ').removeprefix('Front ').removeprefix('Back ')
        draw.text((x + tile_width // 2, y + 16), label, anchor='mt', fill='#15243a', font=font(16, True))
        for side, source in enumerate((ios / (entry['image'] + '.png'), android / ('android-' + entry['image'] + '.png'))):
            cropped = muscle_crop(Image.open(source))
            preview = ImageOps.contain(cropped, (tile_width // 2 - 28, tile_height - 85), Image.Resampling.LANCZOS)
            px = x + side * (tile_width // 2) + (tile_width // 2 - preview.width) // 2
            py = y + 52 + (tile_height - 85 - preview.height) // 2
            canvas.paste(preview, (px, py))
            draw.text((x + side * tile_width // 2 + tile_width // 4, y + tile_height - 30), 'iOS' if side == 0 else 'Android', anchor='mt', fill='#526174', font=font(12))
    save(canvas, output)


def hero(ios, android, output, count):
    canvas = Image.new('RGB', (1280, 830), '#101e35')
    draw = ImageDraw.Draw(canvas)
    draw.text((40, 26), 'SwiftUIComponents', font=font(44, True), fill='white')
    draw.text((40, 86), f'Native Swift. iOS + Android. {count} runnable examples.', font=font(24), fill='#bcd9ff')
    screens = [(ios, 'muscle-linear-gradient.png', 'iOS / Muscle Map'),
               (android, 'android-muscle-linear-gradient.png', 'Android / Skip Fuse'),
               (ios, 'muscle-map-regions.png', 'iOS / Body regions'),
               (android, 'android-muscle-map-regions.png', 'Android / Body regions')]
    for index, (directory, filename, label) in enumerate(screens):
        x = 40 + index * 306
        draw.text((x, 138), label, font=font(17, True), fill='#e6f0ff')
        capture = Image.open(directory / filename).convert('RGB')
        preview = ImageOps.contain(capture, (282, 628), Image.Resampling.LANCZOS)
        draw.rounded_rectangle((x - 3, 174, x + preview.width + 3, 180 + preview.height), radius=18, fill='#8293b0')
        canvas.paste(preview, (x, 177))
    save(canvas, output)


def day_parity(ios, android, output):
    canvas = Image.new('RGB', (880, 440), '#f4f7fc')
    draw = ImageDraw.Draw(canvas)
    draw.text((24, 20), 'DefaultDayView: one shared layout.', fill='#15243a', font=font(26, True))
    for index, (directory, name, label) in enumerate(((ios, 'defaultdayview.png', 'iOS'),
                                                    (android, 'android-defaultdayview.png', 'Android / Skip Fuse'))):
        source = Image.open(directory / name).convert('RGB')
        # Find the two actual purple selection surfaces, then keep their spacing intact.
        region = source.crop((0, round(source.height * .24), source.width, round(source.height * .64)))
        mask = Image.new('L', region.size)
        pixels, rgb = mask.load(), region.load()
        for y in range(region.height):
            for x in range(region.width):
                r, g, b = rgb[x, y]
                if r > 150 and b > r and g < r - 10:
                    pixels[x, y] = 255
        x1, y1, x2, y2 = mask.getbbox()
        cropped = region.crop((max(0, x1 - 20), max(0, y1 - 20), min(region.width, x2 + 20), min(region.height, y2 + 20)))
        preview = ImageOps.contain(cropped, (400, 320), Image.Resampling.LANCZOS)
        x = 20 + index * 440
        draw.rounded_rectangle((x, 68, x + 400, 412), radius=16, fill='white', outline='#dce4ef')
        canvas.paste(preview, (x + (400 - preview.width) // 2, 76 + (320 - preview.height) // 2))
        draw.text((x + 200, 418), label, anchor='mt', fill='#526174', font=font(14, True))
    save(canvas, output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ios', required=True, type=Path)
    parser.add_argument('--android', required=True, type=Path)
    parser.add_argument('--output', default=BASE / 'Images', type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    entries = json.loads((BASE / 'Examples.json').read_text())
    for entry in entries:
        for directory, prefix in ((args.ios, ''), (args.android, 'android-')):
            name = prefix + entry['image'] + '.png'
            source = Image.open(directory / name).convert('RGB')
            resized = source.resize((480, round(source.height * 480 / source.width)), Image.Resampling.LANCZOS)
            save(resized, args.output / name)
    styles = [entry for entry in entries if entry['name'].startswith('Muscle ') and entry['name'] not in {'Muscle Map', 'Muscle Map Styles', 'Muscle Map Regions', 'Muscle Map Drag'}]
    gallery(styles, args.ios, args.android, args.output / 'muscle-style-gallery.png', 'Five styles. One shared Swift API.', columns=3, tile_width=400, tile_height=380)
    for side in ('Front', 'Back'):
        anatomy = [entry for entry in entries if entry['category'] == side + ' anatomical shapes']
        gallery(anatomy, args.ios, args.android, args.output / (side.lower() + '-muscle-atlas-gallery.png'), side + ': all 16 anatomical vectors')
    hero(args.ios, args.android, args.output / 'hero.png', len(entries))
    day_parity(args.ios, args.android, args.output / 'default-day-parity.png')
    print('Prepared ' + str(len(entries) * 2) + ' screenshots and five galleries')


if __name__ == '__main__':
    main()
