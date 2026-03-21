import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart';


abstract class DrawRepository {
  Future<ApiResult<DrawRouting>> getRouting({
    required LatLng start,
    required LatLng end,
  });
}
