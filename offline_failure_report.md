# Offline Failure Report

This report outlines the application features that bypass the robust offline-first background queueing mechanism (`BackgroundSyncService` and `SyncQueueTable`). These features check for `AppConnectivity.connectivity()` directly in their respective Riverpod notifiers. As a result, when the device is offline, these features will fail immediately or display an error message, rather than appropriately queuing their network requests for background sync when the connection is restored.

## Affected Features

Based on an audit of the `lib/application/` directory, the following modules manually check for connectivity and will fail gracefully or show errors when offline:

### 1. Search (`search_notifier.dart`)
- **Impact:** Searching features bypass queueing.
- **Failures at:**
  - `lib/application/search/search_notifier.dart` (lines 67, 91, 115)

### 2. Map / Location (`view_map_notifier.dart`)
- **Impact:** Map viewing and location-related features will not function or queue requests offline.
- **Failures at:**
  - `lib/application/map/view_map_notifier.dart` (lines 47, 76, 106)

### 3. Notifications (`notification_notifier.dart`)
- **Impact:** Fetching or interacting with notifications will fail.
- **Failures at:**
  - `lib/application/notification/notification_notifier.dart` (line 41)

### 4. Orders (`order_notifier.dart`, `orders_list_notifier.dart`)
- **Impact:** Creating, viewing, or modifying orders.
- **Failures at:**
  - `lib/application/order/order_notifier.dart` (numerous occurrences: 79, 282, 317, 341, 445, 654, 706, 803, 828, 863, 895)
  - `lib/application/orders_list/orders_list_notifier.dart` (lines 177, 205)

### 5. Likes / Favorites (`like_notifier.dart`)
- **Impact:** Liking or unliking items will not be queued for offline execution.
- **Failures at:**
  - `lib/application/like/like_notifier.dart` (line 16)

### 6. Profile & User Management (`profile_notifier.dart`, `edit_profile_notifier.dart`)
- **Impact:** Fetching profile details or editing the profile will fail offline.
- **Failures at:**
  - `lib/application/profile/profile_notifier.dart` (lines 132, 216, 255, 286, 324, 371)
  - `lib/application/edit_profile/edit_profile_notifier.dart` (lines 93, 142)

### 7. Shops (`shop_notifier.dart`)
- **Impact:** Fetching shop details. (Note: The checks here are currently commented out, but are worth monitoring).
- **Failures at:**
  - `lib/application/shop/shop_notifier.dart` (lines 528, 624, 662)

### 8. Home (`home_notifier.dart`)
- **Impact:** The home screen uses a connection listener which might dictate offline behavior bypassing queue.
- **Failures at:**
  - `lib/application/home/home_notifier.dart` (line 57)

### 9. Confirmations (`register_confirmation_notifier.dart`)
- **Impact:** Confirming registration or actions.
- **Failures at:**
  - `lib/application/confirmation/register_confirmation_notifier.dart` (lines 42, 81, 116, 157, 214, 251)

### 10. Promos & Filters (`promo_code_notifier.dart`, `filter_notifier.dart`)
- **Impact:** Applying promo codes and applying catalog filters.
- **Failures at:**
  - `lib/application/promo_code/promo_code_notifier.dart` (line 23)
  - `lib/application/filter/filter_notifier.dart` (lines 29, 76, 123, 165, 200)

### 11. Settings, Help & Language (`setting_notifier.dart`, `help_notifier.dart`, `language_notifier.dart`, `currency_notifier.dart`)
- **Impact:** Updating settings, fetching help, changing language, or changing currency.
- **Failures at:**
  - `lib/application/setting/setting_notifier.dart` (line 23)
  - `lib/application/help/help_notifier.dart` (line 15)
  - `lib/application/language/language_notifier.dart` (lines 27, 88)
  - `lib/application/currency/currency_notifier.dart` (line 17)

### 12. Parcels (`parcel_list_notifier.dart`, `parcel_notifier.dart`)
- **Impact:** Viewing or managing parcels.
- **Failures at:**
  - `lib/application/parcels_list/parcel_list_notifier.dart` (lines 22, 78, 124, 153)
  - `lib/application/parcel/parcel_notifier.dart` (lines 31, 71, 95, 147, 305, 398)

### 13. Authentication (`login_notifier.dart`, `register_notifier.dart`, `reset_password_notifier.dart`, `auth/confirmation/register_confirmation_notifier.dart`)
- **Impact:** Authentication flows frequently check for connectivity. However, note that `login_notifier.dart` and `register_notifier.dart` **do** have some fallback logic that enqueues requests via `BackgroundSyncService.enqueueRequest` when offline. Despite this, they still check connectivity manually to branch logic, rather than relying purely on the repository layer handling.
- **Failures at:**
  - `lib/application/auth/login/login_notifier.dart` (lines 76, 113, 145, 168, 316, 403, 530)
  - `lib/application/auth/register/register_notifier.dart` (lines 89, 126, 179, 358, 472, 531, 625, 748)
  - `lib/application/auth/reset_password/reset_password_notifier.dart` (lines 57, 94, 132)
  - `lib/application/auth/confirmation/register_confirmation_notifier.dart` (lines 46, 160, 196, 237, 368, 405, 453)

### 14. Splash Screen (`splash_notifier.dart`)
- **Impact:** Splash screen initialization logic checks for connectivity.
- **Failures at:**
  - `lib/application/splash/splash_notifier.dart` (lines 21, 66)

## Conclusion

According to best practices outlined for this project (`Avoid wrapping repository API calls with manual AppConnectivity.connectivity() checks in Riverpod Notifiers, as this bypasses the data layer's background sync queue and prevents Dio from properly handling offline request queuing`), the above modules should be refactored to remove the manual `AppConnectivity.connectivity()` checks. They should ideally rely on the `HttpService` / `Dio` interceptor logic and `BackgroundSyncService` to handle failures and queuing, providing a smoother offline-first experience.