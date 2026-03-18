# Offline Support Audit Report

## Introduction
This report provides an audit of the application's offline capabilities. The application features an offline-first architecture but still has a few missing elements and vulnerabilities when running without an internet connection.

## Network Detection System
The app uses `connectivity_plus` through `AppConnectivity` class in `lib/infrastructure/services/utils/app_connectivity.dart`. It includes multiple methods for connectivity detection:
- `connectivity()`: A basic connectivity check.
- `connectivityWithDialog()`: Automatically shows an offline dialog when no connection is detected.

The UI extensively checks for connectivity before interacting with repositories, primarily seen in `lib/application/home/home_notifier.dart` and other notifiers. If offline, the application will block the operation and show a generic offline message instead of attempting API requests.

### Flaws & Limitations in Network Detection:
- The `AppConnectivity` wrapper lacks a stream listener. Background state changes do not automatically re-render or trigger retry logic across the UI (except for the `BackgroundSyncService` background listener). The app relies mostly on explicit checks on user action.
- Several Notifiers (like `HomeNotifier`) just display a message and stop fetching data. For a true offline-first approach, they should retrieve cached local data instead of halting operations when no connection is present.

## Background Synchronization & Database
The app uses Drift for SQLite local data persistence (`lib/infrastructure/services/utils/app_database.dart`) and maintains a `SyncQueueTable` for background request processing.

`BackgroundSyncService` runs in the background to handle queued API requests:
- Automatically listens to connectivity changes (`Connectivity().onConnectivityChanged`).
- Uses unique identifiers (`X-Idempotency-Key`) for outgoing offline operations to prevent double requests on the backend.
- Caches specific authentication responses when requests successfully sync.

### Limitations:
- It intercepts 400-level status codes and discards requests but treats 500-level as network errors requiring retries. If the server goes into persistent failure, the queue might build indefinitely.
- It doesn't appear to handle complex transactional dependencies (e.g., creating a user, then creating a cart for that user). If the first request fails due to unexpected business logic (4xx), subsequent requests that depend on it may still fire and also fail.

## Repository Audit

### 1. Cart Repository (`lib/infrastructure/repositories/cart_repository.dart`)
- **Offline Writes:** Supported. Adding a cart item `addToCart`, `insertCart`, and `insertCartWithGroup` gracefully fallback to `appDatabase.insertSyncRequest`.
- **Flaws:**
  - `getCart`, `getCartInGroup`, `deleteCart`, `removeProductCart`, and `changeStatus` completely fail in offline mode. The UI will just receive a network error rather than an updated local state.
  - Adding an item to the cart will be queued, but reading the cart will fail. This means the user can add to cart offline, but they can't see what's in their cart.

### 2. Orders Repository (`lib/infrastructure/repositories/orders_repository.dart`)
- **Offline Reads:** `getOrders` correctly persists data locally (`appDatabase.upsertOrder`) and has a robust fallback to local database reads (`appDatabase.getOrdersLocally`) when the network fails.
- **Flaws:**
  - `createOrder` fails immediately in offline mode. There is no offline fallback or queue mechanism for checkout logic.
  - Operations like `cancelOrder`, `refundOrder`, `createAutoOrder`, and `deleteAutoOrder` will fail completely as there's no `BackgroundSyncService` usage.
  - `getSingleOrder` has no local data fallback. Users cannot view an individual order's details when offline, even though the order list might load.

### 3. Authentication Repository (`lib/infrastructure/repositories/auth_repository.dart`)
- **Flaws:**
  - **No offline fallback:** All methods (`login`, `sendOtp`, `sigUpWithData`, etc.) fail immediately when offline.
  - **Authentication sync issue:** While `BackgroundSyncService` correctly captures tokens for queued auth requests, the actual `AuthRepository` itself doesn't queue operations like login or registration. The user cannot log in offline or register while disconnected.

### 4. General Repositories & UI
Because many notifiers start with `if (connected)` and fail silently or with a snackbar if disconnected, users will see empty states for:
- Banners (`fetchBanner`, `fetchAdsById`)
- Categories (`fetchCategories`)
- Shops (`fetchShop`, `fetchAllShops`)
- Stories (`fetchStories`)

There is a preloading caching system in `HomeNotifier` (`_preloadedCategoryShops`), which acts as an in-memory cache, but it's not persisted to SQLite. If the app restarts without an internet connection, all these elements will appear blank.

## Critical Risks
1. **Broken Checkout Flow:** Users can add items to the cart offline (which are queued), but they cannot complete the order because `createOrder` doesn't support offline queuing.
2. **Read-Write Inconsistency:** The application queues write operations for carts but doesn't read local queue state when pulling cart data. The cart UI will appear broken or desynchronized while offline.
3. **Empty Initial State:** Restarting the application in an offline state will result in a blank homepage because categories, banners, and shops are not loaded from Drift persistence in `HomeNotifier`.

## Recommendations
1. Integrate SQLite read-fallbacks into all GET requests (Shops, Categories, Cart, Banners).
2. Expand `insertSyncRequest` usage to other critical mutation endpoints (Order cancellation, Refunds).
3. Ensure cart reads check both remote and local SQLite queue to provide a unified offline view.