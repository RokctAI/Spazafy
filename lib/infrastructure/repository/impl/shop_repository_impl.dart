import 'package:fpdart/fpdart.dart';
import 'package:billing_app/infrastructure/services/hive_database.dart';
import 'package:billing_app/presentation/components/error/failure.dart';
import 'package:billing_app/infrastructure/models/data/shop.dart';
import 'package:billing_app/infrastructure/repository/shop_repository.dart';
import 'package:billing_app/infrastructure/models/shop_model.dart';

class ShopRepositoryImpl implements ShopRepository {
  static const String shopKey = 'shop_details';

  @override
  Future<Either<Failure, Shop>> getShop() async {
    try {
      final box = HiveDatabase.shopBox;
      final shop = box.get(shopKey);
      if (shop != null) {
        return Right(shop);
      } else {
        // Return default shop if not found
        return const Right(
          Shop(
            name: 'Dinesh Shop',
            addressLine1: 'Samrajpet, Mecheri',
            addressLine2: 'Salem - 636453',
            phoneNumber: '+917010674588',
            upiId: 'dineshsowndar@oksbi',
            footerText: 'Thank you, Visit again!!!',
          ),
        );
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateShop(Shop shop) async {
    try {
      final box = HiveDatabase.shopBox;
      final model = ShopModel.fromEntity(shop);
      await box.put(shopKey, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
