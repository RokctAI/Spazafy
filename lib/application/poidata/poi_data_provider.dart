import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/infrastructure/models/data/poi_data.dart';
// poi_data_provider.dart

final poiDataProvider = StateNotifierProvider<POIDataNotifier, List<POIData>>((
  ref,
) {
  return POIDataNotifier();
});

class POIDataNotifier extends StateNotifier<List<POIData>> {
  POIDataNotifier() : super([]);

  void updatePOIData(List<POIData> newData) {
    state = newData;
  }
}
