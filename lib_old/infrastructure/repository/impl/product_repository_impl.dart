import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rokctapp/infrastructure/services/hive_database.dart';
import 'package:rokctapp/presentation/components/error/failure.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';
import 'package:billing_app/infrastructure/repository/product_repository.dart';
import 'package:billing_app/infrastructure/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Box<ProductModel>? _box;

  ProductRepositoryImpl({Box<ProductModel>? box}) : _box = box;

  Box<ProductModel> get _productBox => _box ?? HiveDatabase.productBox;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final box = _productBox;
      final products = box.values.toList();
      return Right(products);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductByBarcode(String barcode) async {
    try {
      final box = _productBox;
      final product = box.values.firstWhere(
        (element) => element.barcode == barcode,
        orElse: () => throw Exception('Product not found'),
      );
      return Right(product);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      final box = _productBox;
      // You can use add() or put()
      final model = ProductModel.fromEntity(product);
      await box.put(model.id, model); // Using ID as key
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      final box = _productBox;
      final model = ProductModel.fromEntity(product);
      await box.put(model.id, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      final box = _productBox;
      await box.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
