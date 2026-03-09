import 'package:fpdart/fpdart.dart';
import '../../../presentation/components/error/failure.dart';
import 'package:billing_app/presentation/components/usecase/usecase.dart';
import 'package:billing_app/infrastructure/models/data/shop.dart';
import 'package:billing_app/infrastructure/repository/shop_repository.dart';

class GetShopUseCase implements UseCase<Shop, NoParams> {
  final ShopRepository repository;

  GetShopUseCase(this.repository);

  @override
  Future<Either<Failure, Shop>> call(NoParams params) {
    return repository.getShop();
  }
}

class UpdateShopUseCase implements UseCase<void, Shop> {
  final ShopRepository repository;

  UpdateShopUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Shop params) {
    return repository.updateShop(params);
  }
}
