import 'package:flutter_test/flutter_test.dart';
import 'package:billing_app/infrastructure/models/data/cart_item.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';

void main() {
  const dummyProduct = Product(
    id: '1',
    name: 'Test Product',
    barcode: '123456789',
    price: 10.0,
  );

  group('CartItem total calculation', () {
    test('should calculate total for positive quantity and price', () {
      final item = CartItem(product: dummyProduct, quantity: 2);
      expect(item.total, 20.0);
    });

    test('should return 0 when quantity is 0', () {
      final item = CartItem(product: dummyProduct, quantity: 0);
      expect(item.total, 0.0);
    });

    test('should return 0 when price is 0', () {
      const freeProduct = Product(
        id: '2',
        name: 'Free Product',
        barcode: '000000',
        price: 0.0,
      );
      final item = CartItem(product: freeProduct, quantity: 5);
      expect(item.total, 0.0);
    });

    test('should calculate total with negative quantity (for returns)', () {
      final item = CartItem(product: dummyProduct, quantity: -1);
      expect(item.total, -10.0);
    });

    test('should correctly calculate total for fractional prices', () {
      const fractionalProduct = Product(
        id: '3',
        name: 'Fractional Product',
        barcode: '111111',
        price: 3.33,
      );
      final item = CartItem(product: fractionalProduct, quantity: 3);
      // Using closeTo for double precision
      expect(item.total, closeTo(9.99, 0.0001));
    });

    test('should handle very large quantity and price', () {
      const expensiveProduct = Product(
        id: '4',
        name: 'Expensive Product',
        barcode: '999999',
        price: 1000000.0, // 1 million
      );
      final item =
          CartItem(product: expensiveProduct, quantity: 1000); // 1 thousand
      expect(item.total, 1000000000.0); // 1 billion
    });
  });

  group('CartItem copyWith', () {
    test('should return a new object with updated quantity', () {
      final item1 = CartItem(product: dummyProduct, quantity: 1);
      final item2 = item1.copyWith(quantity: 5);

      expect(item2.quantity, 5);
      expect(item2.product, dummyProduct);
      expect(item1.quantity, 1); // original remains unchanged
    });

    test('should return a new object with updated product', () {
      final item1 = CartItem(product: dummyProduct, quantity: 2);
      const newProduct = Product(
        id: '9',
        name: 'New Product',
        barcode: '987654321',
        price: 15.0,
      );
      final item2 = item1.copyWith(product: newProduct);

      expect(item2.product, newProduct);
      expect(item2.quantity, 2);
      expect(item1.product, dummyProduct); // original remains unchanged
    });

    test('should return identical object if no params passed', () {
      final item1 = CartItem(product: dummyProduct, quantity: 1);
      final item2 = item1.copyWith();

      expect(item2, equals(item1));
    });
  });

  group('CartItem Equatable props', () {
    test('should be equal when product and quantity are the same', () {
      final item1 = CartItem(product: dummyProduct, quantity: 2);
      final item2 = CartItem(product: dummyProduct, quantity: 2);

      expect(item1, equals(item2));
    });

    test('should not be equal when quantity is different', () {
      final item1 = CartItem(product: dummyProduct, quantity: 1);
      final item2 = CartItem(product: dummyProduct, quantity: 2);

      expect(item1, isNot(equals(item2)));
    });

    test('should not be equal when product is different', () {
      final item1 = CartItem(product: dummyProduct, quantity: 1);
      const differentProduct = Product(
        id: '5',
        name: 'Different Product',
        barcode: '555555',
        price: 10.0,
      );
      final item2 = CartItem(product: differentProduct, quantity: 1);

      expect(item1, isNot(equals(item2)));
    });
  });
}
