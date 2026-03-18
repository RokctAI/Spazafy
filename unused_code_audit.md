# Unused Code Audit Report

An analysis of the codebase using `dart analyze` has identified several areas with unused elements, unused local variables, and dead code.

## 1. Unused Elements (Declarations not referenced)

A common pattern across many BLoC/State classes is the declaration of a private constructor (e.g., `ClassName._()`) that is never used. This is often an artifact of using the `freezed` package incorrectly or unnecessarily.

The following files have unused state declarations:

- `lib/application/add_card/add_card_state.dart:15:22` (`AddCardState._`)
- `lib/application/app_widget/app_state.dart:14:18` (`AppState._`)
- `lib/application/auth/confirmation/register_confirmation_state.dart:20:35` (`RegisterConfirmationState._`)
- `lib/application/auth/login/login_state.dart:23:20` (`LoginState._`)
- `lib/application/auth/register/register_state.dart:25:23` (`RegisterState._`)
- `lib/application/auth/reset_password/reset_password_state.dart:22:28` (`ResetPasswordState._`)
- `lib/application/auto_order/auto_order_state.dart:24:24` (`AutoOrderState._`)
- `lib/application/chat/chat_state.dart:19:19` (`ChatState._`)
- `lib/application/closed/closed_state.dart:9:21` (`ClosedState._`)
- `lib/application/currency/currency_state.dart:13:23` (`CurrencyState._`)
- `lib/application/delivery_points/delivery_points_state.dart:13:29` (`DeliveryPointsState._`)
- `lib/application/edit_profile/edit_profile_state.dart:23:26` (`EditProfileState._`)
- `lib/application/filter/filter_state.dart:30:21` (`FilterState._`)
- `lib/application/floating_button/floating_state.dart:10:23` (`FloatingState._`)
- `lib/application/help/help_state.dart:13:19` (`HelpState._`)
- `lib/application/home/home_state.dart:37:19` (`HomeState._`)
- `lib/application/intro/intro_state.dart:9:20` (`IntroState._`)
- `lib/application/language/language_state.dart:16:23` (`LanguageState._`)
- `lib/application/like/like_state.dart:13:19` (`LikeState._`)
- `lib/application/main/main_state.dart:14:19` (`MainState._`)
- `lib/application/map/view_map_state.dart:16:22` (`ViewMapState._`)
- `lib/application/notification/notification_state.dart:16:27` (`NotificationState._`)
- `lib/application/order/order_state.dart:49:20` (`OrderState._`)
- `lib/application/order_time/time_state.dart:13:19` (`TimeState._`)
- `lib/application/orders_list/orders_list_state.dart:19:25` (`OrdersListState._`)
- `lib/application/parcel/parcel_state.dart:31:21` (`ParcelState._`)
- `lib/application/parcels_list/parcel_list_state.dart:16:25` (`ParcelListState._`)
- `lib/application/payment_methods/payment_state.dart:13:22` (`PaymentState._`)
- `lib/application/product/product_state.dart:25:22` (`ProductState._`)
- `lib/application/profile/profile_state.dart:31:22` (`ProfileState._`)
- `lib/application/promo_code/promo_code_state.dart:12:24` (`PromoCodeState._`)
- `lib/application/save_card/saved_cards_state.dart:14:25` (`SavedCardsState._`)
- `lib/application/search/search_state.dart:18:21` (`SearchState._`)
- `lib/application/select/select_state.dart:11:21` (`SelectState._`)
- `lib/application/setting/setting_state.dart:13:22` (`SettingState._`)
- `lib/application/shop/shop_state.dart:51:19` (`ShopState._`)
- `lib/application/shop_order/shop_order_state.dart:24:24` (`ShopOrderState._`)
- `lib/application/splash/splash_state.dart:9:21` (`SplashState._`)

*Recommendation*: Remove these private constructors if they are not enabling custom methods/getters within the freezed class.

## 2. Unused Local Variables

Variables that are declared but never read. This can indicate an incomplete feature or refactored code.

- `lib/application/shop/shop_notifier.dart:716:11` - `dynamicLink`
- `lib/application/shop_order/shop_order_notifier.dart:610:11` - `dynamicLink`
- `lib/infrastructure/repositories/parcel_repository.dart:236:11` - `data`
- `lib/infrastructure/repositories/products_repository.dart:16:11` - `params`
- `lib/infrastructure/repositories/products_repository.dart:22:13` - `client`
- `lib/infrastructure/repositories/products_repository.dart:87:11` - `params`
- `lib/infrastructure/repositories/products_repository.dart:96:13` - `client`
- `lib/presentation/pages/main/main_page.dart:240:15` - `offlineUser`
- `lib/utils/app_initializer.dart:36:18` - `tenantSite`

*Recommendation*: Remove these unused variables to clean up the code and potentially avoid memory/performance overhead.

## 3. Dead Code

Code that cannot be reached during execution, often due to a return statement, throw, or conditional logic that is always true/false preceding it.

- `lib/application/billing/billing_state.freezed.dart:237:5`
- `lib/domain/handlers/network_exceptions.dart:89:16`
- `lib/domain/handlers/network_exceptions.dart:167:16`
- `lib/infrastructure/repositories/wallet_repository.dart:116:14`
- `lib/infrastructure/services/utils/app_database.dart:330:5`
- `lib/infrastructure/services/utils/app_database.dart:341:5`
- `lib/presentation/components/title_icon.dart:82:37`
- `lib/printer/providers/billing_printer_state.freezed.dart:184:5`

*Recommendation*: Investigate the cause of the unreachable code and remove it. Note that `freezed` generated files should not be edited directly; the source `.dart` file should be updated and the generator re-run.
