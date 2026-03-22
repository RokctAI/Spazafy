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

enum PriceFilter { byLow, byHigh }

enum ListAlignment { singleBig, vertically, horizontally }

enum ExtrasType { color, text, image }

enum DeliveryTypeEnum { delivery, pickup, pickupPoint }

enum ShippingDeliveryVisibilityType {
  cantOrder,
  onlyDelivery,
  onlyPickup,
  both,
}

enum OrderStatus { open, accepted, ready, onWay, delivered, canceled }

enum CouponType { fix, percent }

enum MessageOwner { you, partner }

enum BannerType { banner, look }

enum LookProductStockStatus { outOfStock, alreadyAdded, notAdded }

enum SignUpType { phone, email, both }

// Enums for payment methods
enum PaymentMethodType { directCard, savedCard }

enum SnackBarType { success, info, error }

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

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
