import 'package:rokctapp/domain/handlers/api_result.dart';
import 'package:rokctapp/infrastructure/models/response/mobile_translations_response.dart';
import 'package:rokctapp/infrastructure/models/response/manager/ai_translation_response.dart';
import 'package:rokctapp/infrastructure/models/request/manager/ai_translation_request.dart';
import 'package:rokctapp/infrastructure/models/response/currencies_response.dart';
import 'package:rokctapp/infrastructure/services/constants/enums.dart';
import 'package:rokctapp/infrastructure/models/response/driver/setting_response.dart';
import 'package:rokctapp/infrastructure/models/response/gallery_upload_response.dart';
import 'package:rokctapp/infrastructure/models/response/multi_gallery_upload_response.dart';
import 'package:rokctapp/infrastructure/models/response/languages_response.dart';
import 'package:rokctapp/domain/handlers/handlers.dart';
import 'package:rokctapp/infrastructure/models/models.dart';
import 'package:rokctapp/infrastructure/services/utils/manager/services.dart'
    hide UploadType;

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
