import 'package:venderfoodyman/domain/handlers/handlers.dart';
import 'package:venderfoodyman/domain/interface/settings.dart';
import 'package:venderfoodyman/infrastructure/models/models.dart';
import 'package:venderfoodyman/infrastructure/services/hive_database.dart';
import 'package:venderfoodyman/infrastructure/services/services.dart';

/// Offline-first implementation of [SettingsInterface].
/// Settings and translations stored in Hive.
class OfflineSettingsRepository implements SettingsInterface {
  @override
  Future<ApiResult<SettingsResponse>> getGlobalSettings() async {
    try {
      final allJson = HiveDatabase.getAll(HiveDatabase.settingsBox);
      final settings = allJson
          .map((json) => SettingsData.fromJson(json))
          .toList();
      return ApiResult.success(data: SettingsResponse(data: settings));
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<TranslationsResponse>> getTranslations() async {
    try {
      // Return cached translations from LocalStorage
      final translations = LocalStorage.getTranslations();
      return ApiResult.success(
        data: TranslationsResponse.fromJson({'data': translations}),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<LanguagesResponse>> getLanguages() async {
    try {
      final languages = LocalStorage.getActiveLanguages();
      return ApiResult.success(
        data: LanguagesResponse.fromJson({
          'data': languages.map((l) => l.toJson()).toList(),
        }),
      );
    } catch (e) {
      return ApiResult.failure(error: e.toString());
    }
  }

  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  ) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  ) async {
    return const ApiResult.failure(error: 'Not available offline');
  }

  @override
  Future<ApiResult<AiTranslationResponse>> getAiTranslation({
    required AiTranslationRequest model,
  }) async {
    return const ApiResult.failure(error: 'Not available offline');
  }
}
