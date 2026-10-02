#!/usr/bin/env python3
"""Compose paired README GIFs from real iOS/Android recordings (FFmpeg and Pillow)."""
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
    'rating-input': (7, (.105, .68), (.085, .68)),
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
        scale_time = seconds / (duration - 1.2)
        background = 'white' if index == 0 else '0xf9f7ff'
        filters.append(
            f'[{index}:v]trim=start=1:end={duration - .2},'
            f'setpts=(PTS-STARTPTS)*{scale_time},crop=iw:{height}:0:{top},'
            f'scale={tile_width}:-2:flags=lanczos,fps=12,'
            'tpad=stop_mode=clone:stop_duration=1,'
            f'pad={tile_width}:{tile_height}:0:0:color={background}[side{index}]')
    filters.extend([
        f'[side0]pad={tile_width + gap}:{tile_height}:0:0:color=0xf4f7fc[left]',
        f'[left][side1]hstack=inputs=2,'
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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--recordings', required=True, type=Path,
                        help='folder containing ios-<clip>.mov and android-<clip>.mp4')
    parser.add_argument('--ffmpeg', default='ffmpeg')
    parser.add_argument('--output', default=BASE / 'Images', type=Path)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for name, spec in CLIPS.items():
        compose(args.ffmpeg, args.recordings, args.output, name, spec)


if __name__ == '__main__':
    main()
