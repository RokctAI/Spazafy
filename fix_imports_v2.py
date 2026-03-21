import os

def fix_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception:
        return

    # 1. Remove all BOM characters anywhere they appear
    content = content.replace('\ufeff', '')
    
    lines = content.split('\n')
    
    imports = []
    others = []
    
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('import ') or stripped.startswith("part '") or stripped.startswith("library "):
            imports.append(line)
        else:
            others.append(line)

    new_content = '\n'.join(imports + others)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)

for root, _, files in os.walk('lib'):
    for f in files:
        if f.endswith('.dart'):
             fix_file(os.path.join(root, f))
print('Dart syntax format pass completed!')
