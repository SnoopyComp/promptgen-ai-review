#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys, re, pathlib

def main():
    if len(sys.argv) != 2:
        print("usage: parse_reference_paths.py <PR_BODY_FILE>", file=sys.stderr)
        sys.exit(2)

    pr_body_path = pathlib.Path(sys.argv[1])
    if not pr_body_path.is_file():
        print(f"missing file: {pr_body_path}", file=sys.stderr)
        sys.exit(1)

    text = pr_body_path.read_text(encoding="utf-8", errors="replace")

    pattern = re.compile(r'reference\s*=\s*\{(.*?)\}', re.IGNORECASE | re.DOTALL)
    matches = pattern.findall(text)

    for block in matches:
        for raw in block.split(','):
            reference_path = raw.strip().rstrip('\r')
            if reference_path:
                print(reference_path)

if __name__ == "__main__":
    main()
