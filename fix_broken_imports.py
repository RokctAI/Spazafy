import os
import re

def fix_imports(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Pattern: import '...'; \s+ (hide|show|as)
                # We want to remove the semicolon before (hide|show|as)
                new_content = re.sub(r"(import\s+['\"].*?)';(\s+)(hide|show|as)", r"\1'\2\3", content)
                new_content = re.sub(r"(import\s+['\"].*?)\";(\s+)(hide|show|as)", r"\1\"\2\3", new_content)
                
                if content != new_content:
                    with open(path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Fixed: {path}")

if __name__ == "__main__":
    fix_imports('lib')
