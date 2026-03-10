import 'package:flutter_test/flutter_test.dart';
import 'package:billing_app/application/billing/billing_bloc.dart'; // BillingState is part of billing_bloc.dart
import 'package:billing_app/infrastructure/models/data/cart_item.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';

void main() {
  group('BillingState', () {
    test('totalAmount is 0 when cartItems is empty', () {
      const state = BillingState(cartItems: []);
      expect(state.totalAmount, 0.0);
    });

    test('totalAmount correctly sums up the totals of all cart items', () {
      const product1 = Product(
        id: '1',
        name: 'Product 1',
        barcode: '111',
        price: 10.0,
      );
      const product2 = Product(
        id: '2',
        name: 'Product 2',
        barcode: '222',
        price: 25.5,
      );

      final cartItems = [
        const CartItem(product: product1, quantity: 2), // Total: 20.0
        const CartItem(product: product2, quantity: 1), // Total: 25.5
      ];

      final state = BillingState(cartItems: cartItems);

      expect(state.totalAmount, 45.5);
    });

    test('copyWith updates properties correctly', () {
      const state = BillingState();

      final newState = state.copyWith(
        error: 'An error occurred',
        isPrinting: true,
        printSuccess: true,
      );

      expect(newState.error, 'An error occurred');
      expect(newState.isPrinting, isTrue);
      expect(newState.printSuccess, isTrue);
      expect(newState.cartItems, isEmpty);
    });

    test('copyWith clears error when clearError is true', () {
      const state = BillingState(error: 'An error occurred');

      final newState = state.copyWith(clearError: true);

      expect(newState.error, isNull);
    });

    test('supports value comparisons', () {
      const state1 = BillingState(error: 'error', isPrinting: true);
      const state2 = BillingState(error: 'error', isPrinting: true);
      const state3 = BillingState(error: 'different', isPrinting: true);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });
}
