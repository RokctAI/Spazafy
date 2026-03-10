import 'package:fpdart/fpdart.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:billing_app/infrastructure/models/data/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductByBarcode(String barcode);
  Future<Either<Failure, void>> addProduct(Product product);
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}
