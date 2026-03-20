import 'package:rokctapp/domain/handlers/driver/api_result.dart';
import 'package:rokctapp/infrastructure/models/data/parcel_order.dart';

abstract class ParcelRepositoryFacade {
  Future<ApiResult<ParcelOrder>> showParcel(String id);

  Future<ApiResult<dynamic>> setCurrentOrder(String? orderId);

  Future<ApiResult<List<ParcelOrder>>> getActiveOrders(int page);

  Future<ApiResult<List<ParcelOrder>>> getAvailableOrders(int page);

  Future<ApiResult<List<ParcelOrder>>> getHistoryOrders(
    int page, {
    DateTime? start,
    DateTime? end,
  });

  Future<ApiResult<dynamic>> updateParcel(String? parcelId, String? status);

  Future<ApiResult<void>> addReviewParcel(
    String orderId, {
    required double rating,
    required String comment,
  });

  Future<ApiResult<ParcelOrder>> setParcel(String orderId);
}
