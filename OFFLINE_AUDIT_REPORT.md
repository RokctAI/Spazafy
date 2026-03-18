# 🔍 Spazafy Offline Capability Audit Report

This report outlines the potential failure points and areas of improvement for Spazafy's offline capabilities.

## 1. Direct `http` API Calls
The app uses the `http` package for some requests instead of the centralized `Dio` client (`HttpService`). Direct `http` calls bypass the background sync queue, idempotency headers, and standard offline error handling. This means if the device is offline, these requests will fail silently or throw unhandled socket exceptions instead of being queued for later.

**Files with direct `http` usage:**
- `lib/application/shop_order/shop_order_notifier.dart`
- `lib/presentation/pages/profile/profile_page.dart`
- `lib/application/about/about_provider.dart`
- `lib/utils/app_initializer.dart`
- `lib/application/delivery/delivery_provider.dart`
- `lib/application/shop/shop_notifier.dart`
- `lib/infrastructure/services/utils/marker_image_cropper.dart`
- `lib/application/product/product_notifier.dart`
- `lib/utils/app_usage_service.dart`
- `lib/application/shopname/shop_name_provider.dart`

**Risk:** Features relying on these calls (e.g., fetching about page, POI data, generating share links, shop names, delivery data) will fail abruptly when offline, and actions like sharing products may crash or fail to generate a link.

## 2. Lack of Local Storage Fallback in Riverpod Notifiers
Many `StateNotifier` classes check `AppConnectivity.connectivity()` before making API calls. If offline, they show a 'Check your network connection' snackbar and halt execution, instead of attempting to read from the local `Drift` database as a fallback.

**Example:** `ProductNotifier.getProductDetailsById`

```dart
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      // ... fetch from API
    } else {
      // ... show snackbar and fail
    }
```

**Risk:** Even if data is available in the local database, the user cannot access it because the application layer forces an online check before falling back to local data, violating the 'Offline-First' architectural principle.

## 3. Cart and Order Submissions Not Queued
In `ProductNotifier.createCart`, if the device is offline, it shows a 'No connection' snackbar instead of queuing the cart addition in the `SyncQueueTable` for background synchronization.

**Risk:** Users cannot build carts or prepare orders while offline, completely breaking the offline POS and manager flows.

## 4. Splash Screen Initialization Logic
The `SplashPage` and `AppInitializer` rely heavily on API checks (`/api/v1/rest/status`, `/api/method/paas.api.remote_config.get_remote_config`) during startup.

**Risk:** If the app is launched while offline, it might get stuck on the splash screen or fail to initialize essential data, preventing the user from accessing the local offline POS functionality.

## 5. Image Caching and Network Images
The app uses `cached_network_image`, which is good, but `marker_image_cropper.dart` uses `http.get` directly to fetch images for markers.

**Risk:** Maps and markers will fail to load images when offline, potentially crashing the map view or displaying broken UI.

## 6. Sync Queue Underutilization
The `SyncQueueTable` in Drift is designed to handle offline data syncing, but a quick grep reveals its usage might be limited or missing in key transaction repositories.

**Risk:** Orders, carts, and events created offline may not be properly inserted into the sync queue for later transmission to the backend, resulting in data loss or failure to fulfill orders when connectivity is restored.

## 7. Offline Payment Flows (Shop2Shop QR)
According to the architecture document, Shop2Shop QR payments are the primary payment method. Generating the QR code requires the order total.
**Risk:** If the payment confirmation flow or QR generation requires an immediate online callback to the backend to verify the transaction before proceeding, the offline POS flow will be blocked at checkout.

## 8. Local Product Search & Filtering
The app needs to search products locally. If the search Notifier (`SearchNotifier` or similar) relies exclusively on the API (`/api/v1/rest/products/paginate`), offline users cannot find products to add to their cart.

**Risk:** The search bar and category filters will become unresponsive or throw errors when offline, breaking the core workflow of finding items to sell or restock.


## 9. Lack of `Dio` Interceptor Idempotency
While the Architecture Document notes the use of `X-Idempotency-Key` headers for outgoing REST requests via `BackgroundSyncService`, this might not be properly enforced at the `Dio` interceptor level for all non-GET requests.
**Risk:** When syncing queued transactions in `SyncQueueTable` after a connection drops and is restored, duplicate orders or cart operations could occur if the `X-Idempotency-Key` is missing or not generated consistently on the client side.

## 10. `AppConnectivity` Blocking `Dio` Execution
Many Riverpod Notifiers manually wrap API repository calls in `AppConnectivity.connectivity()` checks.
**Risk:** This duplicates logic, clutters business logic layers, and often completely prevents executing a `Dio` request. If `Dio` is configured correctly, it should gracefully fail and either trigger the sync queue or pull from the `Drift` database inside the Repository layer, keeping the Notifiers clean.

## Summary
The current implementation of Spazafy contains multiple critical paths that forcefully require an online connection, directly violating the target **Offline-First Architecture**. Migrating these calls to the `Drift` database, queuing write operations in the `SyncQueueTable`, and moving the network checking logic closer to the repository layer are the most immediate priorities.
