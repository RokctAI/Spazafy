import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:billing_app/infrastructure/repository/impl/product_repository_impl.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/models/product_model.dart';

class MockBox extends Mock implements Box<ProductModel> {}

class FakeProductModel extends Fake implements ProductModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProductModel());
  });

  group('ProductRepositoryImpl Error Paths', () {
    late ProductRepositoryImpl repository;
    late MockBox mockBox;
    late Product testProduct;

    setUp(() {
      mockBox = MockBox();
      repository = ProductRepositoryImpl(box: mockBox);
      testProduct = const Product(
        id: 'test_id',
        name: 'test_name',
        price: 10.0,
        barcode: '123456789',
        stock: 5,
      );
    });

    test('getProducts returns CacheFailure on database error', () async {
      when(() => mockBox.values).thenThrow(Exception('Database error'));

      final result = await repository.getProducts();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockBox.values).called(1);
    });

    test('getProductByBarcode returns CacheFailure on database error',
        () async {
      when(() => mockBox.values).thenThrow(Exception('Database error'));

      final result = await repository.getProductByBarcode('123456789');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockBox.values).called(1);
    });

    test('addProduct returns CacheFailure on database error', () async {
      when(() => mockBox.put(any(), any()))
          .thenThrow(Exception('Database error'));

      final result = await repository.addProduct(testProduct);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockBox.put(any(), any())).called(1);
    });

    test('updateProduct returns CacheFailure on database error', () async {
      when(() => mockBox.put(any(), any()))
          .thenThrow(Exception('Database error'));

      final result = await repository.updateProduct(testProduct);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockBox.put(any(), any())).called(1);
    });

    test('deleteProduct returns CacheFailure on database error', () async {
      when(() => mockBox.delete(any())).thenThrow(Exception('Database error'));

      final result = await repository.deleteProduct('test_id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should not return Right'),
      );
      verify(() => mockBox.delete('test_id')).called(1);
    });
  });
}
