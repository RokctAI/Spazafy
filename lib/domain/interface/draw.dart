import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venderfoodyman/infrastructure/models/customer/response/draw_routing_response.dart';

import 'package:venderfoodyman/domain/handlers/customer/handlers.dart';

abstract class DrawFacade {
  Future<ApiResult<DrawRouting>> getRouting({
    required LatLng start,
    required LatLng end,
  });
}
