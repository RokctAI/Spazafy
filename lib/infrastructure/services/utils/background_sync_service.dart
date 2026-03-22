import 'package:rokctapp/domain/handlers/http_service.dart';
import 'package:rokctapp/infrastructure/models/data/profile_data.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/app_database.dart';
import 'package:rokctapp/infrastructure/services/utils/local_storage.dart';
import 'package:rokctapp/infrastructure/models/models.dart';


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
        // If request has failed too many times, move to abandoned table for manual review
        if (request.retryCount >= 5) {
          debugPrint('==> request ${request.id} abandoned after 5 retries');
          await database.abandonSyncRequest(
            request,
            error:
                request.lastError ??
                'Abandoned after 5 retries due to persistent failures',
          );
          continue;
        }

        final result = await _sendRequestWithStatus(request);
        if (result.success) {
          await database.removeSyncRequest(request.id);
        } else if (result.remove) {
          // If it's a permanent client error (4xx), move to abandoned for review if payload is important
          final errorMsg = 'Permanent Failure (4xx): ${result.error}';
          await database.abandonSyncRequest(request, error: errorMsg);

          // Notify user via LocalStorage flag
          final currentCount = LocalStorage.getSyncErrorCount();
          await LocalStorage.setSyncErrorCount(currentCount + 1);
          await LocalStorage.setLastSyncError(errorMsg);
        } else {
          // Increment retry count if it was a server/network error
          await database.incrementSyncRetry(request.id, error: result.error);
          continue;
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<SyncResult> _sendRequestWithStatus(SyncQueueEntity request) async {
    try {
      final client = httpService.client(requireAuth: true);
      final data = jsonDecode(request.payload);

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
      if (statusCode >= 200 && statusCode < 300) {
        // Special handling for auth requests to save token
        if (request.url.contains('/auth/register') ||
            request.url.contains('/auth/login') ||
            request.url.contains('auth.signup') ||
            request.url.contains('auth.create')) {
          final responseData = response.data;
          final token =
              responseData['data']?['access_token'] ?? responseData['token'];
          if (token != null) {
            await LocalStorage.setToken(token);
            LocalStorage.setIsGuest(false);
            LocalStorage.deleteOfflineUser();

            final userData =
                responseData['data']?['user'] ?? responseData['user'];
            if (userData != null) {
              await LocalStorage.setUser(ProfileData.fromJson(userData));
            }
          }
        }
        return const SyncResult(success: true);
      } else if (statusCode >= 400 && statusCode < 500) {
        return SyncResult(
          success: false,
          remove: true,
          error: 'Status: $statusCode, ${response.data}',
        );
      }
      return SyncResult(success: false, error: 'Server Error: $statusCode');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode >= 400 && statusCode < 500) {
        return SyncResult(
          success: false,
          remove: true,
          error: 'Client Error: $statusCode, ${e.message}',
        );
      }
      return SyncResult(success: false, error: 'Network Error: ${e.message}');
    } catch (e) {
      return SyncResult(success: false, error: 'Unexpected Error: $e');
    }
  }
}

class SyncResult {
  final bool success;
  final bool remove;
  final String? error;

  const SyncResult({required this.success, this.remove = false, this.error});
}
