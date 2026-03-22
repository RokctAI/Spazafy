import 'package:rokctapp/dummy_types.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart';

abstract class SettingsInterface {
  Future<ApiResult<GalleryUploadResponse>> uploadImage(
    String filePath,
    UploadType uploadType,
  );

  Future<ApiResult<MultiGalleryUploadResponse>> uploadMultiImage(
    List<String?> filePaths,
    UploadType uploadType,
  );

  Future<ApiResult<CurrenciesResponse>> getCurrencies();

  Future<ApiResult<SettingsResponse>> getGlobalSettings();

  Future<ApiResult<MobileTranslationsResponse>> getTranslations();

  Future<ApiResult<LanguagesResponse>> getLanguages();

  Future<ApiResult<AiTranslationResponse>> getAiTranslation({
    required AiTranslationRequest model,
  });
}
