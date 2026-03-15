import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:venderfoodyman/domain/handlers/manager/http_service.dart';
import 'package:venderfoodyman/infrastructure/services/manager/app_database.dart';

class BackgroundSyncService {
  final AppDatabase database;
  final HttpService httpService;
  bool _isProcessing = false;

  BackgroundSyncService({required this.database, required this.httpService}) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet)) {
        processQueue();
      }
    });
  }

  Future<void> enqueueRequest(
    String url,
    String method,
    Map<String, dynamic> payload,
  ) async {
    final uuid = const Uuid().v4();
    final companion = SyncQueueTableCompanion.insert(
      id: Value(uuid),
      url: url,
      method: method,
      payload: jsonEncode(payload),
      createdAt: DateTime.now(),
    );

    await database.insertSyncRequest(companion);
    processQueue(); // Try to process immediately
  }

  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.mobile) &&
          !connectivityResult.contains(ConnectivityResult.wifi) &&
          !connectivityResult.contains(ConnectivityResult.ethernet)) {
        return; // No network
      }

      final pendingRequests = await database.getPendingSyncRequests();

      for (final request in pendingRequests) {
        final success = await _sendRequest(request);
        if (success) {
          await database.removeSyncRequest(request.id);
        } else {
          // If a request fails, we stop processing the rest of the queue to maintain order.
          break;
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> _sendRequest(SyncQueueEntity request) async {
    try {
      final client = httpService.client(
        requireAuth: true,
      ); // Queue needs auth generally
      final data = jsonDecode(request.payload);

      // Add idempotency key to headers to prevent duplicate processing on backend
      final options = Options(
        method: request.method,
        headers: {'X-Idempotency-Key': request.id},
      );

      final response = await client.request(
        request.url,
        data: data,
        options: options,
      );

      final statusCode = response.statusCode ?? 0;
      // 2xx indicates success. 4xx indicates client error (e.g. invalid data) which won't succeed on retry
      if ((statusCode >= 200 && statusCode < 300) ||
          (statusCode >= 400 && statusCode < 500)) {
        return true;
      }
      return false; // 5xx or other errors -> retry later
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode >= 400 && statusCode < 500) {
        // Client errors (4xx) should be removed from queue, as they will continually fail
        return true;
      }
      return false; // Network errors or 5xx -> retain in queue
    } catch (e) {
      return false;
    }
  }
}
