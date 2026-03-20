# Offline Failure Audit Report

This report outlines the features, functions, and UI elements that explicitly fail or block user interaction when the application is offline.

## 1. Application/Notifier Layer Blockers
These state notifiers perform manual connectivity checks, effectively blocking the operation from entering the offline background sync queue or executing locally.

### `lib/application/auth/confirmation/register_confirmation_notifier.dart`
- **Register Confirmation Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/auth/login/login_notifier.dart`
- **Login Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/auth/register/register_notifier.dart`
- **Register Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/auth/reset_password/reset_password_notifier.dart`
- **Reset Password Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/chat/chat_notifier.dart`
- **Chat Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/confirmation/register_confirmation_notifier.dart`
- **Register Confirmation Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/edit_profile/edit_profile_notifier.dart`
- **Edit Profile Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/filter/filter_notifier.dart`
- **Filter Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/foods/manager/filter/foods_filter_notifier.dart`
- **Foods Filter Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/home/driver/home_notifier.dart`
- **Home Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/map/view_map_notifier.dart`
- **View Map Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/notification/driver/notification_notifier.dart`
- **Notification Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/notification/manager/notification_notifier.dart`
- **Notification Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/order/driver/all_order/order_notifier.dart`
- **Order Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/order/driver/canceled_order/canceled_order_notifier.dart`
- **Canceled Order Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/order/driver/delivered_order/delivered_order_notifier.dart`
- **Delivered Order Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/order/driver/progress_ordedr/progress_order_notifier.dart`
- **Progress Order Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/order/order_notifier.dart`
- **Order Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/orders_list/orders_list_notifier.dart`
- **Orders List Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/parcel/driver/parcel_notifier.dart`
- **Parcel Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/parcel/parcel_notifier.dart`
- **Parcel Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/parcels_list/parcel_list_notifier.dart`
- **Parcel List Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/payment_methods/payment_notifier.dart`
- **Payment Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/product/product_notifier.dart`
- **Product Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/profile/driver/notifier/profile_edit_notifier.dart`
- **Profile Edit Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/profile/driver/notifier/profile_settings_notifier.dart`
- **Profile Settings Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/profile/manager/profile_notifier.dart`
- **Profile Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/profile/profile_notifier.dart`
- **Profile Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/promo_code/promo_code_notifier.dart`
- **Promo Code Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/shop/shop_notifier.dart`
- **Shop Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

### `lib/application/splash/splash_notifier.dart`
- **Splash Notifier**: Operations within this file manually check `AppConnectivity.connectivity()`.

## 2. UI Routing Blockers
These screens intercept routing or initialize logic that explicitly checks for a connection and redirects the user to a `NoConnectionRoute` or blocks access.

### `lib/presentation/components/custom_scaffold.dart`
- **Custom Scaffold**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/initial/splash/splash_page.dart`
- **Splash Page**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/order/order_check/order_check.dart`
- **Order Check**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/order/order_check/widgets/payment_method.dart`
- **Payment Method**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/pages_driver.dart`
- **Pages Driver**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/pages_manager.dart`
- **Pages Manager**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/parcel/parcel_page.dart`
- **Parcel Page**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/parcel/widgets/parcel_payments.dart`
- **Parcel Payments**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/profile/profile_page.dart`
- **Profile Page**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/profile/wallet_history.dart`
- **Wallet History**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/profile/widgets/wallet_send_screen.dart`
- **Wallet Send Screen**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/pages/profile/widgets/wallet_topup_screen.dart`
- **Wallet Topup Screen**: Has explicit UI logic to check connection or route to `NoConnection`.

### `lib/presentation/routes/app_router.dart`
- **App Router**: Has explicit UI logic to check connection or route to `NoConnection`.

## 3. Infrastructure Layer Connectivity Checks
These repositories or services manually check for connectivity.

- `lib/infrastructure/services/utils/app_connectivity.dart`
- `lib/infrastructure/services/utils/app_helpers.dart`
- `lib/infrastructure/services/utils/driver/app_helpers.dart`
- `lib/infrastructure/services/utils/manager/app_helpers.dart`
