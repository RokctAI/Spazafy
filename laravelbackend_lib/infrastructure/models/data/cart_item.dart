import 'package:venderfoodyman/infrastructure/models/data/product_data.dart';

/// A cart item that wraps an existing [ProductData] with a quantity.
/// This is the only new model needed for the billing feature.
class CartItem {
  final ProductData product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  /// Total price for this line item (unit price × quantity).
  double get total {
    final unitPrice =
        product.stock?.totalPrice?.toDouble() ?? 0.0;
    return unitPrice * quantity;
  }

  /// Product display name from translation.
  String get name => product.translation?.title ?? 'Unknown';

  /// Product barcode.
  String? get barCode => product.barCode;

  /// Product image URL.
  String? get imageUrl => product.img;

  /// Unit of measurement label.
  String? get uom => product.unit?.translation?.title;

  CartItem copyWith({ProductData? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}
