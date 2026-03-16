import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/delivery_point_data.dart';

abstract class DeliveryPointsFacade {
  Future<ApiResult<List<DeliveryPointData>>> getDeliveryPoints({
    required double latitude,
    required double longitude,
  });

  Future<ApiResult<List<DeliveryPointData>>> getAllDeliveryPoints();
}
