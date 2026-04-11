import 'package:rokctapp/infrastructure/models/data/extras.dart';

enum ShopStatus { notRequested, newShop, edited, approved, rejected }

enum UploadType {
  extras,
  brands,
  categories,
  shopsLogo,
  shopsBack,
  products,
  reviews,
  users,
  deliveryCar,
}

enum ListAlignment { singleBig, vertically, horizontally }

enum PriceFilter { byLow, byHigh }

enum DeliveryTypeEnum { delivery, pickup, pickupPoint }

enum ProductStatus { published, pending, unpublished }

enum WeekDays { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

enum AiTranslationModel {
  product('Product'),
  category('Category'),
  service('Service'),
  membership('MemberShip'),
  giftCart('GiftCart'),
  formOption('FormOption'),
  shop('Shop'),
  faq('Faq');

  const AiTranslationModel(this.type);
  final String type;
}

enum SignUpType { phone, email, both }

// Enums for payment methods
enum PaymentMethodType { directCard, savedCard }

enum SnackBarType { success, info, error }

enum ShippingDeliveryVisibilityType {
  cantOrder,
  onlyDelivery,
  onlyPickup,
  both,
}

enum OrderStatus {
  open,
  newOrder,
  cooking,
  accepted,
  ready,
  onAWay,
  delivered,
  canceled,
}

enum CouponType { fix, percent }

enum MessageOwner { you, partner }

enum BannerType { banner, look }

enum LookProductStockStatus { outOfStock, alreadyAdded, notAdded }

enum ExtrasType { color, text, image }

enum Gender { male, female }

extension DayOfWeekExtension on DayOfWeek {
  String get name => toString().split('.').last;

  static DayOfWeek? fromString(String? day) {
    if (day == null) return null;
    return DayOfWeek.values.firstWhere(
      (e) => e.name == day.toLowerCase(),
      orElse: () => DayOfWeek.monday,
    );
  }
}

extension ShopStatusExtension on ShopStatus {
  String get name => toString().split('.').last;

  static ShopStatus fromString(String? status) {
    return ShopStatus.values.firstWhere(
      (e) => e.name == status?.toLowerCase(),
      orElse: () => ShopStatus.notRequested,
    );
  }
}
