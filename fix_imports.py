#!/usr/bin/env python3
"""
fix_imports.py — Spazafy import unification script.

Replaces all broken `package:driver/...`, `package:manager/...`,
old relative paths, and legacy venderfoodyman subpaths with the
correct unified `package:venderfoodyman/...` equivalents.

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
    # ── driver package → venderfoodyman ──────────────────────────────────────
    ("package:driver/infrastructure/services/driver/app_connectivity.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart"),
    ("package:driver/infrastructure/services/driver/app_helpers.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_helpers.dart"),
    ("package:driver/infrastructure/services/driver/tr_keys.dart",
     "package:venderfoodyman/infrastructure/services/utils/tr_keys.dart"),
    ("package:driver/infrastructure/services/driver/local_storage.dart",
     "package:venderfoodyman/infrastructure/services/utils/local_storage.dart"),
    ("package:driver/infrastructure/services/driver/services.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_helpers.dart"),
    ("package:driver/infrastructure/services/driver/loading.dart",
     "package:venderfoodyman/presentation/components/customer/loading.dart"),
    ("package:driver/domain/interface/driver/orders.dart",
     "package:venderfoodyman/domain/interface/orders.dart"),
    ("package:driver/domain/di/customer/dependency_manager.dart",
     "package:venderfoodyman/domain/di/dependency_manager.dart"),
    ("package:driver/domain/di/dependency_manager.dart",
     "package:venderfoodyman/domain/di/dependency_manager.dart"),
    ("package:driver/presentation/theme/driver/app_style.dart",
     "package:venderfoodyman/presentation/theme/customer/app_style.dart"),
    ("package:driver/presentation/theme/driver/app_assets.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_assets.dart"),
    ("package:driver/application/providers/driver/providers.dart",
     "package:venderfoodyman/application/order/all_order/order_provider.dart"),
    ("package:driver/presentation/components/driver/loading.dart",
     "package:venderfoodyman/presentation/components/customer/loading.dart"),
    ("package:driver/presentation/components/driver/components.dart",
     "package:venderfoodyman/presentation/components/customer/components.dart"),
    ("package:driver/infrastructure/models/models.dart",
     "package:venderfoodyman/infrastructure/models/customer/models.dart"),
    ("package:driver/application/order/all_order/order_provider.dart",
     "package:venderfoodyman/application/order/all_order/order_provider.dart"),
    ("package:driver/application/order/canceled_order/canceled_order_state.dart",
     "package:venderfoodyman/application/order/canceled_order/canceled_order_state.dart"),
    ("package:driver/application/order/delivered_order/delivered_order_state.dart",
     "package:venderfoodyman/application/order/delivered_order/delivered_order_state.dart"),
    ("package:driver/application/", "package:venderfoodyman/application/"),
    # Catch-all remaining driver imports
    ("package:driver/", "package:venderfoodyman/"),

    # ── manager package → venderfoodyman ─────────────────────────────────────
    ("package:manager/infrastructure/services/manager/services.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_helpers.dart"),
    ("package:manager/domain/di/manager/dependency_manager.dart",
     "package:venderfoodyman/domain/di/dependency_manager.dart"),
    ("package:manager/presentation/theme/manager/app_style.dart",
     "package:venderfoodyman/presentation/theme/customer/app_style.dart"),
    # Catch-all remaining manager imports
    ("package:manager/", "package:venderfoodyman/"),

    # ── old venderfoodyman customer subpaths → unified paths ─────────────────
    ("package:venderfoodyman/infrastructure/services/customer/app_connectivity.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart"),
    ("package:venderfoodyman/infrastructure/services/customer/app_helpers.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_helpers.dart"),
    ("package:venderfoodyman/infrastructure/services/customer/local_storage.dart",
     "package:venderfoodyman/infrastructure/services/utils/local_storage.dart"),
    ("package:venderfoodyman/infrastructure/services/customer/tr_keys.dart",
     "package:venderfoodyman/infrastructure/services/utils/tr_keys.dart"),
    ("package:venderfoodyman/infrastructure/services/customer/marker_image_cropper.dart",
     "package:venderfoodyman/infrastructure/services/utils/marker_image_cropper.dart"),
    ("package:venderfoodyman/domain/interface/customer/orders.dart",
     "package:venderfoodyman/domain/interface/orders.dart"),
    ("package:venderfoodyman/domain/interface/customer/shops.dart",
     "package:venderfoodyman/domain/interface/shops.dart"),
    ("package:venderfoodyman/domain/interface/customer/banners.dart",
     "package:venderfoodyman/domain/interface/banners.dart"),
    ("package:venderfoodyman/domain/interface/customer/categories.dart",
     "package:venderfoodyman/domain/interface/categories.dart"),
    ("package:venderfoodyman/domain/interface/customer/products.dart",
     "package:venderfoodyman/domain/interface/products.dart"),
    ("package:venderfoodyman/domain/interface/customer/auth.dart",
     "package:venderfoodyman/domain/interface/auth.dart"),
    ("package:venderfoodyman/domain/interface/customer/user.dart",
     "package:venderfoodyman/domain/interface/user.dart"),
    ("package:venderfoodyman/domain/interface/customer/cart.dart",
     "package:venderfoodyman/domain/interface/cart.dart"),
    ("package:venderfoodyman/domain/interface/customer/payments.dart",
     "package:venderfoodyman/domain/interface/payments.dart"),
    ("package:venderfoodyman/domain/interface/customer/brands.dart",
     "package:venderfoodyman/domain/interface/brands.dart"),
    ("package:venderfoodyman/domain/di/customer/dependency_manager.dart",
     "package:venderfoodyman/domain/di/dependency_manager.dart"),

    # ── old manager service barrel → broken reference ─────────────────────────
    ("package:venderfoodyman/infrastructure/services/manager/services.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_helpers.dart"),
    ("package:venderfoodyman/presentation/components/manager/components.dart",
     "package:venderfoodyman/presentation/components/customer/components.dart"),

    # ── Router Merger (Customer/Driver/Manager → Unified) ──────────────────
    ("package:venderfoodyman/presentation/routes/customer/app_router.dart",
     "package:venderfoodyman/presentation/routes/app_router.dart"),
    ("package:venderfoodyman/presentation/routes/driver/app_router.dart",
     "package:venderfoodyman/presentation/routes/app_router.dart"),
    ("package:venderfoodyman/presentation/routes/manager/app_router.dart",
     "package:venderfoodyman/presentation/routes/app_router.dart"),
    ("package:venderfoodyman/presentation/routes/customer/app_router.gr.dart",
     "package:venderfoodyman/presentation/routes/app_router.gr.dart"),
    ("package:venderfoodyman/presentation/routes/driver/app_router.gr.dart",
     "package:venderfoodyman/presentation/routes/app_router.gr.dart"),
    ("package:venderfoodyman/presentation/routes/manager/app_router.gr.dart",
     "package:venderfoodyman/presentation/routes/app_router.gr.dart"),

    # ── Infrastructure & Utils Unification ──────────────────────────────────
    ("package:venderfoodyman/utils/customer/app_initializer_widget.dart",
     "package:venderfoodyman/utils/app_initializer_widget.dart"),
    ("package:venderfoodyman/infrastructure/services/customer/app_database.dart",
     "package:venderfoodyman/infrastructure/services/utils/app_database.dart"),
    ("package:venderfoodyman/infrastructure/models/customer/data/address_information.dart",
     "package:venderfoodyman/infrastructure/models/data/address_information.dart"),
    ("package:venderfoodyman/infrastructure/models/customer/data/address_old_data.dart",
     "package:venderfoodyman/infrastructure/models/data/address_old_data.dart"),
    ("package:venderfoodyman/infrastructure/models/customer/models.dart",
     "package:venderfoodyman/infrastructure/models/models.dart"),
    ("package:venderfoodyman/infrastructure/models/driver/models.dart",
     "package:venderfoodyman/infrastructure/models/models.dart"),
    ("package:venderfoodyman/infrastructure/models/manager/models.dart",
     "package:venderfoodyman/infrastructure/models/models.dart"),
    ("package:venderfoodyman/infrastructure/services/utils/storage_keys.dart",
     "package:venderfoodyman/infrastructure/services/constants/storage_keys.dart"),

    # ── Presentation Theme Unification ──────────────────────────────────────
    ("package:venderfoodyman/presentation/theme/customer/",
     "package:venderfoodyman/presentation/theme/customer/"), # Keep it for now but maybe map to unified later
    ("presentation/theme/theme.dart",
     "package:venderfoodyman/presentation/theme/customer/theme.dart"),

    # ── Presentation Page Specific Unification ─────────────────────────────

    # ── Infrastructure Repository Unification ──────────────────────────────────
    ("package:venderfoodyman/infrastructure/repositories/customer/",
     "package:venderfoodyman/infrastructure/repositories/"),
    ("package:venderfoodyman/infrastructure/repositories/driver/",
     "package:venderfoodyman/infrastructure/repositories/"),
    ("package:venderfoodyman/infrastructure/repositories/manager/",
     "package:venderfoodyman/infrastructure/repositories/"),

    # ── Presentation Page Unification ───────────────────────────────────────
    ("package:venderfoodyman/presentation/pages/customer/home/",
     "package:venderfoodyman/presentation/pages/home/"),
    ("package:venderfoodyman/presentation/pages/customer/initial/",
     "package:venderfoodyman/presentation/pages/initial/"),
    ("package:venderfoodyman/presentation/pages/customer/like/",
     "package:venderfoodyman/presentation/pages/like/"),
    ("package:venderfoodyman/presentation/pages/customer/main/",
     "package:venderfoodyman/presentation/pages/main/"),
    ("package:venderfoodyman/presentation/pages/customer/order/",
     "package:venderfoodyman/presentation/pages/order/"),
    ("package:venderfoodyman/presentation/pages/customer/parcel/",
     "package:venderfoodyman/presentation/pages/parcel/"),
    ("package:venderfoodyman/presentation/pages/customer/policy_term/",
     "package:venderfoodyman/presentation/pages/policy_term/"),
    ("package:venderfoodyman/presentation/pages/customer/search/",
     "package:venderfoodyman/presentation/pages/search/"),
    ("package:venderfoodyman/presentation/pages/customer/service/",
     "package:venderfoodyman/presentation/pages/service/"),
    ("package:venderfoodyman/presentation/pages/customer/setting/",
     "package:venderfoodyman/presentation/pages/setting/"),
    ("package:venderfoodyman/presentation/pages/customer/shop/",
     "package:venderfoodyman/presentation/pages/shop/"),
    ("package:venderfoodyman/presentation/pages/customer/view_map/",
     "package:venderfoodyman/presentation/pages/view_map/"),
    ("package:venderfoodyman/presentation/pages/customer/intro/",
     "package:venderfoodyman/presentation/pages/intro/"),
    ("package:venderfoodyman/presentation/pages/customer/profile/wallet_history.dart",
     "package:venderfoodyman/presentation/pages/profile/wallet_history.dart"),
    ("package:venderfoodyman/presentation/pages/customer/auth/",
     "package:venderfoodyman/presentation/pages/auth/customer/"),

    # ── Presentation Page Catch-all Unification ─────────────────────────────
    ("package:venderfoodyman/presentation/pages/customer/",
     "package:venderfoodyman/presentation/pages/"),

    # ── Domain Unification ──────────────────────────────────
    ("package:venderfoodyman/domain/handlers/customer/handlers.dart",
     "package:venderfoodyman/domain/handlers/handlers.dart"),
    ("package:venderfoodyman/domain/interface/customer/address.dart",
     "package:venderfoodyman/domain/interface/address.dart"),
    ("package:venderfoodyman/domain/interface/customer/blogs.dart",
     "package:venderfoodyman/domain/interface/blogs.dart"),
    ("package:venderfoodyman/domain/interface/customer/currencies.dart",
     "package:venderfoodyman/domain/interface/currencies.dart"),
    ("package:venderfoodyman/domain/interface/customer/draw.dart",
     "package:venderfoodyman/domain/interface/draw.dart"),
    ("package:venderfoodyman/domain/interface/customer/cart.dart",
     "package:venderfoodyman/domain/interface/cart.dart"),
    ("package:venderfoodyman/domain/interface/customer/payments.dart",
     "package:venderfoodyman/domain/interface/payments.dart"),
    ("package:venderfoodyman/domain/interface/customer/brands.dart",
     "package:venderfoodyman/domain/interface/brands.dart"),
    ("package:venderfoodyman/domain/interface/customer/banners.dart",
     "package:venderfoodyman/domain/interface/banners.dart"),
    ("package:venderfoodyman/domain/interface/customer/shops.dart",
     "package:venderfoodyman/domain/interface/shops.dart"),
    ("package:venderfoodyman/domain/interface/customer/categories.dart",
     "package:venderfoodyman/domain/interface/categories.dart"),
    ("package:venderfoodyman/domain/interface/customer/products.dart",
     "package:venderfoodyman/domain/interface/products.dart"),
    ("package:venderfoodyman/domain/interface/customer/settings.dart",
     "package:venderfoodyman/domain/interface/settings.dart"),
    ("package:venderfoodyman/domain/interface/customer/user.dart",
     "package:venderfoodyman/domain/interface/user.dart"),
    ("package:venderfoodyman/domain/interface/customer/notification.dart",
     "package:venderfoodyman/domain/interface/notification.dart"),
    ("package:venderfoodyman/domain/interface/customer/orders.dart",
     "package:venderfoodyman/domain/interface/orders.dart"),
    ("package:venderfoodyman/domain/interface/customer/parcel.dart",
     "package:venderfoodyman/domain/interface/parcel.dart"),
    ("package:venderfoodyman/domain/interface/customer/gallery.dart",
     "package:venderfoodyman/domain/interface/gallery.dart"),
    ("package:venderfoodyman/domain/interface/customer/wallet.dart",
     "package:venderfoodyman/domain/interface/wallet.dart"),
    ("package:venderfoodyman/domain/interface/customer/loans.dart",
     "package:venderfoodyman/domain/interface/loans.dart"),
    ("package:venderfoodyman/domain/interface/customer/delivery_points.dart",
     "package:venderfoodyman/domain/interface/delivery_points.dart"),
    ("package:venderfoodyman/domain/interface/customer/table.dart",
     "package:venderfoodyman/domain/interface/table.dart"),
    ("package:venderfoodyman/domain/interface/customer/subscriptions.dart",
     "package:venderfoodyman/domain/interface/subscriptions.dart"),
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
    # Style → AppStyle (driver used Style not AppStyle)
    (r"\bStyle\.inter",             "AppStyle.inter"),
    (r"\bStyle\.greyColor\b",       "AppStyle.greyColor"),
    (r"\bStyle\.primary\b",         "AppStyle.primary"),
    (r"\bStyle\.white\b",           "AppStyle.white"),
    (r"\bStyle\.black\b",           "AppStyle.blackColor"),
]

# Provider renames — applied only in files that import all_order/order_provider
# (to avoid renaming the root customer orderProvider)
PROVIDER_RENAMES_IN_DRIVER_FILES = [
    (r"\borderProvider\b", "driverOrderProvider"),
]

# ─── Relative path fixes (broken relative imports in some files) ──────────────

RELATIVE_FIXES = [
    # Old relative imports to infrastructure/models/data/...
    (r"import '[^']*infrastructure/models/data/order_detail\.dart'",
     "import 'package:venderfoodyman/infrastructure/models/customer/models.dart'"),
    (r"import '[^']*infrastructure/services/app_helpers\.dart'",
     "import 'package:venderfoodyman/infrastructure/services/utils/app_helpers.dart'"),
    (r"import '[^']*infrastructure/services/app_connectivity\.dart'",
     "import 'package:venderfoodyman/infrastructure/services/utils/app_connectivity.dart'"),
    (r"import '[^']*infrastructure/services/local_storage\.dart'",
     "import 'package:venderfoodyman/infrastructure/services/utils/local_storage.dart'"),
]


def fix_file(path: str) -> bool:
    """Returns True if the file was modified."""
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        original = f.read()

    content = original

    # Apply import string replacements
    for old, new in IMPORT_REPLACEMENTS:
        content = content.replace(old, new)

    # Apply relative path regex fixes
    for pattern, replacement in RELATIVE_FIXES:
        content = re.sub(pattern, replacement, content)

    # Apply class renames
    for pattern, replacement in CLASS_RENAMES:
        content = re.sub(pattern, replacement, content)

    # Apply driver provider rename only in files that import all_order/order_provider
    if "all_order/order_provider" in content:
        for pattern, replacement in PROVIDER_RENAMES_IN_DRIVER_FILES:
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
    parser.add_argument("--dry-run", action="store_true", help="Preview only, don't write files")
    args = parser.parse_args()
    DRY_RUN = args.dry_run

    root = os.path.join(os.path.dirname(__file__), "lib")
    if not os.path.isdir(root):
        print(f"ERROR: Could not find lib/ at {root}")
        sys.exit(1)

    changed = 0
    scanned = 0

    for dirpath, _, filenames in os.walk(root):
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
