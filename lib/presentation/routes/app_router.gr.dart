// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddressListPage]
class AddressListRoute extends PageRouteInfo<void> {
  const AddressListRoute({List<PageRouteInfo>? children})
    : super(AddressListRoute.name, initialChildren: children);

  static const String name = 'AddressListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddressListPage();
    },
  );
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required String roleId,
    required String name,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(key: key, roleId: roleId, name: name),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatPage(key: args.key, roleId: args.roleId, name: args.name);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key, required this.roleId, required this.name});

  final Key? key;

  final String roleId;

  final String name;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, roleId: $roleId, name: $name}';
  }
}

/// generated route for
/// [ClosedPage]
class ClosedRoute extends PageRouteInfo<void> {
  const ClosedRoute({List<PageRouteInfo>? children})
    : super(ClosedRoute.name, initialChildren: children);

  static const String name = 'ClosedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClosedPage();
    },
  );
}

/// generated route for
/// [CreateShopPage]
class CreateShopRoute extends PageRouteInfo<void> {
  const CreateShopRoute({List<PageRouteInfo>? children})
    : super(CreateShopRoute.name, initialChildren: children);

  static const String name = 'CreateShopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateShopPage();
    },
  );
}

/// generated route for
/// [DeliveryTimePage]
class DeliveryTimeRoute extends PageRouteInfo<void> {
  const DeliveryTimeRoute({List<PageRouteInfo>? children})
    : super(DeliveryTimeRoute.name, initialChildren: children);

  static const String name = 'DeliveryTimeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DeliveryTimePage();
    },
  );
}

/// generated route for
/// [DriverBecomeDriverPage]
class DriverBecomeDriverRoute extends PageRouteInfo<void> {
  const DriverBecomeDriverRoute({List<PageRouteInfo>? children})
    : super(DriverBecomeDriverRoute.name, initialChildren: children);

  static const String name = 'DriverBecomeDriverRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverBecomeDriverPage();
    },
  );
}

/// generated route for
/// [DriverDeliveryZonePage]
class DriverDeliveryZoneRoute extends PageRouteInfo<void> {
  const DriverDeliveryZoneRoute({List<PageRouteInfo>? children})
    : super(DriverDeliveryZoneRoute.name, initialChildren: children);

  static const String name = 'DriverDeliveryZoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverDeliveryZonePage();
    },
  );
}

/// generated route for
/// [DriverHomePage]
class DriverHomeRoute extends PageRouteInfo<void> {
  const DriverHomeRoute({List<PageRouteInfo>? children})
    : super(DriverHomeRoute.name, initialChildren: children);

  static const String name = 'DriverHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverHomePage();
    },
  );
}

/// generated route for
/// [DriverIncomePage]
class DriverIncomeRoute extends PageRouteInfo<void> {
  const DriverIncomeRoute({List<PageRouteInfo>? children})
    : super(DriverIncomeRoute.name, initialChildren: children);

  static const String name = 'DriverIncomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverIncomePage();
    },
  );
}

/// generated route for
/// [DriverNoConnectionPage]
class DriverNoConnectionRoute extends PageRouteInfo<void> {
  const DriverNoConnectionRoute({List<PageRouteInfo>? children})
    : super(DriverNoConnectionRoute.name, initialChildren: children);

  static const String name = 'DriverNoConnectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverNoConnectionPage();
    },
  );
}

/// generated route for
/// [DriverNotificationListPage]
class DriverNotificationListRoute extends PageRouteInfo<void> {
  const DriverNotificationListRoute({List<PageRouteInfo>? children})
    : super(DriverNotificationListRoute.name, initialChildren: children);

  static const String name = 'DriverNotificationListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverNotificationListPage();
    },
  );
}

/// generated route for
/// [DriverOrderHistoryPage]
class DriverOrderHistoryRoute extends PageRouteInfo<void> {
  const DriverOrderHistoryRoute({List<PageRouteInfo>? children})
    : super(DriverOrderHistoryRoute.name, initialChildren: children);

  static const String name = 'DriverOrderHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverOrderHistoryPage();
    },
  );
}

/// generated route for
/// [DriverOrdersPage]
class DriverOrdersRoute extends PageRouteInfo<void> {
  const DriverOrdersRoute({List<PageRouteInfo>? children})
    : super(DriverOrdersRoute.name, initialChildren: children);

  static const String name = 'DriverOrdersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverOrdersPage();
    },
  );
}

/// generated route for
/// [DriverParcelHistoryPage]
class DriverParcelHistoryRoute extends PageRouteInfo<void> {
  const DriverParcelHistoryRoute({List<PageRouteInfo>? children})
    : super(DriverParcelHistoryRoute.name, initialChildren: children);

  static const String name = 'DriverParcelHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverParcelHistoryPage();
    },
  );
}

/// generated route for
/// [DriverParcelsPage]
class DriverParcelsRoute extends PageRouteInfo<void> {
  const DriverParcelsRoute({List<PageRouteInfo>? children})
    : super(DriverParcelsRoute.name, initialChildren: children);

  static const String name = 'DriverParcelsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverParcelsPage();
    },
  );
}

/// generated route for
/// [DriverProfilePage]
class DriverProfileRoute extends PageRouteInfo<void> {
  const DriverProfileRoute({List<PageRouteInfo>? children})
    : super(DriverProfileRoute.name, initialChildren: children);

  static const String name = 'DriverProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverProfilePage();
    },
  );
}

/// generated route for
/// [DriverStoryPage]
class DriverStoryRoute extends PageRouteInfo<void> {
  const DriverStoryRoute({List<PageRouteInfo>? children})
    : super(DriverStoryRoute.name, initialChildren: children);

  static const String name = 'DriverStoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverStoryPage();
    },
  );
}

/// generated route for
/// [DriverViewMapPage]
class DriverViewMapRoute extends PageRouteInfo<void> {
  const DriverViewMapRoute({List<PageRouteInfo>? children})
    : super(DriverViewMapRoute.name, initialChildren: children);

  static const String name = 'DriverViewMapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriverViewMapPage();
    },
  );
}

/// generated route for
/// [HelpPage]
class HelpRoute extends PageRouteInfo<void> {
  const HelpRoute({List<PageRouteInfo>? children})
    : super(HelpRoute.name, initialChildren: children);

  static const String name = 'HelpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelpPage();
    },
  );
}

/// generated route for
/// [InfoPage]
class InfoRoute extends PageRouteInfo<InfoRouteArgs> {
  InfoRoute({Key? key, required int index, List<PageRouteInfo>? children})
    : super(
        InfoRoute.name,
        args: InfoRouteArgs(key: key, index: index),
        initialChildren: children,
      );

  static const String name = 'InfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoRouteArgs>();
      return InfoPage(key: args.key, index: args.index);
    },
  );
}

class InfoRouteArgs {
  const InfoRouteArgs({this.key, required this.index});

  final Key? key;

  final int index;

  @override
  String toString() {
    return 'InfoRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [IntroPage]
class IntroRoute extends PageRouteInfo<void> {
  const IntroRoute({List<PageRouteInfo>? children})
    : super(IntroRoute.name, initialChildren: children);

  static const String name = 'IntroRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntroPage();
    },
  );
}

/// generated route for
/// [LikePage]
class LikeRoute extends PageRouteInfo<LikeRouteArgs> {
  LikeRoute({Key? key, bool isBackButton = true, List<PageRouteInfo>? children})
    : super(
        LikeRoute.name,
        args: LikeRouteArgs(key: key, isBackButton: isBackButton),
        initialChildren: children,
      );

  static const String name = 'LikeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LikeRouteArgs>(
        orElse: () => const LikeRouteArgs(),
      );
      return LikePage(key: args.key, isBackButton: args.isBackButton);
    },
  );
}

class LikeRouteArgs {
  const LikeRouteArgs({this.key, this.isBackButton = true});

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'LikeRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [LoanDocumentUploadScreen]
class LoanDocumentUploadRoute
    extends PageRouteInfo<LoanDocumentUploadRouteArgs> {
  LoanDocumentUploadRoute({
    Key? key,
    String? prefilledIdNumber,
    List<PageRouteInfo>? children,
  }) : super(
         LoanDocumentUploadRoute.name,
         args: LoanDocumentUploadRouteArgs(
           key: key,
           prefilledIdNumber: prefilledIdNumber,
         ),
         initialChildren: children,
       );

  static const String name = 'LoanDocumentUploadRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoanDocumentUploadRouteArgs>(
        orElse: () => const LoanDocumentUploadRouteArgs(),
      );
      return LoanDocumentUploadScreen(
        key: args.key,
        prefilledIdNumber: args.prefilledIdNumber,
      );
    },
  );
}

class LoanDocumentUploadRouteArgs {
  const LoanDocumentUploadRouteArgs({this.key, this.prefilledIdNumber});

  final Key? key;

  final String? prefilledIdNumber;

  @override
  String toString() {
    return 'LoanDocumentUploadRouteArgs{key: $key, prefilledIdNumber: $prefilledIdNumber}';
  }
}

/// generated route for
/// [LoanEligibilityScreen]
class LoanEligibilityRoute extends PageRouteInfo<LoanEligibilityRouteArgs> {
  LoanEligibilityRoute({
    Key? key,
    Map<String, dynamic>? financialDetails,
    List<PageRouteInfo>? children,
  }) : super(
         LoanEligibilityRoute.name,
         args: LoanEligibilityRouteArgs(
           key: key,
           financialDetails: financialDetails,
         ),
         initialChildren: children,
       );

  static const String name = 'LoanEligibilityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoanEligibilityRouteArgs>(
        orElse: () => const LoanEligibilityRouteArgs(),
      );
      return LoanEligibilityScreen(
        key: args.key,
        financialDetails: args.financialDetails,
      );
    },
  );
}

class LoanEligibilityRouteArgs {
  const LoanEligibilityRouteArgs({this.key, this.financialDetails});

  final Key? key;

  final Map<String, dynamic>? financialDetails;

  @override
  String toString() {
    return 'LoanEligibilityRouteArgs{key: $key, financialDetails: $financialDetails}';
  }
}

/// generated route for
/// [LoanScreen]
class LoanRoute extends PageRouteInfo<void> {
  const LoanRoute({List<PageRouteInfo>? children})
    : super(LoanRoute.name, initialChildren: children);

  static const String name = 'LoanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoanScreen();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [ManagerAuthPage]
class ManagerAuthRoute extends PageRouteInfo<void> {
  const ManagerAuthRoute({List<PageRouteInfo>? children})
    : super(ManagerAuthRoute.name, initialChildren: children);

  static const String name = 'ManagerAuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerAuthPage();
    },
  );
}

/// generated route for
/// [ManagerCreateOrderPage]
class ManagerCreateOrderRoute extends PageRouteInfo<void> {
  const ManagerCreateOrderRoute({List<PageRouteInfo>? children})
    : super(ManagerCreateOrderRoute.name, initialChildren: children);

  static const String name = 'ManagerCreateOrderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerCreateOrderPage();
    },
  );
}

/// generated route for
/// [ManagerDeliveryZonePage]
class ManagerDeliveryZoneRoute extends PageRouteInfo<void> {
  const ManagerDeliveryZoneRoute({List<PageRouteInfo>? children})
    : super(ManagerDeliveryZoneRoute.name, initialChildren: children);

  static const String name = 'ManagerDeliveryZoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerDeliveryZonePage();
    },
  );
}

/// generated route for
/// [ManagerIncomePage]
class ManagerIncomeRoute extends PageRouteInfo<void> {
  const ManagerIncomeRoute({List<PageRouteInfo>? children})
    : super(ManagerIncomeRoute.name, initialChildren: children);

  static const String name = 'ManagerIncomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerIncomePage();
    },
  );
}

/// generated route for
/// [ManagerMainPage]
class ManagerMainRoute extends PageRouteInfo<void> {
  const ManagerMainRoute({List<PageRouteInfo>? children})
    : super(ManagerMainRoute.name, initialChildren: children);

  static const String name = 'ManagerMainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerMainPage();
    },
  );
}

/// generated route for
/// [ManagerMapSearchPage]
class ManagerMapSearchRoute extends PageRouteInfo<void> {
  const ManagerMapSearchRoute({List<PageRouteInfo>? children})
    : super(ManagerMapSearchRoute.name, initialChildren: children);

  static const String name = 'ManagerMapSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerMapSearchPage();
    },
  );
}

/// generated route for
/// [ManagerNoConnectionPage]
class ManagerNoConnectionRoute extends PageRouteInfo<void> {
  const ManagerNoConnectionRoute({List<PageRouteInfo>? children})
    : super(ManagerNoConnectionRoute.name, initialChildren: children);

  static const String name = 'ManagerNoConnectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerNoConnectionPage();
    },
  );
}

/// generated route for
/// [ManagerNotificationListPage]
class ManagerNotificationListRoute extends PageRouteInfo<void> {
  const ManagerNotificationListRoute({List<PageRouteInfo>? children})
    : super(ManagerNotificationListRoute.name, initialChildren: children);

  static const String name = 'ManagerNotificationListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerNotificationListPage();
    },
  );
}

/// generated route for
/// [ManagerOrderHistoryPage]
class ManagerOrderHistoryRoute extends PageRouteInfo<void> {
  const ManagerOrderHistoryRoute({List<PageRouteInfo>? children})
    : super(ManagerOrderHistoryRoute.name, initialChildren: children);

  static const String name = 'ManagerOrderHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerOrderHistoryPage();
    },
  );
}

/// generated route for
/// [ManagerOrderPage]
class ManagerOrderRoute extends PageRouteInfo<void> {
  const ManagerOrderRoute({List<PageRouteInfo>? children})
    : super(ManagerOrderRoute.name, initialChildren: children);

  static const String name = 'ManagerOrderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ManagerOrderPage();
    },
  );
}

/// generated route for
/// [ManagerViewMapPage]
class ManagerViewMapRoute extends PageRouteInfo<ManagerViewMapRouteArgs> {
  ManagerViewMapRoute({
    required VoidCallback onChanged,
    Key? key,
    bool isShopLocation = false,
    int? shopId,
    List<PageRouteInfo>? children,
  }) : super(
         ManagerViewMapRoute.name,
         args: ManagerViewMapRouteArgs(
           onChanged: onChanged,
           key: key,
           isShopLocation: isShopLocation,
           shopId: shopId,
         ),
         initialChildren: children,
       );

  static const String name = 'ManagerViewMapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ManagerViewMapRouteArgs>();
      return ManagerViewMapPage(
        args.onChanged,
        key: args.key,
        isShopLocation: args.isShopLocation,
        shopId: args.shopId,
      );
    },
  );
}

class ManagerViewMapRouteArgs {
  const ManagerViewMapRouteArgs({
    required this.onChanged,
    this.key,
    this.isShopLocation = false,
    this.shopId,
  });

  final VoidCallback onChanged;

  final Key? key;

  final bool isShopLocation;

  final int? shopId;

  @override
  String toString() {
    return 'ManagerViewMapRouteArgs{onChanged: $onChanged, key: $key, isShopLocation: $isShopLocation, shopId: $shopId}';
  }
}

/// generated route for
/// [MapSearchPage]
class MapSearchRoute extends PageRouteInfo<void> {
  const MapSearchRoute({List<PageRouteInfo>? children})
    : super(MapSearchRoute.name, initialChildren: children);

  static const String name = 'MapSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MapSearchPage();
    },
  );
}

/// generated route for
/// [NoConnectionPage]
class NoConnectionRoute extends PageRouteInfo<void> {
  const NoConnectionRoute({List<PageRouteInfo>? children})
    : super(NoConnectionRoute.name, initialChildren: children);

  static const String name = 'NoConnectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NoConnectionPage();
    },
  );
}

/// generated route for
/// [NotificationListPage]
class NotificationListRoute extends PageRouteInfo<void> {
  const NotificationListRoute({List<PageRouteInfo>? children})
    : super(NotificationListRoute.name, initialChildren: children);

  static const String name = 'NotificationListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationListPage();
    },
  );
}

/// generated route for
/// [OrderPage]
class OrderRoute extends PageRouteInfo<void> {
  const OrderRoute({List<PageRouteInfo>? children})
    : super(OrderRoute.name, initialChildren: children);

  static const String name = 'OrderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrderPage();
    },
  );
}

/// generated route for
/// [OrderProgressPage]
class OrderProgressRoute extends PageRouteInfo<OrderProgressRouteArgs> {
  OrderProgressRoute({Key? key, String? orderId, List<PageRouteInfo>? children})
    : super(
        OrderProgressRoute.name,
        args: OrderProgressRouteArgs(key: key, orderId: orderId),
        initialChildren: children,
      );

  static const String name = 'OrderProgressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderProgressRouteArgs>(
        orElse: () => const OrderProgressRouteArgs(),
      );
      return OrderProgressPage(key: args.key, orderId: args.orderId);
    },
  );
}

class OrderProgressRouteArgs {
  const OrderProgressRouteArgs({this.key, this.orderId});

  final Key? key;

  final String? orderId;

  @override
  String toString() {
    return 'OrderProgressRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [OrdersListPage]
class OrdersListRoute extends PageRouteInfo<void> {
  const OrdersListRoute({List<PageRouteInfo>? children})
    : super(OrdersListRoute.name, initialChildren: children);

  static const String name = 'OrdersListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrdersListPage();
    },
  );
}

/// generated route for
/// [OrdersMainPage]
class OrdersMainRoute extends PageRouteInfo<void> {
  const OrdersMainRoute({List<PageRouteInfo>? children})
    : super(OrdersMainRoute.name, initialChildren: children);

  static const String name = 'OrdersMainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrdersMainPage();
    },
  );
}

/// generated route for
/// [ParcelListPage]
class ParcelListRoute extends PageRouteInfo<void> {
  const ParcelListRoute({List<PageRouteInfo>? children})
    : super(ParcelListRoute.name, initialChildren: children);

  static const String name = 'ParcelListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ParcelListPage();
    },
  );
}

/// generated route for
/// [ParcelPage]
class ParcelRoute extends PageRouteInfo<ParcelRouteArgs> {
  ParcelRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
         ParcelRoute.name,
         args: ParcelRouteArgs(key: key, isBackButton: isBackButton),
         initialChildren: children,
       );

  static const String name = 'ParcelRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ParcelRouteArgs>(
        orElse: () => const ParcelRouteArgs(),
      );
      return ParcelPage(key: args.key, isBackButton: args.isBackButton);
    },
  );
}

class ParcelRouteArgs {
  const ParcelRouteArgs({this.key, this.isBackButton = true});

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'ParcelRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [ParcelProgressPage]
class ParcelProgressRoute extends PageRouteInfo<ParcelProgressRouteArgs> {
  ParcelProgressRoute({
    Key? key,
    String? parcelId,
    List<PageRouteInfo>? children,
  }) : super(
         ParcelProgressRoute.name,
         args: ParcelProgressRouteArgs(key: key, parcelId: parcelId),
         initialChildren: children,
       );

  static const String name = 'ParcelProgressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ParcelProgressRouteArgs>(
        orElse: () => const ParcelProgressRouteArgs(),
      );
      return ParcelProgressPage(key: args.key, parcelId: args.parcelId);
    },
  );
}

class ParcelProgressRouteArgs {
  const ParcelProgressRouteArgs({this.key, this.parcelId});

  final Key? key;

  final String? parcelId;

  @override
  String toString() {
    return 'ParcelProgressRouteArgs{key: $key, parcelId: $parcelId}';
  }
}

/// generated route for
/// [PolicyPage]
class PolicyRoute extends PageRouteInfo<void> {
  const PolicyRoute({List<PageRouteInfo>? children})
    : super(PolicyRoute.name, initialChildren: children);

  static const String name = 'PolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PolicyPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    dynamic Function()? onCardAdded,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileRoute.name,
         args: ProfileRouteArgs(
           key: key,
           onCardAdded: onCardAdded,
           isBackButton: isBackButton,
         ),
         initialChildren: children,
       );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileRouteArgs>(
        orElse: () => const ProfileRouteArgs(),
      );
      return ProfilePage(
        key: args.key,
        onCardAdded: args.onCardAdded,
        isBackButton: args.isBackButton,
      );
    },
  );
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.onCardAdded,
    this.isBackButton = true,
  });

  final Key? key;

  final dynamic Function()? onCardAdded;

  final bool isBackButton;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, onCardAdded: $onCardAdded, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [RecommendedOnePage]
class RecommendedOneRoute extends PageRouteInfo<RecommendedOneRouteArgs> {
  RecommendedOneRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    List<PageRouteInfo>? children,
  }) : super(
         RecommendedOneRoute.name,
         args: RecommendedOneRouteArgs(
           key: key,
           isNewsOfPage: isNewsOfPage,
           isShop: isShop,
         ),
         initialChildren: children,
       );

  static const String name = 'RecommendedOneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecommendedOneRouteArgs>(
        orElse: () => const RecommendedOneRouteArgs(),
      );
      return RecommendedOnePage(
        key: args.key,
        isNewsOfPage: args.isNewsOfPage,
        isShop: args.isShop,
      );
    },
  );
}

class RecommendedOneRouteArgs {
  const RecommendedOneRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  @override
  String toString() {
    return 'RecommendedOneRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop}';
  }
}

/// generated route for
/// [RecommendedPage]
class RecommendedRoute extends PageRouteInfo<RecommendedRouteArgs> {
  RecommendedRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    List<PageRouteInfo>? children,
  }) : super(
         RecommendedRoute.name,
         args: RecommendedRouteArgs(
           key: key,
           isNewsOfPage: isNewsOfPage,
           isShop: isShop,
         ),
         initialChildren: children,
       );

  static const String name = 'RecommendedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecommendedRouteArgs>(
        orElse: () => const RecommendedRouteArgs(),
      );
      return RecommendedPage(
        key: args.key,
        isNewsOfPage: args.isNewsOfPage,
        isShop: args.isShop,
      );
    },
  );
}

class RecommendedRouteArgs {
  const RecommendedRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  @override
  String toString() {
    return 'RecommendedRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop}';
  }
}

/// generated route for
/// [RecommendedThreePage]
class RecommendedThreeRoute extends PageRouteInfo<RecommendedThreeRouteArgs> {
  RecommendedThreeRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    bool isPopular = false,
    List<PageRouteInfo>? children,
  }) : super(
         RecommendedThreeRoute.name,
         args: RecommendedThreeRouteArgs(
           key: key,
           isNewsOfPage: isNewsOfPage,
           isShop: isShop,
           isPopular: isPopular,
         ),
         initialChildren: children,
       );

  static const String name = 'RecommendedThreeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecommendedThreeRouteArgs>(
        orElse: () => const RecommendedThreeRouteArgs(),
      );
      return RecommendedThreePage(
        key: args.key,
        isNewsOfPage: args.isNewsOfPage,
        isShop: args.isShop,
        isPopular: args.isPopular,
      );
    },
  );
}

class RecommendedThreeRouteArgs {
  const RecommendedThreeRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  final bool isPopular;

  @override
  String toString() {
    return 'RecommendedThreeRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop, isPopular: $isPopular}';
  }
}

/// generated route for
/// [RecommendedTwoPage]
class RecommendedTwoRoute extends PageRouteInfo<RecommendedTwoRouteArgs> {
  RecommendedTwoRoute({
    Key? key,
    bool isNewsOfPage = false,
    bool isShop = false,
    bool isPopular = false,
    List<PageRouteInfo>? children,
  }) : super(
         RecommendedTwoRoute.name,
         args: RecommendedTwoRouteArgs(
           key: key,
           isNewsOfPage: isNewsOfPage,
           isShop: isShop,
           isPopular: isPopular,
         ),
         initialChildren: children,
       );

  static const String name = 'RecommendedTwoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecommendedTwoRouteArgs>(
        orElse: () => const RecommendedTwoRouteArgs(),
      );
      return RecommendedTwoPage(
        key: args.key,
        isNewsOfPage: args.isNewsOfPage,
        isShop: args.isShop,
        isPopular: args.isPopular,
      );
    },
  );
}

class RecommendedTwoRouteArgs {
  const RecommendedTwoRouteArgs({
    this.key,
    this.isNewsOfPage = false,
    this.isShop = false,
    this.isPopular = false,
  });

  final Key? key;

  final bool isNewsOfPage;

  final bool isShop;

  final bool isPopular;

  @override
  String toString() {
    return 'RecommendedTwoRouteArgs{key: $key, isNewsOfPage: $isNewsOfPage, isShop: $isShop, isPopular: $isPopular}';
  }
}

/// generated route for
/// [RegisterConfirmationPage]
class RegisterConfirmationRoute
    extends PageRouteInfo<RegisterConfirmationRouteArgs> {
  RegisterConfirmationRoute({
    Key? key,
    required UserModel userModel,
    bool isResetPassword = false,
    required String verificationId,
    bool editPhone = false,
    String? role,
    List<PageRouteInfo>? children,
  }) : super(
         RegisterConfirmationRoute.name,
         args: RegisterConfirmationRouteArgs(
           key: key,
           userModel: userModel,
           isResetPassword: isResetPassword,
           verificationId: verificationId,
           editPhone: editPhone,
           role: role,
         ),
         initialChildren: children,
       );

  static const String name = 'RegisterConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterConfirmationRouteArgs>();
      return RegisterConfirmationPage(
        key: args.key,
        userModel: args.userModel,
        isResetPassword: args.isResetPassword,
        verificationId: args.verificationId,
        editPhone: args.editPhone,
        role: args.role,
      );
    },
  );
}

class RegisterConfirmationRouteArgs {
  const RegisterConfirmationRouteArgs({
    this.key,
    required this.userModel,
    this.isResetPassword = false,
    required this.verificationId,
    this.editPhone = false,
    this.role,
  });

  final Key? key;

  final UserModel userModel;

  final bool isResetPassword;

  final String verificationId;

  final bool editPhone;

  final String? role;

  @override
  String toString() {
    return 'RegisterConfirmationRouteArgs{key: $key, userModel: $userModel, isResetPassword: $isResetPassword, verificationId: $verificationId, editPhone: $editPhone, role: $role}';
  }
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<RegisterRouteArgs> {
  RegisterRoute({
    Key? key,
    required bool isOnlyEmail,
    String? role,
    List<PageRouteInfo>? children,
  }) : super(
         RegisterRoute.name,
         args: RegisterRouteArgs(
           key: key,
           isOnlyEmail: isOnlyEmail,
           role: role,
         ),
         initialChildren: children,
       );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterRouteArgs>();
      return RegisterPage(
        key: args.key,
        isOnlyEmail: args.isOnlyEmail,
        role: args.role,
      );
    },
  );
}

class RegisterRouteArgs {
  const RegisterRouteArgs({this.key, required this.isOnlyEmail, this.role});

  final Key? key;

  final bool isOnlyEmail;

  final String? role;

  @override
  String toString() {
    return 'RegisterRouteArgs{key: $key, isOnlyEmail: $isOnlyEmail, role: $role}';
  }
}

/// generated route for
/// [ResetPasswordPage]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
    : super(ResetPasswordRoute.name, initialChildren: children);

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ResetPasswordPage();
    },
  );
}

/// generated route for
/// [ResultFilterPage]
class ResultFilterRoute extends PageRouteInfo<ResultFilterRouteArgs> {
  ResultFilterRoute({
    Key? key,
    required String categoryId,
    List<PageRouteInfo>? children,
  }) : super(
         ResultFilterRoute.name,
         args: ResultFilterRouteArgs(key: key, categoryId: categoryId),
         initialChildren: children,
       );

  static const String name = 'ResultFilterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResultFilterRouteArgs>();
      return ResultFilterPage(key: args.key, categoryId: args.categoryId);
    },
  );
}

class ResultFilterRouteArgs {
  const ResultFilterRouteArgs({this.key, required this.categoryId});

  final Key? key;

  final String categoryId;

  @override
  String toString() {
    return 'ResultFilterRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
         SearchRoute.name,
         args: SearchRouteArgs(key: key, isBackButton: isBackButton),
         initialChildren: children,
       );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchRouteArgs>(
        orElse: () => const SearchRouteArgs(),
      );
      return SearchPage(key: args.key, isBackButton: args.isBackButton);
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key, this.isBackButton = true});

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [SelectAddressPage]
class SelectAddressRoute extends PageRouteInfo<void> {
  const SelectAddressRoute({List<PageRouteInfo>? children})
    : super(SelectAddressRoute.name, initialChildren: children);

  static const String name = 'SelectAddressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectAddressPage();
    },
  );
}

/// generated route for
/// [SelectSectionPage]
class SelectSectionRoute extends PageRouteInfo<void> {
  const SelectSectionRoute({List<PageRouteInfo>? children})
    : super(SelectSectionRoute.name, initialChildren: children);

  static const String name = 'SelectSectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectSectionPage();
    },
  );
}

/// generated route for
/// [SelectTablePage]
class SelectTableRoute extends PageRouteInfo<SelectTableRouteArgs> {
  SelectTableRoute({
    Key? key,
    required int? sectionId,
    List<PageRouteInfo>? children,
  }) : super(
         SelectTableRoute.name,
         args: SelectTableRouteArgs(key: key, sectionId: sectionId),
         initialChildren: children,
       );

  static const String name = 'SelectTableRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelectTableRouteArgs>();
      return SelectTablePage(key: args.key, sectionId: args.sectionId);
    },
  );
}

class SelectTableRouteArgs {
  const SelectTableRouteArgs({this.key, required this.sectionId});

  final Key? key;

  final int? sectionId;

  @override
  String toString() {
    return 'SelectTableRouteArgs{key: $key, sectionId: $sectionId}';
  }
}

/// generated route for
/// [SelectUserPage]
class SelectUserRoute extends PageRouteInfo<void> {
  const SelectUserRoute({List<PageRouteInfo>? children})
    : super(SelectUserRoute.name, initialChildren: children);

  static const String name = 'SelectUserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SelectUserPage();
    },
  );
}

/// generated route for
/// [ServiceTwoCategoryPage]
class ServiceTwoCategoryRoute
    extends PageRouteInfo<ServiceTwoCategoryRouteArgs> {
  ServiceTwoCategoryRoute({
    Key? key,
    required int index,
    List<PageRouteInfo>? children,
  }) : super(
         ServiceTwoCategoryRoute.name,
         args: ServiceTwoCategoryRouteArgs(key: key, index: index),
         initialChildren: children,
       );

  static const String name = 'ServiceTwoCategoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServiceTwoCategoryRouteArgs>();
      return ServiceTwoCategoryPage(key: args.key, index: args.index);
    },
  );
}

class ServiceTwoCategoryRouteArgs {
  const ServiceTwoCategoryRouteArgs({this.key, required this.index});

  final Key? key;

  final int index;

  @override
  String toString() {
    return 'ServiceTwoCategoryRouteArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [SettingPage]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingPage();
    },
  );
}

/// generated route for
/// [ShareReferralFaqPage]
class ShareReferralFaqRoute extends PageRouteInfo<ShareReferralFaqRouteArgs> {
  ShareReferralFaqRoute({
    Key? key,
    required String terms,
    List<PageRouteInfo>? children,
  }) : super(
         ShareReferralFaqRoute.name,
         args: ShareReferralFaqRouteArgs(key: key, terms: terms),
         initialChildren: children,
       );

  static const String name = 'ShareReferralFaqRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShareReferralFaqRouteArgs>();
      return ShareReferralFaqPage(key: args.key, terms: args.terms);
    },
  );
}

class ShareReferralFaqRouteArgs {
  const ShareReferralFaqRouteArgs({this.key, required this.terms});

  final Key? key;

  final String terms;

  @override
  String toString() {
    return 'ShareReferralFaqRouteArgs{key: $key, terms: $terms}';
  }
}

/// generated route for
/// [ShareReferralPage]
class ShareReferralRoute extends PageRouteInfo<void> {
  const ShareReferralRoute({List<PageRouteInfo>? children})
    : super(ShareReferralRoute.name, initialChildren: children);

  static const String name = 'ShareReferralRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShareReferralPage();
    },
  );
}

/// generated route for
/// [ShippingAddressPage]
class ShippingAddressRoute extends PageRouteInfo<void> {
  const ShippingAddressRoute({List<PageRouteInfo>? children})
    : super(ShippingAddressRoute.name, initialChildren: children);

  static const String name = 'ShippingAddressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShippingAddressPage();
    },
  );
}

/// generated route for
/// [ShopDetailPage]
class ShopDetailRoute extends PageRouteInfo<ShopDetailRouteArgs> {
  ShopDetailRoute({
    Key? key,
    required ShopData shop,
    required String workTime,
    List<PageRouteInfo>? children,
  }) : super(
         ShopDetailRoute.name,
         args: ShopDetailRouteArgs(key: key, shop: shop, workTime: workTime),
         initialChildren: children,
       );

  static const String name = 'ShopDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShopDetailRouteArgs>();
      return ShopDetailPage(
        key: args.key,
        shop: args.shop,
        workTime: args.workTime,
      );
    },
  );
}

class ShopDetailRouteArgs {
  const ShopDetailRouteArgs({
    this.key,
    required this.shop,
    required this.workTime,
  });

  final Key? key;

  final ShopData shop;

  final String workTime;

  @override
  String toString() {
    return 'ShopDetailRouteArgs{key: $key, shop: $shop, workTime: $workTime}';
  }
}

/// generated route for
/// [ShopPage]
class ShopRoute extends PageRouteInfo<ShopRouteArgs> {
  ShopRoute({
    Key? key,
    required String shopId,
    String? productId,
    String? cartId,
    ShopData? shop,
    String? ownerId,
    List<PageRouteInfo>? children,
  }) : super(
         ShopRoute.name,
         args: ShopRouteArgs(
           key: key,
           shopId: shopId,
           productId: productId,
           cartId: cartId,
           shop: shop,
           ownerId: ownerId,
         ),
         initialChildren: children,
       );

  static const String name = 'ShopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShopRouteArgs>();
      return ShopPage(
        key: args.key,
        shopId: args.shopId,
        productId: args.productId,
        cartId: args.cartId,
        shop: args.shop,
        ownerId: args.ownerId,
      );
    },
  );
}

class ShopRouteArgs {
  const ShopRouteArgs({
    this.key,
    required this.shopId,
    this.productId,
    this.cartId,
    this.shop,
    this.ownerId,
  });

  final Key? key;

  final String shopId;

  final String? productId;

  final String? cartId;

  final ShopData? shop;

  final String? ownerId;

  @override
  String toString() {
    return 'ShopRouteArgs{key: $key, shopId: $shopId, productId: $productId, cartId: $cartId, shop: $shop, ownerId: $ownerId}';
  }
}

/// generated route for
/// [ShopsBannerPage]
class ShopsBannerRoute extends PageRouteInfo<ShopsBannerRouteArgs> {
  ShopsBannerRoute({
    Key? key,
    required int bannerId,
    required String title,
    bool isAds = false,
    List<PageRouteInfo>? children,
  }) : super(
         ShopsBannerRoute.name,
         args: ShopsBannerRouteArgs(
           key: key,
           bannerId: bannerId,
           title: title,
           isAds: isAds,
         ),
         initialChildren: children,
       );

  static const String name = 'ShopsBannerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShopsBannerRouteArgs>();
      return ShopsBannerPage(
        key: args.key,
        bannerId: args.bannerId,
        title: args.title,
        isAds: args.isAds,
      );
    },
  );
}

class ShopsBannerRouteArgs {
  const ShopsBannerRouteArgs({
    this.key,
    required this.bannerId,
    required this.title,
    this.isAds = false,
  });

  final Key? key;

  final int bannerId;

  final String title;

  final bool isAds;

  @override
  String toString() {
    return 'ShopsBannerRouteArgs{key: $key, bannerId: $bannerId, title: $title, isAds: $isAds}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [StoryListPage]
class StoryListRoute extends PageRouteInfo<StoryListRouteArgs> {
  StoryListRoute({
    Key? key,
    required int index,
    required RefreshController controller,
    List<PageRouteInfo>? children,
  }) : super(
         StoryListRoute.name,
         args: StoryListRouteArgs(
           key: key,
           index: index,
           controller: controller,
         ),
         initialChildren: children,
       );

  static const String name = 'StoryListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<StoryListRouteArgs>();
      return StoryListPage(
        key: args.key,
        index: args.index,
        controller: args.controller,
      );
    },
  );
}

class StoryListRouteArgs {
  const StoryListRouteArgs({
    this.key,
    required this.index,
    required this.controller,
  });

  final Key? key;

  final int index;

  final RefreshController controller;

  @override
  String toString() {
    return 'StoryListRouteArgs{key: $key, index: $index, controller: $controller}';
  }
}

/// generated route for
/// [SubscriptionsPage]
class SubscriptionsRoute extends PageRouteInfo<void> {
  const SubscriptionsRoute({List<PageRouteInfo>? children})
    : super(SubscriptionsRoute.name, initialChildren: children);

  static const String name = 'SubscriptionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SubscriptionsPage();
    },
  );
}

/// generated route for
/// [TermPage]
class TermRoute extends PageRouteInfo<void> {
  const TermRoute({List<PageRouteInfo>? children})
    : super(TermRoute.name, initialChildren: children);

  static const String name = 'TermRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermPage();
    },
  );
}

/// generated route for
/// [UiTypePage]
class UiTypeRoute extends PageRouteInfo<UiTypeRouteArgs> {
  UiTypeRoute({Key? key, bool isBack = false, List<PageRouteInfo>? children})
    : super(
        UiTypeRoute.name,
        args: UiTypeRouteArgs(key: key, isBack: isBack),
        initialChildren: children,
      );

  static const String name = 'UiTypeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UiTypeRouteArgs>(
        orElse: () => const UiTypeRouteArgs(),
      );
      return UiTypePage(key: args.key, isBack: args.isBack);
    },
  );
}

class UiTypeRouteArgs {
  const UiTypeRouteArgs({this.key, this.isBack = false});

  final Key? key;

  final bool isBack;

  @override
  String toString() {
    return 'UiTypeRouteArgs{key: $key, isBack: $isBack}';
  }
}

/// generated route for
/// [ViewMapPage]
class ViewMapRoute extends PageRouteInfo<ViewMapRouteArgs> {
  ViewMapRoute({
    Key? key,
    bool isParcel = false,
    bool isPop = true,
    bool isShopLocation = false,
    int? shopId,
    int? indexAddress,
    AddressNewModel? address,
    bool useSlidingPanel = false,
    VoidCallback? onChanged,
    List<PageRouteInfo>? children,
  }) : super(
         ViewMapRoute.name,
         args: ViewMapRouteArgs(
           key: key,
           isParcel: isParcel,
           isPop: isPop,
           isShopLocation: isShopLocation,
           shopId: shopId,
           indexAddress: indexAddress,
           address: address,
           useSlidingPanel: useSlidingPanel,
           onChanged: onChanged,
         ),
         initialChildren: children,
       );

  static const String name = 'ViewMapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewMapRouteArgs>(
        orElse: () => const ViewMapRouteArgs(),
      );
      return ViewMapPage(
        key: args.key,
        isParcel: args.isParcel,
        isPop: args.isPop,
        isShopLocation: args.isShopLocation,
        shopId: args.shopId,
        indexAddress: args.indexAddress,
        address: args.address,
        useSlidingPanel: args.useSlidingPanel,
        onChanged: args.onChanged,
      );
    },
  );
}

class ViewMapRouteArgs {
  const ViewMapRouteArgs({
    this.key,
    this.isParcel = false,
    this.isPop = true,
    this.isShopLocation = false,
    this.shopId,
    this.indexAddress,
    this.address,
    this.useSlidingPanel = false,
    this.onChanged,
  });

  final Key? key;

  final bool isParcel;

  final bool isPop;

  final bool isShopLocation;

  final int? shopId;

  final int? indexAddress;

  final AddressNewModel? address;

  final bool useSlidingPanel;

  final VoidCallback? onChanged;

  @override
  String toString() {
    return 'ViewMapRouteArgs{key: $key, isParcel: $isParcel, isPop: $isPop, isShopLocation: $isShopLocation, shopId: $shopId, indexAddress: $indexAddress, address: $address, useSlidingPanel: $useSlidingPanel, onChanged: $onChanged}';
  }
}

/// generated route for
/// [WalletHistoryPage]
class WalletHistoryRoute extends PageRouteInfo<WalletHistoryRouteArgs> {
  WalletHistoryRoute({
    Key? key,
    bool isBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
         WalletHistoryRoute.name,
         args: WalletHistoryRouteArgs(key: key, isBackButton: isBackButton),
         initialChildren: children,
       );

  static const String name = 'WalletHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WalletHistoryRouteArgs>(
        orElse: () => const WalletHistoryRouteArgs(),
      );
      return WalletHistoryPage(key: args.key, isBackButton: args.isBackButton);
    },
  );
}

class WalletHistoryRouteArgs {
  const WalletHistoryRouteArgs({this.key, this.isBackButton = true});

  final Key? key;

  final bool isBackButton;

  @override
  String toString() {
    return 'WalletHistoryRouteArgs{key: $key, isBackButton: $isBackButton}';
  }
}

/// generated route for
/// [WebViewPage]
class WebViewRoute extends PageRouteInfo<WebViewRouteArgs> {
  WebViewRoute({Key? key, required String url, List<PageRouteInfo>? children})
    : super(
        WebViewRoute.name,
        args: WebViewRouteArgs(key: key, url: url),
        initialChildren: children,
      );

  static const String name = 'WebViewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WebViewRouteArgs>();
      return WebViewPage(key: args.key, url: args.url);
    },
  );
}

class WebViewRouteArgs {
  const WebViewRouteArgs({this.key, required this.url});

  final Key? key;

  final String url;

  @override
  String toString() {
    return 'WebViewRouteArgs{key: $key, url: $url}';
  }
}
