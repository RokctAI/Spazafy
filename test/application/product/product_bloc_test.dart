import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:billing_app/application/product/product_bloc.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/models/usecases/product_usecases.dart';
import 'package:billing_app/presentation/components/usecase/usecase.dart';
import 'package:billing_app/presentation/components/error/failure.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}
class MockAddProductUseCase extends Mock implements AddProductUseCase {}
class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}
class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

class FakeProduct extends Fake implements Product {}
class FakeNoParams extends Fake implements NoParams {}

void main() {
  late ProductBloc productBloc;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockUpdateProductUseCase mockUpdateProductUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;

  const tProduct = Product(
    id: '1',
    name: 'Test Product',
    barcode: '123456789',
    price: 10.0,
    stock: 100,
  );

  final tProductsList = [tProduct];
  const tFailureMessage = 'Cache failure';
  const tFailure = CacheFailure(tFailureMessage);

  setUpAll(() {
    registerFallbackValue(FakeProduct());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockAddProductUseCase = MockAddProductUseCase();
    mockUpdateProductUseCase = MockUpdateProductUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();

    productBloc = ProductBloc(
      getProductsUseCase: mockGetProductsUseCase,
      addProductUseCase: mockAddProductUseCase,
      updateProductUseCase: mockUpdateProductUseCase,
      deleteProductUseCase: mockDeleteProductUseCase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  test('initial state should be ProductState()', () {
    expect(productBloc.state, const ProductState());
  });

  group('LoadProducts', () {
    blocTest<ProductBloc, ProductState>(
      'emits [loading, loaded] when GetProductsUseCase succeeds',
      build: () {
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => Right(tProductsList));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        ProductState(status: ProductStatus.loaded, products: tProductsList),
      ],
      verify: (_) {
        verify(() => mockGetProductsUseCase(any())).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [loading, error] when GetProductsUseCase fails',
      build: () {
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return productBloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.error, message: tFailureMessage),
      ],
      verify: (_) {
        verify(() => mockGetProductsUseCase(any())).called(1);
      },
    );
  });

  group('AddProduct', () {
    blocTest<ProductBloc, ProductState>(
      'emits [loading, success] and then triggers LoadProducts on success',
      build: () {
        when(() => mockAddProductUseCase(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => Right(tProductsList));
        return productBloc;
      },
      act: (bloc) => bloc.add(const AddProduct(tProduct)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.success, message: 'Product added successfully'),
        const ProductState(status: ProductStatus.loading),
        ProductState(status: ProductStatus.loaded, products: tProductsList),
      ],
      verify: (_) {
        verify(() => mockAddProductUseCase(tProduct)).called(1);
        verify(() => mockGetProductsUseCase(any())).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [loading, error] when AddProductUseCase fails',
      build: () {
        when(() => mockAddProductUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return productBloc;
      },
      act: (bloc) => bloc.add(const AddProduct(tProduct)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.error, message: tFailureMessage),
      ],
      verify: (_) {
        verify(() => mockAddProductUseCase(tProduct)).called(1);
        verifyNever(() => mockGetProductsUseCase(any()));
      },
    );
  });

  group('UpdateProduct', () {
    blocTest<ProductBloc, ProductState>(
      'emits [loading, success] and then triggers LoadProducts on success',
      build: () {
        when(() => mockUpdateProductUseCase(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => Right(tProductsList));
        return productBloc;
      },
      act: (bloc) => bloc.add(const UpdateProduct(tProduct)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.success, message: 'Product updated successfully'),
        const ProductState(status: ProductStatus.loading),
        ProductState(status: ProductStatus.loaded, products: tProductsList),
      ],
      verify: (_) {
        verify(() => mockUpdateProductUseCase(tProduct)).called(1);
        verify(() => mockGetProductsUseCase(any())).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [loading, error] when UpdateProductUseCase fails',
      build: () {
        when(() => mockUpdateProductUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return productBloc;
      },
      act: (bloc) => bloc.add(const UpdateProduct(tProduct)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.error, message: tFailureMessage),
      ],
      verify: (_) {
        verify(() => mockUpdateProductUseCase(tProduct)).called(1);
        verifyNever(() => mockGetProductsUseCase(any()));
      },
    );
  });

  group('DeleteProduct', () {
    const tId = '1';

    blocTest<ProductBloc, ProductState>(
      'emits [loading, success] and then triggers LoadProducts on success',
      build: () {
        when(() => mockDeleteProductUseCase(any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetProductsUseCase(any()))
            .thenAnswer((_) async => Right(tProductsList));
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProduct(tId)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.success, message: 'Product deleted successfully'),
        const ProductState(status: ProductStatus.loading),
        ProductState(status: ProductStatus.loaded, products: tProductsList),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUseCase(tId)).called(1);
        verify(() => mockGetProductsUseCase(any())).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [loading, error] when DeleteProductUseCase fails',
      build: () {
        when(() => mockDeleteProductUseCase(any()))
            .thenAnswer((_) async => const Left(tFailure));
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProduct(tId)),
      expect: () => [
        const ProductState(status: ProductStatus.loading),
        const ProductState(status: ProductStatus.error, message: tFailureMessage),
      ],
      verify: (_) {
        verify(() => mockDeleteProductUseCase(tId)).called(1);
        verifyNever(() => mockGetProductsUseCase(any()));
      },
    );
  });
}
