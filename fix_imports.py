import os
import re

def fix_imports(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    header_idx = -1
    for idx, line in enumerate(lines):
        s = line.strip()
        if s.startswith('class ') or s.startswith('enum ') or s.startswith('mixin ') or s.startswith('extension ') or s.startswith('@RoutePage') or s.startswith('void ') or s.startswith('Future<'):
            header_idx = idx
            break

    if header_idx == -1:
        return # Skip files with no structured body

    header = lines[:header_idx]
    body = lines[header_idx:]

    directives = []
    others = []

    for line in header:
        s = line.strip()
        if s.startswith('import ') or s.startswith("part ") or s.startswith("library "):
            directives.append(line)
        else:
            others.append(line)

    new_header = directives + others
    if new_header != header:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(new_header + body)
        print("Fixed imports in", filepath)

for root, _, files in os.walk('lib'):
    for f in files:
        if f.endswith('.dart'):
             fix_imports(os.path.join(root, f))
