import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:billing_app/presentation/components/usecase/usecase.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/repository/product_repository.dart';
import 'package:billing_app/infrastructure/models/usecases/product_usecases.dart';

@GenerateNiceMocks([MockSpec<ProductRepository>()])
import 'product_usecases_test.mocks.dart';

void main() {
  provideDummy<Either<Failure, List<Product>>>(const Right([]));
  // provideDummy for void is tricky, try Right<Failure, void>(null)
  provideDummy<Either<Failure, void>>(Right<Failure, void>(null));
  provideDummy<Either<Failure, Product>>(
    const Right(
      Product(id: 'dummy', name: 'dummy', barcode: 'dummy', price: 0.0),
    ),
  );

  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  group('GetProductsUseCase', () {
    late GetProductsUseCase useCase;

    setUp(() {
      useCase = GetProductsUseCase(mockRepository);
    });

    final tProductList = [
      const Product(
        id: '1',
        name: 'Test Product 1',
        barcode: '123456',
        price: 10.0,
      ),
      const Product(
        id: '2',
        name: 'Test Product 2',
        barcode: '654321',
        price: 20.0,
      ),
    ];

    test('should get list of products from the repository', () async {
      // arrange
      when(
        mockRepository.getProducts(),
      ).thenAnswer((_) async => Right(tProductList));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(tProductList));
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const failure = CacheFailure('Failed to fetch products');
      when(
        mockRepository.getProducts(),
      ).thenAnswer((_) async => const Left(failure));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, const Left(failure));
      verify(mockRepository.getProducts());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('AddProductUseCase', () {
    late AddProductUseCase useCase;

    setUp(() {
      useCase = AddProductUseCase(mockRepository);
    });

    final tProduct = const Product(
      id: '1',
      name: 'Test Product',
      barcode: '123456',
      price: 10.0,
    );

    test('should add product to the repository', () async {
      // arrange
      when(
        mockRepository.addProduct(any),
      ).thenAnswer((_) async => Right<Failure, void>(null));
      // act
      final result = await useCase(tProduct);
      // assert
      expect(result, Right<Failure, void>(null));
      verify(mockRepository.addProduct(tProduct));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when adding to repository fails', () async {
      // arrange
      const failure = CacheFailure('Failed to add product');
      when(
        mockRepository.addProduct(any),
      ).thenAnswer((_) async => const Left(failure));
      // act
      final result = await useCase(tProduct);
      // assert
      expect(result, const Left(failure));
      verify(mockRepository.addProduct(tProduct));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('UpdateProductUseCase', () {
    late UpdateProductUseCase useCase;

    setUp(() {
      useCase = UpdateProductUseCase(mockRepository);
    });

    final tProduct = const Product(
      id: '1',
      name: 'Test Product Updated',
      barcode: '123456',
      price: 15.0,
    );

    test('should update product in the repository', () async {
      // arrange
      when(
        mockRepository.updateProduct(any),
      ).thenAnswer((_) async => Right<Failure, void>(null));
      // act
      final result = await useCase(tProduct);
      // assert
      expect(result, Right<Failure, void>(null));
      verify(mockRepository.updateProduct(tProduct));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return failure when updating product in repository fails',
      () async {
        // arrange
        const failure = CacheFailure('Failed to update product');
        when(
          mockRepository.updateProduct(any),
        ).thenAnswer((_) async => const Left(failure));
        // act
        final result = await useCase(tProduct);
        // assert
        expect(result, const Left(failure));
        verify(mockRepository.updateProduct(tProduct));
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });

  group('DeleteProductUseCase', () {
    late DeleteProductUseCase useCase;

    setUp(() {
      useCase = DeleteProductUseCase(mockRepository);
    });

    const tProductId = '1';

    test('should delete product from the repository', () async {
      // arrange
      when(
        mockRepository.deleteProduct(any),
      ).thenAnswer((_) async => Right<Failure, void>(null));
      // act
      final result = await useCase(tProductId);
      // assert
      expect(result, Right<Failure, void>(null));
      verify(mockRepository.deleteProduct(tProductId));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return failure when deleting product from repository fails',
      () async {
        // arrange
        const failure = CacheFailure('Failed to delete product');
        when(
          mockRepository.deleteProduct(any),
        ).thenAnswer((_) async => const Left(failure));
        // act
        final result = await useCase(tProductId);
        // assert
        expect(result, const Left(failure));
        verify(mockRepository.deleteProduct(tProductId));
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });

  group('GetProductByBarcodeUseCase', () {
    late GetProductByBarcodeUseCase useCase;

    setUp(() {
      useCase = GetProductByBarcodeUseCase(mockRepository);
    });

    const tBarcode = '123456';
    final tProduct = const Product(
      id: '1',
      name: 'Test Product',
      barcode: '123456',
      price: 10.0,
    );

    test('should get product by barcode from the repository', () async {
      // arrange
      when(
        mockRepository.getProductByBarcode(any),
      ).thenAnswer((_) async => Right(tProduct));
      // act
      final result = await useCase(tBarcode);
      // assert
      expect(result, Right(tProduct));
      verify(mockRepository.getProductByBarcode(tBarcode));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return failure when getting product by barcode fails',
      () async {
        // arrange
        const failure = CacheFailure('Product not found');
        when(
          mockRepository.getProductByBarcode(any),
        ).thenAnswer((_) async => const Left(failure));
        // act
        final result = await useCase(tBarcode);
        // assert
        expect(result, const Left(failure));
        verify(mockRepository.getProductByBarcode(tBarcode));
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
