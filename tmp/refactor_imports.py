import os

replacements = {
    "package:rokctapp/infrastructure/services/utils/manager/local_storage.dart": "package:rokctapp/infrastructure/services/utils/local_storage.dart",
    "package:rokctapp/infrastructure/services/utils/driver/local_storage.dart": "package:rokctapp/infrastructure/services/utils/local_storage.dart",
    "package:rokctapp/infrastructure/services/constants/manager/tr_keys.dart": "package:rokctapp/infrastructure/services/constants/tr_keys.dart",
    "package:rokctapp/infrastructure/services/constants/driver/tr_keys.dart": "package:rokctapp/infrastructure/services/constants/tr_keys.dart",
    "package:rokctapp/infrastructure/services/constants/manager/storage_keys.dart": "package:rokctapp/infrastructure/services/constants/storage_keys.dart",
    "package:rokctapp/infrastructure/services/constants/manager/enums.dart": "package:rokctapp/infrastructure/services/constants/enums.dart",
}

def refactor_imports(root_dir):
    count = 0
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".dart"):
                path = os.path.join(root, file)
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
                
                new_content = content
                for old, new in replacements.items():
                    new_content = new_content.replace(old, new)
                
                if new_content != content:
                    with open(path, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    print(f"Refactored: {path}")
                    count += 1
    print(f"Total files refactored: {count}")

if __name__ == "__main__":
    lib_dir = r"c:\Users\sinya\Desktop\RokctAI\Frappenize\Spazafy\lib"
    refactor_imports(lib_dir)
