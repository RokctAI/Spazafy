# 🔍 Spazafy Codebase Offline Capability Audit Report

This report evaluates Spazafy's codebase against its offline-first architectural goals by scanning the code for implementation flaws and missing logic.

## 1. Widespread UI-Layer Connectivity Blocking
Instead of delegating offline fallback to the data layer (`Drift`), many application notifiers manually check `AppConnectivity.connectivity()` and immediately fail if offline, entirely blocking offline access to previously fetched or cached data.

**Files that block execution without checking `AppDatabase` or `LocalStorage`:**
- `lib/application/payment_methods/payment_notifier.dart`
- `lib/application/notification/notification_notifier.dart`
- `lib/application/promo_code/promo_code_notifier.dart`
- `lib/application/help/help_notifier.dart`
- `lib/application/product/product_notifier.dart`
- `lib/application/orders_list/orders_list_notifier.dart`
- `lib/application/filter/filter_notifier.dart`
- `lib/application/setting/setting_notifier.dart`
- `lib/application/parcels_list/parcel_list_notifier.dart`
- `lib/application/auth/reset_password/reset_password_notifier.dart`

**Risk:** Users cannot view orders, products, notifications, or access app settings while offline because the UI layer explicitly prevents it, breaking the POS and manager offline flows.

## 2. API Requests Bypassing Interceptors & Sync Layer
The app utilizes the `http` package for specific functionality instead of the designated `Dio` client (`HttpService`). Direct `http` calls do not trigger `FrappeResponseInterceptor` or `LogInterceptor` and cannot be natively wired to the offline `SyncQueueTable`.

**Files using direct `http.get` / `http.post`:**
- `lib/infrastructure/services/utils/marker_image_cropper.dart`
- `lib/presentation/pages/profile/profile_page.dart`
- `lib/utils/app_usage_service.dart`
- `lib/utils/app_initializer.dart`
- `lib/application/shop/shop_notifier.dart`
- `lib/application/about/about_provider.dart`
- `lib/application/product/product_notifier.dart`
- `lib/application/shop_order/shop_order_notifier.dart`
- `lib/application/shopname/shop_name_provider.dart`
- `lib/application/delivery/delivery_provider.dart`

**Risk:** Actions triggered by these files (like generating product share links or cropping marker images) will crash silently or throw unhandled socket exceptions instead of gracefully falling back.

## 3. Empty Sync Queue & Event Queue Sinks
The architecture designates a `SyncQueueTable` for transaction retries and an `EventQueueTable` for AI telemetry, but an audit shows they are fundamentally unused by the application.
- The method `insertSyncRequest` inside `BackgroundSyncService` and `AppDatabase` is **never called** by any repository (`CartRepository`, `OrderRepository`, etc.) when network errors (`NetworkExceptions`) occur.
- No files within `lib/application/` or `lib/presentation/` write directly to the `events` table via `putItem`.

**Risk:** Data entered while offline is completely lost. Carts, pending orders, and user telemetry are not queued for upload. The "Sync Service" exists in the codebase but receives no inputs.

## 4. App Initializer Offline Trap
The application boot sequence inside `AppInitializer` heavily relies on fetching `paas.api.remote_config.get_remote_config` and `/api/v1/rest/status` to determine the environment state.
**Risk:** If the device loses connection before launch, the `AppInitializer` lacks robust local-only pathways, preventing the application from safely migrating into its core offline mode.

## Summary
The codebase reveals a significant gap between the architectural intent and current implementation. The application layer aggressively checks for online connectivity and aborts operations instead of querying the local SQLite (`Drift`) database. Furthermore, write operations (orders, carts, events) fail instantly offline because no repositories are currently wired to enqueue failed `Dio` requests into the `SyncQueueTable`. Migrating data fetching logic into the repositories and removing `AppConnectivity` guards from Notifiers should be the first priority.
