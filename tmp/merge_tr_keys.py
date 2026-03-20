import re
import os

def extract_keys(content):
    # Matches: static const String name = 'value'; or "value";
    pattern = r"static\s+const\s+String\s+(\w+)\s*=\s*['\"]([^'\"]+)['\"];"
    return re.findall(pattern, content)

def merge_tr_keys():
    global_path = r"c:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib\infrastructure\services\constants\tr_keys.dart"
    manager_path = r"c:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib\infrastructure\services\constants\manager\tr_keys.dart"
    driver_path = r"c:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib\infrastructure\services\constants\driver\tr_keys.dart"

    with open(global_path, 'r', encoding='utf-8') as f:
        global_content = f.read()
    
    with open(manager_path, 'r', encoding='utf-8') as f:
        manager_content = f.read()
        
    with open(driver_path, 'r', encoding='utf-8') as f:
        driver_content = f.read()

    global_keys = dict(extract_keys(global_content))
    manager_keys = extract_keys(manager_content)
    driver_keys = extract_keys(driver_content)

    new_keys = []
    
    # Check Manager keys
    for key, value in manager_keys:
        if key not in global_keys:
            new_keys.append((key, value))
            global_keys[key] = value # Prevents duplicates within the same run

    # Check Driver keys
    for key, value in driver_keys:
        if key not in global_keys:
            new_keys.append((key, value))
            global_keys[key] = value

    if not new_keys:
        print("No new keys to add.")
        return

    # Prepare the string to append
    append_str = "\n  // Merged from Manager/Driver\n"
    for key, value in new_keys:
        append_str += f"  static const String {key} = '{value}';\n"

    # Insert before the last closing brace
    last_brace_index = global_content.rfind('}')
    if last_brace_index != -1:
        updated_content = global_content[:last_brace_index] + append_str + global_content[last_brace_index:]
        with open(global_path, 'w', encoding='utf-8') as f:
            f.write(updated_content)
        print(f"Successfully added {len(new_keys)} keys to TrKeys.")
    else:
        print("Could not find closing brace in TrKeys.dart")

if __name__ == "__main__":
    merge_tr_keys()
