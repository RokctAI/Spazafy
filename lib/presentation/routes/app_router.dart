import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// ─── Customer/Shared Pages ──────────────────────────────────────────────────
import 'package:venderfoodyman/presentation/pages/home/home_four/filter/result_filter.dart';
import 'package:venderfoodyman/presentation/pages/home/home_four/widgets/recommended_screen.dart';
import 'package:venderfoodyman/presentation/pages/auth/login/login_page.dart';
import 'package:venderfoodyman/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:venderfoodyman/presentation/pages/auth/register/register_page.dart';
import 'package:venderfoodyman/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:venderfoodyman/presentation/pages/initial/no_connection/no_connection_page.dart';
import 'package:venderfoodyman/presentation/pages/initial/splash/splash_page.dart';
import 'package:venderfoodyman/presentation/pages/initial/ui_type/ui_type_page.dart';
import 'package:venderfoodyman/presentation/pages/like/like_page.dart';
import 'package:venderfoodyman/presentation/pages/main/main_page.dart';
import 'package:venderfoodyman/presentation/pages/order/order_screen/order_screen.dart';
import 'package:venderfoodyman/presentation/pages/order/orders_page.dart';
import 'package:venderfoodyman/presentation/pages/parcel/parcel_list_page.dart';
import 'package:venderfoodyman/presentation/pages/parcel/parcel_order_page.dart';
import 'package:venderfoodyman/presentation/pages/parcel/widgets/info_screen.dart';
import 'package:venderfoodyman/presentation/pages/policy_term/policy_page.dart';
import 'package:venderfoodyman/presentation/pages/policy_term/term_page.dart';
import 'package:venderfoodyman/presentation/pages/search/search_page.dart';
import 'package:venderfoodyman/presentation/pages/service/service_two_category_page.dart';
import 'package:venderfoodyman/presentation/pages/setting/setting_page.dart';
import 'package:venderfoodyman/presentation/pages/shop/shop_detail.dart';
import 'package:venderfoodyman/presentation/pages/shop/shop_page.dart';
import 'package:venderfoodyman/presentation/pages/view_map/map_search_page.dart';
import 'package:venderfoodyman/presentation/pages/view_map/view_map_page.dart';
import 'package:venderfoodyman/presentation/pages/initial/closed/closed_page.dart';
import 'package:venderfoodyman/presentation/pages/intro/customer/intro_page.dart';
import 'package:venderfoodyman/presentation/pages/order/orders_main.dart';

// ─── Shared/Manager/Driver Pages ─────────────────────────────────────────────
import '../pages/profile/address_list.dart';
import '../pages/profile/notification_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/profile/share_referral_faq.dart';
import '../pages/chat/chat/chat_page.dart';
import '../pages/home/widgets/shops_banner_page.dart';
import '../pages/order/order_screen/order_progress_screen.dart';
import '../pages/parcel/parcel_page.dart';
import '../pages/profile/help_page.dart';
import '../pages/profile/share_referral_page.dart';
import '../pages/profile/wallet_history.dart';
import '../pages/story_page/story_page.dart';
import '../pages/become/become_driver_page.dart';
import '../pages/become/become_seller_page.dart';
import '../pages/home/pos_page.dart';
import '../../presentation/pages/loans/widgets/loan_document_upload_screen.dart';
import '../../presentation/pages/loans/widgets/loan_eligibility_screen.dart';
import '../../presentation/pages/loans/loan_screen.dart';

// Note: Ensure PinPageType and other enums are imported if needed

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // ─── Core Routes ─────────────────────────────────────────────────────
    MaterialRoute(path: '/', page: SplashRoute.page),
    MaterialRoute(path: '/no-connection', page: NoConnectionRoute.page),
    MaterialRoute(path: '/login', page: LoginRoute.page),
    MaterialRoute(path: '/main', page: MainRoute.page),
    MaterialRoute(path: '/intro', page: IntroRoute.page),
    MaterialRoute(path: '/closed', page: ClosedRoute.page),
    MaterialRoute(path: '/ui-type', page: UiTypeRoute.page),

    // ─── Customer Routes ─────────────────────────────────────────────────
    MaterialRoute(path: '/shop', page: ShopRoute.page),
    MaterialRoute(path: '/order-list', page: OrdersListRoute.page),
    MaterialRoute(path: '/setting', page: SettingRoute.page),
    MaterialRoute(path: '/order-check', page: OrderRoute.page),
    MaterialRoute(path: '/search', page: SearchRoute.page),
    MaterialRoute(
      path: '/profile-customer',
      page: ProfileRoute.page,
    ), // Shared Profile
    MaterialRoute(path: '/map', page: ViewMapRoute.page),
    MaterialRoute(path: "/story-list", page: StoryListRoute.page),
    MaterialRoute(path: '/recommended', page: RecommendedRoute.page),
    MaterialRoute(path: '/map-search', page: MapSearchRoute.page),
    MaterialRoute(path: '/help', page: HelpRoute.page),
    MaterialRoute(path: '/order-progress', page: OrderProgressRoute.page),
    MaterialRoute(path: '/result-filter', page: ResultFilterRoute.page),
    MaterialRoute(path: '/wallet-history', page: WalletHistoryRoute.page),
    MaterialRoute(path: '/become-seller', page: BecomeSellerRoute.page),
    MaterialRoute(path: '/become-driver', page: BecomeDriverRoute.page),
    MaterialRoute(path: '/shops-banner', page: ShopsBannerRoute.page),
    MaterialRoute(path: '/shops-detail', page: ShopDetailRoute.page),
    MaterialRoute(path: '/share-referral', page: ShareReferralRoute.page),
    MaterialRoute(
      path: '/share-referral-faq',
      page: ShareReferralFaqRoute.page,
    ),
    MaterialRoute(path: '/chat', page: ChatRoute.page),
    MaterialRoute(path: '/notifications', page: NotificationListRoute.page),
    MaterialRoute(
      path: '/service-category',
      page: ServiceTwoCategoryRoute.page,
    ),
    MaterialRoute(path: '/parcel', page: ParcelRoute.page),
    MaterialRoute(path: '/parcel-list', page: ParcelListRoute.page),
    MaterialRoute(path: '/parcel-progress', page: ParcelProgressRoute.page),
    MaterialRoute(path: '/info', page: InfoRoute.page),
    MaterialRoute(path: '/like', page: LikeRoute.page),
    MaterialRoute(path: '/address-list', page: AddressListRoute.page),
    MaterialRoute(path: '/term', page: TermRoute.page),
    MaterialRoute(path: '/policy', page: PolicyRoute.page),
    MaterialRoute(path: '/orders-main', page: OrdersMainRoute.page),

    // ─── Financial/Loan Routes ───────────────────────────────────────────
    MaterialRoute(path: '/loan-eligibility', page: LoanEligibilityRoute.page),
    MaterialRoute(path: '/loan-upload', page: LoanDocumentUploadRoute.page),
    MaterialRoute(path: '/loan', page: LoanRoute.page),

    // ─── Manager/Seller/POS Routes ───────────────────────────────────────
    CupertinoRoute(path: '/income', page: IncomeRoute.page),
    CupertinoRoute(path: '/select-user', page: SelectUserRoute.page),
    CupertinoRoute(path: '/delivery-time', page: DeliveryTimeRoute.page),
    CupertinoRoute(path: '/order-history', page: OrderHistoryRoute.page),
    CupertinoRoute(path: '/delivery-zone', page: DeliveryZoneRoute.page),
    CupertinoRoute(path: '/select-address', page: SelectAddressRoute.page),
    CupertinoRoute(path: '/order-products', page: CreateOrderRoute.page),
    CupertinoRoute(path: '/shipping-address', page: ShippingAddressRoute.page),
    MaterialRoute(path: '/select-section', page: SelectSectionRoute.page),
    MaterialRoute(path: '/select-table', page: SelectTableRoute.page),
    MaterialRoute(path: '/webview', page: WebViewRoute.page),
    MaterialRoute(path: '/subscription', page: SubscriptionsRoute.page),
    CupertinoRoute(path: '/pos', page: PosRoute.page),
    CupertinoRoute(path: '/pos-checkout', page: PosCheckoutRoute.page),

    // ─── Driver Routes ───────────────────────────────────────────────────
    CupertinoRoute(path: '/driver-home', page: HomeRoute.page),
    CupertinoRoute(path: '/driver-story', page: StoryRoute.page),
    CupertinoRoute(path: '/parcel-history', page: ParcelHistoryRoute.page),
    CupertinoRoute(path: '/driver-orders', page: OrdersRoute.page),
    CupertinoRoute(path: '/driver-parcels', page: ParcelsRoute.page),
  ];
}
