#!/usr/bin/env python3
import os
import re
import sys

def verify_imports():
    root_dir = os.path.abspath(os.path.dirname(__file__)) or os.getcwd()
    lib_dir = os.path.join(root_dir, 'lib')
    
    if not os.path.exists(lib_dir):
        print(f"Error: 'lib' directory not found in {root_dir}")
        sys.exit(1)

    broken_links = []
    scanned_files = 0
    total_imports = 0

    # Regex to find imports: import '...'; or import "...";
    import_pattern = re.compile(r'import\s+[\'"]([^\'"]+)[\'"]')

    for dirpath, dirnames, filenames in os.walk(lib_dir):
        # Skip hidden and non-source dirs
        dirnames[:] = [d for d in dirnames if not d.startswith('.') and d not in ['build', 'node_modules', 'android', 'ios', 'web']]
        
        for filename in filenames:
            if not filename.endswith('.dart'):
                continue
            
            scanned_files += 1
            file_path = os.path.join(dirpath, filename)
            
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
                
            for line_num, line in enumerate(lines, 1):
                match = import_pattern.search(line)
                if not match:
                    continue
                
                target = match.group(1)
                total_imports += 1
                
                # Check if it's a project internal package import
                if target.startswith('package:rokctapp/'):
                    relative_target = target.replace('package:rokctapp/', '')
                    target_abs_path = os.path.join(lib_dir, relative_target.replace('/', os.sep))
                
                # Check if it's a relative import (doesn't start with package: or dart:)
                elif not target.startswith('package:') and not target.startswith('dart:'):
                    target_abs_path = os.path.abspath(os.path.join(dirpath, target.replace('/', os.sep)))
                
                else:
                    # External package or dart SDK, skip validation
                    continue
                
                # Skip validation for CI-generated files
                if any(target.endswith(ext) for ext in ['.freezed.dart', '.g.dart', '.gr.dart']):
                    continue

                # Verify existence
                if not os.path.exists(target_abs_path):
                    broken_links.append({
                        'file': os.path.relpath(file_path, root_dir),
                        'line': line_num,
                        'import': target,
                        'resolved_path': target_abs_path
                    })

    # Report results
    report = []
    report.append("-" * 30)
    report.append(f"IMPORT VERIFICATION REPORT")
    report.append("-" * 30)
    report.append(f"Scanned Files: {scanned_files}")
    report.append(f"Total Internal Imports: {total_imports}")
    report.append("-" * 30)

    if not broken_links:
        report.append("SUCCESS: 0 broken links found! The project is build-ready.")
        success = True
    else:
        report.append(f"FAILURE: Found {len(broken_links)} broken links:")
        for idx, link in enumerate(broken_links, 1):
            report.append(f"{idx}. {link['file']}:{link['line']}")
            report.append(f"   Broken Import: {link['import']}")
        success = False

    report_text = "\n".join(report)
    print(report_text)
    
    with open(os.path.join(root_dir, 'import_report.txt'), 'w', encoding='utf-8') as f:
        f.write(report_text)
        
    return success

if __name__ == "__main__":
    success = verify_imports()
    if not success:
        sys.exit(1)
