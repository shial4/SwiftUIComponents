#!/usr/bin/env python3
"""Capture the executable catalogue's real iOS simulator screens."""
import argparse
import json
import subprocess
import time
from pathlib import Path

BASE = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--simulator', required=True, help='booted simulator UUID')
    parser.add_argument('--app', type=Path, help='built Examples.app to install first')
    parser.add_argument('--bundle-id', default='com.swiftui.components.Examples')
    parser.add_argument('--output', type=Path, default=BASE / 'Images')
    parser.add_argument('--only', action='append', help='capture only the named route; repeatable')
    parser.add_argument('--settle', type=float, default=1.0, help='seconds to allow native layout to settle')
    args = parser.parse_args()
    entries = json.loads((BASE / 'Examples.json').read_text())
    if args.only:
        known = {entry['name'] for entry in entries}
        unknown = set(args.only) - known
        if unknown:
            parser.error('Unknown routes: ' + ', '.join(sorted(unknown)))
        entries = [entry for entry in entries if entry['name'] in args.only]
    args.output.mkdir(parents=True, exist_ok=True)

    def run(*arguments):
        subprocess.run(['xcrun', 'simctl', *map(str, arguments)], check=True, stdout=subprocess.DEVNULL)

    if args.app:
        run('install', args.simulator, args.app)
    for entry in entries:
        run('launch', '--terminate-running-process', args.simulator, args.bundle_id, '--demo', entry['name'])
        time.sleep(max(0, args.settle))
        run('io', args.simulator, 'screenshot', args.output / (entry['image'] + '.png'))
        print('Captured iOS: ' + entry['name'], flush=True)


if __name__ == '__main__':
    main()
