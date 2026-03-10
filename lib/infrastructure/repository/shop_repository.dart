import 'package:fpdart/fpdart.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:billing_app/infrastructure/models/data/shop.dart';

abstract class ShopRepository {
  Future<Either<Failure, Shop>> getShop();
  Future<Either<Failure, void>> updateShop(Shop shop);
}
