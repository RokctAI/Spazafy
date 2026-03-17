#!/usr/bin/env python3
"""
fix_imports.py — The ultimate rokctapp import unification script.

Resolves the remaining broken links by normalizing paths to the new unified structure.
"""

import os
import re
import sys
import argparse

DRY_RUN = False

# ─── Import path replacements (order matters — more specific first) ───────────

IMPORT_REPLACEMENTS = [
    # ── Repo & Infrastructure Fixes ──
    ("infrastructure/repositories/offline/offline_products_repository.dart", "infrastructure/repositories/products_repository.dart"),
    ("infrastructure/repositories/customer/", "infrastructure/repositories/"),
    ("infrastructure/repositories/manager/", "infrastructure/repositories/"),
    ("infrastructure/repositories/driver/", "infrastructure/repositories/"),
    
    # ── Typo Fixes & Component Realignment ──
    ("package:rokctapp/presentation/component/", "package:rokctapp/presentation/components/"),
    ("/component/components.dart", "/components/components.dart"),
    ("/component/scan_prompt.dart", "/components/scan_prompt.dart"),
    ("/component/loading.dart", "/components/loading.dart"),
    ("/component/helper/", "/components/helper/"),
    ("/component/loading/", "/components/loading/"),
    ("/component/list_items/", "/components/list_items/"),
    ("/component/text_fields/", "/components/text_fields/"),
    ("tab_bars/custom_tab_bar.dart", "package:rokctapp/presentation/components/tab_bars/custom_tab_bar.dart"),
    ("package:rokctapp/presentation/theme/app_assets.dart", "package:rokctapp/infrastructure/services/app_assets.dart"), # Correction: found in infrastructure
    ("package:rokctapp/presentation/app_assets.dart", "package:rokctapp/infrastructure/services/app_assets.dart"),
    ("package:rokctapp/presentation/pages/intro/intro_page.dart", "package:rokctapp/presentation/pages/intro/customer/intro_page.dart"),

    # ── Specific Provider Mappings (Flattened and Grouped) ──
    ("application/delivery/delivery_provider.dart", "application/delivery/unified_delivery_provider.dart"),
    ("application/shop_order/", "application/shops/shop_order/"),
    ("application/shop/", "application/shops/"),
    ("application/shopname/", "application/shops/shopname/"),
    ("application/filter/", "application/foods/filter/"),
    ("application/orders_list/", "application/order/orders_list/"),
    ("application/intro/", "application/intro/customer/"),
    ("application/order/customer/", "application/order/"),
    
    # ── Infrastructure/Services Fixes ──
    ("infrastructure/services/utils/tr_keys.dart", "infrastructure/services/constants/tr_keys.dart"),
    ("infrastructure/services/tr_keys.dart", "infrastructure/services/constants/tr_keys.dart"),
    ("infrastructure/services/utils/app_assets.dart", "infrastructure/services/app_assets.dart"),
    ("infrastructure/services/utils/app_constants.dart", "app_constants.dart"),
    ("infrastructure/services/app_constants.dart", "app_constants.dart"),
    ("package:rokctapp/infrastructure/services/utils/app_constants.dart", "package:rokctapp/app_constants.dart"),
    ("infrastructure/services/manager/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/driver/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/customer/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/services.dart", "infrastructure/services/utils/services.dart"),
    
    # ── Domain/Interface Renames ──
    ("domain/interface/payment_facade.dart", "domain/interface/payments.dart"),
    ("domain/interface/subscription_facade.dart", "domain/interface/subscriptions.dart"),

    # ── Style/Theme Realignment ──
    ("package:rokctapp/presentation/styles/style.dart", "package:rokctapp/presentation/theme/app_style.dart"),
    ("package:rokctapp/presentation/styles/", "package:rokctapp/presentation/theme/"),
    ("package:rokctapp/presentation/pages/home/shimmer/", "package:rokctapp/presentation/components/loading/"),

    # ── Legacy Namespace Fixes ──
    ("package:foodyman/", "package:rokctapp/"),
    ("package:venderfoodyman/", "package:rokctapp/"),
]

# ─── Relative Fixes Regex ────────────────────────────────────────────────────

RELATIVE_FIXES = [
    # Application State Normalization
    (r"import\s+['\"](\.\./)+state/profile_edit_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    (r"import\s+['\"](\.\./)+state/profile_image_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    (r"import\s+['\"](\.\./)+state/profile_settings_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    
    # Normalize common broken relative paths to package paths
    (r"import\s+['\"](\.\./)+app_constants\.dart['\"]", "import 'package:rokctapp/app_constants.dart'"),
    (r"import\s+['\"](\.\./)+infrastructure/services/utils/app_constants\.dart['\"]", "import 'package:rokctapp/app_constants.dart'"),
    (r"import\s+['\"](\.\./)+infrastructure/services/utils/tr_keys\.dart['\"]", "import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart'"),
    (r"import\s+['\"](\.\./)+infrastructure/services/constants/tr_keys\.dart['\"]", "import 'package:rokctapp/infrastructure/services/constants/tr_keys.dart'"),
    
    # Broad Package-ification for known top-level dirs
    (r"import\s+['\"](\.\./)+infrastructure/", "import 'package:rokctapp/infrastructure/"),
    (r"import\s+['\"](\.\./)+application/", "import 'package:rokctapp/application/"),
    (r"import\s+['\"](\.\./)+presentation/", "import 'package:rokctapp/presentation/"),
    (r"import\s+['\"](\.\./)+domain/", "import 'package:rokctapp/domain/"),
    
    # Specific missing depth cases
    (r"import\s+['\"](\.\./)+presentation/theme/theme\.dart['\"]", "import 'package:rokctapp/presentation/theme/theme.dart'"),
    (r"import\s+['\"](\.\./)+presentation/theme/app_style\.dart['\"]", "import 'package:rokctapp/presentation/theme/app_style.dart'"),
]

def fix_file(path: str) -> bool:
    """Returns True if the file was modified."""
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
    except Exception:
        return False

    modified = False
    new_lines = []

    for line in lines:
        new_line = line
        
        # Only process import lines
        if line.strip().startswith("import "):
            replaced = False
            
            # 1. Try Regex Relative Fixes first (more specific)
            for pattern, replacement in RELATIVE_FIXES:
                temp_line = re.sub(pattern, replacement, new_line)
                if temp_line != new_line:
                    new_line = temp_line
                    replaced = True
                    break # Stop after first major regex match
            
            # 2. Try Exact String Replacements if not already replaced by regex
            if not replaced:
                for old, new in IMPORT_REPLACEMENTS:
                    # Guard: If the line already has the correct "new" path, skip
                    if new.startswith("package:rokctapp/") and new in line:
                        continue
                    
                    if old in new_line:
                        new_line = new_line.replace(old, new)
                        replaced = True
                        break # IMPORTANT: Prevent chain-reaction replacements

        if new_line != line:
            modified = True
        new_lines.append(new_line)

    if not modified:
        return False

    if DRY_RUN:
        print(f"  [DRY] Would update: {path}")
        return True

    with open(path, "w", encoding="utf-8") as f:
        f.writelines(new_lines)
    return True


def main():
    global DRY_RUN
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", help="Preview only")
    args = parser.parse_args()
    DRY_RUN = args.dry_run

    root = os.path.dirname(__file__) or "."
    changed = 0
    scanned = 0

    for dirpath, dirnames, filenames in os.walk(root):
        # Skip hidden and non-source dirs
        dirnames[:] = [d for d in dirnames if not d.startswith(".") and d not in ["build", "node_modules", "android", "ios", "web"]]
        for filename in filenames:
            if not filename.endswith(".dart"):
                continue
            filepath = os.path.join(dirpath, filename)
            scanned += 1
            if fix_file(filepath):
                changed += 1
                if not DRY_RUN:
                    print(f"  Fixed: {os.path.relpath(filepath, root)}")

    mode = "DRY RUN" if DRY_RUN else "DONE"
    print(f"\n[{mode}] Scanned {scanned} files, fixed {changed}.")


if __name__ == "__main__":
    main()
