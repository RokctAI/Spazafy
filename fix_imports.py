#!/usr/bin/env python3
"""
fix_imports.py — The ultimate rokctapp import unification script.

Resolves the remaining 235 broken links.
Handles:
1. Nested driver component paths.
2. Specific utility relocations (payfast/services).
3. Relative path normalization for unified application layers.
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
    ("package:rokctapp/presentation/pages/home/widgets/foods_page.dart", "package:rokctapp/presentation/pages/home/driver/widgets/foods_page.dart"),

    # ── Style/Theme Realignment ──
    ("package:rokctapp/presentation/styles/style.dart", "package:rokctapp/presentation/theme/app_style.dart"),
    ("package:rokctapp/presentation/styles/", "package:rokctapp/presentation/theme/"),
    
    # ── Application Layer Flattening ──
    ("application/order/customer/", "application/order/"),
    ("application/profile/edit_profile_provider.dart", "application/profile/edit_profile/edit_profile_provider.dart"),
    ("application/profile/notifier/profile_edit_notifier.dart", "application/profile/profile_edit_notifier.dart"),
    ("application/profile/notifier/profile_image_notifier.dart", "application/profile/profile_image_notifier.dart"),
    ("application/profile/provider/profile_edit_provider.dart", "application/profile/profile_provider.dart"),
    ("application/profile/provider/profile_image_provider.dart", "application/profile/profile_provider.dart"),
    ("application/profile/state/profile_edit_state.dart", "application/profile/profile_state.dart"),
    ("application/profile/state/profile_image_state.dart", "application/profile/profile_state.dart"),
    ("application/profile/provider/profile_settings_provider.dart", "application/profile/profile_settings_notifier.dart"),
    
    # ── Domain/Interface Renames ──
    ("domain/interface/payment_facade.dart", "domain/interface/payments.dart"),
    ("domain/interface/subscription_facade.dart", "domain/interface/subscriptions.dart"),
    
    # ── Infrastructure/Services Fixes ──
    ("infrastructure/services/manager/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/driver/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/customer/services.dart", "infrastructure/services/utils/services.dart"),
    ("infrastructure/services/tr_keys.dart", "infrastructure/services/utils/tr_keys.dart"),
    ("infrastructure/services/app_constants.dart", "infrastructure/services/utils/app_constants.dart"),
    
    # ── Utility & Misc Fixes ──
    ("'signature_service.dart'", "'services/signature_service.dart'"),
    ("\"signature_service.dart\"", "\"services/signature_service.dart\""),
    ("'printer_device.dart'", "'../models/printer_device.dart'"),
    ("\"printer_device.dart\"", "\"../models/printer_device.dart\""),
    ("package:rokctapp/presentation/pages/intro/intro_page.dart", "package:rokctapp/presentation/pages/intro/intro_page.dart"), 

    ("package:foodyman/", "package:rokctapp/"),
    ("package:venderfoodyman/", "package:rokctapp/"),
]

# ─── Relative Fixes Regex ────────────────────────────────────────────────────

RELATIVE_FIXES = [
    # Application State Normalization
    (r"import\s+['\"](\.\./)+state/profile_edit_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    (r"import\s+['\"](\.\./)+state/profile_image_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    (r"import\s+['\"](\.\./)+state/profile_settings_state\.dart['\"]", "import 'package:rokctapp/application/profile/profile_state.dart'"),
    (r"import\s+['\"](\.\./)+app_constants\.dart['\"]", "import 'package:rokctapp/infrastructure/services/utils/app_constants.dart'"),
    
    # General package-ify
    (r"import\s+['\"](\.\./)+domain/di/dependency_manager\.dart['\"]", "import 'package:rokctapp/domain/di/dependency_manager.dart'"),
    (r"import\s+['\"](\.\./)+infrastructure/models/models\.dart['\"]", "import 'package:rokctapp/infrastructure/models/models.dart'"),
    (r"import\s+['\"](\.\./)+presentation/theme/theme\.dart['\"]", "import 'package:rokctapp/presentation/theme/theme.dart'"),
    (r"import\s+['\"](\.\./)+presentation/theme/app_style\.dart['\"]", "import 'package:rokctapp/presentation/theme/app_style.dart'"),
    (r"import\s+['\"](\.\./)+application/providers/providers\.dart['\"]", "import 'package:rokctapp/application/providers/providers.dart'"),
    (r"import\s+['\"](\.\./)+infrastructure/services/utils/tr_keys\.dart['\"]", "import 'package:rokctapp/infrastructure/services/utils/tr_keys.dart'"),
]

def fix_file(path: str) -> bool:
    """Returns True if the file was modified."""
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        original = f.read()

    content = original

    # Apply import string replacements
    for old, new in IMPORT_REPLACEMENTS:
        content = content.replace(old, new)

    # Apply regex relative fixes
    for pattern, replacement in RELATIVE_FIXES:
        content = re.sub(pattern, replacement, content)

    if content == original:
        return False

    if DRY_RUN:
        print(f"  [DRY] Would update: {path}")
        return True

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
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
