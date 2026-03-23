import os, re, sys

def find_all_definitions():
    print("Indexing all Dart files...")
    # Map type_name -> file_path
    def_map = {}
    pattern = re.compile(r'\b(?:class|enum|typedef|extension|mixin)\s+([A-Z][a-zA-Z0-9_]*)\b')
    
    for root, _, files in os.walk('lib'):
        for f in files:
            if f.endswith('.dart') and f != 'dummy_types.dart':
                path = os.path.join(root, f)
                try:
                    with open(path, 'r', encoding='utf-8') as file:
                        content = file.read()
                    matches = pattern.findall(content)
                    if matches:
                        rel_path = os.path.relpath(path, 'lib').replace(os.path.sep, '/')
                        pkg_path = f"package:rokctapp/{rel_path}"
                        for m in set(matches):
                            if m not in def_map:
                                def_map[m] = pkg_path
                except Exception as e:
                    pass
    return def_map

def run_fast_healer():
    if not os.path.exists('analyze.log'):
        print("Missing analyze.log")
        return
    with open('analyze.log', 'r', encoding='utf-16') as f:
        log = f.read()
    
    missing_pattern = re.compile(r"(info|error|warning)\s+-\s+(lib[^\s:]+):(\d+):(\d+)\s+-\s+(?:Type|The name|Undefined class|Undefined name|Classes can only extend other classes)\s*'([^']+)'", re.IGNORECASE)
    
    def_map = find_all_definitions()
    print(f"Indexed {len(def_map)} types in O(1) time.")
    
    file_imports_needed = {} 
    missing_globals = set()
    
    for match in missing_pattern.finditer(log):
        file_path = match.group(2)
        type_name = match.group(5)
        if len(type_name.split()) > 1:
            continue
        file_path = os.path.normpath(file_path).replace(os.sep, '/')
        
        found_pkg = def_map.get(type_name)
        if found_pkg:
            if file_path not in file_imports_needed:
                file_imports_needed[file_path] = set()
            file_imports_needed[file_path].add(found_pkg)
        else:
            missing_globals.add(type_name)

    # 1. Strip ALL remaining dummy_types.dart globally
    print("Stripping remaining dummy_types globally...")
    stripped_count = 0
    for root, _, files in os.walk('lib'):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as f_obj:
                    content = f_obj.read()
                if 'import \'package:rokctapp/dummy_types.dart\';\n' in content or 'import "package:rokctapp/dummy_types.dart";\n' in content:
                    content = content.replace('import \'package:rokctapp/dummy_types.dart\';\n', '')
                    content = content.replace('import "package:rokctapp/dummy_types.dart";\n', '')
                    with open(path, 'w', encoding='utf-8') as f_obj:
                        f_obj.write(content)
                    stripped_count += 1
    print(f"Stripped dummy bypass from {stripped_count} files.")
    
    # 2. Inject missing real imports
    healed = 0
    for fp, pkgs in file_imports_needed.items():
        if os.path.exists(fp):
            with open(fp, 'r', encoding='utf-8') as file:
                content = file.read()
            to_add = []
            for pkg in pkgs:
                if pkg not in content:
                    to_add.append(f"import '{pkg}';")
            if to_add:
                new_content = "\n".join(to_add) + "\n" + content
                with open(fp, 'w', encoding='utf-8') as file:
                    file.write(new_content)
                healed += 1

    print(f"Healed {healed} files by mapping real imports.")
    
    if missing_globals:
        print("\n[ALERT] The following classes/models are completely MISSING from the local Spazafy repository:")
        for g in sorted(missing_globals):
            print(f"- {g}")
    else:
        print("\nAll missing types mapping succeeded.")

run_fast_healer()
