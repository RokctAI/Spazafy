import os, re

def find_definition_of(type_name):
    patterns = [
        re.compile(fr'\bclass\s+{type_name}\b'),
        re.compile(fr'\benum\s+{type_name}\b'),
        re.compile(fr'\btypedef\s+{type_name}\b'),
        re.compile(fr'\bextension\s+{type_name}\b'),
        re.compile(fr'\bmixin\s+{type_name}\b')
    ]
    for root, _, files in os.walk('lib'):
        for f in files:
            if f.endswith('.dart') and f != 'dummy_types.dart':
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                for p in patterns:
                    if p.search(content):
                        rel_path = os.path.relpath(path, 'lib').replace(os.path.sep, '/')
                        return f"package:rokctapp/{rel_path}"
    return None

def analyze_and_heal():
    if not os.path.exists('analyze.log'):
        print("Missing analyze.log")
        return
    with open('analyze.log', 'r', encoding='utf-16') as f:
        log = f.read()
    
    missing_pattern = re.compile(r"(info|error|warning)\s+-\s+(lib[^\s:]+):(\d+):(\d+)\s+-\s+(?:Type|The name|Undefined class|Undefined name|Classes can only extend other classes)\s*'([^']+)'", re.IGNORECASE)
    
    file_imports_needed = {} 
    missing_globals = set()
    
    for match in missing_pattern.finditer(log):
        file_path = match.group(2)
        type_name = match.group(5)
        if len(type_name.split()) > 1:
            continue
        file_path = os.path.normpath(file_path).replace(os.sep, '/')
        
        found_pkg = find_definition_of(type_name)
        if found_pkg:
            if file_path not in file_imports_needed:
                file_imports_needed[file_path] = set()
            file_imports_needed[file_path].add(found_pkg)
        else:
            missing_globals.add(type_name)

    # Inject missing real imports
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
                print(f"Healed {fp} by correctly importing {len(to_add)} missing file(s).")

    # Log 100% missing dependencies transparently
    if missing_globals:
        print("\n[ALERT] The following classes/models are literally missing from the Spazafy codebase.")
        print("Do not mock these! They must be copied over from the old repository:")
        for g in sorted(missing_globals):
            print(f"- {g}")
    else:
        print("\nAll missing types were flawlessly mapped to their real files!")

analyze_and_heal()
