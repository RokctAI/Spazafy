import os
import re

dart_files_map = {}
LIB_DIR = os.path.abspath('lib')

# Build an index of all dart files
for root, _, files in os.walk(LIB_DIR):
    for f in files:
        if f.endswith('.dart'):
            basename = f
            full_path = os.path.join(root, f)
            if basename not in dart_files_map:
                dart_files_map[basename] = []
            dart_files_map[basename].append(full_path)

def resolve_path(current_file, import_str):
    if import_str.startswith('package:rokctapp/'):
        return os.path.join(LIB_DIR, import_str.replace('package:rokctapp/', '').replace('/', os.sep))
    else:
        return os.path.abspath(os.path.join(os.path.dirname(current_file), import_str.replace('/', os.sep)))

def compute_new_import(current_file, target_file, is_package=False):
    if is_package or import_str_orig.startswith('package:'):
        # Return package path
        rel = os.path.relpath(target_file, LIB_DIR).replace(os.sep, '/')
        return f"package:rokctapp/{rel}"
    else:
        # Return relative
        rel = os.path.relpath(target_file, os.path.dirname(current_file)).replace(os.sep, '/')
        if not rel.startswith('.'):
            rel = './' + rel
        return rel

def fix_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception:
        return

    lines = content.split('\n')
    changed = False
    
    # Regex to catch import '...' and export '...'
    pattern = re.compile(r"^(import|export)\s+['\"]([^'\"]+)['\"](.*)$")
    
    for i, line in enumerate(lines):
        s_line = line.strip()
        match = pattern.match(s_line)
        if match:
            directive = match.group(1)
            global import_str_orig
            import_str_orig = match.group(2)
            rest = match.group(3)
            
            # evaluate if it's flutter or third party
            if import_str_orig.startswith('package:') and not import_str_orig.startswith('package:rokctapp/'):
                continue
            if import_str_orig.startswith('dart:'):
                continue
                
            resolved_full = resolve_path(filepath, import_str_orig)
            
            if not os.path.exists(resolved_full):
                basename = os.path.basename(import_str_orig)
                candidates = dart_files_map.get(basename, [])
                
                if candidates:
                    # Pick the best candidate based on directory hints
                    best_candidate = candidates[0]
                    if len(candidates) > 1:
                        # try to match driver/manager scope
                        is_driver = 'driver' in filepath.lower()
                        is_manager = 'manager' in filepath.lower()
                        
                        for c in candidates:
                            if is_driver and 'driver' in c.lower():
                                best_candidate = c
                                break
                            if is_manager and 'manager' in c.lower():
                                best_candidate = c
                                break
                    
                    new_import_path = compute_new_import(filepath, best_candidate, is_package=import_str_orig.startswith('package:rokctapp/'))
                    new_line = line.replace(import_str_orig, new_import_path)
                    lines[i] = new_line
                    changed = True
                    print(f"Fixed {import_str_orig} -> {new_import_path} in {os.path.basename(filepath)}")
                else:
                    # File literally doesn't exist anywhere in lib. Comment it out to safely let it compile
                    lines[i] = f"// {line} // NOT FOUND IN PROJECT"
                    changed = True
                    print(f"Commented missing dead file {import_str_orig} in {os.path.basename(filepath)}")

    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))

for root, _, files in os.walk(LIB_DIR):
    for f in files:
        if f.endswith('.dart'):
             fix_file(os.path.join(root, f))
print("Finished fixing dead imports!")
