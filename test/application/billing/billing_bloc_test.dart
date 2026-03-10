import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:billing_app/application/billing/billing_bloc.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/models/data/cart_item.dart';
import 'package:billing_app/infrastructure/models/usecases/product_usecases.dart';

import 'billing_bloc_test.mocks.dart';

@GenerateMocks([GetProductByBarcodeUseCase])
void main() {
  late BillingBloc bloc;
  late MockGetProductByBarcodeUseCase mockGetProductByBarcodeUseCase;

  setUp(() {
    mockGetProductByBarcodeUseCase = MockGetProductByBarcodeUseCase();
    bloc = BillingBloc(
      getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('BillingBloc - RemoveProductFromCartEvent', () {
    const product1 =
        Product(id: '1', name: 'Product 1', barcode: '111', price: 10.0);
    const product2 =
        Product(id: '2', name: 'Product 2', barcode: '222', price: 20.0);
    const product3 =
        Product(id: '3', name: 'Product 3', barcode: '333', price: 30.0);

    blocTest<BillingBloc, BillingState>(
      'should remove the product from cart when it exists',
      build: () => BillingBloc(
          getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(
        cartItems: [
          CartItem(product: product1),
          CartItem(product: product2),
          CartItem(product: product3),
        ],
      ),
      act: (bloc) => bloc.add(const RemoveProductFromCartEvent('2')),
      expect: () => [
        const BillingState(
          cartItems: [
            CartItem(product: product1),
            CartItem(product: product3),
          ],
        ),
      ],
    );

    blocTest<BillingBloc, BillingState>(
      'should not emit a new state if product does not exist in the cart (or emit identical state)',
      build: () => BillingBloc(
          getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(
        cartItems: [
          CartItem(product: product1),
        ],
      ),
      act: (bloc) => bloc.add(const RemoveProductFromCartEvent('4')),
      expect: () => [], // BLoC will skip identical states by default
    );

    blocTest<BillingBloc, BillingState>(
      'should handle removing the last item from the cart',
      build: () => BillingBloc(
          getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(
        cartItems: [
          CartItem(product: product1),
        ],
      ),
      act: (bloc) => bloc.add(const RemoveProductFromCartEvent('1')),
      expect: () => [
        const BillingState(
          cartItems: [],
        ),
      ],
    );
  });
}
