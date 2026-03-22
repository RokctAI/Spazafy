import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/infrastructure/models/models_driver.dart';
import 'package:rokctapp/infrastructure/services/utils/driver/services.dart';
import 'package:rokctapp/domain/handlers/driver/handlers.dart';

abstract class SettingsRepository {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  );

  Future<ApiResult<CurrenciesResponse>> getCurrencies();

  Future<ApiResult<SettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();
}
