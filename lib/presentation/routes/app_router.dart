import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/filter/result_filter.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/widgets/recommended_two_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rokctapp/presentation/pages/auth/login/login_page.dart';
import 'package:rokctapp/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:rokctapp/presentation/pages/auth/register/register_page.dart';
import 'package:rokctapp/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/widgets/recommended_one_screen.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/widgets/recommended_three_screen.dart';
import 'package:rokctapp/presentation/pages/initial/splash/splash_page.dart';
import 'package:rokctapp/presentation/pages/initial/no_connection/no_connection_page.dart';
import 'package:rokctapp/presentation/pages/initial/ui_type/ui_type_page.dart';
import 'package:rokctapp/presentation/pages/like/like_page.dart';
import 'package:rokctapp/presentation/pages/main/main_page.dart';
import 'package:rokctapp/presentation/pages/order/order_screen/order_screen.dart';
import 'package:rokctapp/presentation/pages/order/orders_page.dart';
import 'package:rokctapp/presentation/pages/parcel/parcel_list_page.dart';
import 'package:rokctapp/presentation/pages/parcel/parcel_order_page.dart';
import 'package:rokctapp/presentation/pages/parcel/widgets/info_screen.dart';
import 'package:rokctapp/presentation/pages/policy_term/policy_page.dart';
import 'package:rokctapp/presentation/pages/policy_term/term_page.dart';
import 'package:rokctapp/presentation/pages/profile/address_list.dart';
import 'package:rokctapp/presentation/pages/profile/notification_page.dart';
import 'package:rokctapp/presentation/pages/profile/profile_page.dart';
import 'package:rokctapp/presentation/pages/profile/share_referral_faq.dart';
import 'package:rokctapp/presentation/pages/search/search_page.dart';
import 'package:rokctapp/presentation/pages/service/service_two_category_page.dart';
import 'package:rokctapp/presentation/pages/setting/setting_page.dart';
import 'package:rokctapp/presentation/pages/stores/shop_detail.dart';
import 'package:rokctapp/presentation/pages/stores/shop_page.dart';
import 'package:rokctapp/presentation/pages/view_map/map_search_page.dart';
import 'package:rokctapp/presentation/pages/view_map/view_map_page.dart';
import 'package:rokctapp/infrastructure/models/data/address_new_data.dart';
import 'package:rokctapp/infrastructure/models/data/shop_data.dart';
import 'package:rokctapp/infrastructure/models/data/user.dart';
import 'package:rokctapp/presentation/pages/chat/chat/chat_page.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/widgets/shops_banner_page.dart';
import 'package:rokctapp/presentation/pages/order/order_screen/order_progress_screen.dart';
import 'package:rokctapp/presentation/pages/parcel/parcel_page.dart';
import 'package:rokctapp/presentation/pages/become/become_seller.dart';
import 'package:rokctapp/presentation/pages/profile/help_page.dart';
import 'package:rokctapp/presentation/pages/home/home_zero/widgets/recommended_screen.dart';
import 'package:rokctapp/presentation/pages/profile/share_referral_page.dart';
import 'package:rokctapp/presentation/pages/profile/wallet_history.dart';
import 'package:rokctapp/presentation/pages/story/story_page.dart';
import 'package:rokctapp/presentation/pages/initial/closed/closed_page.dart';
import 'package:rokctapp/presentation/pages/intro/intro_page.dart';
import 'package:rokctapp/presentation/pages/order/orders_main.dart';
import 'package:rokctapp/presentation/pages/loans/widgets/loan_document_upload_screen.dart';
import 'package:rokctapp/presentation/pages/loans/widgets/loan_eligibility_screen.dart';
import 'package:rokctapp/presentation/pages/loans/loan_screen.dart';
import 'package:rokctapp/presentation/pages/profile/driver/notification_list_page.dart';
import 'package:rokctapp/presentation/pages/order_history/driver/order_history.dart';
import 'package:rokctapp/presentation/pages/order/driver/orders_page.dart';
import 'package:rokctapp/presentation/pages/parcel/driver/parcels_page.dart';
import 'package:rokctapp/presentation/pages/profile/driver/profile_page.dart';
import 'package:rokctapp/presentation/pages/story/driver/story_page.dart';
import 'package:rokctapp/presentation/pages/view_map/driver_view_map_page.dart';
import 'package:rokctapp/presentation/pages/auth/manager/auth_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/create_order_page.dart';
import 'package:rokctapp/presentation/pages/restaurant/manager/delivery_zone/delivery_zone_page.dart';
import 'package:rokctapp/presentation/pages/income/manager/income_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/main_page.dart';
import 'package:rokctapp/presentation/pages/view_map/manager_map_search_page.dart';
import 'package:rokctapp/presentation/pages/restaurant/manager/notification_list_page.dart';
import 'package:rokctapp/presentation/pages/order_history/manager/order_history.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/order/order_page.dart';
import 'package:rokctapp/presentation/pages/view_map/manager_view_map_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/address/select_address_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/select_section/select_section_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/select_table/select_table_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/select_user/select_user_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/shipping_address_page.dart';
import 'package:rokctapp/presentation/pages/restaurant/manager/subscriptions/subscriptions_page.dart';
import 'package:rokctapp/presentation/pages/webview/webview_page.dart';
import 'package:rokctapp/presentation/pages/main/manager/create_order/shipping/details/delivery_time_page.dart';
import 'package:rokctapp/presentation/pages/become/become_driver.dart';
import 'package:rokctapp/presentation/pages/profile/driver/delivery_zone/delivery_zone_page.dart';
import 'package:rokctapp/presentation/pages/home/driver/home_page.dart';
import 'package:rokctapp/presentation/pages/income/driver/income_page.dart';
import 'package:rokctapp/presentation/routes/app_router.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    MaterialRoute(path: '/', page: SplashRoute.page),
    MaterialRoute(path: '/no-connection', page: NoConnectionRoute.page),
    MaterialRoute(path: '/login', page: LoginRoute.page),
    MaterialRoute(path: '/ui-type', page: UiTypeRoute.page),
    MaterialRoute(path: '/reset', page: ResetPasswordRoute.page),
    MaterialRoute(
      path: '/register-confirmation',
      page: RegisterConfirmationRoute.page,
    ),
    MaterialRoute(path: '/register', page: RegisterRoute.page),
    MaterialRoute(path: '/main', page: MainRoute.page),
    MaterialRoute(path: '/shop', page: ShopRoute.page),
    MaterialRoute(path: '/order', page: OrdersListRoute.page),
    MaterialRoute(path: '/setting', page: SettingRoute.page),
    MaterialRoute(path: '/orderScreen', page: OrderRoute.page),
    MaterialRoute(path: '/searchPage', page: SearchRoute.page),
    MaterialRoute(path: '/ProfilePage', page: ProfileRoute.page),
    MaterialRoute(path: '/map', page: ViewMapRoute.page),
    MaterialRoute(path: "/storyList", page: StoryListRoute.page),
    MaterialRoute(path: '/recommended', page: RecommendedRoute.page),
    MaterialRoute(path: '/recommended_one', page: RecommendedOneRoute.page),
    MaterialRoute(path: '/recommended_two', page: RecommendedTwoRoute.page),
    MaterialRoute(path: '/map_search', page: MapSearchRoute.page),
    MaterialRoute(path: '/help', page: HelpRoute.page),
    MaterialRoute(path: '/order_progress', page: OrderProgressRoute.page),
    MaterialRoute(path: '/result_filter', page: ResultFilterRoute.page),
    MaterialRoute(path: '/wallet_history', page: WalletHistoryRoute.page),
    MaterialRoute(path: '/create_shop', page: CreateShopRoute.page),
    MaterialRoute(path: '/shops_banner', page: ShopsBannerRoute.page),
    MaterialRoute(path: '/shops_detail', page: ShopDetailRoute.page),
    MaterialRoute(path: '/share_referral', page: ShareReferralRoute.page),
    MaterialRoute(
      path: '/share_referral_faq',
      page: ShareReferralFaqRoute.page,
    ),
    MaterialRoute(path: '/chat', page: ChatRoute.page),
    MaterialRoute(
      path: '/notification_list_page',
      page: NotificationListRoute.page,
    ),
    MaterialRoute(
      path: '/service_two_category_page',
      page: ServiceTwoCategoryRoute.page,
    ),
    MaterialRoute(path: '/recommended_three', page: RecommendedThreeRoute.page),
    MaterialRoute(path: '/parcel_page', page: ParcelRoute.page),
    MaterialRoute(path: '/info_screen', page: InfoRoute.page),
    MaterialRoute(path: '/like_page', page: LikeRoute.page),
    MaterialRoute(path: '/parcel_list_page', page: ParcelListRoute.page),
    MaterialRoute(
      path: '/parcel_progress_page',
      page: ParcelProgressRoute.page,
    ),
    // MaterialRoute(path: '/sub_category_page', page: SubCategoryRoute.page),
    MaterialRoute(path: '/address_list_page', page: AddressListRoute.page),
    MaterialRoute(path: '/term', page: TermRoute.page),
    MaterialRoute(path: '/policy', page: PolicyRoute.page),
    MaterialRoute(path: '/ClosedPage', page: ClosedRoute.page),
    MaterialRoute(path: '/IntroPage', page: IntroRoute.page),
    MaterialRoute(path: '/OrdesMainPage', page: OrdersMainRoute.page),
    MaterialRoute(
      path: '/LoanEligibilityScreen',
      page: LoanEligibilityRoute.page,
    ),
    MaterialRoute(
      path: '/LoanDocumentUploadScreen',
      page: LoanDocumentUploadRoute.page,
    ),
    MaterialRoute(path: '/LoanScreen', page: LoanRoute.page),

    // Driver Routes
    CupertinoRoute(path: '/driver/income', page: DriverIncomeRoute.page),
    CupertinoRoute(path: '/driver/home', page: DriverHomeRoute.page),
    CupertinoRoute(path: '/map', page: ViewMapRoute.page),
    CupertinoRoute(path: '/driver/story', page: DriverStoryRoute.page),
    CupertinoRoute(path: '/driver/profile', page: DriverProfileRoute.page),
    CupertinoRoute(
      path: '/driver/list-notification',
      page: DriverNotificationListRoute.page,
    ),
    CupertinoRoute(
      path: '/driver/order-history',
      page: DriverOrderHistoryRoute.page,
    ),
    CupertinoRoute(path: '/driver/orders', page: DriverOrdersRoute.page),
    CupertinoRoute(path: '/driver/parcels', page: DriverParcelsRoute.page),
    CupertinoRoute(
      path: '/driver/become-driver',
      page: DriverBecomeDriverRoute.page,
    ),
    CupertinoRoute(
      path: '/driver/delivery-zone',
      page: DriverDeliveryZoneRoute.page,
    ),
    CupertinoRoute(path: '/driver/view-map', page: DriverViewMapRoute.page),
    CupertinoRoute(
      path: '/driver/no-connection',
      page: DriverNoConnectionRoute.page,
    ),

    // Manager Routes
    CupertinoRoute(path: '/manager/main', page: ManagerMainRoute.page),
    CupertinoRoute(path: '/manager/auth', page: ManagerAuthRoute.page),
    CupertinoRoute(path: '/manager/view-map', page: ManagerViewMapRoute.page),
    CupertinoRoute(path: '/manager/order', page: ManagerOrderRoute.page),
    CupertinoRoute(path: '/manager/income', page: ManagerIncomeRoute.page),
    CupertinoRoute(path: '/manager/select-user', page: SelectUserRoute.page),
    CupertinoRoute(
      path: '/manager/delivery-time',
      page: DeliveryTimeRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/order-history',
      page: ManagerOrderHistoryRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/delivery-zone',
      page: ManagerDeliveryZoneRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/no-connection',
      page: ManagerNoConnectionRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/select-address',
      page: SelectAddressRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/order-products',
      page: ManagerCreateOrderRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/shipping-address',
      page: ShippingAddressRoute.page,
    ),
    CupertinoRoute(
      path: '/manager/list-notification',
      page: ManagerNotificationListRoute.page,
    ),
    CupertinoRoute(path: '/manager/view_map', page: ManagerViewMapRoute.page),
    CupertinoRoute(
      path: '/manager/search_map',
      page: ManagerMapSearchRoute.page,
    ),
    MaterialRoute(
      path: '/manager/select-section',
      page: SelectSectionRoute.page,
    ),
    MaterialRoute(path: '/manager/select-table', page: SelectTableRoute.page),
    MaterialRoute(path: '/manager/webview', page: WebViewRoute.page),
    MaterialRoute(
      path: '/manager/subscription',
      page: SubscriptionsRoute.page,
    ),
  ];
}
