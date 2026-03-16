#!/usr/bin/env python3
"""
fix_imports.py — Spazafy import unification script.

Replaces all broken `package:driver/...`, `package:manager/...`,
old relative paths, and legacy venderfoodyman/foodyman subpaths 
with the correct unified `package:rokctapp/...` equivalents.

Also fixes class name renames (e.g. OrdersRepositoryFacade → OrdersFacade).

Usage:
    python fix_imports.py [--dry-run]
"""

import os
import re
import sys
import argparse

DRY_RUN = False

# ─── Import path replacements (order matters — more specific first) ───────────

IMPORT_REPLACEMENTS = [
    # ── legacy package names → rokctapp ──────────────────────────────────
    ("package:foodyman/", "package:rokctapp/"),
    ("package:venderfoodyman/", "package:rokctapp/"),
    ("package:driver/", "package:rokctapp/"),
    ("package:manager/", "package:rokctapp/"),

    # ── Specific heavy-lifting replacements (Legacy internal sub-paths) ──
    ("package:rokctapp/infrastructure/services/driver/", "package:rokctapp/infrastructure/services/utils/"),
    ("package:rokctapp/infrastructure/services/customer/", "package:rokctapp/infrastructure/services/utils/"),
    ("package:rokctapp/presentation/components/driver/", "package:rokctapp/presentation/components/"),
    ("package:rokctapp/presentation/components/manager/", "package:rokctapp/presentation/components/"),
    ("package:rokctapp/presentation/components/customer/", "package:rokctapp/presentation/components/"),
    ("package:rokctapp/presentation/pages/customer/", "package:rokctapp/presentation/pages/"),
    ("package:rokctapp/presentation/theme/customer/", "package:rokctapp/presentation/theme/"),
    ("package:rokctapp/domain/interface/customer/", "package:rokctapp/domain/interface/"),
    ("package:rokctapp/infrastructure/repositories/customer/", "package:rokctapp/infrastructure/repositories/"),
]

# ─── Class/type name renames ──────────────────────────────────────────────────

CLASS_RENAMES = [
    (r"\bOrdersRepositoryFacade\b", "OrdersFacade"),
    (r"\bShopsRepositoryFacade\b",  "ShopsFacade"),
    (r"\bCartRepositoryFacade\b",   "CartFacade"),
    (r"\bPaymentsRepositoryFacade\b", "PaymentsFacade"),
    (r"\bBannersRepositoryFacade\b", "BannersFacade"),
    (r"\bCategoriesRepositoryFacade\b", "CategoriesFacade"),
    (r"\bProductsRepositoryFacade\b", "ProductsFacade"),
    (r"\bUserRepositoryFacade\b",   "UserFacade"),
    (r"\bAuthRepositoryFacade\b",   "AuthFacade"),
    (r"\bDrawRepositoryFacade\b",   "DrawFacade"),
    (r"\bOrdersDetailData\b",       "OrderDetailData"),
    # Style → AppStyle
    (r"\bStyle\.inter",             "AppStyle.inter"),
    (r"\bStyle\.greyColor\b",       "AppStyle.greyColor"),
    (r"\bStyle\.primary\b",         "AppStyle.primary"),
    (r"\bStyle\.white\b",           "AppStyle.white"),
    (r"\bStyle\.black\b",           "AppStyle.blackColor"),
]

# ─── Relative path fixes & Double Package Clean-up ────────────────────────────

RELATIVE_FIXES = [
    # Fix double package issues caused by previous iterations
    (r"package:rokctapp/package:rokctapp/", "package:rokctapp/"),
    (r"package:rokctapp/package:venderfoodyman/", "package:rokctapp/"),
    (r"package:venderfoodyman/package:rokctapp/", "package:rokctapp/"),
    
    # Clean up standard theme.dart relative/broken imports
    (r"import\s+'presentation/theme/theme\.dart'", "import 'package:rokctapp/presentation/theme/theme.dart'"),
]


def fix_file(path: str) -> bool:
    """Returns True if the file was modified."""
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        original = f.read()

    content = original

    # Apply import string replacements
    for old, new in IMPORT_REPLACEMENTS:
        content = content.replace(old, new)

    # Apply double-path and relative fixes
    for pattern, replacement in RELATIVE_FIXES:
        content = re.sub(pattern, replacement, content)

    # Apply class renames
    for pattern, replacement in CLASS_RENAMES:
        content = re.sub(pattern, replacement, content)

    # Provider renames logic (Driver specific)
    if "all_order/order_provider" in content:
        content = content.replace("orderProvider", "driverOrderProvider")

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
