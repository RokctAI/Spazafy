import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rokctapp/domain/di/dependency_manager.dart';
import 'package:rokctapp/infrastructure/services/utils/app_database.dart';
import 'package:rokctapp/infrastructure/services/utils/background_sync_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return BackgroundSyncService(
    database: database,
    httpService: dioHttp, // From DependencyManager
  );
});
