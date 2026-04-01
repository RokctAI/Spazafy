import 'package:rokctapp/infrastructure/models/data/shop_delivery.dart';
import 'package:rokctapp/infrastructure/models/data/deliveries_data.dart';
import 'package:rokctapp/infrastructure/models/data/shop_delivery.dart';


class DeliveriesData {
  final String? shopId;
  final List<ShopDelivery> shopDeliveries;

  DeliveriesData(this.shopId, this.shopDeliveries);
}
