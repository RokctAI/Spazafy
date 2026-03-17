import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rokctapp/app_constants.dart';
import 'package:rokctapp/application/poidata/poi_data_provider.dart';
import 'package:rokctapp/infrastructure/models/data/poi_data.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';

class AppInitializer extends StatefulWidget {
  final ProviderContainer providerContainer;

  const AppInitializer({super.key, required this.providerContainer});

  Future<void> initializeApp() async {
    await _loadCachedPOIData(providerContainer);
    await _fetchPOIDataStatic(providerContainer);
    await _checkAppStatusFromAPIStatic();
  }

  Future<void> fetchPOIData() async {
    await _fetchPOIDataStatic(providerContainer);
  }

  Future<void> checkAppStatusFromAPI() async {
    await _checkAppStatusFromAPIStatic();
  }

  @override
  State<AppInitializer> createState() => _AppInitializerState();

  static Future<void> _fetchPOIDataStatic(
    ProviderContainer providerContainer,
  ) async {
    final String tenantSite = AppConstants.baseUrl;

    try {
      final response = await http.get(
        Uri.parse(
          '$tenantSite/api/method/paas.api.remote_config.get_remote_config?app_type=Customer',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final config = responseData['message'];

        if (config != null && config['poiData'] != null) {
          // Cache the fresh POI data locally
          await LocalStorage.setRemoteConfig({'poiData': config['poiData']});
          _applyPOIData(config['poiData'], providerContainer);
        }
      } else {
        if (kDebugMode) {
          debugPrint("Failed to fetch POI data. Status: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching POI data: $e");
      }
    }
  }

  static Future<void> _checkAppStatusFromAPIStatic() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}/public/api/v1/rest/status'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppConstants.isMaintain = data['status'] != 'OK';
      }
    } catch (e) {
      debugPrint("App status check failed (likely offline): $e");
    }
  }

  static Future<void> _loadCachedPOIData(
    ProviderContainer providerContainer,
  ) async {
    final cachedConfig = LocalStorage.getRemoteConfig();
    if (cachedConfig != null && cachedConfig['poiData'] != null) {
      _applyPOIData(cachedConfig['poiData'], providerContainer);
    }
  }

  static void _applyPOIData(
    dynamic poiDataRaw,
    ProviderContainer providerContainer,
  ) {
    try {
      List<dynamic> poiDataJson;
      if (poiDataRaw is String) {
        poiDataJson = jsonDecode(poiDataRaw);
      } else {
        poiDataJson = poiDataRaw;
      }

      List<POIData> poiDataList = [];
      for (var poiDataMap in poiDataJson) {
        poiDataList.add(
          POIData(
            name: poiDataMap['name'],
            latitude: poiDataMap['latitude'].toDouble(),
            longitude: poiDataMap['longitude'].toDouble(),
            titleColor: Color(
              int.parse(
                    poiDataMap['titleColor'].substring(2),
                    radix: 16,
                  ) +
                  0xFF000000,
            ),
            pin: poiDataMap['pin'],
          ),
        );
      }
      providerContainer
          .read(poiDataProvider.notifier)
          .updatePOIData(poiDataList);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error processing poiData: $e");
      }
    }
  }
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
