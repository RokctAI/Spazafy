import 'package:venderfoodyman/domain/handlers/customer/api_result.dart';
import 'package:venderfoodyman/infrastructure/models/customer/data/delivery_point_data.dart';

abstract class DeliveryPointsFacade {
  Future<ApiResult<List<DeliveryPointData>>> getDeliveryPoints({
    required double latitude,
    required double longitude,
  });

  Future<ApiResult<List<DeliveryPointData>>> getAllDeliveryPoints();
}
