import 'package:rokctapp/infrastructure/models/models.dart';

class DeliveriesData {
  final String? shopId;
  final List<ShopDelivery> shopDeliveries;

  DeliveriesData(this.shopId, this.shopDeliveries);
}
