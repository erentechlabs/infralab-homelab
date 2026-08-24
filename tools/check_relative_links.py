#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
MARKDOWN = [p for p in ROOT.rglob("*.md") if ".git" not in p.parts]

pattern = re.compile(r'!?\[[^\]]*\]\(([^)]+)\)')
errors = []

for md in MARKDOWN:
    text = md.read_text(encoding="utf-8")
    for target in pattern.findall(text):
        target = target.strip().split("#", 1)[0]
        if not target:
            continue
        if target.startswith(("http://", "https://", "mailto:")):
            continue
        path = (md.parent / target).resolve()
        try:
            path.relative_to(ROOT.resolve())
        except ValueError:
            errors.append(f"{md.relative_to(ROOT)}: link escapes repository: {target}")
            continue
        if not path.exists():
            errors.append(f"{md.relative_to(ROOT)}: missing target: {target}")

if errors:
    print("Relative-link validation failed:")
    for error in errors:
        print(f" - {error}")
    sys.exit(1)

print(f"Relative-link validation passed for {len(MARKDOWN)} Markdown files.")
