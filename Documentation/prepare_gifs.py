#!/usr/bin/env python3
"""Compose README GIFs from real captures (FFmpeg and Pillow); --hero reuses the catalogue GIFs."""
import argparse
import math
import re
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw
from prepare_images import BASE, font

# Fractions of the captured portrait screen. Keep the interactive controls and
# their results; omit system bars and unused space below each playground.
CLIPS = {
    'dynamic-list': (12, (.105, .95), (.085, .96)),
    'calendar-selection': (10, (.105, .79), (.085, .77)),
    'muscle-paint': (10, (.105, .98), (.085, .93)),
    'joystick-drag': (8, (.105, .73), (.085, .70)),
    'rating-input': (7, (.105, .76), (.085, .76)),
    'counting-label': (8, (.105, .83), (.085, .80)),
    'progress': (9, (.105, .64), (.085, .60)),
}


def metadata(ffmpeg, path):
    result = subprocess.run([ffmpeg, '-hide_banner', '-i', str(path)],
                            capture_output=True, text=True)
    duration = re.search(r'Duration: (\d+):(\d+):(\d+\.\d+)', result.stderr)
    dimensions = re.search(r'Video:.*? (\d{2,5})x(\d{2,5})', result.stderr)
    if not duration or not dimensions:
        raise ValueError(f'Cannot read video metadata: {path}\n{result.stderr}')
    hours, minutes, seconds = map(float, duration.groups())
    width, height = map(int, dimensions.groups())
    duration_seconds = hours * 3600 + minutes * 60 + seconds
    if duration_seconds <= 1.2:
        raise ValueError(f'Recording is too short to trim: {path}')
    return duration_seconds, width, height


def compose(ffmpeg, directory, output, name, spec):
    seconds, *crops = spec
    inputs = [directory / ('ios-' + name + '.mov'),
              directory / ('android-' + name + '.mp4')]
    info = [metadata(ffmpeg, path) for path in inputs]
    tile_width, gap, margin, heading = 320, 16, 12, 42
    crops_px = [(round(h * top), round(h * (bottom - top)))
                for (_, _, h), (top, bottom) in zip(info, crops)]
    tile_height = 2 * math.ceil(max(height * tile_width / width
                                   for (_, width, _), (_, height) in zip(info, crops_px)) / 2)
    canvas_width = tile_width * 2 + gap + margin * 2
    filters = []
    for index, ((duration, _, _), (top, height)) in enumerate(zip(info, crops_px)):
        # Remove recording startup, then align the two complete interactions in
        # time. Source frames remain actual app output; no animation is invented.
        # Hold the final source frame before sampling variable-rate simulator
        # recordings. Otherwise a last update between FPS ticks can be dropped.
        scale_time = (seconds - 1) / duration
        background = 'white' if index == 0 else '0xf9f7ff'
        filters.append(
            f'[{index}:v]tpad=stop_mode=clone:stop_duration=1,'
            'fps=12:eof_action=pass,trim=start=1,'
            f'setpts=(PTS-STARTPTS)*{scale_time},crop=iw:{height}:0:{top},'
            f'scale={tile_width}:-2:flags=lanczos,'
            'tpad=stop_mode=clone:stop_duration=1,fps=12,'
            f'pad={tile_width}:{tile_height}:0:0:color={background}[side{index}]')
    filters.extend([
        f'[side0]pad={tile_width + gap}:{tile_height}:0:0:color=0xf4f7fc[left]',
        f'[left][side1]hstack=inputs=2,tpad=stop_mode=clone:stop_duration=1,'
        f'pad={canvas_width}:{tile_height + heading + margin}:{margin}:{heading}:color=0xf4f7fc[body]',
        '[body][2:v]overlay=0:0:shortest=1,split[frames][colors]',
        '[colors]palettegen=stats_mode=diff[palette]',
        '[frames][palette]paletteuse=dither=bayer:bayer_scale=3:diff_mode=rectangle[gif]',
    ])
    with tempfile.TemporaryDirectory() as temporary:
        header = Image.new('RGBA', (canvas_width, heading), '#f4f7fc')
        draw = ImageDraw.Draw(header)
        for x, label in ((margin + tile_width / 2, 'iOS'),
                         (margin + tile_width + gap + tile_width / 2, 'Android / Skip Fuse')):
            draw.text((x, 12), label, anchor='mt', fill='#15243a', font=font(18, True))
        header_path = Path(temporary) / 'header.png'
        header.save(header_path)
        command = [ffmpeg, '-hide_banner', '-loglevel', 'error', '-y']
        for path in inputs:
            command.extend(['-i', str(path)])
        target = output / (name + '.gif')
        command.extend(['-loop', '1', '-i', str(header_path),
                        '-filter_complex', ';'.join(filters), '-map', '[gif]',
                        '-t', str(seconds), '-loop', '0', str(target)])
        subprocess.run(command, check=True)
        print(f'{target.name}: {seconds}s, {target.stat().st_size / 1024:.0f} KiB', flush=True)


def compose_hero(ffmpeg, output):
    # Crop only the iOS interaction from each checked-in catalogue GIF. The
    # calendar excerpt ends before the week layout brings source code into view.
    clips = [
        ('calendar-selection', 'Calendar', 'Select dates and ranges', (24, 153, 296, 379), 0, 6),
        ('muscle-paint', 'Muscle Map', 'Tap and drag to paint', (24, 221, 296, 428), 2, 7),
        ('dynamic-list', 'DynamicList', 'Cells that fit their content', (24, 158, 296, 376), 0, 12),
        ('progress', 'Progress', 'Animate any Shape', (24, 100, 296, 274), 2, 6),
    ]
    width, height, fps, seconds = 1280, 660, 12, 12
    panel_width, gap, margin = 292, 16, 32
    content_width, content_height, content_top = 268, 390, 224
    canvas = Image.new('RGB', (width, height), '#101e35')
    draw = ImageDraw.Draw(canvas)
    draw.text((margin, 28), 'SwiftUIComponents', font=font(42, True), fill='white')
    draw.text((margin, 86), 'Four interactive components. Real iOS captures.',
              font=font(23), fill='#bcd9ff')
    command = [ffmpeg, '-hide_banner', '-loglevel', 'error', '-y']
    filters = []
    with tempfile.TemporaryDirectory() as temporary:
        background = Path(temporary) / 'hero-background.png'
        for index, (name, title, subtitle, (x, y, w, h), start, duration) in enumerate(clips):
            left = margin + index * (panel_width + gap)
            draw.rounded_rectangle((left, 142, left + panel_width, 634),
                                   radius=18, fill='white')
            draw.text((left + 12, 158), title, font=font(24, True), fill='#15243a')
            draw.text((left + 12, 191), subtitle, font=font(16), fill='#526174')
            filters.append(
                f'[{index + 1}:v]fps={fps},trim=start_frame={start * fps}:end_frame={(start + duration) * fps},'
                f'crop={w}:{h}:{x}:{y},'
                f'scale={content_width}:-2:flags=lanczos,'
                f'pad={content_width}:{content_height}:0:(oh-ih)/2:color=white,'
                f'loop=loop={math.ceil(seconds / duration) - 1}:size={duration * fps}:start=0,'
                f'setpts=N/({fps}*TB),trim=end_frame={seconds * fps}[tile{index}]')
            previous = '[0:v]' if index == 0 else f'[panel{index - 1}]'
            filters.append(f'{previous}[tile{index}]overlay={left + 12}:{content_top}'
                           f':shortest=1[panel{index}]')
        canvas.save(background)
        command.extend(['-loop', '1', '-framerate', str(fps), '-t', str(seconds), '-i', str(background)])
        for name, *_ in clips:
            command.extend(['-i', str(output / (name + '.gif'))])
        filters.extend([
            f'[panel3]trim=duration={seconds},split[frames][colors]',
            '[colors]palettegen=stats_mode=diff[palette]',
            '[frames][palette]paletteuse=dither=bayer:bayer_scale=3:diff_mode=rectangle[gif]',
        ])
        target = output / 'hero.gif'
        command.extend(['-filter_complex', ';'.join(filters), '-map', '[gif]',
                        '-t', str(seconds), '-loop', '0', str(target)])
        subprocess.run(command, check=True)
        print(f'{target.name}: {seconds}s, {target.stat().st_size / 1024:.0f} KiB', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--recordings', type=Path,
                        help='folder containing ios-<clip>.mov and android-<clip>.mp4')
    parser.add_argument('--ffmpeg', default='ffmpeg')
    parser.add_argument('--output', default=BASE / 'Images', type=Path)
    parser.add_argument('--only', action='append', choices=CLIPS,
                        help='compose only the named clip; repeatable')
    parser.add_argument('--hero', action='store_true',
                        help='compose the iOS overview from catalogue GIFs already in --output')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    if args.hero:
        compose_hero(args.ffmpeg, args.output)
        return
    if args.recordings is None:
        parser.error('--recordings is required unless --hero is used')
    for name, spec in CLIPS.items():
        if args.only and name not in args.only:
            continue
        compose(args.ffmpeg, args.recordings, args.output, name, spec)


if __name__ == '__main__':
    main()
