import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:billing_app/application/billing/billing_bloc.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/models/data/cart_item.dart';
import 'package:billing_app/infrastructure/models/usecases/product_usecases.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateNiceMocks([MockSpec<GetProductByBarcodeUseCase>()])
import 'billing_bloc_test.mocks.dart';

void main() {
  provideDummy<Either<Failure, Product>>(const Right(Product(id: 'dummy', name: 'dummy', barcode: 'dummy', price: 0.0)));

  late MockGetProductByBarcodeUseCase mockGetProductByBarcodeUseCase;

  setUp(() {
    mockGetProductByBarcodeUseCase = MockGetProductByBarcodeUseCase();
  });

  group('AddProductToCartEvent', () {
    const tProduct1 = Product(id: '1', name: 'Product 1', barcode: '111', price: 10.0);
    const tProduct2 = Product(id: '2', name: 'Product 2', barcode: '222', price: 20.0);

    blocTest<BillingBloc, BillingState>(
      'initial state is correct',
      build: () => BillingBloc(getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      verify: (bloc) => expect(bloc.state, const BillingState()),
    );

    blocTest<BillingBloc, BillingState>(
      'should add new product to cart when product does not exist in cart',
      build: () => BillingBloc(getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      act: (bloc) => bloc.add(const AddProductToCartEvent(tProduct1)),
      expect: () => [
        const BillingState(
          cartItems: [CartItem(product: tProduct1, quantity: 1)],
          error: null,
        ),
      ],
    );

    blocTest<BillingBloc, BillingState>(
      'should increment quantity when product already exists in cart',
      build: () => BillingBloc(getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(
        cartItems: [CartItem(product: tProduct1, quantity: 1)],
      ),
      act: (bloc) => bloc.add(const AddProductToCartEvent(tProduct1)),
      expect: () => [
        const BillingState(
          cartItems: [CartItem(product: tProduct1, quantity: 2)],
          error: null,
        ),
      ],
    );

    blocTest<BillingBloc, BillingState>(
      'should clear error state when adding product to cart',
      build: () => BillingBloc(getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(error: 'Product not found: 999', cartItems: []),
      act: (bloc) => bloc.add(const AddProductToCartEvent(tProduct1)),
      expect: () => [
        const BillingState(
          cartItems: [CartItem(product: tProduct1, quantity: 1)],
          error: null,
        ),
      ],
    );

    blocTest<BillingBloc, BillingState>(
      'should add multiple different products to cart',
      build: () => BillingBloc(getProductByBarcodeUseCase: mockGetProductByBarcodeUseCase),
      seed: () => const BillingState(
        cartItems: [CartItem(product: tProduct1, quantity: 1)],
      ),
      act: (bloc) => bloc.add(const AddProductToCartEvent(tProduct2)),
      expect: () => [
        const BillingState(
          cartItems: [
            CartItem(product: tProduct1, quantity: 1),
            CartItem(product: tProduct2, quantity: 1),
          ],
          error: null,
        ),
      ],
    );
  });
}
